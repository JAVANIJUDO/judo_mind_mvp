import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/models/local_attempt_history_record.dart';
import 'package:judo_mind/models/progress_evidence_summary.dart';
import 'package:judo_mind/models/single_attempt_analysis_v2a.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  test('empty History produces an explicit no-evidence state', () {
    final summary = ProgressEvidenceSummary.fromRecords(const []);

    expect(summary.state, ProgressEvidenceState.noEvidence);
    expect(summary.totalAttempts, 0);
    expect(summary.totalMetricCount, 0);
  });

  test('one stored attempt produces exact evidence counts', () {
    final summary = ProgressEvidenceSummary.fromRecords([
      _record('attempt-1', DateTime.utc(2026, 8, 14, 1)),
    ]);

    expect(summary.state, ProgressEvidenceState.ready);
    expect(summary.totalAttempts, 1);
    expect(summary.completedAttemptCount, 1);
    expect(summary.reportableMetricCount, 2);
    expect(summary.reviewRequiredMetricCount, 1);
    expect(summary.withheldMetricCount, 1);
    expect(summary.totalMetricCount, 4);
    expect(summary.techniqueIds, {'uchi-mata'});
  });

  test('multiple records are counted and ordered deterministically', () {
    final older = _record('attempt-b', DateTime.utc(2026, 8, 14, 1));
    final newer = _record('attempt-a', DateTime.utc(2026, 8, 14, 2));
    final summary = ProgressEvidenceSummary.fromRecords([older, newer]);

    expect(summary.totalAttempts, 2);
    expect(summary.completedAttemptCount, 2);
    expect(summary.reportableMetricCount, 4);
    expect(summary.reviewRequiredMetricCount, 2);
    expect(summary.withheldMetricCount, 2);
    expect(summary.latestSavedAtUtc, DateTime.utc(2026, 8, 14, 2));
    expect(summary.records.map((record) => record.analysisId), [
      'attempt-a',
      'attempt-b',
    ]);
  });

  test('unknown metric identity fails closed without partial counts', () {
    final record = _record('attempt-1', DateTime.utc(2026, 8, 14));
    final malformed = _copyRecord(
      record,
      metrics: [
        _copyMetric(record.metrics.first, metricId: 'UM-UNKNOWN-999'),
        ...record.metrics.skip(1),
      ],
    );

    final summary = ProgressEvidenceSummary.fromRecords([malformed]);

    expect(summary.state, ProgressEvidenceState.invalidEvidence);
    expect(summary.totalAttempts, 0);
    expect(summary.totalMetricCount, 0);
  });

  test('unknown metric status fails closed', () {
    final record = _record('attempt-1', DateTime.utc(2026, 8, 14));
    final malformed = _copyRecord(
      record,
      metrics: [
        _copyMetric(
          record.metrics.first,
          status: SingleAttemptMetricStatus.unknown,
        ),
        ...record.metrics.skip(1),
      ],
    );

    expect(
      ProgressEvidenceSummary.fromRecords([malformed]).state,
      ProgressEvidenceState.invalidEvidence,
    );
  });

  test('incompatible method versions are withheld rather than compared', () {
    final first = _record('attempt-1', DateTime.utc(2026, 8, 14, 1));
    final second = _record('attempt-2', DateTime.utc(2026, 8, 14, 2));
    final incompatible = _copyRecord(
      second,
      metrics: [
        _copyMetric(
          second.metrics.first,
          methodVersion: 'different-unapproved-version',
        ),
        ...second.metrics.skip(1),
      ],
    );

    final summary = ProgressEvidenceSummary.fromRecords([first, incompatible]);

    expect(summary.state, ProgressEvidenceState.incompatibleVersions);
    expect(summary.totalAttempts, 0);
    expect(summary.metricVersions, isEmpty);
  });

  test('UM-ANG-001 remains review-required in every valid record', () {
    final records = [
      _record('attempt-1', DateTime.utc(2026, 8, 14, 1)),
      _record('attempt-2', DateTime.utc(2026, 8, 14, 2)),
    ];
    final summary = ProgressEvidenceSummary.fromRecords(records);

    expect(summary.reviewRequiredMetricCount, 2);
    for (final record in summary.records) {
      expect(
        record.metrics
            .singleWhere((metric) => metric.metricId == 'UM-ANG-001')
            .status,
        SingleAttemptMetricStatus.reviewRequired,
      );
    }
  });
}

LocalAttemptHistoryRecord _record(String analysisId, DateTime savedAtUtc) {
  return LocalAttemptHistoryRecord.fromAnalysis(
    validSingleAttemptV2AResult(analysisId: analysisId),
    savedAtUtc: savedAtUtc,
  );
}

LocalAttemptHistoryRecord _copyRecord(
  LocalAttemptHistoryRecord source, {
  required List<LocalAttemptMetricSummary> metrics,
}) {
  return LocalAttemptHistoryRecord(
    recordSchemaVersion: source.recordSchemaVersion,
    sourceResponseSchemaVersion: source.sourceResponseSchemaVersion,
    analysisVariant: source.analysisVariant,
    analysisId: source.analysisId,
    resultStatus: source.resultStatus,
    analysisMode: source.analysisMode,
    scientificLevel: source.scientificLevel,
    techniqueId: source.techniqueId,
    cameraView: source.cameraView,
    reviewBinding: source.reviewBinding,
    metrics: metrics,
    capabilities: source.capabilities,
    limitations: source.limitations,
    savedAtUtc: source.savedAtUtc,
  );
}

LocalAttemptMetricSummary _copyMetric(
  LocalAttemptMetricSummary source, {
  String? metricId,
  SingleAttemptMetricStatus? status,
  String? methodVersion,
}) {
  return LocalAttemptMetricSummary(
    metricId: metricId ?? source.metricId,
    name: source.name,
    status: status ?? source.status,
    value: source.value,
    unit: source.unit,
    provenance: source.provenance,
    temporalReference: source.temporalReference,
    confidence: source.confidence,
    methodVersion: methodVersion ?? source.methodVersion,
    limitation: source.limitation,
    descriptiveText: source.descriptiveText,
    withheldReason: source.withheldReason,
  );
}
