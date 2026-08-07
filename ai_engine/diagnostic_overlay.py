from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import cv2
import numpy as np

from rtmlib import Body


# COCO 17-keypoint skeleton connections.
SKELETON = (
    (5, 6),
    (5, 7),
    (7, 9),
    (6, 8),
    (8, 10),
    (5, 11),
    (6, 12),
    (11, 12),
    (11, 13),
    (13, 15),
    (12, 14),
    (14, 16),
    (0, 5),
    (0, 6),
)


POSE_COLORS = (
    (255, 120, 30),   # Blue
    (0, 190, 255),    # Gold
    (80, 220, 80),    # Green
    (180, 80, 255),   # Purple
)


class JudoPoseDiagnostic:
    """Visual diagnostic system for Judo pose failures."""

    def __init__(self) -> None:
        print(
            "Initializing Judo Mind "
            "Diagnostic RTMPose..."
        )

        self._model = Body(
            mode="balanced",
            to_openpose=False,
            backend="onnxruntime",
            device="cpu",
        )

        print(
            "Judo Mind Diagnostic "
            "RTMPose: READY"
        )

    def analyze(
        self,
        video_path: str | Path,
        target_fps: float = 2.0,
        threshold: float = 0.30,
    ) -> dict[str, Any]:
        source_path = Path(video_path)

        if not source_path.exists():
            raise FileNotFoundError(
                f"Video not found: {source_path}"
            )

        output_root = (
            Path(__file__).resolve().parent
            / "runtime"
            / "diagnostics"
        )

        failure_directory = (
            output_root / "failure_frames"
        )

        output_root.mkdir(
            parents=True,
            exist_ok=True,
        )

        failure_directory.mkdir(
            parents=True,
            exist_ok=True,
        )

        capture = cv2.VideoCapture(
            str(source_path)
        )

        if not capture.isOpened():
            raise RuntimeError(
                f"Unable to open: {source_path}"
            )

        source_fps = capture.get(
            cv2.CAP_PROP_FPS
        )

        if source_fps <= 0:
            source_fps = 30.0

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

        total_frames = int(
            capture.get(
                cv2.CAP_PROP_FRAME_COUNT
            )
        )

        sample_stride = max(
            1,
            round(
                source_fps / target_fps
            ),
        )

        output_video = (
            output_root
            / "rtmpose_diagnostic.mp4"
        )

        writer = cv2.VideoWriter(
            str(output_video),
            cv2.VideoWriter_fourcc(
                *"mp4v"
            ),
            target_fps,
            (width, height),
        )

        if not writer.isOpened():
            capture.release()

            raise RuntimeError(
                "Unable to create "
                "diagnostic video."
            )

        analyzed = 0
        zero_pose = 0
        one_pose = 0
        two_or_more = 0

        failure_images: list[str] = []

        frame_index = 0

        try:
            while True:
                success, frame = (
                    capture.read()
                )

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

                valid_indices = (
                    self._valid_pose_indices(
                        scores_array,
                        threshold,
                    )
                )

                valid_count = len(
                    valid_indices
                )

                analyzed += 1

                if valid_count == 0:
                    zero_pose += 1
                    status = "NO VALID POSE"
                    status_color = (
                        0,
                        0,
                        255,
                    )

                elif valid_count == 1:
                    one_pose += 1
                    status = (
                        "ONLY ONE ATHLETE"
                    )
                    status_color = (
                        0,
                        180,
                        255,
                    )

                else:
                    two_or_more += 1
                    status = (
                        "TWO ATHLETES VISIBLE"
                    )
                    status_color = (
                        50,
                        210,
                        50,
                    )

                overlay = frame.copy()

                for display_index, pose_index in enumerate(
                    valid_indices
                ):
                    if (
                        pose_index
                        >= len(keypoints_array)
                        or pose_index
                        >= len(scores_array)
                    ):
                        continue

                    color = POSE_COLORS[
                        display_index
                        % len(POSE_COLORS)
                    ]

                    self._draw_pose(
                        overlay,
                        keypoints_array[
                            pose_index
                        ],
                        scores_array[
                            pose_index
                        ],
                        threshold,
                        color,
                        display_index + 1,
                    )

                self._draw_status(
                    overlay,
                    status,
                    status_color,
                    frame_index,
                    source_fps,
                    valid_count,
                )

                writer.write(overlay)

                if valid_count < 2:
                    failure_path = (
                        failure_directory
                        / (
                            f"failure_"
                            f"{frame_index:06d}.jpg"
                        )
                    )

                    cv2.imwrite(
                        str(failure_path),
                        overlay,
                    )

                    failure_images.append(
                        str(failure_path)
                    )

                if (
                    analyzed == 1
                    or analyzed % 10 == 0
                ):
                    estimated_total = max(
                        1,
                        (
                            total_frames
                            + sample_stride
                            - 1
                        )
                        // sample_stride,
                    )

                    progress = min(
                        100.0,
                        (
                            analyzed
                            / estimated_total
                        )
                        * 100.0,
                    )

                    print(
                        f"Diagnostic: "
                        f"{analyzed}/"
                        f"{estimated_total} "
                        f"({progress:.1f}%)"
                    )

                frame_index += 1

        finally:
            capture.release()
            writer.release()

        two_pose_percent = (
            two_or_more / analyzed * 100.0
            if analyzed
            else 0.0
        )

        report = {
            "engine": (
                "rtmpose_m_diagnostic"
            ),
            "target_fps": target_fps,
            "threshold": threshold,
            "analyzed_frames": analyzed,
            "zero_pose_frames": zero_pose,
            "one_pose_frames": one_pose,
            "two_or_more_pose_frames": (
                two_or_more
            ),
            "two_pose_percent": (
                two_pose_percent
            ),
            "output_video": (
                str(output_video)
            ),
            "failure_frame_count": (
                len(failure_images)
            ),
            "failure_directory": (
                str(failure_directory)
            ),
        }

        report_path = (
            output_root
            / "diagnostic_report.json"
        )

        report_path.write_text(
            json.dumps(
                report,
                indent=2,
                ensure_ascii=False,
            ),
            encoding="utf-8",
        )

        return report

    def _valid_pose_indices(
        self,
        scores: np.ndarray,
        threshold: float,
    ) -> list[int]:
        if scores.size == 0:
            return []

        if scores.ndim == 1:
            scores = np.expand_dims(
                scores,
                axis=0,
            )

        valid_indices: list[int] = []

        for index, person_scores in enumerate(
            scores
        ):
            visible = int(
                np.sum(
                    person_scores
                    >= threshold
                )
            )

            if visible >= 8:
                valid_indices.append(
                    index
                )

        return valid_indices

    def _draw_pose(
        self,
        frame: np.ndarray,
        keypoints: np.ndarray,
        scores: np.ndarray,
        threshold: float,
        color: tuple[int, int, int],
        athlete_number: int,
    ) -> None:
        if len(keypoints) < 17:
            return

        for start, end in SKELETON:
            if (
                start >= len(scores)
                or end >= len(scores)
            ):
                continue

            if (
                scores[start] < threshold
                or scores[end] < threshold
            ):
                continue

            start_point = (
                int(keypoints[start][0]),
                int(keypoints[start][1]),
            )

            end_point = (
                int(keypoints[end][0]),
                int(keypoints[end][1]),
            )

            cv2.line(
                frame,
                start_point,
                end_point,
                color,
                3,
                cv2.LINE_AA,
            )

        visible_points = []

        for index, point in enumerate(
            keypoints
        ):
            if index >= len(scores):
                continue

            if scores[index] < threshold:
                continue

            x = int(point[0])
            y = int(point[1])

            visible_points.append(
                (x, y)
            )

            cv2.circle(
                frame,
                (x, y),
                5,
                color,
                -1,
                cv2.LINE_AA,
            )

        if visible_points:
            label_x = min(
                point[0]
                for point in visible_points
            )

            label_y = min(
                point[1]
                for point in visible_points
            )

            cv2.putText(
                frame,
                f"ATHLETE {athlete_number}",
                (
                    label_x,
                    max(30, label_y - 15),
                ),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.65,
                color,
                2,
                cv2.LINE_AA,
            )

    def _draw_status(
        self,
        frame: np.ndarray,
        status: str,
        color: tuple[int, int, int],
        frame_index: int,
        source_fps: float,
        pose_count: int,
    ) -> None:
        time_seconds = (
            frame_index / source_fps
        )

        cv2.rectangle(
            frame,
            (15, 15),
            (500, 115),
            (10, 10, 10),
            -1,
        )

        cv2.putText(
            frame,
            "JUDO MIND POSE DIAGNOSTIC",
            (30, 45),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.65,
            (255, 255, 255),
            2,
            cv2.LINE_AA,
        )

        cv2.putText(
            frame,
            status,
            (30, 75),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.62,
            color,
            2,
            cv2.LINE_AA,
        )

        cv2.putText(
            frame,
            (
                f"Time: {time_seconds:.2f}s  "
                f"Valid poses: {pose_count}"
            ),
            (30, 102),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.52,
            (210, 210, 210),
            1,
            cv2.LINE_AA,
        )


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Judo Mind RTMPose "
            "Diagnostic Overlay"
        )
    )

    parser.add_argument(
        "video",
        help="Path to Judo video",
    )

    parser.add_argument(
        "--target-fps",
        type=float,
        default=2.0,
    )

    parser.add_argument(
        "--threshold",
        type=float,
        default=0.30,
    )

    args = parser.parse_args()

    diagnostic = JudoPoseDiagnostic()

    report = diagnostic.analyze(
        video_path=args.video,
        target_fps=args.target_fps,
        threshold=args.threshold,
    )

    print()
    print(
        "Judo Mind Diagnostic Complete"
    )
    print()

    print(
        json.dumps(
            report,
            indent=2,
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()