import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_badge.dart';
import '../../../../core/widgets/judo_card.dart';

class TechniqueSectionPlaceholder extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final bool isPremium;
  final bool isAiFeature;
  final List<String> plannedFeatures;

  const TechniqueSectionPlaceholder({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    this.isPremium = false,
    this.isAiFeature = false,
    this.plannedFeatures = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(
                  JudoRadius.sm,
                ),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: JudoIconSize.sm,
              ),
            ),
            const SizedBox(width: JudoSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: JudoTypography.headingSmall.copyWith(
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: JudoSpacing.xs),
                  Text(
                    description,
                    style: JudoTypography.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),

        if (isPremium || isAiFeature) ...[
          const SizedBox(height: JudoSpacing.md),
          Wrap(
            spacing: JudoSpacing.sm,
            runSpacing: JudoSpacing.sm,
            children: [
              if (isAiFeature)
                const JudoBadge(
                  text: 'AI',
                  type: JudoBadgeType.ai,
                ),
              if (isPremium)
                const JudoBadge(
                  text: 'Advanced',
                  type: JudoBadgeType.premium,
                ),
            ],
          ),
        ],

        if (plannedFeatures.isNotEmpty) ...[
          const SizedBox(height: JudoSpacing.lg),
          ...plannedFeatures.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(
                bottom: JudoSpacing.sm,
              ),
              child: JudoCard(
                padding: const EdgeInsets.all(
                  JudoSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: accentColor,
                      size: JudoIconSize.sm,
                    ),
                    const SizedBox(width: JudoSpacing.sm),
                    Expanded(
                      child: Text(
                        feature,
                        style: JudoTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}