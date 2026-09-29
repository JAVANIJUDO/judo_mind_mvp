from __future__ import annotations

import math
from unittest import TestCase

from ai_engine.single_attempt.pose_observation_adapter import (
    mediapipe_frame_pose_to_candidate,
    mediapipe_frame_pose_to_observation,
)


def _frame_result() -> dict[str, object]:
    landmarks = [
        {"x": index / 100.0, "y": index / 200.0, "visibility": 0.9}
        for index in range(33)
    ]
    return {
        "frame_index": 50,
        "timestamp_ms": 2000,
        "pose_count": 2,
        "poses": [
            {"pose_index": 0, "landmarks": landmarks},
            {
                "pose_index": 1,
                "landmarks": [
                    {**landmark, "visibility": 0.8} for landmark in landmarks
                ],
            },
        ],
    }


class SingleAttemptPoseAdapterTest(TestCase):
    def test_frame_candidate_has_no_track_or_role_before_human_confirmation(
        self,
    ) -> None:
        candidate = mediapipe_frame_pose_to_candidate(
            _frame_result(),
            detection_index=1,
            image_width=640,
            image_height=360,
        )

        self.assertFalse(hasattr(candidate, "neutral_track_id"))
        self.assertFalse(hasattr(candidate, "role"))
        self.assertEqual(candidate.detection_index, 1)
        self.assertEqual(candidate.required_landmark_count, 8)
        self.assertEqual(candidate.model_landmark_visibility_count, 8)

        observation = candidate.to_human_confirmed_observation(
            neutral_track_id="Track A"
        )
        self.assertEqual(observation.neutral_track_id, "Track A")
        self.assertEqual(observation.detection_index, 1)

    def test_adapts_only_the_human_selected_frame_local_pose(self) -> None:
        observation = mediapipe_frame_pose_to_observation(
            _frame_result(),
            detection_index=1,
            human_confirmed_neutral_track_id="Track B",
            image_width=640,
            image_height=360,
        )

        self.assertEqual(observation.frame.frame_index, 50)
        self.assertEqual(observation.frame.timestamp_ms, 2000)
        self.assertEqual(observation.detection_index, 1)
        self.assertEqual(observation.neutral_track_id, "Track B")
        self.assertEqual(observation.image_width, 640)
        self.assertEqual(observation.coordinate_space, "normalized_image")
        self.assertEqual(observation.landmarks["left_shoulder"].x, 0.11)
        self.assertEqual(observation.landmarks["right_ankle"].visibility, 0.8)

    def test_does_not_treat_frame_local_order_as_identity(self) -> None:
        with self.assertRaises(ValueError):
            mediapipe_frame_pose_to_observation(
                _frame_result(),
                detection_index=0,
                human_confirmed_neutral_track_id="Track Tori",
                image_width=640,
                image_height=360,
            )

    def test_rejects_missing_pose_landmarks_and_non_finite_coordinates(self) -> None:
        frame = _frame_result()
        poses = frame["poses"]
        assert isinstance(poses, list)
        pose = poses[0]
        assert isinstance(pose, dict)
        pose["landmarks"] = []
        with self.assertRaises(ValueError):
            mediapipe_frame_pose_to_observation(
                frame,
                detection_index=0,
                human_confirmed_neutral_track_id="Track A",
                image_width=640,
                image_height=360,
            )

        frame = _frame_result()
        poses = frame["poses"]
        assert isinstance(poses, list)
        pose = poses[0]
        assert isinstance(pose, dict)
        landmarks = pose["landmarks"]
        assert isinstance(landmarks, list)
        landmark = landmarks[11]
        assert isinstance(landmark, dict)
        landmark["x"] = math.nan
        with self.assertRaises(ValueError):
            mediapipe_frame_pose_to_observation(
                frame,
                detection_index=0,
                human_confirmed_neutral_track_id="Track A",
                image_width=640,
                image_height=360,
            )
