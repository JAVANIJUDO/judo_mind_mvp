import '../../../models/single_attempt_analysis_v2a.dart';
import '../../../models/single_attempt_v2a_request.dart';

abstract class SingleAttemptV2AService {
  Future<SingleAttemptAnalysisV2A> analyzeReviewedVideo(
    SingleAttemptV2ARequest request,
  );
}

class SingleAttemptV2AException implements Exception {
  const SingleAttemptV2AException(this.message);

  final String message;

  @override
  String toString() => message;
}
