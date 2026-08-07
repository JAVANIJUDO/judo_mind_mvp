import 'package:flutter/material.dart';

import '../../../core/design_system/icons/judo_icons.dart';
import '../../../core/theme/judo_design_tokens.dart';
import '../../../core/theme/judo_typography.dart';

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
}

class TechniqueDashboardGrid extends StatelessWidget {
  final ValueChanged<TechniqueDashboardSection> onSectionTap;

  const TechniqueDashboardGrid({super.key, required this.onSectionTap});

  @override
  Widget build(BuildContext context) {
    final groups = _buildGroups();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Learning Dashboard', style: JudoTypography.headingMedium),
        const SizedBox(height: JudoSpacing.xs),
        Text(
          'Watch, understand, practise, analyze and master the technique.',
          style: JudoTypography.bodySmall,
        ),
        const SizedBox(height: JudoSpacing.xl),
        ...groups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: JudoSpacing.xl),
            child: _DashboardGroup(group: group, onSectionTap: onSectionTap),
          ),
        ),
      ],
    );
  }

  List<_TechniqueDashboardGroupData> _buildGroups() {
    return const [
      _TechniqueDashboardGroupData(
        title: 'Learn',
        subtitle: 'Watch, understand and visually explore the technique',
        color: JudoColors.primary,
        items: [
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.overview,
            title: 'Overview',
            icon: JudoIcons.overview,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.videos,
            title: 'Media Library',
            icon: JudoIcons.mediaLibrary,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.technicalAnalysis,
            title: 'Technical Analysis',
            icon: JudoIcons.technicalAnalysis,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.biomechanics,
            title: 'Biomechanics',
            icon: JudoIcons.biomechanics,
            badgeText: 'Learn',
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.training,
            title: 'Training',
            icon: JudoIcons.training,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.shadowTraining,
            title: 'Shadow Training',
            icon: JudoIcons.shadowTraining,
            badgeText: 'Visual',
          ),
        ],
      ),
      _TechniqueDashboardGroupData(
        title: 'Performance',
        subtitle: 'Build physical ability and apply the technique',
        color: JudoColors.success,
        items: [
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.conditioning,
            title: 'Conditioning',
            icon: JudoIcons.conditioning,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.tactical,
            title: 'Tactical',
            icon: JudoIcons.direction,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.competition,
            title: 'Competition',
            icon: JudoIcons.ippon,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.combinations,
            title: 'Combinations',
            icon: JudoIcons.combination,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.mistakesAndSafety,
            title: 'Mistakes & Safety',
            icon: JudoIcons.mistakesAndSafety,
            colorOverride: JudoColors.danger,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.mastery,
            title: 'Mastery',
            icon: JudoIcons.mastery,
          ),
        ],
      ),
      _TechniqueDashboardGroupData(
        title: 'Professional',
        subtitle: 'Advanced knowledge and intelligent tools',
        color: JudoColors.gold,
        items: [
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.champions,
            title: 'Champions',
            icon: JudoIcons.champions,
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.sensiBot,
            title: 'Sensi Bot',
            icon: JudoIcons.aiCoach,
            badgeText: 'AI',
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.quiz,
            title: 'Quiz',
            icon: JudoIcons.quiz,
            badgeText: '10',
          ),
          _TechniqueDashboardItemData(
            section: TechniqueDashboardSection.sources,
            title: 'Sources',
            icon: JudoIcons.sources,
          ),
        ],
      ),
    ];
  }
}

class _DashboardGroup extends StatelessWidget {
  final _TechniqueDashboardGroupData group;

  final ValueChanged<TechniqueDashboardSection> onSectionTap;

  const _DashboardGroup({required this.group, required this.onSectionTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupHeader(
          title: group.title,
          subtitle: group.subtitle,
          color: group.color,
        ),
        const SizedBox(height: JudoSpacing.md),
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

                return TechniqueDashboardItem(
                  title: item.title,
                  subtitle: '',
                  icon: item.icon,
                  accentColor: item.colorOverride ?? group.color,
                  badgeText: item.badgeText,
                  isEnabled: item.isEnabled,
                  onTap: () {
                    onSectionTap(item.section);
                  },
                );
              },
            );
          },
        ),
      ],
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
  final String title;
  final String subtitle;
  final Color color;

  final List<_TechniqueDashboardItemData> items;

  const _TechniqueDashboardGroupData({
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
  final bool isEnabled;

  const _TechniqueDashboardItemData({
    required this.section,
    required this.title,
    required this.icon,
    this.badgeText,
    this.colorOverride,
    this.isEnabled = true,
  });
}
