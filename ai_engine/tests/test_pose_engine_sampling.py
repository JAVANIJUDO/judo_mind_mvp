from __future__ import annotations

from pathlib import Path
from tempfile import TemporaryDirectory
from threading import Lock
from unittest import TestCase
from unittest.mock import patch

import cv2

from ai_engine.pose_engine import JudoPoseEngine
from ai_engine.video_sampling import (
    build_bounded_review_context_plan,
    build_human_selected_frame_plan,
    build_video_sampling_plan,
    select_distributed_sampling_subset,
)


class _FakeCapture:
    def __init__(self, frame_count: int = 25) -> None:
        self._frame_count = frame_count
        self._next_frame = 0
        self.read_calls = 0
        self.released = False

    def isOpened(self) -> bool:
        return True

    def get(self, property_id: int) -> float:
        return {
            cv2.CAP_PROP_FPS: 25.0,
            cv2.CAP_PROP_FRAME_COUNT: float(self._frame_count),
            cv2.CAP_PROP_FRAME_WIDTH: 640.0,
            cv2.CAP_PROP_FRAME_HEIGHT: 480.0,
        }.get(property_id, 0.0)

    def read(self) -> tuple[bool, object | None]:
        self.read_calls += 1
        if self._next_frame >= self._frame_count:
            return False, None

        self._next_frame += 1
        return True, object()

    def release(self) -> None:
        self.released = True


class _EmptyPoseResult:
    pose_landmarks: tuple = ()
    pose_world_landmarks: tuple = ()


class _RecordingLandmarker:
    def __init__(self) -> None:
        self.timestamps_ms: list[int] = []
        self.closed = False

    def detect_for_video(self, image: object, timestamp_ms: int):
        del image
        self.timestamps_ms.append(timestamp_ms)
        return _EmptyPoseResult()

    def close(self) -> None:
        self.closed = True


class _FailingCloseLandmarker(_RecordingLandmarker):
    def close(self) -> None:
        super().close()
        raise RuntimeError("synthetic close failure")


class PoseEngineSamplingIntegrationTest(TestCase):
    def test_isolated_context_releases_lock_when_landmarker_close_fails(
        self,
    ) -> None:
        capture = _FakeCapture(frame_count=3)
        isolated_landmarker = _FailingCloseLandmarker()
        engine = JudoPoseEngine.__new__(JudoPoseEngine)
        engine._landmarker = _RecordingLandmarker()
        engine._landmarker_options = object()
        engine._analysis_lock = Lock()
        plan = build_bounded_review_context_plan(
            source_fps=25.0,
            frame_count=3,
            attempt_start_frame=0,
            review_frame=2,
        )

        with TemporaryDirectory(prefix="judo-mind-context-close-") as directory:
            video_path = Path(directory) / "synthetic.mp4"
            video_path.write_bytes(b"synthetic-placeholder")
            with (
                patch(
                    "ai_engine.pose_engine.cv2.VideoCapture",
                    return_value=capture,
                ),
                patch(
                    "ai_engine.pose_engine.cv2.cvtColor",
                    side_effect=lambda frame, conversion: frame,
                ),
                patch(
                    "ai_engine.pose_engine.mp.Image",
                    side_effect=lambda **arguments: arguments["data"],
                ),
                patch.object(
                    engine,
                    "_create_landmarker",
                    return_value=isolated_landmarker,
                ),
            ):
                with self.assertRaisesRegex(RuntimeError, "close failure"):
                    engine.analyze_video(
                        video_path,
                        sampling_plan=plan,
                        isolate_video_context=True,
                    )

        self.assertTrue(engine._analysis_lock.acquire(blocking=False))
        engine._analysis_lock.release()

    def test_isolated_context_uses_fresh_landmarker_and_monotonic_plan(
        self,
    ) -> None:
        capture = _FakeCapture(frame_count=100)
        persistent_landmarker = _RecordingLandmarker()
        isolated_landmarker = _RecordingLandmarker()
        engine = JudoPoseEngine.__new__(JudoPoseEngine)
        engine._landmarker = persistent_landmarker
        engine._landmarker_options = object()
        plan = build_bounded_review_context_plan(
            source_fps=25.0,
            frame_count=100,
            attempt_start_frame=45,
            review_frame=50,
        )

        with TemporaryDirectory(prefix="judo-mind-context-isolation-") as directory:
            video_path = Path(directory) / "synthetic.mp4"
            video_path.write_bytes(b"synthetic-placeholder")

            with (
                patch(
                    "ai_engine.pose_engine.cv2.VideoCapture",
                    return_value=capture,
                ),
                patch(
                    "ai_engine.pose_engine.cv2.cvtColor",
                    side_effect=lambda frame, conversion: frame,
                ),
                patch(
                    "ai_engine.pose_engine.mp.Image",
                    side_effect=lambda **arguments: arguments["data"],
                ),
                patch.object(
                    engine,
                    "_create_landmarker",
                    return_value=isolated_landmarker,
                ),
            ):
                result = engine.analyze_video(
                    video_path,
                    sampling_plan=plan,
                    isolate_video_context=True,
                )

        self.assertEqual(persistent_landmarker.timestamps_ms, [])
        self.assertEqual(isolated_landmarker.timestamps_ms, list(plan.timestamps_ms))
        self.assertTrue(isolated_landmarker.closed)
        self.assertEqual(
            [frame["frame_index"] for frame in result["frames"]],
            list(plan.frame_indices),
        )

    def test_human_selected_frame_stops_decoding_after_reviewed_frame(
        self,
    ) -> None:
        capture = _FakeCapture(frame_count=100)
        landmarker = _RecordingLandmarker()
        engine = JudoPoseEngine.__new__(JudoPoseEngine)
        engine._landmarker = landmarker
        plan = build_human_selected_frame_plan(
            source_fps=25.0,
            frame_count=100,
            frame_index=10,
        )

        with TemporaryDirectory(prefix="judo-mind-selected-frame-") as directory:
            video_path = Path(directory) / "synthetic.mp4"
            video_path.write_bytes(b"synthetic-placeholder")

            with (
                patch(
                    "ai_engine.pose_engine.cv2.VideoCapture",
                    return_value=capture,
                ),
                patch(
                    "ai_engine.pose_engine.cv2.cvtColor",
                    side_effect=lambda frame, conversion: frame,
                ),
                patch(
                    "ai_engine.pose_engine.mp.Image",
                    side_effect=lambda **arguments: arguments["data"],
                ),
            ):
                result = engine.analyze_video(
                    video_path,
                    sampling_plan=plan,
                )

        self.assertEqual(capture.read_calls, 11)
        self.assertEqual(result["frames"][0]["frame_index"], 10)
        self.assertEqual(result["frames"][0]["timestamp_ms"], 400)

    def test_landmarker_receives_shared_25_to_10_fps_sampling_plan(self) -> None:
        capture = _FakeCapture()
        landmarker = _RecordingLandmarker()
        engine = JudoPoseEngine.__new__(JudoPoseEngine)
        engine._landmarker = landmarker

        with TemporaryDirectory(prefix="judo-mind-sampling-") as directory:
            video_path = Path(directory) / "synthetic.mp4"
            video_path.write_bytes(b"synthetic-placeholder")

            with (
                patch(
                    "ai_engine.pose_engine.cv2.VideoCapture",
                    return_value=capture,
                ),
                patch(
                    "ai_engine.pose_engine.cv2.cvtColor",
                    side_effect=lambda frame, conversion: frame,
                ),
                patch(
                    "ai_engine.pose_engine.mp.Image",
                    side_effect=lambda **arguments: arguments["data"],
                ),
            ):
                result = engine.analyze_video(video_path, target_fps=10.0)

        self.assertTrue(capture.released)
        self.assertEqual(
            [frame["frame_index"] for frame in result["frames"]],
            [0, 3, 5, 8, 10, 13, 15, 18, 20, 23],
        )
        self.assertEqual(
            landmarker.timestamps_ms,
            [0, 120, 200, 320, 400, 520, 600, 720, 800, 920],
        )
        self.assertEqual(result["analysis"]["analyzed_frame_count"], 10)
        self.assertEqual(result["analysis"]["effective_analyzed_fps"], 10.0)
        self.assertIn("inference", result["analysis"]["stage_timings_seconds"])

    def test_accepts_shared_screening_subset_and_reports_callbacks(self) -> None:
        capture = _FakeCapture()
        landmarker = _RecordingLandmarker()
        engine = JudoPoseEngine.__new__(JudoPoseEngine)
        engine._landmarker = landmarker
        full_plan = build_video_sampling_plan(
            source_fps=25.0,
            target_fps=10.0,
            frame_count=25,
        )
        subset = select_distributed_sampling_subset(
            full_plan,
            maximum_frames=4,
        )
        observations: list[tuple[int, int, int]] = []

        with TemporaryDirectory(prefix="judo-mind-sampling-") as directory:
            video_path = Path(directory) / "synthetic.mp4"
            video_path.write_bytes(b"synthetic-placeholder")

            with (
                patch(
                    "ai_engine.pose_engine.cv2.VideoCapture",
                    return_value=capture,
                ),
                patch(
                    "ai_engine.pose_engine.cv2.cvtColor",
                    side_effect=lambda frame, conversion: frame,
                ),
                patch(
                    "ai_engine.pose_engine.mp.Image",
                    side_effect=lambda **arguments: arguments["data"],
                ),
            ):
                result = engine.analyze_video(
                    video_path,
                    sampling_plan=subset,
                    after_sample=lambda *items: observations.append(items),
                )

        self.assertEqual(
            tuple(frame["frame_index"] for frame in result["frames"]),
            subset.frame_indices,
        )
        self.assertEqual(
            tuple(item[:2] for item in observations),
            tuple(zip(subset.frame_indices, subset.timestamps_ms)),
        )

    def test_reused_landmarker_receives_monotonic_cross_video_timestamps(
        self,
    ) -> None:
        captures = (_FakeCapture(frame_count=3), _FakeCapture(frame_count=3))
        landmarker = _RecordingLandmarker()
        engine = JudoPoseEngine.__new__(JudoPoseEngine)
        engine._landmarker = landmarker

        with TemporaryDirectory(prefix="judo-mind-sampling-") as directory:
            video_paths = (
                Path(directory) / "first.mp4",
                Path(directory) / "second.mp4",
            )

            for video_path in video_paths:
                video_path.write_bytes(b"synthetic-placeholder")

            with (
                patch(
                    "ai_engine.pose_engine.cv2.VideoCapture",
                    side_effect=captures,
                ),
                patch(
                    "ai_engine.pose_engine.cv2.cvtColor",
                    side_effect=lambda frame, conversion: frame,
                ),
                patch(
                    "ai_engine.pose_engine.mp.Image",
                    side_effect=lambda **arguments: arguments["data"],
                ),
            ):
                first = engine.analyze_video(video_paths[0], target_fps=25.0)
                first_landmarker_timestamps = tuple(landmarker.timestamps_ms)
                second = engine.analyze_video(video_paths[1], target_fps=25.0)

        second_landmarker_timestamps = tuple(
            landmarker.timestamps_ms[len(first_landmarker_timestamps):]
        )
        self.assertEqual(
            [frame["timestamp_ms"] for frame in first["frames"]],
            [0, 40, 80],
        )
        self.assertEqual(
            [frame["timestamp_ms"] for frame in second["frames"]],
            [0, 40, 80],
        )
        self.assertGreater(
            second_landmarker_timestamps[0],
            first_landmarker_timestamps[-1],
        )
