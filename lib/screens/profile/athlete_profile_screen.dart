import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/analysis_provenance_localizer.dart';
import '../../core/providers/local_athlete_profile_provider.dart';
import '../../core/providers/local_attempt_history_provider.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../core/theme/judo_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../models/local_athlete_profile.dart';
import '../../models/local_attempt_history_record.dart';
import '../../models/single_attempt_analysis_v2a.dart';

/// Local/demo-only Athlete Profile and scientifically bounded V2A history.
class AthleteProfileScreen extends StatelessWidget {
  const AthleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: AppBar(title: Text(l10n.athleteProfileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(JudoSpacing.lg),
        children: [
          _DisclosureCard(
            key: const ValueKey('profile-local-disclosure'),
            icon: Icons.phone_android_outlined,
            title: l10n.localProfileDisclosureTitle,
            message: l10n.localProfileDisclosure,
          ),
          const SizedBox(height: JudoSpacing.lg),
          const _ProfileSection(),
          const SizedBox(height: JudoSpacing.xl),
          Text(
            l10n.localAnalysisHistoryTitle,
            style: JudoTypography.headingSmall,
          ),
          const SizedBox(height: JudoSpacing.sm),
          Text(
            l10n.localAnalysisHistoryDisclosure,
            key: const ValueKey('history-local-disclosure'),
            style: JudoTypography.bodySmall,
          ),
          const SizedBox(height: JudoSpacing.lg),
          const LocalAnalysisHistorySection(),
          const SizedBox(height: JudoSpacing.xl),
          _DisclosureCard(
            key: const ValueKey('profile-unavailable-boundary'),
            icon: Icons.lock_outline_rounded,
            title: l10n.profileUnavailableFeaturesTitle,
            message: l10n.profileUnavailableFeaturesDescription,
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalAthleteProfileProvider>(
      builder: (context, provider, child) {
        switch (provider.state) {
          case LocalAthleteProfileState.initial:
          case LocalAthleteProfileState.loading:
            return const Center(
              key: ValueKey('profile-loading'),
              child: CircularProgressIndicator(),
            );
          case LocalAthleteProfileState.failure:
            return _StorageErrorCard(
              key: const ValueKey('profile-storage-error'),
              message: AppLocalizations.of(context)!.localProfileStorageError,
              onRetry: provider.initialize,
            );
          case LocalAthleteProfileState.ready:
          case LocalAthleteProfileState.saving:
            return _ProfileEditor(profile: provider.profile);
        }
      },
    );
  }
}

class _ProfileEditor extends StatefulWidget {
  const _ProfileEditor({required this.profile});

  final LocalAthleteProfile profile;

  @override
  State<_ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<_ProfileEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayName;
  late final TextEditingController _beltRank;
  late final TextEditingController _club;
  late final TextEditingController _country;
  late final TextEditingController _biography;

  @override
  void initState() {
    super.initState();
    _displayName = TextEditingController(text: widget.profile.displayName);
    _beltRank = TextEditingController(text: widget.profile.beltRank);
    _club = TextEditingController(text: widget.profile.club);
    _country = TextEditingController(text: widget.profile.country);
    _biography = TextEditingController(text: widget.profile.biography);
  }

  @override
  void dispose() {
    _displayName.dispose();
    _beltRank.dispose();
    _club.dispose();
    _country.dispose();
    _biography.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final profile = LocalAthleteProfile.fromInput(
      displayName: _displayName.text,
      beltRank: _beltRank.text,
      club: _club.text,
      country: _country.text,
      biography: _biography.text,
    );
    final saved = await context.read<LocalAthleteProfileProvider>().save(
      profile,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            saved ? l10n.localProfileSaved : l10n.localProfileSaveFailed,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<LocalAthleteProfileProvider>();
    return Container(
      key: const ValueKey('local-athlete-profile-form'),
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selfReportedProfileTitle,
              style: JudoTypography.titleLarge,
            ),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              l10n.selfReportedProfileDescription,
              style: JudoTypography.bodySmall,
            ),
            const SizedBox(height: JudoSpacing.lg),
            _field(
              _displayName,
              l10n.profileDisplayName,
              LocalAthleteProfile.displayNameMaxLength,
            ),
            _field(
              _beltRank,
              l10n.profileBeltRank,
              LocalAthleteProfile.beltRankMaxLength,
            ),
            _field(_club, l10n.profileClub, LocalAthleteProfile.clubMaxLength),
            _field(
              _country,
              l10n.profileCountry,
              LocalAthleteProfile.countryMaxLength,
            ),
            _field(
              _biography,
              l10n.profileBiography,
              LocalAthleteProfile.biographyMaxLength,
              maxLines: 4,
            ),
            const SizedBox(height: JudoSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const ValueKey('save-local-athlete-profile'),
                onPressed: provider.isBusy ? null : _save,
                icon: provider.state == LocalAthleteProfileState.saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(l10n.saveLocalProfile),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    int maxLength, {
    int maxLines = 1,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.md),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
        validator: (value) => (value?.length ?? 0) > maxLength
            ? l10n.profileFieldTooLong(maxLength)
            : null,
      ),
    );
  }
}

class LocalAnalysisHistorySection extends StatelessWidget {
  const LocalAnalysisHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalAttemptHistoryProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;
        switch (provider.loadState) {
          case LocalAttemptHistoryLoadState.initial:
          case LocalAttemptHistoryLoadState.loading:
            return const Center(
              key: ValueKey('history-loading'),
              child: CircularProgressIndicator(),
            );
          case LocalAttemptHistoryLoadState.failure:
            return _StorageErrorCard(
              key: const ValueKey('history-storage-error'),
              message: l10n.localHistoryStorageError,
              onRetry: provider.initialize,
            );
          case LocalAttemptHistoryLoadState.ready:
            if (provider.records.isEmpty) {
              return _DisclosureCard(
                key: const ValueKey('history-empty-state'),
                icon: Icons.history_toggle_off_rounded,
                title: l10n.localHistoryEmptyTitle,
                message: l10n.localHistoryEmptyDescription,
              );
            }
            return _HistoryContent(records: provider.records);
        }
      },
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.records});

  final List<LocalAttemptHistoryRecord> records;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reportable = _statusCount(SingleAttemptMetricStatus.reportable);
    final reviewRequired = _statusCount(
      SingleAttemptMetricStatus.reviewRequired,
    );
    final withheld = _statusCount(SingleAttemptMetricStatus.withheld);
    return Column(
      key: const ValueKey('local-analysis-history-list'),
      children: [
        Wrap(
          spacing: JudoSpacing.sm,
          runSpacing: JudoSpacing.sm,
          children: [
            Chip(label: Text(l10n.savedLocalAnalysesCount(records.length))),
            Chip(
              label: Text(
                l10n.metricStatusCount(l10n.metricStatusReportable, reportable),
              ),
            ),
            Chip(
              label: Text(
                l10n.metricStatusCount(
                  l10n.metricStatusReviewRequired,
                  reviewRequired,
                ),
              ),
            ),
            Chip(
              label: Text(
                l10n.metricStatusCount(l10n.metricStatusWithheld, withheld),
              ),
            ),
          ],
        ),
        const SizedBox(height: JudoSpacing.md),
        for (final record in records) ...[
          _HistoryRecordCard(record: record),
          const SizedBox(height: JudoSpacing.md),
        ],
      ],
    );
  }

  int _statusCount(SingleAttemptMetricStatus status) => records
      .expand((record) => record.metrics)
      .where((metric) => metric.status == status)
      .length;
}

class _HistoryRecordCard extends StatelessWidget {
  const _HistoryRecordCard({required this.record});

  final LocalAttemptHistoryRecord record;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      key: ValueKey('history-record-${record.analysisId}'),
      color: JudoColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        side: const BorderSide(color: JudoColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(_techniqueName(record.techniqueId, l10n)),
        subtitle: Text(l10n.savedLocallyAt(_dateLabel(record.savedAtUtc))),
        childrenPadding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          0,
          JudoSpacing.lg,
          JudoSpacing.lg,
        ),
        children: [
          _BoundaryRow(
            label: l10n.analysisIdentifier,
            value: record.analysisId,
          ),
          _BoundaryRow(
            label: l10n.analysisModeLabel,
            value: record.analysisMode.contains('single')
                ? l10n.singleAttemptAnalysisTitle
                : l10n.unknownLabel,
          ),
          _BoundaryRow(
            label: l10n.multiPersonEvidenceLabel,
            value:
                record.capabilities.multiPersonEvidenceStatus == 'insufficient'
                ? l10n.insufficientEvidenceLabel
                : l10n.unknownLabel,
          ),
          _BoundaryRow(
            label: l10n.interactionMetricsLabel,
            value: record.capabilities.multiPersonInteractionMetricsReportable
                ? l10n.availableLabel
                : l10n.notReportableLabel,
          ),
          const SizedBox(height: JudoSpacing.sm),
          for (final metric in record.metrics) _MetricDetail(metric: metric),
        ],
      ),
    );
  }

  String _techniqueName(String techniqueId, AppLocalizations l10n) =>
      techniqueId == 'uchi-mata' ? l10n.uchiMata : techniqueId;

  String _dateLabel(DateTime utc) =>
      utc.toLocal().toIso8601String().replaceFirst('T', ' ').split('.').first;
}

class _MetricDetail extends StatelessWidget {
  const _MetricDetail({required this.metric});

  final LocalAttemptMetricSummary metric;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = switch (metric.status) {
      SingleAttemptMetricStatus.reportable => l10n.metricStatusReportable,
      SingleAttemptMetricStatus.reviewRequired =>
        l10n.metricStatusReviewRequired,
      SingleAttemptMetricStatus.withheld => l10n.metricStatusWithheld,
      SingleAttemptMetricStatus.unknown => l10n.unknownLabel,
    };
    final value = metric.value == null
        ? l10n.notAvailableLabel
        : '${metric.value} ${metric.unit}';
    return Container(
      key: ValueKey('history-metric-${metric.metricId}'),
      width: double.infinity,
      margin: const EdgeInsets.only(top: JudoSpacing.sm),
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.surfaceVariant,
        borderRadius: BorderRadius.circular(JudoRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${metric.metricId} · ${_metricName(l10n)}',
            style: JudoTypography.titleSmall,
          ),
          _BoundaryRow(label: l10n.metricValueLabel, value: value),
          _BoundaryRow(label: l10n.metricStatusLabel, value: status),
          _BoundaryRow(
            label: l10n.metricProvenanceLabel,
            value: localizeAnalysisProvenance(l10n, metric.provenance),
          ),
          _BoundaryRow(
            label: l10n.metricMethodVersionLabel,
            value: metric.methodVersion,
          ),
          _BoundaryRow(
            label: l10n.metricConfidenceAvailabilityLabel,
            value: metric.confidence.available
                ? l10n.availableLabel
                : l10n.notAvailableLabel,
          ),
          _BoundaryRow(
            label: l10n.metricLimitationLabel,
            value: _metricLimitation(l10n),
          ),
          if (metric.withheldReason != null)
            _BoundaryRow(
              label: l10n.metricWithheldReasonLabel,
              value: Localizations.localeOf(context).languageCode == 'fa'
                  ? l10n.groundedSenseiEvidenceWithheld
                  : metric.withheldReason!,
            ),
        ],
      ),
    );
  }

  String _metricName(AppLocalizations l10n) => switch (metric.metricId) {
    'UM-TIM-001' => l10n.groundedSenseiMetricDuration,
    'UM-ANG-001' => l10n.groundedSenseiMetricTrunk,
    'UM-ANG-002' => l10n.groundedSenseiMetricSupportKnee,
    'UM-ANG-003' => l10n.groundedSenseiMetricAttackingKnee,
    _ => metric.name,
  };

  String _metricLimitation(AppLocalizations l10n) => switch (metric.metricId) {
    'UM-TIM-001' => l10n.groundedSenseiWhyDuration,
    'UM-ANG-001' => l10n.groundedSenseiWhyTrunk,
    'UM-ANG-002' => l10n.groundedSenseiWhySupportKnee,
    'UM-ANG-003' => l10n.groundedSenseiWhyAttackingKnee,
    _ => metric.limitation,
  };
}

class _BoundaryRow extends StatelessWidget {
  const _BoundaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: JudoSpacing.xs),
      child: Text('$label: $value', style: JudoTypography.bodySmall),
    );
  }
}

class _StorageErrorCard extends StatelessWidget {
  const _StorageErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _DisclosureCard(
      icon: Icons.error_outline,
      title: l10n.localStorageUnavailableTitle,
      message: message,
      action: TextButton(onPressed: onRetry, child: Text(l10n.retryLabel)),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: JudoColors.primary),
          const SizedBox(width: JudoSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: JudoTypography.titleMedium),
                const SizedBox(height: JudoSpacing.xs),
                Text(message, style: JudoTypography.bodySmall),
                ?action,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: JudoColors.surface,
  borderRadius: BorderRadius.circular(JudoRadius.lg),
  border: Border.all(color: JudoColors.border),
);
