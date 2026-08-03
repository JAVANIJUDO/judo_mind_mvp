import 'package:flutter/material.dart';
import '../../../../core/media/media_label_resolver.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../models/technique_media_item.dart';

class AnalysisMediaCard extends StatelessWidget {
  final TechniqueMediaItem item;
  final VoidCallback onTap;

  const AnalysisMediaCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final analysis = item.analysis;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(JudoRadius.lg),

        child: Ink(
          padding: const EdgeInsets.all(JudoSpacing.md),

          decoration: BoxDecoration(
            color: JudoColors.surface,

            borderRadius: BorderRadius.circular(JudoRadius.lg),

            border: Border.all(color: JudoColors.gold.withValues(alpha: 0.35)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Container(
                    width: 42,

                    height: 42,

                    decoration: BoxDecoration(
                      color: JudoColors.gold.withValues(alpha: 0.15),

                      borderRadius: BorderRadius.circular(JudoRadius.md),
                    ),

                    child: const Icon(
                      Icons.psychology_alt_rounded,

                      color: JudoColors.gold,

                      size: 25,
                    ),
                  ),

                  const SizedBox(width: JudoSpacing.md),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                      Text(
  item.title
      .replaceAll(' — 360° Analysis Template', '')
      .replaceAll(' — AI Comparison', '')
      .replaceAll(' — Biomechanics Analysis', ''),

  maxLines: 1,

  overflow: TextOverflow.ellipsis,

  style: JudoTypography.titleSmall,
),

const SizedBox(
  height: JudoSpacing.xs,
),

Row(
  children: [

    const Icon(
      Icons.psychology_alt_rounded,
      size: 15,
      color: JudoColors.gold,
    ),

    const SizedBox(
      width: 5,
    ),

    Text(
  MediaLabelResolver.category(item),

  style: JudoTypography.bodySmall.copyWith(
    color: JudoColors.gold,
  ),
),
  ],
),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: JudoSpacing.lg),

              _AnalysisRow(
                title: 'Opponent Guard',

                value: analysis?.opponentGuard ?? 'Not analyzed',
              ),

              _AnalysisRow(
                title: 'Kuzushi',

                value: analysis?.kuzushiDirection ?? 'Not analyzed',
              ),

              _AnalysisRow(
                title: 'Balance',

                value: analysis?.balanceAnalysis ?? 'Not analyzed',
              ),

              _AnalysisRow(
                title: 'Timing',

                value: analysis?.attackTiming ?? 'Not analyzed',
              ),

              const SizedBox(height: JudoSpacing.md),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(vertical: JudoSpacing.sm),

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: JudoColors.gold.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(JudoRadius.md),
                ),

                child: const Text(
                  'Open Analysis',

                  style: TextStyle(
                    color: JudoColors.gold,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  final String title;
  final String value;

  const _AnalysisRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),

      child: Row(
        children: [
          Expanded(child: Text(title, style: JudoTypography.bodySmall)),

          Flexible(
            child: Text(
              value,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.end,

              style: JudoTypography.bodySmall.copyWith(color: JudoColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}
