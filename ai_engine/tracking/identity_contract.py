from __future__ import annotations

from dataclasses import dataclass
import math
from typing import Protocol, Sequence


MODEL_ESTIMATED = "model-estimated"
AI_INFERRED = "AI-inferred"
ACTIVE_TRACK_STATUSES = frozenset(
    {"tentative", "confirmed", "reappeared"}
)
INACTIVE_TRACK_STATUSES = frozenset({"lost", "terminated"})
ASSOCIATION_DECISION_STATUSES = frozenset(
    {"associated", "review_required", "withheld"}
)
TRACK_EVENT_TYPES = frozenset(
    {
        "crossing",
        "occluded",
        "disappeared",
        "reappeared",
        "detection_order_changed",
    }
)
UNCERTAINTY_REASONS = frozenset(
    {
        "association_confidence_unavailable",
        "ambiguous_overlap",
        "crossing",
        "detection_order_changed",
        "missing_detection",
        "occlusion",
        "reappearance_not_verified",
    }
)
ANNOTATED_TRACK_EVENT_TAGS = frozenset(
    {
        "crossing",
        "detection_order_changed",
        "disappeared",
        "occlusion",
        "reappeared",
        "track_terminated",
    }
)


def _validate_neutral_track_id(track_id: str) -> None:
    prefix = "Track "
    label = track_id.removeprefix(prefix)

    if (
        not track_id.startswith(prefix)
        or not label
        or not label.isascii()
        or not label.isalpha()
        or not label.isupper()
    ):
        raise ValueError("Only role-neutral Track labels are allowed.")

    if label in {"TORI", "UKE"}:
        raise ValueError("Tori/Uke roles require a separate validated classifier.")


def neutral_track_label(index: int) -> str:
    """Return role-neutral labels such as Track A, Track B, ..., Track AA."""

    if index < 0:
        raise ValueError("Track index must be greater than or equal to zero.")

    value = index + 1
    letters = ""

    while value:
        value, remainder = divmod(value - 1, 26)
        letters = chr(ord("A") + remainder) + letters

    return f"Track {letters}"


@dataclass(frozen=True)
class BoundingBox2D:
    left: float
    top: float
    right: float
    bottom: float

    def __post_init__(self) -> None:
        if not all(
            math.isfinite(value)
            for value in (self.left, self.top, self.right, self.bottom)
        ):
            raise ValueError("Bounding box coordinates must be finite.")
        if self.right <= self.left or self.bottom <= self.top:
            raise ValueError("Bounding box must have positive width and height.")


@dataclass(frozen=True)
class PoseDetection2D:
    """One frame-local pose detection; it carries no athlete identity."""

    detection_index: int
    bounding_box: BoundingBox2D
    keypoints: tuple[tuple[float, float], ...]
    keypoint_scores: tuple[float, ...] | None
    provenance: str = MODEL_ESTIMATED

    def __post_init__(self) -> None:
        if self.detection_index < 0:
            raise ValueError("Detection index cannot be negative.")

        if self.provenance != MODEL_ESTIMATED:
            raise ValueError("2D pose detections must remain model-estimated.")

        if (
            self.keypoint_scores is not None
            and len(self.keypoint_scores) != len(self.keypoints)
        ):
            raise ValueError("Every keypoint must have one matching score.")

        if any(
            len(keypoint) != 2
            or not all(math.isfinite(value) for value in keypoint)
            for keypoint in self.keypoints
        ):
            raise ValueError("Every keypoint must contain finite 2D geometry.")

        if self.keypoint_scores is not None and any(
            not math.isfinite(score) or not 0.0 <= score <= 1.0
            for score in self.keypoint_scores
        ):
            raise ValueError("Keypoint scores must be finite values from 0 to 1.")


@dataclass(frozen=True)
class PoseFrameObservation:
    """A timestamped set of role-neutral, frame-local pose detections."""

    frame_index: int
    timestamp_ms: int
    detections: tuple[PoseDetection2D, ...]
    provenance: str = MODEL_ESTIMATED

    def __post_init__(self) -> None:
        if self.frame_index < 0 or self.timestamp_ms < 0:
            raise ValueError("Frame index and timestamp cannot be negative.")

        if self.provenance != MODEL_ESTIMATED:
            raise ValueError("Pose frame observations must be model-estimated.")

        detection_indices = [
            detection.detection_index for detection in self.detections
        ]
        if len(set(detection_indices)) != len(detection_indices):
            raise ValueError("Detection indices must be unique within a frame.")


@dataclass(frozen=True)
class TrackAssociationDecision:
    """Fail-closed association result, separate from athlete roles."""

    frame_index: int
    timestamp_ms: int
    detection_index: int | None
    track_id: str | None
    status: str
    association_confidence: float | None
    uncertainty_reasons: tuple[str, ...] = ()
    provenance: str = AI_INFERRED

    def __post_init__(self) -> None:
        if self.frame_index < 0 or self.timestamp_ms < 0:
            raise ValueError("Frame index and timestamp cannot be negative.")

        if self.status not in ASSOCIATION_DECISION_STATUSES:
            raise ValueError("Unknown association decision status.")

        if self.provenance != AI_INFERRED:
            raise ValueError("Track association must remain AI-inferred.")

        if self.detection_index is not None and self.detection_index < 0:
            raise ValueError("Detection index cannot be negative.")

        if self.track_id is not None:
            _validate_neutral_track_id(self.track_id)

        if (
            self.association_confidence is not None
            and (
                not math.isfinite(self.association_confidence)
                or not 0.0 <= self.association_confidence <= 1.0
            )
        ):
            raise ValueError("Association confidence must be between 0 and 1.")

        unknown_reasons = set(self.uncertainty_reasons) - UNCERTAINTY_REASONS
        if unknown_reasons:
            raise ValueError("Unknown association uncertainty reason.")

        if len(set(self.uncertainty_reasons)) != len(self.uncertainty_reasons):
            raise ValueError("Uncertainty reasons must be unique.")

        if self.status == "associated":
            if self.track_id is None or self.detection_index is None:
                raise ValueError(
                    "Associated observations require track and detection IDs."
                )
            if self.association_confidence is None and (
                "association_confidence_unavailable"
                not in self.uncertainty_reasons
            ):
                raise ValueError(
                    "Missing confidence must be stated explicitly."
                )
        elif not self.uncertainty_reasons:
            raise ValueError(
                "Review-required or withheld decisions need uncertainty reasons."
            )

        if self.status == "withheld" and any(
            value is not None
            for value in (
                self.detection_index,
                self.track_id,
                self.association_confidence,
            )
        ):
            raise ValueError("Withheld associations cannot expose an identity.")


@dataclass(frozen=True)
class NeutralTrackEvent:
    frame_index: int
    timestamp_ms: int
    track_id: str
    event_type: str
    notes: str | None = None
    provenance: str = AI_INFERRED

    def __post_init__(self) -> None:
        if self.frame_index < 0 or self.timestamp_ms < 0:
            raise ValueError("Frame index and timestamp cannot be negative.")

        _validate_neutral_track_id(self.track_id)

        if self.event_type not in TRACK_EVENT_TYPES:
            raise ValueError("Unknown neutral tracking event type.")

        if self.provenance != AI_INFERRED:
            raise ValueError("Neutral tracking events must remain AI-inferred.")


@dataclass(frozen=True)
class HumanRoleConfirmation:
    """Manual role gate; a neutral tracker cannot produce this assertion."""

    track_id: str
    role: str
    confirmation_source: str = "human-confirmed"
    reviewer_notes: str | None = None

    def __post_init__(self) -> None:
        _validate_neutral_track_id(self.track_id)

        if self.role not in {"Tori", "Uke"}:
            raise ValueError("Only the reviewed Judo roles are supported.")

        if self.confirmation_source != "human-confirmed":
            raise ValueError("Tori/Uke roles require human confirmation.")


@dataclass(frozen=True)
class NeutralTrackObservation:
    """AI-inferred association to a neutral track, never a Tori/Uke role."""

    track_id: str
    detection: PoseDetection2D | None
    association_confidence: float | None
    age_frames: int
    missed_frames: int
    status: str
    provenance: str = AI_INFERRED

    def __post_init__(self) -> None:
        _validate_neutral_track_id(self.track_id)

        if self.provenance != AI_INFERRED:
            raise ValueError("Identity association must remain AI-inferred.")

        if (
            self.association_confidence is not None
            and (
                not math.isfinite(self.association_confidence)
                or not 0.0 <= self.association_confidence <= 1.0
            )
        ):
            raise ValueError("Association confidence must be between 0 and 1.")

        if self.age_frames < 1 or self.missed_frames < 0:
            raise ValueError("Track age/missed-frame counts are invalid.")

        valid_statuses = ACTIVE_TRACK_STATUSES | INACTIVE_TRACK_STATUSES

        if self.status not in valid_statuses:
            raise ValueError("Track status is not part of the approved contract.")

        if self.status in ACTIVE_TRACK_STATUSES and self.detection is None:
            raise ValueError("An active track observation requires a detection.")

        if self.status in INACTIVE_TRACK_STATUSES and self.detection is not None:
            raise ValueError("A lost or terminated track cannot claim a detection.")

        if self.detection is None and self.association_confidence is not None:
            raise ValueError("A track without a detection cannot claim confidence.")

        if self.status in INACTIVE_TRACK_STATUSES and self.missed_frames < 1:
            raise ValueError("Lost or terminated tracks require missed frames.")


class NeutralIdentityTracker(Protocol):
    """Interface only; no production tracker is approved by this contract."""

    def reset(self) -> None: ...

    def update(
        self,
        detections: Sequence[PoseDetection2D],
        *,
        frame_index: int,
        timestamp_ms: int,
    ) -> tuple[NeutralTrackObservation, ...]: ...


@dataclass(frozen=True)
class AnnotatedTrackAssignment:
    """Evaluation-only reference row, never a user-facing identity result."""

    subject_reference_id: str
    frame_index: int
    timestamp_ms: int
    visible: bool
    predicted_track_id: str | None
    event_tags: tuple[str, ...] = ()
    association_confidence: float | None = None
    detection_index: int | None = None
    reference_source: str = "human-reviewed"
    prediction_provenance: str = AI_INFERRED

    def __post_init__(self) -> None:
        normalized_subject = self.subject_reference_id.strip()
        if not normalized_subject:
            raise ValueError("Subject reference ID must not be empty.")

        if normalized_subject.upper() in {"TORI", "UKE"}:
            raise ValueError("Evaluation references must remain role-neutral.")
        object.__setattr__(self, "subject_reference_id", normalized_subject)

        if self.reference_source != "human-reviewed":
            raise ValueError("Tracking references must be human-reviewed.")
        if self.prediction_provenance != AI_INFERRED:
            raise ValueError("Predicted track assignments must be AI-inferred.")

        if self.frame_index < 0 or self.timestamp_ms < 0:
            raise ValueError("Frame index and timestamp cannot be negative.")

        unknown_tags = set(self.event_tags) - ANNOTATED_TRACK_EVENT_TAGS
        if unknown_tags:
            raise ValueError("Unknown annotated tracking event tag.")
        if len(set(self.event_tags)) != len(self.event_tags):
            raise ValueError("Annotated tracking event tags must be unique.")

        if not self.visible and self.predicted_track_id is not None:
            raise ValueError("An invisible subject cannot have an assigned track.")

        if self.predicted_track_id is not None:
            _validate_neutral_track_id(self.predicted_track_id)

        if self.predicted_track_id is None and self.association_confidence is not None:
            raise ValueError("An unassigned observation cannot have confidence.")

        if self.predicted_track_id is None and self.detection_index is not None:
            raise ValueError(
                "An unassigned subject cannot claim a frame-local detection."
            )

        if (
            self.association_confidence is not None
            and (
                not math.isfinite(self.association_confidence)
                or not 0.0 <= self.association_confidence <= 1.0
            )
        ):
            raise ValueError("Association confidence must be between 0 and 1.")

        if self.detection_index is not None and self.detection_index < 0:
            raise ValueError("Detection index cannot be negative.")

        if self.detection_index is not None and not self.visible:
            raise ValueError("An invisible subject cannot have a detection index.")

        if "track_terminated" in self.event_tags and self.visible:
            raise ValueError(
                "Track termination must be annotated on an absent frame."
            )

        if (
            {"crossing", "occlusion", "reappeared"} & set(self.event_tags)
            and not self.visible
        ):
            raise ValueError(
                "Crossing, occlusion and reappearance require visibility."
            )

        if "disappeared" in self.event_tags and self.visible:
            raise ValueError("Disappearance requires an absent subject row.")

        if (
            "detection_order_changed" in self.event_tags
            and self.detection_index is None
        ):
            raise ValueError(
                "Detection-order change requires a detection index."
            )


@dataclass(frozen=True)
class TrackingEvaluation:
    annotated_frames: int
    visible_observations: int
    assigned_observations: int
    assignment_coverage: float
    identity_switches: int
    crossing_identity_switches: int
    reappearance_events: int
    reappearance_preserved: int
    reappearance_changed: int
    reappearance_unverified: int
    confidence_observations: int
    confidence_coverage: float
    mean_association_confidence: float | None
    single_visible_subject_frames: int
    multiple_visible_subject_frames: int
    detection_order_changes: int
    detection_order_change_identity_switches: int
    track_termination_events: int
    post_termination_reinitializations: int
    track_assignment_collision_frames: int
    track_assignment_collisions: int
    detection_assignment_collision_frames: int
    detection_assignment_collisions: int
    reference_source: str = "human-reviewed"
    prediction_provenance: str = AI_INFERRED
    interpretation: str = "role_neutral_tracking_evaluation_only"
    tracking_accuracy_claimed: bool = False


def evaluate_tracking_assignments(
    assignments: Sequence[AnnotatedTrackAssignment],
) -> TrackingEvaluation:
    """Evaluate continuity from externally annotated synthetic/lab references."""

    grouped: dict[str, list[AnnotatedTrackAssignment]] = {}
    timestamp_by_frame_index: dict[int, int] = {}
    frame_index_by_timestamp: dict[int, int] = {}
    tracks_by_frame: dict[tuple[int, int, str], set[str]] = {}
    detections_by_frame: dict[tuple[int, int, int], set[str]] = {}

    for assignment in assignments:
        known_timestamp = timestamp_by_frame_index.setdefault(
            assignment.frame_index,
            assignment.timestamp_ms,
        )
        if known_timestamp != assignment.timestamp_ms:
            raise ValueError(
                "One frame index cannot map to multiple timestamps."
            )
        known_frame_index = frame_index_by_timestamp.setdefault(
            assignment.timestamp_ms,
            assignment.frame_index,
        )
        if known_frame_index != assignment.frame_index:
            raise ValueError(
                "One timestamp cannot map to multiple frame indices."
            )

        grouped.setdefault(assignment.subject_reference_id, []).append(
            assignment
        )
        if assignment.visible and assignment.predicted_track_id is not None:
            tracks_by_frame.setdefault(
                (
                    assignment.frame_index,
                    assignment.timestamp_ms,
                    assignment.predicted_track_id,
                ),
                set(),
            ).add(assignment.subject_reference_id)
        if assignment.visible and assignment.detection_index is not None:
            detections_by_frame.setdefault(
                (
                    assignment.frame_index,
                    assignment.timestamp_ms,
                    assignment.detection_index,
                ),
                set(),
            ).add(assignment.subject_reference_id)

    visible_observations = 0
    assigned_observations = 0
    identity_switches = 0
    crossing_identity_switches = 0
    reappearance_events = 0
    reappearance_preserved = 0
    reappearance_changed = 0
    reappearance_unverified = 0
    confidence_values: list[float] = []
    detection_order_changes = 0
    detection_order_change_identity_switches = 0
    track_termination_events = 0
    post_termination_reinitializations = 0
    visible_subjects_by_frame: dict[tuple[int, int], set[str]] = {}

    for assignment in assignments:
        if assignment.visible:
            visible_subjects_by_frame.setdefault(
                (assignment.frame_index, assignment.timestamp_ms),
                set(),
            ).add(assignment.subject_reference_id)

    for subject_rows in grouped.values():
        ordered_rows = sorted(
            subject_rows,
            key=lambda row: (row.frame_index, row.timestamp_ms),
        )
        previous_frame_index: int | None = None
        previous_timestamp_ms: int | None = None
        previous_track_id: str | None = None
        previous_detection_index: int | None = None
        absence_since_assignment = False
        terminated_since_assignment = False

        for row in ordered_rows:
            if (
                previous_frame_index is not None
                and row.frame_index <= previous_frame_index
            ):
                raise ValueError(
                    "Each subject must have unique, increasing frame indices."
                )

            if (
                previous_timestamp_ms is not None
                and row.timestamp_ms <= previous_timestamp_ms
            ):
                raise ValueError(
                    "Each subject must have unique, increasing timestamps."
                )

            previous_frame_index = row.frame_index
            previous_timestamp_ms = row.timestamp_ms

            if "track_terminated" in row.event_tags:
                track_termination_events += 1
                terminated_since_assignment = previous_track_id is not None
                absence_since_assignment = previous_track_id is not None

            if not row.visible:
                if previous_track_id is not None:
                    absence_since_assignment = True
                continue

            visible_observations += 1

            if row.predicted_track_id is None:
                if previous_track_id is not None:
                    absence_since_assignment = True
                continue

            assigned_observations += 1

            if row.association_confidence is not None:
                confidence_values.append(row.association_confidence)

            detection_order_changed = (
                previous_detection_index is not None
                and row.detection_index is not None
                and row.detection_index != previous_detection_index
            )

            if detection_order_changed:
                detection_order_changes += 1

            if absence_since_assignment:
                reappearance_events += 1

                if terminated_since_assignment:
                    reappearance_unverified += 1
                    post_termination_reinitializations += 1
                elif previous_track_id is None:
                    reappearance_unverified += 1
                elif row.predicted_track_id == previous_track_id:
                    reappearance_preserved += 1
                else:
                    reappearance_changed += 1

                absence_since_assignment = False

            identity_changed = (
                previous_track_id is not None
                and row.predicted_track_id != previous_track_id
            )

            if (
                identity_changed
                and not terminated_since_assignment
            ):
                identity_switches += 1

                if "crossing" in row.event_tags:
                    crossing_identity_switches += 1

                if detection_order_changed:
                    detection_order_change_identity_switches += 1

            previous_track_id = row.predicted_track_id
            previous_detection_index = row.detection_index
            terminated_since_assignment = False

    assignment_coverage = (
        assigned_observations / visible_observations
        if visible_observations
        else 0.0
    )
    confidence_coverage = (
        len(confidence_values) / assigned_observations
        if assigned_observations
        else 0.0
    )
    single_visible_subject_frames = sum(
        len(subjects) == 1 for subjects in visible_subjects_by_frame.values()
    )
    multiple_visible_subject_frames = sum(
        len(subjects) >= 2 for subjects in visible_subjects_by_frame.values()
    )
    track_collision_groups = [
        (key, subjects)
        for key, subjects in tracks_by_frame.items()
        if len(subjects) > 1
    ]
    detection_collision_groups = [
        (key, subjects)
        for key, subjects in detections_by_frame.items()
        if len(subjects) > 1
    ]

    return TrackingEvaluation(
        annotated_frames=len(timestamp_by_frame_index),
        visible_observations=visible_observations,
        assigned_observations=assigned_observations,
        assignment_coverage=assignment_coverage,
        identity_switches=identity_switches,
        crossing_identity_switches=crossing_identity_switches,
        reappearance_events=reappearance_events,
        reappearance_preserved=reappearance_preserved,
        reappearance_changed=reappearance_changed,
        reappearance_unverified=reappearance_unverified,
        confidence_observations=len(confidence_values),
        confidence_coverage=confidence_coverage,
        mean_association_confidence=(
            sum(confidence_values) / len(confidence_values)
            if confidence_values
            else None
        ),
        single_visible_subject_frames=single_visible_subject_frames,
        multiple_visible_subject_frames=multiple_visible_subject_frames,
        detection_order_changes=detection_order_changes,
        detection_order_change_identity_switches=(
            detection_order_change_identity_switches
        ),
        track_termination_events=track_termination_events,
        post_termination_reinitializations=(
            post_termination_reinitializations
        ),
        track_assignment_collision_frames=len(
            {key[:2] for key, _ in track_collision_groups}
        ),
        track_assignment_collisions=sum(
            len(subjects) - 1 for _, subjects in track_collision_groups
        ),
        detection_assignment_collision_frames=len(
            {key[:2] for key, _ in detection_collision_groups}
        ),
        detection_assignment_collisions=sum(
            len(subjects) - 1
            for _, subjects in detection_collision_groups
        ),
    )
