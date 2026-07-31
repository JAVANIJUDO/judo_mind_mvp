class TechniqueAIModel {

  final List<String> weakPoints;

  final List<String> suggestedDrills;

  final List<String> recommendedProgression;

  final String? nextTechnique;

  final List<String> personalizedAdvice;


  const TechniqueAIModel({

    required this.weakPoints,

    required this.suggestedDrills,

    required this.recommendedProgression,

    this.nextTechnique,

    required this.personalizedAdvice,

  });

}