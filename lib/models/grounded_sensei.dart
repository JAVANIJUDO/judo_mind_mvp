import 'analysis_provenance.dart';
import 'single_attempt_analysis_v2a.dart';
import 'single_attempt_v2a_request.dart';
import 'technique_model.dart';

/// Exact, human-reviewed inputs and scientific output accepted by Grounded
/// Sensei V1. This contract intentionally has no free-form prompt field.
class GroundedSenseiRequest {
  const GroundedSenseiRequest({
    required this.technique,
    required this.reviewedRequest,
    required this.reviewedResult,
    required this.locale,
  });

  static const supportedMetricIds = <String>{
    'UM-TIM-001',
    'UM-ANG-001',
    'UM-ANG-002',
    'UM-ANG-003',
  };

  final TechniqueModel technique;
  final SingleAttemptV2ARequest reviewedRequest;
  final SingleAttemptAnalysisV2A reviewedResult;
  final String locale;

  bool get hasSupportedLocale => locale == 'en' || locale == 'fa';

  Map<String, int> get metricIdCounts {
    final counts = <String, int>{};
    for (final metric in reviewedResult.metrics) {
      counts.update(metric.metricId, (count) => count + 1, ifAbsent: () => 1);
    }
    return Map.unmodifiable(counts);
  }

  bool get hasExactMetricSet {
    final counts = metricIdCounts;
    return counts.length == supportedMetricIds.length &&
        supportedMetricIds.every((id) => counts[id] == 1);
  }

  bool get hasExactReviewedBinding {
    return technique.supportsReviewedSingleAttemptV2A &&
        reviewedResult.techniqueId == 'uchi-mata' &&
        reviewedRequest.isValid &&
        reviewedResult.matchesReviewedRequest(reviewedRequest);
  }
}

class GroundedSenseiBinding {
  const GroundedSenseiBinding({
    required this.techniqueId,
    required this.analysisId,
    required this.videoId,
    required this.eventSchemaId,
    required this.neutralTrackId,
    required this.selectedDetectionIndex,
    required this.cameraView,
    required this.supportLeg,
    required this.attackingLeg,
    required this.projectedAngleViewSuitable,
    required this.lowRollConfirmed,
    required this.humanReviewed,
    required this.attemptStart,
    required this.attemptEnd,
    required this.angleFrame,
  });

  final String techniqueId;
  final String analysisId;
  final String videoId;
  final String eventSchemaId;
  final String neutralTrackId;
  final int selectedDetectionIndex;
  final String cameraView;
  final String supportLeg;
  final String attackingLeg;
  final bool projectedAngleViewSuitable;
  final bool lowRollConfirmed;
  final bool humanReviewed;
  final ReviewedFrameReference attemptStart;
  final ReviewedFrameReference attemptEnd;
  final ReviewedFrameReference angleFrame;
}

enum GroundedSenseiNextActionStatus { unavailableNoApprovedDrillMapping }

/// A deterministic semantic view of one already-validated V2A metric. Values,
/// statuses, confidence availability, provenance and method versions are
/// preserved; the Sensei does not recalculate or reclassify them.
class GroundedSenseiFinding {
  const GroundedSenseiFinding({
    required this.metricId,
    required this.status,
    required this.value,
    required this.unit,
    required this.provenance,
    required this.methodVersion,
    required this.confidenceAvailable,
    required this.overlayAvailable,
    required this.nextActionStatus,
  });

  final String metricId;
  final SingleAttemptMetricStatus status;
  final double? value;
  final String unit;
  final AnalysisProvenance provenance;
  final String methodVersion;
  final bool confidenceAvailable;
  final bool overlayAvailable;
  final GroundedSenseiNextActionStatus nextActionStatus;
}

/// Evaluation-safe local explanation output. Text is resolved by the Flutter
/// localization layer from these bounded semantic fields.
class GroundedSenseiExplanation {
  const GroundedSenseiExplanation({
    required this.implementationVersion,
    required this.sourceSchemaVersion,
    required this.locale,
    required this.binding,
    required this.findings,
    required this.safetyGuidance,
    required this.limitationCodes,
    required this.multiPersonEvidenceStatus,
    required this.multiPersonInteractionMetricsReportable,
  });

  static const currentImplementationVersion = 'grounded-sensei-local-1.0.0';

  final String implementationVersion;
  final String sourceSchemaVersion;
  final String locale;
  final GroundedSenseiBinding binding;
  final List<GroundedSenseiFinding> findings;
  final List<String> safetyGuidance;
  final List<String> limitationCodes;
  final String multiPersonEvidenceStatus;
  final bool multiPersonInteractionMetricsReportable;

  bool get isDeterministicLocal =>
      implementationVersion == currentImplementationVersion;

  bool get hasApprovedDrillMapping => false;

  bool get hasExactFindingSet {
    final ids = findings.map((finding) => finding.metricId).toList();
    return ids.length == GroundedSenseiRequest.supportedMetricIds.length &&
        ids.toSet().containsAll(GroundedSenseiRequest.supportedMetricIds);
  }
}
