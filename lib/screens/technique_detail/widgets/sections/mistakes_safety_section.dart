import 'package:flutter/material.dart';

import '../../../../core/design_system/icons/judo_icons.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';

/// A model-driven, visually distinct learning artifact for approved mistakes
/// and safety guidance. It never fabricates a correction or consequence when
/// the technique contract does not provide one.
class TechniqueMistakesSafetySection extends StatelessWidget {
  const TechniqueMistakesSafetySection({super.key, required this.technique});

  final TechniqueModel technique;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = technique.resolveContent(
      Localizations.localeOf(context).languageCode,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumns = constraints.maxWidth >= 680;
        final mistakePanel = _EvidencePanel(
          key: const ValueKey<String>('mistakes-distinct-renderer'),
          title: l10n.commonMistakes,
          emptyMessage: l10n.noCommonMistakes,
          itemLabel: l10n.mistakeReviewPointLabel,
          items: content.commonMistakes,
          icon: JudoIcons.mistakesAndSafety,
          accentColor: JudoColors.danger,
          itemKeyPrefix: 'mistake-evidence',
        );
        final safetyPanel = _EvidencePanel(
          key: const ValueKey<String>('safety-distinct-renderer'),
          title: l10n.safetyGuidance,
          emptyMessage: l10n.noSafetyGuidance,
          itemLabel: l10n.safetyGuidanceItemLabel,
          items: content.safetyTips,
          icon: Icons.shield_outlined,
          accentColor: JudoColors.warning,
          itemKeyPrefix: 'safety-evidence',
        );

        if (!useColumns) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mistakePanel,
              const SizedBox(height: JudoSpacing.xl),
              safetyPanel,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: mistakePanel),
            const SizedBox(width: JudoSpacing.lg),
            Expanded(child: safetyPanel),
          ],
        );
      },
    );
  }
}

class _EvidencePanel extends StatelessWidget {
  const _EvidencePanel({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.itemLabel,
    required this.items,
    required this.icon,
    required this.accentColor,
    required this.itemKeyPrefix,
  });

  final String title;
  final String emptyMessage;
  final String itemLabel;
  final List<String> items;
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
                child: JudoCard(
                  key: ValueKey<String>('$itemKeyPrefix-$index'),
                  borderColor: accentColor.withValues(alpha: 0.38),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(JudoRadius.sm),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: JudoTypography.labelMedium.copyWith(
                            color: accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: JudoSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemLabel,
                              style: JudoTypography.labelSmall.copyWith(
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(height: JudoSpacing.xs),
                            Text(
                              visibleItems[index],
                              style: JudoTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
