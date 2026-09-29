import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/localization/technique_term_localizer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';

class OverviewSection extends StatelessWidget {
  final TechniqueModel technique;

  const OverviewSection({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = technique.resolveContent(
      Localizations.localeOf(context).languageCode,
    );
    final beltLevel = technique.beltLevel.trim();
    final difficulty = technique.difficulty.trim();
    final showBeltLevel =
        beltLevel.isNotEmpty &&
        beltLevel.toLowerCase() != difficulty.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: JudoSpacing.sm,
          runSpacing: JudoSpacing.sm,
          children: [
            TechniqueMetadataItem(
              label: l10n.japaneseName,
              value: technique.japaneseName,
              unavailableLabel: l10n.unavailableLabel,
            ),
            TechniqueMetadataItem(
              label: l10n.classification,
              value: TechniqueTermLocalizer.taxonomy(l10n, technique.category),
              unavailableLabel: l10n.unavailableLabel,
            ),
            TechniqueMetadataItem(
              label: l10n.techniqueType,
              value: TechniqueTermLocalizer.taxonomy(l10n, technique.type),
              unavailableLabel: l10n.unavailableLabel,
            ),
            if (showBeltLevel)
              TechniqueMetadataItem(
                label: l10n.beltLevel,
                value: beltLevel,
                unavailableLabel: l10n.unavailableLabel,
              ),
            if (difficulty.isNotEmpty)
              TechniqueMetadataItem(
                label: l10n.difficulty,
                value: TechniqueTermLocalizer.difficulty(l10n, difficulty),
                unavailableLabel: l10n.unavailableLabel,
              ),
          ],
        ),
        const SizedBox(height: JudoSpacing.lg),
        TechniqueTextContent(
          title: l10n.description,
          text: content.description,
          emptyMessage: l10n.approvedContentUnavailable,
          icon: Icons.info_outline_rounded,
          accentColor: JudoColors.primary,
          contentKey: const ValueKey<String>('overview-description'),
        ),
      ],
    );
  }
}
