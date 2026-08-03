import '../../models/technique_media_item.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Utility: Media Label Resolver
/// Purpose: Centralized display labels for media cards
/// Version: 1.0.0
/// ----------------------------------------------------------------

class MediaLabelResolver {
  const MediaLabelResolver._();


  static String title(
    TechniqueMediaItem item,
  ) {

    return item.title
        .replaceAll(
          ' — Official Technique Image',
          '',
        )
        .replaceAll(
          ' — Official Image',
          '',
        )
        .replaceAll(
          ' — Technical Demonstration',
          '',
        )
        .replaceAll(
          ' — Training Method',
          '',
        )
        .replaceAll(
          ' — Competition Analysis',
          '',
        )
        .replaceAll(
          ' — 360° Analysis Template',
          '',
        )
        .trim();
  }



  static String source(
    TechniqueMediaItem item,
  ) {

    final value =
        item.sourceName.trim();


    if (value.contains(
      'International Judo Federation',
    )) {
      return 'IJF Archive';
    }


    if (value.contains(
      'Judo Mind Training Library',
    )) {
      return 'Training Library';
    }


    if (value.contains(
      'Judo Mind',
    )) {
      return 'Judo Mind Lab';
    }


    return value;
  }



  static String category(
    TechniqueMediaItem item,
  ) {

    return switch (item.type) {

      TechniqueMediaType.officialImage =>
        'Official Reference',


      TechniqueMediaType.officialDemonstration =>
        'Official Demonstration',


      TechniqueMediaType.trainingVideo =>
        'Training',


      TechniqueMediaType.competitionVideo =>
        'Competition',


      TechniqueMediaType.topExecution =>
        'Top Execution',


      TechniqueMediaType.slowMotion ||
      TechniqueMediaType.animation ||
      TechniqueMediaType.biomechanics ||
      TechniqueMediaType.aiComparison =>
        'AI Analysis',


      TechniqueMediaType.championExample =>
        'Champion Example',
    };
  }



  static String verification(
    TechniqueMediaItem item,
  ) {

    if (item.isVerified) {
      return 'Verified';
    }

    return '';
  }
}