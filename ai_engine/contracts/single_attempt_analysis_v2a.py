from __future__ import annotations

from enum import Enum
import math
from typing import Literal

from pydantic import BaseModel, Field, model_validator

from ai_engine.contracts.single_camera_pose_summary import (
    AnalysisLimitation,
    AnalysisProvenance,
    TechniqueReference,
)


SCHEMA_VERSION = "2.0.0"
ANALYSIS_VARIANT = "single_attempt_v2a"


class MetricStatus(str, Enum):
    REPORTABLE = "reportable"
    REVIEW_REQUIRED = "review_required"
    WITHHELD = "withheld"


class SupportLegSide(str, Enum):
    LEFT = "left"
    RIGHT = "right"


class FrameReference(BaseModel):
    frame_index: int = Field(ge=0, strict=True)
    timestamp_ms: int = Field(ge=0, strict=True)
    pts_ms: int | None = Field(default=None, ge=0, strict=True)
    timing_provenance: str | None = Field(default=None, min_length=1)
    timing_manifest_id: str | None = Field(default=None, min_length=20)
    video_id: str | None = Field(default=None, min_length=1)
    canonicalization_method_version: str | None = Field(default=None, min_length=1)


class SourceTimingInterpretation(BaseModel):
    state: Literal["REAL_TIME", "KNOWN_TIME_SCALE", "UNKNOWN"]
    timing_mode: Literal["CFR", "VFR", "UNKNOWN"]
    timestamp_provenance: str = Field(min_length=1)
    physical_time_scale: float | None = Field(default=None, gt=0)

    @model_validator(mode="after")
    def validate_scale(self) -> "SourceTimingInterpretation":
        if self.state == "KNOWN_TIME_SCALE":
            if self.physical_time_scale is None:
                raise ValueError("Known source timing requires an explicit scale.")
        elif self.physical_time_scale is not None:
            raise ValueError("Only KNOWN_TIME_SCALE may carry a time scale.")
        return self


class AttemptBoundarySelection(BaseModel):
    start: FrameReference
    end: FrameReference
    event_schema_id: str = Field(min_length=1)
    selection_source: Literal["human-selected"] = "human-selected"
    reviewer_notes: str | None = None
    boundaries_human_confirmed: bool = False
    source_timing: SourceTimingInterpretation | None = None
    single_attempt_confirmed: bool = False
    attempt_scope: Literal["SINGLE_ATTEMPT"] | None = None
    attempt_scope_source: Literal["HUMAN_CONFIRMED"] | None = None
    attempt_scope_contract_version: Literal[
        "single-attempt-human-confirmation-1.0.0"
    ] | None = None

    @model_validator(mode="after")
    def validate_order(self) -> "AttemptBoundarySelection":
        if self.end.frame_index <= self.start.frame_index:
            raise ValueError("Attempt end frame must follow start frame.")

        if self.end.timestamp_ms <= self.start.timestamp_ms:
            raise ValueError("Attempt end timestamp must follow start timestamp.")

        scope_fields = (
            self.attempt_scope,
            self.attempt_scope_source,
            self.attempt_scope_contract_version,
        )
        if self.single_attempt_confirmed and any(value is None for value in scope_fields):
            raise ValueError("Confirmed single-attempt scope requires complete provenance.")
        if not self.single_attempt_confirmed and any(value is not None for value in scope_fields):
            raise ValueError("Single-attempt scope cannot exist without human confirmation.")

        return self


class SubjectSelection(BaseModel):
    neutral_track_id: str = Field(pattern=r"^Track [A-Z]+$")
    selected_detection_index: int = Field(ge=0)
    role: Literal["Tori"] = "Tori"
    confirmation_source: Literal["human-confirmed"] = "human-confirmed"
    reviewer_notes: str | None = None

    @model_validator(mode="after")
    def reject_role_as_track_id(self) -> "SubjectSelection":
        if self.neutral_track_id in {"Track TORI", "Track UKE"}:
            raise ValueError("Role names cannot be used as neutral track IDs.")

        return self


class SupportLegSelection(BaseModel):
    side: SupportLegSide
    confirmation_source: Literal["human-confirmed"] = "human-confirmed"
    reviewer_notes: str | None = None


class AttackingLegSelection(BaseModel):
    side: SupportLegSide
    confirmation_source: Literal["human-confirmed"] = "human-confirmed"
    reviewer_notes: str | None = None


class CameraSuitabilityReview(BaseModel):
    projected_angle_view_suitable: bool
    low_roll_confirmed: bool
    review_source: Literal["human-reviewed"] = "human-reviewed"
    reviewer_notes: str | None = None

    @property
    def permits_reportable_angles(self) -> bool:
        return self.projected_angle_view_suitable and self.low_roll_confirmed


class AnalysisFrameSelection(BaseModel):
    frame: FrameReference
    selection_source: Literal["human-selected"] = "human-selected"
    event_label: str = Field(min_length=1)
    reviewer_notes: str | None = None


class Landmark2D(BaseModel):
    x: float = Field(ge=0, le=1)
    y: float = Field(ge=0, le=1)
    visibility: float | None = Field(default=None, ge=0, le=1)

    @model_validator(mode="after")
    def validate_finite_coordinates(self) -> "Landmark2D":
        if not math.isfinite(self.x) or not math.isfinite(self.y):
            raise ValueError("Landmark coordinates must be finite.")

        return self


class PoseObservation2D(BaseModel):
    frame: FrameReference
    neutral_track_id: str = Field(pattern=r"^Track [A-Z]+$")
    detection_index: int = Field(ge=0)
    image_width: int = Field(gt=0)
    image_height: int = Field(gt=0)
    coordinate_space: Literal["normalized_image"] = "normalized_image"
    landmarks: dict[str, Landmark2D]
    boundary_normalized_landmarks: list[str] = Field(default_factory=list)
    provenance: Literal[AnalysisProvenance.MODEL_ESTIMATED] = (
        AnalysisProvenance.MODEL_ESTIMATED
    )

    @model_validator(mode="after")
    def validate_boundary_normalized_landmarks(self) -> "PoseObservation2D":
        unknown = sorted(
            set(self.boundary_normalized_landmarks).difference(self.landmarks)
        )
        if unknown:
            raise ValueError(
                "Boundary-normalized landmark names must exist in landmarks: "
                + ", ".join(unknown)
            )

        return self


class SingleAttemptAnalysisRequest(BaseModel):
    schema_version: Literal[SCHEMA_VERSION] = SCHEMA_VERSION
    analysis_variant: Literal[ANALYSIS_VARIANT] = ANALYSIS_VARIANT
    video_id: str = Field(min_length=1)
    technique: TechniqueReference
    camera_view: Literal[
        "side",
        "front",
        "rear",
        "forty_five_degrees",
        "unknown",
    ]
    attempt: AttemptBoundarySelection
    subject: SubjectSelection
    support_leg: SupportLegSelection
    attacking_leg: AttackingLegSelection | None = None
    angle_frame: AnalysisFrameSelection
    camera_suitability: CameraSuitabilityReview
    pose_observation: PoseObservation2D | None = None

    @model_validator(mode="after")
    def validate_manual_and_observation_alignment(
        self,
    ) -> "SingleAttemptAnalysisRequest":
        if self.technique.id != "uchi-mata":
            raise ValueError("V2A currently supports only Uchi Mata.")

        selected_frame = self.angle_frame.frame
        if not (
            self.attempt.start.timestamp_ms
            <= selected_frame.timestamp_ms
            <= self.attempt.end.timestamp_ms
        ):
            raise ValueError("Angle frame must be inside the selected attempt.")

        if not (
            self.attempt.start.frame_index
            <= selected_frame.frame_index
            <= self.attempt.end.frame_index
        ):
            raise ValueError("Angle frame index must be inside the attempt.")

        if self.pose_observation is not None:
            if self.pose_observation.frame != selected_frame:
                raise ValueError(
                    "Pose observation must match the human-selected angle frame."
                )

            if (
                self.pose_observation.neutral_track_id
                != self.subject.neutral_track_id
            ):
                raise ValueError(
                    "Pose observation must match the human-confirmed track."
                )

            if (
                self.pose_observation.detection_index
                != self.subject.selected_detection_index
            ):
                raise ValueError(
                    "Pose observation must match the human-selected detection."
                )

        return self


class MetricConfidence(BaseModel):
    available: bool
    kind: Literal["minimum_model_landmark_visibility"] | None = None
    value: float | None = Field(default=None, ge=0, le=1)
    provenance: Literal[AnalysisProvenance.MODEL_ESTIMATED] | None = None
    interpretation: str = Field(min_length=1)

    @model_validator(mode="after")
    def validate_availability(self) -> "MetricConfidence":
        evidence_fields = (self.kind, self.value, self.provenance)

        if self.available and any(field is None for field in evidence_fields):
            raise ValueError("Available confidence requires complete evidence.")

        if not self.available and any(
            field is not None for field in evidence_fields
        ):
            raise ValueError("Unavailable confidence cannot carry a value.")

        return self


class OverlayPoint(BaseModel):
    x: float = Field(ge=0, le=1)
    y: float = Field(ge=0, le=1)
    label: str | None = None

    @model_validator(mode="after")
    def validate_finite_coordinates(self) -> "OverlayPoint":
        if not math.isfinite(self.x) or not math.isfinite(self.y):
            raise ValueError("Overlay coordinates must be finite.")

        return self


class OverlayPrimitive(BaseModel):
    kind: Literal["line", "polyline", "angle_label"]
    points: list[OverlayPoint]
    label: str = Field(min_length=1)
    color_layer: Literal["blue"] = "blue"

    @model_validator(mode="after")
    def validate_shape(self) -> "OverlayPrimitive":
        if not self.label.strip():
            raise ValueError("Overlay labels cannot be blank.")

        if self.kind == "line" and len(self.points) != 2:
            raise ValueError("Line overlays require exactly two points.")

        if self.kind == "polyline" and len(self.points) < 2:
            raise ValueError("Polyline overlays require at least two points.")

        if self.kind == "angle_label" and len(self.points) != 1:
            raise ValueError("Angle labels require exactly one anchor point.")

        return self


class MetricTemporalReference(BaseModel):
    kind: Literal["instant", "interval"]
    frame: FrameReference | None = None
    start: FrameReference | None = None
    end: FrameReference | None = None

    @model_validator(mode="after")
    def validate_reference(self) -> "MetricTemporalReference":
        if self.kind == "instant":
            if self.frame is None or self.start is not None or self.end is not None:
                raise ValueError("Instant metrics require only one frame reference.")
        elif self.frame is not None or self.start is None or self.end is None:
            raise ValueError("Interval metrics require start and end references.")

        return self


class MetricResult(BaseModel):
    metric_id: Literal[
        "UM-TIM-001",
        "UM-ANG-001",
        "UM-ANG-002",
        "UM-ANG-003",
    ]
    name: str = Field(min_length=1)
    status: MetricStatus
    value: float | None = None
    unit: Literal["seconds", "degrees"]
    provenance: Literal[
        AnalysisProvenance.MEASURED,
        AnalysisProvenance.MODEL_ESTIMATED,
    ]
    temporal_reference: MetricTemporalReference
    confidence: MetricConfidence
    method_version: str = Field(min_length=1)
    limitation: str = Field(min_length=1)
    descriptive_text: str | None = Field(default=None, min_length=1)
    withheld_reason: str | None = Field(default=None, min_length=1)
    overlay: list[OverlayPrimitive] = Field(default_factory=list)

    @model_validator(mode="after")
    def validate_status_payload(self) -> "MetricResult":
        if self.value is not None and not math.isfinite(self.value):
            raise ValueError("Metric value must be finite.")

        if self.status == MetricStatus.WITHHELD:
            if self.value is not None or self.descriptive_text is not None:
                raise ValueError("Withheld metrics cannot expose a value.")
            if not self.withheld_reason:
                raise ValueError("Withheld metrics require an explicit reason.")
            if self.overlay:
                raise ValueError("Withheld metrics cannot expose geometry.")
        else:
            if self.value is None or not self.descriptive_text:
                raise ValueError("Available metrics require value and description.")
            if self.withheld_reason is not None:
                raise ValueError("Available metrics cannot claim withholding.")

        expected_contract = {
            "UM-TIM-001": (
                "seconds",
                AnalysisProvenance.MEASURED,
                "interval",
                "reviewed-event-elapsed-time-1.0.0",
            ),
            "UM-ANG-001": (
                "degrees",
                AnalysisProvenance.MODEL_ESTIMATED,
                "instant",
                "projected-trunk-inclination-1.0.0",
            ),
            "UM-ANG-002": (
                "degrees",
                AnalysisProvenance.MODEL_ESTIMATED,
                "instant",
                "projected-knee-angle-1.0.0",
            ),
            "UM-ANG-003": (
                "degrees",
                AnalysisProvenance.MODEL_ESTIMATED,
                "instant",
                "projected-knee-angle-1.0.0",
            ),
        }
        expected_unit, expected_provenance, expected_time, expected_method = (
            expected_contract[self.metric_id]
        )

        if self.unit != expected_unit:
            raise ValueError("Metric unit does not match the approved registry.")

        if self.provenance != expected_provenance:
            raise ValueError(
                "Metric provenance does not match the approved registry."
            )

        if self.temporal_reference.kind != expected_time:
            raise ValueError(
                "Metric temporal reference does not match the approved registry."
            )

        if self.method_version != expected_method:
            raise ValueError("Metric method version is not approved for V2A.")

        if self.value is not None:
            if self.metric_id == "UM-TIM-001" and self.value <= 0:
                raise ValueError("Execution duration must be positive.")

            if self.metric_id.startswith("UM-ANG-") and not 0 <= self.value <= 180:
                raise ValueError("Projected angle must be between 0 and 180 degrees.")

        if self.metric_id == "UM-TIM-001":
            if self.confidence.available:
                raise ValueError(
                    "Reviewed duration cannot claim model landmark confidence."
                )
            if self.overlay:
                raise ValueError("Execution duration cannot contain geometry.")
        elif self.status != MetricStatus.WITHHELD:
            expected_geometry = (
                ("line", "angle_label")
                if self.metric_id == "UM-ANG-001"
                else ("polyline", "angle_label")
            )
            actual_geometry = tuple(
                primitive.kind for primitive in self.overlay
            )
            if actual_geometry != expected_geometry:
                raise ValueError(
                    "Available projected angles require approved blue geometry."
                )

            expected_primary_points = (
                2 if self.metric_id == "UM-ANG-001" else 3
            )
            if len(self.overlay[0].points) != expected_primary_points:
                raise ValueError(
                    "Projected angle geometry has an unexpected point count."
                )

            if (
                self.status == MetricStatus.REPORTABLE
                and not self.confidence.available
            ):
                raise ValueError(
                    "Reportable projected angles require landmark visibility "
                    "evidence."
                )

        return self


class MultiPersonEvidenceStatus(str, Enum):
    NOT_REQUIRED = "not_required"
    REVIEW_REQUIRED = "review_required"
    INSUFFICIENT = "insufficient"


class SingleAttemptCapabilities(BaseModel):
    human_confirmed_tori: Literal[True] = True
    human_confirmed_support_leg: Literal[True] = True
    automatic_tori_uke_identity: Literal[False] = False
    automatic_phase_detection: Literal[False] = False
    three_dimensional_reconstruction: Literal[False] = False
    force_torque_power: Literal[False] = False
    normative_coaching: Literal[False] = False

    multi_person_evidence_status: MultiPersonEvidenceStatus = (
        MultiPersonEvidenceStatus.INSUFFICIENT
    )
    multi_person_interaction_metrics_reportable: Literal[False] = False


class SingleAttemptAnalysisResponse(BaseModel):
    schema_version: Literal[SCHEMA_VERSION] = SCHEMA_VERSION
    analysis_variant: Literal[ANALYSIS_VARIANT] = ANALYSIS_VARIANT
    analysis_id: str = Field(min_length=1)
    status: Literal["completed"] = "completed"
    analysis_mode: Literal["single_camera_2d_single_attempt"] = (
        "single_camera_2d_single_attempt"
    )
    scientific_level: Literal["level_1"] = "level_1"
    technique: TechniqueReference
    video_id: str = Field(min_length=1)
    camera_view: Literal[
        "side",
        "front",
        "rear",
        "forty_five_degrees",
        "unknown",
    ]
    attempt: AttemptBoundarySelection
    subject: SubjectSelection
    support_leg: SupportLegSelection
    attacking_leg: AttackingLegSelection | None = None
    angle_frame: AnalysisFrameSelection
    camera_suitability: CameraSuitabilityReview
    metrics: list[MetricResult]
    capabilities: SingleAttemptCapabilities = Field(
        default_factory=SingleAttemptCapabilities
    )
    limitations: list[AnalysisLimitation]

    @model_validator(mode="after")
    def validate_metric_set(self) -> "SingleAttemptAnalysisResponse":
        expected = {
            "UM-TIM-001",
            "UM-ANG-001",
            "UM-ANG-002",
            "UM-ANG-003",
        }
        actual = [metric.metric_id for metric in self.metrics]

        if len(actual) != len(expected) or set(actual) != expected:
            raise ValueError("V2A must contain each approved metric exactly once.")

        if self.technique.id != "uchi-mata":
            raise ValueError("V2A response currently supports only Uchi Mata.")

        metric_by_id = {metric.metric_id: metric for metric in self.metrics}
        duration_reference = metric_by_id["UM-TIM-001"].temporal_reference
        if (
            duration_reference.start != self.attempt.start
            or duration_reference.end != self.attempt.end
        ):
            raise ValueError(
                "Duration temporal reference must match reviewed boundaries."
            )

        for metric_id in (
            "UM-ANG-001",
            "UM-ANG-002",
            "UM-ANG-003",
        ):
            metric = metric_by_id[metric_id]
            if metric.temporal_reference.frame != self.angle_frame.frame:
                raise ValueError(
                    "Projected metric frame must match the reviewed angle frame."
                )

            if (
                not self.camera_suitability.permits_reportable_angles
                and metric.status == MetricStatus.REPORTABLE
            ):
                raise ValueError(
                    "Unconfirmed camera suitability cannot be reportable."
                )

        attacking_metric = metric_by_id["UM-ANG-003"]
        if self.attacking_leg is None:
            if attacking_metric.status != MetricStatus.WITHHELD:
                raise ValueError(
                    "UM-ANG-003 must be withheld when attacking leg "
                    "is not human-confirmed."
                )

        required_limitation_codes = {
            "human_role_confirmation_required",
            "human_support_leg_confirmation_required",
            "automatic_phase_detection_not_available",
            "projected_single_camera_geometry",
            "camera_perspective_affects_angles",
            "kinetics_not_available",
            "descriptive_only",
        }
        limitation_codes = {
            limitation.code
            for limitation in self.limitations
            if limitation.affects_interpretation
        }
        if not required_limitation_codes.issubset(limitation_codes):
            raise ValueError("V2A scientific limitations are incomplete.")

        return self


SINGLE_ATTEMPT_LIMITATIONS = [
    AnalysisLimitation(
        code="human_role_confirmation_required",
        message=(
            "Tori is selected by a human reviewer; the model does not infer "
            "Tori or Uke identity."
        ),
    ),
    AnalysisLimitation(
        code="human_support_leg_confirmation_required",
        message="The support leg is selected by a human reviewer.",
    ),
    AnalysisLimitation(
        code="automatic_phase_detection_not_available",
        message=(
            "Kuzushi, Tsukuri and Kake are not automatically detected in V2A."
        ),
    ),
    AnalysisLimitation(
        code="projected_single_camera_geometry",
        message=(
            "Reported angles are image-plane projections and are not true "
            "anatomical 3D angles."
        ),
    ),
    AnalysisLimitation(
        code="camera_perspective_affects_angles",
        message=(
            "Camera roll, perspective, occlusion and out-of-plane motion can "
            "change projected angles."
        ),
    ),
    AnalysisLimitation(
        code="kinetics_not_available",
        message=(
            "No force, torque, moment, power, load or OpenSim result is "
            "produced from this single-camera analysis."
        ),
    ),
    AnalysisLimitation(
        code="descriptive_only",
        message=(
            "V2A describes selected 2D observations and does not judge "
            "technique quality or prescribe an ideal value."
        ),
    ),
]
