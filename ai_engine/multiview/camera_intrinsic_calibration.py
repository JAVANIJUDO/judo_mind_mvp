from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import cv2
import numpy as np


SQUARES_X = 7
SQUARES_Y = 5

# Physical dimensions in meters.
SQUARE_LENGTH = 0.025
MARKER_LENGTH = 0.018

MINIMUM_CHARUCO_CORNERS = 12
MINIMUM_CALIBRATION_VIEWS = 12


class JudoCameraCalibrator:
    """Intrinsic camera calibration for Judo Mind."""

    def __init__(
        self,
        sample_interval_seconds: float = 0.40,
    ) -> None:
        self.sample_interval_seconds = (
            sample_interval_seconds
        )

        self.dictionary = (
            cv2.aruco.getPredefinedDictionary(
                cv2.aruco.DICT_6X6_250
            )
        )

        self.board = cv2.aruco.CharucoBoard(
            (
                SQUARES_X,
                SQUARES_Y,
            ),
            SQUARE_LENGTH,
            MARKER_LENGTH,
            self.dictionary,
        )

        self.detector = (
            cv2.aruco.CharucoDetector(
                self.board
            )
        )

    def calibrate_video(
        self,
        video_path: str | Path,
        camera_id: str,
    ) -> dict[str, Any]:
        path = Path(video_path)

        if not path.exists():
            raise FileNotFoundError(
                f"Calibration video not found: {path}"
            )

        capture = cv2.VideoCapture(
            str(path)
        )

        if not capture.isOpened():
            raise RuntimeError(
                f"Cannot open video: {path}"
            )

        fps = capture.get(
            cv2.CAP_PROP_FPS
        )

        if fps <= 0:
            fps = 30.0

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
                fps
                * self.sample_interval_seconds
            ),
        )

        object_points: list[np.ndarray] = []
        image_points: list[np.ndarray] = []

        detected_frames = 0
        sampled_frames = 0

        frame_index = 0

        print(
            "Judo Mind Camera Calibration"
        )

        print(
            f"Video resolution: "
            f"{width} x {height}"
        )

        print(
            f"Video FPS: {fps:.3f}"
        )

        print(
            f"Frames: {total_frames}"
        )

        print(
            f"Sampling every "
            f"{sample_stride} frames"
        )

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

                sampled_frames += 1

                (
                    charuco_corners,
                    charuco_ids,
                    _,
                    _,
                ) = self.detector.detectBoard(
                    frame
                )

                if (
                    charuco_ids is None
                    or charuco_corners is None
                    or len(charuco_ids)
                    < MINIMUM_CHARUCO_CORNERS
                ):
                    frame_index += 1
                    continue

                (
                    frame_object_points,
                    frame_image_points,
                ) = self.board.matchImagePoints(
                    charuco_corners,
                    charuco_ids,
                )

                if (
                    frame_object_points is None
                    or frame_image_points is None
                    or len(frame_object_points)
                    < MINIMUM_CHARUCO_CORNERS
                ):
                    frame_index += 1
                    continue

                object_points.append(
                    np.asarray(
                        frame_object_points,
                        dtype=np.float32,
                    )
                )

                image_points.append(
                    np.asarray(
                        frame_image_points,
                        dtype=np.float32,
                    )
                )

                detected_frames += 1

                if (
                    detected_frames == 1
                    or detected_frames % 5 == 0
                ):
                    print(
                        "Accepted calibration "
                        f"views: {detected_frames}"
                    )

                frame_index += 1

        finally:
            capture.release()

        print()

        print(
            f"Sampled frames: "
            f"{sampled_frames}"
        )

        print(
            "Valid calibration views: "
            f"{len(object_points)}"
        )

        if (
            len(object_points)
            < MINIMUM_CALIBRATION_VIEWS
        ):
            raise RuntimeError(
                "Not enough valid ChArUco "
                "views for scientific "
                "calibration. "
                f"Need at least "
                f"{MINIMUM_CALIBRATION_VIEWS}, "
                f"found {len(object_points)}."
            )

        calibration = (
            self._robust_calibration(
                object_points=object_points,
                image_points=image_points,
                image_size=(
                    width,
                    height,
                ),
            )
        )

        report = self._build_report(
            camera_id=camera_id,
            video_path=path,
            width=width,
            height=height,
            fps=fps,
            sampled_frames=sampled_frames,
            initial_view_count=(
                len(object_points)
            ),
            calibration=calibration,
        )

        self._save_report(
            camera_id=camera_id,
            report=report,
        )

        return report

    def _robust_calibration(
        self,
        object_points: list[np.ndarray],
        image_points: list[np.ndarray],
        image_size: tuple[int, int],
    ) -> dict[str, Any]:
        first = self._run_calibration(
            object_points,
            image_points,
            image_size,
        )

        errors = np.asarray(
            first["per_view_errors"],
            dtype=np.float64,
        )

        median = float(
            np.median(errors)
        )

        mad = float(
            np.median(
                np.abs(
                    errors - median
                )
            )
        )

        robust_limit = max(
            1.25,
            median + 2.5 * mad,
        )

        accepted_indices = [
            index
            for index, error in enumerate(
                errors
            )
            if error <= robust_limit
        ]

        removed_count = (
            len(object_points)
            - len(accepted_indices)
        )

        if (
            removed_count > 0
            and len(accepted_indices)
            >= MINIMUM_CALIBRATION_VIEWS
        ):
            filtered_object_points = [
                object_points[index]
                for index
                in accepted_indices
            ]

            filtered_image_points = [
                image_points[index]
                for index
                in accepted_indices
            ]

            final = self._run_calibration(
                filtered_object_points,
                filtered_image_points,
                image_size,
            )

            final["outliers_removed"] = (
                removed_count
            )

            final[
                "outlier_error_limit_px"
            ] = robust_limit

            return final

        first["outliers_removed"] = 0

        first[
            "outlier_error_limit_px"
        ] = robust_limit

        return first

    def _run_calibration(
        self,
        object_points: list[np.ndarray],
        image_points: list[np.ndarray],
        image_size: tuple[int, int],
    ) -> dict[str, Any]:
        (
            rms,
            camera_matrix,
            distortion,
            rotation_vectors,
            translation_vectors,
        ) = cv2.calibrateCamera(
            object_points,
            image_points,
            image_size,
            None,
            None,
        )

        per_view_errors: list[float] = []

        for (
            object_point,
            image_point,
            rotation_vector,
            translation_vector,
        ) in zip(
            object_points,
            image_points,
            rotation_vectors,
            translation_vectors,
        ):
            projected, _ = (
                cv2.projectPoints(
                    object_point,
                    rotation_vector,
                    translation_vector,
                    camera_matrix,
                    distortion,
                )
            )

            observed = np.asarray(
                image_point,
                dtype=np.float64,
            ).reshape(-1, 2)

            predicted = np.asarray(
                projected,
                dtype=np.float64,
            ).reshape(-1, 2)

            differences = (
                observed - predicted
            )

            error = float(
                np.sqrt(
                    np.mean(
                        np.sum(
                            differences**2,
                            axis=1,
                        )
                    )
                )
            )

            per_view_errors.append(
                error
            )

        return {
            "rms": float(rms),
            "camera_matrix": (
                camera_matrix
            ),
            "distortion": distortion,
            "per_view_errors": (
                per_view_errors
            ),
            "view_count": (
                len(object_points)
            ),
        }

    def _quality_label(
        self,
        rms: float,
    ) -> str:
        if rms <= 0.50:
            return "excellent"

        if rms <= 0.80:
            return "good"

        if rms <= 1.20:
            return "acceptable"

        return "review_required"

    def _build_report(
        self,
        camera_id: str,
        video_path: Path,
        width: int,
        height: int,
        fps: float,
        sampled_frames: int,
        initial_view_count: int,
        calibration: dict[str, Any],
    ) -> dict[str, Any]:
        camera_matrix = calibration[
            "camera_matrix"
        ]

        distortion = calibration[
            "distortion"
        ]

        errors = calibration[
            "per_view_errors"
        ]

        rms = float(
            calibration["rms"]
        )

        return {
            "camera_id": camera_id,
            "status": "completed",
            "quality": (
                self._quality_label(rms)
            ),
            "source_video": (
                str(video_path)
            ),
            "image_size": {
                "width": width,
                "height": height,
                "orientation": (
                    "landscape"
                    if width > height
                    else "portrait"
                ),
            },
            "source_fps": fps,
            "board": {
                "type": "charuco",
                "squares_x": SQUARES_X,
                "squares_y": SQUARES_Y,
                "square_length_m": (
                    SQUARE_LENGTH
                ),
                "marker_length_m": (
                    MARKER_LENGTH
                ),
                "dictionary": (
                    "DICT_6X6_250"
                ),
            },
            "sampling": {
                "sampled_frames": (
                    sampled_frames
                ),
                "initial_valid_views": (
                    initial_view_count
                ),
                "final_valid_views": (
                    calibration[
                        "view_count"
                    ]
                ),
                "outliers_removed": (
                    calibration[
                        "outliers_removed"
                    ]
                ),
            },
            "calibration": {
                "rms_reprojection_error_px": (
                    rms
                ),
                "mean_view_error_px": (
                    float(
                        np.mean(errors)
                    )
                ),
                "max_view_error_px": (
                    float(
                        np.max(errors)
                    )
                ),
                "outlier_error_limit_px": (
                    calibration[
                        "outlier_error_limit_px"
                    ]
                ),
                "camera_matrix": (
                    camera_matrix.tolist()
                ),
                "distortion_coefficients": (
                    distortion
                    .reshape(-1)
                    .tolist()
                ),
                "fx": float(
                    camera_matrix[0, 0]
                ),
                "fy": float(
                    camera_matrix[1, 1]
                ),
                "cx": float(
                    camera_matrix[0, 2]
                ),
                "cy": float(
                    camera_matrix[1, 2]
                ),
            },
            "coordinate_unit": "meter",
        }

    def _save_report(
        self,
        camera_id: str,
        report: dict[str, Any],
    ) -> None:
        output_directory = (
            Path(__file__)
            .resolve()
            .parent
            .parent
            / "runtime"
            / "calibration"
        )

        output_directory.mkdir(
            parents=True,
            exist_ok=True,
        )

        output_path = (
            output_directory
            / f"{camera_id}_intrinsics.json"
        )

        output_path.write_text(
            json.dumps(
                report,
                indent=2,
                ensure_ascii=False,
            ),
            encoding="utf-8",
        )

        print(
            f"Calibration saved: "
            f"{output_path}"
        )


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Judo Mind ChArUco "
            "Intrinsic Camera Calibration"
        )
    )

    parser.add_argument(
        "video",
        help="Calibration video path",
    )

    parser.add_argument(
        "--camera-id",
        default="camera_1",
    )

    args = parser.parse_args()

    calibrator = JudoCameraCalibrator()

    report = calibrator.calibrate_video(
        video_path=args.video,
        camera_id=args.camera_id,
    )

    print()
    print(
        "Judo Mind Intrinsic "
        "Calibration Complete"
    )

    print()

    print(
        "Quality:",
        report["quality"],
    )

    print(
        "RMS reprojection error:",
        report["calibration"][
            "rms_reprojection_error_px"
        ],
        "px",
    )

    print(
        "Mean view error:",
        report["calibration"][
            "mean_view_error_px"
        ],
        "px",
    )

    print(
        "Max view error:",
        report["calibration"][
            "max_view_error_px"
        ],
        "px",
    )

    print(
        "Valid views:",
        report["sampling"][
            "final_valid_views"
        ],
    )

    print(
        "Outliers removed:",
        report["sampling"][
            "outliers_removed"
        ],
    )


if __name__ == "__main__":
    main()