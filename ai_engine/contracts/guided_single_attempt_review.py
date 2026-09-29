from __future__ import annotations

from enum import Enum
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, model_validator

from ai_engine.contracts.single_attempt_analysis_v2a import SupportLegSide
from ai_engine.single_attempt.timing_manifest import SourceTimingState


class GuidedTimingManifestInput(BaseModel):
    video_id: str = Field(min_length=1)
    source_timing_state: SourceTimingState
    physical_time_scale: float | None = Field(default=None, gt=0)

    @model_validator(mode="after")
    def validate_scale(self) -> "GuidedTimingManifestInput":
        if self.source_timing_state is SourceTimingState.KNOWN_TIME_SCALE:
            if self.physical_time_scale is None:
                raise ValueError("Known time scale requires a positive scale.")
        elif self.physical_time_scale is not None:
            raise ValueError("Time scale is allowed only for KNOWN_TIME_SCALE.")
        return self


class GuidedTimingManifestResponse(BaseModel):
    schema_version: Literal["1.0.0"] = "1.0.0"
    timing_manifest_id: str = Field(min_length=20)
    expires_in_seconds: int = Field(gt=0)
    total_decoded_frames: int = Field(gt=0)
    frame_timestamps_ms: list[int] = Field(min_length=1)
    timing_mode: Literal["CFR", "VFR", "UNKNOWN"]
    duration_ms: int = Field(ge=0)
    source_fps: float | None = Field(default=None, gt=0)
    timestamp_provenance: Literal[
        "decoder-reported-timestamp", "average-fps-derived-not-true-pts"
    ]
    canonicalization_method_version: Literal[
        "opencv-decoded-timeline-1.0.0"
    ] = "opencv-decoded-timeline-1.0.0"
    source_timing_state: SourceTimingState
    physical_time_scale: float | None = Field(default=None, gt=0)
    limitations: list[str]

    @model_validator(mode="after")
    def validate_frame_timestamps(self) -> "GuidedTimingManifestResponse":
        if len(self.frame_timestamps_ms) != self.total_decoded_frames:
            raise ValueError("Every decoded frame requires one canonical timestamp.")
        if any(value < 0 for value in self.frame_timestamps_ms):
            raise ValueError("Frame timestamps cannot be negative.")
        return self


class GuidedReviewPrepareInput(BaseModel):
    video_id: str = Field(min_length=1)
    technique_id: str = Field(min_length=1)
    camera_view: Literal[
        "side", "front", "rear", "forty_five_degrees", "unknown"
    ]
    timing_manifest_id: str = Field(min_length=20)
    attempt_start_frame: int = Field(ge=0, strict=True)
    attempt_end_frame: int = Field(gt=0, strict=True)
    review_frame: int = Field(ge=0, strict=True)
    boundaries_confirmed: Literal[True]
    single_attempt_confirmed: Literal[True]
    attempt_scope: Literal["SINGLE_ATTEMPT"]
    attempt_scope_source: Literal["HUMAN_CONFIRMED"]
    attempt_scope_contract_version: Literal[
        "single-attempt-human-confirmation-1.0.0"
    ]

    @model_validator(mode="after")
    def validate_boundary_order(self) -> "GuidedReviewPrepareInput":
        if self.technique_id != "uchi-mata":
            raise ValueError("Guided V2A currently supports only Uchi Mata.")
        if self.attempt_end_frame <= self.attempt_start_frame:
            raise ValueError("Attempt end must follow attempt start.")
        if not self.attempt_start_frame <= self.review_frame <= self.attempt_end_frame:
            raise ValueError("Review moment must be inside the selected attempt.")
        return self


class GuidedBoundaryPreviewInput(BaseModel):
    video_id: str = Field(min_length=1)
    timing_manifest_id: str = Field(min_length=20)
    attempt_start_frame: int = Field(ge=0, strict=True)
    attempt_end_frame: int = Field(gt=0, strict=True)
    review_frame: int = Field(ge=0, strict=True)

    @model_validator(mode="after")
    def validate_frames(self) -> "GuidedBoundaryPreviewInput":
        if self.attempt_end_frame <= self.attempt_start_frame:
            raise ValueError("Attempt end must follow attempt start.")
        if not self.attempt_start_frame <= self.review_frame <= self.attempt_end_frame:
            raise ValueError("Review frame must be inside the selected attempt.")
        return self


class GuidedBoundaryPreviewResponse(BaseModel):
    schema_version: Literal["1.0.0"] = "1.0.0"
    timing_manifest_id: str = Field(min_length=20)
    start_frame: int = Field(ge=0)
    end_frame: int = Field(gt=0)
    review_frame: int = Field(ge=0)
    start_timestamp_ms: int = Field(ge=0)
    end_timestamp_ms: int = Field(ge=0)
    start_preview_jpeg_base64: str = Field(min_length=1)
    end_preview_jpeg_base64: str = Field(min_length=1)
    status: Literal["human_boundary_confirmation_required"] = (
        "human_boundary_confirmation_required"
    )


class CandidateSelectionStatus(str, Enum):
    READY_FOR_HUMAN_SELECTION = "ready_for_human_selection"
    INSUFFICIENT_CANDIDATE_EVIDENCE = "insufficient_candidate_evidence"
    NO_SELECTABLE_CANDIDATE = "no_selectable_candidate"


def candidate_selection_status_for_count(
    selectable_candidate_count: int,
) -> CandidateSelectionStatus:
    if selectable_candidate_count < 0:
        raise ValueError("Selectable candidate count cannot be negative.")
    if selectable_candidate_count == 0:
        return CandidateSelectionStatus.NO_SELECTABLE_CANDIDATE
    if selectable_candidate_count == 1:
        return CandidateSelectionStatus.INSUFFICIENT_CANDIDATE_EVIDENCE
    return CandidateSelectionStatus.READY_FOR_HUMAN_SELECTION


class GuidedCandidateTrackMetadata(BaseModel):
    status: Literal["unavailable"] = "unavailable"
    neutral_track_id: None = None
    association_confidence: None = None
    reason: Literal["frame_local_candidate_only_no_tracking"] = (
        "frame_local_candidate_only_no_tracking"
    )


class GuidedReviewCandidate(BaseModel):
    candidate_token: str = Field(min_length=20)
    preview_jpeg_base64: str = Field(min_length=1)
    pose_availability: Literal["available"] = "available"
    pose_provenance: Literal["model-estimated"] = "model-estimated"
    required_landmark_count: int = Field(gt=0)
    available_required_landmark_count: int = Field(ge=0)
    model_landmark_visibility_status: Literal[
        "available", "partial", "unavailable"
    ]
    model_landmark_visibility_count: int = Field(ge=0)
    track_metadata: GuidedCandidateTrackMetadata = Field(
        default_factory=GuidedCandidateTrackMetadata
    )

    @model_validator(mode="after")
    def validate_evidence_counts(self) -> "GuidedReviewCandidate":
        if self.available_required_landmark_count != self.required_landmark_count:
            raise ValueError(
                "Selectable candidates require all required 2D landmarks."
            )
        if self.model_landmark_visibility_count > self.required_landmark_count:
            raise ValueError(
                "Visibility count cannot exceed required landmark count."
            )
        expected_status = (
            "unavailable"
            if self.model_landmark_visibility_count == 0
            else "available"
            if self.model_landmark_visibility_count == self.required_landmark_count
            else "partial"
        )
        if self.model_landmark_visibility_status != expected_status:
            raise ValueError("Visibility status does not match its evidence count.")
        return self


class GuidedReviewPrepareResponse(BaseModel):
    schema_version: Literal["1.1.0"] = "1.1.0"
    review_session_id: str = Field(min_length=20)
    expires_in_seconds: int = Field(gt=0)
    canonical_start_ms: int = Field(ge=0)
    canonical_end_ms: int = Field(ge=0)
    canonical_review_moment_ms: int = Field(ge=0)
    canonical_start_frame: int = Field(ge=0)
    canonical_end_frame: int = Field(gt=0)
    canonical_review_frame: int = Field(ge=0)
    timing_mode: Literal["CFR", "VFR", "UNKNOWN"]
    timestamp_provenance: str = Field(min_length=1)
    source_timing_state: SourceTimingState
    physical_time_scale: float | None = Field(default=None, gt=0)
    boundaries_human_confirmed: Literal[True] = True
    single_attempt_confirmed: Literal[True] = True
    attempt_scope: Literal["SINGLE_ATTEMPT"] = "SINGLE_ATTEMPT"
    attempt_scope_source: Literal["HUMAN_CONFIRMED"] = "HUMAN_CONFIRMED"
    attempt_scope_contract_version: Literal[
        "single-attempt-human-confirmation-1.0.0"
    ] = "single-attempt-human-confirmation-1.0.0"
    detected_pose_count: int = Field(ge=0)
    selectable_candidate_count: int = Field(ge=0)
    candidate_selection_status: CandidateSelectionStatus
    candidates: list[GuidedReviewCandidate]
    status: Literal["human_confirmation_required"] = "human_confirmation_required"
    limitations: list[str]

    @model_validator(mode="after")
    def validate_candidate_set(self) -> "GuidedReviewPrepareResponse":
        if self.selectable_candidate_count != len(self.candidates):
            raise ValueError(
                "Selectable candidate count must match returned candidates."
            )
        if self.detected_pose_count < self.selectable_candidate_count:
            raise ValueError(
                "Selectable candidates cannot exceed model-returned poses."
            )
        expected_status = candidate_selection_status_for_count(
            self.selectable_candidate_count
        )
        if self.candidate_selection_status is not expected_status:
            raise ValueError(
                "Candidate selection status does not match selectable evidence."
            )
        return self


class GuidedHumanRoleAssignment(BaseModel):
    model_config = ConfigDict(extra="forbid")

    role: Literal["TORI"]
    source: Literal["HUMAN_CONFIRMATION"]
    candidate_token: str = Field(min_length=20)


class GuidedReviewConfirmInput(BaseModel):
    model_config = ConfigDict(extra="forbid")

    review_session_id: str = Field(min_length=20)
    role_assignment: GuidedHumanRoleAssignment
    tori_confirmed: bool
    support_leg: SupportLegSide
    attacking_leg: SupportLegSide
    projected_angle_view_suitable: bool
    low_roll_confirmed: bool
    reviewer_uncertain: bool
