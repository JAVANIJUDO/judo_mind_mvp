import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/capabilities/current_scientific_capabilities.dart';
import '../../core/providers/local_attempt_history_provider.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../core/theme/judo_typography.dart';
import '../../core/widgets/language/language_selector.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmClearHistory(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('clear-history-confirmation-dialog'),
        title: Text(l10n.settingsClearHistoryConfirmTitle),
        content: Text(l10n.settingsClearHistoryConfirmDescription),
        actions: [
          TextButton(
            key: const ValueKey('cancel-clear-history'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const ValueKey('confirm-clear-history'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.settingsClearHistoryAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final cleared = await context
        .read<LocalAttemptHistoryProvider>()
        .clearHistory();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            cleared
                ? l10n.settingsHistoryCleared
                : l10n.settingsHistoryClearFailed,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        key: const ValueKey('settings-local-mvp'),
        padding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          JudoSpacing.lg,
          JudoSpacing.lg,
          JudoSpacing.xxxl,
        ),
        children: [
          _SettingsSection(
            key: const ValueKey('settings-language-section'),
            icon: Icons.language_rounded,
            title: l10n.settingsLanguageSectionTitle,
            child: const LanguageSelector(),
          ),
          const SizedBox(height: JudoSpacing.lg),
          _SettingsSection(
            key: const ValueKey('settings-local-data-section'),
            icon: Icons.phonelink_lock_outlined,
            title: l10n.settingsLocalDataTitle,
            child: _LocalDataSettings(onClearHistory: _confirmClearHistory),
          ),
          const SizedBox(height: JudoSpacing.lg),
          _SettingsSection(
            key: const ValueKey('settings-scientific-boundary-section'),
            icon: Icons.science_outlined,
            title: l10n.settingsScientificBoundaryTitle,
            child: const _ScientificBoundary(),
          ),
          const SizedBox(height: JudoSpacing.lg),
          _SettingsSection(
            key: const ValueKey('settings-application-info-section'),
            icon: Icons.info_outline_rounded,
            title: l10n.settingsApplicationInfoTitle,
            child: const _ApplicationInfo(),
          ),
        ],
      ),
    );
  }
}

class _LocalDataSettings extends StatelessWidget {
  const _LocalDataSettings({required this.onClearHistory});

  final Future<void> Function(BuildContext context) onClearHistory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<LocalAttemptHistoryProvider>(
      builder: (context, provider, child) {
        final ready = provider.loadState == LocalAttemptHistoryLoadState.ready;
        final count = ready ? provider.records.length : 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsLocalDataDescription,
              style: JudoTypography.bodySmall,
            ),
            const SizedBox(height: JudoSpacing.md),
            Container(
              key: const ValueKey('settings-history-count'),
              width: double.infinity,
              padding: const EdgeInsets.all(JudoSpacing.md),
              decoration: BoxDecoration(
                color: JudoColors.surfaceVariant,
                borderRadius: BorderRadius.circular(JudoRadius.sm),
              ),
              child: Text(
                ready
                    ? l10n.settingsStoredHistoryCount(count)
                    : provider.loadState == LocalAttemptHistoryLoadState.failure
                    ? l10n.settingsHistoryUnavailable
                    : l10n.loading,
                style: JudoTypography.titleSmall,
              ),
            ),
            const SizedBox(height: JudoSpacing.md),
            if (ready && count == 0)
              Text(
                l10n.settingsHistoryEmpty,
                key: const ValueKey('settings-history-empty'),
                style: JudoTypography.bodySmall,
              ),
            if (ready && count > 0)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const ValueKey('clear-analysis-history'),
                  onPressed: provider.isClearing
                      ? null
                      : () => onClearHistory(context),
                  icon: provider.isClearing
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.settingsClearHistoryAction),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ScientificBoundary extends StatelessWidget {
  const _ScientificBoundary();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final metricIds = CurrentScientificCapabilities.approvedMetricIds.toList()
      ..sort();
    return Material(
      color: Colors.transparent,
      child: ExpansionTile(
        key: const ValueKey('settings-scientific-details-expansion'),
        initiallyExpanded: false,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(l10n.scientificDetailsTitle),
        children: [
          _InfoRow(
            key: const ValueKey('settings-v2a-supported-boundary'),
            icon: Icons.check_circle_outline,
            text: l10n.settingsV2aSupportedBoundary(metricIds.join(', ')),
          ),
          _InfoRow(
            key: const ValueKey('settings-review-required-boundary'),
            icon: Icons.fact_check_outlined,
            text: l10n.settingsReviewRequiredBoundary,
          ),
          _InfoRow(
            key: const ValueKey('settings-multi-person-boundary'),
            icon: Icons.people_outline,
            text: l10n.settingsMultiPersonBoundary,
          ),
          _InfoRow(
            key: const ValueKey('settings-interaction-boundary'),
            icon: Icons.link_off_rounded,
            text: l10n.settingsInteractionBoundary,
          ),
          _InfoRow(
            key: const ValueKey('settings-unavailable-modules-boundary'),
            icon: Icons.lock_outline_rounded,
            text: l10n.settingsUnavailableModulesBoundary,
          ),
        ],
      ),
    );
  }
}

class _ApplicationInfo extends StatelessWidget {
  const _ApplicationInfo();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _LabelValue(
          label: l10n.settingsApplicationNameLabel,
          value: l10n.appName,
        ),
        _LabelValue(
          label: l10n.settingsApplicationStatusLabel,
          value: l10n.settingsApplicationStatusLocalDemo,
        ),
        _LabelValue(
          label: l10n.settingsAvailableLanguagesLabel,
          value: l10n.settingsAvailableLanguagesValue,
        ),
        _LabelValue(
          label: l10n.settingsStorageBoundaryLabel,
          value: l10n.settingsStorageBoundaryValue,
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: JudoColors.gold),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(child: Text(title, style: JudoTypography.headingSmall)),
            ],
          ),
          const SizedBox(height: JudoSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: JudoColors.textSecondary),
          const SizedBox(width: JudoSpacing.sm),
          Expanded(child: Text(text, style: JudoTypography.bodySmall)),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: JudoTypography.labelMedium)),
          const SizedBox(width: JudoSpacing.md),
          Expanded(
            flex: 2,
            child: Text(value, style: JudoTypography.bodySmall),
          ),
        ],
      ),
    );
  }
}
