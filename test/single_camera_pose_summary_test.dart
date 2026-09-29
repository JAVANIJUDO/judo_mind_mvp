import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:judo_mind/core/ai/analysis/single_camera_analysis_service.dart';
import 'package:judo_mind/data/ai/http_single_camera_analysis_service.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/analysis_provenance.dart';
import 'package:judo_mind/models/single_camera_pose_summary.dart';
import 'package:judo_mind/models/video_analysis_request.dart';
import 'package:judo_mind/screens/technique_detail/widgets/analyze/single_camera_pose_summary_card.dart';

void main() {
  test('parses provenance and preserves the single-camera boundary', () {
    final summary = SingleCameraPoseSummary.fromJson(_poseSummaryPayload());

    expect(summary.schemaVersion, '1.0.0');
    expect(summary.status, 'completed');
    expect(summary.video.provenance, AnalysisProvenance.measured);
    expect(summary.poseCoverage.provenance, AnalysisProvenance.modelEstimated);
    expect(summary.poseCoverage.confidenceAvailable, isFalse);
    expect(summary.hasExpectedScientificBoundary, isTrue);
  });

  test('rejects incompatible or scientifically promoted payloads', () {
    final mutations = <void Function(Map<String, dynamic>)>[
      (payload) => payload['schema_version'] = '2.0.0',
      (payload) => payload['status'] = 'partial',
      (payload) {
        (payload['video'] as Map<String, dynamic>)['provenance'] =
            'model-estimated';
      },
      (payload) {
        (payload['pose_coverage'] as Map<String, dynamic>)['provenance'] =
            'reconstructed';
      },
      (payload) {
        (payload['pose_coverage']
                as Map<String, dynamic>)['confidence_available'] =
            true;
      },
      (payload) {
        final limitations = payload['limitations'] as List<dynamic>;
        limitations.removeWhere(
          (item) =>
              (item as Map<String, dynamic>)['code'] == 'single_camera_2d_only',
        );
      },
    ];

    for (final mutate in mutations) {
      final payload =
          jsonDecode(jsonEncode(_poseSummaryPayload())) as Map<String, dynamic>;
      mutate(payload);

      expect(
        SingleCameraPoseSummary.fromJson(payload).hasExpectedScientificBoundary,
        isFalse,
      );
    }
  });

  test('HTTP service sends the bounded multipart work order', () async {
    final client = _RecordingClient(_poseSummaryPayload());
    final service = HttpSingleCameraAnalysisService(
      client: client,
      endpoint: Uri.parse('http://localhost/pose-summary'),
    );
    final tempDirectory = await Directory.systemTemp.createTemp(
      'judo-mind-pose-test-',
    );
    final video = File('${tempDirectory.path}/uchi-mata.mp4');
    await video.writeAsBytes(const [0, 1, 2, 3]);

    try {
      final summary = await service.analyzePoseSummary(
        VideoAnalysisRequest.singleCameraPoseSummary(
          techniqueId: 'uchi-mata',
          techniqueName: 'Uchi Mata',
          videoPath: video.path,
          cameraView: AnalysisCameraView.side,
          createdAt: DateTime.utc(2026, 8, 7),
        ),
      );

      final request = client.lastRequest as http.MultipartRequest;
      expect(request.fields['technique_id'], 'uchi-mata');
      expect(request.fields['camera_view'], 'side');
      expect(request.files.single.field, 'video');
      expect(summary.poseCoverage.twoPoseRate, 0.7);
    } finally {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('HTTP service diagnoses a stale or wrong endpoint', () async {
    final client = _RecordingClient(const {
      'detail': 'Not Found',
    }, statusCode: 404);
    final service = HttpSingleCameraAnalysisService(
      client: client,
      endpoint: Uri.parse('http://localhost/wrong-endpoint'),
    );
    final tempDirectory = await Directory.systemTemp.createTemp(
      'judo-mind-pose-test-',
    );
    final video = File('${tempDirectory.path}/uchi-mata.mp4');
    await video.writeAsBytes(const [0, 1, 2, 3]);

    try {
      await expectLater(
        service.analyzePoseSummary(
          VideoAnalysisRequest.singleCameraPoseSummary(
            techniqueId: 'uchi-mata',
            techniqueName: 'Uchi Mata',
            videoPath: video.path,
            cameraView: AnalysisCameraView.side,
            createdAt: DateTime.utc(2026, 8, 8),
          ),
        ),
        throwsA(
          isA<SingleCameraAnalysisException>().having(
            (error) => error.message,
            'message',
            contains('endpoint was not found (HTTP 404)'),
          ),
        ),
      );
    } finally {
      await tempDirectory.delete(recursive: true);
    }
  });

  testWidgets('renders provenance and scientific limitations', (tester) async {
    final summary = SingleCameraPoseSummary.fromJson(_poseSummaryPayload());

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SingleCameraPoseSummaryCard(summary: summary),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('single-camera-pose-summary')),
      findsOneWidget,
    );
    expect(find.text('Single-Camera Pose Summary'), findsOneWidget);
    expect(find.textContaining('Video metadata · measured'), findsOneWidget);
    expect(
      find.textContaining('Pose coverage · model-estimated'),
      findsOneWidget,
    );
    expect(
      find.textContaining('not measured or reconstructed 3D'),
      findsOneWidget,
    );
  });
}

class _RecordingClient extends http.BaseClient {
  _RecordingClient(this.payload, {this.statusCode = 200});

  final Map<String, dynamic> payload;
  final int statusCode;
  http.BaseRequest? lastRequest;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastRequest = request;
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(payload))),
      statusCode,
      headers: const {'content-type': 'application/json'},
    );
  }
}

Map<String, dynamic> _poseSummaryPayload() {
  return {
    'schema_version': '1.0.0',
    'analysis_id': 'analysis-1',
    'status': 'completed',
    'analysis_mode': 'single_camera_2d',
    'technique': {'id': 'uchi-mata'},
    'camera_view': 'side',
    'engine': {
      'id': 'mediapipe_pose_landmarker_heavy',
      'display_name': 'MediaPipe Pose Landmarker Heavy',
      'maturity': 'experimental',
      'target_fps': 10.0,
    },
    'video': {
      'filename': 'uchi-mata.mp4',
      'width': 1920,
      'height': 1080,
      'source_fps': 30.0,
      'frame_count': 90,
      'duration_seconds': 3.0,
      'provenance': 'measured',
    },
    'pose_coverage': {
      'analyzed_frame_count': 30,
      'frames_with_at_least_one_pose': 27,
      'frames_with_two_poses': 21,
      'at_least_one_pose_rate': 0.9,
      'two_pose_rate': 0.7,
      'provenance': 'model-estimated',
      'confidence_available': false,
    },
    'capabilities': {
      'athlete_identity': false,
      'phase_detection': false,
      'three_dimensional_reconstruction': false,
      'force_or_torque': false,
    },
    'limitations': [
      {
        'code': 'pose_identity_not_available',
        'message': 'Identity is not available.',
        'affects_interpretation': true,
      },
      {
        'code': 'phase_detection_not_available',
        'message': 'Phases are not available.',
        'affects_interpretation': true,
      },
      {
        'code': 'single_camera_2d_only',
        'message': 'No reconstructed 3D.',
        'affects_interpretation': true,
      },
      {
        'code': 'force_torque_not_available',
        'message': 'Force and torque are not available.',
        'affects_interpretation': true,
      },
      {
        'code': 'experimental_pose_baseline',
        'message': 'Experimental pose baseline.',
        'affects_interpretation': true,
      },
    ],
  };
}
