import 'package:flutter/material.dart';

import '../../../../core/design_system/icons/judo_icons.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';

/// Presents approved combinations and counters as two independent branches
/// from the selected technique. It does not imply a pairing or transition
/// between list entries that the source model does not define.
class TechniqueCombinationCounterFlow extends StatelessWidget {
  const TechniqueCombinationCounterFlow({super.key, required this.technique});

  final TechniqueModel technique;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = technique.resolveContent(
      Localizations.localeOf(context).languageCode,
    );

    return Column(
      key: const ValueKey<String>('combination-counter-distinct-renderer'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudoCard(
          borderColor: JudoColors.primary.withValues(alpha: 0.42),
          child: Row(
            children: [
              const Icon(
                JudoIcons.throwTechnique,
                color: JudoColors.primary,
                size: JudoIconSize.md,
              ),
              const SizedBox(width: JudoSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.flowFromTechniqueLabel,
                      style: JudoTypography.labelSmall.copyWith(
                        color: JudoColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: JudoSpacing.xs),
                    Text(
                      content.name,
                      style: JudoTypography.titleLarge.copyWith(
                        color: JudoColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: JudoSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final useColumns = constraints.maxWidth >= 680;
            final combinations = _FlowBranch(
              title: l10n.combinations,
              items: content.combinations,
              emptyMessage: l10n.noCombinations,
              icon: JudoIcons.combination,
              accentColor: JudoColors.success,
              itemKeyPrefix: 'combination-flow',
            );
            final counters = _FlowBranch(
              title: l10n.counters,
              items: content.counters,
              emptyMessage: l10n.noCounters,
              icon: JudoIcons.counter,
              accentColor: JudoColors.warning,
              itemKeyPrefix: 'counter-flow',
            );

            if (!useColumns) {
              return Column(
                children: [
                  combinations,
                  const SizedBox(height: JudoSpacing.xl),
                  counters,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: combinations),
                const SizedBox(width: JudoSpacing.lg),
                Expanded(child: counters),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FlowBranch extends StatelessWidget {
  const _FlowBranch({
    required this.title,
    required this.items,
    required this.emptyMessage,
    required this.icon,
    required this.accentColor,
    required this.itemKeyPrefix,
  });

  final String title;
  final List<String> items;
  final String emptyMessage;
  final IconData icon;
  final Color accentColor;
  final String itemKeyPrefix;

  @override
  Widget build(BuildContext context) {
    final visibleItems = items
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);

    return Semantics(
      container: true,
      label: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: JudoIconSize.sm),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: JudoTypography.headingSmall.copyWith(
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: JudoSpacing.md),
          if (visibleItems.isEmpty)
            TechniqueContentNotice(
              key: ValueKey<String>('$itemKeyPrefix-empty'),
              message: emptyMessage,
              icon: Icons.info_outline_rounded,
              accentColor: JudoColors.textSecondary,
            )
          else
            ...List<Widget>.generate(visibleItems.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 54,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(JudoRadius.xs),
                      ),
                    ),
                    const SizedBox(width: JudoSpacing.sm),
                    Expanded(
                      child: JudoCard(
                        key: ValueKey<String>('$itemKeyPrefix-$index'),
                        padding: const EdgeInsets.all(JudoSpacing.md),
                        borderColor: accentColor.withValues(alpha: 0.32),
                        child: Text(
                          visibleItems[index],
                          style: JudoTypography.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
