import 'widgets/competition/competition_section.dart';
import 'widgets/tactical/tactical_intelligence_section.dart';
import 'widgets/description/description_section.dart';
import 'widgets/ijf_profile/ijf_profile_section.dart';
import 'widgets/media/media_section.dart';
import 'widgets/basic_info/basic_info_section.dart';
import 'widgets/hero/hero_section.dart';
import 'widgets/sections/technical_analysis_section.dart';
import 'widgets/sections/overview_section.dart';
import 'package:flutter/material.dart';
import '../../models/technique_model.dart';
import '../../core/widgets/judo_card.dart';
import '../../core/widgets/judo_icon.dart';
import '../../core/widgets/judo_section_title.dart';
import 'widgets/technical_analysis.dart';
import 'widgets/quiz_section.dart';
import 'widgets/technique_dashboard_grid.dart';
import 'widgets/technique_bottom_sheet.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/language/language_provider.dart';
import '../../core/providers/favorite_provider.dart';
import '../../core/widgets/judo_premium_button.dart';
import '../../core/providers/recent_techniques_provider.dart';
class TechniqueDetailScreen extends StatelessWidget {

  final TechniqueModel technique;


  const TechniqueDetailScreen({
    super.key,
    required this.technique,
  });


void _openTechniqueSection(
  BuildContext context,
  TechniqueDashboardSection section,
) {
  switch (section) {
   

    case TechniqueDashboardSection.overview:
  TechniqueBottomSheet.show(
    context: context,
    title: 'Overview',
    icon: Icons.dashboard_customize_outlined,
    child: OverviewSection(
      technique: technique,
    ),
  );
  break;

case TechniqueDashboardSection.technicalAnalysis:
  TechniqueBottomSheet.show(
    context: context,
    title: 'Technical Analysis',
    icon: Icons.analytics_outlined,
    child: TechnicalAnalysisSection(
      technique: technique,
    ),
  );
  break;

    default:
      TechniqueBottomSheet.show(
        context: context,
        title: 'Coming Soon',
        icon: Icons.construction_outlined,
        child: const Text(
          'This section will be available soon.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
  }
}

  @override
  Widget build(BuildContext context) {
    final languageProvider =
    Provider.of<LanguageProvider>(context);

final translation =
    technique.getTranslation(
      languageProvider.languageCode,
    );

    final l10n = AppLocalizations.of(context)!;


  
    return Scaffold(

      backgroundColor: const Color(0xFF050505),

      appBar: AppBar(
  backgroundColor: const Color(0xFF050505),
  foregroundColor: Colors.white,
  elevation: 0,
  title: Text(
    translation?.name ?? technique.nameEn,
    style: const TextStyle(
      color: Color(0xFFD4AF37),
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
  ),
  actions: [

    Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {

        final isFavorite =
            favoriteProvider.isFavorite(technique.id);

        return IconButton(

          splashRadius: 26,

          onPressed: () async {

            await favoriteProvider.toggleFavorite(
              technique.id,
            );

          },

          icon: AnimatedSwitcher(

            duration: const Duration(milliseconds: 250),

            child: Icon(

              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_add_outlined,

              key: ValueKey(isFavorite),

              color: isFavorite
                  ? const Color(0xFFD4AF37)
                  : Colors.white,

              size: 30,

            ),

          ),

        );

      },

    ),

    const SizedBox(width: 10),

  ],

),
        


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Center(

          child: ConstrainedBox(

            constraints: const BoxConstraints(
              maxWidth: 900,
            ),


            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,


              children: [


                HeroSection(
  technique: technique,
  title: translation?.name ?? technique.nameEn,
),

const SizedBox(height: 20),



                BasicInfoSection(
  technique: technique,
),



                const SizedBox(height: 25),


                IjfProfileSection(
  technique: technique,
),

const SizedBox(height: 25),



                MediaSection(
  technique: technique,
),



                const SizedBox(height: 30),



                DescriptionSection(
  title: l10n.description,
  description:
      translation?.description ?? technique.description,
),



                const SizedBox(height: 30),



                TechnicalAnalysis(

  kuzushi:
    (translation?.executionSteps.length ?? 0) > 0
        ? translation!.executionSteps[0]
        : technique.kuzushi,

  tsukuri:
    (translation?.executionSteps.length ?? 0) > 1
        ? translation!.executionSteps[1]
        : technique.tsukuri,

  kake:
    (translation?.executionSteps.length ?? 0) > 2
        ? translation!.executionSteps[2]
        : technique.kake,

),

TechniqueDashboardGrid(
  onSectionTap: (section) {
    _openTechniqueSection(
      context,
      section,
    );
  },
),



                const SizedBox(height: 30),

TacticalIntelligenceSection(
  technique: technique,
),

const SizedBox(height: 30),
_ChampionsCard(
  technique: technique,
),

const SizedBox(height: 30),

CompetitionAnalysisSection(
  technique: technique,
),

const SizedBox(height: 24),

_TechniqueActions(
  technique: technique,
),

const SizedBox(height: 30),

                _StringListSection(

  title: l10n.commonMistakes,

  items:
      translation?.commonMistakes.isNotEmpty == true
          ? translation!.commonMistakes
          : technique.commonErrors,

  iconType: "warning",

),



                const SizedBox(height: 25),



                _StringListSection(

  title: l10n.combinations,

  items:
      translation?.combinations.isNotEmpty == true
          ? translation!.combinations
          : technique.combinations,

  iconType: "technique",

),



                const SizedBox(height: 30),

_TechniqueMasteryCard(
  technique: technique,
),

const SizedBox(height: 30),

_SensiBotRecommendationCard(
  technique: technique,
),

const SizedBox(height: 30),

Text(
  "Quiz Count: ${technique.quiz.length}",
  style: const TextStyle(
    color: Colors.red,
    fontSize: 20,
  ),
),

              QuizSection(

  quizzes: technique.quiz,

),



                const SizedBox(height: 30),



                _StringListSection(

title: l10n.source,
                  items: technique.sources
    .map((source) => source.title)
    .toList(),

                  iconType: "source",

                ),



                const SizedBox(height: 40),


              ],

            ),

          ),

        ),

      ),

    );

  }

}


class _StringListSection extends StatelessWidget {


  final String title;

  final List<String> items;

  final String iconType;



  const _StringListSection({

    required this.title,

    required this.items,

    required this.iconType,

  });



  @override
  Widget build(BuildContext context) {


    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,


      children: [


        JudoSectionTitle(

          title: title,

          iconType: iconType,

        ),


        const SizedBox(height: 12),



        ...items.map(

          (item) => Padding(

            padding: const EdgeInsets.only(
              bottom: 10,
            ),


            child: JudoCard(

              child: Row(

                children: [


                  JudoIcon(

                    type: iconType,

                    size: 26,

                  ),



                  const SizedBox(width: 12),



                  Expanded(

                    child: Text(

                      item,


                      style: const TextStyle(

                        color: Colors.white70,

                        fontSize: 15,

                      ),

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


class _ChampionsCard extends StatelessWidget {

  final TechniqueModel technique;


  const _ChampionsCard({
    required this.technique,
  });


  @override
  Widget build(BuildContext context) {


    if (technique.famousUsers.isEmpty) {
      return const SizedBox();
    }


    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(20),


      decoration: BoxDecoration(

        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(

          color: const Color(0xFFD4AF37),

        ),

      ),


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [


          const Text(

            "Champions Using This Technique",

            style: TextStyle(

              color: Color(0xFFD4AF37),

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 15),


          ...technique.famousUsers.map(

            (champion) => Padding(

              padding:

                  const EdgeInsets.only(bottom: 8),


              child: Row(

                children: [


                  const Icon(

                    Icons.sports_martial_arts,

                    color: Color(0xFFD4AF37),

                    size: 22,

                  ),


                  const SizedBox(width: 10),


                  Text(

                    champion,

                    style: const TextStyle(

                      color: Colors.white,

                      fontWeight: FontWeight.bold,

                    ),

                  ),


                ],

              ),

            ),

          ),

        ],

      ),

    );

  }

}
class _TechniqueActions extends StatelessWidget {
  final TechniqueModel technique;

  const _TechniqueActions({
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();

    final bool isFavorite =
        favoriteProvider.isFavorite(technique.id);

    return Column(
      children: [

        JudoPremiumButton(
          label: isFavorite
              ? "Remove from Favorites"
              : "Add to Favorites",

          icon: isFavorite
              ? Icons.bookmark_rounded
              : Icons.bookmark_add_rounded,

          accentColor: const Color(0xFFD4AF37),

          onPressed: () async {

            await favoriteProvider.toggleFavorite(
              technique.id,
            );

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(

              SnackBar(

                content: Text(

                  isFavorite
                      ? "Removed from Favorites"
                      : "Added to Favorites",

                ),

              ),

            );

          },
        ),

        const SizedBox(height: 14),

        JudoPremiumButton(
          label: "Start Training",

          icon: Icons.sports_martial_arts_rounded,

          accentColor: const Color(0xFF0066FF),

          onPressed: () {

          },

        ),

        const SizedBox(height: 14),

        JudoPremiumButton(
          label: "Track Progress",

          icon: Icons.insights_rounded,

          accentColor: Colors.green,

          onPressed: () {

          },

        ),

      ],
    );
  }
}

class _TechniqueMasteryCard extends StatelessWidget {

  final TechniqueModel technique;

  const _TechniqueMasteryCard({
    required this.technique,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xFFD4AF37),
        ),

      ),


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(

            "Technique Mastery",

            style: TextStyle(

              color: Color(0xFFD4AF37),

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 15),


          const Text(

            "Learning Progress",

            style: TextStyle(
              color: Colors.white70,
            ),

          ),


          const SizedBox(height: 10),


          LinearProgressIndicator(

            value: 0.35,

            minHeight: 10,

            backgroundColor:
                Color(0xFF222222),

            valueColor:
                AlwaysStoppedAnimation<Color>(
                  Color(0xFF0066FF),
                ),

          ),


          const SizedBox(height: 15),


          Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              _MasteryItem(
                title: "Theory",
                value: "40%",
              ),

              _MasteryItem(
                title: "Technique",
                value: "30%",
              ),

              _MasteryItem(
                title: "Competition",
                value: "20%",
              ),

            ],

          ),

        ],

      ),

    );

  }

}




class _MasteryItem extends StatelessWidget {

  final String title;

  final String value;


  const _MasteryItem({

    required this.title,

    required this.value,

  });


  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        Text(

          value,

          style: const TextStyle(

            color: Colors.white,

            fontWeight: FontWeight.bold,

            fontSize: 18,

          ),

        ),


        Text(

          title,

          style: const TextStyle(

            color: Colors.white54,

          ),

        ),

      ],

    );

  }

}
class _SensiBotRecommendationCard extends StatelessWidget {

  final TechniqueModel technique;

  const _SensiBotRecommendationCard({
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xFF0066FF),
        ),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            "Sensi Bot Recommendation",
            style: TextStyle(
              color: Color(0xFF0066FF),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(

            technique.aiTrainingAdvice,

            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),

          ),

        ],

      ),

    );

  }

}