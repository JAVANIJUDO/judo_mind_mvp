import 'analysis_provenance.dart';
import 'single_attempt_v2a_request.dart';

enum SingleAttemptMetricStatus {
  reportable('reportable'),
  reviewRequired('review_required'),
  withheld('withheld'),
  unknown('unknown');

  const SingleAttemptMetricStatus(this.apiValue);

  final String apiValue;

  static SingleAttemptMetricStatus fromApiValue(Object? value) {
    return values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => SingleAttemptMetricStatus.unknown,
    );
  }
}

class SingleAttemptAnalysisV2A {
  const SingleAttemptAnalysisV2A({
    required this.schemaVersion,
    required this.analysisVariant,
    required this.analysisId,
    required this.status,
    required this.analysisMode,
    required this.scientificLevel,
    required this.techniqueId,
    required this.videoId,
    required this.cameraView,
    required this.attempt,
    required this.subject,
    required this.supportLeg,
    required this.attackingLeg,
    required this.angleFrame,
    required this.cameraSuitability,
    required this.metrics,
    required this.capabilities,
    required this.limitations,
  });

  final String schemaVersion;
  final String analysisVariant;
  final String analysisId;
  final String status;
  final String analysisMode;
  final String scientificLevel;
  final String techniqueId;
  final String videoId;
  final String cameraView;
  final AttemptBoundarySummary attempt;
  final HumanSubjectSelectionSummary subject;
  final HumanSupportLegSelectionSummary supportLeg;
  final HumanAttackingLegSelectionSummary? attackingLeg;
  final AnalysisFrameSummary angleFrame;
  final CameraSuitabilitySummary cameraSuitability;
  final List<SingleAttemptMetricResult> metrics;
  final SingleAttemptCapabilitiesSummary capabilities;
  final List<SingleAttemptLimitation> limitations;

  static const Set<String> requiredMetricIds = {
    'UM-TIM-001',
    'UM-ANG-001',
    'UM-ANG-002',
    'UM-ANG-003',
  };

  static const Set<String> requiredLimitationCodes = {
    'human_role_confirmation_required',
    'human_support_leg_confirmation_required',
    'automatic_phase_detection_not_available',
    'projected_single_camera_geometry',
    'camera_perspective_affects_angles',
    'kinetics_not_available',
    'descriptive_only',
  };

  bool get hasExpectedScientificBoundary {
    final metricIds = metrics.map((metric) => metric.metricId).toList();
    final limitationCodes = limitations
        .where((limitation) => limitation.affectsInterpretation)
        .map((limitation) => limitation.code)
        .toSet();
    final duration = metrics.where((metric) => metric.metricId == 'UM-TIM-001');
    final projectedAngles = metrics.where(
      (metric) =>
          metric.metricId == 'UM-ANG-001' ||
          metric.metricId == 'UM-ANG-002' ||
          metric.metricId == 'UM-ANG-003',
    );
    final attackingKnee = metrics.where(
      (metric) => metric.metricId == 'UM-ANG-003',
    );

    return schemaVersion == '2.0.0' &&
        analysisVariant == 'single_attempt_v2a' &&
        status == 'completed' &&
        analysisMode == 'single_camera_2d_single_attempt' &&
        scientificLevel == 'level_1' &&
        techniqueId == 'uchi-mata' &&
        {
          'side',
          'front',
          'rear',
          'forty_five_degrees',
          'unknown',
        }.contains(cameraView) &&
        subject.role == 'Tori' &&
        subject.isHumanConfirmedNeutralTrack &&
        supportLeg.isHumanConfirmed &&
        attackingKnee.length == 1 &&
        (attackingLeg?.isHumanConfirmed == true ||
            (attackingLeg == null &&
                attackingKnee.single.status ==
                    SingleAttemptMetricStatus.withheld)) &&
        attempt.isConsistent &&
        angleFrame.isHumanSelected &&
        angleFrame.frame.frameIndex >= attempt.start.frameIndex &&
        angleFrame.frame.frameIndex <= attempt.end.frameIndex &&
        angleFrame.frame.timestampMs >= attempt.start.timestampMs &&
        angleFrame.frame.timestampMs <= attempt.end.timestampMs &&
        cameraSuitability.reviewSource == 'human-reviewed' &&
        metricIds.length == requiredMetricIds.length &&
        metricIds.toSet().containsAll(requiredMetricIds) &&
        duration.length == 1 &&
        duration.single.provenance == AnalysisProvenance.measured &&
        duration.single.temporalReference.start?.matches(attempt.start) ==
            true &&
        duration.single.temporalReference.end?.matches(attempt.end) == true &&
        projectedAngles.length == 3 &&
        projectedAngles.every(
          (metric) =>
              metric.provenance == AnalysisProvenance.modelEstimated &&
              metric.temporalReference.frame?.matches(angleFrame.frame) == true,
        ) &&
        metrics.every(
          (metric) =>
              metric.hasConsistentStatusPayload && metric.hasApprovedContract,
        ) &&
        (cameraSuitability.permitsReportableAngles ||
            projectedAngles.every(
              (metric) => metric.status != SingleAttemptMetricStatus.reportable,
            )) &&
        capabilities.humanConfirmedTori &&
        capabilities.humanConfirmedSupportLeg &&
        capabilities.multiPersonEvidenceStatus == 'insufficient' &&
        !capabilities.multiPersonInteractionMetricsReportable &&
        !capabilities.automaticToriUkeIdentity &&
        !capabilities.automaticPhaseDetection &&
        !capabilities.threeDimensionalReconstruction &&
        !capabilities.forceTorquePower &&
        !capabilities.normativeCoaching &&
        limitationCodes.containsAll(requiredLimitationCodes);
  }

  bool matchesReviewedRequest(SingleAttemptV2ARequest request) {
    return videoId == request.videoId &&
        cameraView == request.cameraView &&
        attempt.start.matchesReviewed(request.attemptStart) &&
        attempt.end.matchesReviewed(request.attemptEnd) &&
        attempt.eventSchemaId == request.eventSchemaId &&
        attempt.singleAttemptConfirmed == request.singleAttemptConfirmed &&
        attempt.attemptScope == request.attemptScope &&
        attempt.attemptScopeSource == request.attemptScopeSource &&
        attempt.attemptScopeContractVersion ==
            request.attemptScopeContractVersion &&
        subject.neutralTrackId == request.neutralTrackId &&
        subject.selectedDetectionIndex == request.selectedDetectionIndex &&
        supportLeg.side == request.supportLeg.name &&
        attackingLeg?.side == request.attackingLeg.name &&
        angleFrame.frame.matchesReviewed(request.angleFrame) &&
        angleFrame.eventLabel == request.angleEventLabel &&
        cameraSuitability.projectedAngleViewSuitable ==
            request.projectedAngleViewSuitable &&
        cameraSuitability.lowRollConfirmed == request.lowRollConfirmed;
  }

  factory SingleAttemptAnalysisV2A.fromJson(Map<String, dynamic> json) {
    final metricsJson = _list(json, 'metrics');
    final limitationsJson = _list(json, 'limitations');
    final attackingLegJson = _optionalMap(json, 'attacking_leg');

    return SingleAttemptAnalysisV2A(
      schemaVersion: _string(json, 'schema_version'),
      analysisVariant: _string(json, 'analysis_variant'),
      analysisId: _string(json, 'analysis_id'),
      status: _string(json, 'status'),
      analysisMode: _string(json, 'analysis_mode'),
      scientificLevel: _string(json, 'scientific_level'),
      techniqueId: _string(_map(json, 'technique'), 'id'),
      videoId: _string(json, 'video_id'),
      cameraView: _string(json, 'camera_view'),
      attempt: AttemptBoundarySummary.fromJson(_map(json, 'attempt')),
      subject: HumanSubjectSelectionSummary.fromJson(_map(json, 'subject')),
      supportLeg: HumanSupportLegSelectionSummary.fromJson(
        _map(json, 'support_leg'),
      ),
      attackingLeg: attackingLegJson == null
          ? null
          : HumanAttackingLegSelectionSummary.fromJson(attackingLegJson),
      angleFrame: AnalysisFrameSummary.fromJson(_map(json, 'angle_frame')),
      cameraSuitability: CameraSuitabilitySummary.fromJson(
        _map(json, 'camera_suitability'),
      ),
      metrics: List.unmodifiable(
        metricsJson.map(
          (item) => SingleAttemptMetricResult.fromJson(_asMap(item, 'metric')),
        ),
      ),
      capabilities: SingleAttemptCapabilitiesSummary.fromJson(
        _map(json, 'capabilities'),
      ),
      limitations: List.unmodifiable(
        limitationsJson.map(
          (item) =>
              SingleAttemptLimitation.fromJson(_asMap(item, 'limitation')),
        ),
      ),
    );
  }
}

class FrameReferenceSummary {
  const FrameReferenceSummary({
    required this.frameIndex,
    required this.timestampMs,
    this.ptsMs,
    this.timingProvenance,
    this.canonicalizationMethodVersion,
  });

  final int frameIndex;
  final int timestampMs;
  final int? ptsMs;
  final String? timingProvenance;
  final String? canonicalizationMethodVersion;

  bool matches(FrameReferenceSummary other) =>
      frameIndex == other.frameIndex && timestampMs == other.timestampMs;

  bool matchesReviewed(ReviewedFrameReference other) =>
      frameIndex == other.frameIndex && timestampMs == other.timestampMs;

  factory FrameReferenceSummary.fromJson(Map<String, dynamic> json) {
    return FrameReferenceSummary(
      frameIndex: _int(json, 'frame_index'),
      timestampMs: _int(json, 'timestamp_ms'),
      ptsMs: json['pts_ms'] as int?,
      timingProvenance: json['timing_provenance'] as String?,
      canonicalizationMethodVersion:
          json['canonicalization_method_version'] as String?,
    );
  }
}

class AttemptBoundarySummary {
  const AttemptBoundarySummary({
    required this.start,
    required this.end,
    required this.eventSchemaId,
    required this.selectionSource,
    this.boundariesHumanConfirmed = false,
    this.sourceTimingState,
    this.timingMode,
    this.timestampProvenance,
    this.physicalTimeScale,
    this.singleAttemptConfirmed = false,
    this.attemptScope,
    this.attemptScopeSource,
    this.attemptScopeContractVersion,
  });

  final FrameReferenceSummary start;
  final FrameReferenceSummary end;
  final String eventSchemaId;
  final String selectionSource;
  final bool boundariesHumanConfirmed;
  final String? sourceTimingState;
  final String? timingMode;
  final String? timestampProvenance;
  final double? physicalTimeScale;
  final bool singleAttemptConfirmed;
  final String? attemptScope;
  final String? attemptScopeSource;
  final String? attemptScopeContractVersion;

  bool get isConsistent =>
      selectionSource == 'human-selected' &&
      end.frameIndex > start.frameIndex &&
      end.timestampMs > start.timestampMs &&
      (!singleAttemptConfirmed ||
          (attemptScope == 'SINGLE_ATTEMPT' &&
              attemptScopeSource == 'HUMAN_CONFIRMED' &&
              attemptScopeContractVersion ==
                  'single-attempt-human-confirmation-1.0.0'));

  factory AttemptBoundarySummary.fromJson(Map<String, dynamic> json) {
    return AttemptBoundarySummary(
      start: FrameReferenceSummary.fromJson(_map(json, 'start')),
      end: FrameReferenceSummary.fromJson(_map(json, 'end')),
      eventSchemaId: _string(json, 'event_schema_id'),
      selectionSource: _string(json, 'selection_source'),
      boundariesHumanConfirmed:
          json['boundaries_human_confirmed'] as bool? ?? false,
      sourceTimingState: (json['source_timing'] as Map?)?['state'] as String?,
      timingMode: (json['source_timing'] as Map?)?['timing_mode'] as String?,
      timestampProvenance:
          (json['source_timing'] as Map?)?['timestamp_provenance'] as String?,
      physicalTimeScale:
          ((json['source_timing'] as Map?)?['physical_time_scale'] as num?)
              ?.toDouble(),
      singleAttemptConfirmed:
          json['single_attempt_confirmed'] as bool? ?? false,
      attemptScope: json['attempt_scope'] as String?,
      attemptScopeSource: json['attempt_scope_source'] as String?,
      attemptScopeContractVersion:
          json['attempt_scope_contract_version'] as String?,
    );
  }
}

class HumanSubjectSelectionSummary {
  const HumanSubjectSelectionSummary({
    required this.neutralTrackId,
    required this.selectedDetectionIndex,
    required this.role,
    required this.confirmationSource,
  });

  final String neutralTrackId;
  final int selectedDetectionIndex;
  final String role;
  final String confirmationSource;

  bool get isHumanConfirmedNeutralTrack =>
      confirmationSource == 'human-confirmed' &&
      RegExp(r'^Track [A-Z]+$').hasMatch(neutralTrackId) &&
      neutralTrackId != 'Track TORI' &&
      neutralTrackId != 'Track UKE';

  factory HumanSubjectSelectionSummary.fromJson(Map<String, dynamic> json) {
    return HumanSubjectSelectionSummary(
      neutralTrackId: _string(json, 'neutral_track_id'),
      selectedDetectionIndex: _int(json, 'selected_detection_index'),
      role: _string(json, 'role'),
      confirmationSource: _string(json, 'confirmation_source'),
    );
  }
}

class HumanSupportLegSelectionSummary {
  const HumanSupportLegSelectionSummary({
    required this.side,
    required this.confirmationSource,
  });

  final String side;
  final String confirmationSource;

  bool get isHumanConfirmed =>
      confirmationSource == 'human-confirmed' &&
      (side == 'left' || side == 'right');

  factory HumanSupportLegSelectionSummary.fromJson(Map<String, dynamic> json) {
    return HumanSupportLegSelectionSummary(
      side: _string(json, 'side'),
      confirmationSource: _string(json, 'confirmation_source'),
    );
  }
}

class HumanAttackingLegSelectionSummary {
  const HumanAttackingLegSelectionSummary({
    required this.side,
    required this.confirmationSource,
  });

  final String side;
  final String confirmationSource;

  bool get isHumanConfirmed =>
      confirmationSource == 'human-confirmed' &&
      (side == 'left' || side == 'right');

  factory HumanAttackingLegSelectionSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return HumanAttackingLegSelectionSummary(
      side: _string(json, 'side'),
      confirmationSource: _string(json, 'confirmation_source'),
    );
  }
}

class AnalysisFrameSummary {
  const AnalysisFrameSummary({
    required this.frame,
    required this.selectionSource,
    required this.eventLabel,
  });

  final FrameReferenceSummary frame;
  final String selectionSource;
  final String eventLabel;

  bool get isHumanSelected => selectionSource == 'human-selected';

  factory AnalysisFrameSummary.fromJson(Map<String, dynamic> json) {
    return AnalysisFrameSummary(
      frame: FrameReferenceSummary.fromJson(_map(json, 'frame')),
      selectionSource: _string(json, 'selection_source'),
      eventLabel: _string(json, 'event_label'),
    );
  }
}

class CameraSuitabilitySummary {
  const CameraSuitabilitySummary({
    required this.projectedAngleViewSuitable,
    required this.lowRollConfirmed,
    required this.reviewSource,
  });

  final bool projectedAngleViewSuitable;
  final bool lowRollConfirmed;
  final String reviewSource;

  bool get permitsReportableAngles =>
      projectedAngleViewSuitable && lowRollConfirmed;

  factory CameraSuitabilitySummary.fromJson(Map<String, dynamic> json) {
    return CameraSuitabilitySummary(
      projectedAngleViewSuitable: _bool(json, 'projected_angle_view_suitable'),
      lowRollConfirmed: _bool(json, 'low_roll_confirmed'),
      reviewSource: _string(json, 'review_source'),
    );
  }
}

class MetricTemporalReferenceSummary {
  const MetricTemporalReferenceSummary({
    required this.kind,
    this.frame,
    this.start,
    this.end,
  });

  final String kind;
  final FrameReferenceSummary? frame;
  final FrameReferenceSummary? start;
  final FrameReferenceSummary? end;

  bool get isConsistent {
    if (kind == 'instant') {
      return frame != null && start == null && end == null;
    }
    if (kind == 'interval') {
      return frame == null && start != null && end != null;
    }
    return false;
  }

  factory MetricTemporalReferenceSummary.fromJson(Map<String, dynamic> json) {
    return MetricTemporalReferenceSummary(
      kind: _string(json, 'kind'),
      frame: _optionalFrame(json, 'frame'),
      start: _optionalFrame(json, 'start'),
      end: _optionalFrame(json, 'end'),
    );
  }
}

class MetricConfidenceSummary {
  const MetricConfidenceSummary({
    required this.available,
    required this.kind,
    required this.value,
    required this.provenance,
    required this.interpretation,
  });

  final bool available;
  final String? kind;
  final double? value;
  final AnalysisProvenance? provenance;
  final String interpretation;

  bool get isConsistent {
    if (available) {
      return kind == 'minimum_model_landmark_visibility' &&
          value != null &&
          value! >= 0 &&
          value! <= 1 &&
          provenance == AnalysisProvenance.modelEstimated;
    }
    return kind == null && value == null && provenance == null;
  }

  factory MetricConfidenceSummary.fromJson(Map<String, dynamic> json) {
    final rawProvenance = json['provenance'];
    return MetricConfidenceSummary(
      available: _bool(json, 'available'),
      kind: _optionalString(json, 'kind'),
      value: _optionalDouble(json, 'value'),
      provenance: rawProvenance == null
          ? null
          : AnalysisProvenance.fromApiValue(rawProvenance),
      interpretation: _string(json, 'interpretation'),
    );
  }
}

class OverlayPointSummary {
  const OverlayPointSummary({required this.x, required this.y, this.label});

  final double x;
  final double y;
  final String? label;

  bool get isNormalized => x >= 0 && x <= 1 && y >= 0 && y <= 1;

  factory OverlayPointSummary.fromJson(Map<String, dynamic> json) {
    return OverlayPointSummary(
      x: _double(json, 'x'),
      y: _double(json, 'y'),
      label: _optionalString(json, 'label'),
    );
  }
}

class OverlayPrimitiveSummary {
  const OverlayPrimitiveSummary({
    required this.kind,
    required this.points,
    required this.label,
    required this.colorLayer,
  });

  final String kind;
  final List<OverlayPointSummary> points;
  final String? label;
  final String colorLayer;

  bool get hasValidShape =>
      label != null &&
      label!.trim().isNotEmpty &&
      points.every((point) => point.isNormalized) &&
      switch (kind) {
        'line' => points.length == 2,
        'polyline' => points.length >= 2,
        'angle_label' => points.length == 1,
        _ => false,
      };

  factory OverlayPrimitiveSummary.fromJson(Map<String, dynamic> json) {
    return OverlayPrimitiveSummary(
      kind: _string(json, 'kind'),
      points: List.unmodifiable(
        _list(
          json,
          'points',
        ).map((point) => OverlayPointSummary.fromJson(_asMap(point, 'point'))),
      ),
      label: _optionalString(json, 'label'),
      colorLayer: _string(json, 'color_layer'),
    );
  }
}

class SingleAttemptMetricResult {
  const SingleAttemptMetricResult({
    required this.metricId,
    required this.name,
    required this.status,
    required this.value,
    required this.unit,
    required this.provenance,
    required this.temporalReference,
    required this.confidence,
    required this.methodVersion,
    required this.limitation,
    required this.descriptiveText,
    required this.withheldReason,
    required this.overlay,
  });

  final String metricId;
  final String name;
  final SingleAttemptMetricStatus status;
  final double? value;
  final String unit;
  final AnalysisProvenance provenance;
  final MetricTemporalReferenceSummary temporalReference;
  final MetricConfidenceSummary confidence;
  final String methodVersion;
  final String limitation;
  final String? descriptiveText;
  final String? withheldReason;
  final List<OverlayPrimitiveSummary> overlay;

  bool get hasApprovedContract {
    return switch (metricId) {
      'UM-TIM-001' =>
        unit == 'seconds' &&
            provenance == AnalysisProvenance.measured &&
            temporalReference.kind == 'interval' &&
            methodVersion == 'reviewed-event-elapsed-time-1.0.0' &&
            !confidence.available &&
            overlay.isEmpty &&
            (value == null || value! > 0),
      'UM-ANG-001' =>
        unit == 'degrees' &&
            provenance == AnalysisProvenance.modelEstimated &&
            temporalReference.kind == 'instant' &&
            methodVersion == 'projected-trunk-inclination-1.0.0' &&
            (status != SingleAttemptMetricStatus.reportable ||
                confidence.available) &&
            (status == SingleAttemptMetricStatus.withheld ||
                _hasExactOverlayGeometry(
                  primaryKind: 'line',
                  primaryPointCount: 2,
                )) &&
            (value == null || (value! >= 0 && value! <= 180)),
      'UM-ANG-002' =>
        unit == 'degrees' &&
            provenance == AnalysisProvenance.modelEstimated &&
            temporalReference.kind == 'instant' &&
            methodVersion == 'projected-knee-angle-1.0.0' &&
            (status != SingleAttemptMetricStatus.reportable ||
                confidence.available) &&
            (status == SingleAttemptMetricStatus.withheld ||
                _hasExactOverlayGeometry(
                  primaryKind: 'polyline',
                  primaryPointCount: 3,
                )) &&
            (value == null || (value! >= 0 && value! <= 180)),
      'UM-ANG-003' =>
        unit == 'degrees' &&
            provenance == AnalysisProvenance.modelEstimated &&
            temporalReference.kind == 'instant' &&
            methodVersion == 'projected-knee-angle-1.0.0' &&
            (status != SingleAttemptMetricStatus.reportable ||
                confidence.available) &&
            (status == SingleAttemptMetricStatus.withheld ||
                _hasExactOverlayGeometry(
                  primaryKind: 'polyline',
                  primaryPointCount: 3,
                )) &&
            (value == null || (value! >= 0 && value! <= 180)),
      _ => false,
    };
  }

  bool _hasExactOverlayGeometry({
    required String primaryKind,
    required int primaryPointCount,
  }) {
    return overlay.length == 2 &&
        overlay[0].kind == primaryKind &&
        overlay[0].points.length == primaryPointCount &&
        overlay[1].kind == 'angle_label' &&
        overlay[1].points.length == 1;
  }

  bool get hasConsistentStatusPayload {
    final validOverlay = overlay.every(
      (primitive) => primitive.colorLayer == 'blue' && primitive.hasValidShape,
    );
    if (!temporalReference.isConsistent ||
        !confidence.isConsistent ||
        !validOverlay) {
      return false;
    }
    if (status == SingleAttemptMetricStatus.withheld) {
      return value == null &&
          descriptiveText == null &&
          withheldReason != null &&
          overlay.isEmpty;
    }
    return status != SingleAttemptMetricStatus.unknown &&
        value != null &&
        value!.isFinite &&
        descriptiveText != null &&
        withheldReason == null;
  }

  factory SingleAttemptMetricResult.fromJson(Map<String, dynamic> json) {
    return SingleAttemptMetricResult(
      metricId: _string(json, 'metric_id'),
      name: _string(json, 'name'),
      status: SingleAttemptMetricStatus.fromApiValue(json['status']),
      value: _optionalDouble(json, 'value'),
      unit: _string(json, 'unit'),
      provenance: AnalysisProvenance.fromApiValue(json['provenance']),
      temporalReference: MetricTemporalReferenceSummary.fromJson(
        _map(json, 'temporal_reference'),
      ),
      confidence: MetricConfidenceSummary.fromJson(_map(json, 'confidence')),
      methodVersion: _string(json, 'method_version'),
      limitation: _string(json, 'limitation'),
      descriptiveText: _optionalString(json, 'descriptive_text'),
      withheldReason: _optionalString(json, 'withheld_reason'),
      overlay: List.unmodifiable(
        _list(json, 'overlay').map(
          (item) => OverlayPrimitiveSummary.fromJson(
            _asMap(item, 'overlay primitive'),
          ),
        ),
      ),
    );
  }
}

class SingleAttemptCapabilitiesSummary {
  const SingleAttemptCapabilitiesSummary({
    required this.humanConfirmedTori,
    required this.humanConfirmedSupportLeg,
    required this.automaticToriUkeIdentity,
    required this.automaticPhaseDetection,
    required this.threeDimensionalReconstruction,
    required this.forceTorquePower,
    required this.normativeCoaching,
    required this.multiPersonEvidenceStatus,
    required this.multiPersonInteractionMetricsReportable,
  });

  final bool humanConfirmedTori;
  final bool humanConfirmedSupportLeg;
  final bool automaticToriUkeIdentity;
  final bool automaticPhaseDetection;
  final bool threeDimensionalReconstruction;
  final bool forceTorquePower;
  final bool normativeCoaching;
  final String multiPersonEvidenceStatus;
  final bool multiPersonInteractionMetricsReportable;

  factory SingleAttemptCapabilitiesSummary.fromJson(Map<String, dynamic> json) {
    return SingleAttemptCapabilitiesSummary(
      humanConfirmedTori: _bool(json, 'human_confirmed_tori'),
      humanConfirmedSupportLeg: _bool(json, 'human_confirmed_support_leg'),
      automaticToriUkeIdentity: _bool(json, 'automatic_tori_uke_identity'),
      automaticPhaseDetection: _bool(json, 'automatic_phase_detection'),
      threeDimensionalReconstruction: _bool(
        json,
        'three_dimensional_reconstruction',
      ),
      forceTorquePower: _bool(json, 'force_torque_power'),
      normativeCoaching: _bool(json, 'normative_coaching'),
      multiPersonEvidenceStatus: _string(json, 'multi_person_evidence_status'),
      multiPersonInteractionMetricsReportable: _bool(
        json,
        'multi_person_interaction_metrics_reportable',
      ),
    );
  }
}

class SingleAttemptLimitation {
  const SingleAttemptLimitation({
    required this.code,
    required this.message,
    required this.affectsInterpretation,
  });

  final String code;
  final String message;
  final bool affectsInterpretation;

  factory SingleAttemptLimitation.fromJson(Map<String, dynamic> json) {
    return SingleAttemptLimitation(
      code: _string(json, 'code'),
      message: _string(json, 'message'),
      affectsInterpretation: _bool(json, 'affects_interpretation'),
    );
  }
}

Map<String, dynamic> _map(Map<String, dynamic> json, String key) {
  return _asMap(json[key], key);
}

Map<String, dynamic>? _optionalMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value == null ? null : _asMap(value, key);
}

FrameReferenceSummary? _optionalFrame(Map<String, dynamic> json, String key) {
  final value = _optionalMap(json, key);
  return value == null ? null : FrameReferenceSummary.fromJson(value);
}

Map<String, dynamic> _asMap(Object? value, String fieldName) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  throw FormatException('$fieldName must be an object.');
}

List<dynamic> _list(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is List) {
    return value;
  }
  throw FormatException('$key must be a list.');
}

String _string(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw FormatException('$key must be a non-empty string.');
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw FormatException('$key must be null or a non-empty string.');
}

int _int(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int && value >= 0) {
    return value;
  }
  throw FormatException('$key must be a non-negative integer.');
}

double _double(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num && value.toDouble().isFinite) {
    return value.toDouble();
  }
  throw FormatException('$key must be a finite number.');
}

double? _optionalDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is num && value.toDouble().isFinite) {
    return value.toDouble();
  }
  throw FormatException('$key must be null or a finite number.');
}

bool _bool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is bool) {
    return value;
  }
  throw FormatException('$key must be a boolean.');
}
