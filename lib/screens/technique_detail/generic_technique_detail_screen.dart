import 'package:flutter/material.dart';

import '../../core/localization/technique_term_localizer.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../core/theme/judo_typography.dart';
import '../../core/widgets/judo_app_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../models/technique_explanation_content.dart';
import '../../models/technique_model.dart';
import 'generic_technique_detail_adapter.dart';
import 'widgets/content/technique_content_widgets.dart';

/// Evaluation-safe, read-only educational presentation for an explicitly
/// eligible non-Uchi catalog record. It has no analysis, scoring, mastery,
/// diagnosis, prediction, prescription or future-action route. Optional
/// technical/media/evidence fields remain fail-closed behind their own data
/// and provenance contracts.
class GenericTechniqueDetailScreen extends StatelessWidget {
  const GenericTechniqueDetailScreen({super.key, required this.technique});

  final TechniqueModel technique;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = GenericTechniqueDetailAdapter.fromTechnique(
      technique,
      languageCode: Localizations.localeOf(context).languageCode,
    );
    final emptyMessage = l10n.approvedContentUnavailable;
    final hasStructuredPhases = <String>[
      content.kuzushi,
      content.tsukuri,
      content.kake,
    ].any((value) => value.isNotEmpty);

    return Scaffold(
      key: const ValueKey<String>('generic-technique-detail-screen'),
      backgroundColor: JudoColors.background,
      appBar: JudoAppBar(
        title: content.name,
        subtitle: content.japaneseName.isEmpty ? null : content.japaneseName,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          JudoSpacing.md,
          JudoSpacing.lg,
          JudoSpacing.xxxl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content.name, style: JudoTypography.headingLarge),
                if (content.japaneseName.isNotEmpty) ...[
                  const SizedBox(height: JudoSpacing.xs),
                  Text(
                    content.japaneseName,
                    style: JudoTypography.titleMedium.copyWith(
                      color: JudoColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: JudoSpacing.lg),
                TechniqueContentNotice(
                  key: const ValueKey<String>('generic-read-only-boundary'),
                  message: l10n.scientificTransparencySafetyBoundaryDescription,
                  icon: Icons.menu_book_outlined,
                  accentColor: JudoColors.primary,
                ),
                const SizedBox(height: JudoSpacing.lg),
                Wrap(
                  spacing: JudoSpacing.sm,
                  runSpacing: JudoSpacing.sm,
                  children: [
                    TechniqueMetadataItem(
                      label: l10n.category,
                      value: TechniqueTermLocalizer.taxonomy(
                        l10n,
                        content.category,
                      ),
                      unavailableLabel: l10n.unavailableLabel,
                    ),
                    TechniqueMetadataItem(
                      label: l10n.beltLevel,
                      value: TechniqueTermLocalizer.difficulty(
                        l10n,
                        content.beltLevel,
                      ),
                      unavailableLabel: l10n.unavailableLabel,
                    ),
                    TechniqueMetadataItem(
                      label: l10n.difficulty,
                      value: TechniqueTermLocalizer.difficulty(
                        l10n,
                        content.difficulty,
                      ),
                      unavailableLabel: l10n.unavailableLabel,
                    ),
                  ],
                ),
                const SizedBox(height: JudoSpacing.xl),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-overview-section'),
                  title: l10n.overview,
                  icon: Icons.dashboard_customize_outlined,
                  accentColor: JudoColors.primary,
                  initiallyExpanded: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TechniqueTextValue(
                        text: content.description,
                        emptyMessage: emptyMessage,
                        valueKey: const ValueKey<String>(
                          'generic-overview-content',
                        ),
                      ),
                      const SizedBox(height: JudoSpacing.md),
                      _TechniqueTextValue(
                        label: l10n.techniqueApplicationContext,
                        text: content.applicationContext,
                        emptyMessage: l10n.unavailableLabel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-grip-section'),
                  title: l10n.techniqueGripAndStartingPosition,
                  icon: Icons.accessibility_new_rounded,
                  accentColor: JudoColors.primary,
                  child: _TechniqueTextValue(
                    text: content.gripAndStartingPosition,
                    emptyMessage: l10n.unavailableLabel,
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-execution-section'),
                  title: l10n.techniqueExecutionPhases,
                  icon: Icons.format_list_numbered_rounded,
                  accentColor: JudoColors.primary,
                  initiallyExpanded: true,
                  child: hasStructuredPhases
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TechniqueTextValue(
                              label: l10n.kuzushi,
                              text: content.kuzushi,
                              emptyMessage: l10n.unavailableLabel,
                            ),
                            const SizedBox(height: JudoSpacing.md),
                            _TechniqueTextValue(
                              label: l10n.tsukuri,
                              text: content.tsukuri,
                              emptyMessage: l10n.unavailableLabel,
                            ),
                            const SizedBox(height: JudoSpacing.md),
                            _TechniqueTextValue(
                              label: l10n.kake,
                              text: content.kake,
                              emptyMessage: l10n.unavailableLabel,
                            ),
                          ],
                        )
                      : _TechniqueListValue(
                          items: content.executionSteps,
                          emptyMessage: emptyMessage,
                          itemKeyPrefix: 'generic-execution-step',
                        ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-follow-through-section'),
                  title: l10n.techniqueFollowThrough,
                  icon: Icons.rotate_right_rounded,
                  accentColor: JudoColors.primary,
                  child: _TechniqueTextValue(
                    text: content.makikomiOrFollowThrough,
                    emptyMessage: l10n.unavailableLabel,
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-key-points-section'),
                  title: l10n.keyPoints,
                  icon: Icons.key_outlined,
                  accentColor: JudoColors.gold,
                  initiallyExpanded: true,
                  child: _TechniqueListValue(
                    items: content.keyPoints,
                    emptyMessage: emptyMessage,
                    itemKeyPrefix: 'generic-key-point',
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-mistakes-section'),
                  title: l10n.commonMistakes,
                  icon: Icons.warning_amber_rounded,
                  accentColor: JudoColors.danger,
                  child: _TechniqueListValue(
                    items: content.commonMistakes,
                    emptyMessage: emptyMessage,
                    itemKeyPrefix: 'generic-common-mistake',
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-safety-section'),
                  title: l10n.safetyGuidance,
                  icon: Icons.health_and_safety_outlined,
                  accentColor: JudoColors.success,
                  child: _TechniqueListValue(
                    items: content.safetyTips,
                    emptyMessage: emptyMessage,
                    itemKeyPrefix: 'generic-safety-tip',
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-variations-section'),
                  title: l10n.techniqueVariations,
                  icon: Icons.call_split_rounded,
                  accentColor: JudoColors.primary,
                  child: _TechniqueListValue(
                    items: content.variations,
                    emptyMessage: l10n.unavailableLabel,
                    itemKeyPrefix: 'generic-variation',
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-combinations-section'),
                  title: l10n.combinations,
                  icon: Icons.account_tree_outlined,
                  accentColor: JudoColors.primary,
                  child: _TechniqueListValue(
                    items: <String>[
                      ...content.combinations,
                      ...content.canonicalCombinationTechniqueIds,
                    ],
                    emptyMessage: emptyMessage,
                    itemKeyPrefix: 'generic-combination',
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-counters-section'),
                  title: l10n.counters,
                  icon: Icons.swap_horiz_rounded,
                  accentColor: JudoColors.primary,
                  child: _TechniqueListValue(
                    items: <String>[
                      ...content.counters,
                      ...content.canonicalCounterTechniqueIds,
                    ],
                    emptyMessage: emptyMessage,
                    itemKeyPrefix: 'generic-counter',
                  ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-visual-section'),
                  title: l10n.techniqueVisualExplanation,
                  icon: Icons.image_outlined,
                  accentColor: JudoColors.primary,
                  child: content.canDisplayVisual
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TechniqueZoomableVisual(
                              semanticLabel:
                                  content.visualAccessibleDescription,
                              child: Image.asset(
                                content.visualAssetReference,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) =>
                                    TechniqueContentNotice(
                                      message: l10n.unavailableLabel,
                                      icon: Icons.broken_image_outlined,
                                      accentColor: JudoColors.textSecondary,
                                    ),
                              ),
                            ),
                            if (content.visualHasConceptualArrows) ...[
                              const SizedBox(height: JudoSpacing.md),
                              TechniqueContentNotice(
                                key: const ValueKey<String>(
                                  'conceptual-diagram-disclaimer',
                                ),
                                message:
                                    l10n.techniqueConceptualDiagramDisclaimer,
                                icon: Icons.info_outline_rounded,
                                accentColor: JudoColors.primary,
                              ),
                            ],
                          ],
                        )
                      : _TechniqueTextValue(
                          text: '',
                          emptyMessage: l10n.unavailableLabel,
                        ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-video-section'),
                  title: l10n.techniqueVideoExplanation,
                  icon: Icons.play_circle_outline_rounded,
                  accentColor: JudoColors.primary,
                  child: content.canDisplayVideo
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TechniqueTextValue(
                              text: content.videoAccessibleDescription,
                              emptyMessage: l10n.unavailableLabel,
                            ),
                            const SizedBox(height: JudoSpacing.sm),
                            Text(
                              content.videoReference,
                              key: const ValueKey<String>(
                                'generic-video-reference',
                              ),
                              style: JudoTypography.labelSmall.copyWith(
                                color: JudoColors.textSecondary,
                              ),
                            ),
                          ],
                        )
                      : _TechniqueTextValue(
                          text: '',
                          emptyMessage: l10n.unavailableLabel,
                        ),
                ),
                const SizedBox(height: JudoSpacing.md),
                TechniqueExpandableContentSection(
                  key: const ValueKey<String>('generic-technical-section'),
                  title: l10n.techniqueTechnicalExplanation,
                  icon: Icons.school_outlined,
                  accentColor: JudoColors.primary,
                  child: _TechniqueTextValue(
                    text: content.technicalAnalysis,
                    emptyMessage: emptyMessage,
                    valueKey: const ValueKey<String>(
                      'generic-technical-content',
                    ),
                  ),
                ),
                if (content.hasQualifiedConceptualInterpretation) ...[
                  const SizedBox(height: JudoSpacing.md),
                  TechniqueExpandableContentSection(
                    key: const ValueKey<String>(
                      'generic-conceptual-interpretation-section',
                    ),
                    title: l10n.techniqueConceptualMechanicalInterpretation,
                    icon: Icons.schema_outlined,
                    accentColor: JudoColors.primary,
                    child: _TechniqueInterpretationList(
                      items: content.conceptualInterpretation,
                      classificationLabel:
                          l10n.techniqueStatementClassification,
                    ),
                  ),
                ],
                if (content.hasQualifiedBiomechanicalInterpretation) ...[
                  const SizedBox(height: JudoSpacing.md),
                  TechniqueExpandableContentSection(
                    key: const ValueKey<String>(
                      'generic-biomechanical-interpretation-section',
                    ),
                    title: l10n.techniqueBiomechanicalInterpretation,
                    icon: Icons.query_stats_rounded,
                    accentColor: JudoColors.primary,
                    child: _TechniqueInterpretationList(
                      items: content.biomechanicalInterpretation,
                      classificationLabel:
                          l10n.techniqueStatementClassification,
                      measuredLabel: l10n.techniqueMeasuredBiomechanicalResult,
                    ),
                  ),
                ],
                if (content.evidenceAndReviewStatus case final evidence?) ...[
                  const SizedBox(height: JudoSpacing.md),
                  TechniqueExpandableContentSection(
                    key: const ValueKey<String>(
                      'generic-evidence-review-section',
                    ),
                    title: l10n.techniqueEvidenceReviewStatus,
                    icon: Icons.fact_check_outlined,
                    accentColor: JudoColors.primary,
                    child: _TechniqueEvidenceStatus(
                      evidence: evidence,
                      l10n: l10n,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TechniqueTextValue extends StatelessWidget {
  const _TechniqueTextValue({
    required this.text,
    required this.emptyMessage,
    this.label,
    this.valueKey,
  });

  final String? label;
  final String text;
  final String emptyMessage;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final value = text.trim();
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label case final label?) ...[
            Text(label, style: JudoTypography.titleSmall),
            const SizedBox(height: JudoSpacing.xs),
          ],
          Text(
            value.isEmpty ? emptyMessage : value,
            key: valueKey,
            style: JudoTypography.bodyMedium.copyWith(
              color: value.isEmpty
                  ? JudoColors.textSecondary
                  : JudoColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechniqueListValue extends StatelessWidget {
  const _TechniqueListValue({
    required this.items,
    required this.emptyMessage,
    required this.itemKeyPrefix,
  });

  final List<String> items;
  final String emptyMessage;
  final String itemKeyPrefix;

  @override
  Widget build(BuildContext context) {
    final visible = items
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    if (visible.isEmpty) {
      return _TechniqueTextValue(text: '', emptyMessage: emptyMessage);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(
        visible.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: JudoIconSize.sm,
                color: JudoColors.primary,
              ),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(
                child: Text(
                  visible[index],
                  key: ValueKey<String>('$itemKeyPrefix-$index'),
                  style: JudoTypography.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TechniqueInterpretationList extends StatelessWidget {
  const _TechniqueInterpretationList({
    required this.items,
    required this.classificationLabel,
    this.measuredLabel,
  });

  final List<ResolvedTechniqueInterpretation> items;
  final String classificationLabel;
  final String? measuredLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(items.length, (index) {
        final item = items[index];
        final heading =
            item.classification == TechniqueStatementClassification.measured &&
                measuredLabel != null
            ? measuredLabel!
            : '$classificationLabel: ${item.classification.wireValue}';
        return Padding(
          padding: const EdgeInsets.only(bottom: JudoSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading, style: JudoTypography.labelMedium),
              const SizedBox(height: JudoSpacing.xs),
              Text(item.text, style: JudoTypography.bodyMedium),
              const SizedBox(height: JudoSpacing.xs),
              Text(
                item.limitations,
                style: JudoTypography.bodySmall.copyWith(
                  color: JudoColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TechniqueEvidenceStatus extends StatelessWidget {
  const _TechniqueEvidenceStatus({required this.evidence, required this.l10n});

  final ResolvedTechniqueEvidenceAndReviewStatus evidence;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      (l10n.techniqueContentSource, evidence.contentSource),
      (l10n.techniqueSourceType, evidence.sourceType),
      (l10n.techniqueProvenanceLicense, evidence.provenanceOrLicense),
      (
        l10n.techniqueTechnicalReviewStatus,
        _reviewStatusLabel(l10n, evidence.technicalReviewStatus),
      ),
      (
        l10n.techniqueScientificReviewStatus,
        _reviewStatusLabel(l10n, evidence.scientificReviewStatus),
      ),
      (l10n.techniqueReviewerRole, evidence.reviewerRole),
      (l10n.metricLimitationLabel, evidence.limitations),
      (
        l10n.techniqueLastReviewDate,
        evidence.lastReviewDate.toIso8601String().split('T').first,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
              child: _TechniqueTextValue(
                label: row.$1,
                text: row.$2,
                emptyMessage: '',
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

String _reviewStatusLabel(
  AppLocalizations l10n,
  TechniqueContentReviewStatus status,
) => switch (status) {
  TechniqueContentReviewStatus.notReviewed => l10n.techniqueReviewNotReviewed,
  TechniqueContentReviewStatus.reviewRequired => l10n.techniqueReviewRequired,
  TechniqueContentReviewStatus.reviewed => l10n.techniqueReviewRecorded,
};
