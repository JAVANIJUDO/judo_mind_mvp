import 'package:flutter/foundation.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Model: Technique Media Item
/// Reference Technique: Uchi Mata
/// Version: 1.0.0
/// ----------------------------------------------------------------

enum TechniqueMediaType {
  officialImage,
  officialDemonstration,
  trainingVideo,
  competitionVideo,
  slowMotion,
  animation,
  biomechanics,
  topExecution,
  championExample,
  aiComparison,
}

enum TechniqueMediaSourceType {
  ijf,
  kodokan,
  eju,
  competitionArchive,
  judoMind,
  licensedPartner,
  externalVerified,
}

@immutable
class TechniqueMediaItem {
  final String id;

  /// Localized media title.
  ///
  /// Example:
  /// Uchi Mata — Official IJF Demonstration
  final String title;

  /// Optional short explanation displayed below the title.
  final String description;

  final TechniqueMediaType type;
  final TechniqueMediaSourceType sourceType;

  /// Human-readable source name.
  ///
  /// Example:
  /// International Judo Federation
  final String sourceName;

  /// Video, image or animation address.
  final String mediaUrl;

  /// Local asset path or remote thumbnail address.
  final String thumbnailUrl;

  /// Duration in seconds.
  ///
  /// Use null for images.
  final int? durationSeconds;

  /// Language code such as:
  /// en, fa, fr, ja
  final String languageCode;

  /// Technique level associated with this media item.
  ///
  /// Example:
  /// Beginner, Intermediate, Advanced
  final String level;

  final bool isVerified;
  final bool isPremium;
  final bool isFeatured;

  /// Optional athlete information for competition media.
  final String? athleteName;
  final String? opponentName;
  final String? competitionName;
  final int? competitionYear;

  /// Optional clip position inside a longer video.
  final Duration? startAt;
  final Duration? endAt;

  /// Tactical and technical metadata.
  final String? gripSituation;
  final String? attackDirection;
  final String? executionVariation;
  final String? scoreResult;

  /// Used for manually ordered collections such as Top 10.
  final int sortOrder;

  /// Search and AI classification tags.
  final List<String> tags;

  const TechniqueMediaItem({
    required this.id,
    required this.title,
    required this.type,
    required this.sourceType,
    required this.sourceName,
    required this.mediaUrl,
    this.description = '',
    this.thumbnailUrl = '',
    this.durationSeconds,
    this.languageCode = 'en',
    this.level = '',
    this.isVerified = false,
    this.isPremium = false,
    this.isFeatured = false,
    this.athleteName,
    this.opponentName,
    this.competitionName,
    this.competitionYear,
    this.startAt,
    this.endAt,
    this.gripSituation,
    this.attackDirection,
    this.executionVariation,
    this.scoreResult,
    this.sortOrder = 0,
    this.tags = const [],
  });

  bool get isImage {
    return type == TechniqueMediaType.officialImage;
  }

  bool get isVideo {
    return switch (type) {
      TechniqueMediaType.officialImage => false,
      TechniqueMediaType.animation => false,
      TechniqueMediaType.officialDemonstration ||
      TechniqueMediaType.trainingVideo ||
      TechniqueMediaType.competitionVideo ||
      TechniqueMediaType.slowMotion ||
      TechniqueMediaType.biomechanics ||
      TechniqueMediaType.topExecution ||
      TechniqueMediaType.championExample ||
      TechniqueMediaType.aiComparison =>
        true,
    };
  }

  bool get hasThumbnail {
    return thumbnailUrl.trim().isNotEmpty;
  }

  bool get hasValidMedia {
    return mediaUrl.trim().isNotEmpty;
  }

  String get formattedDuration {
    final seconds = durationSeconds;

    if (seconds == null || seconds <= 0) {
      return '';
    }

    final minutesPart = seconds ~/ 60;
    final secondsPart = seconds % 60;

    return '${minutesPart.toString().padLeft(2, '0')}:'
        '${secondsPart.toString().padLeft(2, '0')}';
  }

  String get mediaTypeLabel {
    return switch (type) {
      TechniqueMediaType.officialImage =>
        'Official Image',
      TechniqueMediaType.officialDemonstration =>
        'Official Demonstration',
      TechniqueMediaType.trainingVideo =>
        'Training Video',
      TechniqueMediaType.competitionVideo =>
        'Competition Video',
      TechniqueMediaType.slowMotion =>
        'Slow Motion',
      TechniqueMediaType.animation =>
        'Animation',
      TechniqueMediaType.biomechanics =>
        'Biomechanics',
      TechniqueMediaType.topExecution =>
        'Top Execution',
      TechniqueMediaType.championExample =>
        'Champion Example',
      TechniqueMediaType.aiComparison =>
        'AI Comparison',
    };
  }

  String get sourceTypeLabel {
    return switch (sourceType) {
      TechniqueMediaSourceType.ijf => 'IJF',
      TechniqueMediaSourceType.kodokan => 'Kodokan',
      TechniqueMediaSourceType.eju => 'EJU',
      TechniqueMediaSourceType.competitionArchive =>
        'Competition Archive',
      TechniqueMediaSourceType.judoMind =>
        'Judo Mind',
      TechniqueMediaSourceType.licensedPartner =>
        'Licensed Partner',
      TechniqueMediaSourceType.externalVerified =>
        'Verified External Source',
    };
  }

  TechniqueMediaItem copyWith({
    String? id,
    String? title,
    String? description,
    TechniqueMediaType? type,
    TechniqueMediaSourceType? sourceType,
    String? sourceName,
    String? mediaUrl,
    String? thumbnailUrl,
    int? durationSeconds,
    String? languageCode,
    String? level,
    bool? isVerified,
    bool? isPremium,
    bool? isFeatured,
    String? athleteName,
    String? opponentName,
    String? competitionName,
    int? competitionYear,
    Duration? startAt,
    Duration? endAt,
    String? gripSituation,
    String? attackDirection,
    String? executionVariation,
    String? scoreResult,
    int? sortOrder,
    List<String>? tags,
  }) {
    return TechniqueMediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description:
          description ?? this.description,
      type: type ?? this.type,
      sourceType:
          sourceType ?? this.sourceType,
      sourceName:
          sourceName ?? this.sourceName,
      mediaUrl:
          mediaUrl ?? this.mediaUrl,
      thumbnailUrl:
          thumbnailUrl ?? this.thumbnailUrl,
      durationSeconds:
          durationSeconds ?? this.durationSeconds,
      languageCode:
          languageCode ?? this.languageCode,
      level: level ?? this.level,
      isVerified:
          isVerified ?? this.isVerified,
      isPremium:
          isPremium ?? this.isPremium,
      isFeatured:
          isFeatured ?? this.isFeatured,
      athleteName:
          athleteName ?? this.athleteName,
      opponentName:
          opponentName ?? this.opponentName,
      competitionName:
          competitionName ?? this.competitionName,
      competitionYear:
          competitionYear ?? this.competitionYear,
      startAt:
          startAt ?? this.startAt,
      endAt:
          endAt ?? this.endAt,
      gripSituation:
          gripSituation ?? this.gripSituation,
      attackDirection:
          attackDirection ?? this.attackDirection,
      executionVariation:
          executionVariation ?? this.executionVariation,
      scoreResult:
          scoreResult ?? this.scoreResult,
      sortOrder:
          sortOrder ?? this.sortOrder,
      tags: tags ?? this.tags,
    );
  }
}