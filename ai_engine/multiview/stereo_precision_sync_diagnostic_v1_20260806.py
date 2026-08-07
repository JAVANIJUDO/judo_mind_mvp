from __future__ import annotations

import argparse
import json
from pathlib import Path

import av
import numpy as np

from stereo_audio_sync_diagnostic_v2 import (
    BoardPoseDetector,
    load_intrinsics,
    load_json,
    mean_rotation,
    nearest_frames,
    orient_frame,
    rotation_distance_degrees,
    select_orientation,
)


MAX_SYNC_ERROR_MS = 1.0
MAX_SELECTED_PAIRS = 36
MIN_VALID_PAIRS = 10


def video_packet_pts(path: Path) -> np.ndarray:
    container = av.open(str(path))
    try:
        if not container.streams.video:
            raise RuntimeError(f"No video stream: {path}")
        stream = container.streams.video[0]
        time_base = stream.time_base
        values: list[float] = []
        for packet in container.demux(stream):
            if packet.pts is not None:
                values.append(float(packet.pts * time_base))
        if not values:
            raise RuntimeError(f"No video PTS values: {path}")
        return np.asarray(sorted(set(values)), dtype=np.float64)
    finally:
        container.close()


def nearest_value(values: np.ndarray, target: float) -> float:
    index = int(np.searchsorted(values, target))
    candidates: list[float] = []
    if index < len(values):
        candidates.append(float(values[index]))
    if index > 0:
        candidates.append(float(values[index - 1]))
    if not candidates:
        raise RuntimeError("No timestamp candidate found.")
    return min(candidates, key=lambda item: abs(item - target))


def select_precision_pairs(
    times_1: np.ndarray,
    times_2: np.ndarray,
    intercept: float,
    slope: float,
) -> list[tuple[float, float, float]]:
    candidates: list[tuple[float, float, float]] = []
    used_camera_2: set[float] = set()

    for time_1 in times_1:
        time_1 = float(time_1)
        if time_1 < 3.0 or time_1 > 57.0:
            continue
        mapped_time_2 = time_1 + intercept + slope * time_1
        time_2 = nearest_value(times_2, mapped_time_2)
        error_ms = (time_2 - mapped_time_2) * 1000.0
        if abs(error_ms) > MAX_SYNC_ERROR_MS:
            continue
        if time_2 in used_camera_2:
            continue
        used_camera_2.add(time_2)
        candidates.append((time_1, time_2, error_ms))

    if len(candidates) <= MAX_SELECTED_PAIRS:
        return candidates

    indices = np.linspace(
        0,
        len(candidates) - 1,
        MAX_SELECTED_PAIRS,
        dtype=int,
    )
    return [candidates[int(index)] for index in indices]


def quality_label(
    translation_median_m: float,
    rotation_median_deg: float,
    sync_median_ms: float,
) -> str:
    if (
        translation_median_m <= 0.004
        and rotation_median_deg <= 0.50
        and sync_median_ms <= 0.60
    ):
        return "excellent"
    if (
        translation_median_m <= 0.008
        and rotation_median_deg <= 1.00
        and sync_median_ms <= 0.80
    ):
        return "good"
    if (
        translation_median_m <= 0.015
        and rotation_median_deg <= 1.75
        and sync_median_ms <= 1.00
    ):
        return "usable_for_stereo_calibration"
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

    print("Reading exact encoded video timestamps...")
    times_1 = video_packet_pts(camera_1_path)
    times_2 = video_packet_pts(camera_2_path)
    print(f"Camera 1 video timestamps: {len(times_1)}")
    print(f"Camera 2 video timestamps: {len(times_2)}")

    precision_pairs = select_precision_pairs(times_1, times_2, intercept, slope)
    print(
        f"Selected <= {MAX_SYNC_ERROR_MS:.1f} ms pairs: "
        f"{len(precision_pairs)}"
    )
    if len(precision_pairs) < MIN_VALID_PAIRS:
        raise RuntimeError(
            f"Only {len(precision_pairs)} precision timestamp pairs found."
        )

    target_1 = [item[0] for item in precision_pairs]
    target_2 = [item[1] for item in precision_pairs]
    print("Decoding precision camera 1 frames...")
    frames_1 = nearest_frames(camera_1_path, target_1)
    print("Decoding precision camera 2 frames...")
    frames_2 = nearest_frames(camera_2_path, target_2)

    detector = BoardPoseDetector()
    orientation_1 = select_orientation(
        "Camera 1", frames_1, size_1, detector, matrix_1, distortion_1
    )
    orientation_2 = select_orientation(
        "Camera 2", frames_2, size_2, detector, matrix_2, distortion_2
    )

    rotations: list[np.ndarray] = []
    translations: list[np.ndarray] = []
    sync_errors: list[float] = []
    reprojection_1: list[float] = []
    reprojection_2: list[float] = []
    observations: list[dict] = []

    for index, (((time_1, frame_1), (time_2, frame_2)), expected) in enumerate(
        zip(zip(frames_1, frames_2), precision_pairs), start=1
    ):
        frame_1 = orient_frame(frame_1, orientation_1)
        frame_2 = orient_frame(frame_2, orientation_2)
        pose_1 = detector.pose(frame_1, matrix_1, distortion_1)
        pose_2 = detector.pose(frame_2, matrix_2, distortion_2)
        mapped_time_2 = time_1 + intercept + slope * time_1
        sync_error_ms = (time_2 - mapped_time_2) * 1000.0

        if pose_1 is None or pose_2 is None:
            continue
        rotation_1, translation_1, error_1, corners_1 = pose_1
        rotation_2, translation_2, error_2, corners_2 = pose_2
        relative_rotation = rotation_2 @ rotation_1.T
        relative_translation = translation_2 - relative_rotation @ translation_1

        rotations.append(relative_rotation)
        translations.append(relative_translation)
        sync_errors.append(sync_error_ms)
        reprojection_1.append(error_1)
        reprojection_2.append(error_2)
        observations.append(
            {
                "camera_1_pts_seconds": time_1,
                "camera_2_pts_seconds": time_2,
                "sync_error_ms": sync_error_ms,
                "camera_1_reprojection_px": error_1,
                "camera_2_reprojection_px": error_2,
                "camera_1_corners": corners_1,
                "camera_2_corners": corners_2,
                "baseline_m": float(np.linalg.norm(relative_translation)),
            }
        )
        print(
            f"Valid {len(rotations):02d}: sync {sync_error_ms:+.3f} ms, "
            f"reproj {error_1:.3f}/{error_2:.3f} px"
        )

    if len(rotations) < MIN_VALID_PAIRS:
        raise RuntimeError(
            f"Only {len(rotations)} precision pairs contained ChArUco in both views."
        )

    center_rotation = mean_rotation(rotations)
    translation_array = np.asarray(translations)
    center_translation = np.median(translation_array, axis=0)
    translation_deviation = np.linalg.norm(
        translation_array - center_translation, axis=1
    )
    rotation_deviation = np.asarray(
        [rotation_distance_degrees(item, center_rotation) for item in rotations]
    )
    baselines = np.linalg.norm(translation_array, axis=1)
    absolute_sync = np.abs(np.asarray(sync_errors))

    t_median = float(np.median(translation_deviation))
    r_median = float(np.median(rotation_deviation))
    s_median = float(np.median(absolute_sync))
    quality = quality_label(t_median, r_median, s_median)

    report = {
        "status": "completed",
        "quality": quality,
        "method": "audio_drift_mapping_plus_sub_1ms_video_pts_selection",
        "valid_pair_count": len(rotations),
        "candidate_pair_count": len(precision_pairs),
        "camera_orientations": {
            "camera_1": orientation_1,
            "camera_2": orientation_2,
        },
        "diagnostics": {
            "median_abs_sync_error_ms": s_median,
            "max_abs_sync_error_ms": float(np.max(absolute_sync)),
            "median_translation_deviation_m": t_median,
            "max_translation_deviation_m": float(np.max(translation_deviation)),
            "median_rotation_deviation_deg": r_median,
            "max_rotation_deviation_deg": float(np.max(rotation_deviation)),
            "median_baseline_m": float(np.median(baselines)),
            "baseline_range_m": [float(np.min(baselines)), float(np.max(baselines))],
            "mean_camera_1_reprojection_px": float(np.mean(reprojection_1)),
            "mean_camera_2_reprojection_px": float(np.mean(reprojection_2)),
        },
        "observations": observations,
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_precision_sync_diagnostic.json"
    )
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    print(f"Diagnostic saved: {output}")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind sub-1ms stereo timestamp diagnostic"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--audio-sync", type=Path, required=True)
    args = parser.parse_args()

    print("Judo Mind Precision Stereo Sync Diagnostic")
    report = run(
        args.camera_1,
        args.camera_2,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.audio_sync,
    )
    data = report["diagnostics"]
    print("\nJudo Mind Precision Stereo Sync Diagnostic Complete")
    print("Quality:", report["quality"])
    print("Valid pairs:", report["valid_pair_count"])
    print("Median sync error:", data["median_abs_sync_error_ms"], "ms")
    print("Median translation deviation:", data["median_translation_deviation_m"], "m")
    print("Median rotation deviation:", data["median_rotation_deviation_deg"], "deg")
    print("Median baseline:", data["median_baseline_m"], "m")


if __name__ == "__main__":
    main()