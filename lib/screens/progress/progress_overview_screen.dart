import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/local_attempt_history_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../core/theme/judo_typography.dart';
import '../../data/techniques/technique_factory.dart';
import '../../l10n/app_localizations.dart';
import '../../models/local_attempt_history_record.dart';
import '../../models/progress_evidence_summary.dart';
import '../../models/single_attempt_analysis_v2a.dart';
import '../technique_detail/widgets/sections/technique_section_router.dart';
import '../technique_detail/widgets/technique_dashboard_grid.dart';

/// Evidence-only progress presentation over the existing local V2A History.
/// It deliberately contains no mastery, ranking, score, trend or comparison.
class ProgressOverviewScreen extends StatelessWidget {
  const ProgressOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: AppBar(title: Text(l10n.progressOverviewTitle)),
      body: Consumer<LocalAttemptHistoryProvider>(
        builder: (context, provider, child) {
          return switch (provider.loadState) {
            LocalAttemptHistoryLoadState.initial ||
            LocalAttemptHistoryLoadState.loading => const Center(
              key: ValueKey('progress-loading'),
              child: CircularProgressIndicator(),
            ),
            LocalAttemptHistoryLoadState.failure => _ProgressStatePage(
              key: const ValueKey('progress-storage-failure'),
              icon: Icons.error_outline,
              title: l10n.localStorageUnavailableTitle,
              message: l10n.localHistoryStorageError,
              actionLabel: l10n.retryLabel,
              onAction: provider.initialize,
            ),
            LocalAttemptHistoryLoadState.ready => _ProgressEvidenceView(
              summary: ProgressEvidenceSummary.fromRecords(provider.records),
            ),
          };
        },
      ),
    );
  }
}

class _ProgressEvidenceView extends StatelessWidget {
  const _ProgressEvidenceView({required this.summary});

  final ProgressEvidenceSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (summary.state) {
      ProgressEvidenceState.noEvidence => _ProgressStatePage(
        key: const ValueKey('progress-no-evidence'),
        icon: Icons.insights_outlined,
        title: l10n.progressNoEvidenceTitle,
        message: l10n.progressNoEvidenceDescription,
        actionLabel: l10n.homeAnalyzeUchiMataTitle,
        onAction: () => TechniqueSectionRouter.open(
          context: context,
          section: TechniqueDashboardSection.aiAnalysis,
          technique: TechniqueFactory.featuredReferenceTechnique,
        ),
      ),
      ProgressEvidenceState.invalidEvidence => _ProgressStatePage(
        key: const ValueKey('progress-invalid-evidence'),
        icon: Icons.gpp_bad_outlined,
        title: l10n.progressInvalidEvidenceTitle,
        message: l10n.progressInvalidEvidenceDescription,
      ),
      ProgressEvidenceState.incompatibleVersions => _ProgressStatePage(
        key: const ValueKey('progress-incompatible-evidence'),
        icon: Icons.compare_arrows_outlined,
        title: l10n.progressIncompatibleEvidenceTitle,
        message: l10n.progressIncompatibleEvidenceDescription,
      ),
      ProgressEvidenceState.ready => _ReadyProgressView(summary: summary),
    };
  }
}

class _ReadyProgressView extends StatelessWidget {
  const _ReadyProgressView({required this.summary});

  final ProgressEvidenceSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final latest = _localizedDateTime(context, summary.latestSavedAtUtc!);
    final versions = summary.metricVersions.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView(
      key: const ValueKey('progress-overview-ready'),
      padding: const EdgeInsets.all(JudoSpacing.lg),
      children: [
        Text(l10n.progressOverviewDisclosure, style: JudoTypography.bodySmall),
        const SizedBox(height: JudoSpacing.lg),
        Wrap(
          spacing: JudoSpacing.sm,
          runSpacing: JudoSpacing.sm,
          children: [
            _EvidenceSummaryCard(
              key: const ValueKey('progress-total-attempts'),
              icon: Icons.history_rounded,
              label: l10n.progressSavedAttempts,
              value: '${summary.totalAttempts}',
            ),
            _EvidenceSummaryCard(
              key: const ValueKey('progress-completed-attempts'),
              icon: Icons.fact_check_outlined,
              label: l10n.progressCompletedRecords,
              value: '${summary.completedAttemptCount}',
            ),
            _EvidenceSummaryCard(
              key: const ValueKey('progress-latest-attempt'),
              icon: Icons.schedule_rounded,
              label: l10n.progressLatestSaved,
              value: latest,
            ),
          ],
        ),
        const SizedBox(height: JudoSpacing.xl),
        _SectionCard(
          key: const ValueKey('progress-status-distribution'),
          title: l10n.progressMetricEvidenceTitle,
          child: Column(
            children: [
              _StatusEvidenceBar(
                key: const ValueKey('progress-reportable-count'),
                label: l10n.metricStatusReportable,
                count: summary.reportableMetricCount,
                total: summary.totalMetricCount,
                color: JudoColors.success,
              ),
              _StatusEvidenceBar(
                key: const ValueKey('progress-review-required-count'),
                label: l10n.metricStatusReviewRequired,
                count: summary.reviewRequiredMetricCount,
                total: summary.totalMetricCount,
                color: JudoColors.warning,
              ),
              _StatusEvidenceBar(
                key: const ValueKey('progress-withheld-count'),
                label: l10n.metricStatusWithheld,
                count: summary.withheldMetricCount,
                total: summary.totalMetricCount,
                color: JudoColors.danger,
              ),
            ],
          ),
        ),
        const SizedBox(height: JudoSpacing.lg),
        _ExpandableSectionCard(
          key: const ValueKey('progress-scientific-details'),
          title: l10n.scientificDetailsTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.progressTechniqueVersionTitle,
                style: JudoTypography.titleSmall,
              ),
              const SizedBox(height: JudoSpacing.sm),
              Text(
                '${l10n.progressTechniqueLabel}: ${_techniqueLabel(l10n, summary.techniqueIds.single)}',
                style: JudoTypography.bodyMedium,
              ),
              const SizedBox(height: JudoSpacing.sm),
              for (final version in versions)
                Padding(
                  padding: const EdgeInsets.only(top: JudoSpacing.xs),
                  child: Text(
                    '${version.key} · ${version.value}',
                    style: JudoTypography.bodySmall,
                  ),
                ),
              const SizedBox(height: JudoSpacing.sm),
              Text(
                l10n.progressNoVersionComparison,
                style: JudoTypography.bodySmall,
              ),
              const Divider(height: JudoSpacing.xl),
              Text(
                l10n.progressScientificBoundariesTitle,
                style: JudoTypography.titleSmall,
              ),
              const SizedBox(height: JudoSpacing.sm),
              _BoundaryLine(text: l10n.progressReviewRequiredBoundary),
              _BoundaryLine(text: l10n.progressMultiPersonBoundary),
              _BoundaryLine(text: l10n.progressInteractionBoundary),
            ],
          ),
        ),
        const SizedBox(height: JudoSpacing.lg),
        _SectionCard(
          key: const ValueKey('progress-mastery-unavailable'),
          title: l10n.progressMasteryUnavailableTitle,
          child: Text(
            l10n.progressMasteryUnavailableDescription,
            style: JudoTypography.bodySmall,
          ),
        ),
        const SizedBox(height: JudoSpacing.lg),
        OutlinedButton.icon(
          key: const ValueKey('progress-open-history'),
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.localAnalysisHistory),
          icon: const Icon(Icons.history_rounded),
          label: Text(l10n.progressOpenHistory),
        ),
        const SizedBox(height: JudoSpacing.xl),
        Text(l10n.progressTimelineTitle, style: JudoTypography.titleMedium),
        const SizedBox(height: JudoSpacing.md),
        for (final record in summary.records) ...[
          _AttemptEvidenceCard(record: record),
          const SizedBox(height: JudoSpacing.md),
        ],
      ],
    );
  }
}

class _EvidenceSummaryCard extends StatelessWidget {
  const _EvidenceSummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: JudoColors.primary),
          const SizedBox(height: JudoSpacing.sm),
          Text(value, style: JudoTypography.titleMedium),
          const SizedBox(height: JudoSpacing.xs),
          Text(label, style: JudoTypography.bodySmall),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: JudoTypography.titleSmall),
          const SizedBox(height: JudoSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _ExpandableSectionCard extends StatelessWidget {
  const _ExpandableSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JudoColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        side: const BorderSide(color: JudoColors.border),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(title, style: JudoTypography.titleSmall),
        childrenPadding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          0,
          JudoSpacing.lg,
          JudoSpacing.lg,
        ),
        children: [child],
      ),
    );
  }
}

class _StatusEvidenceBar extends StatelessWidget {
  const _StatusEvidenceBar({
    super.key,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: JudoTypography.bodyMedium)),
              Text('$count', style: JudoTypography.labelLarge),
            ],
          ),
          const SizedBox(height: JudoSpacing.xs),
          LinearProgressIndicator(
            value: total == 0 ? 0 : count / total,
            minHeight: 6,
            color: color,
            backgroundColor: JudoColors.surfaceVariant,
            borderRadius: BorderRadius.circular(JudoRadius.xs),
          ),
        ],
      ),
    );
  }
}

class _BoundaryLine extends StatelessWidget {
  const _BoundaryLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: JudoIconSize.sm,
            color: JudoColors.warning,
          ),
          const SizedBox(width: JudoSpacing.sm),
          Expanded(child: Text(text, style: JudoTypography.bodySmall)),
        ],
      ),
    );
  }
}

class _AttemptEvidenceCard extends StatelessWidget {
  const _AttemptEvidenceCard({required this.record});

  final LocalAttemptHistoryRecord record;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reportable = _metricCount(SingleAttemptMetricStatus.reportable);
    final review = _metricCount(SingleAttemptMetricStatus.reviewRequired);
    final withheld = _metricCount(SingleAttemptMetricStatus.withheld);

    return Container(
      key: ValueKey('progress-attempt-${record.analysisId}'),
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _techniqueLabel(l10n, record.techniqueId),
            style: JudoTypography.titleSmall,
          ),
          const SizedBox(height: JudoSpacing.xs),
          Text(
            _localizedDateTime(context, record.savedAtUtc),
            style: JudoTypography.bodySmall,
          ),
          const SizedBox(height: JudoSpacing.sm),
          Wrap(
            spacing: JudoSpacing.sm,
            runSpacing: JudoSpacing.xs,
            children: [
              Chip(label: Text('${l10n.metricStatusReportable}: $reportable')),
              Chip(label: Text('${l10n.metricStatusReviewRequired}: $review')),
              Chip(label: Text('${l10n.metricStatusWithheld}: $withheld')),
            ],
          ),
        ],
      ),
    );
  }

  int _metricCount(SingleAttemptMetricStatus status) =>
      record.metrics.where((metric) => metric.status == status).length;
}

class _ProgressStatePage extends StatelessWidget {
  const _ProgressStatePage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final Future<Object?> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(JudoSpacing.xl),
      children: [
        const SizedBox(height: JudoSpacing.xxl),
        Icon(icon, size: JudoIconSize.xl, color: JudoColors.warning),
        const SizedBox(height: JudoSpacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: JudoTypography.titleMedium,
        ),
        const SizedBox(height: JudoSpacing.sm),
        Text(
          message,
          textAlign: TextAlign.center,
          style: JudoTypography.bodySmall,
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: JudoSpacing.lg),
          OutlinedButton(
            key: const ValueKey('progress-state-action'),
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
        ],
        const SizedBox(height: JudoSpacing.lg),
        _SectionCard(
          key: const ValueKey('progress-empty-mastery-unavailable'),
          title: AppLocalizations.of(context)!.progressMasteryUnavailableTitle,
          child: Text(
            AppLocalizations.of(context)!.progressMasteryUnavailableDescription,
            style: JudoTypography.bodySmall,
          ),
        ),
      ],
    );
  }
}

String _techniqueLabel(AppLocalizations l10n, String techniqueId) =>
    techniqueId == 'uchi-mata' ? l10n.uchiMata : techniqueId;

String _localizedDateTime(BuildContext context, DateTime utc) {
  final local = utc.toLocal();
  final material = MaterialLocalizations.of(context);
  return '${material.formatMediumDate(local)} · '
      '${material.formatTimeOfDay(TimeOfDay.fromDateTime(local))}';
}
