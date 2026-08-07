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
    rotation_distance_degrees,
)
from stereo_precision_sync_diagnostic_v1_20260806 import video_packet_pts
from stereo_static_hold_calibration_v1_20260807 import (
    build_holds,
    detect_pose_samples,
    scan_targets,
)


CAMERA_1_ORIENTATION = "clockwise"
CAMERA_2_ORIENTATION = "rotate180"
PROBE_DELTA_SECONDS = 0.20
MAX_PROBE_TRANSLATION_M = 0.012
MAX_PROBE_ROTATION_DEG = 2.0


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


def pose_at_frames(
    frames: list[tuple[float, np.ndarray]],
    orientation: str,
    detector: BoardPoseDetector,
    matrix: np.ndarray,
    distortion: np.ndarray,
) -> list[tuple[float, np.ndarray, np.ndarray, float] | None]:
    results: list[tuple[float, np.ndarray, np.ndarray, float] | None] = []
    for timestamp, frame in frames:
        pose = detector.pose(orient(frame, orientation), matrix, distortion)
        if pose is None:
            results.append(None)
            continue
        rotation, translation, reprojection, _ = pose
        results.append(
            (
                float(timestamp),
                rotation,
                translation,
                float(reprojection),
            )
        )
    return results


def probe_motion(
    poses: list[tuple[float, np.ndarray, np.ndarray, float] | None],
) -> tuple[bool, float | None, float | None]:
    if len(poses) != 3 or any(item is None for item in poses):
        return False, None, None

    first = poses[0]
    middle = poses[1]
    last = poses[2]
    assert first is not None and middle is not None and last is not None

    translation_span = max(
        float(np.linalg.norm(first[2] - middle[2])),
        float(np.linalg.norm(last[2] - middle[2])),
        float(np.linalg.norm(last[2] - first[2])),
    )
    rotation_span = max(
        rotation_distance_degrees(first[1], middle[1]),
        rotation_distance_degrees(last[1], middle[1]),
        rotation_distance_degrees(last[1], first[1]),
    )
    stable = (
        translation_span <= MAX_PROBE_TRANSLATION_M
        and rotation_span <= MAX_PROBE_ROTATION_DEG
    )
    return stable, translation_span, rotation_span


def run(
    camera_1_path: Path,
    camera_2_path: Path,
    camera_1_intrinsics_path: Path,
    camera_2_intrinsics_path: Path,
    audio_sync_path: Path,
) -> dict:
    matrix_1, distortion_1, _ = load_intrinsics(camera_1_intrinsics_path)
    matrix_2, distortion_2, _ = load_intrinsics(camera_2_intrinsics_path)
    audio_sync = load_json(audio_sync_path)
    mapping = audio_sync["time_mapping"]
    intercept = float(mapping["intercept_seconds"])
    slope = float(mapping["slope_seconds_per_second"])

    print("Reading PTS timelines...")
    times_1 = video_packet_pts(camera_1_path)
    times_2 = video_packet_pts(camera_2_path)
    detector = BoardPoseDetector()

    print("Detecting Camera 1 stable holds...")
    scan_frames_1 = nearest_frames(camera_1_path, scan_targets(times_1))
    samples_1 = detect_pose_samples(
        scan_frames_1,
        CAMERA_1_ORIENTATION,
        detector,
        matrix_1,
        distortion_1,
    )
    holds = build_holds(samples_1)
    print(f"Camera 1 stable holds: {len(holds)}")
    if not holds:
        raise RuntimeError("No Camera 1 holds detected.")

    probe_targets_2: list[float] = []
    expected_centers_2: list[float] = []
    for hold in holds:
        center_2 = hold.midpoint + intercept + slope * hold.midpoint
        expected_centers_2.append(center_2)
        probe_targets_2.extend(
            [
                center_2 - PROBE_DELTA_SECONDS,
                center_2,
                center_2 + PROBE_DELTA_SECONDS,
            ]
        )

    if min(probe_targets_2) < float(times_2[0]) or max(probe_targets_2) > float(times_2[-1]):
        raise RuntimeError("Camera 2 probe times fall outside video PTS range.")

    print("Decoding Camera 2 hold probes...")
    frames_2 = nearest_frames(camera_2_path, probe_targets_2)
    poses_2 = pose_at_frames(
        frames_2,
        CAMERA_2_ORIENTATION,
        detector,
        matrix_2,
        distortion_2,
    )

    results: list[dict] = []
    stable_count = 0
    for index, hold in enumerate(holds):
        group = poses_2[index * 3 : index * 3 + 3]
        stable, translation_span, rotation_span = probe_motion(group)
        if stable:
            stable_count += 1

        status = "STABLE" if stable else "NOT_STABLE"
        translation_text = (
            f"{translation_span * 1000.0:.2f} mm"
            if translation_span is not None
            else "n/a"
        )
        rotation_text = (
            f"{rotation_span:.3f} deg" if rotation_span is not None else "n/a"
        )
        print(
            f"Hold {index + 1:02d}: Camera1 center {hold.midpoint:.3f} s -> "
            f"Camera2 expected {expected_centers_2[index]:.3f} s | {status} | "
            f"motion {translation_text}, {rotation_text}"
        )
        results.append(
            {
                "hold_index": index + 1,
                "camera_1_midpoint_seconds": hold.midpoint,
                "camera_2_expected_seconds": expected_centers_2[index],
                "camera_2_stable": stable,
                "translation_span_m": translation_span,
                "rotation_span_deg": rotation_span,
            }
        )

    ratio = stable_count / len(holds)
    if ratio >= 0.875:
        quality = "audio_video_pairing_supported"
    elif ratio >= 0.625:
        quality = "pairing_review_required"
    else:
        quality = "audio_video_pairing_rejected"

    report = {
        "status": "completed",
        "quality": quality,
        "method": "camera2_motion_probe_around_audio_mapped_hold_centers",
        "probe_delta_seconds": PROBE_DELTA_SECONDS,
        "hold_count": len(holds),
        "stable_camera_2_hold_count": stable_count,
        "stable_ratio": ratio,
        "results": results,
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_hold_pairing_diagnostic.json"
    )
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    print(f"Diagnostic saved: {output}")
    print("\nJudo Mind Stereo Hold Pairing Diagnostic Complete")
    print("Quality:", quality)
    print("Camera 1 holds:", len(holds))
    print("Camera 2 stable at mapped times:", stable_count)
    print("Stable ratio:", ratio)
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind stereo static-hold A/V pairing diagnostic"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--audio-sync", type=Path, required=True)
    args = parser.parse_args()

    print("Judo Mind Stereo Hold Pairing Diagnostic")
    run(
        args.camera_1,
        args.camera_2,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.audio_sync,
    )


if __name__ == "__main__":
    main()