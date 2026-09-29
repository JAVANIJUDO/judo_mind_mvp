import 'single_attempt_analysis_v2a.dart';
import 'single_attempt_v2a_request.dart';

enum SourceTimingState { realTime, knownTimeScale, unknown }

extension SourceTimingStateWire on SourceTimingState {
  String get wireName => switch (this) {
    SourceTimingState.realTime => 'REAL_TIME',
    SourceTimingState.knownTimeScale => 'KNOWN_TIME_SCALE',
    SourceTimingState.unknown => 'UNKNOWN',
  };
}

class GuidedTimingManifestRequest {
  const GuidedTimingManifestRequest({
    required this.videoPath,
    required this.videoId,
    required this.sourceTimingState,
    this.physicalTimeScale,
  });
  final String videoPath;
  final String videoId;
  final SourceTimingState sourceTimingState;
  final double? physicalTimeScale;
  Map<String, dynamic> toJson() => {
    'video_id': videoId,
    'source_timing_state': sourceTimingState.wireName,
    if (physicalTimeScale != null) 'physical_time_scale': physicalTimeScale,
  };
}

class GuidedTimingManifest {
  const GuidedTimingManifest({
    required this.id,
    required this.totalDecodedFrames,
    required this.durationMs,
    required this.frameTimestampsMs,
    required this.timingMode,
    required this.timestampProvenance,
    required this.sourceTimingState,
    this.sourceFps,
    this.physicalTimeScale,
  });
  final String id;
  final int totalDecodedFrames;
  final int durationMs;
  final List<int> frameTimestampsMs;
  final String timingMode;
  final String timestampProvenance;
  final String sourceTimingState;
  final double? sourceFps;
  final double? physicalTimeScale;

  int timestampForFrame(int frameIndex) {
    if (frameIndex < 0 || frameIndex >= frameTimestampsMs.length) {
      throw RangeError.index(frameIndex, frameTimestampsMs);
    }
    return frameTimestampsMs[frameIndex];
  }

  factory GuidedTimingManifest.fromJson(Map<String, dynamic> json) =>
      GuidedTimingManifest(
        id: json['timing_manifest_id'] as String,
        totalDecodedFrames: json['total_decoded_frames'] as int,
        durationMs: json['duration_ms'] as int,
        frameTimestampsMs: List<int>.unmodifiable(
          (json['frame_timestamps_ms'] as List).cast<int>(),
        ),
        timingMode: json['timing_mode'] as String,
        timestampProvenance: json['timestamp_provenance'] as String,
        sourceTimingState: json['source_timing_state'] as String,
        sourceFps: (json['source_fps'] as num?)?.toDouble(),
        physicalTimeScale: (json['physical_time_scale'] as num?)?.toDouble(),
      );
}

class GuidedBoundaryPreview {
  const GuidedBoundaryPreview({
    required this.manifestId,
    required this.startFrame,
    required this.endFrame,
    required this.reviewFrame,
    required this.startTimestampMs,
    required this.endTimestampMs,
    required this.startPreviewJpegBase64,
    required this.endPreviewJpegBase64,
  });
  final String manifestId;
  final int startFrame;
  final int endFrame;
  final int reviewFrame;
  final int startTimestampMs;
  final int endTimestampMs;
  final String startPreviewJpegBase64;
  final String endPreviewJpegBase64;

  factory GuidedBoundaryPreview.fromJson(Map<String, dynamic> json) =>
      GuidedBoundaryPreview(
        manifestId: json['timing_manifest_id'] as String,
        startFrame: json['start_frame'] as int,
        endFrame: json['end_frame'] as int,
        reviewFrame: json['review_frame'] as int,
        startTimestampMs: json['start_timestamp_ms'] as int,
        endTimestampMs: json['end_timestamp_ms'] as int,
        startPreviewJpegBase64: json['start_preview_jpeg_base64'] as String,
        endPreviewJpegBase64: json['end_preview_jpeg_base64'] as String,
      );
}

class GuidedReviewPrepareRequest {
  const GuidedReviewPrepareRequest({
    required this.videoPath,
    required this.videoId,
    required this.techniqueId,
    required this.cameraView,
    required this.timingManifestId,
    required this.attemptStartFrame,
    required this.attemptEndFrame,
    required this.reviewFrame,
    required this.boundariesConfirmed,
    required this.singleAttemptConfirmed,
  });

  final String videoPath;
  final String videoId;
  final String techniqueId;
  final String cameraView;
  final String timingManifestId;
  final int attemptStartFrame;
  final int attemptEndFrame;
  final int reviewFrame;
  final bool boundariesConfirmed;
  final bool singleAttemptConfirmed;

  Map<String, dynamic> toJson() => {
    'video_id': videoId,
    'technique_id': techniqueId,
    'camera_view': cameraView,
    'timing_manifest_id': timingManifestId,
    'attempt_start_frame': attemptStartFrame,
    'attempt_end_frame': attemptEndFrame,
    'review_frame': reviewFrame,
    'boundaries_confirmed': boundariesConfirmed,
    'single_attempt_confirmed': singleAttemptConfirmed,
    'attempt_scope': 'SINGLE_ATTEMPT',
    'attempt_scope_source': 'HUMAN_CONFIRMED',
    'attempt_scope_contract_version': 'single-attempt-human-confirmation-1.0.0',
  };
}

enum GuidedCandidateSelectionStatus {
  readyForHumanSelection,
  insufficientCandidateEvidence,
  noSelectableCandidate,
}

enum GuidedPoseAvailability { available }

enum GuidedModelLandmarkVisibilityStatus { available, partial, unavailable }

class GuidedCandidateTrackMetadata {
  const GuidedCandidateTrackMetadata({
    this.status = 'unavailable',
    this.neutralTrackId,
    this.associationConfidence,
    this.reason = 'frame_local_candidate_only_no_tracking',
  });

  final String status;
  final String? neutralTrackId;
  final double? associationConfidence;
  final String reason;

  bool get isExplicitlyUnavailable =>
      status == 'unavailable' &&
      neutralTrackId == null &&
      associationConfidence == null &&
      reason == 'frame_local_candidate_only_no_tracking';

  factory GuidedCandidateTrackMetadata.fromJson(Map<String, dynamic> json) {
    final metadata = GuidedCandidateTrackMetadata(
      status: json['status'] as String,
      neutralTrackId: json['neutral_track_id'] as String?,
      associationConfidence: (json['association_confidence'] as num?)
          ?.toDouble(),
      reason: json['reason'] as String,
    );
    if (!metadata.isExplicitlyUnavailable) {
      throw const FormatException(
        'Frame candidates cannot contain tracking or identity evidence.',
      );
    }
    return metadata;
  }
}

class GuidedReviewCandidate {
  const GuidedReviewCandidate({
    required this.token,
    required this.previewJpegBase64,
    this.poseAvailability = GuidedPoseAvailability.available,
    this.poseProvenance = 'model-estimated',
    required this.requiredLandmarkCount,
    required this.availableRequiredLandmarkCount,
    required this.modelLandmarkVisibilityStatus,
    required this.modelLandmarkVisibilityCount,
    this.trackMetadata = const GuidedCandidateTrackMetadata(),
  });
  final String token;
  final String previewJpegBase64;
  final GuidedPoseAvailability poseAvailability;
  final String poseProvenance;
  final int requiredLandmarkCount;
  final int availableRequiredLandmarkCount;
  final GuidedModelLandmarkVisibilityStatus modelLandmarkVisibilityStatus;
  final int modelLandmarkVisibilityCount;
  final GuidedCandidateTrackMetadata trackMetadata;

  bool get hasSelectablePoseEvidence =>
      poseAvailability == GuidedPoseAvailability.available &&
      poseProvenance == 'model-estimated' &&
      requiredLandmarkCount > 0 &&
      availableRequiredLandmarkCount == requiredLandmarkCount &&
      modelLandmarkVisibilityCount >= 0 &&
      modelLandmarkVisibilityCount <= requiredLandmarkCount &&
      trackMetadata.isExplicitlyUnavailable;

  factory GuidedReviewCandidate.fromJson(Map<String, dynamic> json) {
    final candidate = GuidedReviewCandidate(
      token: json['candidate_token'] as String,
      previewJpegBase64: json['preview_jpeg_base64'] as String,
      poseAvailability: _poseAvailability(json['pose_availability'] as String),
      poseProvenance: json['pose_provenance'] as String,
      requiredLandmarkCount: json['required_landmark_count'] as int,
      availableRequiredLandmarkCount:
          json['available_required_landmark_count'] as int,
      modelLandmarkVisibilityStatus: _visibilityStatus(
        json['model_landmark_visibility_status'] as String,
      ),
      modelLandmarkVisibilityCount:
          json['model_landmark_visibility_count'] as int,
      trackMetadata: GuidedCandidateTrackMetadata.fromJson(
        Map<String, dynamic>.from(json['track_metadata'] as Map),
      ),
    );
    if (!candidate.hasSelectablePoseEvidence ||
        !_visibilityCountMatchesStatus(candidate)) {
      throw const FormatException('Candidate evidence is inconsistent.');
    }
    return candidate;
  }
}

class GuidedReviewSession {
  const GuidedReviewSession({
    required this.sessionId,
    required this.expiresInSeconds,
    required this.canonicalStartMs,
    required this.canonicalEndMs,
    required this.canonicalReviewMomentMs,
    required this.canonicalStartFrame,
    required this.canonicalEndFrame,
    required this.canonicalReviewFrame,
    required this.timingMode,
    required this.timestampProvenance,
    required this.sourceTimingState,
    required this.singleAttemptConfirmed,
    required this.attemptScope,
    required this.attemptScopeSource,
    required this.attemptScopeContractVersion,
    required this.detectedPoseCount,
    required this.selectableCandidateCount,
    required this.candidateSelectionStatus,
    required this.candidates,
    required this.limitations,
  });
  final String sessionId;
  final int expiresInSeconds;
  final int canonicalStartMs;
  final int canonicalEndMs;
  final int canonicalReviewMomentMs;
  final int canonicalStartFrame;
  final int canonicalEndFrame;
  final int canonicalReviewFrame;
  final String timingMode;
  final String timestampProvenance;
  final String sourceTimingState;
  final bool singleAttemptConfirmed;
  final String attemptScope;
  final String attemptScopeSource;
  final String attemptScopeContractVersion;
  final int detectedPoseCount;
  final int selectableCandidateCount;
  final GuidedCandidateSelectionStatus candidateSelectionStatus;
  final List<GuidedReviewCandidate> candidates;
  final List<String> limitations;

  bool get hasReadyCandidateEvidence =>
      candidateSelectionStatus ==
          GuidedCandidateSelectionStatus.readyForHumanSelection &&
      detectedPoseCount >= selectableCandidateCount &&
      selectableCandidateCount >= 2 &&
      selectableCandidateCount == candidates.length &&
      candidates.every((candidate) => candidate.hasSelectablePoseEvidence);

  factory GuidedReviewSession.fromJson(Map<String, dynamic> json) {
    final session = GuidedReviewSession(
      sessionId: json['review_session_id'] as String,
      expiresInSeconds: json['expires_in_seconds'] as int,
      canonicalStartMs: json['canonical_start_ms'] as int,
      canonicalEndMs: json['canonical_end_ms'] as int,
      canonicalReviewMomentMs: json['canonical_review_moment_ms'] as int,
      canonicalStartFrame: json['canonical_start_frame'] as int,
      canonicalEndFrame: json['canonical_end_frame'] as int,
      canonicalReviewFrame: json['canonical_review_frame'] as int,
      timingMode: json['timing_mode'] as String,
      timestampProvenance: json['timestamp_provenance'] as String,
      sourceTimingState: json['source_timing_state'] as String,
      singleAttemptConfirmed: json['single_attempt_confirmed'] as bool,
      attemptScope: json['attempt_scope'] as String,
      attemptScopeSource: json['attempt_scope_source'] as String,
      attemptScopeContractVersion:
          json['attempt_scope_contract_version'] as String,
      detectedPoseCount: json['detected_pose_count'] as int,
      selectableCandidateCount: json['selectable_candidate_count'] as int,
      candidateSelectionStatus: _candidateSelectionStatus(
        json['candidate_selection_status'] as String,
      ),
      candidates: List.unmodifiable(
        (json['candidates'] as List).map(
          (value) => GuidedReviewCandidate.fromJson(
            Map<String, dynamic>.from(value as Map),
          ),
        ),
      ),
      limitations: List.unmodifiable(
        (json['limitations'] as List).cast<String>(),
      ),
    );
    final expectedStatus = session.selectableCandidateCount == 0
        ? GuidedCandidateSelectionStatus.noSelectableCandidate
        : session.selectableCandidateCount == 1
        ? GuidedCandidateSelectionStatus.insufficientCandidateEvidence
        : GuidedCandidateSelectionStatus.readyForHumanSelection;
    if (session.detectedPoseCount < session.selectableCandidateCount ||
        session.selectableCandidateCount != session.candidates.length ||
        session.candidateSelectionStatus != expectedStatus) {
      throw const FormatException('Candidate-set evidence is inconsistent.');
    }
    return session;
  }
}

GuidedCandidateSelectionStatus _candidateSelectionStatus(String value) =>
    switch (value) {
      'ready_for_human_selection' =>
        GuidedCandidateSelectionStatus.readyForHumanSelection,
      'insufficient_candidate_evidence' =>
        GuidedCandidateSelectionStatus.insufficientCandidateEvidence,
      'no_selectable_candidate' =>
        GuidedCandidateSelectionStatus.noSelectableCandidate,
      _ => throw FormatException('Unknown candidate selection status: $value'),
    };

GuidedPoseAvailability _poseAvailability(String value) => switch (value) {
  'available' => GuidedPoseAvailability.available,
  _ => throw FormatException('Unknown pose availability: $value'),
};

GuidedModelLandmarkVisibilityStatus _visibilityStatus(String value) =>
    switch (value) {
      'available' => GuidedModelLandmarkVisibilityStatus.available,
      'partial' => GuidedModelLandmarkVisibilityStatus.partial,
      'unavailable' => GuidedModelLandmarkVisibilityStatus.unavailable,
      _ => throw FormatException('Unknown visibility status: $value'),
    };

bool _visibilityCountMatchesStatus(GuidedReviewCandidate candidate) =>
    switch (candidate.modelLandmarkVisibilityStatus) {
      GuidedModelLandmarkVisibilityStatus.available =>
        candidate.modelLandmarkVisibilityCount ==
            candidate.requiredLandmarkCount,
      GuidedModelLandmarkVisibilityStatus.partial =>
        candidate.modelLandmarkVisibilityCount > 0 &&
            candidate.modelLandmarkVisibilityCount <
                candidate.requiredLandmarkCount,
      GuidedModelLandmarkVisibilityStatus.unavailable =>
        candidate.modelLandmarkVisibilityCount == 0,
    };

class GuidedHumanRoleAssignment {
  const GuidedHumanRoleAssignment({required this.candidateToken});

  static const role = 'TORI';
  static const source = 'HUMAN_CONFIRMATION';
  final String candidateToken;

  Map<String, dynamic> toJson() => {
    'role': role,
    'source': source,
    'candidate_token': candidateToken,
  };
}

class GuidedReviewConfirmation {
  const GuidedReviewConfirmation({
    required this.session,
    required this.roleAssignment,
    required this.toriConfirmed,
    required this.supportLeg,
    required this.attackingLeg,
    required this.projectedAngleViewSuitable,
    required this.lowRollConfirmed,
    required this.reviewerUncertain,
  });
  final GuidedReviewSession session;
  final GuidedHumanRoleAssignment roleAssignment;
  final bool toriConfirmed;
  final ReviewedSupportLeg supportLeg;
  final ReviewedAttackingLeg attackingLeg;
  final bool projectedAngleViewSuitable;
  final bool lowRollConfirmed;
  final bool reviewerUncertain;

  String get candidateToken => roleAssignment.candidateToken;

  Map<String, dynamic> toJson() => {
    'review_session_id': session.sessionId,
    'role_assignment': roleAssignment.toJson(),
    'tori_confirmed': toriConfirmed,
    'support_leg': supportLeg.name,
    'attacking_leg': attackingLeg.name,
    'projected_angle_view_suitable': projectedAngleViewSuitable,
    'low_roll_confirmed': lowRollConfirmed,
    'reviewer_uncertain': reviewerUncertain,
  };
}

class GuidedReviewAnalysis {
  const GuidedReviewAnalysis({
    required this.result,
    required this.reviewedRequest,
  });
  final SingleAttemptAnalysisV2A result;
  final SingleAttemptV2ARequest reviewedRequest;
}
