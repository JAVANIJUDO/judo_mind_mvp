import '../../core/ai/analysis/grounded_sensei_service.dart';
import '../../models/grounded_sensei.dart';

/// Deterministic, local-only Grounded Sensei V1.
///
/// This service accepts no arbitrary text input, performs no inference, and
/// has no network dependency. It only projects an already-validated,
/// human-reviewed V2A result into a typed explanation contract.
class LocalGroundedSenseiService implements GroundedSenseiService {
  const LocalGroundedSenseiService();

  static const _metricOrder = <String>[
    'UM-TIM-001',
    'UM-ANG-001',
    'UM-ANG-002',
    'UM-ANG-003',
  ];

  @override
  Future<GroundedSenseiExplanation> explain(
    GroundedSenseiRequest request,
  ) async {
    _validate(request);

    final metricsById = {
      for (final metric in request.reviewedResult.metrics)
        metric.metricId: metric,
    };
    final findings = _metricOrder
        .map((id) {
          final metric = metricsById[id]!;
          return GroundedSenseiFinding(
            metricId: metric.metricId,
            status: metric.status,
            value: metric.value,
            unit: metric.unit,
            provenance: metric.provenance,
            methodVersion: metric.methodVersion,
            confidenceAvailable: metric.confidence.available,
            overlayAvailable: metric.overlay.isNotEmpty,
            nextActionStatus: GroundedSenseiNextActionStatus
                .unavailableNoApprovedDrillMapping,
          );
        })
        .toList(growable: false);

    return GroundedSenseiExplanation(
      implementationVersion:
          GroundedSenseiExplanation.currentImplementationVersion,
      sourceSchemaVersion: request.reviewedResult.schemaVersion,
      locale: request.locale,
      binding: GroundedSenseiBinding(
        techniqueId: request.technique.id,
        analysisId: request.reviewedResult.analysisId,
        videoId: request.reviewedResult.videoId,
        eventSchemaId: request.reviewedRequest.eventSchemaId,
        neutralTrackId: request.reviewedRequest.neutralTrackId,
        selectedDetectionIndex: request.reviewedRequest.selectedDetectionIndex,
        cameraView: request.reviewedRequest.cameraView,
        supportLeg: request.reviewedRequest.supportLeg.name,
        attackingLeg: request.reviewedRequest.attackingLeg.name,
        projectedAngleViewSuitable:
            request.reviewedRequest.projectedAngleViewSuitable,
        lowRollConfirmed: request.reviewedRequest.lowRollConfirmed,
        humanReviewed: true,
        attemptStart: request.reviewedRequest.attemptStart,
        attemptEnd: request.reviewedRequest.attemptEnd,
        angleFrame: request.reviewedRequest.angleFrame,
      ),
      findings: List.unmodifiable(findings),
      safetyGuidance: List.unmodifiable(_selectedLanguageSafety(request)),
      limitationCodes: List.unmodifiable(
        request.reviewedResult.limitations
            .where((limitation) => limitation.affectsInterpretation)
            .map((limitation) => limitation.code),
      ),
      multiPersonEvidenceStatus:
          request.reviewedResult.capabilities.multiPersonEvidenceStatus,
      multiPersonInteractionMetricsReportable: request
          .reviewedResult
          .capabilities
          .multiPersonInteractionMetricsReportable,
    );
  }

  void _validate(GroundedSenseiRequest request) {
    if (!request.hasSupportedLocale) {
      throw const GroundedSenseiException('unsupported_locale');
    }
    if (!request.reviewedRequest.isValid) {
      throw const GroundedSenseiException('invalid_reviewed_request');
    }
    if (!request.reviewedRequest.singleAttemptConfirmed ||
        request.reviewedRequest.attemptScope != 'SINGLE_ATTEMPT' ||
        request.reviewedRequest.attemptScopeSource != 'HUMAN_CONFIRMED') {
      throw const GroundedSenseiException('single_attempt_scope_unconfirmed');
    }
    if (!request.technique.supportsReviewedSingleAttemptV2A ||
        request.reviewedResult.techniqueId != 'uchi-mata') {
      throw const GroundedSenseiException('technique_binding_mismatch');
    }

    final counts = request.metricIdCounts;
    if (counts.keys.any(
      (id) => !GroundedSenseiRequest.supportedMetricIds.contains(id),
    )) {
      throw const GroundedSenseiException('unknown_metric');
    }
    if (counts.values.any((count) => count != 1)) {
      throw const GroundedSenseiException('duplicate_metric');
    }
    if (!request.hasExactMetricSet) {
      throw const GroundedSenseiException('missing_metric');
    }
    if (!request.reviewedResult.hasExpectedScientificBoundary) {
      throw const GroundedSenseiException('scientific_boundary_rejected');
    }
    if (!request.hasExactReviewedBinding) {
      throw const GroundedSenseiException('reviewed_binding_mismatch');
    }
    if (request.reviewedResult.capabilities.multiPersonEvidenceStatus !=
            'insufficient' ||
        request
            .reviewedResult
            .capabilities
            .multiPersonInteractionMetricsReportable) {
      throw const GroundedSenseiException('multi_person_boundary_rejected');
    }
  }

  List<String> _selectedLanguageSafety(GroundedSenseiRequest request) {
    if (request.locale == 'en') {
      return request.technique.safetyTips
          .where((item) => item.trim().isNotEmpty)
          .toList(growable: false);
    }
    return request.technique
            .getTranslation(request.locale)
            ?.safetyTips
            .where((item) => item.trim().isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
  }
}
