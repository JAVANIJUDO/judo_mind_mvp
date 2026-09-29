/// Optional technique-explanation fields that cannot be represented safely by
/// the existing [TechniqueModel] free-text contracts.
///
/// This extension is presentation data only. It never grants route access,
/// scientific approval, analysis capability, scoring, or production status.
enum TechniqueExplanationContentState {
  unavailable,
  draft,
  technicalReviewRequired,
  readOnlyEducationalReady,
}

enum TechniqueStatementClassification {
  conceptual,
  observed,
  measured,
  reconstructed,
  modelEstimated,
  aiInferred,
}

extension TechniqueStatementClassificationWireValue
    on TechniqueStatementClassification {
  String get wireValue => switch (this) {
    TechniqueStatementClassification.conceptual => 'CONCEPTUAL',
    TechniqueStatementClassification.observed => 'OBSERVED',
    TechniqueStatementClassification.measured => 'MEASURED',
    TechniqueStatementClassification.reconstructed => 'RECONSTRUCTED',
    TechniqueStatementClassification.modelEstimated => 'MODEL_ESTIMATED',
    TechniqueStatementClassification.aiInferred => 'AI_INFERRED',
  };
}

enum TechniqueContentReviewStatus { notReviewed, reviewRequired, reviewed }

enum TechniqueMediaRightsBasis {
  unavailable,
  projectOwned,
  licensed,
  permissionRecorded,
}

/// Exact-language text. Missing translations deliberately resolve to empty;
/// the generic UI must show its localized unavailable state instead of
/// silently substituting another language.
class TechniqueLocalizedText {
  const TechniqueLocalizedText({this.values = const <String, String>{}});

  final Map<String, String> values;

  String resolve(String languageCode) {
    final code = languageCode.trim().toLowerCase().split('-').first;
    return values[code]?.trim() ?? '';
  }

  bool hasValueFor(String languageCode) => resolve(languageCode).isNotEmpty;
}

class TechniqueExecutionPhaseContent {
  const TechniqueExecutionPhaseContent({
    this.kuzushi = const TechniqueLocalizedText(),
    this.tsukuri = const TechniqueLocalizedText(),
    this.kake = const TechniqueLocalizedText(),
    this.makikomiOrFollowThrough = const TechniqueLocalizedText(),
  });

  final TechniqueLocalizedText kuzushi;
  final TechniqueLocalizedText tsukuri;
  final TechniqueLocalizedText kake;
  final TechniqueLocalizedText makikomiOrFollowThrough;

  bool hasCorePhasesFor(String languageCode) =>
      kuzushi.hasValueFor(languageCode) &&
      tsukuri.hasValueFor(languageCode) &&
      kake.hasValueFor(languageCode);
}

class TechniqueInterpretationStatement {
  const TechniqueInterpretationStatement({
    this.text = const TechniqueLocalizedText(),
    required this.classification,
    this.methodReference = '',
    this.limitations = const TechniqueLocalizedText(),
  });

  final TechniqueLocalizedText text;
  final TechniqueStatementClassification classification;
  final String methodReference;
  final TechniqueLocalizedText limitations;

  bool isQualifiedForDisplay(String languageCode) {
    if (!text.hasValueFor(languageCode) ||
        !limitations.hasValueFor(languageCode)) {
      return false;
    }
    return switch (classification) {
      TechniqueStatementClassification.conceptual ||
      TechniqueStatementClassification.observed => true,
      TechniqueStatementClassification.measured ||
      TechniqueStatementClassification.reconstructed ||
      TechniqueStatementClassification.modelEstimated ||
      TechniqueStatementClassification.aiInferred =>
        methodReference.trim().isNotEmpty,
    };
  }
}

class TechniqueVisualExplanation {
  const TechniqueVisualExplanation({
    this.assetReference = '',
    this.rightsBasis = TechniqueMediaRightsBasis.unavailable,
    this.provenanceReference = '',
    this.licenseOrPermissionReference = '',
    this.accessibleDescription = const TechniqueLocalizedText(),
    this.bodyPositionLabels = const <TechniqueLocalizedText>[],
    this.hasConceptualDirectionalArrows = false,
    this.contactAndSupportPoints = const <TechniqueLocalizedText>[],
    this.sequenceFrameReferences = const <String>[],
  });

  final String assetReference;
  final TechniqueMediaRightsBasis rightsBasis;
  final String provenanceReference;
  final String licenseOrPermissionReference;
  final TechniqueLocalizedText accessibleDescription;
  final List<TechniqueLocalizedText> bodyPositionLabels;
  final bool hasConceptualDirectionalArrows;
  final List<TechniqueLocalizedText> contactAndSupportPoints;
  final List<String> sequenceFrameReferences;

  bool canDisplayFor(String languageCode) =>
      assetReference.trim().isNotEmpty &&
      rightsBasis != TechniqueMediaRightsBasis.unavailable &&
      provenanceReference.trim().isNotEmpty &&
      licenseOrPermissionReference.trim().isNotEmpty &&
      accessibleDescription.hasValueFor(languageCode);
}

class TechniqueVideoExplanation {
  const TechniqueVideoExplanation({
    this.mediaReference = '',
    this.rightsBasis = TechniqueMediaRightsBasis.unavailable,
    this.provenanceReference = '',
    this.licenseOrPermissionReference = '',
    this.accessibleDescription = const TechniqueLocalizedText(),
  });

  final String mediaReference;
  final TechniqueMediaRightsBasis rightsBasis;
  final String provenanceReference;
  final String licenseOrPermissionReference;
  final TechniqueLocalizedText accessibleDescription;

  bool canDisplayFor(String languageCode) =>
      mediaReference.trim().isNotEmpty &&
      rightsBasis != TechniqueMediaRightsBasis.unavailable &&
      provenanceReference.trim().isNotEmpty &&
      licenseOrPermissionReference.trim().isNotEmpty &&
      accessibleDescription.hasValueFor(languageCode);
}

class TechniqueEvidenceAndReviewStatus {
  const TechniqueEvidenceAndReviewStatus({
    this.contentSource = '',
    this.sourceType = '',
    this.provenanceOrLicense = '',
    this.technicalReviewStatus = TechniqueContentReviewStatus.notReviewed,
    this.scientificReviewStatus = TechniqueContentReviewStatus.notReviewed,
    this.reviewerRole = '',
    this.limitations = const TechniqueLocalizedText(),
    this.lastReviewDate,
  });

  final String contentSource;
  final String sourceType;
  final String provenanceOrLicense;
  final TechniqueContentReviewStatus technicalReviewStatus;
  final TechniqueContentReviewStatus scientificReviewStatus;
  final String reviewerRole;
  final TechniqueLocalizedText limitations;
  final DateTime? lastReviewDate;

  bool hasRecordedProvenanceFor(String languageCode) =>
      contentSource.trim().isNotEmpty &&
      sourceType.trim().isNotEmpty &&
      provenanceOrLicense.trim().isNotEmpty &&
      reviewerRole.trim().isNotEmpty &&
      limitations.hasValueFor(languageCode) &&
      lastReviewDate != null;
}

/// Gap-only child contract for the approved explanation standard.
///
/// Canonical identity, description, technical analysis, general execution
/// steps, coaching points, mistakes, safety, combinations and counters remain
/// owned by [TechniqueModel].
class TechniqueExplanationExtension {
  const TechniqueExplanationExtension({
    this.state = TechniqueExplanationContentState.unavailable,
    this.applicationContext = const TechniqueLocalizedText(),
    this.gripAndStartingPosition = const TechniqueLocalizedText(),
    this.executionPhases = const TechniqueExecutionPhaseContent(),
    this.variations = const <TechniqueLocalizedText>[],
    this.canonicalCombinationTechniqueIds = const <String>[],
    this.canonicalCounterTechniqueIds = const <String>[],
    this.visualExplanation = const TechniqueVisualExplanation(),
    this.videoExplanation = const TechniqueVideoExplanation(),
    this.conceptualMechanicalInterpretation =
        const <TechniqueInterpretationStatement>[],
    this.biomechanicalInterpretation =
        const <TechniqueInterpretationStatement>[],
    this.evidenceAndReviewStatus = const TechniqueEvidenceAndReviewStatus(),
  });

  const TechniqueExplanationExtension.empty()
    : this(state: TechniqueExplanationContentState.unavailable);

  final TechniqueExplanationContentState state;
  final TechniqueLocalizedText applicationContext;
  final TechniqueLocalizedText gripAndStartingPosition;
  final TechniqueExecutionPhaseContent executionPhases;
  final List<TechniqueLocalizedText> variations;
  final List<String> canonicalCombinationTechniqueIds;
  final List<String> canonicalCounterTechniqueIds;
  final TechniqueVisualExplanation visualExplanation;
  final TechniqueVideoExplanation videoExplanation;
  final List<TechniqueInterpretationStatement>
  conceptualMechanicalInterpretation;
  final List<TechniqueInterpretationStatement> biomechanicalInterpretation;
  final TechniqueEvidenceAndReviewStatus evidenceAndReviewStatus;

  bool get isReadOnlyEducationalReady =>
      state == TechniqueExplanationContentState.readOnlyEducationalReady;

  bool hasQualifiedConceptualInterpretationFor(String languageCode) =>
      isReadOnlyEducationalReady &&
      conceptualMechanicalInterpretation.isNotEmpty &&
      conceptualMechanicalInterpretation.every(
        (statement) =>
            statement.classification ==
                TechniqueStatementClassification.conceptual &&
            statement.isQualifiedForDisplay(languageCode),
      ) &&
      evidenceAndReviewStatus.technicalReviewStatus ==
          TechniqueContentReviewStatus.reviewed &&
      evidenceAndReviewStatus.hasRecordedProvenanceFor(languageCode);

  bool hasQualifiedBiomechanicalInterpretationFor(String languageCode) =>
      isReadOnlyEducationalReady &&
      biomechanicalInterpretation.isNotEmpty &&
      biomechanicalInterpretation.every(
        (statement) => statement.isQualifiedForDisplay(languageCode),
      ) &&
      evidenceAndReviewStatus.scientificReviewStatus ==
          TechniqueContentReviewStatus.reviewed &&
      evidenceAndReviewStatus.hasRecordedProvenanceFor(languageCode);
}
