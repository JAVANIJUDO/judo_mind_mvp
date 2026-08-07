from __future__ import annotations

import argparse
import json
from pathlib import Path

import av
import cv2
import numpy as np


SQUARES_X = 7
SQUARES_Y = 5
SQUARE_LENGTH = 0.025
MARKER_LENGTH = 0.018
MINIMUM_CORNERS = 10
DIAGNOSTIC_FRAME_COUNT = 14


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def load_intrinsics(
    path: Path,
) -> tuple[np.ndarray, np.ndarray, tuple[int, int]]:
    report = load_json(path)
    calibration = report["calibration"]
    matrix = np.asarray(calibration["camera_matrix"], dtype=np.float64)
    distortion = np.asarray(
        calibration["distortion_coefficients"], dtype=np.float64
    ).reshape(1, -1)
    size = (
        int(report["image_size"]["width"]),
        int(report["image_size"]["height"]),
    )
    return matrix, distortion, size


def frame_time(frame: av.VideoFrame) -> float:
    if frame.pts is None or frame.time_base is None:
        raise RuntimeError("Video frame has no usable PTS timestamp.")
    return float(frame.pts * frame.time_base)


def nearest_frames(
    path: Path,
    targets: list[float],
) -> list[tuple[float, np.ndarray]]:
    if not targets:
        return []

    ordered = list(targets)
    results: list[tuple[float, np.ndarray]] = []
    container = av.open(str(path))
    try:
        if not container.streams.video:
            raise RuntimeError(f"No video stream: {path}")
        stream = container.streams.video[0]
        target_index = 0
        previous: av.VideoFrame | None = None
        previous_time: float | None = None

        for current in container.decode(stream):
            current_time = frame_time(current)

            while (
                target_index < len(ordered)
                and current_time >= ordered[target_index]
            ):
                target = ordered[target_index]
                if previous is not None and previous_time is not None:
                    if abs(previous_time - target) <= abs(current_time - target):
                        chosen = previous
                        chosen_time = previous_time
                    else:
                        chosen = current
                        chosen_time = current_time
                else:
                    chosen = current
                    chosen_time = current_time

                results.append(
                    (
                        chosen_time,
                        chosen.to_ndarray(format="bgr24"),
                    )
                )
                target_index += 1

            if target_index >= len(ordered):
                break

            previous = current
            previous_time = current_time

        if len(results) != len(ordered):
            raise RuntimeError(
                f"Requested {len(ordered)} frames from {path}, "
                f"but decoded {len(results)}."
            )
        return results
    finally:
        container.close()


def mean_rotation(rotations: list[np.ndarray]) -> np.ndarray:
    accumulator = np.sum(np.asarray(rotations), axis=0)
    left, _, right = np.linalg.svd(accumulator)
    result = left @ right
    if np.linalg.det(result) < 0:
        left[:, -1] *= -1
        result = left @ right
    return result


def rotation_distance_degrees(first: np.ndarray, second: np.ndarray) -> float:
    delta = first @ second.T
    cosine = float(np.clip((np.trace(delta) - 1.0) / 2.0, -1.0, 1.0))
    return float(np.degrees(np.arccos(cosine)))


class BoardPoseDetector:
    def __init__(self) -> None:
        dictionary = cv2.aruco.getPredefinedDictionary(cv2.aruco.DICT_6X6_250)
        self.board = cv2.aruco.CharucoBoard(
            (SQUARES_X, SQUARES_Y),
            SQUARE_LENGTH,
            MARKER_LENGTH,
            dictionary,
        )
        self.detector = cv2.aruco.CharucoDetector(self.board)
        self.object_corners = np.asarray(
            self.board.getChessboardCorners(), dtype=np.float64
        )

    def pose(
        self,
        frame: np.ndarray,
        matrix: np.ndarray,
        distortion: np.ndarray,
    ) -> tuple[np.ndarray, np.ndarray, float, int] | None:
        corners, ids, _, _ = self.detector.detectBoard(frame)
        if corners is None or ids is None or len(ids) < MINIMUM_CORNERS:
            return None

        ids_array = np.asarray(ids, dtype=np.int32).reshape(-1)
        image_points = np.asarray(corners, dtype=np.float64).reshape(-1, 2)
        object_points = self.object_corners[ids_array]

        success, rvec, tvec = cv2.solvePnP(
            object_points,
            image_points,
            matrix,
            distortion,
            flags=cv2.SOLVEPNP_ITERATIVE,
        )
        if not success:
            return None

        projected, _ = cv2.projectPoints(
            object_points, rvec, tvec, matrix, distortion
        )
        error = float(
            np.sqrt(
                np.mean(
                    np.sum(
                        (image_points - projected.reshape(-1, 2)) ** 2,
                        axis=1,
                    )
                )
            )
        )
        rotation, _ = cv2.Rodrigues(rvec)
        return rotation, tvec.reshape(3), error, len(ids_array)


def orient_frame(frame: np.ndarray, orientation: str) -> np.ndarray:
    if orientation == "clockwise":
        return cv2.rotate(frame, cv2.ROTATE_90_CLOCKWISE)
    if orientation == "counterclockwise":
        return cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
    return frame


def select_orientation(
    label: str,
    selected_frames: list[tuple[float, np.ndarray]],
    target_size: tuple[int, int],
    detector: BoardPoseDetector,
    matrix: np.ndarray,
    distortion: np.ndarray,
) -> str:
    first_frame = selected_frames[0][1]
    raw_size = (first_frame.shape[1], first_frame.shape[0])

    if raw_size == target_size:
        print(f"{label} orientation: none (raw frame matches intrinsics)")
        return "none"

    if raw_size != (target_size[1], target_size[0]):
        raise RuntimeError(
            f"{label} raw size {raw_size} is incompatible with "
            f"intrinsic size {target_size}."
        )

    candidates = ("clockwise", "counterclockwise")
    scores: dict[str, float] = {}
    for candidate in candidates:
        errors: list[float] = []
        for _, frame in selected_frames[:8]:
            oriented = orient_frame(frame, candidate)
            pose = detector.pose(oriented, matrix, distortion)
            if pose is not None:
                errors.append(pose[2])
        if len(errors) >= 3:
            scores[candidate] = float(np.median(errors))

    if not scores:
        raise RuntimeError(
            f"Could not determine {label} orientation from ChArUco reprojection."
        )

    chosen = min(scores, key=scores.get)
    print(f"{label} orientation candidates: {scores}")
    print(f"{label} selected orientation: {chosen}")
    return chosen


def quality_label(
    translation_median_m: float,
    rotation_median_deg: float,
    sync_median_ms: float,
) -> str:
    if (
        translation_median_m <= 0.006
        and rotation_median_deg <= 0.60
        and sync_median_ms <= 8.5
    ):
        return "excellent"
    if (
        translation_median_m <= 0.012
        and rotation_median_deg <= 1.20
        and sync_median_ms <= 12.0
    ):
        return "good"
    if (
        translation_median_m <= 0.025
        and rotation_median_deg <= 2.50
        and sync_median_ms <= 20.0
    ):
        return "usable_for_calibration_test"
    return "review_required"


def run_diagnostic(
    camera_1_path: Path,
    camera_2_path: Path,
    camera_1_intrinsics_path: Path,
    camera_2_intrinsics_path: Path,
    audio_sync_path: Path,
) -> dict:
    matrix_1, distortion_1, size_1 = load_intrinsics(
        camera_1_intrinsics_path
    )
    matrix_2, distortion_2, size_2 = load_intrinsics(
        camera_2_intrinsics_path
    )
    audio_sync = load_json(audio_sync_path)
    mapping = audio_sync["time_mapping"]
    intercept = float(mapping["intercept_seconds"])
    slope = float(mapping["slope_seconds_per_second"])

    def map_time(time_1: float) -> float:
        return time_1 + intercept + slope * time_1

    target_times_1 = np.linspace(5.0, 55.0, DIAGNOSTIC_FRAME_COUNT).tolist()

    print("Decoding selected camera 1 frames using real PTS...")
    selected_1 = nearest_frames(camera_1_path, target_times_1)
    actual_times_1 = [item[0] for item in selected_1]
    target_times_2 = [map_time(value) for value in actual_times_1]

    print("Decoding synchronized camera 2 frames using real PTS...")
    selected_2 = nearest_frames(camera_2_path, target_times_2)

    detector = BoardPoseDetector()
    orientation_1 = select_orientation(
        "Camera 1",
        selected_1,
        size_1,
        detector,
        matrix_1,
        distortion_1,
    )
    orientation_2 = select_orientation(
        "Camera 2",
        selected_2,
        size_2,
        detector,
        matrix_2,
        distortion_2,
    )
    rotations: list[np.ndarray] = []
    translations: list[np.ndarray] = []
    sync_errors_ms: list[float] = []
    reprojection_1: list[float] = []
    reprojection_2: list[float] = []
    observations: list[dict] = []

    for index, ((time_1, frame_1), (time_2, frame_2)) in enumerate(
        zip(selected_1, selected_2), start=1
    ):
        frame_1 = orient_frame(frame_1, orientation_1)
        frame_2 = orient_frame(frame_2, orientation_2)
        pose_1 = detector.pose(frame_1, matrix_1, distortion_1)
        pose_2 = detector.pose(frame_2, matrix_2, distortion_2)
        sync_error_ms = (time_2 - map_time(time_1)) * 1000.0

        if pose_1 is None or pose_2 is None:
            print(f"Pair {index}/{DIAGNOSTIC_FRAME_COUNT}: board not detected")
            continue

        rotation_1, translation_1, error_1, corners_1 = pose_1
        rotation_2, translation_2, error_2, corners_2 = pose_2
        relative_rotation = rotation_2 @ rotation_1.T
        relative_translation = translation_2 - relative_rotation @ translation_1

        rotations.append(relative_rotation)
        translations.append(relative_translation)
        sync_errors_ms.append(sync_error_ms)
        reprojection_1.append(error_1)
        reprojection_2.append(error_2)
        observations.append(
            {
                "camera_1_pts_seconds": time_1,
                "camera_2_pts_seconds": time_2,
                "sync_error_ms": sync_error_ms,
                "camera_1_reprojection_px": error_1,
                "camera_2_reprojection_px": error_2,
                "camera_1_charuco_corners": corners_1,
                "camera_2_charuco_corners": corners_2,
                "relative_translation_m": relative_translation.tolist(),
                "baseline_m": float(np.linalg.norm(relative_translation)),
            }
        )
        print(
            f"Pair {index}/{DIAGNOSTIC_FRAME_COUNT}: "
            f"sync {sync_error_ms:+.3f} ms, "
            f"reproj {error_1:.3f}/{error_2:.3f} px"
        )

    if len(rotations) < 6:
        raise RuntimeError(
            f"Only {len(rotations)} synchronized ChArUco pairs were valid."
        )

    center_rotation = mean_rotation(rotations)
    translation_array = np.asarray(translations)
    center_translation = np.median(translation_array, axis=0)
    translation_deviation = np.linalg.norm(
        translation_array - center_translation,
        axis=1,
    )
    rotation_deviation = np.asarray(
        [rotation_distance_degrees(item, center_rotation) for item in rotations]
    )
    baseline_values = np.linalg.norm(translation_array, axis=1)
    absolute_sync = np.abs(np.asarray(sync_errors_ms))

    translation_median = float(np.median(translation_deviation))
    rotation_median = float(np.median(rotation_deviation))
    sync_median = float(np.median(absolute_sync))
    quality = quality_label(translation_median, rotation_median, sync_median)

    report = {
        "status": "completed",
        "quality": quality,
        "method": "audio_clock_mapping_plus_real_video_pts",
        "camera_orientations": {
            "camera_1": orientation_1,
            "camera_2": orientation_2,
        },
        "valid_pair_count": len(rotations),
        "requested_pair_count": DIAGNOSTIC_FRAME_COUNT,
        "audio_time_mapping": {
            "intercept_seconds": intercept,
            "slope_seconds_per_second": slope,
            "drift_ppm": float(slope * 1_000_000.0),
        },
        "diagnostics": {
            "median_abs_sync_error_ms": sync_median,
            "max_abs_sync_error_ms": float(np.max(absolute_sync)),
            "median_relative_translation_deviation_m": translation_median,
            "max_relative_translation_deviation_m": float(
                np.max(translation_deviation)
            ),
            "median_relative_rotation_deviation_deg": rotation_median,
            "max_relative_rotation_deviation_deg": float(
                np.max(rotation_deviation)
            ),
            "median_baseline_m": float(np.median(baseline_values)),
            "baseline_range_m": [
                float(np.min(baseline_values)),
                float(np.max(baseline_values)),
            ],
            "mean_camera_1_reprojection_px": float(np.mean(reprojection_1)),
            "mean_camera_2_reprojection_px": float(np.mean(reprojection_2)),
        },
        "observations": observations,
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_sync_diagnostic.json"
    )
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )
    print(f"Diagnostic saved: {output}")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind audio-synchronized stereo PTS diagnostic"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--audio-sync", type=Path, required=True)
    args = parser.parse_args()

    print("Judo Mind Stereo Audio/PTS Diagnostic")
    report = run_diagnostic(
        args.camera_1,
        args.camera_2,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.audio_sync,
    )
    data = report["diagnostics"]
    print("\nJudo Mind Stereo Audio/PTS Diagnostic Complete")
    print("Quality:", report["quality"])
    print("Valid pairs:", report["valid_pair_count"])
    print("Median sync error:", data["median_abs_sync_error_ms"], "ms")
    print(
        "Median translation deviation:",
        data["median_relative_translation_deviation_m"],
        "m",
    )
    print(
        "Median rotation deviation:",
        data["median_relative_rotation_deviation_deg"],
        "deg",
    )
    print("Median baseline:", data["median_baseline_m"], "m")


if __name__ == "__main__":
    main()