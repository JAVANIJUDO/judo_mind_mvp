"""Evaluation-only neutral tracking with RTMLib's greedy IoU primitive.

This adapter is an experimental baseline, not a production tracker. It consumes
existing :class:`PoseDetection2D` values and never invokes RTMLib model
inference. The RTMLib default IoU threshold is retained only as an engineering
baseline; it is not a scientifically validated association threshold.

The adapter deliberately gives up identity continuity when the one-to-one IoU
association is ambiguous, detections collapse during a multi-person interval,
or a detection appears after any track was lost. It never emits Tori/Uke roles
and never converts IoU into association confidence.
"""

from __future__ import annotations

from dataclasses import dataclass
import math
from typing import Sequence

from rtmlib.tools.solution.pose_tracker import compute_iou

from ai_engine.tracking.identity_contract import (
    BoundingBox2D,
    NeutralTrackEvent,
    NeutralTrackObservation,
    PoseDetection2D,
    TrackAssociationDecision,
    neutral_track_label,
)


RTMLIB_EXPERIMENTAL_IOU_THRESHOLD = 0.3


@dataclass
class _TrackState:
    track_id: str
    bounding_box: BoundingBox2D
    last_detection_index: int
    age_frames: int = 1
    missed_frames: int = 0
    active: bool = True
    current_detection: PoseDetection2D | None = None


class ExperimentalRTMLibIoUTracker:
    """Fail-closed, role-neutral adapter for synthetic evaluation only."""

    evaluation_only = True
    production_approved = False
    association_confidence_validated = False

    def __init__(
        self,
        *,
        iou_threshold: float = RTMLIB_EXPERIMENTAL_IOU_THRESHOLD,
    ) -> None:
        if (
            not math.isfinite(iou_threshold)
            or iou_threshold < 0.0
            or iou_threshold > 1.0
        ):
            raise ValueError("IoU threshold must be finite and between 0 and 1.")

        self.iou_threshold = iou_threshold
        self.reset()

    def reset(self) -> None:
        self._tracks: list[_TrackState] = []
        self._next_track_index = 0
        self._last_frame_index: int | None = None
        self._last_timestamp_ms: int | None = None
        self.last_decisions: tuple[TrackAssociationDecision, ...] = ()
        self.last_events: tuple[NeutralTrackEvent, ...] = ()

    def update(
        self,
        detections: Sequence[PoseDetection2D],
        *,
        frame_index: int,
        timestamp_ms: int,
    ) -> tuple[NeutralTrackObservation, ...]:
        self._validate_frame(detections, frame_index, timestamp_ms)
        ordered_detections = tuple(detections)
        decisions: list[TrackAssociationDecision] = []
        events: list[NeutralTrackEvent] = []

        for track in self._tracks:
            track.current_detection = None
            if not track.active:
                track.age_frames += 1
                track.missed_frames += 1

        active_tracks = [track for track in self._tracks if track.active]

        if (
            len(active_tracks) > 1
            and 0 < len(ordered_detections) < len(active_tracks)
        ):
            self._fail_closed_occlusion(
                active_tracks,
                ordered_detections,
                frame_index,
                timestamp_ms,
                decisions,
                events,
            )
        else:
            self._associate_unambiguous(
                active_tracks,
                ordered_detections,
                frame_index,
                timestamp_ms,
                decisions,
                events,
            )

        self._last_frame_index = frame_index
        self._last_timestamp_ms = timestamp_ms
        self.last_decisions = tuple(decisions)
        self.last_events = tuple(events)
        return tuple(self._observation(track) for track in self._tracks)

    def _associate_unambiguous(
        self,
        active_tracks: Sequence[_TrackState],
        detections: Sequence[PoseDetection2D],
        frame_index: int,
        timestamp_ms: int,
        decisions: list[TrackAssociationDecision],
        events: list[NeutralTrackEvent],
    ) -> None:
        candidates_by_track: dict[str, list[tuple[int, float]]] = {
            track.track_id: [] for track in active_tracks
        }
        candidates_by_detection: dict[int, list[tuple[str, float]]] = {
            detection.detection_index: [] for detection in detections
        }

        track_by_id = {track.track_id: track for track in active_tracks}
        detection_by_index = {
            detection.detection_index: detection for detection in detections
        }

        for track in active_tracks:
            for detection in detections:
                overlap = self._iou(track.bounding_box, detection.bounding_box)
                if overlap > self.iou_threshold:
                    candidates_by_track[track.track_id].append(
                        (detection.detection_index, overlap)
                    )
                    candidates_by_detection[detection.detection_index].append(
                        (track.track_id, overlap)
                    )

        ambiguous_tracks = {
            track_id
            for track_id, candidates in candidates_by_track.items()
            if len(candidates) > 1
        }
        ambiguous_detections = {
            detection_index
            for detection_index, candidates in candidates_by_detection.items()
            if len(candidates) > 1
        }
        for track_id, candidates in candidates_by_track.items():
            if any(
                detection_index in ambiguous_detections
                for detection_index, _ in candidates
            ):
                ambiguous_tracks.add(track_id)
        for detection_index, candidates in candidates_by_detection.items():
            if any(track_id in ambiguous_tracks for track_id, _ in candidates):
                ambiguous_detections.add(detection_index)

        matched_track_ids: set[str] = set()
        matched_detection_indices: set[int] = set()
        candidate_edges = sorted(
            (
                (overlap, track_id, detection_index)
                for track_id, candidates in candidates_by_track.items()
                for detection_index, overlap in candidates
                if track_id not in ambiguous_tracks
                and detection_index not in ambiguous_detections
            ),
            key=lambda edge: (-edge[0], edge[1], edge[2]),
        )

        for _, track_id, detection_index in candidate_edges:
            if (
                track_id in matched_track_ids
                or detection_index in matched_detection_indices
            ):
                continue

            track = track_by_id[track_id]
            detection = detection_by_index[detection_index]
            self._confirm_match(
                track,
                detection,
                frame_index,
                timestamp_ms,
                decisions,
                events,
            )
            matched_track_ids.add(track_id)
            matched_detection_indices.add(detection_index)

        for detection_index in sorted(ambiguous_detections):
            decisions.append(
                TrackAssociationDecision(
                    frame_index=frame_index,
                    timestamp_ms=timestamp_ms,
                    detection_index=detection_index,
                    track_id=None,
                    status="review_required",
                    association_confidence=None,
                    uncertainty_reasons=(
                        "association_confidence_unavailable",
                        "ambiguous_overlap",
                        "crossing",
                    ),
                )
            )

        for track in active_tracks:
            if track.track_id in matched_track_ids:
                continue

            if track.track_id in ambiguous_tracks:
                self._mark_lost(
                    track,
                    frame_index,
                    timestamp_ms,
                    decisions,
                    events,
                    reasons=(
                        "association_confidence_unavailable",
                        "ambiguous_overlap",
                        "crossing",
                    ),
                    event_type="crossing",
                )
            else:
                self._mark_lost(
                    track,
                    frame_index,
                    timestamp_ms,
                    decisions,
                    events,
                    reasons=(
                        "association_confidence_unavailable",
                        "missing_detection",
                    ),
                    event_type="disappeared",
                )

        for detection in detections:
            if (
                detection.detection_index in matched_detection_indices
                or detection.detection_index in ambiguous_detections
            ):
                continue
            self._create_track(
                detection,
                frame_index,
                timestamp_ms,
                decisions,
                reappearance_unverified=any(
                    not track.active for track in self._tracks
                ),
            )

    def _fail_closed_occlusion(
        self,
        active_tracks: Sequence[_TrackState],
        detections: Sequence[PoseDetection2D],
        frame_index: int,
        timestamp_ms: int,
        decisions: list[TrackAssociationDecision],
        events: list[NeutralTrackEvent],
    ) -> None:
        for detection in detections:
            decisions.append(
                TrackAssociationDecision(
                    frame_index=frame_index,
                    timestamp_ms=timestamp_ms,
                    detection_index=detection.detection_index,
                    track_id=None,
                    status="review_required",
                    association_confidence=None,
                    uncertainty_reasons=(
                        "association_confidence_unavailable",
                        "ambiguous_overlap",
                        "occlusion",
                    ),
                )
            )

        for track in active_tracks:
            self._mark_lost(
                track,
                frame_index,
                timestamp_ms,
                decisions,
                events,
                reasons=(
                    "association_confidence_unavailable",
                    "ambiguous_overlap",
                    "occlusion",
                ),
                event_type="occluded",
            )

    def _confirm_match(
        self,
        track: _TrackState,
        detection: PoseDetection2D,
        frame_index: int,
        timestamp_ms: int,
        decisions: list[TrackAssociationDecision],
        events: list[NeutralTrackEvent],
    ) -> None:
        detection_order_changed = (
            detection.detection_index != track.last_detection_index
        )
        track.bounding_box = detection.bounding_box
        track.last_detection_index = detection.detection_index
        track.age_frames += 1
        track.missed_frames = 0
        track.current_detection = detection

        uncertainty_reasons = ["association_confidence_unavailable"]
        if detection_order_changed:
            uncertainty_reasons.append("detection_order_changed")
            events.append(
                NeutralTrackEvent(
                    frame_index=frame_index,
                    timestamp_ms=timestamp_ms,
                    track_id=track.track_id,
                    event_type="detection_order_changed",
                    notes=(
                        "Frame-local detection order changed; neutral track "
                        "continuity came only from unambiguous IoU."
                    ),
                )
            )

        decisions.append(
            TrackAssociationDecision(
                frame_index=frame_index,
                timestamp_ms=timestamp_ms,
                detection_index=detection.detection_index,
                track_id=track.track_id,
                status="associated",
                association_confidence=None,
                uncertainty_reasons=tuple(uncertainty_reasons),
            )
        )

    def _create_track(
        self,
        detection: PoseDetection2D,
        frame_index: int,
        timestamp_ms: int,
        decisions: list[TrackAssociationDecision],
        *,
        reappearance_unverified: bool,
    ) -> None:
        track = _TrackState(
            track_id=neutral_track_label(self._next_track_index),
            bounding_box=detection.bounding_box,
            last_detection_index=detection.detection_index,
            current_detection=detection,
        )
        self._next_track_index += 1
        self._tracks.append(track)

        reasons = ["association_confidence_unavailable"]
        status = "associated"
        if reappearance_unverified:
            reasons.append("reappearance_not_verified")
            status = "review_required"

        decisions.append(
            TrackAssociationDecision(
                frame_index=frame_index,
                timestamp_ms=timestamp_ms,
                detection_index=detection.detection_index,
                track_id=track.track_id,
                status=status,
                association_confidence=None,
                uncertainty_reasons=tuple(reasons),
            )
        )

    def _mark_lost(
        self,
        track: _TrackState,
        frame_index: int,
        timestamp_ms: int,
        decisions: list[TrackAssociationDecision],
        events: list[NeutralTrackEvent],
        *,
        reasons: tuple[str, ...],
        event_type: str,
    ) -> None:
        track.active = False
        track.current_detection = None
        track.age_frames += 1
        track.missed_frames = 1
        decisions.append(
            TrackAssociationDecision(
                frame_index=frame_index,
                timestamp_ms=timestamp_ms,
                detection_index=None,
                track_id=track.track_id,
                status="review_required",
                association_confidence=None,
                uncertainty_reasons=reasons,
            )
        )
        events.append(
            NeutralTrackEvent(
                frame_index=frame_index,
                timestamp_ms=timestamp_ms,
                track_id=track.track_id,
                event_type=event_type,
                notes="Identity continuity was not asserted by the baseline.",
            )
        )

    def _observation(self, track: _TrackState) -> NeutralTrackObservation:
        if track.active:
            status = "tentative" if track.age_frames == 1 else "confirmed"
        else:
            status = "lost"

        return NeutralTrackObservation(
            track_id=track.track_id,
            detection=track.current_detection,
            association_confidence=None,
            age_frames=track.age_frames,
            missed_frames=track.missed_frames,
            status=status,
        )

    def _validate_frame(
        self,
        detections: Sequence[PoseDetection2D],
        frame_index: int,
        timestamp_ms: int,
    ) -> None:
        if frame_index < 0 or timestamp_ms < 0:
            raise ValueError("Frame index and timestamp cannot be negative.")
        if self._last_frame_index is not None and frame_index <= self._last_frame_index:
            raise ValueError("Frame indices must increase strictly.")
        if (
            self._last_timestamp_ms is not None
            and timestamp_ms <= self._last_timestamp_ms
        ):
            raise ValueError("Timestamps must increase strictly.")

        detection_indices = [
            detection.detection_index for detection in detections
        ]
        if len(detection_indices) != len(set(detection_indices)):
            raise ValueError("Detection indices must be unique within a frame.")

    @staticmethod
    def _iou(first: BoundingBox2D, second: BoundingBox2D) -> float:
        return float(
            compute_iou(
                [first.left, first.top, first.right, first.bottom],
                [second.left, second.top, second.right, second.bottom],
            )
        )
