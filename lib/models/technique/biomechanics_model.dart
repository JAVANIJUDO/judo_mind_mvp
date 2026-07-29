class BiomechanicsModel {

  final String centerOfGravity;

  final String forceDirection;

  final List<String> bodyAngles;

  final List<String> mainMuscles;

  final List<String> movementPhases;

  final List<String> keyPoints;


  const BiomechanicsModel({

    required this.centerOfGravity,

    required this.forceDirection,

    required this.bodyAngles,

    required this.mainMuscles,

    required this.movementPhases,

    required this.keyPoints,

  });

}