import 'analysis_provenance.dart';
import 'single_attempt_analysis_v2a.dart';

/// Immutable, local/demo-only summary of one scientifically bounded V2A
/// result. It deliberately excludes video identifiers, paths, bytes, overlays,
/// frame-local detection indices, scores, mastery and trend fields.
class LocalAttemptHistoryRecord {
  const LocalAttemptHistoryRecord({
    required this.recordSchemaVersion,
    required this.sourceResponseSchemaVersion,
    required this.analysisVariant,
    required this.analysisId,
    required this.resultStatus,
    required this.analysisMode,
    required this.scientificLevel,
    required this.techniqueId,
    required this.cameraView,
    required this.reviewBinding,
    required this.metrics,
    required this.capabilities,
    required this.limitations,
    required this.savedAtUtc,
  });

  static const currentSchemaVersion = '1.0.0';

  final String recordSchemaVersion;
  final String sourceResponseSchemaVersion;
  final String analysisVariant;
  final String analysisId;
  final String resultStatus;
  final String analysisMode;
  final String scientificLevel;
  final String techniqueId;
  final String cameraView;
  final LocalAttemptReviewBinding reviewBinding;
  final List<LocalAttemptMetricSummary> metrics;
  final LocalAttemptCapabilityBoundary capabilities;
  final List<LocalAttemptLimitationSummary> limitations;
  final DateTime savedAtUtc;

  bool get hasExpectedBoundary {
    final metricIds = metrics.map((metric) => metric.metricId).toList();
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
    final limitationCodes = limitations
        .where((limitation) => limitation.affectsInterpretation)
        .map((limitation) => limitation.code)
        .toSet();

    return recordSchemaVersion == currentSchemaVersion &&
        sourceResponseSchemaVersion == '2.0.0' &&
        analysisVariant == 'single_attempt_v2a' &&
        analysisId.trim().isNotEmpty &&
        resultStatus == 'completed' &&
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
        reviewBinding.isValid &&
        metricIds.length == SingleAttemptAnalysisV2A.requiredMetricIds.length &&
        metricIds.toSet().containsAll(
          SingleAttemptAnalysisV2A.requiredMetricIds,
        ) &&
        duration.length == 1 &&
        duration.single.temporalReference.start?.matches(
              reviewBinding.attemptStart,
            ) ==
            true &&
        duration.single.temporalReference.end?.matches(
              reviewBinding.attemptEnd,
            ) ==
            true &&
        projectedAngles.length == 3 &&
        projectedAngles.every(
          (metric) =>
              metric.temporalReference.frame?.matches(
                reviewBinding.angleFrame,
              ) ==
              true,
        ) &&
        (reviewBinding.attackingLegSide != null ||
            (attackingKnee.length == 1 &&
                attackingKnee.single.status ==
                    SingleAttemptMetricStatus.withheld)) &&
        (reviewBinding.projectedAngleViewSuitable &&
                reviewBinding.lowRollConfirmed ||
            projectedAngles.every(
              (metric) => metric.status != SingleAttemptMetricStatus.reportable,
            )) &&
        metrics.every((metric) => metric.isValid) &&
        capabilities.isExpectedBoundary &&
        limitationCodes.containsAll(
          SingleAttemptAnalysisV2A.requiredLimitationCodes,
        ) &&
        savedAtUtc.isUtc;
  }

  factory LocalAttemptHistoryRecord.fromAnalysis(
    SingleAttemptAnalysisV2A result, {
    required DateTime savedAtUtc,
  }) {
    if (!result.hasExpectedScientificBoundary) {
      throw const FormatException(
        'Only a V2A result with the expected scientific boundary may be saved.',
      );
    }

    final record = LocalAttemptHistoryRecord(
      recordSchemaVersion: currentSchemaVersion,
      sourceResponseSchemaVersion: result.schemaVersion,
      analysisVariant: result.analysisVariant,
      analysisId: result.analysisId,
      resultStatus: result.status,
      analysisMode: result.analysisMode,
      scientificLevel: result.scientificLevel,
      techniqueId: result.techniqueId,
      cameraView: result.cameraView,
      reviewBinding: LocalAttemptReviewBinding.fromAnalysis(result),
      metrics: List.unmodifiable(
        result.metrics.map(LocalAttemptMetricSummary.fromResult),
      ),
      capabilities: LocalAttemptCapabilityBoundary.fromResult(
        result.capabilities,
      ),
      limitations: List.unmodifiable(
        result.limitations.map(LocalAttemptLimitationSummary.fromResult),
      ),
      savedAtUtc: savedAtUtc.toUtc(),
    );

    if (!record.hasExpectedBoundary) {
      throw const FormatException(
        'The local attempt record does not preserve the V2A boundary.',
      );
    }
    return record;
  }

  factory LocalAttemptHistoryRecord.fromJson(Map<String, dynamic> json) {
    final savedAt = DateTime.tryParse(_string(json, 'saved_at_utc'));
    if (savedAt == null || !savedAt.isUtc) {
      throw const FormatException('saved_at_utc must be a UTC timestamp.');
    }

    final record = LocalAttemptHistoryRecord(
      recordSchemaVersion: _string(json, 'record_schema_version'),
      sourceResponseSchemaVersion: _string(
        json,
        'source_response_schema_version',
      ),
      analysisVariant: _string(json, 'analysis_variant'),
      analysisId: _string(json, 'analysis_id'),
      resultStatus: _string(json, 'result_status'),
      analysisMode: _string(json, 'analysis_mode'),
      scientificLevel: _string(json, 'scientific_level'),
      techniqueId: _string(json, 'technique_id'),
      cameraView: _string(json, 'camera_view'),
      reviewBinding: LocalAttemptReviewBinding.fromJson(
        _map(json, 'review_binding'),
      ),
      metrics: List.unmodifiable(
        _list(json, 'metrics').map(
          (item) => LocalAttemptMetricSummary.fromJson(_asMap(item, 'metric')),
        ),
      ),
      capabilities: LocalAttemptCapabilityBoundary.fromJson(
        _map(json, 'capabilities'),
      ),
      limitations: List.unmodifiable(
        _list(json, 'limitations').map(
          (item) => LocalAttemptLimitationSummary.fromJson(
            _asMap(item, 'limitation'),
          ),
        ),
      ),
      savedAtUtc: savedAt,
    );

    if (!record.hasExpectedBoundary) {
      throw const FormatException(
        'Unsupported or scientifically inconsistent local attempt record.',
      );
    }
    return record;
  }

  Map<String, dynamic> toJson() {
    return {
      'record_schema_version': recordSchemaVersion,
      'source_response_schema_version': sourceResponseSchemaVersion,
      'analysis_variant': analysisVariant,
      'analysis_id': analysisId,
      'result_status': resultStatus,
      'analysis_mode': analysisMode,
      'scientific_level': scientificLevel,
      'technique_id': techniqueId,
      'camera_view': cameraView,
      'review_binding': reviewBinding.toJson(),
      'metrics': metrics.map((metric) => metric.toJson()).toList(),
      'capabilities': capabilities.toJson(),
      'limitations': limitations
          .map((limitation) => limitation.toJson())
          .toList(),
      'saved_at_utc': savedAtUtc.toIso8601String(),
    };
  }
}

class LocalAttemptReviewBinding {
  const LocalAttemptReviewBinding({
    required this.attemptStart,
    required this.attemptEnd,
    required this.eventSchemaId,
    required this.attemptSelectionSource,
    required this.neutralTrackId,
    required this.subjectRole,
    required this.subjectConfirmationSource,
    required this.supportLegSide,
    required this.supportLegConfirmationSource,
    required this.attackingLegSide,
    required this.attackingLegConfirmationSource,
    required this.angleFrame,
    required this.angleSelectionSource,
    required this.angleEventLabel,
    required this.projectedAngleViewSuitable,
    required this.lowRollConfirmed,
    required this.cameraReviewSource,
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

  final LocalAttemptFrameReference attemptStart;
  final LocalAttemptFrameReference attemptEnd;
  final String eventSchemaId;
  final String attemptSelectionSource;
  final String neutralTrackId;
  final String subjectRole;
  final String subjectConfirmationSource;
  final String supportLegSide;
  final String supportLegConfirmationSource;
  final String? attackingLegSide;
  final String? attackingLegConfirmationSource;
  final LocalAttemptFrameReference angleFrame;
  final String angleSelectionSource;
  final String angleEventLabel;
  final bool projectedAngleViewSuitable;
  final bool lowRollConfirmed;
  final String cameraReviewSource;
  final bool boundariesHumanConfirmed;
  final String? sourceTimingState;
  final String? timingMode;
  final String? timestampProvenance;
  final double? physicalTimeScale;
  final bool singleAttemptConfirmed;
  final String? attemptScope;
  final String? attemptScopeSource;
  final String? attemptScopeContractVersion;

  bool get isValid {
    final neutralTrackPattern = RegExp(r'^Track [A-Z]+$');
    final attackingLegConsistent =
        (attackingLegSide == null && attackingLegConfirmationSource == null) ||
        ({'left', 'right'}.contains(attackingLegSide) &&
            attackingLegConfirmationSource == 'human-confirmed');
    final attemptScopeConsistent =
        !singleAttemptConfirmed ||
        (attemptScope == 'SINGLE_ATTEMPT' &&
            attemptScopeSource == 'HUMAN_CONFIRMED' &&
            attemptScopeContractVersion ==
                'single-attempt-human-confirmation-1.0.0');
    return attemptStart.isValid &&
        attemptEnd.isValid &&
        attemptEnd.frameIndex > attemptStart.frameIndex &&
        attemptEnd.timestampMs > attemptStart.timestampMs &&
        eventSchemaId.trim().isNotEmpty &&
        attemptSelectionSource == 'human-selected' &&
        neutralTrackPattern.hasMatch(neutralTrackId) &&
        neutralTrackId != 'Track TORI' &&
        neutralTrackId != 'Track UKE' &&
        subjectRole == 'Tori' &&
        subjectConfirmationSource == 'human-confirmed' &&
        {'left', 'right'}.contains(supportLegSide) &&
        supportLegConfirmationSource == 'human-confirmed' &&
        attackingLegConsistent &&
        attemptScopeConsistent &&
        angleFrame.frameIndex >= attemptStart.frameIndex &&
        angleFrame.frameIndex <= attemptEnd.frameIndex &&
        angleFrame.timestampMs >= attemptStart.timestampMs &&
        angleFrame.timestampMs <= attemptEnd.timestampMs &&
        angleSelectionSource == 'human-selected' &&
        angleEventLabel.trim().isNotEmpty &&
        cameraReviewSource == 'human-reviewed';
  }

  factory LocalAttemptReviewBinding.fromAnalysis(
    SingleAttemptAnalysisV2A result,
  ) {
    return LocalAttemptReviewBinding(
      attemptStart: LocalAttemptFrameReference.fromResult(result.attempt.start),
      attemptEnd: LocalAttemptFrameReference.fromResult(result.attempt.end),
      eventSchemaId: result.attempt.eventSchemaId,
      attemptSelectionSource: result.attempt.selectionSource,
      neutralTrackId: result.subject.neutralTrackId,
      subjectRole: result.subject.role,
      subjectConfirmationSource: result.subject.confirmationSource,
      supportLegSide: result.supportLeg.side,
      supportLegConfirmationSource: result.supportLeg.confirmationSource,
      attackingLegSide: result.attackingLeg?.side,
      attackingLegConfirmationSource: result.attackingLeg?.confirmationSource,
      angleFrame: LocalAttemptFrameReference.fromResult(
        result.angleFrame.frame,
      ),
      angleSelectionSource: result.angleFrame.selectionSource,
      angleEventLabel: result.angleFrame.eventLabel,
      projectedAngleViewSuitable:
          result.cameraSuitability.projectedAngleViewSuitable,
      lowRollConfirmed: result.cameraSuitability.lowRollConfirmed,
      cameraReviewSource: result.cameraSuitability.reviewSource,
      boundariesHumanConfirmed: result.attempt.boundariesHumanConfirmed,
      sourceTimingState: result.attempt.sourceTimingState,
      timingMode: result.attempt.timingMode,
      timestampProvenance: result.attempt.timestampProvenance,
      physicalTimeScale: result.attempt.physicalTimeScale,
      singleAttemptConfirmed: result.attempt.singleAttemptConfirmed,
      attemptScope: result.attempt.attemptScope,
      attemptScopeSource: result.attempt.attemptScopeSource,
      attemptScopeContractVersion: result.attempt.attemptScopeContractVersion,
    );
  }

  factory LocalAttemptReviewBinding.fromJson(Map<String, dynamic> json) {
    final attackingLeg = _optionalMap(json, 'attacking_leg');
    return LocalAttemptReviewBinding(
      attemptStart: LocalAttemptFrameReference.fromJson(
        _map(_map(json, 'attempt'), 'start'),
      ),
      attemptEnd: LocalAttemptFrameReference.fromJson(
        _map(_map(json, 'attempt'), 'end'),
      ),
      eventSchemaId: _string(_map(json, 'attempt'), 'event_schema_id'),
      attemptSelectionSource: _string(
        _map(json, 'attempt'),
        'selection_source',
      ),
      neutralTrackId: _string(_map(json, 'subject'), 'neutral_track_id'),
      subjectRole: _string(_map(json, 'subject'), 'role'),
      subjectConfirmationSource: _string(
        _map(json, 'subject'),
        'confirmation_source',
      ),
      supportLegSide: _string(_map(json, 'support_leg'), 'side'),
      supportLegConfirmationSource: _string(
        _map(json, 'support_leg'),
        'confirmation_source',
      ),
      attackingLegSide: attackingLeg == null
          ? null
          : _string(attackingLeg, 'side'),
      attackingLegConfirmationSource: attackingLeg == null
          ? null
          : _string(attackingLeg, 'confirmation_source'),
      angleFrame: LocalAttemptFrameReference.fromJson(
        _map(_map(json, 'angle_frame'), 'frame'),
      ),
      angleSelectionSource: _string(
        _map(json, 'angle_frame'),
        'selection_source',
      ),
      angleEventLabel: _string(_map(json, 'angle_frame'), 'event_label'),
      projectedAngleViewSuitable: _bool(
        _map(json, 'camera_suitability'),
        'projected_angle_view_suitable',
      ),
      lowRollConfirmed: _bool(
        _map(json, 'camera_suitability'),
        'low_roll_confirmed',
      ),
      cameraReviewSource: _string(
        _map(json, 'camera_suitability'),
        'review_source',
      ),
      boundariesHumanConfirmed:
          (_map(json, 'attempt')['boundaries_human_confirmed'] as bool?) ??
          false,
      sourceTimingState:
          (_map(json, 'attempt')['source_timing'] as Map?)?['state'] as String?,
      timingMode:
          (_map(json, 'attempt')['source_timing'] as Map?)?['timing_mode']
              as String?,
      timestampProvenance:
          (_map(json, 'attempt')['source_timing']
                  as Map?)?['timestamp_provenance']
              as String?,
      physicalTimeScale:
          ((_map(json, 'attempt')['source_timing']
                      as Map?)?['physical_time_scale']
                  as num?)
              ?.toDouble(),
      singleAttemptConfirmed:
          (_map(json, 'attempt')['single_attempt_confirmed'] as bool?) ?? false,
      attemptScope: _map(json, 'attempt')['attempt_scope'] as String?,
      attemptScopeSource:
          _map(json, 'attempt')['attempt_scope_source'] as String?,
      attemptScopeContractVersion:
          _map(json, 'attempt')['attempt_scope_contract_version'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attempt': {
        'start': attemptStart.toJson(),
        'end': attemptEnd.toJson(),
        'event_schema_id': eventSchemaId,
        'selection_source': attemptSelectionSource,
        'boundaries_human_confirmed': boundariesHumanConfirmed,
        if (sourceTimingState != null)
          'source_timing': {
            'state': sourceTimingState,
            'timing_mode': timingMode,
            'timestamp_provenance': timestampProvenance,
            'physical_time_scale': physicalTimeScale,
          },
        'single_attempt_confirmed': singleAttemptConfirmed,
        if (attemptScope != null) 'attempt_scope': attemptScope,
        if (attemptScopeSource != null)
          'attempt_scope_source': attemptScopeSource,
        if (attemptScopeContractVersion != null)
          'attempt_scope_contract_version': attemptScopeContractVersion,
      },
      'subject': {
        'neutral_track_id': neutralTrackId,
        'role': subjectRole,
        'confirmation_source': subjectConfirmationSource,
      },
      'support_leg': {
        'side': supportLegSide,
        'confirmation_source': supportLegConfirmationSource,
      },
      'attacking_leg': attackingLegSide == null
          ? null
          : {
              'side': attackingLegSide,
              'confirmation_source': attackingLegConfirmationSource,
            },
      'angle_frame': {
        'frame': angleFrame.toJson(),
        'selection_source': angleSelectionSource,
        'event_label': angleEventLabel,
      },
      'camera_suitability': {
        'projected_angle_view_suitable': projectedAngleViewSuitable,
        'low_roll_confirmed': lowRollConfirmed,
        'review_source': cameraReviewSource,
      },
    };
  }
}

class LocalAttemptFrameReference {
  const LocalAttemptFrameReference({
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

  bool get isValid => frameIndex >= 0 && timestampMs >= 0;

  bool matches(LocalAttemptFrameReference other) =>
      frameIndex == other.frameIndex && timestampMs == other.timestampMs;

  factory LocalAttemptFrameReference.fromResult(FrameReferenceSummary frame) {
    return LocalAttemptFrameReference(
      frameIndex: frame.frameIndex,
      timestampMs: frame.timestampMs,
      ptsMs: frame.ptsMs,
      timingProvenance: frame.timingProvenance,
      canonicalizationMethodVersion: frame.canonicalizationMethodVersion,
    );
  }

  factory LocalAttemptFrameReference.fromJson(Map<String, dynamic> json) {
    return LocalAttemptFrameReference(
      frameIndex: _int(json, 'frame_index'),
      timestampMs: _int(json, 'timestamp_ms'),
      ptsMs: json['pts_ms'] as int?,
      timingProvenance: json['timing_provenance'] as String?,
      canonicalizationMethodVersion:
          json['canonicalization_method_version'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frame_index': frameIndex,
      'timestamp_ms': timestampMs,
      if (ptsMs != null) 'pts_ms': ptsMs,
      if (timingProvenance != null) 'timing_provenance': timingProvenance,
      if (canonicalizationMethodVersion != null)
        'canonicalization_method_version': canonicalizationMethodVersion,
    };
  }
}

class LocalAttemptMetricSummary {
  const LocalAttemptMetricSummary({
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
  });

  final String metricId;
  final String name;
  final SingleAttemptMetricStatus status;
  final double? value;
  final String unit;
  final AnalysisProvenance provenance;
  final LocalAttemptTemporalReference temporalReference;
  final LocalAttemptConfidenceSummary confidence;
  final String methodVersion;
  final String limitation;
  final String? descriptiveText;
  final String? withheldReason;

  bool get isValid {
    final correctContract = switch (metricId) {
      'UM-TIM-001' =>
        unit == 'seconds' &&
            provenance == AnalysisProvenance.measured &&
            temporalReference.kind == 'interval' &&
            methodVersion == 'reviewed-event-elapsed-time-1.0.0' &&
            !confidence.available &&
            (value == null || value! > 0),
      'UM-ANG-001' =>
        unit == 'degrees' &&
            provenance == AnalysisProvenance.modelEstimated &&
            temporalReference.kind == 'instant' &&
            methodVersion == 'projected-trunk-inclination-1.0.0' &&
            (status != SingleAttemptMetricStatus.reportable ||
                confidence.available) &&
            (value == null || (value! >= 0 && value! <= 180)),
      'UM-ANG-002' || 'UM-ANG-003' =>
        unit == 'degrees' &&
            provenance == AnalysisProvenance.modelEstimated &&
            temporalReference.kind == 'instant' &&
            methodVersion == 'projected-knee-angle-1.0.0' &&
            (status != SingleAttemptMetricStatus.reportable ||
                confidence.available) &&
            (value == null || (value! >= 0 && value! <= 180)),
      _ => false,
    };
    final statusPayload = status == SingleAttemptMetricStatus.withheld
        ? value == null && descriptiveText == null && withheldReason != null
        : status != SingleAttemptMetricStatus.unknown &&
              value != null &&
              value!.isFinite &&
              descriptiveText != null &&
              withheldReason == null;
    return name.trim().isNotEmpty &&
        limitation.trim().isNotEmpty &&
        temporalReference.isValid &&
        confidence.isValid &&
        correctContract &&
        statusPayload;
  }

  factory LocalAttemptMetricSummary.fromResult(
    SingleAttemptMetricResult metric,
  ) {
    return LocalAttemptMetricSummary(
      metricId: metric.metricId,
      name: metric.name,
      status: metric.status,
      value: metric.value,
      unit: metric.unit,
      provenance: metric.provenance,
      temporalReference: LocalAttemptTemporalReference.fromResult(
        metric.temporalReference,
      ),
      confidence: LocalAttemptConfidenceSummary.fromResult(metric.confidence),
      methodVersion: metric.methodVersion,
      limitation: metric.limitation,
      descriptiveText: metric.descriptiveText,
      withheldReason: metric.withheldReason,
    );
  }

  factory LocalAttemptMetricSummary.fromJson(Map<String, dynamic> json) {
    final status = SingleAttemptMetricStatus.fromApiValue(json['status']);
    final provenance = AnalysisProvenance.fromApiValue(json['provenance']);
    if (status == SingleAttemptMetricStatus.unknown) {
      throw const FormatException('Unsupported metric status.');
    }
    if (provenance == AnalysisProvenance.unknown) {
      throw const FormatException('Unsupported metric provenance.');
    }
    return LocalAttemptMetricSummary(
      metricId: _string(json, 'metric_id'),
      name: _string(json, 'name'),
      status: status,
      value: _optionalDouble(json, 'value'),
      unit: _string(json, 'unit'),
      provenance: provenance,
      temporalReference: LocalAttemptTemporalReference.fromJson(
        _map(json, 'temporal_reference'),
      ),
      confidence: LocalAttemptConfidenceSummary.fromJson(
        _map(json, 'confidence'),
      ),
      methodVersion: _string(json, 'method_version'),
      limitation: _string(json, 'limitation'),
      descriptiveText: _optionalString(json, 'descriptive_text'),
      withheldReason: _optionalString(json, 'withheld_reason'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metric_id': metricId,
      'name': name,
      'status': status.apiValue,
      'value': value,
      'unit': unit,
      'provenance': provenance.apiValue,
      'temporal_reference': temporalReference.toJson(),
      'confidence': confidence.toJson(),
      'method_version': methodVersion,
      'limitation': limitation,
      'descriptive_text': descriptiveText,
      'withheld_reason': withheldReason,
    };
  }
}

class LocalAttemptTemporalReference {
  const LocalAttemptTemporalReference({
    required this.kind,
    this.frame,
    this.start,
    this.end,
  });

  final String kind;
  final LocalAttemptFrameReference? frame;
  final LocalAttemptFrameReference? start;
  final LocalAttemptFrameReference? end;

  bool get isValid => switch (kind) {
    'instant' => frame?.isValid == true && start == null && end == null,
    'interval' =>
      frame == null && start?.isValid == true && end?.isValid == true,
    _ => false,
  };

  factory LocalAttemptTemporalReference.fromResult(
    MetricTemporalReferenceSummary temporal,
  ) {
    return LocalAttemptTemporalReference(
      kind: temporal.kind,
      frame: temporal.frame == null
          ? null
          : LocalAttemptFrameReference.fromResult(temporal.frame!),
      start: temporal.start == null
          ? null
          : LocalAttemptFrameReference.fromResult(temporal.start!),
      end: temporal.end == null
          ? null
          : LocalAttemptFrameReference.fromResult(temporal.end!),
    );
  }

  factory LocalAttemptTemporalReference.fromJson(Map<String, dynamic> json) {
    return LocalAttemptTemporalReference(
      kind: _string(json, 'kind'),
      frame: _optionalFrame(json, 'frame'),
      start: _optionalFrame(json, 'start'),
      end: _optionalFrame(json, 'end'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'frame': frame?.toJson(),
      'start': start?.toJson(),
      'end': end?.toJson(),
    };
  }
}

class LocalAttemptConfidenceSummary {
  const LocalAttemptConfidenceSummary({
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

  bool get isValid {
    if (!available) {
      return kind == null && value == null && provenance == null;
    }
    return kind == 'minimum_model_landmark_visibility' &&
        value != null &&
        value! >= 0 &&
        value! <= 1 &&
        provenance == AnalysisProvenance.modelEstimated;
  }

  factory LocalAttemptConfidenceSummary.fromResult(
    MetricConfidenceSummary confidence,
  ) {
    return LocalAttemptConfidenceSummary(
      available: confidence.available,
      kind: confidence.kind,
      value: confidence.value,
      provenance: confidence.provenance,
      interpretation: confidence.interpretation,
    );
  }

  factory LocalAttemptConfidenceSummary.fromJson(Map<String, dynamic> json) {
    final rawProvenance = json['provenance'];
    final provenance = rawProvenance == null
        ? null
        : AnalysisProvenance.fromApiValue(rawProvenance);
    if (provenance == AnalysisProvenance.unknown) {
      throw const FormatException('Unsupported confidence provenance.');
    }
    return LocalAttemptConfidenceSummary(
      available: _bool(json, 'available'),
      kind: _optionalString(json, 'kind'),
      value: _optionalDouble(json, 'value'),
      provenance: provenance,
      interpretation: _string(json, 'interpretation'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'kind': kind,
      'value': value,
      'provenance': provenance?.apiValue,
      'interpretation': interpretation,
    };
  }
}

class LocalAttemptCapabilityBoundary {
  const LocalAttemptCapabilityBoundary({
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

  bool get isExpectedBoundary =>
      humanConfirmedTori &&
      humanConfirmedSupportLeg &&
      !automaticToriUkeIdentity &&
      !automaticPhaseDetection &&
      !threeDimensionalReconstruction &&
      !forceTorquePower &&
      !normativeCoaching &&
      multiPersonEvidenceStatus == 'insufficient' &&
      !multiPersonInteractionMetricsReportable;

  factory LocalAttemptCapabilityBoundary.fromResult(
    SingleAttemptCapabilitiesSummary capabilities,
  ) {
    return LocalAttemptCapabilityBoundary(
      humanConfirmedTori: capabilities.humanConfirmedTori,
      humanConfirmedSupportLeg: capabilities.humanConfirmedSupportLeg,
      automaticToriUkeIdentity: capabilities.automaticToriUkeIdentity,
      automaticPhaseDetection: capabilities.automaticPhaseDetection,
      threeDimensionalReconstruction:
          capabilities.threeDimensionalReconstruction,
      forceTorquePower: capabilities.forceTorquePower,
      normativeCoaching: capabilities.normativeCoaching,
      multiPersonEvidenceStatus: capabilities.multiPersonEvidenceStatus,
      multiPersonInteractionMetricsReportable:
          capabilities.multiPersonInteractionMetricsReportable,
    );
  }

  factory LocalAttemptCapabilityBoundary.fromJson(Map<String, dynamic> json) {
    return LocalAttemptCapabilityBoundary(
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

  Map<String, dynamic> toJson() {
    return {
      'human_confirmed_tori': humanConfirmedTori,
      'human_confirmed_support_leg': humanConfirmedSupportLeg,
      'automatic_tori_uke_identity': automaticToriUkeIdentity,
      'automatic_phase_detection': automaticPhaseDetection,
      'three_dimensional_reconstruction': threeDimensionalReconstruction,
      'force_torque_power': forceTorquePower,
      'normative_coaching': normativeCoaching,
      'multi_person_evidence_status': multiPersonEvidenceStatus,
      'multi_person_interaction_metrics_reportable':
          multiPersonInteractionMetricsReportable,
    };
  }
}

class LocalAttemptLimitationSummary {
  const LocalAttemptLimitationSummary({
    required this.code,
    required this.message,
    required this.affectsInterpretation,
  });

  final String code;
  final String message;
  final bool affectsInterpretation;

  factory LocalAttemptLimitationSummary.fromResult(
    SingleAttemptLimitation limitation,
  ) {
    return LocalAttemptLimitationSummary(
      code: limitation.code,
      message: limitation.message,
      affectsInterpretation: limitation.affectsInterpretation,
    );
  }

  factory LocalAttemptLimitationSummary.fromJson(Map<String, dynamic> json) {
    return LocalAttemptLimitationSummary(
      code: _string(json, 'code'),
      message: _string(json, 'message'),
      affectsInterpretation: _bool(json, 'affects_interpretation'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'affects_interpretation': affectsInterpretation,
    };
  }
}

Map<String, dynamic> _map(Map<String, dynamic> json, String key) {
  return _asMap(json[key], key);
}

Map<String, dynamic>? _optionalMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value == null ? null : _asMap(value, key);
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
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('$key must be a non-empty string.');
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String && value.trim().isNotEmpty) {
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

LocalAttemptFrameReference? _optionalFrame(
  Map<String, dynamic> json,
  String key,
) {
  final value = _optionalMap(json, key);
  return value == null ? null : LocalAttemptFrameReference.fromJson(value);
}
