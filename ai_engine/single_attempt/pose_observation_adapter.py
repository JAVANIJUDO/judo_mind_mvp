from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from ai_engine.contracts.single_attempt_analysis_v2a import (
    FrameReference,
    Landmark2D,
    PoseObservation2D,
)


MEDIAPIPE_LANDMARK_INDEX = {
    "left_shoulder": 11,
    "right_shoulder": 12,
    "left_hip": 23,
    "right_hip": 24,
    "left_knee": 25,
    "right_knee": 26,
    "left_ankle": 27,
    "right_ankle": 28,
}


@dataclass(frozen=True)
class FrameCandidatePose2D:
    """Server-owned frame-local pose evidence with no track or Judo role."""

    frame: FrameReference
    detection_index: int
    image_width: int
    image_height: int
    landmarks: dict[str, Landmark2D]

    @property
    def required_landmark_count(self) -> int:
        return len(MEDIAPIPE_LANDMARK_INDEX)

    @property
    def model_landmark_visibility_count(self) -> int:
        return sum(
            landmark.visibility is not None for landmark in self.landmarks.values()
        )

    def to_human_confirmed_observation(
        self,
        *,
        neutral_track_id: str,
    ) -> PoseObservation2D:
        """Bind a frame candidate to an analysis-local neutral subject label."""

        return PoseObservation2D(
            frame=self.frame,
            neutral_track_id=neutral_track_id,
            detection_index=self.detection_index,
            image_width=self.image_width,
            image_height=self.image_height,
            landmarks=dict(self.landmarks),
        )


def mediapipe_frame_pose_to_candidate(
    frame_result: dict[str, Any],
    *,
    detection_index: int,
    image_width: int,
    image_height: int,
) -> FrameCandidatePose2D:
    """Adapt one model-returned pose without assigning identity or role."""

    if detection_index < 0:
        raise ValueError("Detection index cannot be negative.")

    try:
        frame_index = int(frame_result["frame_index"])
        timestamp_ms = int(frame_result["timestamp_ms"])
        poses = frame_result["poses"]
    except (KeyError, TypeError, ValueError) as error:
        raise ValueError("Pose frame result is incomplete.") from error

    if not isinstance(poses, list):
        raise ValueError("Pose frame result must contain a pose list.")

    matching = [
        pose
        for pose in poses
        if isinstance(pose, dict) and pose.get("pose_index") == detection_index
    ]
    if len(matching) != 1:
        raise ValueError("Selected frame-local pose is not available exactly once.")

    raw_landmarks = matching[0].get("landmarks")
    if not isinstance(raw_landmarks, list):
        raise ValueError("Selected pose does not contain landmark data.")

    required_length = max(MEDIAPIPE_LANDMARK_INDEX.values()) + 1
    if len(raw_landmarks) < required_length:
        raise ValueError("Selected pose does not contain all required landmarks.")

    landmarks: dict[str, Landmark2D] = {}
    for name, landmark_index in MEDIAPIPE_LANDMARK_INDEX.items():
        raw = raw_landmarks[landmark_index]
        if not isinstance(raw, dict):
            raise ValueError(f"Landmark {name} is not a valid object.")

        try:
            landmarks[name] = Landmark2D(
                x=raw["x"],
                y=raw["y"],
                visibility=raw.get("visibility"),
            )
        except (KeyError, TypeError, ValueError) as error:
            raise ValueError(f"Landmark {name} is invalid.") from error

    return FrameCandidatePose2D(
        frame=FrameReference(
            frame_index=frame_index,
            timestamp_ms=timestamp_ms,
        ),
        detection_index=detection_index,
        image_width=image_width,
        image_height=image_height,
        landmarks=landmarks,
    )


def mediapipe_frame_pose_to_observation(
    frame_result: dict[str, Any],
    *,
    detection_index: int,
    human_confirmed_neutral_track_id: str,
    image_width: int,
    image_height: int,
) -> PoseObservation2D:
    """Adapt one human-selected frame-local MediaPipe pose to V2A.

    `detection_index` remains frame-local. The caller must supply a neutral
    track ID that has been reviewed outside this adapter; no Tori/Uke role is
    inferred here.
    """

    candidate = mediapipe_frame_pose_to_candidate(
        frame_result,
        detection_index=detection_index,
        image_width=image_width,
        image_height=image_height,
    )
    return candidate.to_human_confirmed_observation(
        neutral_track_id=human_confirmed_neutral_track_id
    )
