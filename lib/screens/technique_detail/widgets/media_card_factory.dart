import 'media/top_execution_card.dart';
import 'package:flutter/material.dart';
import 'media/competition_analysis_card.dart';
import '../../../models/technique_media_item.dart';
import '../../../core/theme/judo_design_tokens.dart';
import '../../../core/theme/judo_typography.dart';

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
    required String unavailableLabel,
  }) {
    late final Widget card;
    final availableAction = item.hasValidMedia ? onTap : null;

    if (item.type == TechniqueMediaType.competitionVideo ||
        item.type == TechniqueMediaType.championExample) {
      card = CompetitionAnalysisCard(item: item, onTap: availableAction);
    } else if (_isAnalysis(item)) {
      card = AnalysisMediaCard(item: item, onTap: availableAction);
    } else if (item.isImage) {
      card = ImageMediaCard(item: item, onTap: availableAction);
    } else if (item.type == TechniqueMediaType.topExecution) {
      card = TopExecutionCard(item: item, onTap: availableAction);
    } else if (item.isVideo) {
      card = VideoMediaCard(item: item, onTap: availableAction);
    } else {
      card = ImageMediaCard(item: item, onTap: availableAction);
    }

    return Stack(
      key: ValueKey<String>('media-card-${item.id}'),
      children: [
        card,
        if (!item.hasValidMedia)
          PositionedDirectional(
            top: JudoSpacing.sm,
            end: JudoSpacing.sm,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: JudoSpacing.sm,
                  vertical: JudoSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: JudoColors.background.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(JudoRadius.sm),
                  border: Border.all(color: JudoColors.textHint),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: JudoColors.textSecondary,
                    ),
                    const SizedBox(width: JudoSpacing.xs),
                    Text(
                      unavailableLabel,
                      style: JudoTypography.labelSmall.copyWith(
                        color: JudoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  static bool _isAnalysis(TechniqueMediaItem item) {
    return item.type == TechniqueMediaType.aiComparison ||
        item.type == TechniqueMediaType.biomechanics ||
        item.type == TechniqueMediaType.slowMotion;
  }
}
