import '../../../../models/guided_single_attempt_review.dart';
import 'single_attempt_v2a_service.dart';

abstract class GuidedSingleAttemptV2AService {
  Future<GuidedTimingManifest> prepareTimingManifest(
    GuidedTimingManifestRequest request,
  ) => Future<GuidedTimingManifest>.error(
    const GuidedReviewException('Decoded timing manifest is unavailable.'),
  );
  Future<GuidedBoundaryPreview> previewBoundaries(
    GuidedReviewPrepareRequest request,
  ) => Future<GuidedBoundaryPreview>.error(
    const GuidedReviewException('Exact boundary preview is unavailable.'),
  );
  Future<GuidedReviewSession> prepare(GuidedReviewPrepareRequest request);
  Future<GuidedReviewAnalysis> analyze(
    GuidedReviewPrepareRequest preparedRequest,
    GuidedReviewConfirmation confirmation,
  );
}

class GuidedReviewException extends SingleAttemptV2AException {
  const GuidedReviewException(super.message);
}
