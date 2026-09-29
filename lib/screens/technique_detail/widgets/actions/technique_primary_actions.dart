import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_action_button.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';

/// The single technique-local entry into Single-Attempt Analysis.
///
/// Training, history, favorites and Grounded Sensei are deliberately owned by
/// their dedicated destinations instead of being repeated in this card.
class TechniquePrimaryActions extends StatelessWidget {
  const TechniquePrimaryActions({
    super.key,
    required this.technique,
    required this.onAiAnalysis,
  });

  final TechniqueModel technique;
  final VoidCallback onAiAnalysis;

  @override
  Widget build(BuildContext context) {
    if (!technique.supportsReviewedSingleAttemptV2A) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final techniqueName = technique
        .resolveContent(Localizations.localeOf(context).languageCode)
        .name;

    return JudoCard(
      key: const ValueKey<String>('technique-single-attempt-entry'),
      borderColor: JudoColors.gold.withValues(alpha: 0.55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.journeyAnalyzeTitle,
            style: JudoTypography.headingSmall.copyWith(color: JudoColors.gold),
          ),
          const SizedBox(height: JudoSpacing.xs),
          Text(l10n.journeyAnalyzeDescription, style: JudoTypography.bodySmall),
          const SizedBox(height: JudoSpacing.lg),
          JudoActionButton(
            key: const ValueKey<String>('technique-analyze-action'),
            label: l10n.analyzeTechnique(techniqueName),
            icon: Icons.analytics_outlined,
            trailingIcon: Icons.arrow_forward_rounded,
            variant: JudoActionButtonVariant.primary,
            onPressed: onAiAnalysis,
          ),
        ],
      ),
    );
  }
}
