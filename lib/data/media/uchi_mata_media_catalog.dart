import '../../models/media_analysis_metadata.dart';
import '../../models/technique_media_item.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Media Catalog: Uchi Mata
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Central media repository for Uchi Mata.
///
/// All future techniques will follow this structure.
///
/// Categories:
/// - Official Media
/// - Training
/// - Competition
/// - Top Executions
/// - Biomechanics
/// - AI Analysis
abstract final class UchiMataMediaCatalog {
  const UchiMataMediaCatalog._();

  static const List<TechniqueMediaItem> items = [
    TechniqueMediaItem(
      id: 'uchi-mata-official-image-001',

      title:
          'Uchi Mata — Official Technique Image',

      description:
          'Official technical reference image for Uchi Mata.',

      type:
          TechniqueMediaType.officialImage,

      sourceType:
          TechniqueMediaSourceType.judoMind,

      sourceName:
          'Judo Mind Verified Library',

      mediaUrl:
          'assets/images/techniques/uchi_mata.png',

      thumbnailUrl:
          'assets/images/techniques/uchi_mata.png',

      level:
          'Advanced',

      isVerified: true,

      isFeatured: true,

      sortOrder: 1,

      tags: [
        'Uchi Mata',
        'Nage Waza',
        'Ashi Waza',
        'Official Image',
      ],
    ),


    TechniqueMediaItem(
      id:
          'uchi-mata-demo-placeholder-001',

      title:
          'Uchi Mata — Technical Demonstration',

      description:
          'Official demonstration placeholder. Replace with approved direct video source.',

      type:
          TechniqueMediaType.officialDemonstration,

      sourceType:
          TechniqueMediaSourceType.ijf,

      sourceName:
          'IJF Verified Archive',

      mediaUrl:
          '',

      level:
          'Advanced',

      isVerified:
          true,

      sortOrder:
          2,

      tags: [
        'Technical Demonstration',
        'IJF',
      ],
    ),


    TechniqueMediaItem(
      id:
          'uchi-mata-training-placeholder-001',

      title:
          'Uchi Mata — Training Method',

      description:
          'Training drills and technical progression.',

      type:
          TechniqueMediaType.trainingVideo,

      sourceType:
          TechniqueMediaSourceType.judoMind,

      sourceName:
          'Judo Mind Training Library',

      mediaUrl:
          '',

      level:
          'Advanced',

      isPremium:
          true,

      sortOrder:
          3,

      tags: [
        'Training',
        'Drills',
        'Progression',
      ],
    ),


    TechniqueMediaItem(
      id:
          'uchi-mata-analysis-template-001',

      title:
          'Uchi Mata — 360° Analysis Template',

      description:
          'Biomechanical and tactical analysis structure.',

      type:
          TechniqueMediaType.aiComparison,

      sourceType:
          TechniqueMediaSourceType.judoMind,

      sourceName:
          'Sensi Bot AI Lab',

      mediaUrl:
          '',

      level:
          'Advanced',

      isPremium:
          true,

      analysis:
    const MediaAnalysisMetadata(
            opponentGuard:
                'To be analyzed',

            opponentStance:
                'To be analyzed',

            attackTiming:
                'To be analyzed',

            kuzushiDirection:
                'To be analyzed',

            balanceAnalysis:
                'To be analyzed',

            entryAngle:
                'To be analyzed',

            hipPosition:
                'To be analyzed',

            footPlacement:
                'To be analyzed',
          ),

      sortOrder:
          4,

      tags: [
        'AI Analysis',
        'Biomechanics',
        '360 Analysis',
      ],
    ),
  ];
}