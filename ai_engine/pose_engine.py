from __future__ import annotations

from pathlib import Path
from typing import Any

import cv2
import mediapipe as mp


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

        self._landmarker = (
            mp.tasks.vision.PoseLandmarker.create_from_options(
                options
            )
        )

    def close(self) -> None:
        self._landmarker.close()

    def analyze_video(
        self,
        video_path: str | Path,
        target_fps: float = 10.0,
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

        sample_stride = max(
            1,
            round(
                source_fps
                / max(target_fps, 1.0)
            ),
        )

        analyzed_frames: list[
            dict[str, Any]
        ] = []

        frame_index = 0

        try:
            while True:
                success, frame = capture.read()

                if not success:
                    break

                if frame_index % sample_stride != 0:
                    frame_index += 1
                    continue

                timestamp_ms = int(
                    (
                        frame_index
                        / source_fps
                    )
                    * 1000
                )

                rgb_frame = cv2.cvtColor(
                    frame,
                    cv2.COLOR_BGR2RGB,
                )

                mp_image = mp.Image(
                    image_format=mp.ImageFormat.SRGB,
                    data=rgb_frame,
                )

                result = (
                    self._landmarker.detect_for_video(
                        mp_image,
                        timestamp_ms,
                    )
                )

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

                frame_index += 1

        finally:
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
                "sample_stride": sample_stride,
                "analyzed_frame_count": analyzed_count,
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