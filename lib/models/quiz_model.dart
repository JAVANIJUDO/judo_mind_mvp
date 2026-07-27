class QuizModel {

  final String id;

  final String question;

  final List<String> options;

  final int correctAnswerIndex;

  final String explanation;

  final String difficulty;

  final int points;


  final List<QuizTranslation> translations;


  const QuizModel({

    this.id = "",

    required this.question,

    required this.options,

    required this.correctAnswerIndex,

    required this.explanation,

    this.difficulty = "Medium",

    this.points = 10,

    this.translations = const [],

  });


  int get correctAnswer => correctAnswerIndex;



  QuizTranslation? getTranslation(String languageCode){

    try {

      return translations.firstWhere(
        (item) =>
            item.languageCode == languageCode,
      );

    } catch(e){

      return null;

    }

  }

}



class QuizTranslation {


  final String languageCode;


  final String question;


  final List<String> options;


  final String explanation;



  const QuizTranslation({

    required this.languageCode,

    required this.question,

    required this.options,

    required this.explanation,

  });


}