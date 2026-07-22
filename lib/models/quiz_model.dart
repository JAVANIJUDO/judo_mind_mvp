class QuizModel {
  final String question;

  final List<String> options;

  final int correctAnswerIndex;

  final String explanation;

  final String difficulty;

  final int points;

  const QuizModel({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.difficulty = "Medium",
    this.points = 10,
  });
}