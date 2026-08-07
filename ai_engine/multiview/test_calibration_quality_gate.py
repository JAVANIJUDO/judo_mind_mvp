from __future__ import annotations

import unittest

import numpy as np

from calibration_quality_gate import (
    CalibrationPurpose,
    CalibrationRejectedError,
    approve_calibration_report,
    evaluate_calibration_report,
)
from multiview_reconstruction import (
    CameraProjection,
    KeypointObservation,
    MultiViewReconstructor,
)


def calibration_report(
    *,
    quality: str = "good",
    valid_stereo_holds: object = 10,
    rms_reprojection_error_px: object = 1.0,
    median_epipolar_error_px: object = 0.75,
    median_abs_sync_error_ms: object = 4.0,
) -> dict[str, object]:
    return {
        "status": "completed",
        "quality": quality,
        "hold_detection": {
            "valid_stereo_holds": valid_stereo_holds,
        },
        "calibration": {
            "rms_reprojection_error_px": (
                rms_reprojection_error_px
            ),
        },
        "validation": {
            "median_epipolar_error_px": (
                median_epipolar_error_px
            ),
            "median_abs_sync_error_ms": (
                median_abs_sync_error_ms
            ),
        },
    }


class CalibrationQualityGateTest(unittest.TestCase):
    def test_rejects_closed_cycle_review_required_report(self) -> None:
        report = calibration_report(
            quality="review_required",
            valid_stereo_holds=8,
            rms_reprojection_error_px=48.275033303970204,
            median_epipolar_error_px=55.432891845703125,
            median_abs_sync_error_ms=3.335381527633796,
        )

        for purpose in CalibrationPurpose:
            with self.subTest(purpose=purpose):
                decision = evaluate_calibration_report(
                    report=report,
                    purpose=purpose,
                )

                self.assertFalse(decision.accepted)
                with self.assertRaises(
                    CalibrationRejectedError
                ):
                    decision.require_accepted()

    def test_rejects_missing_or_malformed_metrics(self) -> None:
        missing_metric_report = calibration_report()
        validation = missing_metric_report["validation"]
        assert isinstance(validation, dict)
        del validation["median_epipolar_error_px"]

        malformed_hold_report = calibration_report(
            valid_stereo_holds=10.5,
        )

        for report in (
            missing_metric_report,
            malformed_hold_report,
        ):
            with self.subTest(report=report):
                decision = evaluate_calibration_report(
                    report=report,
                    purpose=CalibrationPurpose.SCIENTIFIC_3D,
                )
                self.assertFalse(decision.accepted)

    def test_validation_quality_is_offline_only(self) -> None:
        report = calibration_report(
            quality="usable_for_3d_validation",
            valid_stereo_holds=8,
            rms_reprojection_error_px=3.0,
            median_epipolar_error_px=2.0,
            median_abs_sync_error_ms=9.0,
        )

        context = approve_calibration_report(
            report=report,
            purpose=(
                CalibrationPurpose.OFFLINE_3D_VALIDATION
            ),
            calibration_id="offline-validation-test",
        )

        self.assertFalse(
            context.allows_user_facing_scientific_3d
        )

        for purpose in (
            CalibrationPurpose.SCIENTIFIC_3D,
            CalibrationPurpose.OPENSIM,
        ):
            with self.subTest(purpose=purpose):
                with self.assertRaises(
                    CalibrationRejectedError
                ):
                    approve_calibration_report(
                        report=report,
                        purpose=purpose,
                        calibration_id="must-be-rejected",
                    )

    def test_good_report_can_create_scientific_context(self) -> None:
        context = approve_calibration_report(
            report=calibration_report(),
            purpose=CalibrationPurpose.SCIENTIFIC_3D,
            calibration_id="scientific-test",
        )

        self.assertTrue(
            context.allows_user_facing_scientific_3d
        )

    def test_reconstructor_requires_approved_context(self) -> None:
        with self.assertRaises(CalibrationRejectedError):
            MultiViewReconstructor(  # type: ignore[arg-type]
                calibration_context=None
            )

        context = approve_calibration_report(
            report=calibration_report(),
            purpose=CalibrationPurpose.SCIENTIFIC_3D,
            calibration_id="reconstructor-test",
        )

        reconstructor = MultiViewReconstructor(
            calibration_context=context
        )
        self.assertEqual(
            reconstructor.calibration_context.calibration_id,
            "reconstructor-test",
        )

    def test_reconstruction_binds_calibration_and_provenance(self) -> None:
        context = approve_calibration_report(
            report=calibration_report(),
            purpose=CalibrationPurpose.SCIENTIFIC_3D,
            calibration_id="bound-calibration",
        )
        reconstructor = MultiViewReconstructor(
            calibration_context=context
        )

        projection_1 = np.array(
            [
                [1.0, 0.0, 0.0, 0.0],
                [0.0, 1.0, 0.0, 0.0],
                [0.0, 0.0, 1.0, 0.0],
            ]
        )
        projection_2 = np.array(
            [
                [1.0, 0.0, 0.0, -1.0],
                [0.0, 1.0, 0.0, 0.0],
                [0.0, 0.0, 1.0, 0.0],
            ]
        )
        observations = [
            KeypointObservation(
                camera_id="camera_1",
                x=0.25 / 3.0,
                y=0.40 / 3.0,
                confidence=0.99,
            ),
            KeypointObservation(
                camera_id="camera_2",
                x=(0.25 - 1.0) / 3.0,
                y=0.40 / 3.0,
                confidence=0.98,
            ),
        ]

        mismatched_cameras = [
            CameraProjection(
                camera_id="camera_1",
                calibration_id="wrong-calibration",
                projection_matrix=projection_1,
            ),
            CameraProjection(
                camera_id="camera_2",
                calibration_id="bound-calibration",
                projection_matrix=projection_2,
            ),
        ]
        with self.assertRaises(CalibrationRejectedError):
            reconstructor.reconstruct_point(
                cameras=mismatched_cameras,
                observations=observations,
            )

        cameras = [
            CameraProjection(
                camera_id="camera_1",
                calibration_id="bound-calibration",
                projection_matrix=projection_1,
            ),
            CameraProjection(
                camera_id="camera_2",
                calibration_id="bound-calibration",
                projection_matrix=projection_2,
            ),
        ]
        point = reconstructor.reconstruct_point(
            cameras=cameras,
            observations=observations,
        )

        self.assertIsNotNone(point)
        assert point is not None
        self.assertEqual(point.provenance, "reconstructed")
        self.assertEqual(
            point.calibration_id,
            "bound-calibration",
        )
        self.assertTrue(
            point.allows_user_facing_scientific_3d
        )


if __name__ == "__main__":
    unittest.main()
