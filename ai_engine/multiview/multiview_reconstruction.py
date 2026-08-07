from __future__ import annotations

from dataclasses import dataclass
from typing import Sequence

import numpy as np

try:
    from .calibration_quality_gate import (
        CalibrationPurpose,
        CalibrationRejectedError,
        ValidatedCalibrationContext,
        approve_calibration_report,
        require_validated_context,
    )
except ImportError:
    from calibration_quality_gate import (
        CalibrationPurpose,
        CalibrationRejectedError,
        ValidatedCalibrationContext,
        approve_calibration_report,
        require_validated_context,
    )


@dataclass(frozen=True)
class CameraProjection:
    camera_id: str
    calibration_id: str
    projection_matrix: np.ndarray

    def __post_init__(self) -> None:
        matrix = np.asarray(
            self.projection_matrix,
            dtype=np.float64,
        )

        if matrix.shape != (3, 4):
            raise ValueError(
                "Projection matrix must be 3x4."
            )

        object.__setattr__(
            self,
            "projection_matrix",
            matrix,
        )


@dataclass(frozen=True)
class KeypointObservation:
    camera_id: str
    x: float
    y: float
    confidence: float


@dataclass(frozen=True)
class ReconstructedPoint3D:
    x: float
    y: float
    z: float

    confidence: float

    views_used: int

    mean_reprojection_error: float
    max_reprojection_error: float

    is_valid: bool

    provenance: str
    calibration_id: str
    calibration_purpose: CalibrationPurpose
    allows_user_facing_scientific_3d: bool


class MultiViewReconstructor:
    """
    Weighted multi-view DLT triangulation.

    Responsibilities:
    - Reconstruct 3D anatomical points.
    - Use confidence-weighted observations.
    - Calculate reprojection error.
    - Reject scientifically weak results.
    """

    def __init__(
        self,
        calibration_context: ValidatedCalibrationContext,
        minimum_confidence: float = 0.30,
        maximum_reprojection_error: float = 8.0,
    ) -> None:
        self.calibration_context = (
            require_validated_context(
                calibration_context
            )
        )

        self.minimum_confidence = (
            minimum_confidence
        )

        self.maximum_reprojection_error = (
            maximum_reprojection_error
        )

    def reconstruct_point(
        self,
        cameras: Sequence[CameraProjection],
        observations: Sequence[
            KeypointObservation
        ],
    ) -> ReconstructedPoint3D | None:
        mismatched_cameras = [
            camera.camera_id
            for camera in cameras
            if camera.calibration_id
            != self.calibration_context.calibration_id
        ]
        if mismatched_cameras:
            raise CalibrationRejectedError(
                "Camera projections do not match the approved "
                "calibration context: "
                + ", ".join(mismatched_cameras)
            )

        camera_map = {
            camera.camera_id: camera
            for camera in cameras
        }

        if len(camera_map) != len(cameras):
            raise ValueError(
                "Camera IDs must be unique."
            )

        best_observation_by_camera: dict[
            str,
            KeypointObservation,
        ] = {}
        for observation in observations:
            if not (
                observation.confidence
                >= self.minimum_confidence
                and observation.camera_id
                in camera_map
            ):
                continue

            existing = best_observation_by_camera.get(
                observation.camera_id
            )
            if (
                existing is None
                or observation.confidence
                > existing.confidence
            ):
                best_observation_by_camera[
                    observation.camera_id
                ] = observation

        valid_observations = list(
            best_observation_by_camera.values()
        )

        if len(valid_observations) < 2:
            return None

        rows: list[np.ndarray] = []

        for observation in valid_observations:
            camera = camera_map[
                observation.camera_id
            ]

            projection = (
                camera.projection_matrix
            )

            weight = float(
                np.sqrt(
                    max(
                        observation.confidence,
                        1e-8,
                    )
                )
            )

            row_x = (
                observation.x
                * projection[2]
                - projection[0]
            )

            row_y = (
                observation.y
                * projection[2]
                - projection[1]
            )

            rows.append(
                weight * row_x
            )

            rows.append(
                weight * row_y
            )

        matrix_a = np.asarray(
            rows,
            dtype=np.float64,
        )

        _, _, vh = np.linalg.svd(
            matrix_a,
            full_matrices=False,
        )

        homogeneous_point = vh[-1]

        if (
            abs(homogeneous_point[3])
            < 1e-12
        ):
            return None

        point_3d = (
            homogeneous_point[:3]
            / homogeneous_point[3]
        )

        reprojection_errors: list[float] = []

        for observation in valid_observations:
            camera = camera_map[
                observation.camera_id
            ]

            error = self._reprojection_error(
                camera.projection_matrix,
                point_3d,
                observation,
            )

            reprojection_errors.append(
                error
            )

        mean_error = float(
            np.mean(
                reprojection_errors
            )
        )

        max_error = float(
            np.max(
                reprojection_errors
            )
        )

        observation_confidence = float(
            np.mean(
                [
                    observation.confidence
                    for observation
                    in valid_observations
                ]
            )
        )

        error_quality = 1.0 / (
            1.0
            + mean_error
            / max(
                self.maximum_reprojection_error,
                1e-8,
            )
        )

        final_confidence = float(
            np.clip(
                observation_confidence
                * error_quality,
                0.0,
                1.0,
            )
        )

        is_valid = (
            max_error
            <= self.maximum_reprojection_error
        )

        return ReconstructedPoint3D(
            x=float(point_3d[0]),
            y=float(point_3d[1]),
            z=float(point_3d[2]),
            confidence=final_confidence,
            views_used=len(
                valid_observations
            ),
            mean_reprojection_error=(
                mean_error
            ),
            max_reprojection_error=(
                max_error
            ),
            is_valid=is_valid,
            provenance="reconstructed",
            calibration_id=(
                self.calibration_context.calibration_id
            ),
            calibration_purpose=(
                self.calibration_context.purpose
            ),
            allows_user_facing_scientific_3d=(
                self.calibration_context
                .allows_user_facing_scientific_3d
            ),
        )

    def _reprojection_error(
        self,
        projection_matrix: np.ndarray,
        point_3d: np.ndarray,
        observation: KeypointObservation,
    ) -> float:
        homogeneous = np.array(
            [
                point_3d[0],
                point_3d[1],
                point_3d[2],
                1.0,
            ],
            dtype=np.float64,
        )

        projected = (
            projection_matrix
            @ homogeneous
        )

        if abs(projected[2]) < 1e-12:
            return float("inf")

        projected_x = (
            projected[0]
            / projected[2]
        )

        projected_y = (
            projected[1]
            / projected[2]
        )

        difference_x = (
            projected_x
            - observation.x
        )

        difference_y = (
            projected_y
            - observation.y
        )

        return float(
            np.sqrt(
                difference_x**2
                + difference_y**2
            )
        )


def _project_point(
    projection_matrix: np.ndarray,
    point_3d: np.ndarray,
) -> tuple[float, float]:
    homogeneous = np.array(
        [
            point_3d[0],
            point_3d[1],
            point_3d[2],
            1.0,
        ],
        dtype=np.float64,
    )

    projected = (
        projection_matrix
        @ homogeneous
    )

    return (
        float(
            projected[0]
            / projected[2]
        ),
        float(
            projected[1]
            / projected[2]
        ),
    )


def run_self_test() -> None:
    """
    Synthetic geometry validation.

    Known 3D point:
    X = 0.25
    Y = 0.40
    Z = 3.00

    Two calibrated virtual cameras observe
    the same point.

    The reconstructed point must closely
    match the known ground truth.

    This test uses synthetic calibration evidence
    approved only for offline 3D validation. It does
    not establish production or OpenSim readiness.
    """

    synthetic_calibration_report = {
        "status": "completed",
        "quality": "usable_for_3d_validation",
        "hold_detection": {
            "valid_stereo_holds": 8,
        },
        "calibration": {
            "rms_reprojection_error_px": 0.0,
        },
        "validation": {
            "median_epipolar_error_px": 0.0,
            "median_abs_sync_error_ms": 0.0,
        },
    }

    calibration_context = approve_calibration_report(
        report=synthetic_calibration_report,
        purpose=(
            CalibrationPurpose.OFFLINE_3D_VALIDATION
        ),
        calibration_id="synthetic-self-test",
    )

    focal_length = 1000.0

    intrinsic = np.array(
        [
            [
                focal_length,
                0.0,
                640.0,
            ],
            [
                0.0,
                focal_length,
                360.0,
            ],
            [
                0.0,
                0.0,
                1.0,
            ],
        ],
        dtype=np.float64,
    )

    camera_1_extrinsic = np.array(
        [
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
        ],
        dtype=np.float64,
    )

    camera_2_extrinsic = np.array(
        [
            [1.0, 0.0, 0.0, -1.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
        ],
        dtype=np.float64,
    )

    projection_1 = (
        intrinsic
        @ camera_1_extrinsic
    )

    projection_2 = (
        intrinsic
        @ camera_2_extrinsic
    )

    ground_truth = np.array(
        [
            0.25,
            0.40,
            3.00,
        ],
        dtype=np.float64,
    )

    point_1 = _project_point(
        projection_1,
        ground_truth,
    )

    point_2 = _project_point(
        projection_2,
        ground_truth,
    )

    cameras = [
        CameraProjection(
            camera_id="camera_1",
            calibration_id=(
                calibration_context.calibration_id
            ),
            projection_matrix=(
                projection_1
            ),
        ),
        CameraProjection(
            camera_id="camera_2",
            calibration_id=(
                calibration_context.calibration_id
            ),
            projection_matrix=(
                projection_2
            ),
        ),
    ]

    observations = [
        KeypointObservation(
            camera_id="camera_1",
            x=point_1[0],
            y=point_1[1],
            confidence=0.98,
        ),
        KeypointObservation(
            camera_id="camera_2",
            x=point_2[0],
            y=point_2[1],
            confidence=0.97,
        ),
    ]

    reconstructor = (
        MultiViewReconstructor(
            calibration_context=(
                calibration_context
            )
        )
    )

    reconstructed = (
        reconstructor.reconstruct_point(
            cameras=cameras,
            observations=observations,
        )
    )

    if reconstructed is None:
        raise RuntimeError(
            "3D reconstruction failed."
        )

    reconstructed_array = np.array(
        [
            reconstructed.x,
            reconstructed.y,
            reconstructed.z,
        ]
    )

    error_3d = float(
        np.linalg.norm(
            reconstructed_array
            - ground_truth
        )
    )

    print(
        "Judo Mind Multi-View 3D Engine"
    )

    print(
        "Ground Truth:",
        ground_truth,
    )

    print(
        "Reconstructed:",
        reconstructed_array,
    )

    print(
        f"3D Error: {error_3d:.10f}"
    )

    print(
        "Mean Reprojection Error:",
        reconstructed.mean_reprojection_error,
    )

    print(
        "Views Used:",
        reconstructed.views_used,
    )

    print(
        "Confidence:",
        reconstructed.confidence,
    )

    if error_3d < 1e-6:
        print(
            "Judo Mind Multi-View "
            "3D Engine: SYNTHETIC VALIDATION PASSED"
        )
    else:
        raise RuntimeError(
            "Synthetic 3D validation failed."
        )


if __name__ == "__main__":
    run_self_test()
