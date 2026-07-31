import 'package:flutter/material.dart';

import 'technique_dashboard_item.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Widget: Technique Dashboard Grid
/// Module: Techniques
/// Version: 2.0.0
/// Status: Production
/// ----------------------------------------------------------------

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

  progress,

  sensiBot,

  quiz,

  sources,

}

class TechniqueDashboardGrid extends StatelessWidget {
  final ValueChanged<TechniqueDashboardSection> onSectionTap;

  const TechniqueDashboardGrid({
    super.key,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = _buildDashboardItems();

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(
          constraints.maxWidth,
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: _calculateChildAspectRatio(
              constraints.maxWidth,
              crossAxisCount,
            ),
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return TechniqueDashboardItem(
              title: item.title,
              subtitle: item.subtitle,
              icon: item.icon,
              accentColor: item.accentColor,
              badgeText: item.badgeText,
              isEnabled: item.isEnabled,
              onTap: () => onSectionTap(item.section),
            );
          },
        );
      },
    );
  }

  List<_TechniqueDashboardItemData> _buildDashboardItems() {
    return const [
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.videos,
        title: 'Videos',
        subtitle: 'Training and competition footage',
        icon: Icons.play_circle_outline_rounded,
        accentColor: Color(0xFF2F80ED),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.overview,
        title: 'Overview',
        subtitle: 'Identity and basic information',
        icon: Icons.dashboard_customize_outlined,
        accentColor: Color(0xFF00A8E8),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.technicalAnalysis,
        title: 'Technical Analysis',
        subtitle: 'Execution phases and key details',
        icon: Icons.analytics_outlined,
        accentColor: Color(0xFF7B61FF),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.training,
        title: 'Training',
        subtitle: 'Drills and practice methods',
        icon: Icons.fitness_center_rounded,
        accentColor: Color(0xFF00B894),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.tactical,
        title: 'Tactical Intelligence',
        subtitle: 'Timing, gripping and strategy',
        icon: Icons.psychology_alt_outlined,
        accentColor: Color(0xFFFFB020),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.competition,
        title: 'Competition',
        subtitle: 'Performance in real matches',
        icon: Icons.emoji_events_outlined,
        accentColor: Color(0xFFFF8A00),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.champions,
        title: 'Champions',
        subtitle: 'Elite athletes using this technique',
        icon: Icons.workspace_premium_outlined,
        accentColor: Color(0xFFD4AF37),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.mistakesAndSafety,
        title: 'Mistakes & Safety',
        subtitle: 'Common errors and injury prevention',
        icon: Icons.health_and_safety_outlined,
        accentColor: Color(0xFFFF5A5F),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.combinations,
        title: 'Combinations',
        subtitle: 'Entries, counters and transitions',
        icon: Icons.account_tree_outlined,
        accentColor: Color(0xFF00C2FF),
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.mastery,
        title: 'Mastery',
        subtitle: 'Advanced learning pathway',
        icon: Icons.military_tech_outlined,
        accentColor: Color(0xFF9B51E0),
      ),
      _TechniqueDashboardItemData(
  section: TechniqueDashboardSection.progress,
  title: 'Progress',
  subtitle: 'Learning and mastery tracking',
  icon: Icons.trending_up_outlined,
  accentColor: Color(0xFF9B51E0),
),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.sensiBot,
        title: 'Sensi Bot',
        subtitle: 'AI coaching recommendations',
        icon: Icons.smart_toy_outlined,
        accentColor: Color(0xFF00D1C1),
        badgeText: 'AI',
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.quiz,
        title: 'Quiz',
        subtitle: 'Test your technical knowledge',
        icon: Icons.quiz_outlined,
        accentColor: Color(0xFF6FCF97),
        badgeText: '10',
      ),
      _TechniqueDashboardItemData(
        section: TechniqueDashboardSection.sources,
        title: 'Official Sources',
        subtitle: 'IJF, Kodokan and references',
        icon: Icons.verified_outlined,
        accentColor: Color(0xFF56CCF2),
      ),
_TechniqueDashboardItemData(
  section: TechniqueDashboardSection.biomechanics,
  title: 'Biomechanics',
  subtitle: 'Movement and body analysis',
  icon: Icons.accessibility_new_outlined,
  accentColor: Color(0xFF00E5FF),
),
_TechniqueDashboardItemData(
  section: TechniqueDashboardSection.shadowTraining,
  title: 'Shadow Training',
  subtitle: 'Solo practice system',
  icon: Icons.sports_martial_arts_outlined,
  accentColor: Color(0xFF27AE60),
),
_TechniqueDashboardItemData(
  section: TechniqueDashboardSection.conditioning,
  title: 'Conditioning',
  subtitle: 'Physical preparation',
  icon: Icons.fitness_center_outlined,
  accentColor: Color(0xFFE67E22),
),
    ];
  }

  int _calculateCrossAxisCount(double width) {
    if (width >= 1100) {
      return 4;
    }

    if (width >= 720) {
      return 3;
    }

    return 2;
  }

  double _calculateChildAspectRatio(
    double availableWidth,
    int crossAxisCount,
  ) {
    if (crossAxisCount == 4) {
      return 1.12;
    }

    if (crossAxisCount == 3) {
      return 1.05;
    }

    if (availableWidth < 360) {
      return 0.82;
    }

    return 0.9;
  }
}

class _TechniqueDashboardItemData {
  final TechniqueDashboardSection section;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String? badgeText;
  final bool isEnabled;

  const _TechniqueDashboardItemData({
    required this.section,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.badgeText,
    this.isEnabled = true,
  });
}