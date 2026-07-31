class TechniqueProgressModel {

  final String userId;

  final String techniqueId;

  final bool favorite;

  final int practiceCount;

  final double quizScore;

  final double masteryLevel;

  final double completionPercentage;

  final DateTime? lastPractice;

  final String? notes;


  const TechniqueProgressModel({

    required this.userId,

    required this.techniqueId,

    required this.favorite,

    required this.practiceCount,

    required this.quizScore,

    required this.masteryLevel,

    required this.completionPercentage,

    this.lastPractice,

    this.notes,

  });

}