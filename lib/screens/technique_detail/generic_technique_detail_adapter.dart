import '../../models/technique_model.dart';
import '../../models/technique_translation.dart';
import '../../models/technique_explanation_content.dart';

class ResolvedTechniqueInterpretation {
  const ResolvedTechniqueInterpretation({
    required this.text,
    required this.classification,
    required this.limitations,
  });

  final String text;
  final TechniqueStatementClassification classification;
  final String limitations;
}

class ResolvedTechniqueEvidenceAndReviewStatus {
  const ResolvedTechniqueEvidenceAndReviewStatus({
    required this.contentSource,
    required this.sourceType,
    required this.provenanceOrLicense,
    required this.technicalReviewStatus,
    required this.scientificReviewStatus,
    required this.reviewerRole,
    required this.limitations,
    required this.lastReviewDate,
  });

  final String contentSource;
  final String sourceType;
  final String provenanceOrLicense;
  final TechniqueContentReviewStatus technicalReviewStatus;
  final TechniqueContentReviewStatus scientificReviewStatus;
  final String reviewerRole;
  final String limitations;
  final DateTime lastReviewDate;
}

class GenericTechniqueDetailContent {
  const GenericTechniqueDetailContent({
    required this.name,
    required this.japaneseName,
    required this.category,
    required this.beltLevel,
    required this.difficulty,
    required this.description,
    required this.technicalAnalysis,
    required this.executionSteps,
    required this.keyPoints,
    required this.commonMistakes,
    required this.safetyTips,
    required this.combinations,
    required this.counters,
    required this.applicationContext,
    required this.gripAndStartingPosition,
    required this.kuzushi,
    required this.tsukuri,
    required this.kake,
    required this.makikomiOrFollowThrough,
    required this.variations,
    required this.canonicalCombinationTechniqueIds,
    required this.canonicalCounterTechniqueIds,
    required this.canDisplayVisual,
    required this.visualAssetReference,
    required this.visualAccessibleDescription,
    required this.visualHasConceptualArrows,
    required this.canDisplayVideo,
    required this.videoReference,
    required this.videoAccessibleDescription,
    required this.conceptualInterpretation,
    required this.biomechanicalInterpretation,
    this.evidenceAndReviewStatus,
  });

  final String name;
  final String japaneseName;
  final String category;
  final String beltLevel;
  final String difficulty;
  final String description;
  final String technicalAnalysis;
  final List<String> executionSteps;
  final List<String> keyPoints;
  final List<String> commonMistakes;
  final List<String> safetyTips;
  final List<String> combinations;
  final List<String> counters;
  final String applicationContext;
  final String gripAndStartingPosition;
  final String kuzushi;
  final String tsukuri;
  final String kake;
  final String makikomiOrFollowThrough;
  final List<String> variations;
  final List<String> canonicalCombinationTechniqueIds;
  final List<String> canonicalCounterTechniqueIds;
  final bool canDisplayVisual;
  final String visualAssetReference;
  final String visualAccessibleDescription;
  final bool visualHasConceptualArrows;
  final bool canDisplayVideo;
  final String videoReference;
  final String videoAccessibleDescription;
  final List<ResolvedTechniqueInterpretation> conceptualInterpretation;
  final List<ResolvedTechniqueInterpretation> biomechanicalInterpretation;
  final ResolvedTechniqueEvidenceAndReviewStatus? evidenceAndReviewStatus;

  bool get hasQualifiedConceptualInterpretation =>
      conceptualInterpretation.isNotEmpty;

  bool get hasQualifiedBiomechanicalInterpretation =>
      biomechanicalInterpretation.isNotEmpty;

  bool get hasEvidenceAndReviewStatus => evidenceAndReviewStatus != null;
}

/// Strict presentation adapter for the generic educational route.
///
/// Unlike the Uchi Mata Gold resolver, a missing selected-language field is
/// kept empty so the generic screen can show an explicit unavailable state.
/// The canonical English name remains visible solely as stable identity.
abstract final class GenericTechniqueDetailAdapter {
  const GenericTechniqueDetailAdapter._();

  static GenericTechniqueDetailContent fromTechnique(
    TechniqueModel technique, {
    required String languageCode,
  }) {
    final normalizedLanguage = languageCode
        .trim()
        .toLowerCase()
        .split('-')
        .first;
    final localized = normalizedLanguage == 'en'
        ? null
        : technique.getTranslation(normalizedLanguage);
    final explanation = technique.explanationExtension;
    final extensionReady = explanation.isReadOnlyEducationalReady;
    final evidence = explanation.evidenceAndReviewStatus;

    return GenericTechniqueDetailContent(
      name: _localizedIdentity(localized, technique.englishName),
      japaneseName: technique.japaneseName.trim(),
      category: technique.category.trim(),
      beltLevel: technique.beltLevel.trim(),
      difficulty: technique.difficulty.trim(),
      description: _strictText(
        normalizedLanguage,
        localized?.description,
        technique.description,
      ),
      technicalAnalysis: _strictText(
        normalizedLanguage,
        localized?.technicalAnalysis,
        technique.technicalAnalysis,
      ),
      executionSteps: _strictItems(
        normalizedLanguage,
        localized?.executionSteps,
        technique.executionSteps,
      ),
      keyPoints: _strictItems(
        normalizedLanguage,
        localized?.keyPoints,
        technique.keyPoints,
      ),
      commonMistakes: _strictItems(
        normalizedLanguage,
        localized?.commonMistakes,
        technique.commonMistakes,
      ),
      safetyTips: _strictItems(
        normalizedLanguage,
        localized?.safetyTips,
        technique.safetyTips,
      ),
      combinations: _strictItems(
        normalizedLanguage,
        localized?.combinations,
        technique.combinations,
      ),
      counters: _strictItems(
        normalizedLanguage,
        localized?.counters,
        technique.counters,
      ),
      applicationContext: extensionReady
          ? explanation.applicationContext.resolve(normalizedLanguage)
          : '',
      gripAndStartingPosition: extensionReady
          ? explanation.gripAndStartingPosition.resolve(normalizedLanguage)
          : '',
      kuzushi: extensionReady
          ? explanation.executionPhases.kuzushi.resolve(normalizedLanguage)
          : '',
      tsukuri: extensionReady
          ? explanation.executionPhases.tsukuri.resolve(normalizedLanguage)
          : '',
      kake: extensionReady
          ? explanation.executionPhases.kake.resolve(normalizedLanguage)
          : '',
      makikomiOrFollowThrough: extensionReady
          ? explanation.executionPhases.makikomiOrFollowThrough.resolve(
              normalizedLanguage,
            )
          : '',
      variations: extensionReady
          ? _resolvedExtensionItems(explanation.variations, normalizedLanguage)
          : const [],
      canonicalCombinationTechniqueIds: extensionReady
          ? _canonicalIds(explanation.canonicalCombinationTechniqueIds)
          : const [],
      canonicalCounterTechniqueIds: extensionReady
          ? _canonicalIds(explanation.canonicalCounterTechniqueIds)
          : const [],
      canDisplayVisual:
          extensionReady &&
          explanation.visualExplanation.canDisplayFor(normalizedLanguage),
      visualAssetReference: extensionReady
          ? explanation.visualExplanation.assetReference.trim()
          : '',
      visualAccessibleDescription: extensionReady
          ? explanation.visualExplanation.accessibleDescription.resolve(
              normalizedLanguage,
            )
          : '',
      visualHasConceptualArrows:
          extensionReady &&
          explanation.visualExplanation.hasConceptualDirectionalArrows,
      canDisplayVideo:
          extensionReady &&
          explanation.videoExplanation.canDisplayFor(normalizedLanguage),
      videoReference: extensionReady
          ? explanation.videoExplanation.mediaReference.trim()
          : '',
      videoAccessibleDescription: extensionReady
          ? explanation.videoExplanation.accessibleDescription.resolve(
              normalizedLanguage,
            )
          : '',
      conceptualInterpretation:
          explanation.hasQualifiedConceptualInterpretationFor(
            normalizedLanguage,
          )
          ? _resolvedInterpretations(
              explanation.conceptualMechanicalInterpretation,
              normalizedLanguage,
            )
          : const [],
      biomechanicalInterpretation:
          explanation.hasQualifiedBiomechanicalInterpretationFor(
            normalizedLanguage,
          )
          ? _resolvedInterpretations(
              explanation.biomechanicalInterpretation,
              normalizedLanguage,
            )
          : const [],
      evidenceAndReviewStatus:
          extensionReady &&
              evidence.hasRecordedProvenanceFor(normalizedLanguage)
          ? ResolvedTechniqueEvidenceAndReviewStatus(
              contentSource: evidence.contentSource.trim(),
              sourceType: evidence.sourceType.trim(),
              provenanceOrLicense: evidence.provenanceOrLicense.trim(),
              technicalReviewStatus: evidence.technicalReviewStatus,
              scientificReviewStatus: evidence.scientificReviewStatus,
              reviewerRole: evidence.reviewerRole.trim(),
              limitations: evidence.limitations.resolve(normalizedLanguage),
              lastReviewDate: evidence.lastReviewDate!,
            )
          : null,
    );
  }

  static List<String> _resolvedExtensionItems(
    List<TechniqueLocalizedText> items,
    String languageCode,
  ) => List<String>.unmodifiable(
    items
        .map((item) => item.resolve(languageCode))
        .where((item) => item.isNotEmpty),
  );

  static List<String> _canonicalIds(List<String> ids) =>
      List<String>.unmodifiable(
        ids.map((id) => id.trim()).where(_isCanonicalTechniqueId).toSet(),
      );

  static bool _isCanonicalTechniqueId(String id) =>
      RegExp(r'^\d{3}$').hasMatch(id);

  static List<ResolvedTechniqueInterpretation> _resolvedInterpretations(
    List<TechniqueInterpretationStatement> statements,
    String languageCode,
  ) => List<ResolvedTechniqueInterpretation>.unmodifiable(
    statements.map(
      (statement) => ResolvedTechniqueInterpretation(
        text: statement.text.resolve(languageCode),
        classification: statement.classification,
        limitations: statement.limitations.resolve(languageCode),
      ),
    ),
  );

  static String _localizedIdentity(
    TechniqueTranslation? localized,
    String canonicalName,
  ) {
    final localizedName = localized?.name.trim() ?? '';
    return localizedName.isNotEmpty ? localizedName : canonicalName.trim();
  }

  static String _strictText(
    String languageCode,
    String? localized,
    String canonical,
  ) => languageCode == 'en' ? canonical.trim() : localized?.trim() ?? '';

  static List<String> _strictItems(
    String languageCode,
    List<String>? localized,
    List<String> canonical,
  ) {
    final source = languageCode == 'en' ? canonical : localized ?? const [];
    return List<String>.unmodifiable(
      source.where((item) => item.trim().isNotEmpty).map((item) => item.trim()),
    );
  }
}
