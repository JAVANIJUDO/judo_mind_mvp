import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/technique_model.dart';
import '../../core/widgets/judo_card.dart';
import '../../core/widgets/judo_icon.dart';
import '../../core/widgets/judo_section_title.dart';
import 'widgets/technical_analysis.dart';
import 'widgets/quiz_section.dart';
import 'widgets/video_buttons.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/language/language_provider.dart';

class TechniqueDetailScreen extends StatelessWidget {

  final TechniqueModel technique;


  const TechniqueDetailScreen({
    super.key,
    required this.technique,
  });


  Future<void> openVideo(String url) async {

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
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

          style: const TextStyle(color: Color(0xFFD4AF37),

    fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
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


                Text(

  translation?.name ?? technique.nameEn,


                  style: const TextStyle(

                    color: Color(0xFFD4AF37),

                    fontSize: 32,

                    fontWeight: FontWeight.bold,

                  ),

                ),


                const SizedBox(height: 20),



                _BasicInfoCard(
                  technique: technique,
                ),



                const SizedBox(height: 25),


                _IJFProfileCard(
  technique: technique,
),

const SizedBox(height: 25),



                _TechniqueMedia(
                  technique: technique,
                ),



                const SizedBox(height: 30),



                const _SectionTitle(
                  title: "Overview",
                ),


                const SizedBox(height: 10),



                _BodyText(
                  text: translation?.description ?? technique.description
                ),



                const SizedBox(height: 30),



                TechnicalAnalysis(

                  kuzushi: technique.kuzushi,

                  tsukuri: technique.tsukuri,

                  kake: technique.kake,

                ),



                const SizedBox(height: 30),

_TacticalIntelligenceCard(
  technique: technique,
),

const SizedBox(height: 30),
_ChampionsCard(
  technique: technique,
),

const SizedBox(height: 30),
_CompetitionAnalysisCard(
  technique: technique,
),

const SizedBox(height: 30),

_CompetitionAnalysisCard(
  technique: technique,
),

const SizedBox(height: 30),

_TechniqueActions(
  technique: technique,
),

const SizedBox(height: 30),

                _StringListSection(

                  title: "Common Errors",

                  items: technique.commonErrors,

                  iconType: "warning",

                ),



                const SizedBox(height: 25),



                _StringListSection(

                  title: "Combinations",

                  items: technique.combinations,

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

                  title: "Official Sources",

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

class _BasicInfoCard extends StatelessWidget {

  final TechniqueModel technique;


  const _BasicInfoCard({
    required this.technique,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFF0066FF),
        ),

      ),


      child: Wrap(

        spacing: 12,

        runSpacing: 12,


        children: [


          _InfoChip(
            label: "Category",
            value: technique.category,
          ),


          _InfoChip(
            label: "Type",
            value: technique.type,
          ),


          _InfoChip(
            label: "Level",
            value: technique.beltLevel,
          ),


        ],

      ),

    );

  }

}

class _IJFProfileCard extends StatelessWidget {

  final TechniqueModel technique;

  const _IJFProfileCard({
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

            "IJF Profile",

            style: TextStyle(

              color: Color(0xFFD4AF37),

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 15),


          _ProfileRow(

            title: "Classification",

            value: technique.ijfClassification,

          ),


          _ProfileRow(

            title: "Difficulty",

            value: technique.difficulty,

          ),


          _ProfileRow(

            title: "Competition Usage",

            value: technique.competitionUsage,

          ),

        ],

      ),

    );

  }

}




class _ProfileRow extends StatelessWidget {


  final String title;

  final String value;


  const _ProfileRow({

    required this.title,

    required this.value,

  });



  @override
  Widget build(BuildContext context) {


    return Padding(

      padding: const EdgeInsets.only(bottom: 10),


      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [


          SizedBox(

            width: 150,

            child: Text(

              title,

              style: const TextStyle(

                color: Colors.white54,

              ),

            ),

          ),


          Expanded(

            child: Text(

              value,

              style: const TextStyle(

                color: Colors.white,

                fontWeight: FontWeight.bold,

              ),

            ),

          ),


        ],

      ),

    );


  }

}



class _InfoChip extends StatelessWidget {

  final String label;

  final String value;


  const _InfoChip({

    required this.label,

    required this.value,

  });


  @override
  Widget build(BuildContext context) {


    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),


      decoration: BoxDecoration(

        color: const Color(0xFF080808),

        borderRadius: BorderRadius.circular(14),

      ),



      child: RichText(

        text: TextSpan(

          children: [


            TextSpan(

              text: "$label: ",

              style: const TextStyle(
                color: Colors.white54,
              ),

            ),


            TextSpan(

              text: value,

              style: const TextStyle(

                color: Color(0xFF0066FF),

                fontWeight: FontWeight.bold,

              ),

            ),

          ],

        ),

      ),

    );

  }

}






class _TechniqueMedia extends StatelessWidget {

  final TechniqueModel technique;

  const _TechniqueMedia({
    required this.technique,
  });


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

       _SectionTitle(
  title: l10n.officialMedia,
),


        const SizedBox(height: 15),


        if (technique.images.isNotEmpty)

          Container(

            height: 350,

            width: double.infinity,

            decoration: BoxDecoration(

              color: const Color(0xFF111111),

              borderRadius: BorderRadius.circular(20),

            ),


            child: ClipRRect(

              borderRadius: BorderRadius.circular(20),

              child: Image.asset(

                technique.images.first,

                fit: BoxFit.contain,


                errorBuilder:
                    (context, error, stackTrace) {

                  return const Center(

                    child: Text(

                      "Image not available",

                      style: TextStyle(

                        color: Colors.white54,

                      ),

                    ),

                  );

                },

              ),

            ),

          ),


        const SizedBox(height: 20),


        Text(

            l10n.videoLibrary,

            style: const TextStyle(

              color: Color(0xFFD4AF37),

              fontSize: 18,

              fontWeight: FontWeight.bold,

  ),

),


        const SizedBox(height: 12),


        ...technique.videos.map(

          (video) {

            return Padding(

              padding: const EdgeInsets.only(
                bottom: 10,
              ),


              child: InkWell(

                borderRadius: BorderRadius.circular(14),


                onTap: () async {

                  final uri = Uri.tryParse(video);


                  if (uri != null) {

                    await launchUrl(

                      uri,

                      mode:
                          LaunchMode.externalApplication,

                    );

                  }

                },


                child: JudoCard(

                  child: Row(

                    children: [

                      const Icon(

                        Icons.play_circle_outline,

                        color: Color(0xFFD4AF37),

                      ),


                      const SizedBox(width: 12),


                      Expanded(

                        child: Text(

                          video,

                          style:
                              const TextStyle(

                            color:
                                Colors.white70,

                          ),

                        ),

                      ),

                    ],

                  ),

                ),

              ),

            );

          },

        ),


        const SizedBox(height: 25),


       TechniqueVideoButtons(

  trainingVideo: technique.trainingVideo,

  competitionVideo: technique.competitionVideo,

),

      ],

    );

  }

}


class _SectionTitle extends StatelessWidget {

  final String title;


  const _SectionTitle({

    required this.title,

  });



  @override
  Widget build(BuildContext context) {


    return Text(

      title,


      style: const TextStyle(

        color: Colors.white,

        fontSize: 24,

        fontWeight: FontWeight.bold,

      ),

    );

  }

}






class _BodyText extends StatelessWidget {


  final String text;


  const _BodyText({

    required this.text,

  });



  @override
  Widget build(BuildContext context) {


    return Text(

      text,


      style: const TextStyle(

        color: Colors.white70,

        fontSize: 16,

        height: 1.6,

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
class _TacticalIntelligenceCard extends StatelessWidget {

  final TechniqueModel technique;


  const _TacticalIntelligenceCard({
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

            "Tactical Intelligence",

            style: TextStyle(

              color: Color(0xFF0066FF),

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 15),



          _TacticalRow(

            title: "Grip Strategy",

            value: technique.gripStrategy,

          ),



          _TacticalRow(

            title: "Body Position",

            value: technique.bodyPosition,

          ),



          if (technique.tacticalNotes.isNotEmpty)

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [


                const SizedBox(height: 15),


                const Text(

                  "Tactical Notes",

                  style: TextStyle(

                    color: Colors.white,

                    fontWeight: FontWeight.bold,

                  ),

                ),


                const SizedBox(height: 8),


                ...technique.tacticalNotes.map(

                  (note) => Padding(

                    padding:

                        const EdgeInsets.only(bottom: 6),

                    child: Text(

                      "• $note",

                      style: const TextStyle(

                        color: Colors.white70,

                      ),

                    ),

                  ),

                ),

              ],

            ),


        ],

      ),

    );


  }

}





class _TacticalRow extends StatelessWidget {


  final String title;

  final String value;



  const _TacticalRow({

    required this.title,

    required this.value,

  });



  @override
  Widget build(BuildContext context) {


    return Padding(

      padding: const EdgeInsets.only(bottom: 10),


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [


          Text(

            title,

            style: const TextStyle(

              color: Colors.white54,

            ),

          ),



          const SizedBox(height: 3),



          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontWeight: FontWeight.bold,

            ),

          ),


        ],

      ),

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


    return Row(

      children: [


        Expanded(

          child: ElevatedButton.icon(

            onPressed: () {},

            icon: const Icon(
              Icons.favorite_border,
            ),

            label: const Text(
              "Favorite",
            ),

          ),

        ),


        const SizedBox(width: 12),


        Expanded(

          child: ElevatedButton.icon(

            onPressed: () {},

            icon: const Icon(
              Icons.add_task,
            ),

            label: const Text(
              "Training",
            ),

          ),

        ),


      ],

    );


  }

}
class _CompetitionAnalysisCard extends StatelessWidget {

  final TechniqueModel technique;

  const _CompetitionAnalysisCard({
    required this.technique,
  });


  @override
  Widget build(BuildContext context) {

    if (technique.competitionInsights.isEmpty) {
      return const SizedBox();
    }


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

            "Competition Analysis",

            style: TextStyle(

              color: Color(0xFF0066FF),

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 15),


          ...technique.competitionInsights.map(

            (item) => Padding(

              padding: const EdgeInsets.only(bottom: 8),

              child: Row(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(

                    "•",

                    style: TextStyle(

                      color: Color(0xFFD4AF37),

                      fontSize: 20,

                    ),

                  ),

                  const SizedBox(width: 8),


                  Expanded(

                    child: Text(

                      item,

                      style: const TextStyle(

                        color: Colors.white70,

                        height: 1.5,

                      ),

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