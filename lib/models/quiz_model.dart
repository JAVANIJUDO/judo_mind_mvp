class QuizModel {
  final String question;

  final List<String> options;

  final int correctAnswerIndex;

  final String explanation;


  const QuizModel({

    required this.question,

    required this.options,

    required this.correctAnswerIndex,

    required this.explanation,

  });
}