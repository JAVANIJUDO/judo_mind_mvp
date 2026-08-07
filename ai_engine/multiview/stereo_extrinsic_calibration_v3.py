from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import cv2
import numpy as np


SQUARES_X = 7
SQUARES_Y = 5
SQUARE_LENGTH = 0.025
MARKER_LENGTH = 0.018
MINIMUM_COMMON_CORNERS = 10
MINIMUM_STEREO_VIEWS = 12


class JudoStereoCalibrator:
    """ChArUco stereo/extrinsic calibration for Judo Mind."""

    def __init__(
        self,
        sample_interval_seconds: float = 0.35,
        maximum_sync_offset_seconds: float = 6.0,
    ) -> None:
        self.sample_interval_seconds = sample_interval_seconds
        self.maximum_sync_offset_seconds = maximum_sync_offset_seconds

        dictionary = cv2.aruco.getPredefinedDictionary(
            cv2.aruco.DICT_6X6_250
        )
        self.board = cv2.aruco.CharucoBoard(
            (SQUARES_X, SQUARES_Y),
            SQUARE_LENGTH,
            MARKER_LENGTH,
            dictionary,
        )
        self.detector = cv2.aruco.CharucoDetector(self.board)
        self.board_corners = np.asarray(
            self.board.getChessboardCorners(), dtype=np.float64
        )

    @staticmethod
    def _load_intrinsics(path: Path) -> dict[str, Any]:
        data = json.loads(path.read_text(encoding="utf-8"))
        calibration = data["calibration"]
        return {
            "report": data,
            "size": (
                int(data["image_size"]["width"]),
                int(data["image_size"]["height"]),
            ),
            "matrix": np.asarray(
                calibration["camera_matrix"], dtype=np.float64
            ),
            "distortion": np.asarray(
                calibration["distortion_coefficients"], dtype=np.float64
            ).reshape(1, -1),
        }

    @staticmethod
    def _video_info(capture: cv2.VideoCapture) -> dict[str, float | int]:
        fps = float(capture.get(cv2.CAP_PROP_FPS))
        if fps <= 0:
            fps = 30.0
        frames = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))
        return {
            "width": int(capture.get(cv2.CAP_PROP_FRAME_WIDTH)),
            "height": int(capture.get(cv2.CAP_PROP_FRAME_HEIGHT)),
            "fps": fps,
            "frames": frames,
            "duration": frames / fps if frames > 0 else 0.0,
        }

    @staticmethod
    def _read_at(
        capture: cv2.VideoCapture,
        seconds: float,
    ) -> np.ndarray | None:
        capture.set(cv2.CAP_PROP_POS_MSEC, max(0.0, seconds) * 1000.0)
        success, frame = capture.read()
        return frame if success else None

    def _detect(
        self,
        frame: np.ndarray,
    ) -> tuple[np.ndarray, np.ndarray] | None:
        corners, ids, _, _ = self.detector.detectBoard(frame)
        if corners is None or ids is None:
            return None
        ids_array = np.asarray(ids, dtype=np.int32).reshape(-1)
        corners_array = np.asarray(corners, dtype=np.float64).reshape(-1, 2)
        if len(ids_array) < MINIMUM_COMMON_CORNERS:
            return None
        return corners_array, ids_array

    def _pose(
        self,
        frame: np.ndarray,
        matrix: np.ndarray,
        distortion: np.ndarray,
    ) -> tuple[np.ndarray, float] | None:
        full_pose = self._full_pose(frame, matrix, distortion)
        if full_pose is None:
            return None
        _, translation, error = full_pose
        return translation, error

    def _full_pose(
        self,
        frame: np.ndarray,
        matrix: np.ndarray,
        distortion: np.ndarray,
    ) -> tuple[np.ndarray, np.ndarray, float] | None:
        detection = self._detect(frame)
        if detection is None:
            return None
        corners, ids = detection
        object_points = self.board_corners[ids]
        success, rotation, translation = cv2.solvePnP(
            object_points,
            corners,
            matrix,
            distortion,
            flags=cv2.SOLVEPNP_ITERATIVE,
        )
        if not success:
            return None
        projected, _ = cv2.projectPoints(
            object_points, rotation, translation, matrix, distortion
        )
        error = float(
            np.sqrt(
                np.mean(
                    np.sum(
                        (corners - projected.reshape(-1, 2)) ** 2,
                        axis=1,
                    )
                )
            )
        )
        rotation_matrix, _ = cv2.Rodrigues(rotation)
        return rotation_matrix, translation.reshape(3), error

    def _select_orientation(
        self,
        capture: cv2.VideoCapture,
        video_info: dict[str, float | int],
        intrinsic: dict[str, Any],
    ) -> str:
        video_size = (int(video_info["width"]), int(video_info["height"]))
        target_size = intrinsic["size"]
        if video_size == target_size:
            return "none"
        if video_size != (target_size[1], target_size[0]):
            raise RuntimeError(
                f"Video size {video_size} is incompatible with "
                f"intrinsic calibration size {target_size}."
            )

        candidates = {
            "clockwise": cv2.ROTATE_90_CLOCKWISE,
            "counterclockwise": cv2.ROTATE_90_COUNTERCLOCKWISE,
        }
        errors: dict[str, list[float]] = {name: [] for name in candidates}
        duration = float(video_info["duration"])
        for seconds in np.linspace(0.0, max(0.0, duration - 0.2), 24):
            frame = self._read_at(capture, float(seconds))
            if frame is None:
                continue
            for name, rotation_code in candidates.items():
                rotated = cv2.rotate(frame, rotation_code)
                result = self._pose(
                    rotated, intrinsic["matrix"], intrinsic["distortion"]
                )
                if result is not None:
                    errors[name].append(result[1])

        valid = {
            name: float(np.median(values))
            for name, values in errors.items()
            if len(values) >= 3
        }
        if not valid:
            raise RuntimeError(
                "Could not determine portrait-video rotation. "
                "The ChArUco board was not detected often enough."
            )
        selected = min(valid, key=valid.get)
        print("Camera 2 orientation candidates:", valid)
        return selected

    @staticmethod
    def _orient(frame: np.ndarray, orientation: str) -> np.ndarray:
        if orientation == "clockwise":
            return cv2.rotate(frame, cv2.ROTATE_90_CLOCKWISE)
        if orientation == "counterclockwise":
            return cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
        return frame

    def _motion_track(
        self,
        capture: cv2.VideoCapture,
        info: dict[str, float | int],
        intrinsic: dict[str, Any],
        orientation: str,
        step: float = 0.10,
    ) -> tuple[np.ndarray, np.ndarray]:
        times: list[float] = []
        positions: list[np.ndarray] = []
        duration = float(info["duration"])
        total = max(1, int(duration / step))
        for index in range(total):
            seconds = index * step
            frame = self._read_at(capture, seconds)
            if frame is None:
                continue
            frame = self._orient(frame, orientation)
            result = self._pose(
                frame, intrinsic["matrix"], intrinsic["distortion"]
            )
            if result is not None and result[1] <= 3.0:
                times.append(seconds)
                positions.append(result[0])
            if index > 0 and index % 100 == 0:
                print(f"Motion scan: {index}/{total}")
        if len(times) < 15:
            raise RuntimeError(
                "Not enough ChArUco detections for automatic synchronization."
            )
        return np.asarray(times), np.asarray(positions)

    @staticmethod
    def _speed_signal(
        times: np.ndarray,
        positions: np.ndarray,
        grid: np.ndarray,
    ) -> np.ndarray:
        coordinates = np.column_stack(
            [np.interp(grid, times, positions[:, axis]) for axis in range(3)]
        )
        speed = np.linalg.norm(np.gradient(coordinates, axis=0), axis=1)
        median = float(np.median(speed))
        mad = float(np.median(np.abs(speed - median)))
        limit = median + 6.0 * max(mad, 1e-6)
        return np.clip(speed, 0.0, limit)

    def _estimate_offset(
        self,
        track_1: tuple[np.ndarray, np.ndarray],
        track_2: tuple[np.ndarray, np.ndarray],
    ) -> tuple[float, float]:
        step = 0.10
        duration = min(float(track_1[0][-1]), float(track_2[0][-1]))
        grid = np.arange(0.0, duration, step)
        signal_1 = self._speed_signal(*track_1, grid)
        signal_2 = self._speed_signal(*track_2, grid)
        signal_1 = (signal_1 - signal_1.mean()) / (signal_1.std() + 1e-9)
        signal_2 = (signal_2 - signal_2.mean()) / (signal_2.std() + 1e-9)

        maximum_lag = int(self.maximum_sync_offset_seconds / step)
        best_lag = 0
        best_score = -1.0
        for lag in range(-maximum_lag, maximum_lag + 1):
            if lag < 0:
                first, second = signal_1[-lag:], signal_2[:lag]
            elif lag > 0:
                first, second = signal_1[:-lag], signal_2[lag:]
            else:
                first, second = signal_1, signal_2
            if len(first) < 100:
                continue
            score = float(np.mean(first * second))
            if score > best_score:
                best_lag, best_score = lag, score

        # Pairing convention: camera_2_time = camera_1_time + offset.
        return best_lag * step, best_score

    @staticmethod
    def _mean_rotation(rotations: list[np.ndarray]) -> np.ndarray:
        accumulator = np.sum(np.asarray(rotations), axis=0)
        left, _, right = np.linalg.svd(accumulator)
        rotation = left @ right
        if np.linalg.det(rotation) < 0:
            left[:, -1] *= -1
            rotation = left @ right
        return rotation

    @staticmethod
    def _rotation_distance(first: np.ndarray, second: np.ndarray) -> float:
        delta = first @ second.T
        cosine = float(np.clip((np.trace(delta) - 1.0) / 2.0, -1.0, 1.0))
        return float(np.arccos(cosine))

    def _fine_sync_score(
        self,
        capture_1: cv2.VideoCapture,
        capture_2: cv2.VideoCapture,
        info_1: dict[str, float | int],
        info_2: dict[str, float | int],
        intrinsic_1: dict[str, Any],
        intrinsic_2: dict[str, Any],
        orientation_2: str,
        offset: float,
    ) -> tuple[float, int]:
        start = max(2.0, 2.0 - offset)
        end = min(
            float(info_1["duration"]) - 2.0,
            float(info_2["duration"]) - offset - 2.0,
        )
        if end <= start:
            return float("inf"), 0

        rotations: list[np.ndarray] = []
        translations: list[np.ndarray] = []
        for time_1 in np.linspace(start, end, 14):
            frame_1 = self._read_at(capture_1, float(time_1))
            frame_2 = self._read_at(capture_2, float(time_1 + offset))
            if frame_1 is None or frame_2 is None:
                continue
            frame_2 = self._orient(frame_2, orientation_2)
            pose_1 = self._full_pose(
                frame_1, intrinsic_1["matrix"], intrinsic_1["distortion"]
            )
            pose_2 = self._full_pose(
                frame_2, intrinsic_2["matrix"], intrinsic_2["distortion"]
            )
            if pose_1 is None or pose_2 is None:
                continue
            rotation_1, translation_1, error_1 = pose_1
            rotation_2, translation_2, error_2 = pose_2
            if error_1 > 3.0 or error_2 > 3.0:
                continue
            relative_rotation = rotation_2 @ rotation_1.T
            relative_translation = (
                translation_2 - relative_rotation @ translation_1
            )
            rotations.append(relative_rotation)
            translations.append(relative_translation)

        if len(rotations) < 6:
            return float("inf"), len(rotations)

        mean_rotation = self._mean_rotation(rotations)
        translation_array = np.asarray(translations)
        center_translation = np.median(translation_array, axis=0)
        translation_error = float(
            np.median(np.linalg.norm(translation_array - center_translation, axis=1))
        )
        rotation_error = float(
            np.median(
                [self._rotation_distance(item, mean_rotation) for item in rotations]
            )
        )
        # Meter + radians. Both penalize lack of rigid-camera consistency.
        return translation_error + 0.35 * rotation_error, len(rotations)

    def _refine_offset(
        self,
        capture_1: cv2.VideoCapture,
        capture_2: cv2.VideoCapture,
        info_1: dict[str, float | int],
        info_2: dict[str, float | int],
        intrinsic_1: dict[str, Any],
        intrinsic_2: dict[str, Any],
        orientation_2: str,
        coarse_offset: float,
    ) -> tuple[float, float, int]:
        candidates = np.arange(
            coarse_offset - 0.12,
            coarse_offset + 0.1201,
            0.01,
        )
        best_offset = coarse_offset
        best_score = float("inf")
        best_count = 0
        print("Refining synchronization to 0.01 s resolution...")
        for candidate in candidates:
            score, count = self._fine_sync_score(
                capture_1,
                capture_2,
                info_1,
                info_2,
                intrinsic_1,
                intrinsic_2,
                orientation_2,
                float(candidate),
            )
            if score < best_score:
                best_score = score
                best_offset = float(candidate)
                best_count = count
        if not np.isfinite(best_score):
            raise RuntimeError("Fine synchronization could not find a valid offset.")
        return best_offset, best_score, best_count

    def _filter_rigid_pairs(
        self,
        object_points: list[np.ndarray],
        points_1: list[np.ndarray],
        points_2: list[np.ndarray],
        intrinsic_1: dict[str, Any],
        intrinsic_2: dict[str, Any],
    ) -> tuple[list[np.ndarray], list[np.ndarray], list[np.ndarray], int]:
        rotations: list[np.ndarray] = []
        translations: list[np.ndarray] = []
        valid_indices: list[int] = []
        for index, (objects, image_1, image_2) in enumerate(
            zip(object_points, points_1, points_2)
        ):
            ok_1, rvec_1, tvec_1 = cv2.solvePnP(
                objects, image_1, intrinsic_1["matrix"], intrinsic_1["distortion"]
            )
            ok_2, rvec_2, tvec_2 = cv2.solvePnP(
                objects, image_2, intrinsic_2["matrix"], intrinsic_2["distortion"]
            )
            if not ok_1 or not ok_2:
                continue
            rotation_1, _ = cv2.Rodrigues(rvec_1)
            rotation_2, _ = cv2.Rodrigues(rvec_2)
            relative_rotation = rotation_2 @ rotation_1.T
            relative_translation = (
                tvec_2.reshape(3)
                - relative_rotation @ tvec_1.reshape(3)
            )
            rotations.append(relative_rotation)
            translations.append(relative_translation)
            valid_indices.append(index)

        if len(valid_indices) < MINIMUM_STEREO_VIEWS:
            return object_points, points_1, points_2, 0

        mean_rotation = self._mean_rotation(rotations)
        translation_array = np.asarray(translations)
        center_translation = np.median(translation_array, axis=0)
        translation_deviation = np.linalg.norm(
            translation_array - center_translation, axis=1
        )
        rotation_deviation = np.asarray(
            [self._rotation_distance(item, mean_rotation) for item in rotations]
        )

        t_med = float(np.median(translation_deviation))
        t_mad = float(np.median(np.abs(translation_deviation - t_med)))
        r_med = float(np.median(rotation_deviation))
        r_mad = float(np.median(np.abs(rotation_deviation - r_med)))
        t_limit = max(0.02, t_med + 3.5 * max(t_mad, 1e-5))
        r_limit = max(np.deg2rad(2.0), r_med + 3.5 * max(r_mad, 1e-5))

        keep_local = [
            local_index
            for local_index in range(len(valid_indices))
            if translation_deviation[local_index] <= t_limit
            and rotation_deviation[local_index] <= r_limit
        ]
        keep = [valid_indices[item] for item in keep_local]
        if len(keep) < MINIMUM_STEREO_VIEWS:
            return object_points, points_1, points_2, 0
        removed = len(object_points) - len(keep)
        return (
            [object_points[index] for index in keep],
            [points_1[index] for index in keep],
            [points_2[index] for index in keep],
            removed,
        )

    def _collect_pairs(
        self,
        capture_1: cv2.VideoCapture,
        capture_2: cv2.VideoCapture,
        info_1: dict[str, float | int],
        info_2: dict[str, float | int],
        intrinsic_1: dict[str, Any],
        intrinsic_2: dict[str, Any],
        orientation_2: str,
        offset: float,
    ) -> tuple[list[np.ndarray], list[np.ndarray], list[np.ndarray]]:
        object_points: list[np.ndarray] = []
        image_points_1: list[np.ndarray] = []
        image_points_2: list[np.ndarray] = []
        start = max(0.0, -offset)
        end = min(float(info_1["duration"]), float(info_2["duration"]) - offset)
        times = np.arange(start, end, self.sample_interval_seconds)

        for index, time_1 in enumerate(times):
            time_2 = float(time_1 + offset)
            frame_1 = self._read_at(capture_1, float(time_1))
            frame_2 = self._read_at(capture_2, time_2)
            if frame_1 is None or frame_2 is None:
                continue
            frame_2 = self._orient(frame_2, orientation_2)
            detected_1 = self._detect(frame_1)
            detected_2 = self._detect(frame_2)
            if detected_1 is None or detected_2 is None:
                continue

            corners_1, ids_1 = detected_1
            corners_2, ids_2 = detected_2
            map_1 = {int(marker_id): corner for marker_id, corner in zip(ids_1, corners_1)}
            map_2 = {int(marker_id): corner for marker_id, corner in zip(ids_2, corners_2)}
            common_ids = sorted(set(map_1).intersection(map_2))
            if len(common_ids) < MINIMUM_COMMON_CORNERS:
                continue

            objects = np.asarray(
                [self.board_corners[marker_id] for marker_id in common_ids],
                dtype=np.float32,
            ).reshape(-1, 1, 3)
            points_1 = np.asarray(
                [map_1[marker_id] for marker_id in common_ids], dtype=np.float32
            ).reshape(-1, 1, 2)
            points_2 = np.asarray(
                [map_2[marker_id] for marker_id in common_ids], dtype=np.float32
            ).reshape(-1, 1, 2)

            object_points.append(objects)
            image_points_1.append(points_1)
            image_points_2.append(points_2)
            if len(object_points) == 1 or len(object_points) % 5 == 0:
                print(f"Accepted stereo views: {len(object_points)}")
            if index > 0 and index % 50 == 0:
                print(f"Pair scan: {index}/{len(times)}")

        if len(object_points) < MINIMUM_STEREO_VIEWS:
            raise RuntimeError(
                f"Need at least {MINIMUM_STEREO_VIEWS} synchronized stereo views; "
                f"found {len(object_points)}."
            )
        return object_points, image_points_1, image_points_2

    @staticmethod
    def _stereo_calibrate(
        object_points: list[np.ndarray],
        image_points_1: list[np.ndarray],
        image_points_2: list[np.ndarray],
        intrinsic_1: dict[str, Any],
        intrinsic_2: dict[str, Any],
    ) -> tuple[float, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        result = cv2.stereoCalibrate(
            object_points,
            image_points_1,
            image_points_2,
            intrinsic_1["matrix"].copy(),
            intrinsic_1["distortion"].copy(),
            intrinsic_2["matrix"].copy(),
            intrinsic_2["distortion"].copy(),
            intrinsic_1["size"],
            flags=cv2.CALIB_FIX_INTRINSIC,
            criteria=(
                cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,
                200,
                1e-8,
            ),
        )
        rms, _, _, _, _, rotation, translation, essential, fundamental = result
        return float(rms), rotation, translation.reshape(3), essential, fundamental

    def calibrate(
        self,
        video_1_path: Path,
        video_2_path: Path,
        intrinsics_1_path: Path,
        intrinsics_2_path: Path,
        manual_offset: float | None,
    ) -> dict[str, Any]:
        intrinsic_1 = self._load_intrinsics(intrinsics_1_path)
        intrinsic_2 = self._load_intrinsics(intrinsics_2_path)
        capture_1 = cv2.VideoCapture(str(video_1_path))
        capture_2 = cv2.VideoCapture(str(video_2_path))
        if not capture_1.isOpened() or not capture_2.isOpened():
            raise RuntimeError("Unable to open one or both stereo videos.")

        try:
            info_1 = self._video_info(capture_1)
            info_2 = self._video_info(capture_2)
            orientation_1 = self._select_orientation(capture_1, info_1, intrinsic_1)
            if orientation_1 != "none":
                raise RuntimeError("Camera 1 orientation does not match its intrinsics.")
            orientation_2 = self._select_orientation(capture_2, info_2, intrinsic_2)
            print("Camera 2 selected orientation:", orientation_2)

            if manual_offset is None:
                print("Scanning ChArUco motion for automatic synchronization...")
                track_1 = self._motion_track(
                    capture_1, info_1, intrinsic_1, "none"
                )
                track_2 = self._motion_track(
                    capture_2, info_2, intrinsic_2, orientation_2
                )
                coarse_offset, sync_score = self._estimate_offset(track_1, track_2)
                print(f"Coarse camera 2 time offset: {coarse_offset:+.3f} s")
                offset, fine_sync_score, fine_sync_views = self._refine_offset(
                    capture_1,
                    capture_2,
                    info_1,
                    info_2,
                    intrinsic_1,
                    intrinsic_2,
                    orientation_2,
                    coarse_offset,
                )
            else:
                coarse_offset = manual_offset
                sync_score = None
                print(
                    f"Using supplied coarse camera 2 offset: "
                    f"{coarse_offset:+.3f} s"
                )
                offset, fine_sync_score, fine_sync_views = self._refine_offset(
                    capture_1,
                    capture_2,
                    info_1,
                    info_2,
                    intrinsic_1,
                    intrinsic_2,
                    orientation_2,
                    coarse_offset,
                )

            print(f"Camera 2 time offset: {offset:+.3f} s")
            if sync_score is not None:
                print(f"Coarse synchronization score: {sync_score:.4f}")
            if fine_sync_score is not None:
                print(f"Fine rigid-sync score: {fine_sync_score:.6f}")
                print(f"Fine-sync valid views: {fine_sync_views}")

            object_points, points_1, points_2 = self._collect_pairs(
                capture_1,
                capture_2,
                info_1,
                info_2,
                intrinsic_1,
                intrinsic_2,
                orientation_2,
                offset,
            )
            initial_pair_count = len(object_points)
            object_points, points_1, points_2, removed_pairs = self._filter_rigid_pairs(
                object_points,
                points_1,
                points_2,
                intrinsic_1,
                intrinsic_2,
            )
            print(f"Rigid stereo views: {len(object_points)}")
            print(f"Rejected inconsistent pairs: {removed_pairs}")
            rms, rotation, translation, essential, fundamental = self._stereo_calibrate(
                object_points, points_1, points_2, intrinsic_1, intrinsic_2
            )
        finally:
            capture_1.release()
            capture_2.release()

        baseline = float(np.linalg.norm(translation))
        quality = (
            "excellent" if rms <= 0.75 else
            "good" if rms <= 1.25 else
            "acceptable" if rms <= 2.0 else
            "review_required"
        )
        report = {
            "status": "completed",
            "quality": quality,
            "coordinate_unit": "meter",
            "camera_1_video": str(video_1_path),
            "camera_2_video": str(video_2_path),
            "camera_2_frame_rotation": orientation_2,
            "synchronization": {
                "camera_2_offset_seconds": offset,
                "coarse_score": sync_score,
                "fine_rigid_score": fine_sync_score,
                "fine_sync_valid_views": fine_sync_views,
                "pairing_rule": "camera_2_time = camera_1_time + offset",
            },
            "stereo_calibration": {
                "rms_reprojection_error_px": rms,
                "initial_pair_count": initial_pair_count,
                "valid_view_count": len(object_points),
                "rejected_inconsistent_pairs": removed_pairs,
                "rotation_camera_1_to_camera_2": rotation.tolist(),
                "translation_camera_1_to_camera_2_m": translation.tolist(),
                "baseline_m": baseline,
                "essential_matrix": essential.tolist(),
                "fundamental_matrix": fundamental.tolist(),
            },
        }

        output = Path(__file__).resolve().parent.parent / "runtime" / "calibration" / "stereo_extrinsics.json"
        output.write_text(
            json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8"
        )
        print("Calibration saved:", output)
        return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind synchronized ChArUco stereo calibration"
    )
    parser.add_argument("camera_1_video", type=Path)
    parser.add_argument("camera_2_video", type=Path)
    parser.add_argument("--camera-1-intrinsics", type=Path, required=True)
    parser.add_argument("--camera-2-intrinsics", type=Path, required=True)
    parser.add_argument(
        "--camera-2-offset",
        type=float,
        default=None,
        help=(
            "Known coarse offset in seconds; skips the long motion scan "
            "but still performs 0.01 s rigid-pose refinement."
        ),
    )
    args = parser.parse_args()

    print("Judo Mind Stereo Extrinsic Calibration")
    calibrator = JudoStereoCalibrator()
    report = calibrator.calibrate(
        args.camera_1_video,
        args.camera_2_video,
        args.camera_1_intrinsics,
        args.camera_2_intrinsics,
        args.camera_2_offset,
    )
    result = report["stereo_calibration"]
    print("\nJudo Mind Stereo Calibration Complete")
    print("Quality:", report["quality"])
    print("RMS reprojection error:", result["rms_reprojection_error_px"], "px")
    print("Valid stereo views:", result["valid_view_count"])
    print("Camera baseline:", result["baseline_m"], "m")


if __name__ == "__main__":
    main()