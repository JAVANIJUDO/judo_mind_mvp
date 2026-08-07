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
    mean_rotation,
    nearest_frames,
    rotation_distance_degrees,
)


CAMERA_1_ORIENTATION = "clockwise"
CAMERA_2_ORIENTATION = "rotate180"
MAX_SINGLE_CAMERA_REPROJECTION_PX = 1.50


def orient(frame: np.ndarray, orientation: str) -> np.ndarray:
    if orientation == "clockwise":
        return cv2.rotate(frame, cv2.ROTATE_90_CLOCKWISE)
    if orientation == "counterclockwise":
        return cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
    if orientation == "rotate180":
        return cv2.rotate(frame, cv2.ROTATE_180)
    if orientation == "none":
        return frame
    raise ValueError(f"Unsupported orientation: {orientation}")


def relative_transform(
    rotation_1: np.ndarray,
    translation_1: np.ndarray,
    rotation_2: np.ndarray,
    translation_2: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    relative_rotation = rotation_2 @ rotation_1.T
    relative_translation = (
        translation_2 - relative_rotation @ translation_1
    )
    return relative_rotation, relative_translation


def robust_center_translation(translations: list[np.ndarray]) -> np.ndarray:
    return np.median(np.asarray(translations, dtype=np.float64), axis=0)


def run(
    camera_1_path: Path,
    camera_2_path: Path,
    camera_1_intrinsics_path: Path,
    camera_2_intrinsics_path: Path,
    pairing_report_path: Path,
) -> dict:
    matrix_1, distortion_1, _ = load_intrinsics(camera_1_intrinsics_path)
    matrix_2, distortion_2, _ = load_intrinsics(camera_2_intrinsics_path)
    pairing = load_json(pairing_report_path)

    paired_results = [
        item
        for item in pairing["results"]
        if bool(item.get("camera_2_stable", False))
    ]
    print(f"Stable paired holds from previous diagnostic: {len(paired_results)}")
    if len(paired_results) < 4:
        raise RuntimeError("Too few stable paired holds for geometry diagnostic.")

    targets_1 = [
        float(item["camera_1_midpoint_seconds"]) for item in paired_results
    ]
    targets_2 = [
        float(item["camera_2_expected_seconds"]) for item in paired_results
    ]

    print("Decoding paired Camera 1 frames...")
    frames_1 = nearest_frames(camera_1_path, targets_1)
    print("Decoding paired Camera 2 frames...")
    frames_2 = nearest_frames(camera_2_path, targets_2)

    detector = BoardPoseDetector()
    rotations: list[np.ndarray] = []
    translations: list[np.ndarray] = []
    reprojection_1: list[float] = []
    reprojection_2: list[float] = []
    observations: list[dict] = []

    for pair, (frame_1_data, frame_2_data) in zip(
        paired_results, zip(frames_1, frames_2)
    ):
        time_1, frame_1 = frame_1_data
        time_2, frame_2 = frame_2_data
        pose_1 = detector.pose(
            orient(frame_1, CAMERA_1_ORIENTATION),
            matrix_1,
            distortion_1,
        )
        pose_2 = detector.pose(
            orient(frame_2, CAMERA_2_ORIENTATION),
            matrix_2,
            distortion_2,
        )

        hold_index = int(pair["hold_index"])
        if pose_1 is None or pose_2 is None:
            print(f"Hold {hold_index:02d}: pose unavailable")
            continue

        rotation_1, translation_1, error_1, corners_1 = pose_1
        rotation_2, translation_2, error_2, corners_2 = pose_2
        relative_rotation, relative_translation = relative_transform(
            rotation_1,
            translation_1,
            rotation_2,
            translation_2,
        )
        baseline = float(np.linalg.norm(relative_translation))

        rotations.append(relative_rotation)
        translations.append(relative_translation)
        reprojection_1.append(float(error_1))
        reprojection_2.append(float(error_2))
        observations.append(
            {
                "hold_index": hold_index,
                "camera_1_pts_seconds": float(time_1),
                "camera_2_pts_seconds": float(time_2),
                "camera_1_reprojection_px": float(error_1),
                "camera_2_reprojection_px": float(error_2),
                "camera_1_corner_count": int(corners_1),
                "camera_2_corner_count": int(corners_2),
                "baseline_m": baseline,
                "relative_rotation_matrix": relative_rotation.tolist(),
                "relative_translation_m": relative_translation.tolist(),
            }
        )
        print(
            f"Hold {hold_index:02d}: reproj {error_1:.3f}/{error_2:.3f} px | "
            f"baseline {baseline:.4f} m"
        )

    if len(rotations) < 4:
        raise RuntimeError("Too few valid paired poses for geometry analysis.")

    center_rotation = mean_rotation(rotations)
    center_translation = robust_center_translation(translations)
    translation_deviations = np.asarray(
        [
            float(np.linalg.norm(item - center_translation))
            for item in translations
        ],
        dtype=np.float64,
    )
    rotation_deviations = np.asarray(
        [
            rotation_distance_degrees(item, center_rotation)
            for item in rotations
        ],
        dtype=np.float64,
    )
    baselines = np.asarray(
        [float(np.linalg.norm(item)) for item in translations],
        dtype=np.float64,
    )
    reproj_1_array = np.asarray(reprojection_1, dtype=np.float64)
    reproj_2_array = np.asarray(reprojection_2, dtype=np.float64)

    for observation, translation_deviation, rotation_deviation in zip(
        observations, translation_deviations, rotation_deviations
    ):
        observation["translation_deviation_from_center_m"] = float(
            translation_deviation
        )
        observation["rotation_deviation_from_center_deg"] = float(
            rotation_deviation
        )
        print(
            f"Hold {observation['hold_index']:02d}: geometry deviation "
            f"{translation_deviation * 1000.0:.2f} mm / "
            f"{rotation_deviation:.3f} deg"
        )

    median_reproj_1 = float(np.median(reproj_1_array))
    median_reproj_2 = float(np.median(reproj_2_array))
    median_translation = float(np.median(translation_deviations))
    median_rotation = float(np.median(rotation_deviations))

    intrinsics_supported = (
        median_reproj_1 <= MAX_SINGLE_CAMERA_REPROJECTION_PX
        and median_reproj_2 <= MAX_SINGLE_CAMERA_REPROJECTION_PX
    )

    if intrinsics_supported and median_translation <= 0.008 and median_rotation <= 1.0:
        quality = "geometry_consistent"
    elif intrinsics_supported:
        quality = "intrinsics_supported_extrinsics_inconsistent"
    else:
        quality = "intrinsics_review_required"

    report = {
        "status": "completed",
        "quality": quality,
        "method": "independent_charuco_pose_relative_geometry_consistency",
        "valid_hold_count": len(rotations),
        "summary": {
            "median_camera_1_reprojection_px": median_reproj_1,
            "median_camera_2_reprojection_px": median_reproj_2,
            "median_translation_deviation_m": median_translation,
            "median_rotation_deviation_deg": median_rotation,
            "median_baseline_m": float(np.median(baselines)),
            "baseline_min_m": float(np.min(baselines)),
            "baseline_max_m": float(np.max(baselines)),
        },
        "observations": observations,
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_hold_geometry_diagnostic.json"
    )
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    print(f"Diagnostic saved: {output}")
    print("\nJudo Mind Stereo Hold Geometry Diagnostic Complete")
    print("Quality:", quality)
    print("Valid holds:", len(rotations))
    print("Median Camera 1 reprojection:", median_reproj_1, "px")
    print("Median Camera 2 reprojection:", median_reproj_2, "px")
    print("Median translation deviation:", median_translation, "m")
    print("Median rotation deviation:", median_rotation, "deg")
    print("Median baseline:", float(np.median(baselines)), "m")
    print("Baseline range:", float(np.min(baselines)), "to", float(np.max(baselines)), "m")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind stereo hold geometry diagnostic"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--pairing-report", type=Path, required=True)
    args = parser.parse_args()

    print("Judo Mind Stereo Hold Geometry Diagnostic")
    run(
        args.camera_1,
        args.camera_2,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.pairing_report,
    )


if __name__ == "__main__":
    main()