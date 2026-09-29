import 'quiz_model.dart';
import 'technique_media_item.dart';
import 'technique_translation.dart';
import 'technique_visual_learning_model.dart';
import 'technique_training_content.dart';
import 'technique_explanation_content.dart';

class TechniqueModel {
  final String id;

  final String englishName;
  final String japaneseName;

  final String category;
  final String type;
  final String beltLevel;
  final String difficulty;

  final String description;
  final String technicalAnalysis;

  final List<TechniqueTranslation> translations;

  // -----------------------------------------------------------
  // Legacy media fields
  // -----------------------------------------------------------

  final List<String> images;
  final List<String> videos;

  final String trainingVideo;
  final String competitionVideo;

  // -----------------------------------------------------------
  // Professional media architecture
  // -----------------------------------------------------------

  final List<TechniqueMediaItem> mediaItems;

  // -----------------------------------------------------------
  // Three-layer visual learning architecture
  // -----------------------------------------------------------
  //
  // Supports:
  // - Technical execution
  // - Biomechanics
  // - Shadow training
  // - Strength and conditioning
  // - Mobility
  //
  // Each sequence can contain three synchronized layers:
  // 1. Movement
  // 2. Control
  // 3. Biomechanics

  final TechniqueVisualLearningPlan? visualLearningPlan;

  /// Structured future training content. Empty by default; a visual-learning
  /// prototype or generic technique data must not activate a drill.
  final TechniqueTrainingContent trainingContent;

  /// Optional gap-only data for the structured technique-explanation
  /// standard. Empty by default and independent of route/capability gates.
  final TechniqueExplanationExtension explanationExtension;

  // -----------------------------------------------------------
  // Analysis capability gates
  // -----------------------------------------------------------

  /// Enables the human-reviewed Single-Attempt V2A workflow for this
  /// technique. The default is intentionally fail-closed so a future
  /// technique cannot inherit Uchi Mata's reviewed scientific contract.
  final bool supportsReviewedSingleAttemptV2A;

  /// Enables the bounded educational Practice destination for this technique.
  /// The default is fail-closed so structured fields alone cannot silently
  /// activate a training pathway for another production technique.
  final bool supportsEducationalPracticeGuidance;

  // -----------------------------------------------------------
  // Technical learning data
  // -----------------------------------------------------------

  final List<String> executionSteps;
  final List<String> keyPoints;
  final List<String> commonMistakes;
  final List<String> safetyTips;

  final List<String> combinations;
  final List<String> counters;

  final List<QuizModel> quiz;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<TechniqueSource> sources;

  const TechniqueModel({
    required this.id,
    required this.englishName,
    required this.japaneseName,
    required this.category,
    required this.type,
    required this.beltLevel,
    required this.difficulty,
    required this.description,
    required this.technicalAnalysis,
    this.translations = const [],
    required this.images,
    required this.videos,
    required this.trainingVideo,
    required this.competitionVideo,
    this.mediaItems = const [],
    this.visualLearningPlan,
    this.trainingContent = const TechniqueTrainingContent.empty(),
    this.explanationExtension = const TechniqueExplanationExtension.empty(),
    this.supportsReviewedSingleAttemptV2A = false,
    this.supportsEducationalPracticeGuidance = false,
    required this.executionSteps,
    required this.keyPoints,
    required this.commonMistakes,
    required this.safetyTips,
    required this.combinations,
    required this.counters,
    required this.quiz,
    this.createdAt,
    this.updatedAt,
    required this.sources,
  });

  // -----------------------------------------------------------
  // Compatibility with old screens
  // -----------------------------------------------------------

  String get nameEn => englishName;

  String get nameJp => japaneseName;

  String get kuzushi {
    if (executionSteps.isNotEmpty) {
      return executionSteps[0];
    }

    return '';
  }

  String get tsukuri {
    if (executionSteps.length > 1) {
      return executionSteps[1];
    }

    return '';
  }

  String get kake {
    if (executionSteps.length > 2) {
      return executionSteps[2];
    }

    return '';
  }

  List<String> get commonErrors => commonMistakes;

  String get ijfClassification => category;

  String get competitionUsage => competitionVideo;

  String get gripStrategy {
    if (keyPoints.isNotEmpty) {
      return keyPoints.first;
    }

    return '';
  }

  String get bodyPosition {
    if (keyPoints.length > 1) {
      return keyPoints[1];
    }

    return '';
  }

  List<String> get tacticalNotes => keyPoints;

  List<String> get famousUsers => const [];

  /// Dedicated competition insight content is not present in the current
  /// model. A media URL or general counter list must not be reclassified as
  /// competition analysis.
  List<String> get competitionInsights => const [];

  String get aiTrainingAdvice => technicalAnalysis;

  // -----------------------------------------------------------
  // Professional media helpers
  // -----------------------------------------------------------

  bool get hasProfessionalMedia {
    return mediaItems.any((item) => item.hasValidMedia);
  }

  List<TechniqueMediaItem> get verifiedMediaItems {
    return mediaItems
        .where((item) => item.isVerified && item.hasValidMedia)
        .toList(growable: false);
  }

  List<TechniqueMediaItem> get featuredMediaItems {
    final items = mediaItems
        .where((item) => item.isFeatured && item.hasValidMedia)
        .toList();

    items.sort((first, second) => first.sortOrder.compareTo(second.sortOrder));

    return List.unmodifiable(items);
  }

  List<TechniqueMediaItem> mediaByType(TechniqueMediaType mediaType) {
    final items = mediaItems
        .where((item) => item.type == mediaType && item.hasValidMedia)
        .toList();

    items.sort((first, second) => first.sortOrder.compareTo(second.sortOrder));

    return List.unmodifiable(items);
  }

  TechniqueMediaItem? get primaryMediaItem {
    for (final item in featuredMediaItems) {
      if (item.hasThumbnail || item.isImage) {
        return item;
      }
    }

    for (final item in verifiedMediaItems) {
      if (item.hasThumbnail || item.isImage) {
        return item;
      }
    }

    for (final item in mediaItems) {
      if (item.hasValidMedia) {
        return item;
      }
    }

    return null;
  }

  int get professionalMediaCount {
    return mediaItems.where((item) => item.hasValidMedia).length;
  }

  // -----------------------------------------------------------
  // Visual learning helpers
  // -----------------------------------------------------------

  bool get hasVisualLearning {
    return visualLearningPlan?.isNotEmpty ?? false;
  }

  List<TechniqueVisualSequence> visualSequencesByType(
    TechniqueVisualLearningType type,
  ) {
    return visualLearningPlan?.sequencesByType(type) ?? const [];
  }

  bool get hasValidThreeLayerSequence {
    final sequences = visualLearningPlan?.sequences ?? const [];

    return sequences.any((sequence) => sequence.hasThreeLayerArchitecture);
  }

  int get visualSequenceCount {
    return visualLearningPlan?.totalSequences ?? 0;
  }

  bool get hasApprovedEducationalPracticeGuidance {
    return supportsEducationalPracticeGuidance &&
        executionSteps.any((item) => item.trim().isNotEmpty) &&
        keyPoints.any((item) => item.trim().isNotEmpty) &&
        commonMistakes.any((item) => item.trim().isNotEmpty) &&
        safetyTips.any((item) => item.trim().isNotEmpty);
  }

  // -----------------------------------------------------------
  // Localization
  // -----------------------------------------------------------

  TechniqueTranslation? getTranslation(String languageCode) {
    try {
      return translations.firstWhere(
        (item) => item.languageCode == languageCode,
      );
    } catch (_) {
      return null;
    }
  }

  ResolvedTechniqueContent resolveContent(String languageCode) {
    final normalizedLanguage = languageCode.trim().toLowerCase();
    final translation = normalizedLanguage == 'en'
        ? null
        : getTranslation(normalizedLanguage);

    return ResolvedTechniqueContent(
      name: _resolvedText(translation?.name, englishName),
      description: _resolvedText(translation?.description, description),
      technicalAnalysis: _resolvedText(
        translation?.technicalAnalysis,
        technicalAnalysis,
      ),
      executionSteps: _resolvedItems(
        translation?.executionSteps,
        executionSteps,
      ),
      keyPoints: _resolvedItems(translation?.keyPoints, keyPoints),
      commonMistakes: _resolvedItems(
        translation?.commonMistakes,
        commonMistakes,
      ),
      safetyTips: _resolvedItems(translation?.safetyTips, safetyTips),
      combinations: _resolvedItems(translation?.combinations, combinations),
      counters: _resolvedItems(translation?.counters, counters),
    );
  }

  static String _resolvedText(String? localized, String fallback) {
    final localizedValue = localized?.trim() ?? '';
    return localizedValue.isNotEmpty ? localizedValue : fallback.trim();
  }

  static List<String> _resolvedItems(
    List<String>? localized,
    List<String> fallback,
  ) {
    final localizedItems =
        localized
            ?.where((item) => item.trim().isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    final selected = localizedItems.isNotEmpty
        ? localizedItems
        : fallback
              .where((item) => item.trim().isNotEmpty)
              .toList(growable: false);
    return List<String>.unmodifiable(selected);
  }
}

class ResolvedTechniqueContent {
  final String name;
  final String description;
  final String technicalAnalysis;
  final List<String> executionSteps;
  final List<String> keyPoints;
  final List<String> commonMistakes;
  final List<String> safetyTips;
  final List<String> combinations;
  final List<String> counters;

  const ResolvedTechniqueContent({
    required this.name,
    required this.description,
    required this.technicalAnalysis,
    required this.executionSteps,
    required this.keyPoints,
    required this.commonMistakes,
    required this.safetyTips,
    required this.combinations,
    required this.counters,
  });

  String get kuzushi => executionSteps.isNotEmpty ? executionSteps[0] : '';

  String get tsukuri => executionSteps.length > 1 ? executionSteps[1] : '';

  String get kake => executionSteps.length > 2 ? executionSteps[2] : '';
}

class TechniqueSource {
  final String title;
  final String url;

  const TechniqueSource({required this.title, required this.url});
}
