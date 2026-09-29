import 'package:flutter/material.dart';

import '../../core/constants/modules.dart';
import '../../core/design_system/icons/judo_icons.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../core/theme/judo_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../models/module_model.dart';

/// A single registry-backed view of all official modules. Platform-surface
/// filters use the registry metadata without duplicating module identities.
class ModuleDirectoryScreen extends StatefulWidget {
  const ModuleDirectoryScreen({super.key});

  @override
  State<ModuleDirectoryScreen> createState() => _ModuleDirectoryScreenState();
}

class _ModuleDirectoryScreenState extends State<ModuleDirectoryScreen> {
  JudoMindPlatformSurface? _selectedSurface;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visibleModules = JudoMindModules.modules
        .where(
          (module) =>
              _selectedSurface == null ||
              module.surfaces.contains(_selectedSurface),
        )
        .toList(growable: false);
    final available = visibleModules
        .where((module) => module.isReachable)
        .toList(growable: false);
    final unavailable = visibleModules
        .where((module) => !module.isReachable)
        .toList(growable: false);

    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: AppBar(title: Text(l10n.moduleDirectoryTitle)),
      body: ListView(
        key: const ValueKey('official-module-directory'),
        padding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          JudoSpacing.lg,
          JudoSpacing.lg,
          JudoSpacing.xxxl,
        ),
        children: [
          Text(
            l10n.moduleDirectorySurfaceTitle,
            style: JudoTypography.headingSmall,
          ),
          const SizedBox(height: JudoSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  key: const ValueKey('module-surface-all'),
                  label: Text(l10n.moduleDirectoryAllSurfaces),
                  selected: _selectedSurface == null,
                  onSelected: (_) => setState(() => _selectedSurface = null),
                ),
                for (final surface in JudoMindPlatformSurface.values) ...[
                  const SizedBox(width: JudoSpacing.sm),
                  ChoiceChip(
                    key: ValueKey('module-surface-${surface.name}'),
                    label: Text(_surfaceLabel(l10n, surface)),
                    selected: _selectedSurface == surface,
                    onSelected: (_) =>
                        setState(() => _selectedSurface = surface),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: JudoSpacing.xxl),
          _DirectoryHeading(
            title: l10n.moduleAvailableDestinationsTitle,
            count: available.length,
            color: JudoColors.success,
          ),
          const SizedBox(height: JudoSpacing.md),
          if (available.isEmpty)
            Text(
              l10n.moduleNoAvailableDestinationForSurface,
              style: JudoTypography.bodySmall,
            )
          else
            for (final module in available) ...[
              _AvailableModuleCard(
                key: ValueKey('module-directory-${module.id}'),
                module: module,
              ),
              const SizedBox(height: JudoSpacing.md),
            ],
          const SizedBox(height: JudoSpacing.lg),
          if (unavailable.isNotEmpty)
            _UnavailableModules(
              key: ValueKey(
                'module-directory-unavailable-${_selectedSurface?.name ?? 'all'}',
              ),
              modules: unavailable,
            ),
        ],
      ),
    );
  }
}

class _DirectoryHeading extends StatelessWidget {
  const _DirectoryHeading({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: JudoTypography.headingSmall)),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: JudoSpacing.sm,
            vertical: JudoSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(JudoRadius.xs),
          ),
          child: Text(
            '$count',
            style: JudoTypography.labelMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _AvailableModuleCard extends StatelessWidget {
  const _AvailableModuleCard({super.key, required this.module});

  final ModuleModel module;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isCurrentHome = module.id == 'home';
    final onTap = isCurrentHome
        ? null
        : () => Navigator.of(context).pushNamed(module.route!);

    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      currentValueLength: isCurrentHome ? 1 : null,
      child: Material(
        color: Color.alphaBlend(
          module.color.withValues(alpha: 0.08),
          JudoColors.surfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(JudoRadius.md),
          side: BorderSide(color: module.color.withValues(alpha: 0.34)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(JudoRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(JudoSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModuleIcon(module: module),
                const SizedBox(width: JudoSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _moduleTitle(l10n, module.id),
                        style: JudoTypography.titleLarge,
                      ),
                      const SizedBox(height: JudoSpacing.sm),
                      _SurfaceChips(surfaces: module.surfaces),
                      const SizedBox(height: JudoSpacing.sm),
                      Text(
                        isCurrentHome
                            ? l10n.moduleCurrentDestination
                            : l10n.availableLabel,
                        key: ValueKey('module-status-${module.id}'),
                        style: JudoTypography.labelMedium.copyWith(
                          color: isCurrentHome
                              ? JudoColors.primary
                              : JudoColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    isRtl ? Icons.chevron_left : Icons.chevron_right,
                    color: JudoColors.textHint,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnavailableModules extends StatelessWidget {
  const _UnavailableModules({super.key, required this.modules});

  final List<ModuleModel> modules;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: JudoColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(JudoRadius.md),
        side: const BorderSide(color: JudoColors.border),
      ),
      child: ExpansionTile(
        key: const ValueKey('module-unavailable-expansion'),
        initiallyExpanded: false,
        leading: const Icon(Icons.lock_outline, color: JudoColors.textHint),
        title: Text(l10n.moduleUnavailableDeferredTitle),
        subtitle: Text(
          l10n.moduleUnavailableDeferredSummary(modules.length),
          style: JudoTypography.bodySmall,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          0,
          JudoSpacing.lg,
          JudoSpacing.lg,
        ),
        children: [
          Text(
            l10n.moduleNoApprovedDestination,
            key: const ValueKey('module-unavailable-shared-reason'),
            style: JudoTypography.bodySmall,
          ),
          const SizedBox(height: JudoSpacing.md),
          for (final module in modules) ...[
            _UnavailableModuleRow(
              key: ValueKey('module-directory-${module.id}'),
              module: module,
            ),
            const SizedBox(height: JudoSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _UnavailableModuleRow extends StatelessWidget {
  const _UnavailableModuleRow({super.key, required this.module});

  final ModuleModel module;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      enabled: false,
      child: Container(
        padding: const EdgeInsets.all(JudoSpacing.md),
        decoration: BoxDecoration(
          color: JudoColors.background.withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(JudoRadius.sm),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModuleIcon(module: module, compact: true),
            const SizedBox(width: JudoSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _moduleTitle(l10n, module.id),
                    style: JudoTypography.titleMedium,
                  ),
                  const SizedBox(height: JudoSpacing.xs),
                  Text(
                    l10n.moduleUnavailableDeferredTitle,
                    key: ValueKey('module-status-${module.id}'),
                    style: JudoTypography.labelSmall,
                  ),
                  if (module.id == 'sensi-bet') ...[
                    const SizedBox(height: JudoSpacing.xs),
                    Text(
                      l10n.moduleSensiBetDeferredReason,
                      key: const ValueKey('module-reason-sensi-bet'),
                      style: JudoTypography.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleIcon extends StatelessWidget {
  const _ModuleIcon({required this.module, this.compact = false});

  final ModuleModel module;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final dimension = compact ? 36.0 : 44.0;
    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: module.color.withValues(alpha: compact ? 0.08 : 0.14),
        borderRadius: BorderRadius.circular(JudoRadius.sm),
      ),
      child: Icon(
        module.icon ?? JudoIcons.overview,
        color: compact ? JudoColors.textHint : module.color,
        size: compact ? JudoIconSize.sm : JudoIconSize.md,
      ),
    );
  }
}

class _SurfaceChips extends StatelessWidget {
  const _SurfaceChips({required this.surfaces});

  final Set<JudoMindPlatformSurface> surfaces;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: JudoSpacing.sm,
      runSpacing: JudoSpacing.xs,
      children: surfaces
          .map((surface) => _MetadataChip(label: _surfaceLabel(l10n, surface)))
          .toList(growable: false),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JudoSpacing.sm,
        vertical: JudoSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.xs),
      ),
      child: Text(label, style: JudoTypography.labelSmall),
    );
  }
}

String _moduleTitle(AppLocalizations l10n, String id) => switch (id) {
  'home' => l10n.moduleHomeTitle,
  'techniques' => l10n.moduleTechniquesTitle,
  'sensi-bot' => l10n.moduleSensiBotTitle,
  'sensi-bet' => l10n.moduleSensiBetTitle,
  'monitoring-progress-mastery' => l10n.moduleMonitoringTitle,
  'audiocast' => l10n.moduleAudioCastTitle,
  'athlete-profile' => l10n.moduleAthleteProfileTitle,
  'training-center' => l10n.moduleTrainingCenterTitle,
  'champions-hub' => l10n.moduleChampionsHubTitle,
  'competitions-challenges' => l10n.moduleCompetitionsTitle,
  'news' => l10n.moduleNewsTitle,
  'store-subscriptions' => l10n.moduleStoreSubscriptionsTitle,
  'club-administration' => l10n.moduleClubAdministrationTitle,
  'coach-forum' => l10n.moduleCoachForumTitle,
  'online-courses' => l10n.moduleOnlineCoursesTitle,
  'country-judo-history' => l10n.moduleCountryJudoHistoryTitle,
  'app-management-settings' => l10n.moduleAppManagementSettingsTitle,
  'training-program-validator' => l10n.moduleTrainingProgramValidatorTitle,
  _ => throw StateError('Unknown official module id: $id'),
};

String _surfaceLabel(AppLocalizations l10n, JudoMindPlatformSurface surface) =>
    switch (surface) {
      JudoMindPlatformSurface.athleteApp => l10n.surfaceAthleteApp,
      JudoMindPlatformSurface.coachWorkspace => l10n.surfaceCoachWorkspace,
      JudoMindPlatformSurface.clubFederationConsole =>
        l10n.surfaceClubFederationConsole,
      JudoMindPlatformSurface.judoIntelligenceCore =>
        l10n.surfaceJudoIntelligenceCore,
    };
