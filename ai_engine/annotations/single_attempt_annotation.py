from __future__ import annotations

import math
from pathlib import PurePosixPath
import re
from typing import Literal

from pydantic import BaseModel, Field, ValidationError, field_validator, model_validator

from ai_engine.contracts.single_attempt_analysis_v2a import (
    AttemptBoundarySelection,
    FrameReference,
    SupportLegSelection,
)
from ai_engine.video_sampling import build_human_selected_frame_plan


ANNOTATION_SCHEMA_VERSION = "1.1.0"
ANNOTATION_READINESS_SCHEMA_VERSION = "1.1.0"
DETECTION_EVALUATION_SCHEMA_VERSION = "1.2.0"


def _validate_role_neutral_subject_reference(value: str) -> str:
    normalized = value.strip()
    if not normalized:
        raise ValueError("Subject reference ID cannot be empty.")
    if re.search(
        r"(?:^|[^A-Z0-9])(?:TORI|UKE)(?:$|[^A-Z0-9])",
        normalized.upper(),
    ):
        raise ValueError("Subject reference IDs must remain role-neutral.")
    return normalized


def _normalize_review_image_path(value: str) -> str:
    normalized = value.strip().replace("\\", "/")
    path = PurePosixPath(normalized)
    if (
        not normalized
        or path.is_absolute()
        or ".." in path.parts
        or len(path.parts) != 2
        or path.parts[0] != "frames"
        or path.suffix.lower() not in {".jpg", ".jpeg"}
    ):
        raise ValueError(
            "Review image must be a relative JPEG inside the frames directory."
        )
    return normalized


def _expected_review_image_path(
    sample_position: int,
    frame: FrameReference,
) -> str:
    return (
        f"frames/sample_{sample_position:03d}_"
        f"f{frame.frame_index:06d}_t{frame.timestamp_ms:06d}ms.jpg"
    )


def _validate_review_image_alignment(
    sample_position: int,
    frame: FrameReference,
    image: str,
) -> None:
    expected = _expected_review_image_path(sample_position, frame)
    if image != expected:
        raise ValueError(
            "Review image path does not match its sample position, frame "
            "index and timestamp."
        )


class AnnotatedVideoReference(BaseModel):
    video_id: str = Field(min_length=1)
    filename: str = Field(min_length=1)
    sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    width: int = Field(gt=0, strict=True)
    height: int = Field(gt=0, strict=True)
    source_fps: float = Field(gt=0)
    frame_count: int = Field(gt=0, strict=True)
    duration_seconds: float = Field(gt=0)

    @model_validator(mode="after")
    def validate_finite_metadata(self) -> "AnnotatedVideoReference":
        if not math.isfinite(self.source_fps):
            raise ValueError("Source FPS must be finite.")
        if not math.isfinite(self.duration_seconds):
            raise ValueError("Video duration must be finite.")
        return self


class HumanFrameAnnotation(BaseModel):
    sample_position: int = Field(ge=0, strict=True)
    frame: FrameReference
    image: str = Field(min_length=1)
    visible_judoka_count: int = Field(ge=0, strict=True)
    visible_subject_reference_ids: list[str] = Field(default_factory=list)
    selected_tori_subject_reference_id: str | None = None
    occlusion: bool
    crossing: bool
    notes: str | None = None

    @field_validator("image")
    @classmethod
    def normalize_image_path(cls, value: str) -> str:
        return _normalize_review_image_path(value)

    @field_validator("visible_subject_reference_ids")
    @classmethod
    def normalize_visible_subjects(cls, values: list[str]) -> list[str]:
        return [
            _validate_role_neutral_subject_reference(value)
            for value in values
        ]

    @field_validator("selected_tori_subject_reference_id")
    @classmethod
    def normalize_selected_tori(cls, value: str | None) -> str | None:
        if value is None:
            return None
        return _validate_role_neutral_subject_reference(value)

    @model_validator(mode="after")
    def validate_visible_subjects(self) -> "HumanFrameAnnotation":
        if len(set(self.visible_subject_reference_ids)) != len(
            self.visible_subject_reference_ids
        ):
            raise ValueError("Visible subject reference IDs must be unique.")

        if len(self.visible_subject_reference_ids) > self.visible_judoka_count:
            raise ValueError(
                "Named visible subjects cannot exceed visible judoka count."
            )

        if (
            self.selected_tori_subject_reference_id is not None
            and self.selected_tori_subject_reference_id
            not in self.visible_subject_reference_ids
        ):
            raise ValueError("Selected Tori must be visible in the frame.")

        return self


class HumanReviewerMetadata(BaseModel):
    annotation_source: Literal["human-reviewed"] = "human-reviewed"
    reviewer_reference: str = Field(min_length=1)
    review_notes: str | None = None


class ReviewSubsetSelection(BaseModel):
    method: str = Field(min_length=1)
    sample_count: int = Field(gt=0, strict=True)
    same_timestamps_as_fast_screening: Literal[True] = True
    pose_inference_run: Literal[False] = False


class DraftHumanReview(BaseModel):
    annotation_source: Literal["human-reviewed"] | None = None
    reviewer_reference: str | None = None
    reviewer_notes: str | None = None
    reviewed_attempt: AttemptBoundarySelection | None = None
    selected_tori_subject_reference_id: str | None = None
    support_leg: SupportLegSelection | None = None

    @field_validator("selected_tori_subject_reference_id")
    @classmethod
    def normalize_selected_tori(cls, value: str | None) -> str | None:
        if value is None:
            return None
        return _validate_role_neutral_subject_reference(value)


class DraftFrameAnnotation(BaseModel):
    sample_position: int = Field(ge=0, strict=True)
    frame: FrameReference
    image: str = Field(min_length=1)
    visible_judoka_count: int | None = Field(
        default=None,
        ge=0,
        strict=True,
    )
    visible_subject_reference_ids: list[str] | None = None
    selected_tori_subject_reference_id: str | None = None
    occlusion: bool | None = None
    crossing: bool | None = None
    reviewer_notes: str | None = None

    @field_validator("image")
    @classmethod
    def normalize_image_path(cls, value: str) -> str:
        return _normalize_review_image_path(value)

    @field_validator("visible_subject_reference_ids")
    @classmethod
    def normalize_visible_subjects(
        cls,
        values: list[str] | None,
    ) -> list[str] | None:
        if values is None:
            return None
        return [
            _validate_role_neutral_subject_reference(value)
            for value in values
        ]

    @field_validator("selected_tori_subject_reference_id")
    @classmethod
    def normalize_selected_tori(cls, value: str | None) -> str | None:
        if value is None:
            return None
        return _validate_role_neutral_subject_reference(value)

    @model_validator(mode="after")
    def validate_completed_subject_fields(self) -> "DraftFrameAnnotation":
        visible_subjects = self.visible_subject_reference_ids
        if visible_subjects is not None:
            if len(set(visible_subjects)) != len(visible_subjects):
                raise ValueError("Visible subject reference IDs must be unique.")
            if (
                self.visible_judoka_count is not None
                and len(visible_subjects) > self.visible_judoka_count
            ):
                raise ValueError(
                    "Named visible subjects cannot exceed visible judoka count."
                )
            if (
                self.selected_tori_subject_reference_id is not None
                and self.selected_tori_subject_reference_id
                not in visible_subjects
            ):
                raise ValueError("Selected Tori must be visible in the frame.")
        return self


class SingleAttemptAnnotationDraft(BaseModel):
    schema_version: Literal[ANNOTATION_SCHEMA_VERSION] = ANNOTATION_SCHEMA_VERSION
    annotation_type: Literal["single_attempt_uchi_mata_ground_truth_draft"] = (
        "single_attempt_uchi_mata_ground_truth_draft"
    )
    status: Literal["awaiting_human_annotation"] = "awaiting_human_annotation"
    source_screening_artifact: str = Field(min_length=1)
    source_screening_artifact_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    video: AnnotatedVideoReference
    selection: ReviewSubsetSelection
    human_review: DraftHumanReview
    frames: list[DraftFrameAnnotation] = Field(min_length=1)

    @model_validator(mode="after")
    def validate_subset_alignment(self) -> "SingleAttemptAnnotationDraft":
        if len(self.frames) != self.selection.sample_count:
            raise ValueError("Draft frame count must match subset sample count.")

        positions = [frame.sample_position for frame in self.frames]
        if positions != list(range(len(self.frames))):
            raise ValueError("Draft sample positions must be contiguous and ordered.")

        frame_indices = [frame.frame.frame_index for frame in self.frames]
        timestamps = [frame.frame.timestamp_ms for frame in self.frames]
        image_paths = [frame.image for frame in self.frames]
        if frame_indices != sorted(set(frame_indices)):
            raise ValueError("Draft frame indices must be unique and ordered.")
        if timestamps != sorted(set(timestamps)):
            raise ValueError("Draft timestamps must be unique and ordered.")
        if len(set(image_paths)) != len(image_paths):
            raise ValueError("Draft review image paths must be unique.")

        for frame in self.frames:
            _validate_frame_reference_against_video(frame.frame, self.video)
            _validate_review_image_alignment(
                frame.sample_position,
                frame.frame,
                frame.image,
            )

        return self


class SingleAttemptAnnotationSet(BaseModel):
    schema_version: Literal[ANNOTATION_SCHEMA_VERSION] = ANNOTATION_SCHEMA_VERSION
    annotation_type: Literal["single_attempt_uchi_mata_ground_truth"] = (
        "single_attempt_uchi_mata_ground_truth"
    )
    status: Literal["complete"] = "complete"
    source_screening_artifact: str = Field(min_length=1)
    source_screening_artifact_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    video: AnnotatedVideoReference
    selection: ReviewSubsetSelection
    reviewer: HumanReviewerMetadata
    reviewed_attempt: AttemptBoundarySelection
    selected_tori_subject_reference_id: str = Field(min_length=1)
    support_leg: SupportLegSelection
    frames: list[HumanFrameAnnotation] = Field(min_length=1)

    @field_validator("selected_tori_subject_reference_id")
    @classmethod
    def normalize_selected_tori(cls, value: str) -> str:
        return _validate_role_neutral_subject_reference(value)

    @model_validator(mode="after")
    def validate_frame_sequence(self) -> "SingleAttemptAnnotationSet":
        if len(self.frames) != self.selection.sample_count:
            raise ValueError(
                "Completed frame count must match the review subset."
            )

        frame_indices = [item.frame.frame_index for item in self.frames]
        timestamps = [item.frame.timestamp_ms for item in self.frames]
        sample_positions = [item.sample_position for item in self.frames]
        image_paths = [item.image for item in self.frames]

        if sample_positions != list(range(len(self.frames))):
            raise ValueError(
                "Completed sample positions must be contiguous and ordered."
            )
        if len(set(image_paths)) != len(image_paths):
            raise ValueError("Completed review image paths must be unique.")

        if len(set(frame_indices)) != len(frame_indices):
            raise ValueError("Annotated frame indices must be unique.")

        if frame_indices != sorted(frame_indices):
            raise ValueError("Annotated frames must be in increasing order.")

        if timestamps != sorted(set(timestamps)):
            raise ValueError(
                "Annotated timestamps must be unique and increasing."
            )

        for frame in self.frames:
            _validate_frame_reference_against_video(frame.frame, self.video)
            _validate_review_image_alignment(
                frame.sample_position,
                frame.frame,
                frame.image,
            )

        _validate_frame_reference_against_video(
            self.reviewed_attempt.start,
            self.video,
        )
        _validate_frame_reference_against_video(
            self.reviewed_attempt.end,
            self.video,
        )

        for frame in self.frames:
            selected = frame.selected_tori_subject_reference_id
            if (
                selected is not None
                and selected != self.selected_tori_subject_reference_id
            ):
                raise ValueError(
                    "Per-frame Tori selection must match the reviewed attempt."
                )

        if not any(
            frame.selected_tori_subject_reference_id
            == self.selected_tori_subject_reference_id
            and self.reviewed_attempt.start.frame_index
            <= frame.frame.frame_index
            <= self.reviewed_attempt.end.frame_index
            for frame in self.frames
        ):
            raise ValueError(
                "Reviewed Tori must be visibly confirmed in at least one "
                "annotated frame inside the reviewed attempt."
            )

        return self


def _validate_frame_reference_against_video(
    frame: FrameReference,
    video: AnnotatedVideoReference,
) -> None:
    plan = build_human_selected_frame_plan(
        source_fps=video.source_fps,
        frame_count=video.frame_count,
        frame_index=frame.frame_index,
    )
    expected_timestamp_ms = plan.timestamps_ms[0]
    if frame.timestamp_ms != expected_timestamp_ms:
        raise ValueError(
            f"Frame {frame.frame_index} timestamp must be "
            f"{expected_timestamp_ms} ms for the source video timebase."
        )


class AnnotationDraftReadinessReport(BaseModel):
    schema_version: Literal[ANNOTATION_READINESS_SCHEMA_VERSION] = (
        ANNOTATION_READINESS_SCHEMA_VERSION
    )
    annotation_schema_version: Literal[ANNOTATION_SCHEMA_VERSION] = (
        ANNOTATION_SCHEMA_VERSION
    )
    status: Literal["ready_to_finalize", "awaiting_human_annotation"]
    sample_count: int = Field(ge=1)
    complete_frame_count: int = Field(ge=0)
    incomplete_frame_count: int = Field(ge=0)
    missing_human_review_fields: list[str]
    missing_frame_field_counts: dict[str, int]
    incomplete_sample_positions: list[int]
    selected_tori_confirmation_count: int = Field(ge=0)
    final_validation_errors: list[str]
    can_finalize: bool
    review_asset_check_performed: bool = False
    expected_review_asset_count: int = Field(default=0, ge=0)
    readable_review_asset_count: int = Field(default=0, ge=0)
    missing_review_asset_sample_positions: list[int] = Field(
        default_factory=list
    )
    unreadable_review_asset_sample_positions: list[int] = Field(
        default_factory=list
    )
    dimension_mismatch_review_asset_sample_positions: list[int] = Field(
        default_factory=list
    )
    review_assets_ready: bool | None = None
    labels_inferred_or_defaulted: Literal[False] = False

    @model_validator(mode="after")
    def validate_readiness_consistency(self) -> "AnnotationDraftReadinessReport":
        if self.complete_frame_count + self.incomplete_frame_count != (
            self.sample_count
        ):
            raise ValueError(
                "Complete and incomplete frame counts must equal samples."
            )
        if (
            len(set(self.incomplete_sample_positions))
            != self.incomplete_frame_count
            or any(
                position < 0 or position >= self.sample_count
                for position in self.incomplete_sample_positions
            )
        ):
            raise ValueError("Incomplete sample positions are inconsistent.")

        human_fields_ready = (
            not self.missing_human_review_fields
            and self.incomplete_frame_count == 0
            and not self.final_validation_errors
        )
        asset_gate_ready = (
            not self.review_asset_check_performed
            or self.review_assets_ready is True
        )
        expected_can_finalize = human_fields_ready and asset_gate_ready
        if self.can_finalize != expected_can_finalize:
            raise ValueError("Draft finalization state is inconsistent.")
        if (self.status == "ready_to_finalize") != self.can_finalize:
            raise ValueError("Draft readiness status is inconsistent.")

        asset_position_lists = (
            self.missing_review_asset_sample_positions,
            self.unreadable_review_asset_sample_positions,
            self.dimension_mismatch_review_asset_sample_positions,
        )
        if not self.review_asset_check_performed:
            if (
                self.expected_review_asset_count != 0
                or self.readable_review_asset_count != 0
                or any(asset_position_lists)
                or self.review_assets_ready is not None
            ):
                raise ValueError("Unchecked review-asset state must be empty.")
            return self

        if self.expected_review_asset_count != self.sample_count:
            raise ValueError("Expected review assets must equal sample count.")
        if any(
            len(set(positions)) != len(positions)
            or any(
                position < 0 or position >= self.sample_count
                for position in positions
            )
            for positions in asset_position_lists
        ):
            raise ValueError("Review-asset sample positions are inconsistent.")
        if set(self.missing_review_asset_sample_positions) & set(
            self.unreadable_review_asset_sample_positions
        ):
            raise ValueError("Review assets cannot be missing and unreadable.")
        if (
            self.readable_review_asset_count
            + len(self.missing_review_asset_sample_positions)
            + len(self.unreadable_review_asset_sample_positions)
            != self.expected_review_asset_count
        ):
            raise ValueError("Review-asset counts are inconsistent.")

        expected_assets_ready = (
            self.readable_review_asset_count
            == self.expected_review_asset_count
            and not any(asset_position_lists)
        )
        if self.review_assets_ready != expected_assets_ready:
            raise ValueError("Review-asset readiness state is inconsistent.")
        return self


def inspect_annotation_draft(
    draft: SingleAttemptAnnotationDraft,
) -> AnnotationDraftReadinessReport:
    """Report every missing human field without inventing default labels."""

    review = draft.human_review
    missing_review_fields: list[str] = []
    if review.annotation_source != "human-reviewed":
        missing_review_fields.append("annotation_source")
    if not review.reviewer_reference:
        missing_review_fields.append("reviewer_reference")
    if review.reviewed_attempt is None:
        missing_review_fields.append("reviewed_attempt")
    if not review.selected_tori_subject_reference_id:
        missing_review_fields.append("selected_tori_subject_reference_id")
    if review.support_leg is None:
        missing_review_fields.append("support_leg")

    required_frame_fields = (
        "visible_judoka_count",
        "visible_subject_reference_ids",
        "occlusion",
        "crossing",
    )
    missing_frame_counts = {field: 0 for field in required_frame_fields}
    incomplete_positions: list[int] = []
    selected_tori_confirmations = 0

    for frame in draft.frames:
        missing_in_frame = False
        for field in required_frame_fields:
            if getattr(frame, field) is None:
                missing_frame_counts[field] += 1
                missing_in_frame = True
        if missing_in_frame:
            incomplete_positions.append(frame.sample_position)
        if frame.selected_tori_subject_reference_id is not None:
            selected_tori_confirmations += 1

    final_validation_errors: list[str] = []
    if not missing_review_fields and not incomplete_positions:
        try:
            _build_completed_annotation_set(draft)
        except ValidationError as error:
            final_validation_errors.extend(
                issue["msg"] for issue in error.errors()
            )
        except ValueError as error:
            final_validation_errors.append(str(error))

    can_finalize = (
        not missing_review_fields
        and not incomplete_positions
        and not final_validation_errors
    )
    complete_count = len(draft.frames) - len(incomplete_positions)

    return AnnotationDraftReadinessReport(
        status=(
            "ready_to_finalize"
            if can_finalize
            else "awaiting_human_annotation"
        ),
        sample_count=len(draft.frames),
        complete_frame_count=complete_count,
        incomplete_frame_count=len(incomplete_positions),
        missing_human_review_fields=missing_review_fields,
        missing_frame_field_counts=missing_frame_counts,
        incomplete_sample_positions=incomplete_positions,
        selected_tori_confirmation_count=selected_tori_confirmations,
        final_validation_errors=final_validation_errors,
        can_finalize=can_finalize,
    )


def _build_completed_annotation_set(
    draft: SingleAttemptAnnotationDraft,
) -> SingleAttemptAnnotationSet:
    review = draft.human_review
    if (
        review.annotation_source != "human-reviewed"
        or not review.reviewer_reference
        or review.reviewed_attempt is None
        or not review.selected_tori_subject_reference_id
        or review.support_leg is None
    ):
        raise ValueError("Draft human review metadata is incomplete.")

    completed_frames: list[HumanFrameAnnotation] = []
    for frame in draft.frames:
        if (
            frame.visible_judoka_count is None
            or frame.visible_subject_reference_ids is None
            or frame.occlusion is None
            or frame.crossing is None
        ):
            raise ValueError(
                f"Human annotation is incomplete at sample {frame.sample_position}."
            )

        completed_frames.append(
            HumanFrameAnnotation(
                sample_position=frame.sample_position,
                frame=frame.frame,
                image=frame.image,
                visible_judoka_count=frame.visible_judoka_count,
                visible_subject_reference_ids=frame.visible_subject_reference_ids,
                selected_tori_subject_reference_id=(
                    frame.selected_tori_subject_reference_id
                ),
                occlusion=frame.occlusion,
                crossing=frame.crossing,
                notes=frame.reviewer_notes,
            )
        )

    return SingleAttemptAnnotationSet(
        source_screening_artifact=draft.source_screening_artifact,
        source_screening_artifact_sha256=(
            draft.source_screening_artifact_sha256
        ),
        video=draft.video,
        selection=draft.selection,
        reviewer=HumanReviewerMetadata(
            reviewer_reference=review.reviewer_reference,
            review_notes=review.reviewer_notes,
        ),
        reviewed_attempt=review.reviewed_attempt,
        selected_tori_subject_reference_id=(
            review.selected_tori_subject_reference_id
        ),
        support_leg=review.support_leg,
        frames=completed_frames,
    )


def finalize_annotation_draft(
    draft: SingleAttemptAnnotationDraft,
) -> SingleAttemptAnnotationSet:
    """Fail closed until every required human field is complete."""

    readiness = inspect_annotation_draft(draft)
    if not readiness.can_finalize:
        if readiness.missing_human_review_fields:
            reason = (
                "Missing human review fields: "
                + ", ".join(readiness.missing_human_review_fields)
            )
        elif readiness.incomplete_sample_positions:
            reason = (
                "Incomplete frame labels at sample positions: "
                + ", ".join(
                    str(position)
                    for position in readiness.incomplete_sample_positions[:10]
                )
            )
        else:
            reason = "; ".join(readiness.final_validation_errors)
        raise ValueError(f"Annotation draft is not ready. {reason}")

    return _build_completed_annotation_set(draft)


class PoseDetectionCount(BaseModel):
    frame: FrameReference
    detected_person_count: int = Field(ge=0, strict=True)
    engine_id: str = Field(min_length=1)
    observation_source: Literal["model-estimated"] = "model-estimated"


DetectionCondition = Literal[
    "all_annotated_frames",
    "occlusion_present",
    "crossing_present",
    "occlusion_without_crossing",
    "crossing_without_occlusion",
    "occlusion_and_crossing",
    "clear_of_occlusion_and_crossing",
]


class ConditionalDetectionSlice(BaseModel):
    condition: DetectionCondition
    annotated_frame_count: int = Field(ge=0)
    matched_prediction_count: int = Field(ge=0)
    missing_prediction_count: int = Field(ge=0)
    frames_with_at_least_one_visible_judoka: int = Field(ge=0)
    frames_with_detection_when_at_least_one_visible: int = Field(ge=0)
    detection_coverage_given_at_least_one_visible: float | None = Field(
        default=None,
        ge=0,
        le=1,
    )
    frames_with_at_least_two_visible_judoka: int = Field(ge=0)
    frames_with_two_detections_when_at_least_two_visible: int = Field(ge=0)
    two_detection_coverage_given_two_visible: float | None = Field(
        default=None,
        ge=0,
        le=1,
    )
    frames_with_detection_deficit: int = Field(ge=0)
    frames_with_detection_surplus: int = Field(ge=0)

    @model_validator(mode="after")
    def validate_counts(self) -> "ConditionalDetectionSlice":
        if (
            self.matched_prediction_count + self.missing_prediction_count
            != self.annotated_frame_count
        ):
            raise ValueError(
                "Matched plus missing predictions must equal annotated frames."
            )
        if (
            self.frames_with_detection_when_at_least_one_visible
            > self.frames_with_at_least_one_visible_judoka
            or self.frames_with_two_detections_when_at_least_two_visible
            > self.frames_with_at_least_two_visible_judoka
        ):
            raise ValueError("Detection successes cannot exceed denominators.")
        if (
            self.frames_with_detection_deficit
            + self.frames_with_detection_surplus
            > self.annotated_frame_count
        ):
            raise ValueError("Deficit and surplus counts exceed the slice.")

        expected_one = (
            self.frames_with_detection_when_at_least_one_visible
            / self.frames_with_at_least_one_visible_judoka
            if self.frames_with_at_least_one_visible_judoka
            else None
        )
        expected_two = (
            self.frames_with_two_detections_when_at_least_two_visible
            / self.frames_with_at_least_two_visible_judoka
            if self.frames_with_at_least_two_visible_judoka
            else None
        )
        if self.detection_coverage_given_at_least_one_visible != expected_one:
            raise ValueError("One-person conditional coverage is inconsistent.")
        if self.two_detection_coverage_given_two_visible != expected_two:
            raise ValueError("Two-person conditional coverage is inconsistent.")
        return self


class DetectionGroundTruthEvaluation(BaseModel):
    schema_version: Literal[DETECTION_EVALUATION_SCHEMA_VERSION] = (
        DETECTION_EVALUATION_SCHEMA_VERSION
    )
    annotation_schema_version: Literal[ANNOTATION_SCHEMA_VERSION] = (
        ANNOTATION_SCHEMA_VERSION
    )
    engine_id: str = Field(min_length=1)
    source_video_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    benchmark_artifact_sha256: str | None = Field(
        default=None,
        pattern=r"^[0-9a-f]{64}$",
    )
    artifact_alignment_verified: bool
    matched_frame_count: int = Field(ge=0)
    missing_prediction_count: int = Field(ge=0)
    unexpected_prediction_count: int = Field(ge=0)
    frames_with_at_least_one_visible_judoka: int = Field(ge=0)
    frames_with_detection_when_at_least_one_visible: int = Field(ge=0)
    detection_coverage_given_at_least_one_visible: float | None = Field(
        default=None,
        ge=0,
        le=1,
    )
    frames_with_at_least_two_visible_judoka: int = Field(ge=0)
    frames_with_two_detections_when_at_least_two_visible: int = Field(ge=0)
    two_detection_coverage_given_two_visible: float | None = Field(
        default=None,
        ge=0,
        le=1,
    )
    frames_with_detection_deficit: int = Field(ge=0)
    frames_with_detection_surplus: int = Field(ge=0)
    conditional_slices: list[ConditionalDetectionSlice]
    human_annotation_source: Literal["human-reviewed"] = "human-reviewed"
    prediction_observation_source: Literal["model-estimated"] = (
        "model-estimated"
    )
    coverage_is_confidence: Literal[False] = False
    pose_accuracy_evaluated: Literal[False] = False
    athlete_identity_evaluated: Literal[False] = False
    interpretation: Literal["detection_coverage_evaluation_only"] = (
        "detection_coverage_evaluation_only"
    )

    @model_validator(mode="after")
    def validate_conditional_slices(self) -> "DetectionGroundTruthEvaluation":
        if self.artifact_alignment_verified != (
            self.benchmark_artifact_sha256 is not None
        ):
            raise ValueError(
                "Artifact alignment state and SHA-256 must agree."
            )

        expected = {
            "all_annotated_frames",
            "occlusion_present",
            "crossing_present",
            "occlusion_without_crossing",
            "crossing_without_occlusion",
            "occlusion_and_crossing",
            "clear_of_occlusion_and_crossing",
        }
        actual = [item.condition for item in self.conditional_slices]
        if len(actual) != len(expected) or set(actual) != expected:
            raise ValueError(
                "Detection evaluation must contain every approved condition "
                "exactly once."
            )

        overall = next(
            item
            for item in self.conditional_slices
            if item.condition == "all_annotated_frames"
        )
        top_level_values = (
            self.matched_frame_count,
            self.missing_prediction_count,
            self.frames_with_at_least_one_visible_judoka,
            self.frames_with_detection_when_at_least_one_visible,
            self.detection_coverage_given_at_least_one_visible,
            self.frames_with_at_least_two_visible_judoka,
            self.frames_with_two_detections_when_at_least_two_visible,
            self.two_detection_coverage_given_two_visible,
            self.frames_with_detection_deficit,
            self.frames_with_detection_surplus,
        )
        overall_values = (
            overall.matched_prediction_count,
            overall.missing_prediction_count,
            overall.frames_with_at_least_one_visible_judoka,
            overall.frames_with_detection_when_at_least_one_visible,
            overall.detection_coverage_given_at_least_one_visible,
            overall.frames_with_at_least_two_visible_judoka,
            overall.frames_with_two_detections_when_at_least_two_visible,
            overall.two_detection_coverage_given_two_visible,
            overall.frames_with_detection_deficit,
            overall.frames_with_detection_surplus,
        )
        if top_level_values != overall_values:
            raise ValueError(
                "Top-level detection metrics must match the all-frame slice."
            )

        exclusive_conditions = {
            "occlusion_without_crossing",
            "crossing_without_occlusion",
            "occlusion_and_crossing",
            "clear_of_occlusion_and_crossing",
        }
        exclusive = [
            item
            for item in self.conditional_slices
            if item.condition in exclusive_conditions
        ]
        additive_fields = (
            "annotated_frame_count",
            "matched_prediction_count",
            "missing_prediction_count",
            "frames_with_at_least_one_visible_judoka",
            "frames_with_detection_when_at_least_one_visible",
            "frames_with_at_least_two_visible_judoka",
            "frames_with_two_detections_when_at_least_two_visible",
            "frames_with_detection_deficit",
            "frames_with_detection_surplus",
        )
        for field in additive_fields:
            if sum(getattr(item, field) for item in exclusive) != getattr(
                overall,
                field,
            ):
                raise ValueError(
                    "Mutually exclusive detection slices must partition the "
                    "all-frame metrics."
                )
        return self


def _evaluate_detection_slice(
    annotations: list[HumanFrameAnnotation],
    prediction_by_frame: dict[tuple[int, int], PoseDetectionCount],
    *,
    condition: DetectionCondition,
) -> ConditionalDetectionSlice:
    matched = 0
    missing = 0
    at_least_one_visible = 0
    detection_when_visible = 0
    at_least_two_visible = 0
    two_detections_when_two_visible = 0
    deficits = 0
    surpluses = 0

    for annotation in annotations:
        key = (annotation.frame.frame_index, annotation.frame.timestamp_ms)
        prediction = prediction_by_frame.get(key)
        visible = annotation.visible_judoka_count

        if visible >= 1:
            at_least_one_visible += 1
        if visible >= 2:
            at_least_two_visible += 1

        if prediction is None:
            missing += 1
            if visible > 0:
                deficits += 1
            continue

        matched += 1
        detected = prediction.detected_person_count
        if visible >= 1 and detected >= 1:
            detection_when_visible += 1
        if visible >= 2 and detected >= 2:
            two_detections_when_two_visible += 1
        if detected < visible:
            deficits += 1
        elif detected > visible:
            surpluses += 1

    return ConditionalDetectionSlice(
        condition=condition,
        annotated_frame_count=len(annotations),
        matched_prediction_count=matched,
        missing_prediction_count=missing,
        frames_with_at_least_one_visible_judoka=at_least_one_visible,
        frames_with_detection_when_at_least_one_visible=(
            detection_when_visible
        ),
        detection_coverage_given_at_least_one_visible=(
            detection_when_visible / at_least_one_visible
            if at_least_one_visible
            else None
        ),
        frames_with_at_least_two_visible_judoka=at_least_two_visible,
        frames_with_two_detections_when_at_least_two_visible=(
            two_detections_when_two_visible
        ),
        two_detection_coverage_given_two_visible=(
            two_detections_when_two_visible / at_least_two_visible
            if at_least_two_visible
            else None
        ),
        frames_with_detection_deficit=deficits,
        frames_with_detection_surplus=surpluses,
    )


def evaluate_detection_against_human_labels(
    annotations: SingleAttemptAnnotationSet,
    predictions: list[PoseDetectionCount],
    *,
    engine_id: str | None = None,
    benchmark_artifact_sha256: str | None = None,
    artifact_alignment_verified: bool = False,
) -> DetectionGroundTruthEvaluation:
    """Calculate detection coverage only where complete human labels exist."""

    engine_ids = {prediction.engine_id for prediction in predictions}
    if engine_id is None:
        if len(engine_ids) != 1:
            raise ValueError(
                "Exactly one pose engine must be evaluated at a time."
            )
        selected_engine_id = next(iter(engine_ids))
    else:
        selected_engine_id = engine_id.strip()
        if not selected_engine_id:
            raise ValueError("Engine ID cannot be empty.")
        if engine_ids and engine_ids != {selected_engine_id}:
            raise ValueError("Prediction engine does not match the requested engine.")

    prediction_by_frame: dict[tuple[int, int], PoseDetectionCount] = {}

    for prediction in predictions:
        key = (prediction.frame.frame_index, prediction.frame.timestamp_ms)
        if key in prediction_by_frame:
            raise ValueError("Predictions contain a duplicate frame reference.")
        prediction_by_frame[key] = prediction

    annotation_keys = {
        (annotation.frame.frame_index, annotation.frame.timestamp_ms)
        for annotation in annotations.frames
    }

    slices = [
        _evaluate_detection_slice(
            annotations.frames,
            prediction_by_frame,
            condition="all_annotated_frames",
        ),
        _evaluate_detection_slice(
            [frame for frame in annotations.frames if frame.occlusion],
            prediction_by_frame,
            condition="occlusion_present",
        ),
        _evaluate_detection_slice(
            [frame for frame in annotations.frames if frame.crossing],
            prediction_by_frame,
            condition="crossing_present",
        ),
        _evaluate_detection_slice(
            [
                frame
                for frame in annotations.frames
                if frame.occlusion and not frame.crossing
            ],
            prediction_by_frame,
            condition="occlusion_without_crossing",
        ),
        _evaluate_detection_slice(
            [
                frame
                for frame in annotations.frames
                if frame.crossing and not frame.occlusion
            ],
            prediction_by_frame,
            condition="crossing_without_occlusion",
        ),
        _evaluate_detection_slice(
            [
                frame
                for frame in annotations.frames
                if frame.occlusion and frame.crossing
            ],
            prediction_by_frame,
            condition="occlusion_and_crossing",
        ),
        _evaluate_detection_slice(
            [
                frame
                for frame in annotations.frames
                if not frame.occlusion and not frame.crossing
            ],
            prediction_by_frame,
            condition="clear_of_occlusion_and_crossing",
        ),
    ]
    overall = slices[0]

    return DetectionGroundTruthEvaluation(
        engine_id=selected_engine_id,
        source_video_sha256=annotations.video.sha256,
        benchmark_artifact_sha256=benchmark_artifact_sha256,
        artifact_alignment_verified=artifact_alignment_verified,
        matched_frame_count=overall.matched_prediction_count,
        missing_prediction_count=overall.missing_prediction_count,
        unexpected_prediction_count=len(
            set(prediction_by_frame).difference(annotation_keys)
        ),
        frames_with_at_least_one_visible_judoka=(
            overall.frames_with_at_least_one_visible_judoka
        ),
        frames_with_detection_when_at_least_one_visible=(
            overall.frames_with_detection_when_at_least_one_visible
        ),
        detection_coverage_given_at_least_one_visible=(
            overall.detection_coverage_given_at_least_one_visible
        ),
        frames_with_at_least_two_visible_judoka=(
            overall.frames_with_at_least_two_visible_judoka
        ),
        frames_with_two_detections_when_at_least_two_visible=(
            overall.frames_with_two_detections_when_at_least_two_visible
        ),
        two_detection_coverage_given_two_visible=(
            overall.two_detection_coverage_given_two_visible
        ),
        frames_with_detection_deficit=(
            overall.frames_with_detection_deficit
        ),
        frames_with_detection_surplus=(
            overall.frames_with_detection_surplus
        ),
        conditional_slices=slices,
    )
