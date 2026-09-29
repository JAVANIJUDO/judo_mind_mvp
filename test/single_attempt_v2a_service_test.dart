import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:judo_mind/core/ai/analysis/single_attempt_v2a_service.dart';
import 'package:judo_mind/data/ai/http_single_attempt_v2a_service.dart';
import 'package:judo_mind/models/single_attempt_v2a_request.dart';

void main() {
  test(
    'sends only reviewed selections and parses a bounded V2A result',
    () async {
      final client = _RecordingClient(_resultPayload());
      final service = HttpSingleAttemptV2AService(
        client: client,
        endpoint: Uri.parse('http://localhost/v2a-video'),
      );
      final fixture = await _videoFixture();

      try {
        final result = await service.analyzeReviewedVideo(
          _request(fixture.path),
        );
        final upload = client.lastRequest as http.MultipartRequest;
        final review =
            jsonDecode(upload.fields['review_json']!) as Map<String, dynamic>;

        expect(upload.files.single.field, 'video');
        expect(review['schema_version'], '2.0.0');
        expect(review['pose_observation'], isNull);
        expect(
          (review['subject'] as Map<String, dynamic>)['confirmation_source'],
          'human-confirmed',
        );
        expect(
          (review['subject']
              as Map<String, dynamic>)['selected_detection_index'],
          0,
        );
        expect(review['attacking_leg'], {
          'side': 'right',
          'confirmation_source': 'human-confirmed',
        });
        expect(result.hasExpectedScientificBoundary, isTrue);
      } finally {
        await fixture.parent.delete(recursive: true);
      }
    },
  );

  test('rejects incomplete reviewed selections before upload', () async {
    final client = _RecordingClient(_resultPayload());
    final service = HttpSingleAttemptV2AService(
      client: client,
      endpoint: Uri.parse('http://localhost/v2a-video'),
    );
    final fixture = await _videoFixture();

    try {
      final valid = _request(fixture.path);
      final invalid = SingleAttemptV2ARequest(
        videoPath: valid.videoPath,
        videoId: valid.videoId,
        cameraView: valid.cameraView,
        attemptStart: valid.attemptEnd,
        attemptEnd: valid.attemptStart,
        eventSchemaId: valid.eventSchemaId,
        neutralTrackId: valid.neutralTrackId,
        selectedDetectionIndex: valid.selectedDetectionIndex,
        supportLeg: valid.supportLeg,
        attackingLeg: valid.attackingLeg,
        angleFrame: valid.angleFrame,
        angleEventLabel: valid.angleEventLabel,
        projectedAngleViewSuitable: valid.projectedAngleViewSuitable,
        lowRollConfirmed: valid.lowRollConfirmed,
      );

      await expectLater(
        service.analyzeReviewedVideo(invalid),
        throwsA(isA<SingleAttemptV2AException>()),
      );
      expect(client.lastRequest, isNull);
    } finally {
      await fixture.parent.delete(recursive: true);
    }
  });

  test('rejects a scientifically valid response for another review', () async {
    final fixture = await _videoFixture();

    try {
      for (final mutate in <void Function(Map<String, dynamic>)>[
        (payload) => payload['video_id'] = 'another-video',
        (payload) {
          final supportLeg = payload['support_leg'] as Map<String, dynamic>;
          supportLeg['side'] = 'right';
        },
        (payload) {
          final attackingLeg = payload['attacking_leg'] as Map<String, dynamic>;
          attackingLeg['side'] = 'left';
        },
      ]) {
        final payload =
            jsonDecode(jsonEncode(_resultPayload())) as Map<String, dynamic>;
        mutate(payload);
        final service = HttpSingleAttemptV2AService(
          client: _RecordingClient(payload),
          endpoint: Uri.parse('http://localhost/v2a-video'),
        );

        await expectLater(
          service.analyzeReviewedVideo(_request(fixture.path)),
          throwsA(
            isA<SingleAttemptV2AException>().having(
              (error) => error.message,
              'message',
              contains('does not match the reviewed request'),
            ),
          ),
        );
      }
    } finally {
      await fixture.parent.delete(recursive: true);
    }
  });

  test('reports a bounded stale-endpoint error', () async {
    final client = _RecordingClient(const {
      'detail': 'Not Found',
    }, statusCode: 404);
    final service = HttpSingleAttemptV2AService(
      client: client,
      endpoint: Uri.parse('http://localhost/stale-v2a'),
    );
    final fixture = await _videoFixture();

    try {
      await expectLater(
        service.analyzeReviewedVideo(_request(fixture.path)),
        throwsA(
          isA<SingleAttemptV2AException>().having(
            (error) => error.message,
            'message',
            contains('V2A endpoint was not found (HTTP 404)'),
          ),
        ),
      );
    } finally {
      await fixture.parent.delete(recursive: true);
    }
  });

  test('wraps a missing local video as a bounded service error', () async {
    final client = _RecordingClient(_resultPayload());
    final service = HttpSingleAttemptV2AService(
      client: client,
      endpoint: Uri.parse('http://localhost/v2a-video'),
    );

    await expectLater(
      service.analyzeReviewedVideo(_request('Z:/missing/uchi-mata.mp4')),
      throwsA(
        isA<SingleAttemptV2AException>().having(
          (error) => error.message,
          'message',
          'The selected video file could not be opened.',
        ),
      ),
    );
    expect(client.lastRequest, isNull);
  });

  test('does not expose transport internals in a connection error', () async {
    final service = HttpSingleAttemptV2AService(
      client: _ThrowingClient(),
      endpoint: Uri.parse('http://localhost/v2a-video'),
    );
    final fixture = await _videoFixture();

    try {
      await expectLater(
        service.analyzeReviewedVideo(_request(fixture.path)),
        throwsA(
          isA<SingleAttemptV2AException>()
              .having(
                (error) => error.message,
                'message',
                contains('development connection'),
              )
              .having(
                (error) => error.message,
                'message',
                isNot(contains('internal transport detail')),
              ),
        ),
      );
    } finally {
      await fixture.parent.delete(recursive: true);
    }
  });
}

SingleAttemptV2ARequest _request(String videoPath) {
  return SingleAttemptV2ARequest(
    videoPath: videoPath,
    videoId: 'authorized-video-1',
    cameraView: 'side',
    attemptStart: const ReviewedFrameReference(
      frameIndex: 25,
      timestampMs: 1000,
    ),
    attemptEnd: const ReviewedFrameReference(frameIndex: 75, timestampMs: 3000),
    eventSchemaId: 'human-single-attempt-boundaries-v1',
    neutralTrackId: 'Track A',
    selectedDetectionIndex: 0,
    supportLeg: ReviewedSupportLeg.left,
    attackingLeg: ReviewedAttackingLeg.right,
    angleFrame: const ReviewedFrameReference(frameIndex: 50, timestampMs: 2000),
    angleEventLabel: 'reviewed-angle-observation',
    projectedAngleViewSuitable: true,
    lowRollConfirmed: true,
  );
}

Future<File> _videoFixture() async {
  final directory = await Directory.systemTemp.createTemp('judo-mind-v2a-');
  final file = File('${directory.path}/uchi-mata.mp4');
  await file.writeAsBytes(const [0, 1, 2, 3]);
  return file;
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

class _ThrowingClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw Exception('internal transport detail');
  }
}

Map<String, dynamic> _resultPayload() {
  final instant = {
    'kind': 'instant',
    'frame': {'frame_index': 50, 'timestamp_ms': 2000},
    'start': null,
    'end': null,
  };
  final visibility = {
    'available': true,
    'kind': 'minimum_model_landmark_visibility',
    'value': 0.8,
    'provenance': 'model-estimated',
    'interpretation': 'Model visibility; not pose accuracy.',
  };
  final lineOverlay = [
    {
      'kind': 'line',
      'points': [
        {'x': 0.4, 'y': 0.6, 'label': null},
        {'x': 0.5, 'y': 0.3, 'label': null},
      ],
      'label': 'Projected trunk line',
      'color_layer': 'blue',
    },
    {
      'kind': 'angle_label',
      'points': [
        {'x': 0.5, 'y': 0.3, 'label': null},
      ],
      'label': '18.4 degrees projected',
      'color_layer': 'blue',
    },
  ];
  final kneeOverlay = [
    {
      'kind': 'polyline',
      'points': [
        {'x': 0.4, 'y': 0.5, 'label': 'left hip'},
        {'x': 0.4, 'y': 0.7, 'label': 'left knee'},
        {'x': 0.4, 'y': 0.9, 'label': 'left ankle'},
      ],
      'label': 'Projected left support leg',
      'color_layer': 'blue',
    },
    {
      'kind': 'angle_label',
      'points': [
        {'x': 0.4, 'y': 0.7, 'label': null},
      ],
      'label': '175.0 degrees projected',
      'color_layer': 'blue',
    },
  ];
  final attackingKneeOverlay = [
    {
      'kind': 'polyline',
      'points': [
        {'x': 0.6, 'y': 0.5, 'label': 'right hip'},
        {'x': 0.6, 'y': 0.7, 'label': 'right knee'},
        {'x': 0.6, 'y': 0.9, 'label': 'right ankle'},
      ],
      'label': 'Projected right attacking leg',
      'color_layer': 'blue',
    },
    {
      'kind': 'angle_label',
      'points': [
        {'x': 0.6, 'y': 0.7, 'label': null},
      ],
      'label': '142.0 degrees projected',
      'color_layer': 'blue',
    },
  ];
  final limitationCodes = [
    'human_role_confirmation_required',
    'human_support_leg_confirmation_required',
    'automatic_phase_detection_not_available',
    'projected_single_camera_geometry',
    'camera_perspective_affects_angles',
    'kinetics_not_available',
    'descriptive_only',
  ];

  return {
    'schema_version': '2.0.0',
    'analysis_variant': 'single_attempt_v2a',
    'analysis_id': 'analysis-v2a-service-1',
    'status': 'completed',
    'analysis_mode': 'single_camera_2d_single_attempt',
    'scientific_level': 'level_1',
    'technique': {'id': 'uchi-mata'},
    'video_id': 'authorized-video-1',
    'camera_view': 'side',
    'attempt': {
      'start': {'frame_index': 25, 'timestamp_ms': 1000},
      'end': {'frame_index': 75, 'timestamp_ms': 3000},
      'event_schema_id': 'human-single-attempt-boundaries-v1',
      'selection_source': 'human-selected',
    },
    'subject': {
      'neutral_track_id': 'Track A',
      'selected_detection_index': 0,
      'role': 'Tori',
      'confirmation_source': 'human-confirmed',
    },
    'support_leg': {'side': 'left', 'confirmation_source': 'human-confirmed'},
    'attacking_leg': {
      'side': 'right',
      'confirmation_source': 'human-confirmed',
    },
    'angle_frame': {
      'frame': {'frame_index': 50, 'timestamp_ms': 2000},
      'selection_source': 'human-selected',
      'event_label': 'reviewed-angle-observation',
    },
    'camera_suitability': {
      'projected_angle_view_suitable': true,
      'low_roll_confirmed': true,
      'review_source': 'human-reviewed',
    },
    'metrics': [
      {
        'metric_id': 'UM-TIM-001',
        'name': 'Reviewed execution duration',
        'status': 'reportable',
        'value': 2.0,
        'unit': 'seconds',
        'provenance': 'measured',
        'temporal_reference': {
          'kind': 'interval',
          'frame': null,
          'start': {'frame_index': 25, 'timestamp_ms': 1000},
          'end': {'frame_index': 75, 'timestamp_ms': 3000},
        },
        'confidence': {
          'available': false,
          'kind': null,
          'value': null,
          'provenance': null,
          'interpretation': 'Human-reviewed boundaries.',
        },
        'method_version': 'reviewed-event-elapsed-time-1.0.0',
        'limitation': 'Same event schema only.',
        'descriptive_text': 'Reviewed duration is 2.000 seconds.',
        'withheld_reason': null,
        'overlay': <dynamic>[],
      },
      {
        'metric_id': 'UM-ANG-001',
        'name': 'Projected trunk inclination',
        'status': 'reportable',
        'value': 18.4,
        'unit': 'degrees',
        'provenance': 'model-estimated',
        'temporal_reference': instant,
        'confidence': visibility,
        'method_version': 'projected-trunk-inclination-1.0.0',
        'limitation': 'Projected 2D only.',
        'descriptive_text': 'Projected trunk inclination is 18.4 degrees.',
        'withheld_reason': null,
        'overlay': lineOverlay,
      },
      {
        'metric_id': 'UM-ANG-002',
        'name': 'Projected support-leg knee angle',
        'status': 'reportable',
        'value': 175.0,
        'unit': 'degrees',
        'provenance': 'model-estimated',
        'temporal_reference': instant,
        'confidence': visibility,
        'method_version': 'projected-knee-angle-1.0.0',
        'limitation': 'Projected 2D only.',
        'descriptive_text': 'Projected knee angle is 175.0 degrees.',
        'withheld_reason': null,
        'overlay': kneeOverlay,
      },
      {
        'metric_id': 'UM-ANG-003',
        'name': 'Projected attacking-leg knee angle',
        'status': 'reportable',
        'value': 142.0,
        'unit': 'degrees',
        'provenance': 'model-estimated',
        'temporal_reference': instant,
        'confidence': visibility,
        'method_version': 'projected-knee-angle-1.0.0',
        'limitation': 'Projected 2D only.',
        'descriptive_text':
            'Projected attacking-leg knee angle is 142.0 degrees.',
        'withheld_reason': null,
        'overlay': attackingKneeOverlay,
      },
    ],
    'capabilities': {
      'human_confirmed_tori': true,
      'human_confirmed_support_leg': true,
      'automatic_tori_uke_identity': false,
      'automatic_phase_detection': false,
      'three_dimensional_reconstruction': false,
      'force_torque_power': false,
      'normative_coaching': false,
      'multi_person_evidence_status': 'insufficient',
      'multi_person_interaction_metrics_reportable': false,
    },
    'limitations': [
      for (final code in limitationCodes)
        {
          'code': code,
          'message': 'Scientific limitation.',
          'affects_interpretation': true,
        },
    ],
  };
}
