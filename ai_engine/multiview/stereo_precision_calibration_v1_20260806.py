from __future__ import annotations

import argparse
import json
from pathlib import Path

import cv2
import numpy as np

from stereo_audio_sync_diagnostic_v2 import (
    BoardPoseDetector,
    load_intrinsics,
    load_json,
    nearest_frames,
    orient_frame,
    select_orientation,
)
from stereo_precision_sync_diagnostic_v1_20260806 import (
    MAX_SYNC_ERROR_MS,
    select_precision_pairs,
    video_packet_pts,
)


MIN_COMMON_CORNERS = 8
MIN_STEREO_VIEWS = 12
MAX_SELECTED_PAIRS = 72


class StereoBoardDetector:
    def __init__(self) -> None:
        dictionary = cv2.aruco.getPredefinedDictionary(
            cv2.aruco.DICT_6X6_250
        )
        self.board = cv2.aruco.CharucoBoard(
            (7, 5),
            0.025,
            0.018,
            dictionary,
        )
        self.detector = cv2.aruco.CharucoDetector(self.board)
        self.object_corners = np.asarray(
            self.board.getChessboardCorners(), dtype=np.float32
        )

    def observation(
        self, frame: np.ndarray
    ) -> tuple[np.ndarray, np.ndarray] | None:
        corners, ids, _, _ = self.detector.detectBoard(frame)
        if corners is None or ids is None:
            return None
        ids_array = np.asarray(ids, dtype=np.int32).reshape(-1)
        points = np.asarray(corners, dtype=np.float32).reshape(-1, 2)
        if len(ids_array) < MIN_COMMON_CORNERS:
            return None
        return ids_array, points


def common_points(
    first: tuple[np.ndarray, np.ndarray],
    second: tuple[np.ndarray, np.ndarray],
    object_corners: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, np.ndarray] | None:
    ids_1, points_1 = first
    ids_2, points_2 = second
    map_1 = {int(marker): points_1[index] for index, marker in enumerate(ids_1)}
    map_2 = {int(marker): points_2[index] for index, marker in enumerate(ids_2)}
    common = sorted(set(map_1).intersection(map_2))
    if len(common) < MIN_COMMON_CORNERS:
        return None
    object_points = np.asarray(
        [object_corners[index] for index in common], dtype=np.float32
    )
    image_1 = np.asarray([map_1[index] for index in common], dtype=np.float32)
    image_2 = np.asarray([map_2[index] for index in common], dtype=np.float32)
    return object_points, image_1, image_2


def evenly_limit_pairs(
    pairs: list[tuple[float, float, float]], limit: int
) -> list[tuple[float, float, float]]:
    if len(pairs) <= limit:
        return pairs
    indices = np.linspace(0, len(pairs) - 1, limit, dtype=int)
    return [pairs[int(index)] for index in indices]


def calibrate(
    object_points: list[np.ndarray],
    image_points_1: list[np.ndarray],
    image_points_2: list[np.ndarray],
    matrix_1: np.ndarray,
    distortion_1: np.ndarray,
    matrix_2: np.ndarray,
    distortion_2: np.ndarray,
    image_size: tuple[int, int],
) -> tuple[float, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    flags = cv2.CALIB_FIX_INTRINSIC
    criteria = (
        cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,
        200,
        1e-10,
    )
    result = cv2.stereoCalibrate(
        object_points,
        image_points_1,
        image_points_2,
        matrix_1.copy(),
        distortion_1.copy(),
        matrix_2.copy(),
        distortion_2.copy(),
        image_size,
        flags=flags,
        criteria=criteria,
    )
    rms = float(result[0])
    rotation = np.asarray(result[5], dtype=np.float64)
    translation = np.asarray(result[6], dtype=np.float64).reshape(3)
    essential = np.asarray(result[7], dtype=np.float64)
    fundamental = np.asarray(result[8], dtype=np.float64)
    return rms, rotation, translation, essential, fundamental


def point_line_distance(
    points: np.ndarray, lines: np.ndarray
) -> np.ndarray:
    a = lines[:, 0]
    b = lines[:, 1]
    c = lines[:, 2]
    denominator = np.sqrt(a * a + b * b)
    denominator = np.maximum(denominator, 1e-12)
    return np.abs(a * points[:, 0] + b * points[:, 1] + c) / denominator


def view_epipolar_error(
    points_1: np.ndarray,
    points_2: np.ndarray,
    fundamental: np.ndarray,
) -> float:
    lines_2 = cv2.computeCorrespondEpilines(
        points_1.reshape(-1, 1, 2), 1, fundamental
    ).reshape(-1, 3)
    lines_1 = cv2.computeCorrespondEpilines(
        points_2.reshape(-1, 1, 2), 2, fundamental
    ).reshape(-1, 3)
    d_2 = point_line_distance(points_2, lines_2)
    d_1 = point_line_distance(points_1, lines_1)
    return float(np.median((d_1 + d_2) * 0.5))


def robust_keep_indices(errors: np.ndarray) -> list[int]:
    median = float(np.median(errors))
    mad = float(np.median(np.abs(errors - median)))
    robust_sigma = 1.4826 * mad
    if robust_sigma < 1e-9:
        threshold = median + 0.25
    else:
        threshold = median + 3.0 * robust_sigma
    indices = [
        index for index, error in enumerate(errors) if float(error) <= threshold
    ]
    if len(indices) < MIN_STEREO_VIEWS:
        return list(range(len(errors)))
    return indices


def rotation_degrees(rotation: np.ndarray) -> float:
    vector, _ = cv2.Rodrigues(rotation)
    return float(np.linalg.norm(vector) * 180.0 / np.pi)


def quality_label(rms: float, median_epipolar: float, views: int) -> str:
    if views >= 20 and rms <= 1.0 and median_epipolar <= 0.75:
        return "excellent"
    if views >= 16 and rms <= 2.0 and median_epipolar <= 1.25:
        return "good"
    if views >= 12 and rms <= 3.0 and median_epipolar <= 2.0:
        return "usable_for_3d_validation"
    return "review_required"


def run(
    camera_1_path: Path,
    camera_2_path: Path,
    camera_1_intrinsics_path: Path,
    camera_2_intrinsics_path: Path,
    audio_sync_path: Path,
) -> dict:
    matrix_1, distortion_1, size_1 = load_intrinsics(camera_1_intrinsics_path)
    matrix_2, distortion_2, size_2 = load_intrinsics(camera_2_intrinsics_path)
    audio_sync = load_json(audio_sync_path)
    mapping = audio_sync["time_mapping"]
    intercept = float(mapping["intercept_seconds"])
    slope = float(mapping["slope_seconds_per_second"])

    print("Reading exact video PTS values...")
    times_1 = video_packet_pts(camera_1_path)
    times_2 = video_packet_pts(camera_2_path)
    pairs = select_precision_pairs(times_1, times_2, intercept, slope)

    # The diagnostic intentionally caps at 36 pairs. Build a denser precision
    # pool here using the same sub-1ms rule before selecting up to 72 views.
    dense_pairs: list[tuple[float, float, float]] = []
    used_2: set[float] = set()
    for time_1_value in times_1:
        time_1 = float(time_1_value)
        if time_1 < 3.0 or time_1 > 57.0:
            continue
        mapped = time_1 + intercept + slope * time_1
        index = int(np.searchsorted(times_2, mapped))
        candidates: list[float] = []
        if index < len(times_2):
            candidates.append(float(times_2[index]))
        if index > 0:
            candidates.append(float(times_2[index - 1]))
        if not candidates:
            continue
        time_2 = min(candidates, key=lambda value: abs(value - mapped))
        error_ms = (time_2 - mapped) * 1000.0
        if abs(error_ms) <= MAX_SYNC_ERROR_MS and time_2 not in used_2:
            used_2.add(time_2)
            dense_pairs.append((time_1, time_2, error_ms))

    if len(dense_pairs) >= len(pairs):
        pairs = dense_pairs
    pairs = evenly_limit_pairs(pairs, MAX_SELECTED_PAIRS)
    print(f"Selected sub-1ms candidate pairs: {len(pairs)}")
    if len(pairs) < MIN_STEREO_VIEWS:
        raise RuntimeError("Not enough sub-1ms timestamp pairs for stereo calibration.")

    frames_1 = nearest_frames(camera_1_path, [item[0] for item in pairs])
    frames_2 = nearest_frames(camera_2_path, [item[1] for item in pairs])

    pose_detector = BoardPoseDetector()
    orientation_1 = select_orientation(
        "Camera 1", frames_1, size_1, pose_detector, matrix_1, distortion_1
    )
    orientation_2 = select_orientation(
        "Camera 2", frames_2, size_2, pose_detector, matrix_2, distortion_2
    )
    detector = StereoBoardDetector()

    object_points: list[np.ndarray] = []
    image_points_1: list[np.ndarray] = []
    image_points_2: list[np.ndarray] = []
    metadata: list[dict] = []

    for ((time_1, frame_1), (time_2, frame_2)) in zip(frames_1, frames_2):
        frame_1 = orient_frame(frame_1, orientation_1)
        frame_2 = orient_frame(frame_2, orientation_2)
        observation_1 = detector.observation(frame_1)
        observation_2 = detector.observation(frame_2)
        if observation_1 is None or observation_2 is None:
            continue
        common = common_points(
            observation_1, observation_2, detector.object_corners
        )
        if common is None:
            continue
        object_view, image_1, image_2 = common
        mapped = time_1 + intercept + slope * time_1
        object_points.append(object_view)
        image_points_1.append(image_1)
        image_points_2.append(image_2)
        metadata.append(
            {
                "camera_1_pts_seconds": time_1,
                "camera_2_pts_seconds": time_2,
                "sync_error_ms": (time_2 - mapped) * 1000.0,
                "common_corner_count": len(object_view),
            }
        )

    print(f"Stereo views with common ChArUco corners: {len(object_points)}")
    if len(object_points) < MIN_STEREO_VIEWS:
        raise RuntimeError("Not enough common-corner stereo views.")

    initial = calibrate(
        object_points,
        image_points_1,
        image_points_2,
        matrix_1,
        distortion_1,
        matrix_2,
        distortion_2,
        size_1,
    )
    initial_rms, _, _, _, initial_f = initial
    initial_errors = np.asarray(
        [
            view_epipolar_error(points_1, points_2, initial_f)
            for points_1, points_2 in zip(image_points_1, image_points_2)
        ],
        dtype=np.float64,
    )
    keep = robust_keep_indices(initial_errors)
    rejected = len(object_points) - len(keep)
    print(f"Initial stereo RMS: {initial_rms:.6f} px")
    print(f"Robustly rejected views: {rejected}")

    final_object = [object_points[index] for index in keep]
    final_image_1 = [image_points_1[index] for index in keep]
    final_image_2 = [image_points_2[index] for index in keep]
    final_metadata = [metadata[index] for index in keep]
    final = calibrate(
        final_object,
        final_image_1,
        final_image_2,
        matrix_1,
        distortion_1,
        matrix_2,
        distortion_2,
        size_1,
    )
    rms, rotation, translation, essential, fundamental = final
    final_errors = np.asarray(
        [
            view_epipolar_error(points_1, points_2, fundamental)
            for points_1, points_2 in zip(final_image_1, final_image_2)
        ],
        dtype=np.float64,
    )
    sync_errors = np.abs(
        np.asarray([item["sync_error_ms"] for item in final_metadata])
    )
    median_epipolar = float(np.median(final_errors))
    quality = quality_label(rms, median_epipolar, len(final_object))

    report = {
        "status": "completed",
        "quality": quality,
        "method": "sub_1ms_audio_pts_charuco_stereo_calibrate_fix_intrinsic",
        "camera_orientations": {
            "camera_1": orientation_1,
            "camera_2": orientation_2,
        },
        "candidate_pairs": len(pairs),
        "detected_stereo_views": len(object_points),
        "valid_stereo_views": len(final_object),
        "rejected_views": rejected,
        "calibration": {
            "rms_reprojection_error_px": rms,
            "rotation_matrix": rotation.tolist(),
            "translation_m": translation.tolist(),
            "essential_matrix": essential.tolist(),
            "fundamental_matrix": fundamental.tolist(),
            "baseline_m": float(np.linalg.norm(translation)),
            "rotation_magnitude_deg": rotation_degrees(rotation),
        },
        "validation": {
            "median_epipolar_error_px": median_epipolar,
            "max_epipolar_error_px": float(np.max(final_errors)),
            "median_abs_sync_error_ms": float(np.median(sync_errors)),
            "max_abs_sync_error_ms": float(np.max(sync_errors)),
        },
        "views": final_metadata,
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_precision_extrinsics.json"
    )
    output.write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(f"Calibration saved: {output}")
    print("\nJudo Mind Precision Stereo Calibration Complete")
    print("Quality:", quality)
    print("Final stereo RMS:", rms, "px")
    print("Median epipolar error:", median_epipolar, "px")
    print("Valid stereo views:", len(final_object))
    print("Median sync error:", float(np.median(sync_errors)), "ms")
    print("Camera baseline:", float(np.linalg.norm(translation)), "m")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind sub-1ms robust ChArUco stereo calibration"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--audio-sync", type=Path, required=True)
    args = parser.parse_args()
    print("Judo Mind Precision Stereo Calibration")
    run(
        args.camera_1,
        args.camera_2,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.audio_sync,
    )


if __name__ == "__main__":
    main()