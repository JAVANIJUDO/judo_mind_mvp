from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path

import cv2
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
from stereo_precision_sync_diagnostic_v1_20260806 import video_packet_pts
from stereo_precision_calibration_v1_20260806 import (
    StereoBoardDetector,
    calibrate,
    common_points,
    robust_keep_indices,
    view_epipolar_error,
)


SCAN_INTERVAL_SECONDS = 0.10
MIN_HOLD_DURATION_SECONDS = 0.65
MAX_TRANSLATION_STEP_M = 0.006
MAX_ROTATION_STEP_DEG = 1.00
MAX_HOLD_TRANSLATION_SPREAD_M = 0.015
MAX_HOLD_ROTATION_SPREAD_DEG = 2.00
MIN_HOLD_SEPARATION_SECONDS = 0.80
MIN_STEREO_HOLDS = 8
MAX_STEREO_HOLDS = 24


@dataclass
class PoseSample:
    time: float
    rotation: np.ndarray
    translation: np.ndarray
    reprojection_error: float


@dataclass
class Hold:
    start: float
    end: float
    midpoint: float
    duration: float
    sample_count: int


def scan_targets(times: np.ndarray) -> list[float]:
    start = max(2.0, float(times[0]) + 1.0)
    end = min(float(times[-1]) - 2.0, 59.0)
    if end <= start:
        raise RuntimeError("Video is too short for static-hold calibration.")
    return np.arange(start, end, SCAN_INTERVAL_SECONDS).tolist()


def orientation_targets(times: np.ndarray) -> list[float]:
    start = max(3.0, float(times[0]) + 2.0)
    end = min(float(times[-1]) - 3.0, 57.0)
    if end <= start:
        raise RuntimeError("Video is too short for orientation detection.")
    return np.linspace(start, end, 16).tolist()


def detect_pose_samples(
    frames: list[tuple[float, np.ndarray]],
    orientation: str,
    detector: BoardPoseDetector,
    matrix: np.ndarray,
    distortion: np.ndarray,
) -> list[PoseSample]:
    samples: list[PoseSample] = []
    for time_value, frame in frames:
        oriented = orient_frame(frame, orientation)
        pose = detector.pose(oriented, matrix, distortion)
        if pose is None:
            continue
        rotation, translation, error, _ = pose
        samples.append(
            PoseSample(
                time=float(time_value),
                rotation=rotation,
                translation=translation,
                reprojection_error=float(error),
            )
        )
    return samples


def is_stable_step(first: PoseSample, second: PoseSample) -> bool:
    time_gap = second.time - first.time
    if time_gap <= 0.0 or time_gap > SCAN_INTERVAL_SECONDS * 1.8:
        return False
    translation_step = float(
        np.linalg.norm(second.translation - first.translation)
    )
    rotation_step = rotation_distance_degrees(
        second.rotation, first.rotation
    )
    return (
        translation_step <= MAX_TRANSLATION_STEP_M
        and rotation_step <= MAX_ROTATION_STEP_DEG
    )


def build_holds(samples: list[PoseSample]) -> list[Hold]:
    if len(samples) < 3:
        return []

    runs: list[list[PoseSample]] = []
    current: list[PoseSample] = []

    for first, second in zip(samples[:-1], samples[1:]):
        if is_stable_step(first, second):
            if not current:
                current = [first, second]
            elif abs(current[-1].time - first.time) < 1e-6:
                current.append(second)
            else:
                runs.append(current)
                current = [first, second]
        else:
            if current:
                runs.append(current)
                current = []

    if current:
        runs.append(current)

    holds: list[Hold] = []
    for run in runs:
        start = run[0].time
        end = run[-1].time
        duration = end - start
        if duration < MIN_HOLD_DURATION_SECONDS:
            continue

        translations = np.asarray([sample.translation for sample in run])
        center_translation = np.median(translations, axis=0)
        translation_spread = np.linalg.norm(
            translations - center_translation, axis=1
        )
        center_rotation = mean_rotation([sample.rotation for sample in run])
        rotation_spread = np.asarray(
            [
                rotation_distance_degrees(sample.rotation, center_rotation)
                for sample in run
            ]
        )
        if (
            float(np.max(translation_spread)) > MAX_HOLD_TRANSLATION_SPREAD_M
            or float(np.max(rotation_spread)) > MAX_HOLD_ROTATION_SPREAD_DEG
        ):
            continue

        midpoint_target = (start + end) * 0.5
        midpoint_sample = min(
            run, key=lambda sample: abs(sample.time - midpoint_target)
        )
        hold = Hold(
            start=float(start),
            end=float(end),
            midpoint=float(midpoint_sample.time),
            duration=float(duration),
            sample_count=len(run),
        )
        if holds and hold.midpoint - holds[-1].midpoint < MIN_HOLD_SEPARATION_SECONDS:
            if hold.duration > holds[-1].duration:
                holds[-1] = hold
            continue
        holds.append(hold)

    if len(holds) > MAX_STEREO_HOLDS:
        indices = np.linspace(0, len(holds) - 1, MAX_STEREO_HOLDS, dtype=int)
        holds = [holds[int(index)] for index in indices]
    return holds


def quality_label(
    rms: float,
    median_epipolar: float,
    valid_holds: int,
    median_sync_ms: float,
) -> str:
    if (
        valid_holds >= 14
        and rms <= 1.0
        and median_epipolar <= 0.75
        and median_sync_ms <= 8.5
    ):
        return "excellent"
    if (
        valid_holds >= 10
        and rms <= 2.0
        and median_epipolar <= 1.25
        and median_sync_ms <= 8.5
    ):
        return "good"
    if (
        valid_holds >= 8
        and rms <= 3.0
        and median_epipolar <= 2.0
        and median_sync_ms <= 9.0
    ):
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

    print("Reading video timestamps...")
    times_1 = video_packet_pts(camera_1_path)
    times_2 = video_packet_pts(camera_2_path)
    print(f"Camera 1 PTS count: {len(times_1)}")
    print(f"Camera 2 PTS count: {len(times_2)}")

    pose_detector = BoardPoseDetector()
    orientation_frames_1 = nearest_frames(
        camera_1_path, orientation_targets(times_1)
    )
    orientation_frames_2 = nearest_frames(
        camera_2_path, orientation_targets(times_2)
    )
    orientation_1 = select_orientation(
        "Camera 1",
        orientation_frames_1,
        size_1,
        pose_detector,
        matrix_1,
        distortion_1,
    )
    orientation_2 = select_orientation(
        "Camera 2",
        orientation_frames_2,
        size_2,
        pose_detector,
        matrix_2,
        distortion_2,
    )

    print("Scanning camera 1 for stable ChArUco holds...")
    scan_frames = nearest_frames(camera_1_path, scan_targets(times_1))
    pose_samples = detect_pose_samples(
        scan_frames,
        orientation_1,
        pose_detector,
        matrix_1,
        distortion_1,
    )
    holds = build_holds(pose_samples)
    print(f"Pose samples with ChArUco: {len(pose_samples)}")
    print(f"Detected stable holds: {len(holds)}")
    for index, hold in enumerate(holds, start=1):
        print(
            f"Hold {index:02d}: {hold.start:.3f}-{hold.end:.3f} s "
            f"({hold.duration:.2f} s)"
        )

    if len(holds) < MIN_STEREO_HOLDS:
        raise RuntimeError(
            f"Only {len(holds)} stable holds detected; "
            f"need at least {MIN_STEREO_HOLDS}."
        )

    targets_1 = [hold.midpoint for hold in holds]
    targets_2 = [
        time_1 + intercept + slope * time_1 for time_1 in targets_1
    ]
    if min(targets_2) < float(times_2[0]) or max(targets_2) > float(times_2[-1]):
        raise RuntimeError("Audio time mapping falls outside camera 2 video range.")

    selected_1 = nearest_frames(camera_1_path, targets_1)
    selected_2 = nearest_frames(camera_2_path, targets_2)
    stereo_detector = StereoBoardDetector()

    object_points: list[np.ndarray] = []
    image_points_1: list[np.ndarray] = []
    image_points_2: list[np.ndarray] = []
    metadata: list[dict] = []

    for index, (((time_1, frame_1), (time_2, frame_2)), hold) in enumerate(
        zip(zip(selected_1, selected_2), holds), start=1
    ):
        oriented_1 = orient_frame(frame_1, orientation_1)
        oriented_2 = orient_frame(frame_2, orientation_2)
        observation_1 = stereo_detector.observation(oriented_1)
        observation_2 = stereo_detector.observation(oriented_2)
        if observation_1 is None or observation_2 is None:
            print(f"Hold {index:02d}: rejected (board not detected in both views)")
            continue

        common = common_points(
            observation_1,
            observation_2,
            stereo_detector.object_corners,
        )
        if common is None:
            print(f"Hold {index:02d}: rejected (too few common corners)")
            continue

        object_view, points_1, points_2 = common
        mapped_time_2 = time_1 + intercept + slope * time_1
        sync_error_ms = (time_2 - mapped_time_2) * 1000.0
        object_points.append(object_view)
        image_points_1.append(points_1)
        image_points_2.append(points_2)
        metadata.append(
            {
                "hold_index": index,
                "hold_start_seconds": hold.start,
                "hold_end_seconds": hold.end,
                "camera_1_pts_seconds": float(time_1),
                "camera_2_pts_seconds": float(time_2),
                "sync_error_ms": float(sync_error_ms),
                "common_corner_count": len(object_view),
            }
        )
        print(
            f"Hold {index:02d}: accepted, common corners {len(object_view)}, "
            f"sync {sync_error_ms:+.3f} ms"
        )

    if len(object_points) < MIN_STEREO_HOLDS:
        raise RuntimeError(
            f"Only {len(object_points)} holds were valid in both cameras."
        )

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
    initial_rms, _, _, _, initial_fundamental = initial
    initial_epipolar = np.asarray(
        [
            view_epipolar_error(points_1, points_2, initial_fundamental)
            for points_1, points_2 in zip(image_points_1, image_points_2)
        ],
        dtype=np.float64,
    )
    keep_indices = robust_keep_indices(initial_epipolar)
    rejected_count = len(object_points) - len(keep_indices)

    final_object = [object_points[index] for index in keep_indices]
    final_image_1 = [image_points_1[index] for index in keep_indices]
    final_image_2 = [image_points_2[index] for index in keep_indices]
    final_metadata = [metadata[index] for index in keep_indices]
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
    epipolar_errors = np.asarray(
        [
            view_epipolar_error(points_1, points_2, fundamental)
            for points_1, points_2 in zip(final_image_1, final_image_2)
        ],
        dtype=np.float64,
    )
    sync_errors = np.abs(
        np.asarray([item["sync_error_ms"] for item in final_metadata])
    )
    median_epipolar = float(np.median(epipolar_errors))
    median_sync = float(np.median(sync_errors))
    quality = quality_label(
        rms, median_epipolar, len(final_object), median_sync
    )

    report = {
        "status": "completed",
        "quality": quality,
        "method": "static_hold_charuco_audio_synchronized_stereo_calibration",
        "camera_orientations": {
            "camera_1": orientation_1,
            "camera_2": orientation_2,
        },
        "hold_detection": {
            "detected_holds": len(holds),
            "valid_stereo_holds_before_rejection": len(object_points),
            "valid_stereo_holds": len(final_object),
            "robustly_rejected_holds": rejected_count,
        },
        "calibration": {
            "initial_rms_reprojection_error_px": initial_rms,
            "rms_reprojection_error_px": rms,
            "rotation_matrix": rotation.tolist(),
            "translation_m": translation.tolist(),
            "essential_matrix": essential.tolist(),
            "fundamental_matrix": fundamental.tolist(),
            "baseline_m": float(np.linalg.norm(translation)),
        },
        "validation": {
            "median_epipolar_error_px": median_epipolar,
            "max_epipolar_error_px": float(np.max(epipolar_errors)),
            "median_abs_sync_error_ms": median_sync,
            "max_abs_sync_error_ms": float(np.max(sync_errors)),
        },
        "holds": final_metadata,
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_static_hold_extrinsics.json"
    )
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    print(f"Initial stereo RMS: {initial_rms:.6f} px")
    print(f"Robustly rejected holds: {rejected_count}")
    print(f"Calibration saved: {output}")
    print("\nJudo Mind Static-Hold Stereo Calibration Complete")
    print("Quality:", quality)
    print("Final stereo RMS:", rms, "px")
    print("Median epipolar error:", median_epipolar, "px")
    print("Valid stereo holds:", len(final_object))
    print("Median sync error:", median_sync, "ms")
    print("Camera baseline:", float(np.linalg.norm(translation)), "m")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind static-hold ChArUco stereo calibration"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--audio-sync", type=Path, required=True)
    args = parser.parse_args()

    print("Judo Mind Static-Hold Stereo Calibration")
    run(
        args.camera_1,
        args.camera_2,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.audio_sync,
    )


if __name__ == "__main__":
    main()