import 'package:flutter/material.dart';

import '../../../core/design_system/icons/judo_icons.dart';
import '../../../core/theme/judo_design_tokens.dart';
import '../../../core/theme/judo_typography.dart';
import '../../../l10n/app_localizations.dart';

import 'technique_dashboard_item.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Widget: Technique Dashboard Grid
/// Module: Techniques
/// Reference Technique: Uchi Mata
/// Version: 4.1.0
/// ----------------------------------------------------------------
///
/// Responsibilities:
/// - Organize technique content into clear learning groups.
/// - Use the centralized Judo Mind icon registry.
/// - Support three-layer visual learning.
/// - Keep dashboard cards compact and mobile-friendly.
/// - Remain reusable for all 67 official techniques.
enum TechniqueDashboardSection {
  videos,
  overview,
  technicalAnalysis,
  biomechanics,
  training,
  shadowTraining,
  conditioning,
  resistanceBandTraining,
  tactical,
  competition,
  champions,
  mistakesAndSafety,
  combinations,
  mastery,
  sensiBot,
  quiz,
  sources,
  aiAnalysis,
  analysisHistory,
  coachConnection,
}

class TechniqueDashboardGrid extends StatelessWidget {
  final ValueChanged<TechniqueDashboardSection> onSectionTap;
  final bool Function(TechniqueDashboardSection section)? isSectionAvailable;
  final int quizQuestionCount;

  const TechniqueDashboardGrid({
    super.key,
    required this.onSectionTap,
    required this.quizQuestionCount,
    this.isSectionAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = _buildGroups(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.learningDashboardTitle, style: JudoTypography.headingMedium),
        const SizedBox(height: JudoSpacing.xs),
        Text(
          l10n.learningDashboardDescription,
          style: JudoTypography.bodySmall,
        ),
        const SizedBox(height: JudoSpacing.xl),
        ...groups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: JudoSpacing.xl),
            child: _DashboardGroup(
              group: group,
              onSectionTap: onSectionTap,
              isSectionAvailable: isSectionAvailable,
            ),
          ),
        ),
      ],
    );
  }

  List<_TechniqueDashboardGroupData> _buildGroups(AppLocalizations l10n) {
    return [
      _TechniqueDashboardGroupData(
        id: 'learn',
        title: l10n.journeyLearnTitle,
        subtitle: l10n.journeyLearnDescription,
        color: JudoColors.primary,
        items: [
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.overview,
            title: l10n.overview,
            icon: JudoIcons.overview,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.technicalAnalysis,
            title: l10n.technicalAnalysis,
            icon: JudoIcons.technicalAnalysis,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.biomechanics,
            title: l10n.biomechanics,
            icon: JudoIcons.biomechanics,
            badgeText: l10n.learnLabel,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.mistakesAndSafety,
            title: l10n.mistakesAndSafety,
            icon: JudoIcons.mistakesAndSafety,
            colorOverride: JudoColors.danger,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.combinations,
            title: l10n.combinations,
            icon: JudoIcons.combination,
          ),
        ],
      ),
      _TechniqueDashboardGroupData(
        id: 'progress',
        title: l10n.journeyTrackProgressTitle,
        subtitle: l10n.journeyTrackProgressDescription,
        color: JudoColors.success,
        items: [
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.analysisHistory,
            title: l10n.localAnalysisHistoryTitle,
            icon: JudoIcons.timing,
          ),
        ],
      ),
      _TechniqueDashboardGroupData(
        id: 'coming-later',
        title: l10n.moduleUnavailableDeferredTitle,
        subtitle: l10n.moduleNoApprovedDestination,
        color: JudoColors.textHint,
        items: [
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.training,
            title: l10n.journeyTrainTitle,
            icon: JudoIcons.training,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.coachConnection,
            title: l10n.journeyConnectCoachTitle,
            icon: JudoIcons.coach,
          ),
        ],
      ),
      _TechniqueDashboardGroupData(
        id: 'more',
        title: l10n.moreTechniqueSections,
        subtitle: l10n.learningDashboardDescription,
        color: JudoColors.textSecondary,
        items: [
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.videos,
            title: l10n.videoLibrary,
            icon: JudoIcons.mediaLibrary,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.shadowTraining,
            title: l10n.shadowTrainingTitle,
            icon: JudoIcons.shadowTraining,
            badgeText: l10n.visualLabel,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.conditioning,
            title: l10n.strengthConditioningTitle,
            icon: JudoIcons.conditioning,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.resistanceBandTraining,
            title: l10n.resistanceBandTrainingTitle,
            icon: JudoIcons.training,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.tactical,
            title: l10n.tacticalIntelligence,
            icon: JudoIcons.direction,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.competition,
            title: l10n.competitionAnalysis,
            icon: JudoIcons.ippon,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.champions,
            title: l10n.champions,
            icon: JudoIcons.champions,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.quiz,
            title: l10n.techniqueQuiz,
            icon: JudoIcons.quiz,
            badgeText: '$quizQuestionCount',
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.sources,
            title: l10n.officialSources,
            icon: JudoIcons.sources,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.mastery,
            title: l10n.techniqueMastery,
            icon: JudoIcons.mastery,
          ),
        ],
      ),
    ];
  }
}

class _DashboardGroup extends StatelessWidget {
  final _TechniqueDashboardGroupData group;

  final ValueChanged<TechniqueDashboardSection> onSectionTap;
  final bool Function(TechniqueDashboardSection section)? isSectionAvailable;

  const _DashboardGroup({
    required this.group,
    required this.onSectionTap,
    required this.isSectionAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JudoColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(JudoRadius.md),
        side: BorderSide(color: group.color.withValues(alpha: 0.24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: ValueKey<String>('journey-group-${group.id}'),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: JudoSpacing.md,
          vertical: JudoSpacing.xs,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          JudoSpacing.md,
          0,
          JudoSpacing.md,
          JudoSpacing.md,
        ),
        title: _GroupHeader(
          title: group.title,
          subtitle: group.subtitle,
          color: group.color,
        ),
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _crossAxisCount(constraints.maxWidth);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: group.items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: JudoSpacing.sm,
                  mainAxisSpacing: JudoSpacing.sm,
                  childAspectRatio: _childAspectRatio(
                    constraints.maxWidth,
                    crossAxisCount,
                  ),
                ),
                itemBuilder: (context, index) {
                  final item = group.items[index];
                  final isAvailable =
                      isSectionAvailable?.call(item.section) ?? true;
                  final l10n = AppLocalizations.of(context)!;

                  return TechniqueDashboardItem(
                    key: ValueKey<String>(
                      'dashboard-section-${item.section.name}',
                    ),
                    title: item.title,
                    subtitle: '',
                    icon: item.icon,
                    accentColor: item.colorOverride ?? group.color,
                    badgeText: isAvailable
                        ? item.badgeText
                        : l10n.unavailableLabel,
                    isEnabled: isAvailable,
                    onTap: isAvailable
                        ? () {
                            onSectionTap(item.section);
                          }
                        : null,
                    onUnavailableTap: isAvailable
                        ? null
                        : () {
                            onSectionTap(item.section);
                          },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  int _crossAxisCount(double width) {
    if (width >= 1100) {
      return 5;
    }

    if (width >= 720) {
      return 4;
    }

    return 2;
  }

  double _childAspectRatio(double width, int crossAxisCount) {
    if (crossAxisCount >= 4) {
      return 1.45;
    }

    if (width < 360) {
      return 1.08;
    }

    return 1.20;
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _GroupHeader({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(JudoRadius.xs),
          ),
        ),
        const SizedBox(width: JudoSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: JudoTypography.titleLarge.copyWith(color: color),
              ),
              const SizedBox(height: JudoSpacing.xs),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: JudoTypography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TechniqueDashboardGroupData {
  final String id;
  final String title;
  final String subtitle;
  final Color color;

  final List<_TechniqueDashboardItemData> items;

  const _TechniqueDashboardGroupData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.items,
  });
}

class _TechniqueDashboardItemData {
  final TechniqueDashboardSection section;

  final String title;
  final IconData icon;
  final String? badgeText;
  final Color? colorOverride;

  const _TechniqueDashboardItemData({
    required this.section,
    required this.title,
    required this.icon,
    this.badgeText,
    this.colorOverride,
  });
}
