enum ReviewedSupportLeg { left, right }

enum ReviewedAttackingLeg { left, right }

class ReviewedFrameReference {
  const ReviewedFrameReference({
    required this.frameIndex,
    required this.timestampMs,
  });

  final int frameIndex;
  final int timestampMs;

  bool get isValid => frameIndex >= 0 && timestampMs >= 0;

  Map<String, dynamic> toJson() {
    return {'frame_index': frameIndex, 'timestamp_ms': timestampMs};
  }
}

class SingleAttemptV2ARequest {
  const SingleAttemptV2ARequest({
    required this.videoPath,
    required this.videoId,
    required this.cameraView,
    required this.attemptStart,
    required this.attemptEnd,
    required this.eventSchemaId,
    required this.neutralTrackId,
    required this.selectedDetectionIndex,
    required this.supportLeg,
    required this.attackingLeg,
    required this.angleFrame,
    required this.angleEventLabel,
    required this.projectedAngleViewSuitable,
    required this.lowRollConfirmed,
    this.singleAttemptConfirmed = false,
    this.attemptScope,
    this.attemptScopeSource,
    this.attemptScopeContractVersion,
  });

  final String videoPath;
  final String videoId;
  final String cameraView;
  final ReviewedFrameReference attemptStart;
  final ReviewedFrameReference attemptEnd;
  final String eventSchemaId;
  final String neutralTrackId;
  final int selectedDetectionIndex;
  final ReviewedSupportLeg supportLeg;
  final ReviewedAttackingLeg attackingLeg;
  final ReviewedFrameReference angleFrame;
  final String angleEventLabel;
  final bool projectedAngleViewSuitable;
  final bool lowRollConfirmed;
  final bool singleAttemptConfirmed;
  final String? attemptScope;
  final String? attemptScopeSource;
  final String? attemptScopeContractVersion;

  bool get isValid {
    final trackPattern = RegExp(r'^Track [A-Z]+$');
    final attemptScopeConsistent =
        !singleAttemptConfirmed ||
        (attemptScope == 'SINGLE_ATTEMPT' &&
            attemptScopeSource == 'HUMAN_CONFIRMED' &&
            attemptScopeContractVersion ==
                'single-attempt-human-confirmation-1.0.0');
    return videoPath.trim().isNotEmpty &&
        videoId.trim().isNotEmpty &&
        {
          'side',
          'front',
          'rear',
          'forty_five_degrees',
          'unknown',
        }.contains(cameraView) &&
        attemptStart.isValid &&
        attemptEnd.isValid &&
        attemptEnd.frameIndex > attemptStart.frameIndex &&
        attemptEnd.timestampMs > attemptStart.timestampMs &&
        eventSchemaId.trim().isNotEmpty &&
        trackPattern.hasMatch(neutralTrackId) &&
        neutralTrackId != 'Track TORI' &&
        neutralTrackId != 'Track UKE' &&
        selectedDetectionIndex >= 0 &&
        angleFrame.isValid &&
        angleFrame.frameIndex >= attemptStart.frameIndex &&
        angleFrame.frameIndex <= attemptEnd.frameIndex &&
        angleFrame.timestampMs >= attemptStart.timestampMs &&
        angleFrame.timestampMs <= attemptEnd.timestampMs &&
        angleEventLabel.trim().isNotEmpty &&
        attemptScopeConsistent;
  }

  Map<String, dynamic> toReviewJson() {
    return {
      'schema_version': '2.0.0',
      'analysis_variant': 'single_attempt_v2a',
      'video_id': videoId,
      'technique': {'id': 'uchi-mata'},
      'camera_view': cameraView,
      'attempt': {
        'start': attemptStart.toJson(),
        'end': attemptEnd.toJson(),
        'event_schema_id': eventSchemaId,
        'selection_source': 'human-selected',
        'single_attempt_confirmed': singleAttemptConfirmed,
        if (attemptScope != null) 'attempt_scope': attemptScope,
        if (attemptScopeSource != null)
          'attempt_scope_source': attemptScopeSource,
        if (attemptScopeContractVersion != null)
          'attempt_scope_contract_version': attemptScopeContractVersion,
      },
      'subject': {
        'neutral_track_id': neutralTrackId,
        'selected_detection_index': selectedDetectionIndex,
        'role': 'Tori',
        'confirmation_source': 'human-confirmed',
      },
      'support_leg': {
        'side': supportLeg.name,
        'confirmation_source': 'human-confirmed',
      },
      'attacking_leg': {
        'side': attackingLeg.name,
        'confirmation_source': 'human-confirmed',
      },
      'angle_frame': {
        'frame': angleFrame.toJson(),
        'selection_source': 'human-selected',
        'event_label': angleEventLabel,
      },
      'camera_suitability': {
        'projected_angle_view_suitable': projectedAngleViewSuitable,
        'low_roll_confirmed': lowRollConfirmed,
        'review_source': 'human-reviewed',
      },
      'pose_observation': null,
    };
  }
}
