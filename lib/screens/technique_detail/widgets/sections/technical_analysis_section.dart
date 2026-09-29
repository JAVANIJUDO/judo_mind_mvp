import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';
import '../visual_learning/technique_phase_visual_guide.dart';

class TechnicalAnalysisSection extends StatelessWidget {
  final TechniqueModel technique;

  const TechnicalAnalysisSection({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = technique.resolveContent(
      Localizations.localeOf(context).languageCode,
    );
    final completionSteps = content.executionSteps.length > 3
        ? content.executionSteps.skip(3).toList(growable: false)
        : const <String>[];
    final phaseItems = <TechniquePhaseVisualItem>[
      if (content.kuzushi.isNotEmpty)
        TechniquePhaseVisualItem(
          id: 'kuzushi',
          label: l10n.kuzushi,
          instruction: content.kuzushi,
        ),
      if (content.tsukuri.isNotEmpty)
        TechniquePhaseVisualItem(
          id: 'tsukuri',
          label: l10n.tsukuri,
          instruction: content.tsukuri,
        ),
      if (content.kake.isNotEmpty)
        TechniquePhaseVisualItem(
          id: 'kake',
          label: l10n.kake,
          instruction: content.kake,
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TechniqueTextContent(
          title: l10n.technicalAnalysis,
          text: content.technicalAnalysis,
          emptyMessage: l10n.approvedContentUnavailable,
          icon: Icons.analytics_outlined,
          accentColor: JudoColors.primary,
          contentKey: const ValueKey<String>('technical-analysis-summary'),
        ),
        const SizedBox(height: JudoSpacing.xl),
        if (phaseItems.isEmpty)
          TechniqueContentList(
            title: l10n.classicalPhases,
            items: const [],
            emptyMessage: l10n.approvedContentUnavailable,
            icon: Icons.account_tree_outlined,
            accentColor: JudoColors.primary,
            itemKeyPrefix: 'technical-phase',
          )
        else ...[
          Text(
            l10n.classicalPhases,
            style: JudoTypography.headingSmall.copyWith(
              color: JudoColors.primary,
            ),
          ),
          const SizedBox(height: JudoSpacing.sm),
          Text(
            l10n.visualPhaseGuidanceDescription,
            style: JudoTypography.bodyMedium.copyWith(
              color: JudoColors.textSecondary,
            ),
          ),
          const SizedBox(height: JudoSpacing.lg),
          TechniquePhaseVisualGuide(phases: phaseItems),
        ],
        const SizedBox(height: JudoSpacing.xl),
        TechniqueContentList(
          title: l10n.additionalExecutionSteps,
          items: completionSteps,
          emptyMessage: l10n.noAdditionalExecutionSteps,
          icon: Icons.format_list_numbered_rounded,
          accentColor: JudoColors.primary,
          itemKeyPrefix: 'technical-completion-step',
        ),
        const SizedBox(height: JudoSpacing.xl),
        TechniqueContentList(
          title: l10n.keyPoints,
          items: content.keyPoints,
          emptyMessage: l10n.approvedContentUnavailable,
          icon: Icons.checklist_rounded,
          accentColor: JudoColors.primary,
          itemKeyPrefix: 'technical-key-point',
        ),
      ],
    );
  }
}
