from __future__ import annotations

import argparse
import json
from pathlib import Path

import av
import cv2
import numpy as np

from stereo_audio_sync_diagnostic_v2 import (
    BoardPoseDetector,
    frame_time,
    load_intrinsics,
    load_json,
    mean_rotation,
    nearest_frames,
    rotation_distance_degrees,
)


CAMERA_1_ORIENTATION = "clockwise"
CAMERA_2_ORIENTATION = "rotate180"
CAMERA_2_SCALE = 0.50
OFFSET_MIN_SECONDS = -3.0
OFFSET_MAX_SECONDS = 3.0
OFFSET_STEP_SECONDS = 0.10
MIN_VALID_HOLDS = 4


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


def scale_intrinsics(matrix: np.ndarray, scale: float) -> np.ndarray:
    result = matrix.copy().astype(np.float64)
    result[0, 0] *= scale
    result[1, 1] *= scale
    result[0, 2] *= scale
    result[1, 2] *= scale
    return result


def resize_for_pose(frame: np.ndarray, scale: float) -> np.ndarray:
    if abs(scale - 1.0) < 1e-9:
        return frame
    return cv2.resize(
        frame,
        None,
        fx=scale,
        fy=scale,
        interpolation=cv2.INTER_AREA,
    )


def pose_from_frame(
    frame: np.ndarray,
    orientation: str,
    detector: BoardPoseDetector,
    matrix: np.ndarray,
    distortion: np.ndarray,
    scale: float = 1.0,
) -> tuple[np.ndarray, np.ndarray, float, int] | None:
    prepared = orient(frame, orientation)
    prepared = resize_for_pose(prepared, scale)
    return detector.pose(prepared, matrix, distortion)


def decode_pose_targets(
    path: Path,
    requests: list[tuple[float, int, int]],
    orientation: str,
    detector: BoardPoseDetector,
    matrix: np.ndarray,
    distortion: np.ndarray,
    scale: float,
) -> dict[tuple[int, int], tuple[float, np.ndarray, np.ndarray, float] | None]:
    """Decode ordered target PTS values and retain pose only, never 4K frames."""
    ordered = sorted(requests, key=lambda item: item[0])
    results: dict[
        tuple[int, int], tuple[float, np.ndarray, np.ndarray, float] | None
    ] = {}
    if not ordered:
        return results

    container = av.open(str(path))
    try:
        if not container.streams.video:
            raise RuntimeError(f"No video stream: {path}")
        stream = container.streams.video[0]
        request_index = 0
        previous: av.VideoFrame | None = None
        previous_time: float | None = None
        decoded_count = 0
        pose_count = 0

        for current in container.decode(stream):
            current_time = frame_time(current)
            decoded_count += 1

            while (
                request_index < len(ordered)
                and current_time >= ordered[request_index][0]
            ):
                target, offset_index, hold_index = ordered[request_index]
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

                frame_array = chosen.to_ndarray(format="bgr24")
                pose = pose_from_frame(
                    frame_array,
                    orientation,
                    detector,
                    matrix,
                    distortion,
                    scale,
                )
                if pose is None:
                    results[(offset_index, hold_index)] = None
                else:
                    rotation, translation, error, _ = pose
                    results[(offset_index, hold_index)] = (
                        float(chosen_time),
                        rotation,
                        translation,
                        float(error),
                    )
                    pose_count += 1

                request_index += 1
                if request_index % 50 == 0:
                    print(
                        f"Camera 2 offset probes: {request_index}/{len(ordered)}"
                    )

            if request_index >= len(ordered):
                break

            previous = current
            previous_time = current_time

        if request_index != len(ordered):
            raise RuntimeError(
                f"Decoded {request_index}/{len(ordered)} requested Camera 2 probes."
            )
        print(f"Camera 2 decoded frames traversed: {decoded_count}")
        print(f"Camera 2 probes with ChArUco pose: {pose_count}")
        return results
    finally:
        container.close()


def relative_transform(
    rotation_1: np.ndarray,
    translation_1: np.ndarray,
    rotation_2: np.ndarray,
    translation_2: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    rotation = rotation_2 @ rotation_1.T
    translation = translation_2 - rotation @ translation_1
    return rotation, translation


def candidate_metrics(
    camera_1_poses: list[tuple[np.ndarray, np.ndarray] | None],
    camera_2_poses: dict[
        tuple[int, int], tuple[float, np.ndarray, np.ndarray, float] | None
    ],
    offset_index: int,
) -> dict | None:
    rotations: list[np.ndarray] = []
    translations: list[np.ndarray] = []
    reprojections: list[float] = []

    for hold_index, pose_1 in enumerate(camera_1_poses):
        pose_2 = camera_2_poses.get((offset_index, hold_index))
        if pose_1 is None or pose_2 is None:
            continue
        rotation_1, translation_1 = pose_1
        _, rotation_2, translation_2, reprojection = pose_2
        relative_rotation, relative_translation = relative_transform(
            rotation_1,
            translation_1,
            rotation_2,
            translation_2,
        )
        rotations.append(relative_rotation)
        translations.append(relative_translation)
        reprojections.append(reprojection)

    if len(rotations) < MIN_VALID_HOLDS:
        return None

    center_rotation = mean_rotation(rotations)
    translation_array = np.asarray(translations, dtype=np.float64)
    center_translation = np.median(translation_array, axis=0)
    translation_deviation = np.linalg.norm(
        translation_array - center_translation, axis=1
    )
    rotation_deviation = np.asarray(
        [
            rotation_distance_degrees(rotation, center_rotation)
            for rotation in rotations
        ],
        dtype=np.float64,
    )
    median_translation = float(np.median(translation_deviation))
    median_rotation = float(np.median(rotation_deviation))
    baselines = np.linalg.norm(translation_array, axis=1)

    # Dimensionless ranking objective. The valid-hold penalty prevents an
    # apparently clean result that is based on too few board observations.
    score = (
        median_translation / 0.010
        + median_rotation / 1.0
        + (len(camera_1_poses) - len(rotations)) * 0.75
    )
    return {
        "valid_holds": len(rotations),
        "score": float(score),
        "median_translation_deviation_m": median_translation,
        "median_rotation_deviation_deg": median_rotation,
        "median_baseline_m": float(np.median(baselines)),
        "median_camera_2_reprojection_px": float(np.median(reprojections)),
    }


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
    if len(paired_results) < MIN_VALID_HOLDS:
        raise RuntimeError("Too few paired holds for video-offset search.")

    detector = BoardPoseDetector()
    targets_1 = [
        float(item["camera_1_midpoint_seconds"]) for item in paired_results
    ]
    audio_targets_2 = [
        float(item["camera_2_expected_seconds"]) for item in paired_results
    ]

    print("Decoding Camera 1 reference holds...")
    frames_1 = nearest_frames(camera_1_path, targets_1)
    camera_1_poses: list[tuple[np.ndarray, np.ndarray] | None] = []
    for _, frame in frames_1:
        pose = pose_from_frame(
            frame,
            CAMERA_1_ORIENTATION,
            detector,
            matrix_1,
            distortion_1,
        )
        if pose is None:
            camera_1_poses.append(None)
        else:
            rotation, translation, _, _ = pose
            camera_1_poses.append((rotation, translation))

    offsets = np.arange(
        OFFSET_MIN_SECONDS,
        OFFSET_MAX_SECONDS + OFFSET_STEP_SECONDS * 0.5,
        OFFSET_STEP_SECONDS,
        dtype=np.float64,
    )
    requests: list[tuple[float, int, int]] = []
    for offset_index, offset in enumerate(offsets):
        for hold_index, base_time in enumerate(audio_targets_2):
            target = base_time + float(offset)
            if target > 0.0:
                requests.append((target, offset_index, hold_index))

    scaled_matrix_2 = scale_intrinsics(matrix_2, CAMERA_2_SCALE)
    print(
        f"Searching {len(offsets)} video-offset candidates "
        f"from {OFFSET_MIN_SECONDS:+.1f} to {OFFSET_MAX_SECONDS:+.1f} s..."
    )
    camera_2_poses = decode_pose_targets(
        camera_2_path,
        requests,
        CAMERA_2_ORIENTATION,
        detector,
        scaled_matrix_2,
        distortion_2,
        CAMERA_2_SCALE,
    )

    candidates: list[dict] = []
    for offset_index, offset in enumerate(offsets):
        metrics = candidate_metrics(
            camera_1_poses,
            camera_2_poses,
            offset_index,
        )
        if metrics is None:
            continue
        candidates.append(
            {
                "video_offset_correction_seconds": float(offset),
                **metrics,
            }
        )

    if not candidates:
        raise RuntimeError("No valid video-offset candidate could be evaluated.")

    candidates.sort(key=lambda item: item["score"])
    print("\nBest coarse video-offset candidates:")
    for rank, item in enumerate(candidates[:10], start=1):
        print(
            f"{rank:02d}. correction {item['video_offset_correction_seconds']:+.3f} s | "
            f"holds {item['valid_holds']} | "
            f"T-dev {item['median_translation_deviation_m'] * 1000.0:.2f} mm | "
            f"R-dev {item['median_rotation_deviation_deg']:.3f} deg | "
            f"score {item['score']:.3f}"
        )

    best = candidates[0]
    report = {
        "status": "completed",
        "method": "coarse_geometric_video_latency_search_around_audio_sync",
        "camera_2_pose_scale": CAMERA_2_SCALE,
        "search": {
            "minimum_seconds": OFFSET_MIN_SECONDS,
            "maximum_seconds": OFFSET_MAX_SECONDS,
            "step_seconds": OFFSET_STEP_SECONDS,
        },
        "best_candidate": best,
        "top_candidates": candidates[:10],
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "stereo_video_offset_search.json"
    )
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    print(f"\nDiagnostic saved: {output}")
    print("Judo Mind Video Offset Search Complete")
    print(
        "Best correction:",
        best["video_offset_correction_seconds"],
        "s relative to audio mapping",
    )
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind geometric video latency search"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument("--pairing-report", type=Path, required=True)
    args = parser.parse_args()

    print("Judo Mind Geometric Video Offset Search")
    run(
        args.camera_1,
        args.camera_2,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.pairing_report,
    )


if __name__ == "__main__":
    main()