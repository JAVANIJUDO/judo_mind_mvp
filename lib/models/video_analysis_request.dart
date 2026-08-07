/// ----------------------------------------------------------------
/// Judo Mind Super App
/// AI Fight Intelligence 360
/// Video Analysis Request
/// Version: 1.0.0
/// ----------------------------------------------------------------

library;

enum AnalysisCameraView { side, front, rear, fortyFiveDegrees, unknown }

extension AnalysisCameraViewApi on AnalysisCameraView {
  String get apiValue {
    return switch (this) {
      AnalysisCameraView.side => 'side',
      AnalysisCameraView.front => 'front',
      AnalysisCameraView.rear => 'rear',
      AnalysisCameraView.fortyFiveDegrees => 'forty_five_degrees',
      AnalysisCameraView.unknown => 'unknown',
    };
  }
}

class VideoAnalysisRequest {
  final String techniqueId;
  final String techniqueName;

  final String videoPath;

  final AnalysisCameraView cameraView;

  final DateTime createdAt;

  final bool analyzeTori;
  final bool analyzeUke;

  final bool requestPoseTracking;
  final bool requestJointAngles;
  final bool requestPhaseDetection;
  final bool requestCenterOfMass;
  final bool requestBiomechanics;
  final bool requestSafetyAnalysis;
  final bool requestOverlayVideo;

  const VideoAnalysisRequest({
    required this.techniqueId,
    required this.techniqueName,
    required this.videoPath,
    required this.cameraView,
    required this.createdAt,
    this.analyzeTori = true,
    this.analyzeUke = true,
    this.requestPoseTracking = true,
    this.requestJointAngles = true,
    this.requestPhaseDetection = true,
    this.requestCenterOfMass = true,
    this.requestBiomechanics = true,
    this.requestSafetyAnalysis = true,
    this.requestOverlayVideo = true,
  });

  factory VideoAnalysisRequest.singleCameraPoseSummary({
    required String techniqueId,
    required String techniqueName,
    required String videoPath,
    required AnalysisCameraView cameraView,
    required DateTime createdAt,
  }) {
    return VideoAnalysisRequest(
      techniqueId: techniqueId,
      techniqueName: techniqueName,
      videoPath: videoPath,
      cameraView: cameraView,
      createdAt: createdAt,
      analyzeTori: false,
      analyzeUke: false,
      requestPoseTracking: true,
      requestJointAngles: false,
      requestPhaseDetection: false,
      requestCenterOfMass: false,
      requestBiomechanics: false,
      requestSafetyAnalysis: false,
      requestOverlayVideo: false,
    );
  }

  bool get isValid {
    return techniqueId.trim().isNotEmpty &&
        techniqueName.trim().isNotEmpty &&
        videoPath.trim().isNotEmpty;
  }

  Map<String, String> toSingleCameraFormFields() {
    return {'technique_id': techniqueId, 'camera_view': cameraView.apiValue};
  }
}
