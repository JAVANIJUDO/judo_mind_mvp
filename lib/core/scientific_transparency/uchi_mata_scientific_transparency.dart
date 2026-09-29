import 'scientific_transparency_model.dart';

/// Governed presentation mapping for the current Uchi Mata scientific state.
///
/// Source of truth:
/// - JM_HPS_CORE_V4_DISPOSITION.csv
/// - JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv
/// - JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv
/// - JM_S0_7_A5_VALIDATION_REPORT.md
///
/// This is deliberately a compile-time presentation projection. It does not
/// parse governance CSV files at runtime and does not activate capabilities.
abstract final class UchiMataScientificTransparency {
  const UchiMataScientificTransparency._();

  /// Stable ID of the production Uchi Mata record in [TechniqueModel].
  ///
  /// The API uses a separate `uchi-mata` technique identifier. That transport
  /// value must not be reused to identify the Flutter catalog record.
  static const techniqueId = '001';

  static const snapshot = ScientificTransparencySnapshot(
    schemaVersion: '1.0.0',
    scientificStatus: ScientificTransparencyStatus.humanReviewPending,
    humanReviewState: ScientificTransparencyStatus.humanReviewPending,
    scientificApprovalIssued: false,
    candidateSources: <ScientificSourceDisplayItem>[
      ScientificSourceDisplayItem(
        title:
            'How much is too much? Part 1: IOC consensus statement on load in sport and risk of injury',
        year: 2016,
        sourceType: ScientificSourceType.consensusStatement,
        accessState: ScientificSourceAccessState.publicFullTextIdentified,
        reviewState: ScientificTransparencyStatus.humanReviewPending,
      ),
      ScientificSourceDisplayItem(
        title:
            'How much is too much? Part 2: IOC consensus statement on load in sport and risk of illness',
        year: 2016,
        sourceType: ScientificSourceType.consensusStatement,
        accessState: ScientificSourceAccessState.publicFullTextIdentified,
        reviewState: ScientificTransparencyStatus.humanReviewPending,
      ),
      ScientificSourceDisplayItem(
        title:
            'Monitoring the athlete training response: subjective self-reported measures trump commonly used objective measures: a systematic review',
        year: 2016,
        sourceType: ScientificSourceType.systematicReview,
        accessState: ScientificSourceAccessState.validatedRepositoryPdf,
        reviewState: ScientificTransparencyStatus.humanReviewPending,
      ),
      ScientificSourceDisplayItem(
        title:
            'The Relationships Between Internal and External Measures of Training Load and Intensity in Team Sports: A Meta-Analysis',
        year: 2018,
        sourceType: ScientificSourceType.metaAnalysis,
        accessState: ScientificSourceAccessState.validatedAcceptedManuscript,
        reviewState: ScientificTransparencyStatus.humanReviewPending,
      ),
      ScientificSourceDisplayItem(
        title:
            'Internal Training Load Perceived by Athletes and Planned by Coaches: A Systematic Review and Meta-Analysis',
        year: 2022,
        sourceType: ScientificSourceType.systematicReviewAndMetaAnalysis,
        accessState: ScientificSourceAccessState.validatedPublisherVersion,
        reviewState: ScientificTransparencyStatus.humanReviewPending,
      ),
    ],
    capabilities: <ScientificCapabilityDisplayState>[
      ScientificCapabilityDisplayState(
        displayKey: 'singleCameraPoseSummary',
        state: ScientificTransparencyStatus.validationOnly,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'reviewedSingleAttempt',
        state: ScientificTransparencyStatus.validationOnly,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'projectedTwoDimensionalMetrics',
        state: ScientificTransparencyStatus.validationOnly,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'projectedHipAngle',
        state: ScientificTransparencyStatus.reviewRequired,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'automaticIdentity',
        state: ScientificTransparencyStatus.locked,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'automaticPhases',
        state: ScientificTransparencyStatus.locked,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'threeDimensionalReconstruction',
        state: ScientificTransparencyStatus.locked,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'forceAndKinetics',
        state: ScientificTransparencyStatus.locked,
      ),
      ScientificCapabilityDisplayState(
        displayKey: 'trainingPrescription',
        state: ScientificTransparencyStatus.locked,
      ),
    ],
    limitations: ScientificLimitation.values,
  );

  static ScientificTransparencySnapshot forTechnique(String techniqueId) {
    return isGovernedTechniqueId(techniqueId)
        ? snapshot
        : ScientificTransparencySnapshot.failClosed;
  }

  static bool isGovernedTechniqueId(String techniqueId) {
    return techniqueId.trim() == UchiMataScientificTransparency.techniqueId;
  }
}
