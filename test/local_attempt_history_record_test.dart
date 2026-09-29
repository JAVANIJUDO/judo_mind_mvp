import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/models/analysis_provenance.dart';
import 'package:judo_mind/models/local_attempt_history_record.dart';
import 'package:judo_mind/models/single_attempt_analysis_v2a.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  final savedAt = DateTime.utc(2026, 8, 12, 3, 15);

  test('converts a valid V2A result without scientific promotion', () {
    final record = LocalAttemptHistoryRecord.fromAnalysis(
      validSingleAttemptV2AResult(),
      savedAtUtc: savedAt,
    );

    expect(record.hasExpectedBoundary, isTrue);
    expect(record.recordSchemaVersion, '1.0.0');
    expect(record.analysisId, 'analysis-v2a-history-fixture');
    expect(
      record.metrics.map((metric) => metric.metricId).toSet(),
      SingleAttemptAnalysisV2A.requiredMetricIds,
    );
    expect(
      record.metrics
          .singleWhere((metric) => metric.metricId == 'UM-ANG-001')
          .status,
      SingleAttemptMetricStatus.reviewRequired,
    );
    expect(record.metrics.first.provenance, AnalysisProvenance.measured);
    expect(
      record.metrics
          .skip(1)
          .every(
            (metric) => metric.provenance == AnalysisProvenance.modelEstimated,
          ),
      isTrue,
    );
    expect(record.capabilities.multiPersonEvidenceStatus, 'insufficient');
    expect(record.reviewBinding.singleAttemptConfirmed, isTrue);
    expect(record.reviewBinding.attemptScope, 'SINGLE_ATTEMPT');
    expect(record.reviewBinding.attemptScopeSource, 'HUMAN_CONFIRMED');
    expect(
      record.capabilities.multiPersonInteractionMetricsReportable,
      isFalse,
    );
  });

  test('round-trips strict versioned JSON and preserves limitations', () {
    final original = LocalAttemptHistoryRecord.fromAnalysis(
      validSingleAttemptV2AResult(),
      savedAtUtc: savedAt,
    );
    final decoded = LocalAttemptHistoryRecord.fromJson(
      jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
    );

    expect(decoded.hasExpectedBoundary, isTrue);
    expect(decoded.savedAtUtc, savedAt);
    expect(
      decoded.metrics.map((metric) => metric.status),
      original.metrics.map((metric) => metric.status),
    );
    expect(
      decoded.limitations.map((limitation) => limitation.code).toSet(),
      original.limitations.map((limitation) => limitation.code).toSet(),
    );
    expect(
      decoded.metrics
          .singleWhere((metric) => metric.metricId == 'UM-ANG-002')
          .withheldReason,
      isNotEmpty,
    );
  });

  test(
    'serialization excludes video, overlays, identity indices and scores',
    () {
      final encoded = jsonEncode(
        LocalAttemptHistoryRecord.fromAnalysis(
          validSingleAttemptV2AResult(videoId: 'private-video-file-name.mp4'),
          savedAtUtc: savedAt,
        ).toJson(),
      );

      for (final forbidden in [
        'private-video-file-name.mp4',
        'video_id',
        'video_path',
        'filename',
        'overlay',
        'selected_detection_index',
        'score',
        'mastery',
        'trend',
        'candidate_token',
        'review_session_id',
        'timing_manifest_id',
      ]) {
        expect(encoded, isNot(contains(forbidden)), reason: forbidden);
      }
    },
  );

  test('unsupported schema, status and provenance fail closed', () {
    final baseline = LocalAttemptHistoryRecord.fromAnalysis(
      validSingleAttemptV2AResult(),
      savedAtUtc: savedAt,
    ).toJson();
    final mutations = <void Function(Map<String, dynamic>)>[
      (json) => json['record_schema_version'] = '2.0.0',
      (json) {
        final metrics = json['metrics'] as List<dynamic>;
        (metrics.first as Map<String, dynamic>)['status'] = 'excellent';
      },
      (json) {
        final metrics = json['metrics'] as List<dynamic>;
        (metrics.first as Map<String, dynamic>)['provenance'] = 'direct';
      },
      (json) {
        final metrics = json['metrics'] as List<dynamic>;
        (metrics[1] as Map<String, dynamic>)['value'] = 181.0;
      },
      (json) {
        final metrics = json['metrics'] as List<dynamic>;
        final temporal =
            (metrics[1] as Map<String, dynamic>)['temporal_reference']
                as Map<String, dynamic>;
        temporal['frame'] = {'frame_index': 51, 'timestamp_ms': 2040};
      },
      (json) {
        final suitability =
            (json['review_binding']
                    as Map<String, dynamic>)['camera_suitability']
                as Map<String, dynamic>;
        suitability['projected_angle_view_suitable'] = false;
      },
    ];

    for (final mutate in mutations) {
      final json = jsonDecode(jsonEncode(baseline)) as Map<String, dynamic>;
      mutate(json);
      expect(
        () => LocalAttemptHistoryRecord.fromJson(json),
        throwsFormatException,
      );
    }
  });
}
