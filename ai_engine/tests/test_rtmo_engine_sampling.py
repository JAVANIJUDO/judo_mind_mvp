from __future__ import annotations

from pathlib import Path
from tempfile import TemporaryDirectory
from unittest import TestCase
from unittest.mock import patch

import cv2
import numpy as np

from ai_engine.rtmpose_engine import JudoRTMOEngine
from ai_engine.video_sampling import (
    build_video_sampling_plan,
    select_distributed_sampling_subset,
)


class _FakeCapture:
    def __init__(self) -> None:
        self._next_frame = 0
        self.released = False

    def isOpened(self) -> bool:
        return True

    def get(self, property_id: int) -> float:
        return {
            cv2.CAP_PROP_FPS: 25.0,
            cv2.CAP_PROP_FRAME_COUNT: 5.0,
            cv2.CAP_PROP_FRAME_WIDTH: 640.0,
            cv2.CAP_PROP_FRAME_HEIGHT: 360.0,
        }.get(property_id, 0.0)

    def read(self) -> tuple[bool, object | None]:
        if self._next_frame >= 5:
            return False, None

        self._next_frame += 1
        return True, object()

    def release(self) -> None:
        self.released = True


class _FakeRTMOModel:
    def __init__(self) -> None:
        self.calls = 0

    def __call__(self, frame: object) -> tuple[np.ndarray, np.ndarray]:
        del frame
        self.calls += 1
        pose_count = self.calls
        keypoints = np.zeros((pose_count, 17, 2), dtype=float)
        scores = np.full((pose_count, 17), 0.8, dtype=float)
        return keypoints, scores


class RTMOEngineSamplingTest(TestCase):
    def test_retains_frame_timestamp_pose_count_and_confidence(self) -> None:
        capture = _FakeCapture()
        model = _FakeRTMOModel()
        engine = JudoRTMOEngine.__new__(JudoRTMOEngine)
        engine._model = model

        with TemporaryDirectory(prefix="judo-mind-rtmo-") as directory:
            video_path = Path(directory) / "synthetic.mp4"
            video_path.write_bytes(b"synthetic-placeholder")

            with patch(
                "ai_engine.rtmpose_engine.cv2.VideoCapture",
                return_value=capture,
            ):
                result = engine.analyze_video(video_path, target_fps=10.0)

        self.assertTrue(capture.released)
        self.assertEqual(
            result["frames"],
            [
                {
                    "frame_index": 0,
                    "timestamp_ms": 0,
                    "pose_count": 1,
                    "mean_keypoint_confidence": 0.8,
                },
                {
                    "frame_index": 3,
                    "timestamp_ms": 120,
                    "pose_count": 2,
                    "mean_keypoint_confidence": 0.8,
                },
            ],
        )
        self.assertEqual(result["analysis"]["analyzed_frame_count"], 2)
        self.assertEqual(result["analysis"]["keypoint_confidence_count"], 51)
        self.assertAlmostEqual(
            result["analysis"]["mean_keypoint_confidence"],
            0.8,
        )
        self.assertIn("inference", result["analysis"]["stage_timings_seconds"])

    def test_accepts_shared_screening_subset_and_reports_callbacks(self) -> None:
        capture = _FakeCapture()
        model = _FakeRTMOModel()
        engine = JudoRTMOEngine.__new__(JudoRTMOEngine)
        engine._model = model
        full_plan = build_video_sampling_plan(
            source_fps=25.0,
            target_fps=10.0,
            frame_count=5,
        )
        subset = select_distributed_sampling_subset(
            full_plan,
            maximum_frames=1,
        )
        observations: list[tuple[int, int, int]] = []

        with TemporaryDirectory(prefix="judo-mind-rtmo-") as directory:
            video_path = Path(directory) / "synthetic.mp4"
            video_path.write_bytes(b"synthetic-placeholder")

            with patch(
                "ai_engine.rtmpose_engine.cv2.VideoCapture",
                return_value=capture,
            ):
                result = engine.analyze_video(
                    video_path,
                    sampling_plan=subset,
                    after_sample=lambda *items: observations.append(items),
                )

        self.assertEqual(model.calls, 1)
        self.assertEqual(
            [frame["frame_index"] for frame in result["frames"]],
            list(subset.frame_indices),
        )
        self.assertEqual(observations[0][:2], (3, 120))
