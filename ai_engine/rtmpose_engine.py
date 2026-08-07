from __future__ import annotations

import argparse
import json
import time
from pathlib import Path
from typing import Any

import cv2
import numpy as np

from rtmlib import Body


class JudoRTMOEngine:
    """One-stage multi-person pose engine for Judo video."""

    def __init__(self) -> None:
        print(
            "Initializing Judo Mind RTMO "
            "Multi-Person Engine..."
        )

        self._model = Body(
            pose="rtmo",
            mode="balanced",
            to_openpose=False,
            backend="onnxruntime",
            device="cpu",
        )

        print(
            "Judo Mind RTMO Engine: READY"
        )

    def analyze_video(
        self,
        video_path: str | Path,
        target_fps: float = 10.0,
        keypoint_threshold: float = 0.30,
        show_progress: bool = False,
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

        estimated_frames = max(
            1,
            (
                frame_count
                + sample_stride
                - 1
            )
            // sample_stride,
        )

        analyzed_frames = 0
        zero_pose_frames = 0
        one_pose_frames = 0
        two_or_more_pose_frames = 0

        frames_with_pose = 0
        frames_with_two_poses = 0

        frame_index = 0

        started_at = time.perf_counter()

        try:
            while True:
                success, frame = capture.read()

                if not success:
                    break

                if (
                    frame_index
                    % sample_stride
                    != 0
                ):
                    frame_index += 1
                    continue

                keypoints, scores = (
                    self._model(frame)
                )

                keypoints_array = np.asarray(
                    keypoints
                )

                scores_array = np.asarray(
                    scores
                )

                valid_pose_count = (
                    self._count_valid_poses(
                        keypoints_array,
                        scores_array,
                        keypoint_threshold,
                    )
                )

                analyzed_frames += 1

                if valid_pose_count == 0:
                    zero_pose_frames += 1

                elif valid_pose_count == 1:
                    one_pose_frames += 1

                else:
                    two_or_more_pose_frames += 1

                if valid_pose_count >= 1:
                    frames_with_pose += 1

                if valid_pose_count >= 2:
                    frames_with_two_poses += 1

                if (
                    show_progress
                    and (
                        analyzed_frames == 1
                        or analyzed_frames % 25 == 0
                    )
                ):
                    progress = min(
                        100.0,
                        (
                            analyzed_frames
                            / estimated_frames
                        )
                        * 100.0,
                    )

                    print(
                        f"Analyzing RTMO: "
                        f"{analyzed_frames}/"
                        f"{estimated_frames} "
                        f"({progress:.1f}%)"
                    )

                frame_index += 1

        finally:
            capture.release()

        processing_seconds = (
            time.perf_counter()
            - started_at
        )

        pose_rate = (
            frames_with_pose
            / analyzed_frames
            if analyzed_frames
            else 0.0
        )

        two_pose_rate = (
            frames_with_two_poses
            / analyzed_frames
            if analyzed_frames
            else 0.0
        )

        processing_fps = (
            analyzed_frames
            / processing_seconds
            if processing_seconds > 0
            else 0.0
        )

        realtime_factor = (
            processing_seconds
            / duration_seconds
            if duration_seconds > 0
            else 0.0
        )

        return {
            "engine": "rtmo",
            "architecture": (
                "one_stage_multi_person"
            ),
            "mode": "balanced",
            "backend": "onnxruntime",
            "device": "cpu",
            "video": {
                "path": str(path),
                "width": width,
                "height": height,
                "source_fps": source_fps,
                "frame_count": frame_count,
                "duration_seconds": (
                    duration_seconds
                ),
            },
            "analysis": {
                "target_fps": target_fps,
                "sample_stride": sample_stride,
                "keypoint_threshold": (
                    keypoint_threshold
                ),
                "analyzed_frame_count": (
                    analyzed_frames
                ),
                "zero_pose_frames": (
                    zero_pose_frames
                ),
                "one_pose_frames": (
                    one_pose_frames
                ),
                "two_or_more_pose_frames": (
                    two_or_more_pose_frames
                ),
                "frames_with_pose": (
                    frames_with_pose
                ),
                "frames_with_two_poses": (
                    frames_with_two_poses
                ),
                "single_or_multi_pose_percent": (
                    pose_rate * 100.0
                ),
                "two_pose_detection_percent": (
                    two_pose_rate * 100.0
                ),
                "processing_seconds": (
                    processing_seconds
                ),
                "processing_fps": (
                    processing_fps
                ),
                "realtime_factor": (
                    realtime_factor
                ),
            },
        }

    def _count_valid_poses(
        self,
        keypoints: np.ndarray,
        scores: np.ndarray,
        threshold: float,
    ) -> int:
        if (
            keypoints.size == 0
            or scores.size == 0
        ):
            return 0

        if scores.ndim == 1:
            scores = np.expand_dims(
                scores,
                axis=0,
            )

        valid_count = 0

        for person_scores in scores:
            visible_keypoints = int(
                np.sum(
                    person_scores >= threshold
                )
            )

            if visible_keypoints >= 8:
                valid_count += 1

        return valid_count


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Judo Mind RTMO "
            "Multi-Person Benchmark"
        )
    )

    parser.add_argument(
        "video",
        nargs="?",
        help="Path to Judo video file",
    )

    parser.add_argument(
        "--target-fps",
        type=float,
        default=10.0,
    )

    parser.add_argument(
        "--threshold",
        type=float,
        default=0.30,
    )

    args = parser.parse_args()

    engine = JudoRTMOEngine()

    if not args.video:
        print(
            "Engine initialization "
            "test completed."
        )
        return

    print()
    print(f"Video: {args.video}")
    print(
        "Starting Judo RTMO analysis..."
    )
    print()

    result = engine.analyze_video(
        video_path=args.video,
        target_fps=args.target_fps,
        keypoint_threshold=args.threshold,
        show_progress=True,
    )

    print()
    print(
        "Judo Mind RTMO Analysis Complete"
    )
    print()

    print(
        json.dumps(
            result,
            indent=2,
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()