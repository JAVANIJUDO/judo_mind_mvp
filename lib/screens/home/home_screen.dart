import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design_system/icons/judo_icons.dart';
import '../../core/providers/local_attempt_history_provider.dart';
import '../../core/providers/recent_techniques_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../core/theme/judo_typography.dart';
import '../../data/techniques/technique_factory.dart';
import '../../l10n/app_localizations.dart';
import '../technique_detail/technique_detail_screen.dart';
import '../technique_detail/widgets/sections/technique_section_router.dart';
import '../technique_detail/widgets/technique_dashboard_grid.dart';
import 'home_capability_contract.dart';
import 'module_directory_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.showBackButton = false});

  /// Root Home intentionally suppresses the synthetic back arrow produced by
  /// Flutter's initial named-route stack. A nested caller may opt in.
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final recentTechniques = context.watch<RecentTechniquesProvider?>();
    final history = context.watch<LocalAttemptHistoryProvider?>();
    final referenceTechnique = TechniqueFactory.featuredReferenceTechnique;
    final hasRecentUchiMata =
        recentTechniques?.isInitialized == true &&
        recentTechniques!.contains(referenceTechnique.id);
    final hasLocalHistory =
        history?.loadState == LocalAttemptHistoryLoadState.ready &&
        history!.records.isNotEmpty;

    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackButton && Navigator.of(context).canPop()
            ? const BackButton()
            : null,
        title: const Text('JUDO MIND'),
        actions: [
          IconButton(
            key: const ValueKey('home-settings-action'),
            tooltip: l10n.settings,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            key: const ValueKey('home-profile-action'),
            tooltip: l10n.moduleAthleteProfileTitle,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            icon: const Icon(JudoIcons.athlete),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              JudoSpacing.lg,
              JudoSpacing.md,
              JudoSpacing.lg,
              JudoSpacing.xxxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HomeHero(
                      hasLocalHistory: hasLocalHistory,
                      techniqueName: _referenceTechniqueName(
                        context,
                        referenceTechnique.nameEn,
                      ),
                      onOpen: hasLocalHistory
                          ? () => _openLocalHistory(context)
                          : () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => TechniqueDetailScreen(
                                  technique: referenceTechnique,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: JudoSpacing.xxl),
                    Text(
                      l10n.homeJourneysTitle,
                      style: JudoTypography.headingLarge,
                    ),
                    const SizedBox(height: JudoSpacing.xs),
                    Text(
                      l10n.homeJourneysDescription,
                      style: JudoTypography.bodyMedium,
                    ),
                    const SizedBox(height: JudoSpacing.lg),
                    _JourneyGrid(
                      onOpen: (journey) => _openJourney(context, journey),
                      onOpenProfile: () =>
                          Navigator.pushNamed(context, AppRoutes.profile),
                    ),
                    if (hasRecentUchiMata || hasLocalHistory) ...[
                      const SizedBox(height: JudoSpacing.xxl),
                      Text(
                        l10n.continueSectionTitle,
                        style: JudoTypography.headingMedium,
                      ),
                      const SizedBox(height: JudoSpacing.md),
                      if (hasRecentUchiMata)
                        _ContinueTile(
                          key: const ValueKey('continue-uchi-mata'),
                          icon: JudoIcons.throwTechnique,
                          title: l10n.continueUchiMata,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => TechniqueDetailScreen(
                                technique: referenceTechnique,
                              ),
                            ),
                          ),
                        ),
                      if (hasRecentUchiMata && hasLocalHistory)
                        const SizedBox(height: JudoSpacing.sm),
                      if (hasLocalHistory)
                        _ContinueTile(
                          key: const ValueKey('continue-local-history'),
                          icon: JudoIcons.timing,
                          title: l10n.reviewLocalAnalysisHistory,
                          onTap: () => _openLocalHistory(context),
                        ),
                    ],
                    const SizedBox(height: JudoSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        key: const ValueKey('explore-all-capabilities'),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ModuleDirectoryScreen(),
                          ),
                        ),
                        icon: const Icon(JudoIcons.overview),
                        label: Text(l10n.exploreAllCapabilities),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openJourney(BuildContext context, AthleteHomeJourney journey) {
    switch (journey.destination) {
      case AthleteHomeDestination.techniques:
        _openTechniques(context);
        return;
      case AthleteHomeDestination.reviewedUchiMataAnalysis:
        TechniqueSectionRouter.open(
          context: context,
          section: TechniqueDashboardSection.aiAnalysis,
          technique: TechniqueFactory.featuredReferenceTechnique,
        );
        return;
      case AthleteHomeDestination.progressOverview:
        Navigator.pushNamed(context, AppRoutes.progressOverview);
        return;
      case null:
        return;
    }
  }

  void _openTechniques(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.techniques);
  }

  void _openLocalHistory(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.localAnalysisHistory);
  }

  String _referenceTechniqueName(BuildContext context, String fallback) {
    final reference = TechniqueFactory.featuredReferenceTechnique;
    final languageCode = Localizations.localeOf(context).languageCode;
    return reference.getTranslation(languageCode)?.name ?? fallback;
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.hasLocalHistory,
    required this.techniqueName,
    required this.onOpen,
  });

  final bool hasLocalHistory;
  final String techniqueName;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [JudoColors.surfaceVariant, JudoColors.background],
        ),
        border: Border.all(color: JudoColors.primary.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.homeHeroTitle, style: JudoTypography.headingLarge),
          const SizedBox(height: JudoSpacing.sm),
          Text(l10n.homeHeroDescription, style: JudoTypography.bodyMedium),
          const SizedBox(height: JudoSpacing.lg),
          FilledButton.icon(
            key: const ValueKey('home-hero-primary-action'),
            onPressed: onOpen,
            icon: Icon(
              hasLocalHistory ? JudoIcons.timing : JudoIcons.throwTechnique,
            ),
            label: Text(
              hasLocalHistory
                  ? l10n.viewLatestAnalysis
                  : l10n.exploreReferenceTechnique(techniqueName),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyGrid extends StatelessWidget {
  const _JourneyGrid({required this.onOpen, required this.onOpenProfile});

  final ValueChanged<AthleteHomeJourney> onOpen;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 600
            ? 2
            : 1;
        final width =
            (constraints.maxWidth - JudoSpacing.md * (columns - 1)) / columns;

        final availableJourneys = AthleteHomeCapabilities.journeys
            .where((journey) => journey.isAvailable)
            .toList(growable: false);
        final unavailableJourneys = AthleteHomeCapabilities.journeys
            .where((journey) => !journey.isAvailable)
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: JudoSpacing.md,
              runSpacing: JudoSpacing.md,
              children: [
                ...availableJourneys.map(
                  (journey) => SizedBox(
                    width: width,
                    child: _JourneyCard(
                      actionKey: 'home-journey-${journey.id.name}',
                      content: _journeyContent(
                        AppLocalizations.of(context)!,
                        journey.id,
                      ),
                      onTap: () => onOpen(journey),
                    ),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _JourneyCard(
                    actionKey: 'home-primary-profile',
                    content: _JourneyContent(
                      title: AppLocalizations.of(
                        context,
                      )!.moduleAthleteProfileTitle,
                      description: AppLocalizations.of(
                        context,
                      )!.selfReportedProfileDescription,
                      icon: JudoIcons.athlete,
                      color: JudoColors.primary,
                    ),
                    onTap: onOpenProfile,
                  ),
                ),
              ],
            ),
            const SizedBox(height: JudoSpacing.lg),
            _ComingLaterJourneys(journeys: unavailableJourneys),
          ],
        );
      },
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.actionKey,
    required this.content,
    required this.onTap,
  });

  final String actionKey;
  final _JourneyContent content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      enabled: true,
      child: Material(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.md),
        child: InkWell(
          key: ValueKey(actionKey),
          onTap: onTap,
          borderRadius: BorderRadius.circular(JudoRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(JudoSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: content.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(JudoRadius.sm),
                  ),
                  child: Icon(
                    content.icon,
                    color: content.color,
                    size: JudoIconSize.md,
                  ),
                ),
                const SizedBox(width: JudoSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(content.title, style: JudoTypography.titleLarge),
                      const SizedBox(height: JudoSpacing.xs),
                      Text(
                        content.description,
                        style: JudoTypography.bodySmall,
                      ),
                      const SizedBox(height: JudoSpacing.sm),
                      Text(
                        l10n.availableLabel,
                        key: ValueKey('$actionKey-status'),
                        style: JudoTypography.labelMedium.copyWith(
                          color: JudoColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComingLaterJourneys extends StatelessWidget {
  const _ComingLaterJourneys({required this.journeys});

  final List<AthleteHomeJourney> journeys;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      enabled: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(JudoSpacing.md),
        decoration: BoxDecoration(
          color: JudoColors.surfaceVariant,
          borderRadius: BorderRadius.circular(JudoRadius.md),
          border: Border.all(color: JudoColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.moduleUnavailableDeferredTitle,
              style: JudoTypography.titleMedium,
            ),
            const SizedBox(height: JudoSpacing.sm),
            Wrap(
              spacing: JudoSpacing.sm,
              runSpacing: JudoSpacing.sm,
              children: journeys
                  .map((journey) {
                    final content = _journeyContent(l10n, journey.id);
                    return Chip(
                      key: ValueKey('home-coming-later-${journey.id.name}'),
                      avatar: Icon(content.icon, size: JudoIconSize.xs),
                      label: Text(content.title),
                    );
                  })
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyContent {
  const _JourneyContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

_JourneyContent _journeyContent(
  AppLocalizations l10n,
  AthleteHomeJourneyId id,
) => switch (id) {
  AthleteHomeJourneyId.learn => _JourneyContent(
    title: l10n.journeyLearnTitle,
    description: l10n.homeJourneyLearnDescription,
    icon: JudoIcons.throwTechnique,
    color: JudoColors.primary,
  ),
  AthleteHomeJourneyId.train => _JourneyContent(
    title: l10n.journeyTrainTitle,
    description: l10n.homeJourneyTrainUnavailable,
    icon: JudoIcons.training,
    color: JudoColors.textHint,
  ),
  AthleteHomeJourneyId.analyze => _JourneyContent(
    title: l10n.homeAnalyzeUchiMataTitle,
    description: l10n.homeJourneyAnalyzeDescription,
    icon: JudoIcons.aiAnalysis,
    color: JudoColors.gold,
  ),
  AthleteHomeJourneyId.trackProgress => _JourneyContent(
    title: l10n.journeyTrackProgressTitle,
    description: l10n.homeJourneyTrackProgressDescription,
    icon: JudoIcons.timing,
    color: JudoColors.success,
  ),
  AthleteHomeJourneyId.connectWithCoach => _JourneyContent(
    title: l10n.journeyConnectCoachTitle,
    description: l10n.homeJourneyCoachUnavailable,
    icon: JudoIcons.coach,
    color: JudoColors.textHint,
  ),
};

class _ContinueTile extends StatelessWidget {
  const _ContinueTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: JudoColors.surface,
      borderRadius: BorderRadius.circular(JudoRadius.sm),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: JudoColors.primary),
        title: Text(title, style: JudoTypography.titleMedium),
        trailing: Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
      ),
    );
  }
}
