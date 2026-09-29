import '../analyze/analyze_section.dart';
import '../../../../core/routes/app_routes.dart';
import 'conditioning_section.dart';
import 'resistance_band_training_section.dart';
import 'shadow_training_section.dart';
import 'training_section.dart';
import 'package:flutter/material.dart';
import 'biomechanics_section.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../data/media/technique_media_registry.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_training_content.dart';

import '../competition/competition_section.dart';
import '../media/media_section.dart';
import '../quiz_section.dart';
import '../tactical/tactical_intelligence_section.dart';
import '../technique_bottom_sheet.dart';
import '../technique_dashboard_grid.dart';

import 'overview_section.dart';
import 'combination_counter_flow.dart';
import 'mistakes_safety_section.dart';
import 'sources_section.dart';
import 'technical_analysis_section.dart';
import 'technique_section_placeholder.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Technique Section Router
/// Reference Technique: Uchi Mata
/// ----------------------------------------------------------------
///
/// Responsibilities:
/// - Route every dashboard item to its approved content.
/// - Prevent large content from remaining inside TechniqueDetailScreen.
/// - Provide standardized placeholders for unfinished sections.
/// - Keep the dashboard architecture reusable for all 67 techniques.
abstract final class TechniqueSectionRouter {
  const TechniqueSectionRouter._();

  static bool isAvailable({
    required TechniqueDashboardSection section,
    required TechniqueModel technique,
    String languageCode = 'en',
  }) {
    return switch (section) {
      TechniqueDashboardSection.videos =>
        languageCode == 'en' &&
            (technique.hasProfessionalMedia ||
                TechniqueMediaRegistry.getMedia(
                  technique.id,
                ).any((item) => item.hasValidMedia)),
      TechniqueDashboardSection.training => false,
      TechniqueDashboardSection.aiAnalysis =>
        technique.supportsReviewedSingleAttemptV2A,
      TechniqueDashboardSection.shadowTraining =>
        technique.trainingContent.hasAvailableDrillsFor(
          TechniqueTrainingDrillKind.shadowTraining,
          languageCode,
        ),
      TechniqueDashboardSection.conditioning =>
        technique.trainingContent.hasAvailableDrillsFor(
          TechniqueTrainingDrillKind.strengthConditioning,
          languageCode,
        ),
      TechniqueDashboardSection.resistanceBandTraining =>
        technique.trainingContent.hasAvailableDrillsFor(
          TechniqueTrainingDrillKind.resistanceBand,
          languageCode,
        ),
      TechniqueDashboardSection.mastery ||
      TechniqueDashboardSection.sensiBot ||
      TechniqueDashboardSection.coachConnection => false,
      TechniqueDashboardSection.champions => technique.famousUsers.any(
        (champion) => champion.trim().isNotEmpty,
      ),
      _ => true,
    };
  }

  static Future<void> open({
    required BuildContext context,
    required TechniqueDashboardSection section,
    required TechniqueModel technique,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    if (!isAvailable(
      section: section,
      technique: technique,
      languageCode: Localizations.localeOf(context).languageCode,
    )) {
      _showUnavailable(context, section);
      return;
    }

    switch (section) {
      case TechniqueDashboardSection.overview:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.overview,
          icon: Icons.dashboard_customize_outlined,
          accentColor: JudoColors.primary,
          child: OverviewSection(technique: technique),
        );

      case TechniqueDashboardSection.videos:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.videoLibrary,
          icon: Icons.video_library_outlined,
          accentColor: JudoColors.primary,
          initialChildSize: 0.92,
          child: MediaSection(technique: technique),
        );

      case TechniqueDashboardSection.technicalAnalysis:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.technicalAnalysis,
          icon: Icons.analytics_outlined,
          accentColor: JudoColors.primary,
          initialChildSize: 0.88,
          child: TechnicalAnalysisSection(technique: technique),
        );
      case TechniqueDashboardSection.biomechanics:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.biomechanics,
          icon: Icons.hub_outlined,
          accentColor: JudoColors.success,
          initialChildSize: 0.92,
          child: BiomechanicsSection(technique: technique),
        );

      case TechniqueDashboardSection.training:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.educationalPracticeTitle,
          icon: Icons.fitness_center_rounded,
          accentColor: JudoColors.primary,
          initialChildSize: 0.92,
          child: TrainingSection(technique: technique),
        );
      case TechniqueDashboardSection.shadowTraining:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.shadowTrainingTitle,
          icon: Icons.directions_run_outlined,
          accentColor: JudoColors.primary,
          initialChildSize: 0.92,
          child: ShadowTrainingSection(technique: technique),
        );

      case TechniqueDashboardSection.conditioning:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.strengthConditioningTitle,
          icon: Icons.sports_gymnastics_outlined,
          accentColor: JudoColors.success,
          initialChildSize: 0.92,
          child: ConditioningSection(technique: technique),
        );
      case TechniqueDashboardSection.resistanceBandTraining:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.resistanceBandTrainingTitle,
          icon: Icons.linear_scale_rounded,
          accentColor: JudoColors.gold,
          initialChildSize: 0.92,
          child: ResistanceBandTrainingSection(technique: technique),
        );
      case TechniqueDashboardSection.tactical:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.tacticalIntelligence,
          icon: Icons.psychology_alt_outlined,
          accentColor: JudoColors.success,
          initialChildSize: 0.86,
          child: TacticalIntelligenceSection(technique: technique),
        );

      case TechniqueDashboardSection.competition:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.competitionAnalysis,
          icon: Icons.emoji_events_outlined,
          accentColor: JudoColors.success,
          initialChildSize: 0.86,
          child: CompetitionAnalysisSection(technique: technique),
        );

      case TechniqueDashboardSection.combinations:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.combinations,
          icon: Icons.account_tree_outlined,
          accentColor: JudoColors.success,
          initialChildSize: 0.88,
          child: TechniqueCombinationCounterFlow(technique: technique),
        );

      case TechniqueDashboardSection.mistakesAndSafety:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.mistakesAndSafety,
          icon: Icons.health_and_safety_outlined,
          accentColor: JudoColors.danger,
          initialChildSize: 0.88,
          child: TechniqueMistakesSafetySection(technique: technique),
        );

      case TechniqueDashboardSection.mastery:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Mastery',
          icon: Icons.military_tech_outlined,
          accentColor: JudoColors.success,
          child: const TechniqueSectionPlaceholder(
            title: 'Technique Mastery Path',
            description:
                'Track progress from first understanding to reliable competition application.',
            icon: Icons.military_tech_outlined,
            accentColor: JudoColors.success,
            plannedFeatures: [
              'Theory-completion score',
              'Technical execution score',
              'Training consistency score',
              'Competition-application score',
              'Prerequisite techniques',
              'Recommended next technique',
              'Personal mastery timeline',
            ],
          ),
        );

      case TechniqueDashboardSection.champions:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Champions',
          icon: Icons.workspace_premium_outlined,
          accentColor: JudoColors.gold,
          child: _ChampionsContent(champions: technique.famousUsers),
        );

      case TechniqueDashboardSection.sensiBot:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Sensi Bot',
          icon: Icons.smart_toy_outlined,
          accentColor: JudoColors.gold,
          initialChildSize: 0.84,
          child: TechniqueSectionPlaceholder(
            title: 'Sensi Bot AI Coach',
            description: technique.aiTrainingAdvice.trim().isEmpty
                ? 'Personalized technical guidance will be generated from training history and AI analysis.'
                : technique.aiTrainingAdvice,
            icon: Icons.smart_toy_outlined,
            accentColor: JudoColors.gold,
            isAiFeature: true,
            plannedFeatures: const [
              'Personalized training recommendation',
              'Weakness-based corrective drills',
              'Technique-learning priorities',
              'Progress-based coaching guidance',
              'Connection to AI Fight Intelligence 360',
            ],
          ),
        );

      case TechniqueDashboardSection.quiz:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.techniqueQuiz,
          icon: Icons.quiz_outlined,
          accentColor: JudoColors.gold,
          initialChildSize: 0.92,
          child: QuizSection(quizzes: technique.quiz),
        );

      case TechniqueDashboardSection.sources:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.officialSources,
          icon: Icons.verified_outlined,
          accentColor: JudoColors.gold,
          child: TechniqueSourcesSection(sources: technique.sources),
        );
      case TechniqueDashboardSection.aiAnalysis:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.singleAttemptAnalysisTitle,
          icon: Icons.auto_graph_rounded,
          accentColor: JudoColors.gold,
          initialChildSize: 0.94,
          child: AnalyzeSection(technique: technique),
        );
      case TechniqueDashboardSection.analysisHistory:
        await Navigator.of(context).pushNamed(AppRoutes.localAnalysisHistory);
        return;
      case TechniqueDashboardSection.coachConnection:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: l10n.coachConnectionTitle,
          icon: Icons.person_outline_rounded,
          accentColor: JudoColors.gold,
          child: TechniqueSectionPlaceholder(
            title: l10n.coachConnectionTitle,
            description: l10n.coachConnectionUnavailable,
            icon: Icons.person_outline_rounded,
            accentColor: JudoColors.gold,
          ),
        );
    }
  }

  static void _showUnavailable(
    BuildContext context,
    TechniqueDashboardSection section,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final message = switch (section) {
      TechniqueDashboardSection.training => l10n.techniqueTrainingUnavailable,
      TechniqueDashboardSection.shadowTraining ||
      TechniqueDashboardSection.conditioning ||
      TechniqueDashboardSection.resistanceBandTraining =>
        l10n.trainingExperienceUnavailableDescription,
      TechniqueDashboardSection.mastery => l10n.techniqueMasteryUnavailable,
      TechniqueDashboardSection.champions => l10n.techniqueChampionsUnavailable,
      TechniqueDashboardSection.sensiBot => l10n.techniqueSensiBotUnavailable,
      TechniqueDashboardSection.coachConnection =>
        l10n.coachConnectionUnavailable,
      _ => l10n.techniqueSectionUnavailable,
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            key: ValueKey<String>(
              'technique-section-unavailable-${section.name}',
            ),
          ),
        ),
      );
  }
}

class _ChampionsContent extends StatelessWidget {
  final List<String> champions;

  const _ChampionsContent({required this.champions});

  @override
  Widget build(BuildContext context) {
    final visibleChampions = champions
        .where((item) => item.trim().isNotEmpty)
        .toList();

    if (visibleChampions.isEmpty) {
      return const TechniqueSectionPlaceholder(
        title: 'Champion Technique Library',
        description:
            'Verified elite athletes using this technique will appear here.',
        icon: Icons.workspace_premium_outlined,
        accentColor: JudoColors.gold,
        plannedFeatures: [
          'Olympic champions',
          'World champions',
          'Competition-video examples',
          'Athlete-specific execution styles',
          'Tactical comparison between champions',
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ContentHeader(
          title: 'Elite Athletes',
          icon: Icons.workspace_premium_outlined,
          accentColor: JudoColors.gold,
        ),
        const SizedBox(height: JudoSpacing.lg),
        ...visibleChampions.map(
          (champion) => Padding(
            padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
            child: JudoCard(
              borderColor: JudoColors.gold.withValues(alpha: 0.35),
              child: Row(
                children: [
                  const Icon(
                    Icons.sports_martial_arts_rounded,
                    color: JudoColors.gold,
                    size: JudoIconSize.md,
                  ),
                  const SizedBox(width: JudoSpacing.md),
                  Expanded(
                    child: Text(champion, style: JudoTypography.titleSmall),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContentHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;

  const _ContentHeader({
    required this.title,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(JudoRadius.sm),
          ),
          child: Icon(icon, color: accentColor, size: JudoIconSize.sm),
        ),
        const SizedBox(width: JudoSpacing.md),
        Expanded(
          child: Text(
            title,
            style: JudoTypography.headingSmall.copyWith(color: accentColor),
          ),
        ),
      ],
    );
  }
}
