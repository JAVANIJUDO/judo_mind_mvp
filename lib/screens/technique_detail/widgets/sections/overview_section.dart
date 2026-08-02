import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../models/technique_model.dart';

class OverviewSection extends StatelessWidget {
  final TechniqueModel technique;

  const OverviewSection({
    super.key,
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OverviewBlock(
          title: 'Description',
          icon: Icons.info_outline_rounded,
          text: technique.description,
        ),

        const SizedBox(
          height: JudoSpacing.lg,
        ),

        const _OverviewBlock(
          title: 'Purpose of Technique',
          icon: Icons.flag_outlined,
          text:
              'Understanding the main objective, tactical purpose and execution philosophy of this technique.',
        ),

        const SizedBox(
          height: JudoSpacing.lg,
        ),

        const _OverviewBlock(
          title: 'When To Use',
          icon: Icons.sports_martial_arts_outlined,
          text:
              'Analyze suitable combat situations, opponent reactions and opportunities to apply the technique effectively.',
        ),

        const SizedBox(
          height: JudoSpacing.lg,
        ),

        const _OverviewBlock(
          title: 'Key Learning Points',
          icon: Icons.school_outlined,
          text:
              'Focus on kuzushi, tsukuri, kake, body position, timing and balance control.',
        ),

        const SizedBox(
          height: JudoSpacing.lg,
        ),

        const _OverviewBlock(
          title: 'Common Application',
          icon: Icons.psychology_outlined,
          text:
              'Technical combinations, competition situations and practical application scenarios will be added in the advanced analysis module.',
        ),
      ],
    );
  }
}

class _OverviewBlock extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;

  const _OverviewBlock({
    required this.title,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        JudoSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(
          JudoRadius.lg,
        ),
        border: Border.all(
          color: JudoColors.primary.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: JudoColors.primary.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                JudoRadius.sm,
              ),
            ),
            child: Icon(
              icon,
              color: JudoColors.primary,
              size: 21,
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
                  title,
                  style:
                      JudoTypography.titleMedium,
                ),

                const SizedBox(
                  height: JudoSpacing.sm,
                ),

                Text(
                  text,
                  style:
                      JudoTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}