import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_badge.dart';
import '../../../../models/technique_model.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Widget: Technique Hero Section
/// Module: Techniques
/// Design System: 1.0
/// ----------------------------------------------------------------
///
/// Responsibilities:
/// - Display the technique identity only once.
/// - Display localized technique title.
/// - Display Japanese technique name.
/// - Display official, category and difficulty badges.
///
/// Favorite control belongs to JudoAppBar and must not be duplicated
/// inside this component.
class HeroSection extends StatelessWidget {
  final TechniqueModel technique;
  final String title;

  const HeroSection({
    super.key,
    required this.technique,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final titleStyle =
            JudoTypography.responsiveTechniqueTitle(
          constraints.maxWidth,
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: JudoSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),

              if (technique.japaneseName.trim().isNotEmpty) ...[
                const SizedBox(height: JudoSpacing.xs),
                Text(
                  technique.japaneseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: JudoTypography.headingSmall.copyWith(
                    color: JudoColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: JudoSpacing.md),

              Wrap(
                spacing: JudoSpacing.sm,
                runSpacing: JudoSpacing.sm,
                children: [
                  const JudoBadge(
                    text: 'Official',
                    type: JudoBadgeType.official,
                  ),

                  if (technique.category.trim().isNotEmpty)
                    JudoBadge(
                      text: technique.category,
                      type: JudoBadgeType.verified,
                      icon: Icons.category_outlined,
                    ),

                  if (technique.type.trim().isNotEmpty)
                    JudoBadge(
                      text: technique.type,
                      type: JudoBadgeType.success,
                      icon: Icons.sports_martial_arts_outlined,
                    ),

                  if (technique.difficulty.trim().isNotEmpty)
                    JudoBadge(
                      text: technique.difficulty,
                      type: _difficultyBadgeType(
                        technique.difficulty,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  JudoBadgeType _difficultyBadgeType(
    String difficulty,
  ) {
    final normalized = difficulty
        .trim()
        .toLowerCase();

    if (normalized.contains('beginner') ||
        normalized.contains('basic')) {
      return JudoBadgeType.beginner;
    }

    if (normalized.contains('advanced') ||
        normalized.contains('expert')) {
      return JudoBadgeType.advanced;
    }

    return JudoBadgeType.success;
  }
}