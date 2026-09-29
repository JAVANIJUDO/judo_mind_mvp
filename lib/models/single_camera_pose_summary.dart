import 'analysis_provenance.dart';

class SingleCameraPoseSummary {
  const SingleCameraPoseSummary({
    required this.schemaVersion,
    required this.analysisId,
    required this.status,
    required this.analysisMode,
    required this.techniqueId,
    required this.cameraView,
    required this.engine,
    required this.video,
    required this.poseCoverage,
    required this.capabilities,
    required this.limitations,
  });

  final String schemaVersion;
  final String analysisId;
  final String status;
  final String analysisMode;
  final String techniqueId;
  final String cameraView;
  final PoseEngineSummary engine;
  final SingleCameraVideoSummary video;
  final PoseCoverageSummary poseCoverage;
  final SingleCameraCapabilities capabilities;
  final List<SingleCameraAnalysisLimitation> limitations;

  static const Set<String> _requiredLimitationCodes = {
    'pose_identity_not_available',
    'phase_detection_not_available',
    'single_camera_2d_only',
    'force_torque_not_available',
    'experimental_pose_baseline',
  };

  bool get hasExpectedScientificBoundary {
    final interpretationLimitationCodes = limitations
        .where((limitation) => limitation.affectsInterpretation)
        .map((limitation) => limitation.code)
        .toSet();

    return schemaVersion == '1.0.0' &&
        status == 'completed' &&
        analysisMode == 'single_camera_2d' &&
        engine.maturity == 'experimental' &&
        video.provenance == AnalysisProvenance.measured &&
        poseCoverage.provenance == AnalysisProvenance.modelEstimated &&
        !poseCoverage.confidenceAvailable &&
        poseCoverage.analyzedFrameCount >= 0 &&
        poseCoverage.framesWithAtLeastOnePose >= 0 &&
        poseCoverage.framesWithTwoPoses >= 0 &&
        poseCoverage.framesWithAtLeastOnePose <=
            poseCoverage.analyzedFrameCount &&
        poseCoverage.framesWithTwoPoses <=
            poseCoverage.framesWithAtLeastOnePose &&
        poseCoverage.atLeastOnePoseRate >= 0 &&
        poseCoverage.atLeastOnePoseRate <= 1 &&
        poseCoverage.twoPoseRate >= 0 &&
        poseCoverage.twoPoseRate <= 1 &&
        !capabilities.athleteIdentity &&
        !capabilities.phaseDetection &&
        !capabilities.threeDimensionalReconstruction &&
        !capabilities.forceOrTorque &&
        interpretationLimitationCodes.containsAll(_requiredLimitationCodes);
  }

  factory SingleCameraPoseSummary.fromJson(Map<String, dynamic> json) {
    final technique = _map(json, 'technique');
    final limitations = json['limitations'];

    if (limitations is! List) {
      throw const FormatException('Pose summary limitations must be a list.');
    }

    return SingleCameraPoseSummary(
      schemaVersion: _string(json, 'schema_version'),
      analysisId: _string(json, 'analysis_id'),
      status: _string(json, 'status'),
      analysisMode: _string(json, 'analysis_mode'),
      techniqueId: _string(technique, 'id'),
      cameraView: _string(json, 'camera_view'),
      engine: PoseEngineSummary.fromJson(_map(json, 'engine')),
      video: SingleCameraVideoSummary.fromJson(_map(json, 'video')),
      poseCoverage: PoseCoverageSummary.fromJson(_map(json, 'pose_coverage')),
      capabilities: SingleCameraCapabilities.fromJson(
        _map(json, 'capabilities'),
      ),
      limitations: List.unmodifiable(
        limitations.map(
          (item) => SingleCameraAnalysisLimitation.fromJson(
            _asMap(item, 'limitation'),
          ),
        ),
      ),
    );
  }
}

class PoseEngineSummary {
  const PoseEngineSummary({
    required this.id,
    required this.displayName,
    required this.maturity,
    required this.targetFps,
  });

  final String id;
  final String displayName;
  final String maturity;
  final double targetFps;

  factory PoseEngineSummary.fromJson(Map<String, dynamic> json) {
    return PoseEngineSummary(
      id: _string(json, 'id'),
      displayName: _string(json, 'display_name'),
      maturity: _string(json, 'maturity'),
      targetFps: _double(json, 'target_fps'),
    );
  }
}

class SingleCameraVideoSummary {
  const SingleCameraVideoSummary({
    required this.filename,
    required this.width,
    required this.height,
    required this.sourceFps,
    required this.frameCount,
    required this.durationSeconds,
    required this.provenance,
  });

  final String filename;
  final int width;
  final int height;
  final double sourceFps;
  final int frameCount;
  final double durationSeconds;
  final AnalysisProvenance provenance;

  factory SingleCameraVideoSummary.fromJson(Map<String, dynamic> json) {
    return SingleCameraVideoSummary(
      filename: _string(json, 'filename'),
      width: _int(json, 'width'),
      height: _int(json, 'height'),
      sourceFps: _double(json, 'source_fps'),
      frameCount: _int(json, 'frame_count'),
      durationSeconds: _double(json, 'duration_seconds'),
      provenance: AnalysisProvenance.fromApiValue(json['provenance']),
    );
  }
}

class PoseCoverageSummary {
  const PoseCoverageSummary({
    required this.analyzedFrameCount,
    required this.framesWithAtLeastOnePose,
    required this.framesWithTwoPoses,
    required this.atLeastOnePoseRate,
    required this.twoPoseRate,
    required this.provenance,
    required this.confidenceAvailable,
  });

  final int analyzedFrameCount;
  final int framesWithAtLeastOnePose;
  final int framesWithTwoPoses;
  final double atLeastOnePoseRate;
  final double twoPoseRate;
  final AnalysisProvenance provenance;
  final bool confidenceAvailable;

  factory PoseCoverageSummary.fromJson(Map<String, dynamic> json) {
    return PoseCoverageSummary(
      analyzedFrameCount: _int(json, 'analyzed_frame_count'),
      framesWithAtLeastOnePose: _int(json, 'frames_with_at_least_one_pose'),
      framesWithTwoPoses: _int(json, 'frames_with_two_poses'),
      atLeastOnePoseRate: _double(json, 'at_least_one_pose_rate'),
      twoPoseRate: _double(json, 'two_pose_rate'),
      provenance: AnalysisProvenance.fromApiValue(json['provenance']),
      confidenceAvailable: _bool(json, 'confidence_available'),
    );
  }
}

class SingleCameraCapabilities {
  const SingleCameraCapabilities({
    required this.athleteIdentity,
    required this.phaseDetection,
    required this.threeDimensionalReconstruction,
    required this.forceOrTorque,
  });

  final bool athleteIdentity;
  final bool phaseDetection;
  final bool threeDimensionalReconstruction;
  final bool forceOrTorque;

  factory SingleCameraCapabilities.fromJson(Map<String, dynamic> json) {
    return SingleCameraCapabilities(
      athleteIdentity: _bool(json, 'athlete_identity'),
      phaseDetection: _bool(json, 'phase_detection'),
      threeDimensionalReconstruction: _bool(
        json,
        'three_dimensional_reconstruction',
      ),
      forceOrTorque: _bool(json, 'force_or_torque'),
    );
  }
}

class SingleCameraAnalysisLimitation {
  const SingleCameraAnalysisLimitation({
    required this.code,
    required this.message,
    required this.affectsInterpretation,
  });

  final String code;
  final String message;
  final bool affectsInterpretation;

  factory SingleCameraAnalysisLimitation.fromJson(Map<String, dynamic> json) {
    return SingleCameraAnalysisLimitation(
      code: _string(json, 'code'),
      message: _string(json, 'message'),
      affectsInterpretation: _bool(json, 'affects_interpretation'),
    );
  }
}

Map<String, dynamic> _map(Map<String, dynamic> json, String key) {
  return _asMap(json[key], key);
}

Map<String, dynamic> _asMap(Object? value, String fieldName) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  throw FormatException('$fieldName must be an object.');
}

String _string(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('$key must be a non-empty string.');
}

int _int(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }

  throw FormatException('$key must be an integer.');
}

double _double(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) {
    return value.toDouble();
  }

  throw FormatException('$key must be a number.');
}

bool _bool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is bool) {
    return value;
  }

  throw FormatException('$key must be a boolean.');
}
