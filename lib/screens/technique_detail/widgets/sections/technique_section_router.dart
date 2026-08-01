import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_badge.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../models/technique_model.dart';

import '../competition/competition_section.dart';
import '../media/media_section.dart';
import '../quiz_section.dart';
import '../tactical/tactical_intelligence_section.dart';
import '../technique_bottom_sheet.dart';
import '../technique_dashboard_grid.dart';

import 'overview_section.dart';
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

  static Future<void> open({
    required BuildContext context,
    required TechniqueDashboardSection section,
    required TechniqueModel technique,
  }) async {
    switch (section) {
      case TechniqueDashboardSection.overview:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Overview',
          icon: Icons.dashboard_customize_outlined,
          accentColor: JudoColors.primary,
          child: OverviewSection(
            technique: technique,
          ),
        );

      case TechniqueDashboardSection.videos:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Watch',
          icon: Icons.play_circle_outline_rounded,
          accentColor: JudoColors.primary,
          initialChildSize: 0.88,
          child: MediaSection(
            technique: technique,
          ),
        );

      case TechniqueDashboardSection.technicalAnalysis:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Technical Analysis',
          icon: Icons.analytics_outlined,
          accentColor: JudoColors.primary,
          initialChildSize: 0.88,
          child: TechnicalAnalysisSection(
            technique: technique,
          ),
        );

      case TechniqueDashboardSection.training:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Training',
          icon: Icons.fitness_center_rounded,
          accentColor: JudoColors.primary,
          child: const TechniqueSectionPlaceholder(
            title: 'Technique Training',
            description:
                'A progressive training pathway for learning and applying the technique safely.',
            icon: Icons.fitness_center_rounded,
            accentColor: JudoColors.primary,
            plannedFeatures: [
              'Shadow movement and solo-entry drills',
              'Uchikomi repetition programmes',
              'Nagekomi progression',
              'Partner timing drills',
              'Resistance and reaction drills',
              'Technique-specific strength exercises',
              'Mobility and injury-prevention guidance',
            ],
          ),
        );

      case TechniqueDashboardSection.tactical:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Tactical Intelligence',
          icon: Icons.psychology_alt_outlined,
          accentColor: JudoColors.success,
          initialChildSize: 0.86,
          child: TacticalIntelligenceSection(
            technique: technique,
          ),
        );

      case TechniqueDashboardSection.competition:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Competition Analysis',
          icon: Icons.emoji_events_outlined,
          accentColor: JudoColors.success,
          initialChildSize: 0.86,
          child: CompetitionAnalysisSection(
            technique: technique,
          ),
        );

      case TechniqueDashboardSection.combinations:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Combinations',
          icon: Icons.account_tree_outlined,
          accentColor: JudoColors.success,
          child: _TechniqueListContent(
            title: 'Approved Combinations',
            emptyMessage:
                'Combination data has not been added for this technique yet.',
            icon: Icons.account_tree_outlined,
            accentColor: JudoColors.success,
            items: technique.combinations,
          ),
        );

      case TechniqueDashboardSection.mistakesAndSafety:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Mistakes & Safety',
          icon: Icons.health_and_safety_outlined,
          accentColor: JudoColors.danger,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TechniqueListContent(
                title: 'Common Mistakes',
                emptyMessage:
                    'No common mistakes have been recorded yet.',
                icon: Icons.warning_amber_rounded,
                accentColor: JudoColors.danger,
                items: technique.commonMistakes,
              ),
              const SizedBox(height: JudoSpacing.xl),
              _TechniqueListContent(
                title: 'Safety Guidance',
                emptyMessage:
                    'Safety guidance has not been added yet.',
                icon: Icons.health_and_safety_outlined,
                accentColor: JudoColors.warning,
                items: technique.safetyTips,
              ),
            ],
          ),
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
          child: _ChampionsContent(
            champions: technique.famousUsers,
          ),
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
            description:
                technique.aiTrainingAdvice.trim().isEmpty
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
          title: 'Technique Quiz',
          icon: Icons.quiz_outlined,
          accentColor: JudoColors.gold,
          initialChildSize: 0.92,
          child: QuizSection(
            quizzes: technique.quiz,
          ),
        );

      case TechniqueDashboardSection.sources:
        return TechniqueBottomSheet.show<void>(
          context: context,
          title: 'Official Sources',
          icon: Icons.verified_outlined,
          accentColor: JudoColors.gold,
          child: _SourcesContent(
            sources: technique.sources,
          ),
        );
    }
  }
}

class _TechniqueListContent extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final IconData icon;
  final Color accentColor;
  final List<String> items;

  const _TechniqueListContent({
    required this.title,
    required this.emptyMessage,
    required this.icon,
    required this.accentColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final visibleItems = items
        .where(
          (item) => item.trim().isNotEmpty,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContentHeader(
          title: title,
          icon: icon,
          accentColor: accentColor,
        ),
        const SizedBox(height: JudoSpacing.lg),
        if (visibleItems.isEmpty)
          _EmptyContent(
            message: emptyMessage,
            icon: icon,
          )
        else
          ...visibleItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(
                bottom: JudoSpacing.sm,
              ),
              child: JudoCard(
                padding: const EdgeInsets.all(
                  JudoSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: accentColor,
                      size: JudoIconSize.sm,
                    ),
                    const SizedBox(width: JudoSpacing.sm),
                    Expanded(
                      child: Text(
                        item,
                        style: JudoTypography.bodyMedium,
                      ),
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

class _ChampionsContent extends StatelessWidget {
  final List<String> champions;

  const _ChampionsContent({
    required this.champions,
  });

  @override
  Widget build(BuildContext context) {
    final visibleChampions = champions
        .where(
          (item) => item.trim().isNotEmpty,
        )
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
            padding: const EdgeInsets.only(
              bottom: JudoSpacing.sm,
            ),
            child: JudoCard(
              borderColor: JudoColors.gold.withValues(
                alpha: 0.35,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.sports_martial_arts_rounded,
                    color: JudoColors.gold,
                    size: JudoIconSize.md,
                  ),
                  const SizedBox(width: JudoSpacing.md),
                  Expanded(
                    child: Text(
                      champion,
                      style: JudoTypography.titleSmall,
                    ),
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

class _SourcesContent extends StatelessWidget {
  final List<TechniqueSource> sources;

  const _SourcesContent({
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return const _EmptyContent(
        message:
            'No official references have been added for this technique.',
        icon: Icons.verified_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: JudoSpacing.sm,
          runSpacing: JudoSpacing.sm,
          children: [
            JudoBadge(
              text: 'Official',
              type: JudoBadgeType.official,
            ),
            JudoBadge(
              text: 'Verified',
              type: JudoBadgeType.verified,
            ),
          ],
        ),
        const SizedBox(height: JudoSpacing.lg),
        ...sources.map(
          (source) => Padding(
            padding: const EdgeInsets.only(
              bottom: JudoSpacing.sm,
            ),
            child: JudoCard(
              padding: const EdgeInsets.all(
                JudoSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: JudoColors.gold,
                    size: JudoIconSize.sm,
                  ),
                  const SizedBox(width: JudoSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          source.title,
                          style: JudoTypography.titleSmall,
                        ),
                        if (source.url.trim().isNotEmpty) ...[
                          const SizedBox(
                            height: JudoSpacing.xs,
                          ),
                          Text(
                            source.url,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: JudoTypography.bodySmall,
                          ),
                        ],
                      ],
                    ),
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
            color: accentColor.withValues(
              alpha: 0.14,
            ),
            borderRadius: BorderRadius.circular(
              JudoRadius.sm,
            ),
          ),
          child: Icon(
            icon,
            color: accentColor,
            size: JudoIconSize.sm,
          ),
        ),
        const SizedBox(width: JudoSpacing.md),
        Expanded(
          child: Text(
            title,
            style: JudoTypography.headingSmall.copyWith(
              color: accentColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyContent extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyContent({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return JudoCard(
      child: Column(
        children: [
          Icon(
            icon,
            color: JudoColors.textHint,
            size: JudoIconSize.lg,
          ),
          const SizedBox(height: JudoSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: JudoTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}