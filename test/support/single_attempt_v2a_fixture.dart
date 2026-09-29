import 'package:judo_mind/models/analysis_provenance.dart';
import 'package:judo_mind/models/single_attempt_analysis_v2a.dart';
import 'package:judo_mind/models/single_attempt_v2a_request.dart';

SingleAttemptV2ARequest validSingleAttemptV2ARequest({
  String videoPath = 'D:/authorized/uchi-mata.mp4',
  String videoId = 'authorized-video-1',
  String cameraView = 'side',
  int startFrame = 25,
  int startTimestampMs = 1000,
  int endFrame = 75,
  int endTimestampMs = 3000,
  int angleFrame = 50,
  int angleTimestampMs = 2000,
  String neutralTrackId = 'Track A',
  int selectedDetectionIndex = 0,
  ReviewedSupportLeg supportLeg = ReviewedSupportLeg.left,
  ReviewedAttackingLeg attackingLeg = ReviewedAttackingLeg.right,
  String angleEventLabel = 'reviewed-angle-observation',
  bool projectedAngleViewSuitable = true,
  bool lowRollConfirmed = true,
}) {
  return SingleAttemptV2ARequest(
    videoPath: videoPath,
    videoId: videoId,
    cameraView: cameraView,
    attemptStart: ReviewedFrameReference(
      frameIndex: startFrame,
      timestampMs: startTimestampMs,
    ),
    attemptEnd: ReviewedFrameReference(
      frameIndex: endFrame,
      timestampMs: endTimestampMs,
    ),
    eventSchemaId: 'human-single-attempt-boundaries-v1',
    neutralTrackId: neutralTrackId,
    selectedDetectionIndex: selectedDetectionIndex,
    supportLeg: supportLeg,
    attackingLeg: attackingLeg,
    angleFrame: ReviewedFrameReference(
      frameIndex: angleFrame,
      timestampMs: angleTimestampMs,
    ),
    angleEventLabel: angleEventLabel,
    projectedAngleViewSuitable: projectedAngleViewSuitable,
    lowRollConfirmed: lowRollConfirmed,
    singleAttemptConfirmed: true,
    attemptScope: 'SINGLE_ATTEMPT',
    attemptScopeSource: 'HUMAN_CONFIRMED',
    attemptScopeContractVersion: 'single-attempt-human-confirmation-1.0.0',
  );
}

SingleAttemptAnalysisV2A validSingleAttemptV2AResult({
  String analysisId = 'analysis-v2a-history-fixture',
  String videoId = 'authorized-video-1',
  String cameraView = 'side',
  int startFrame = 25,
  int startTimestampMs = 1000,
  int endFrame = 75,
  int endTimestampMs = 3000,
  int angleFrame = 50,
  int angleTimestampMs = 2000,
  String neutralTrackId = 'Track A',
  String supportLeg = 'left',
  String attackingLeg = 'right',
  String angleEventLabel = 'reviewed-angle-observation',
  bool projectedAngleViewSuitable = true,
  bool lowRollConfirmed = true,
}) {
  final attemptStart = FrameReferenceSummary(
    frameIndex: startFrame,
    timestampMs: startTimestampMs,
  );
  final attemptEnd = FrameReferenceSummary(
    frameIndex: endFrame,
    timestampMs: endTimestampMs,
  );
  final selectedAngleFrame = FrameReferenceSummary(
    frameIndex: angleFrame,
    timestampMs: angleTimestampMs,
  );

  return SingleAttemptAnalysisV2A(
    schemaVersion: '2.0.0',
    analysisVariant: 'single_attempt_v2a',
    analysisId: analysisId,
    status: 'completed',
    analysisMode: 'single_camera_2d_single_attempt',
    scientificLevel: 'level_1',
    techniqueId: 'uchi-mata',
    videoId: videoId,
    cameraView: cameraView,
    attempt: AttemptBoundarySummary(
      start: attemptStart,
      end: attemptEnd,
      eventSchemaId: 'human-single-attempt-boundaries-v1',
      selectionSource: 'human-selected',
      singleAttemptConfirmed: true,
      attemptScope: 'SINGLE_ATTEMPT',
      attemptScopeSource: 'HUMAN_CONFIRMED',
      attemptScopeContractVersion: 'single-attempt-human-confirmation-1.0.0',
    ),
    subject: HumanSubjectSelectionSummary(
      neutralTrackId: neutralTrackId,
      selectedDetectionIndex: 0,
      role: 'Tori',
      confirmationSource: 'human-confirmed',
    ),
    supportLeg: HumanSupportLegSelectionSummary(
      side: supportLeg,
      confirmationSource: 'human-confirmed',
    ),
    attackingLeg: HumanAttackingLegSelectionSummary(
      side: attackingLeg,
      confirmationSource: 'human-confirmed',
    ),
    angleFrame: AnalysisFrameSummary(
      frame: selectedAngleFrame,
      selectionSource: 'human-selected',
      eventLabel: angleEventLabel,
    ),
    cameraSuitability: CameraSuitabilitySummary(
      projectedAngleViewSuitable: projectedAngleViewSuitable,
      lowRollConfirmed: lowRollConfirmed,
      reviewSource: 'human-reviewed',
    ),
    metrics: [
      SingleAttemptMetricResult(
        metricId: 'UM-TIM-001',
        name: 'Reviewed execution duration',
        status: SingleAttemptMetricStatus.reportable,
        value: (endTimestampMs - startTimestampMs) / 1000,
        unit: 'seconds',
        provenance: AnalysisProvenance.measured,
        temporalReference: MetricTemporalReferenceSummary(
          kind: 'interval',
          start: attemptStart,
          end: attemptEnd,
        ),
        confidence: const MetricConfidenceSummary(
          available: false,
          kind: null,
          value: null,
          provenance: null,
          interpretation: 'Human-reviewed boundaries; no model confidence.',
        ),
        methodVersion: 'reviewed-event-elapsed-time-1.0.0',
        limitation: 'Depends on the same reviewed event schema.',
        descriptiveText: 'Reviewed execution duration is 2.000 seconds.',
        withheldReason: null,
        overlay: const [],
      ),
      SingleAttemptMetricResult(
        metricId: 'UM-ANG-001',
        name: 'Projected trunk inclination',
        status: SingleAttemptMetricStatus.reviewRequired,
        value: 18.4,
        unit: 'degrees',
        provenance: AnalysisProvenance.modelEstimated,
        temporalReference: MetricTemporalReferenceSummary(
          kind: 'instant',
          frame: selectedAngleFrame,
        ),
        confidence: const MetricConfidenceSummary(
          available: true,
          kind: 'minimum_model_landmark_visibility',
          value: 0.78,
          provenance: AnalysisProvenance.modelEstimated,
          interpretation: 'Minimum model visibility; not pose accuracy.',
        ),
        methodVersion: 'projected-trunk-inclination-1.0.0',
        limitation: 'Projected 2D angle; not a true 3D trunk angle.',
        descriptiveText: 'Projected trunk inclination is 18.4 degrees.',
        withheldReason: null,
        overlay: _lineOverlay('Projected trunk line', '18.4 projected'),
      ),
      SingleAttemptMetricResult(
        metricId: 'UM-ANG-002',
        name: 'Projected support-leg knee angle',
        status: SingleAttemptMetricStatus.withheld,
        value: null,
        unit: 'degrees',
        provenance: AnalysisProvenance.modelEstimated,
        temporalReference: MetricTemporalReferenceSummary(
          kind: 'instant',
          frame: selectedAngleFrame,
        ),
        confidence: const MetricConfidenceSummary(
          available: false,
          kind: null,
          value: null,
          provenance: null,
          interpretation: 'Metric withheld.',
        ),
        methodVersion: 'projected-knee-angle-1.0.0',
        limitation: 'Projected 2D angle; no load or injury-risk claim.',
        descriptiveText: null,
        withheldReason: 'The support-side ankle landmark is missing.',
        overlay: const [],
      ),
      SingleAttemptMetricResult(
        metricId: 'UM-ANG-003',
        name: 'Projected attacking-leg knee angle',
        status: SingleAttemptMetricStatus.reportable,
        value: 142.0,
        unit: 'degrees',
        provenance: AnalysisProvenance.modelEstimated,
        temporalReference: MetricTemporalReferenceSummary(
          kind: 'instant',
          frame: selectedAngleFrame,
        ),
        confidence: const MetricConfidenceSummary(
          available: true,
          kind: 'minimum_model_landmark_visibility',
          value: 0.74,
          provenance: AnalysisProvenance.modelEstimated,
          interpretation: 'Minimum model visibility; not pose accuracy.',
        ),
        methodVersion: 'projected-knee-angle-1.0.0',
        limitation: 'Projected 2D angle; no load or injury-risk claim.',
        descriptiveText: 'Projected attacking-leg knee angle is 142 degrees.',
        withheldReason: null,
        overlay: _polylineOverlay(
          'Projected right attacking leg',
          '142.0 projected',
        ),
      ),
    ],
    capabilities: const SingleAttemptCapabilitiesSummary(
      humanConfirmedTori: true,
      humanConfirmedSupportLeg: true,
      automaticToriUkeIdentity: false,
      automaticPhaseDetection: false,
      threeDimensionalReconstruction: false,
      forceTorquePower: false,
      normativeCoaching: false,
      multiPersonEvidenceStatus: 'insufficient',
      multiPersonInteractionMetricsReportable: false,
    ),
    limitations: const [
      SingleAttemptLimitation(
        code: 'human_role_confirmation_required',
        message: 'Tori is selected by a human reviewer.',
        affectsInterpretation: true,
      ),
      SingleAttemptLimitation(
        code: 'human_support_leg_confirmation_required',
        message: 'The support leg is selected by a human reviewer.',
        affectsInterpretation: true,
      ),
      SingleAttemptLimitation(
        code: 'automatic_phase_detection_not_available',
        message: 'Technique phases are not automatically detected.',
        affectsInterpretation: true,
      ),
      SingleAttemptLimitation(
        code: 'projected_single_camera_geometry',
        message: 'Angles are projected single-camera geometry.',
        affectsInterpretation: true,
      ),
      SingleAttemptLimitation(
        code: 'camera_perspective_affects_angles',
        message: 'Camera perspective can affect projected angles.',
        affectsInterpretation: true,
      ),
      SingleAttemptLimitation(
        code: 'kinetics_not_available',
        message: 'No force, torque, power or load is reported.',
        affectsInterpretation: true,
      ),
      SingleAttemptLimitation(
        code: 'descriptive_only',
        message: 'The result is descriptive and not normative coaching.',
        affectsInterpretation: true,
      ),
    ],
  );
}

SingleAttemptAnalysisV2A validSingleAttemptV2AResultForRequest(
  SingleAttemptV2ARequest request, {
  String analysisId = 'analysis-v2a-history-fixture',
}) {
  return validSingleAttemptV2AResult(
    analysisId: analysisId,
    videoId: request.videoId,
    cameraView: request.cameraView,
    startFrame: request.attemptStart.frameIndex,
    startTimestampMs: request.attemptStart.timestampMs,
    endFrame: request.attemptEnd.frameIndex,
    endTimestampMs: request.attemptEnd.timestampMs,
    angleFrame: request.angleFrame.frameIndex,
    angleTimestampMs: request.angleFrame.timestampMs,
    neutralTrackId: request.neutralTrackId,
    supportLeg: request.supportLeg.name,
    attackingLeg: request.attackingLeg.name,
    angleEventLabel: request.angleEventLabel,
    projectedAngleViewSuitable: request.projectedAngleViewSuitable,
    lowRollConfirmed: request.lowRollConfirmed,
  );
}

List<OverlayPrimitiveSummary> _lineOverlay(
  String lineLabel,
  String angleLabel,
) {
  return [
    OverlayPrimitiveSummary(
      kind: 'line',
      points: const [
        OverlayPointSummary(x: 0.5, y: 0.6),
        OverlayPointSummary(x: 0.6, y: 0.3),
      ],
      label: lineLabel,
      colorLayer: 'blue',
    ),
    OverlayPrimitiveSummary(
      kind: 'angle_label',
      points: const [OverlayPointSummary(x: 0.6, y: 0.3)],
      label: angleLabel,
      colorLayer: 'blue',
    ),
  ];
}

List<OverlayPrimitiveSummary> _polylineOverlay(
  String lineLabel,
  String angleLabel,
) {
  return [
    OverlayPrimitiveSummary(
      kind: 'polyline',
      points: const [
        OverlayPointSummary(x: 0.6, y: 0.5),
        OverlayPointSummary(x: 0.6, y: 0.7),
        OverlayPointSummary(x: 0.6, y: 0.9),
      ],
      label: lineLabel,
      colorLayer: 'blue',
    ),
    OverlayPrimitiveSummary(
      kind: 'angle_label',
      points: const [OverlayPointSummary(x: 0.6, y: 0.7)],
      label: angleLabel,
      colorLayer: 'blue',
    ),
  ];
}
