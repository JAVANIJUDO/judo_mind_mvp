import 'quiz_model.dart';
import 'technique_translation.dart';


class TechniqueModel {

  final String id;

  final String englishName;
  final String japaneseName;

  final String category;
  final String type;
  final String beltLevel;
  final String difficulty;

  final String description;
  final String technicalAnalysis;
  final List<TechniqueTranslation> translations;

  final List<String> images;
  final List<String> videos;

  final String trainingVideo;
  final String competitionVideo;

  final List<String> executionSteps;

  final List<String> keyPoints;
  final List<String> commonMistakes;
  final List<String> safetyTips;

  final List<String> combinations;
  final List<String> counters;

  final List<QuizModel> quiz;
  final DateTime? createdAt;
final DateTime? updatedAt;

  

  final List<TechniqueSource> sources;


  const TechniqueModel({

    required this.id,

    required this.englishName,
    required this.japaneseName,

    required this.category,
    required this.type,
    required this.beltLevel,
    required this.difficulty,

    required this.description,
    required this.technicalAnalysis,

this.translations = const [],

required this.images,
    required this.videos,

    required this.trainingVideo,
    required this.competitionVideo,

    required this.executionSteps,

    required this.keyPoints,
    required this.commonMistakes,
    required this.safetyTips,

    required this.combinations,
    required this.counters,

    required this.quiz,
    this.createdAt,
this.updatedAt,



required this.sources,

  });


  // Compatibility with old screens

  String get nameEn => englishName;


  String get nameJp => japaneseName;


  String get kuzushi {

    if (executionSteps.isNotEmpty) {
      return executionSteps[0];
    }

    return "";

  }


  String get tsukuri {

    if (executionSteps.length > 1) {
      return executionSteps[1];
    }

    return "";

  }


  String get kake {

    if (executionSteps.length > 2) {
      return executionSteps[2];
    }

    return "";

  }


  List<String> get commonErrors => commonMistakes;


  String get ijfClassification => category;


  String get competitionUsage => competitionVideo;


  String get gripStrategy {

    if (keyPoints.isNotEmpty) {
      return keyPoints.first;
    }

    return "";

  }


  String get bodyPosition {

    if (keyPoints.length > 1) {
      return keyPoints[1];
    }

    return "";

  }


  List<String> get tacticalNotes => keyPoints;


  List<String> get famousUsers => [];


  List<String> get competitionInsights => competitionVideo.isNotEmpty
      ? [competitionVideo]
      : [];


  String get aiTrainingAdvice => technicalAnalysis;
TechniqueTranslation? getTranslation(String languageCode) {

  try {

    return translations.firstWhere(
      (item) => item.languageCode == languageCode,
    );

  } catch (e) {

    return null;

  }

}
}



class TechniqueSource {

  final String title;

  final String url;


  const TechniqueSource({

    required this.title,

    required this.url,

  });

}