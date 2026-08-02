import 'quiz_model.dart';
import 'technique_media_item.dart';
import 'technique_translation.dart';

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
  //
  // These fields remain temporarily for backward compatibility.
  // New content must gradually migrate to mediaItems.

  final List<String> images;
  final List<String> videos;

  final String trainingVideo;
  final String competitionVideo;

  // -----------------------------------------------------------
  // Professional media architecture
  // -----------------------------------------------------------

  final List<TechniqueMediaItem> mediaItems;

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

  List<String> get competitionInsights {
    if (competitionVideo.isEmpty) {
      return const [];
    }

    return [competitionVideo];
  }

  String get aiTrainingAdvice => technicalAnalysis;

  // -----------------------------------------------------------
  // Professional media helpers
  // -----------------------------------------------------------

  bool get hasProfessionalMedia {
    return mediaItems.any(
      (item) => item.hasValidMedia,
    );
  }

  List<TechniqueMediaItem> get verifiedMediaItems {
    return mediaItems
        .where(
          (item) =>
              item.isVerified &&
              item.hasValidMedia,
        )
        .toList(growable: false);
  }

  List<TechniqueMediaItem> get featuredMediaItems {
    final items = mediaItems
        .where(
          (item) =>
              item.isFeatured &&
              item.hasValidMedia,
        )
        .toList();

    items.sort(
      (first, second) =>
          first.sortOrder.compareTo(
        second.sortOrder,
      ),
    );

    return List.unmodifiable(items);
  }

  List<TechniqueMediaItem> mediaByType(
    TechniqueMediaType mediaType,
  ) {
    final items = mediaItems
        .where(
          (item) =>
              item.type == mediaType &&
              item.hasValidMedia,
        )
        .toList();

    items.sort(
      (first, second) =>
          first.sortOrder.compareTo(
        second.sortOrder,
      ),
    );

    return List.unmodifiable(items);
  }

  TechniqueMediaItem? get primaryMediaItem {
    for (final item in featuredMediaItems) {
      if (item.hasThumbnail ||
          item.isImage) {
        return item;
      }
    }

    for (final item in verifiedMediaItems) {
      if (item.hasThumbnail ||
          item.isImage) {
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
    return mediaItems
        .where(
          (item) => item.hasValidMedia,
        )
        .length;
  }

  // -----------------------------------------------------------
  // Localization
  // -----------------------------------------------------------

  TechniqueTranslation? getTranslation(
    String languageCode,
  ) {
    try {
      return translations.firstWhere(
        (item) =>
            item.languageCode ==
            languageCode,
      );
    } catch (_) {
      return null;
    }
  }
}

class TechniqueSource {
  final String title;
  final String url;

  const TechniqueSource({
    required this.title,
    required this.url,
  });
}