import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/favorite_provider.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_action_button.dart';
import '../../../../core/widgets/judo_badge.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../models/technique_model.dart';

class TechniquePrimaryActions extends StatelessWidget {
  final TechniqueModel technique;
  final VoidCallback onAiAnalysis;
  final VoidCallback onStartTraining;
  final VoidCallback onTrackProgress;

  const TechniquePrimaryActions({
    super.key,
    required this.technique,
    required this.onAiAnalysis,
    required this.onStartTraining,
    required this.onTrackProgress,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider =
        context.watch<FavoriteProvider>();

    final isFavorite =
        favoriteProvider.isFavorite(technique.id);

    return JudoCard(
      borderColor: JudoColors.primary.withValues(
        alpha: 0.45,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: JudoColors.primary.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(
                    JudoRadius.sm,
                  ),
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: JudoColors.primary,
                  size: JudoIconSize.sm,
                ),
              ),

              const SizedBox(
                width: JudoSpacing.md,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continue Your Learning',
                      style:
                          JudoTypography.headingSmall,
                    ),
                    const SizedBox(
                      height: JudoSpacing.xs,
                    ),
                    Text(
                      'Train, analyze and track your progress.',
                      style:
                          JudoTypography.bodySmall,
                    ),
                  ],
                ),
              ),

              const JudoBadge(
                text: 'AI Ready',
                type: JudoBadgeType.ai,
              ),
            ],
          ),

          const SizedBox(
            height: JudoSpacing.lg,
          ),

          JudoActionButton(
            label: 'Analyze My Uchi Mata',
            icon: Icons.smart_toy_outlined,
            trailingIcon:
                Icons.arrow_forward_rounded,
            variant:
                JudoActionButtonVariant.primary,
            onPressed: onAiAnalysis,
          ),

          const SizedBox(
            height: JudoSpacing.sm,
          ),

          Row(
            children: [
              Expanded(
                child: JudoActionButton(
                  label: 'Start Training',
                  icon: Icons
                      .sports_martial_arts_rounded,
                  variant:
                      JudoActionButtonVariant.outline,
                  isExpanded: true,
                  isCompact: true,
                  onPressed: onStartTraining,
                ),
              ),

              const SizedBox(
                width: JudoSpacing.sm,
              ),

              Expanded(
                child: JudoActionButton(
                  label: 'Progress',
                  icon: Icons.insights_rounded,
                  variant:
                      JudoActionButtonVariant.outline,
                  isExpanded: true,
                  isCompact: true,
                  onPressed: onTrackProgress,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: JudoSpacing.sm,
          ),

          JudoActionButton(
            label: isFavorite
                ? 'Remove from Favorites'
                : 'Add to Favorites',
            icon: isFavorite
                ? Icons.bookmark_rounded
                : Icons.bookmark_add_outlined,
            variant:
                JudoActionButtonVariant.ghost,
            isCompact: true,
            onPressed: () async {
              await favoriteProvider.toggleFavorite(
                technique.id,
              );
            },
          ),
        ],
      ),
    );
  }
}