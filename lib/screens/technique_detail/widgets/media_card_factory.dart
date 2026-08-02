import 'package:flutter/material.dart';

import '../../../../models/technique_media_item.dart';

import 'media/image_media_card.dart';
import 'media/video_media_card.dart';
import 'media/analysis_media_card.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Component: Media Card Factory
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Decides the correct UI card based on media type.
///
/// Image:
/// - Official technique images
///
/// Video:
/// - Training
/// - Competition
/// - Demonstration
///
/// Analysis:
/// - AI comparison
/// - Biomechanics
/// - 360 analysis
abstract final class MediaCardFactory {
  const MediaCardFactory._();

  static Widget build({
    required TechniqueMediaItem item,
    required VoidCallback onTap,
  }) {
    if (_isAnalysis(item)) {
      return AnalysisMediaCard(
        item: item,
        onTap: onTap,
      );
    }

    if (item.isImage) {
      return ImageMediaCard(
        item: item,
        onTap: onTap,
      );
    }

    if (item.isVideo) {
      return VideoMediaCard(
        item: item,
        onTap: onTap,
      );
    }

    return ImageMediaCard(
      item: item,
      onTap: onTap,
    );
  }

  static bool _isAnalysis(
    TechniqueMediaItem item,
  ) {
    return item.type ==
            TechniqueMediaType.aiComparison ||
        item.type ==
            TechniqueMediaType.biomechanics ||
        item.type ==
            TechniqueMediaType.slowMotion;
  }
}