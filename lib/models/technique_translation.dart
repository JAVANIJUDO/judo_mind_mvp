class TechniqueTranslation {

  final String languageCode;

  final String name;

  final String description;

  final String technicalAnalysis;


  final List<String> executionSteps;

  final List<String> keyPoints;

  final List<String> commonMistakes;

  final List<String> safetyTips;

  final List<String> combinations;

  final List<String> counters;


  const TechniqueTranslation({

    required this.languageCode,

    required this.name,

    required this.description,

    required this.technicalAnalysis,


    this.executionSteps = const [],

    this.keyPoints = const [],

    this.commonMistakes = const [],

    this.safetyTips = const [],

    this.combinations = const [],

    this.counters = const [],

  });

}