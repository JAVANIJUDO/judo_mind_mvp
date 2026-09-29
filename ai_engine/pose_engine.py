from __future__ import annotations

from pathlib import Path
from threading import Lock
import time
from typing import Any, Callable

import cv2
import mediapipe as mp

from ai_engine.video_sampling import (
    VideoSamplingPlan,
    build_video_sampling_plan,
)


class JudoPoseEngine:
    """Multi-person pose extraction engine for Judo videos."""

    def __init__(
        self,
        model_path: str | Path | None = None,
        num_poses: int = 2,
    ) -> None:
        engine_root = Path(__file__).resolve().parent

        self.model_path = Path(
            model_path
            or engine_root
            / "models"
            / "pose_landmarker_heavy.task"
        )

        if not self.model_path.exists():
            raise FileNotFoundError(
                f"Pose model not found: {self.model_path}"
            )

        base_options = mp.tasks.BaseOptions(
            model_asset_path=str(self.model_path),
        )

        options = mp.tasks.vision.PoseLandmarkerOptions(
            base_options=base_options,
            running_mode=mp.tasks.vision.RunningMode.VIDEO,
            num_poses=num_poses,
            min_pose_detection_confidence=0.5,
            min_pose_presence_confidence=0.5,
            min_tracking_confidence=0.5,
            output_segmentation_masks=False,
        )

        self._landmarker_options = options
        self._landmarker = self._create_landmarker()
        self._analysis_lock = Lock()
        self._next_landmarker_timestamp_ms = 0

    def _create_landmarker(self):
        return mp.tasks.vision.PoseLandmarker.create_from_options(
            self._landmarker_options
        )

    def close(self) -> None:
        self._landmarker.close()

    def analyze_video(
        self,
        video_path: str | Path,
        target_fps: float = 10.0,
        *,
        sampling_plan: VideoSamplingPlan | None = None,
        before_sample: Callable[[], None] | None = None,
        after_sample: Callable[[int, int, int], None] | None = None,
        isolate_video_context: bool = False,
    ) -> dict[str, Any]:
        path = Path(video_path)

        if not path.exists():
            raise FileNotFoundError(
                f"Video not found: {path}"
            )

        capture = cv2.VideoCapture(str(path))

        if not capture.isOpened():
            raise RuntimeError(
                f"Unable to open video: {path}"
            )

        source_fps = capture.get(
            cv2.CAP_PROP_FPS
        )

        if source_fps <= 0:
            source_fps = 30.0

        frame_count = int(
            capture.get(
                cv2.CAP_PROP_FRAME_COUNT
            )
        )

        width = int(
            capture.get(
                cv2.CAP_PROP_FRAME_WIDTH
            )
        )

        height = int(
            capture.get(
                cv2.CAP_PROP_FRAME_HEIGHT
            )
        )

        duration_seconds = (
            frame_count / source_fps
            if frame_count > 0
            else 0.0
        )

        if sampling_plan is None:
            sampling_plan = build_video_sampling_plan(
                source_fps=source_fps,
                target_fps=target_fps,
                frame_count=frame_count,
            )
        elif (
            sampling_plan.frame_count != frame_count
            or abs(sampling_plan.source_fps - source_fps) > 1e-6
        ):
            raise ValueError(
                "Sampling plan metadata does not match the opened video."
            )
        sampled_frame_indices = set(
            sampling_plan.frame_indices
        )
        source_timestamp_by_frame = dict(zip(
            sampling_plan.frame_indices,
            sampling_plan.timestamps_ms,
        ))
        last_sampled_frame_index = max(
            sampling_plan.frame_indices,
            default=-1,
        )

        analyzed_frames: list[
            dict[str, Any]
        ] = []

        frame_index = 0
        decode_seconds = 0.0
        preprocessing_seconds = 0.0
        inference_seconds = 0.0
        postprocessing_seconds = 0.0
        analysis_lock = getattr(
            self,
            "_analysis_lock",
            None,
        )

        if analysis_lock is None:
            analysis_lock = Lock()
            self._analysis_lock = analysis_lock

        analysis_lock.acquire()
        active_landmarker = self._landmarker
        isolated_landmarker = None
        landmarker_timestamp_offset_ms = 0
        last_landmarker_timestamp_ms = -1

        try:
            if isolate_video_context:
                isolated_landmarker = self._create_landmarker()
                active_landmarker = isolated_landmarker
            else:
                landmarker_timestamp_offset_ms = getattr(
                    self,
                    "_next_landmarker_timestamp_ms",
                    0,
                )
                last_landmarker_timestamp_ms = (
                    landmarker_timestamp_offset_ms - 1
                )
            while frame_index <= last_sampled_frame_index:
                decode_started = time.perf_counter()
                success, frame = capture.read()
                decode_seconds += time.perf_counter() - decode_started

                if not success:
                    break

                if frame_index not in sampled_frame_indices:
                    frame_index += 1
                    continue

                timestamp_ms = source_timestamp_by_frame[frame_index]
                landmarker_timestamp_ms = (
                    landmarker_timestamp_offset_ms + timestamp_ms
                )

                if before_sample is not None:
                    before_sample()

                preprocessing_started = time.perf_counter()
                rgb_frame = cv2.cvtColor(
                    frame,
                    cv2.COLOR_BGR2RGB,
                )

                mp_image = mp.Image(
                    image_format=mp.ImageFormat.SRGB,
                    data=rgb_frame,
                )
                preprocessing_seconds += (
                    time.perf_counter() - preprocessing_started
                )

                inference_started = time.perf_counter()
                result = (
                    active_landmarker.detect_for_video(
                        mp_image,
                        landmarker_timestamp_ms,
                    )
                )
                inference_seconds += time.perf_counter() - inference_started
                last_landmarker_timestamp_ms = landmarker_timestamp_ms

                postprocessing_started = time.perf_counter()
                poses = []

                for pose_index, landmarks in enumerate(
                    result.pose_landmarks
                ):
                    world_landmarks = []

                    if (
                        pose_index
                        < len(
                            result.pose_world_landmarks
                        )
                    ):
                        world_landmarks = (
                            result.pose_world_landmarks[
                                pose_index
                            ]
                        )

                    pose_data = {
                        "pose_index": pose_index,
                        "landmarks": [
                            {
                                "x": landmark.x,
                                "y": landmark.y,
                                "z": landmark.z,
                                "visibility": getattr(
                                    landmark,
                                    "visibility",
                                    None,
                                ),
                                "presence": getattr(
                                    landmark,
                                    "presence",
                                    None,
                                ),
                            }
                            for landmark in landmarks
                        ],
                        "world_landmarks": [
                            {
                                "x": landmark.x,
                                "y": landmark.y,
                                "z": landmark.z,
                                "visibility": getattr(
                                    landmark,
                                    "visibility",
                                    None,
                                ),
                            }
                            for landmark in world_landmarks
                        ],
                    }

                    poses.append(pose_data)

                analyzed_frames.append(
                    {
                        "frame_index": frame_index,
                        "timestamp_ms": timestamp_ms,
                        "pose_count": len(poses),
                        "poses": poses,
                    }
                )
                postprocessing_seconds += (
                    time.perf_counter() - postprocessing_started
                )

                if after_sample is not None:
                    after_sample(frame_index, timestamp_ms, len(poses))

                frame_index += 1

        finally:
            try:
                if isolate_video_context:
                    if isolated_landmarker is not None:
                        isolated_landmarker.close()
                else:
                    self._next_landmarker_timestamp_ms = max(
                        landmarker_timestamp_offset_ms,
                        last_landmarker_timestamp_ms + 1,
                    )
            finally:
                analysis_lock.release()
            capture.release()

        frames_with_two_poses = sum(
            1
            for frame in analyzed_frames
            if frame["pose_count"] >= 2
        )

        frames_with_pose = sum(
            1
            for frame in analyzed_frames
            if frame["pose_count"] > 0
        )

        analyzed_count = len(
            analyzed_frames
        )

        effective_analyzed_fps = (
            analyzed_count / duration_seconds
            if duration_seconds > 0
            else 0.0
        )

        return {
            "video": {
                "path": str(path),
                "width": width,
                "height": height,
                "source_fps": source_fps,
                "frame_count": frame_count,
                "duration_seconds": duration_seconds,
            },
            "analysis": {
                "target_fps": target_fps,
                "sampling_strategy": (
                    sampling_plan.strategy
                ),
                "nominal_sample_interval_frames": (
                    sampling_plan.nominal_interval_frames
                ),
                "analyzed_frame_count": analyzed_count,
                "effective_analyzed_fps": (
                    effective_analyzed_fps
                ),
                "frames_with_pose": frames_with_pose,
                "frames_with_two_poses": (
                    frames_with_two_poses
                ),
                "single_or_multi_pose_rate": (
                    frames_with_pose
                    / analyzed_count
                    if analyzed_count
                    else 0.0
                ),
                "two_pose_detection_rate": (
                    frames_with_two_poses
                    / analyzed_count
                    if analyzed_count
                        else 0.0
                ),
                "stage_timings_seconds": {
                    "decode": decode_seconds,
                    "preprocessing": preprocessing_seconds,
                    "inference": inference_seconds,
                    "postprocessing": postprocessing_seconds,
                },
            },
            "frames": analyzed_frames,
        }


if __name__ == "__main__":
    engine = JudoPoseEngine()

    try:
        print(
            "Judo Mind Pose Engine: READY"
        )
        print(
            f"Model: {engine.model_path.name}"
        )
    finally:
        engine.close()
