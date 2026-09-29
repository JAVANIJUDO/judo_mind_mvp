import '../../../models/grounded_sensei.dart';

abstract class GroundedSenseiService {
  Future<GroundedSenseiExplanation> explain(GroundedSenseiRequest request);
}

class GroundedSenseiException implements Exception {
  const GroundedSenseiException(this.code);

  final String code;

  @override
  String toString() => code;
}
