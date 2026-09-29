/// Presentation-only scientific states. These values never grant a scientific
/// capability and must be localized before they are shown to an athlete.
enum ScientificTransparencyStatus {
  notScientificallyReviewed,
  humanReviewPending,
  reviewRequired,
  validationOnly,
  locked,
  fullTextRequired,
  methodBlocked,
  sourceMappingRequired,
  notApplicable,
}

enum ScientificSourceType {
  consensusStatement,
  systematicReview,
  metaAnalysis,
  systematicReviewAndMetaAnalysis,
}

enum ScientificSourceAccessState {
  publicFullTextIdentified,
  validatedRepositoryPdf,
  validatedAcceptedManuscript,
  validatedPublisherVersion,
}

enum ScientificLimitation {
  engineeringObservationsOnly,
  noDirectForceOrKinetics,
  noDefinitiveThreeDimensionalAnalysis,
  noTechnicalErrorOrInjuryDiagnosis,
  noInjuryPrediction,
  noRefereeDecision,
  associationIsNotCausation,
  riskIsNotCertainPrediction,
  missingEvidenceKeepsFeaturesLocked,
}

class ScientificSourceDisplayItem {
  final String title;
  final int year;
  final ScientificSourceType sourceType;
  final ScientificSourceAccessState accessState;
  final ScientificTransparencyStatus reviewState;

  const ScientificSourceDisplayItem({
    required this.title,
    required this.year,
    required this.sourceType,
    required this.accessState,
    required this.reviewState,
  });
}

class ScientificCapabilityDisplayState {
  final String displayKey;
  final ScientificTransparencyStatus state;

  const ScientificCapabilityDisplayState({
    required this.displayKey,
    required this.state,
  });
}

/// Immutable, read-only projection of governed repository records.
///
/// It intentionally contains no reviewer identity, local path, governance ID,
/// hash, formula, threshold, enable flag, or mutation action.
class ScientificTransparencySnapshot {
  final String schemaVersion;
  final ScientificTransparencyStatus scientificStatus;
  final ScientificTransparencyStatus humanReviewState;
  final bool scientificApprovalIssued;
  final List<ScientificSourceDisplayItem> candidateSources;
  final List<ScientificCapabilityDisplayState> capabilities;
  final List<ScientificLimitation> limitations;

  const ScientificTransparencySnapshot({
    required this.schemaVersion,
    required this.scientificStatus,
    required this.humanReviewState,
    required this.scientificApprovalIssued,
    required this.candidateSources,
    required this.capabilities,
    required this.limitations,
  });

  /// Missing or unrecognized data must never become approval or availability.
  static const failClosed = ScientificTransparencySnapshot(
    schemaVersion: '1.0.0',
    scientificStatus: ScientificTransparencyStatus.locked,
    humanReviewState: ScientificTransparencyStatus.notScientificallyReviewed,
    scientificApprovalIssued: false,
    candidateSources: <ScientificSourceDisplayItem>[],
    capabilities: <ScientificCapabilityDisplayState>[],
    limitations: <ScientificLimitation>[
      ScientificLimitation.missingEvidenceKeepsFeaturesLocked,
    ],
  );
}
