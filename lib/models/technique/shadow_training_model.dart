class ShadowTrainingModel {
  final String title;

  final String description;

  final List<String> warmUp;

  final List<String> technicalRounds;

  final List<String> speedRounds;

  final List<String> powerRounds;

  final int recommendedReps;

  final String difficulty;


  const ShadowTrainingModel({

    required this.title,

    required this.description,

    required this.warmUp,

    required this.technicalRounds,

    required this.speedRounds,

    required this.powerRounds,

    required this.recommendedReps,

    required this.difficulty,

  });

}