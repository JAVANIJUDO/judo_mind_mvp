import 'local_attempt_history_record.dart';
import 'single_attempt_analysis_v2a.dart';

enum ProgressEvidenceState {
  noEvidence,
  ready,
  invalidEvidence,
  incompatibleVersions,
}

/// A deterministic projection of the existing local V2A History.
///
/// This contract counts stored evidence only. It does not compare metric
/// values, infer a trend, or produce mastery, performance, readiness, ranking
/// or coaching claims.
class ProgressEvidenceSummary {
  const ProgressEvidenceSummary._({
    required this.state,
    required this.records,
    required this.recordStatusCounts,
    required this.reportableMetricCount,
    required this.reviewRequiredMetricCount,
    required this.withheldMetricCount,
    required this.techniqueIds,
    required this.metricVersions,
    this.latestSavedAtUtc,
  });

  final ProgressEvidenceState state;
  final List<LocalAttemptHistoryRecord> records;
  final Map<String, int> recordStatusCounts;
  final int reportableMetricCount;
  final int reviewRequiredMetricCount;
  final int withheldMetricCount;
  final Set<String> techniqueIds;
  final Map<String, String> metricVersions;
  final DateTime? latestSavedAtUtc;

  int get totalAttempts => records.length;
  int get completedAttemptCount => recordStatusCounts['completed'] ?? 0;
  int get totalMetricCount =>
      reportableMetricCount + reviewRequiredMetricCount + withheldMetricCount;
  bool get isReady => state == ProgressEvidenceState.ready;

  factory ProgressEvidenceSummary.fromRecords(
    List<LocalAttemptHistoryRecord> source,
  ) {
    if (source.isEmpty) {
      return const ProgressEvidenceSummary._(
        state: ProgressEvidenceState.noEvidence,
        records: [],
        recordStatusCounts: {},
        reportableMetricCount: 0,
        reviewRequiredMetricCount: 0,
        withheldMetricCount: 0,
        techniqueIds: {},
        metricVersions: {},
      );
    }

    final requiredIds = SingleAttemptAnalysisV2A.requiredMetricIds.toSet();
    final versionSets = <String, Set<String>>{};
    var structurallyRecognized = true;

    for (final record in source) {
      final ids = record.metrics.map((metric) => metric.metricId).toList();
      if (ids.length != requiredIds.length ||
          ids.toSet().length != requiredIds.length ||
          !ids.toSet().containsAll(requiredIds)) {
        structurallyRecognized = false;
        break;
      }
      for (final metric in record.metrics) {
        if (metric.methodVersion.trim().isEmpty) {
          structurallyRecognized = false;
          break;
        }
        versionSets
            .putIfAbsent(metric.metricId, () => <String>{})
            .add(metric.methodVersion);
      }
    }

    if (structurallyRecognized &&
        versionSets.values.any((versions) => versions.length > 1)) {
      return ProgressEvidenceSummary._failClosed(
        ProgressEvidenceState.incompatibleVersions,
      );
    }

    if (!structurallyRecognized ||
        source.any((record) => !record.hasExpectedBoundary)) {
      return ProgressEvidenceSummary._failClosed(
        ProgressEvidenceState.invalidEvidence,
      );
    }

    final records = List<LocalAttemptHistoryRecord>.of(source)
      ..sort((a, b) {
        final timestampOrder = b.savedAtUtc.compareTo(a.savedAtUtc);
        return timestampOrder != 0
            ? timestampOrder
            : a.analysisId.compareTo(b.analysisId);
      });
    final metrics = records.expand((record) => record.metrics).toList();
    final versions = <String, String>{
      for (final entry in versionSets.entries) entry.key: entry.value.single,
    };

    return ProgressEvidenceSummary._(
      state: ProgressEvidenceState.ready,
      records: List.unmodifiable(records),
      recordStatusCounts: Map.unmodifiable({
        for (final status
            in records.map((record) => record.resultStatus).toSet())
          status: records
              .where((record) => record.resultStatus == status)
              .length,
      }),
      reportableMetricCount: metrics
          .where(
            (metric) => metric.status == SingleAttemptMetricStatus.reportable,
          )
          .length,
      reviewRequiredMetricCount: metrics
          .where(
            (metric) =>
                metric.status == SingleAttemptMetricStatus.reviewRequired,
          )
          .length,
      withheldMetricCount: metrics
          .where(
            (metric) => metric.status == SingleAttemptMetricStatus.withheld,
          )
          .length,
      techniqueIds: Set.unmodifiable(
        records.map((record) => record.techniqueId).toSet(),
      ),
      metricVersions: Map.unmodifiable(versions),
      latestSavedAtUtc: records.first.savedAtUtc,
    );
  }

  factory ProgressEvidenceSummary._failClosed(ProgressEvidenceState state) {
    return ProgressEvidenceSummary._(
      state: state,
      records: const [],
      recordStatusCounts: const {},
      reportableMetricCount: 0,
      reviewRequiredMetricCount: 0,
      withheldMetricCount: 0,
      techniqueIds: const {},
      metricVersions: const {},
    );
  }
}
