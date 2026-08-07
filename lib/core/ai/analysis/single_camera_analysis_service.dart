import '../../../models/single_camera_pose_summary.dart';
import '../../../models/video_analysis_request.dart';

abstract class SingleCameraAnalysisService {
  Future<SingleCameraPoseSummary> analyzePoseSummary(
    VideoAnalysisRequest request,
  );
}

class SingleCameraAnalysisException implements Exception {
  const SingleCameraAnalysisException(this.message);

  final String message;

  @override
  String toString() => message;
}
