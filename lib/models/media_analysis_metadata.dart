/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Model: Media Analysis Metadata
/// Module: AI Fight Intelligence 360
/// Version: 2.0.0
/// ----------------------------------------------------------------
///
/// Stores structured tactical and biomechanical results extracted
/// from training and competition videos.
///
/// Important:
/// Single-camera results are estimates.
/// Scientific 3D force measurement requires calibrated multi-camera
/// capture or external sensors.
class MediaAnalysisMetadata {
  final String? analysisId;

  final VideoAnalysisStatus status;
  final VideoAnalysisMode analysisMode;

  /// Overall confidence from 0.0 to 1.0.
  final double? confidenceScore;

  /// Confidence of Tori pose tracking.
  final double? toriTrackingConfidence;

  /// Confidence of Uke pose tracking.
  final double? ukeTrackingConfidence;

  final CameraCalibrationMetadata? calibration;

  final List<TechniquePhaseAnalysis> phases;
  final List<JointAngleMeasurement> jointAngles;
  final List<BiomechanicsFinding> findings;
  final List<NormalizedMovementPoint> centerOfMassPath;
  final List<AnalysisLimitation> limitations;

  /// Generated analysis outputs.
  final String? overlayVideoUrl;
  final String? skeletonDataUrl;
  final String? analysisReportUrl;

  // -----------------------------------------------------------
  // Legacy tactical fields
  // -----------------------------------------------------------

  final String? opponentGuard;
  final String? opponentStance;
  final String? attackTiming;
  final String? defenseReaction;
  final String? kuzushiDirection;
  final String? balanceAnalysis;
  final String? entryAngle;
  final String? hipPosition;
  final String? footPlacement;
  final String? pushPullDynamic;

  const MediaAnalysisMetadata({
    this.analysisId,
    this.status = VideoAnalysisStatus.notStarted,
    this.analysisMode = VideoAnalysisMode.singleCamera2d,
    this.confidenceScore,
    this.toriTrackingConfidence,
    this.ukeTrackingConfidence,
    this.calibration,
    this.phases = const [],
    this.jointAngles = const [],
    this.findings = const [],
    this.centerOfMassPath = const [],
    this.limitations = const [],
    this.overlayVideoUrl,
    this.skeletonDataUrl,
    this.analysisReportUrl,
    this.opponentGuard,
    this.opponentStance,
    this.attackTiming,
    this.defenseReaction,
    this.kuzushiDirection,
    this.balanceAnalysis,
    this.entryAngle,
    this.hipPosition,
    this.footPlacement,
    this.pushPullDynamic,
  });

  bool get hasAnalysisData {
    return phases.isNotEmpty ||
        jointAngles.isNotEmpty ||
        findings.isNotEmpty ||
        centerOfMassPath.isNotEmpty ||
        opponentGuard != null ||
        opponentStance != null ||
        attackTiming != null ||
        defenseReaction != null ||
        kuzushiDirection != null ||
        balanceAnalysis != null ||
        entryAngle != null ||
        hipPosition != null ||
        footPlacement != null ||
        pushPullDynamic != null;
  }

  bool get hasGeneratedOverlay {
    return overlayVideoUrl?.trim().isNotEmpty ?? false;
  }

  bool get hasPoseTracking {
    return skeletonDataUrl?.trim().isNotEmpty ?? false;
  }

  bool get isCompleted {
    return status == VideoAnalysisStatus.completed;
  }

  bool get isScientificallyCalibrated {
    return calibration?.isCalibrated ?? false;
  }

  bool get isSingleCameraEstimate {
    return analysisMode == VideoAnalysisMode.singleCamera2d;
  }

  TechniquePhaseAnalysis? phase(TechniqueMovementPhase phase) {
    for (final item in phases) {
      if (item.phase == phase) {
        return item;
      }
    }

    return null;
  }

  MediaAnalysisMetadata copyWith({
    String? analysisId,
    VideoAnalysisStatus? status,
    VideoAnalysisMode? analysisMode,
    double? confidenceScore,
    double? toriTrackingConfidence,
    double? ukeTrackingConfidence,
    CameraCalibrationMetadata? calibration,
    List<TechniquePhaseAnalysis>? phases,
    List<JointAngleMeasurement>? jointAngles,
    List<BiomechanicsFinding>? findings,
    List<NormalizedMovementPoint>? centerOfMassPath,
    List<AnalysisLimitation>? limitations,
    String? overlayVideoUrl,
    String? skeletonDataUrl,
    String? analysisReportUrl,
    String? opponentGuard,
    String? opponentStance,
    String? attackTiming,
    String? defenseReaction,
    String? kuzushiDirection,
    String? balanceAnalysis,
    String? entryAngle,
    String? hipPosition,
    String? footPlacement,
    String? pushPullDynamic,
  }) {
    return MediaAnalysisMetadata(
      analysisId: analysisId ?? this.analysisId,
      status: status ?? this.status,
      analysisMode: analysisMode ?? this.analysisMode,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      toriTrackingConfidence:
          toriTrackingConfidence ?? this.toriTrackingConfidence,
      ukeTrackingConfidence:
          ukeTrackingConfidence ?? this.ukeTrackingConfidence,
      calibration: calibration ?? this.calibration,
      phases: phases ?? this.phases,
      jointAngles: jointAngles ?? this.jointAngles,
      findings: findings ?? this.findings,
      centerOfMassPath: centerOfMassPath ?? this.centerOfMassPath,
      limitations: limitations ?? this.limitations,
      overlayVideoUrl: overlayVideoUrl ?? this.overlayVideoUrl,
      skeletonDataUrl: skeletonDataUrl ?? this.skeletonDataUrl,
      analysisReportUrl: analysisReportUrl ?? this.analysisReportUrl,
      opponentGuard: opponentGuard ?? this.opponentGuard,
      opponentStance: opponentStance ?? this.opponentStance,
      attackTiming: attackTiming ?? this.attackTiming,
      defenseReaction: defenseReaction ?? this.defenseReaction,
      kuzushiDirection: kuzushiDirection ?? this.kuzushiDirection,
      balanceAnalysis: balanceAnalysis ?? this.balanceAnalysis,
      entryAngle: entryAngle ?? this.entryAngle,
      hipPosition: hipPosition ?? this.hipPosition,
      footPlacement: footPlacement ?? this.footPlacement,
      pushPullDynamic: pushPullDynamic ?? this.pushPullDynamic,
    );
  }
}

enum VideoAnalysisStatus {
  notStarted,
  uploading,
  queued,
  processing,
  completed,
  partiallyCompleted,
  failed,
}

enum VideoAnalysisMode {
  /// Estimated 2D analysis from one camera.
  singleCamera2d,

  /// Calibrated reconstruction from multiple cameras.
  calibratedMultiCamera3d,

  /// Video analysis combined with wearable sensors.
  videoWithSensors,
}

enum TechniqueMovementPhase {
  preparation,
  kuzushi,
  tsukuri,
  kake,
  landing,
  transition,
}

enum BiomechanicsFindingCategory {
  posture,
  balance,
  footwork,
  grip,
  timing,
  rotation,
  forceDirection,
  jointAlignment,
  safety,
}

enum AnalysisFindingSeverity {
  information,
  positive,
  improvement,
  warning,
  critical,
}

class TechniquePhaseAnalysis {
  final TechniqueMovementPhase phase;

  final int startMilliseconds;
  final int endMilliseconds;

  /// Confidence from 0.0 to 1.0.
  final double confidence;

  final String summary;
  final List<String> observations;

  const TechniquePhaseAnalysis({
    required this.phase,
    required this.startMilliseconds,
    required this.endMilliseconds,
    required this.confidence,
    required this.summary,
    this.observations = const [],
  });

  int get durationMilliseconds {
    return endMilliseconds - startMilliseconds;
  }

  bool get hasValidTimeRange {
    return startMilliseconds >= 0 && endMilliseconds > startMilliseconds;
  }
}

class JointAngleMeasurement {
  final String athleteRole;
  final String jointName;

  final double? minimumDegrees;
  final double? maximumDegrees;
  final double? averageDegrees;
  final double? keyFrameDegrees;

  final int? keyFrameMilliseconds;

  /// Confidence from 0.0 to 1.0.
  final double confidence;

  const JointAngleMeasurement({
    required this.athleteRole,
    required this.jointName,
    this.minimumDegrees,
    this.maximumDegrees,
    this.averageDegrees,
    this.keyFrameDegrees,
    this.keyFrameMilliseconds,
    required this.confidence,
  });

  bool get hasMeasurement {
    return minimumDegrees != null ||
        maximumDegrees != null ||
        averageDegrees != null ||
        keyFrameDegrees != null;
  }
}

class BiomechanicsFinding {
  final String id;

  final BiomechanicsFindingCategory category;
  final AnalysisFindingSeverity severity;

  final String title;
  final String description;

  final int? timestampMilliseconds;

  final String? correction;
  final String? recommendedDrill;

  /// Confidence from 0.0 to 1.0.
  final double confidence;

  const BiomechanicsFinding({
    required this.id,
    required this.category,
    required this.severity,
    required this.title,
    required this.description,
    this.timestampMilliseconds,
    this.correction,
    this.recommendedDrill,
    required this.confidence,
  });
}

class CameraCalibrationMetadata {
  final bool isCalibrated;

  final String? cameraAngle;
  final double? frameRate;
  final int? videoWidth;
  final int? videoHeight;

  final double? scaleReferenceMeters;

  const CameraCalibrationMetadata({
    required this.isCalibrated,
    this.cameraAngle,
    this.frameRate,
    this.videoWidth,
    this.videoHeight,
    this.scaleReferenceMeters,
  });
}

class NormalizedMovementPoint {
  /// Video position from 0.0 to 1.0.
  final double x;
  final double y;

  final int timestampMilliseconds;

  /// Confidence from 0.0 to 1.0.
  final double confidence;

  const NormalizedMovementPoint({
    required this.x,
    required this.y,
    required this.timestampMilliseconds,
    required this.confidence,
  });

  bool get isInsideFrame {
    return x >= 0 && x <= 1 && y >= 0 && y <= 1;
  }
}

class AnalysisLimitation {
  final String code;
  final String message;

  final bool affectsAccuracy;

  const AnalysisLimitation({
    required this.code,
    required this.message,
    this.affectsAccuracy = true,
  });
}
