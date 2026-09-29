import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/language/language_provider.dart';
import '../../core/providers/favorite_provider.dart';
import '../../core/scientific_transparency/uchi_mata_scientific_transparency.dart';
import '../../core/theme/judo_design_tokens.dart';
import '../../core/widgets/judo_app_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../models/technique_model.dart';

import 'widgets/actions/technique_primary_actions.dart';
import 'widgets/content/technique_content_widgets.dart';
import 'widgets/hero/hero_section.dart';
import 'widgets/scientific_transparency/scientific_transparency_panel.dart';
import 'widgets/sections/technique_section_router.dart';
import 'widgets/technique_dashboard_grid.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Screen: Technique Detail
/// Reference Technique: Uchi Mata
/// Version: 4.0.0
/// ----------------------------------------------------------------
///
/// Final main-screen structure:
///
/// - Compact App Bar
/// - Technique identity through HeroSection
/// - Learning Dashboard
/// - Primary actions
///
/// Removed from the main page:
///
/// - Repeated BasicInfoSection
/// - TechniqueMediaPreview
/// - Complete MediaSection
/// - Duplicate image entry
/// - Duplicate media navigation
///
/// The Media Library is accessible only through the Dashboard.
class TechniqueDetailScreen extends StatelessWidget {
  final TechniqueModel technique;

  const TechniqueDetailScreen({super.key, required this.technique});

  void _openTechniqueSection(
    BuildContext context,
    TechniqueDashboardSection section,
  ) {
    TechniqueSectionRouter.open(
      context: context,
      section: section,
      technique: technique,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!UchiMataScientificTransparency.isGovernedTechniqueId(technique.id)) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        key: const ValueKey<String>('specialized-technique-route-locked'),
        backgroundColor: JudoColors.background,
        appBar: const JudoAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(JudoSpacing.lg),
          child: TechniqueContentNotice(
            message: l10n.techniqueSectionUnavailable,
            icon: Icons.lock_outline_rounded,
            accentColor: JudoColors.textSecondary,
          ),
        ),
      );
    }

    final languageProvider = context.watch<LanguageProvider>();

    final favoriteProvider = context.watch<FavoriteProvider>();

    final translation = technique.getTranslation(languageProvider.languageCode);

    final techniqueTitle = translation?.name ?? technique.nameEn;

    final isFavorite = favoriteProvider.isFavorite(technique.id);

    final showsScientificTransparency =
        UchiMataScientificTransparency.isGovernedTechniqueId(technique.id);
    final scientificSnapshot = UchiMataScientificTransparency.forTechnique(
      technique.id,
    );

    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: JudoAppBar(
        title: null,
        subtitle: null,
        isFavorite: isFavorite,
        onFavorite: () async {
          await favoriteProvider.toggleFavorite(technique.id);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          JudoSpacing.sm,
          JudoSpacing.lg,
          JudoSpacing.xxxl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroSection(technique: technique, title: techniqueTitle),

                const SizedBox(height: JudoSpacing.xxl),

                if (showsScientificTransparency) ...[
                  ScientificStatusCard(snapshot: scientificSnapshot),
                  const SizedBox(height: JudoSpacing.xl),
                ],

                TechniquePrimaryActions(
                  technique: technique,
                  onAiAnalysis: () {
                    _openTechniqueSection(
                      context,
                      TechniqueDashboardSection.aiAnalysis,
                    );
                  },
                ),

                const SizedBox(height: JudoSpacing.xl),

                TechniqueDashboardGrid(
                  quizQuestionCount: technique.quiz.length,
                  isSectionAvailable: (section) {
                    return TechniqueSectionRouter.isAvailable(
                      section: section,
                      technique: technique,
                      languageCode: languageProvider.languageCode,
                    );
                  },
                  onSectionTap: (section) {
                    _openTechniqueSection(context, section);
                  },
                ),

                const SizedBox(height: JudoSpacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
