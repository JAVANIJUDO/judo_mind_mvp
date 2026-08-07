from __future__ import annotations

"""Memory-safe independent dual-camera ChArUco hold timeline diagnostic."""

import argparse
import json
from pathlib import Path

import numpy as np

import stereo_static_hold_calibration_v1_20260807 as base
from stereo_video_offset_search_v1_20260807 import (
    decode_pose_targets,
    scale_intrinsics,
)


CAMERA_1_ORIENTATION = "rotate180"
CAMERA_2_ORIENTATION = "clockwise"
CAMERA_1_SCALE = 1.0
CAMERA_2_SCALE = 0.5


def detect_holds_streaming(
    path: Path,
    matrix: np.ndarray,
    distortion: np.ndarray,
    orientation: str,
    detector: object,
    scale: float,
) -> tuple[list[base.Hold], int]:
    """Decode sequentially and retain poses only, never a list of 4K frames."""
    times = base.video_packet_pts(path)
    targets = base.scan_targets(times)
    requests = [(target, 0, index) for index, target in enumerate(targets)]
    effective_matrix = scale_intrinsics(matrix, scale)
    poses = decode_pose_targets(
        path,
        requests,
        orientation,
        detector,
        effective_matrix,
        distortion,
        scale,
    )

    samples: list[base.PoseSample] = []
    for index in range(len(targets)):
        pose = poses.get((0, index))
        if pose is None:
            continue
        chosen_time, rotation, translation, error = pose
        samples.append(
            base.PoseSample(
                time=float(chosen_time),
                rotation=rotation,
                translation=translation,
                reprojection_error=float(error),
            )
        )

    return base.build_holds(samples), len(samples)


def hold_dict(hold: base.Hold) -> dict:
    return {
        "start_seconds": hold.start,
        "end_seconds": hold.end,
        "midpoint_seconds": hold.midpoint,
        "duration_seconds": hold.duration,
        "sample_count": hold.sample_count,
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind memory-safe dual-camera hold timeline diagnostic"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--audio-sync", type=Path, required=True)
    args = parser.parse_args()

    matrix_1, distortion_1, _ = base.load_intrinsics(args.camera_1_intrinsics)
    matrix_2, distortion_2, _ = base.load_intrinsics(args.camera_2_intrinsics)
    audio_sync = base.load_json(args.audio_sync)
    mapping = audio_sync["time_mapping"]
    intercept = float(mapping["intercept_seconds"])
    slope = float(mapping["slope_seconds_per_second"])

    detector = base.BoardPoseDetector()

    print("Judo Mind Memory-Safe Dual-Hold Timeline Diagnostic")
    print("Scanning Camera 1 independently (streaming)...")
    holds_1, samples_1 = detect_holds_streaming(
        args.camera_1,
        matrix_1,
        distortion_1,
        CAMERA_1_ORIENTATION,
        detector,
        CAMERA_1_SCALE,
    )
    print(f"Camera 1 ChArUco pose samples: {samples_1}")
    print(f"Camera 1 stable holds: {len(holds_1)}")
    for index, hold in enumerate(holds_1, start=1):
        print(
            f"C1 Hold {index:02d}: {hold.start:.3f}-{hold.end:.3f} s "
            f"| center {hold.midpoint:.3f} | duration {hold.duration:.2f} s"
        )

    print("\nScanning Camera 2 independently (streaming, half-resolution pose)...")
    holds_2, samples_2 = detect_holds_streaming(
        args.camera_2,
        matrix_2,
        distortion_2,
        CAMERA_2_ORIENTATION,
        detector,
        CAMERA_2_SCALE,
    )
    print(f"Camera 2 ChArUco pose samples: {samples_2}")
    print(f"Camera 2 stable holds: {len(holds_2)}")
    for index, hold in enumerate(holds_2, start=1):
        print(
            f"C2 Hold {index:02d}: {hold.start:.3f}-{hold.end:.3f} s "
            f"| center {hold.midpoint:.3f} | duration {hold.duration:.2f} s"
        )

    comparisons: list[dict] = []
    print("\nAudio-mapped C1 centers versus nearest independent C2 hold centers:")
    for index, hold_1 in enumerate(holds_1, start=1):
        mapped = hold_1.midpoint + intercept + slope * hold_1.midpoint
        if not holds_2:
            break
        nearest_index, nearest = min(
            enumerate(holds_2),
            key=lambda item: abs(item[1].midpoint - mapped),
        )
        correction = nearest.midpoint - mapped
        print(
            f"C1 Hold {index:02d} -> audio {mapped:.3f} s -> "
            f"C2 Hold {nearest_index + 1:02d} center {nearest.midpoint:.3f} s "
            f"| correction {correction:+.3f} s"
        )
        comparisons.append(
            {
                "camera_1_hold_index": index,
                "camera_1_midpoint_seconds": hold_1.midpoint,
                "audio_mapped_camera_2_seconds": mapped,
                "nearest_camera_2_hold_index": nearest_index + 1,
                "camera_2_hold_midpoint_seconds": nearest.midpoint,
                "extra_video_correction_seconds": correction,
            }
        )

    corrections = np.asarray(
        [item["extra_video_correction_seconds"] for item in comparisons],
        dtype=np.float64,
    )
    median_correction = float(np.median(corrections)) if corrections.size else None
    mad_correction = (
        float(np.median(np.abs(corrections - median_correction)))
        if corrections.size
        else None
    )

    report = {
        "status": "completed",
        "method": "memory_safe_independent_dual_camera_static_hold_timeline",
        "camera_orientations": {
            "camera_1": CAMERA_1_ORIENTATION,
            "camera_2": CAMERA_2_ORIENTATION,
        },
        "camera_1": {
            "pose_samples": samples_1,
            "holds": [hold_dict(hold) for hold in holds_1],
        },
        "camera_2": {
            "pose_samples": samples_2,
            "holds": [hold_dict(hold) for hold in holds_2],
        },
        "comparisons": comparisons,
        "median_extra_video_correction_seconds": median_correction,
        "mad_extra_video_correction_seconds": mad_correction,
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_dual_hold_timeline_diagnostic_v2.json"
    )
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )

    print(f"\nDiagnostic saved: {output}")
    print("Judo Mind Dual-Hold Timeline Diagnostic Complete")
    print("Camera 1 holds:", len(holds_1))
    print("Camera 2 holds:", len(holds_2))
    print("Median extra video correction:", median_correction, "s")
    print("Correction MAD:", mad_correction, "s")


if __name__ == "__main__":
    main()