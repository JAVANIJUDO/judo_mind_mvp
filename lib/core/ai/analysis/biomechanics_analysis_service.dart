import '../../../models/media_analysis_metadata.dart';
import '../../../models/video_analysis_request.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// AI Fight Intelligence 360
/// Biomechanics Analysis Service Contract
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Flutter depends only on this contract.
///
/// The actual AI engine can later use:
/// - RTMPose / MMPose
/// - MediaPipe
/// - Custom Judo models
/// - GPU backend
///
/// without changing the Technique UI.
abstract interface class BiomechanicsAnalysisService {
  Future<VideoAnalysisJob> submit(VideoAnalysisRequest request);

  Future<VideoAnalysisJob> getJob(String jobId);

  Future<MediaAnalysisMetadata?> getResult(String jobId);

  Future<void> cancel(String jobId);
}

enum VideoAnalysisJobStatus {
  preparing,
  uploading,
  queued,
  poseDetection,
  athleteTracking,
  phaseDetection,
  biomechanicsAnalysis,
  generatingOverlay,
  completed,
  failed,
  cancelled,
}

class VideoAnalysisJob {
  final String id;

  final String techniqueId;

  final VideoAnalysisJobStatus status;

  /// Progress from 0.0 to 1.0.
  final double progress;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final String? message;
  final String? error;

  const VideoAnalysisJob({
    required this.id,
    required this.techniqueId,
    required this.status,
    required this.progress,
    required this.createdAt,
    this.updatedAt,
    this.message,
    this.error,
  });

  bool get isCompleted {
    return status == VideoAnalysisJobStatus.completed;
  }

  bool get hasFailed {
    return status == VideoAnalysisJobStatus.failed;
  }

  bool get isActive {
    return !isCompleted &&
        !hasFailed &&
        status != VideoAnalysisJobStatus.cancelled;
  }
}
