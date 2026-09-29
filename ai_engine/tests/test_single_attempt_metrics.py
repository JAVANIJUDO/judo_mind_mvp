from __future__ import annotations

import math
from unittest import TestCase

from pydantic import ValidationError

from ai_engine.contracts.single_attempt_analysis_v2a import (
    MetricConfidence,
    MetricResult,
    MetricTemporalReference,
    SingleAttemptAnalysisResponse,
    SingleAttemptAnalysisRequest,
)
from ai_engine.contracts.single_camera_pose_summary import AnalysisProvenance
from ai_engine.single_attempt.analysis import analyze_single_attempt
from ai_engine.single_attempt.metrics import (
    Point2D,
    execution_duration_seconds,
    projected_knee_angle_degrees,
    projected_trunk_inclination_degrees,
)


def _request_payload(
    *,
    support_leg: str = "left",
    camera_suitable: bool = True,
    pose_observation: bool = True,
) -> dict[str, object]:
    payload: dict[str, object] = {
        "schema_version": "2.0.0",
        "analysis_variant": "single_attempt_v2a",
        "video_id": "authorized-uchi-mata-001",
        "technique": {"id": "uchi-mata"},
        "camera_view": "side",
        "attempt": {
            "start": {"frame_index": 30, "timestamp_ms": 1000},
            "end": {"frame_index": 90, "timestamp_ms": 3000},
            "event_schema_id": "human-single-attempt-boundaries-v1",
            "selection_source": "human-selected",
        },
        "subject": {
            "neutral_track_id": "Track A",
            "selected_detection_index": 1,
            "role": "Tori",
            "confirmation_source": "human-confirmed",
        },
        "support_leg": {
            "side": support_leg,
            "confirmation_source": "human-confirmed",
        },
        "angle_frame": {
            "frame": {"frame_index": 60, "timestamp_ms": 2000},
            "selection_source": "human-selected",
            "event_label": "reviewed-angle-observation",
        },
        "camera_suitability": {
            "projected_angle_view_suitable": camera_suitable,
            "low_roll_confirmed": camera_suitable,
            "review_source": "human-reviewed",
        },
    }

    if pose_observation:
        payload["pose_observation"] = {
            "frame": {"frame_index": 60, "timestamp_ms": 2000},
            "neutral_track_id": "Track A",
            "detection_index": 1,
            "image_width": 640,
            "image_height": 360,
            "coordinate_space": "normalized_image",
            "provenance": "model-estimated",
            "landmarks": {
                "left_shoulder": {"x": 0.4, "y": 0.2, "visibility": 0.9},
                "right_shoulder": {"x": 0.6, "y": 0.2, "visibility": 0.8},
                "left_hip": {"x": 0.5, "y": 0.5, "visibility": 0.85},
                "right_hip": {"x": 0.7, "y": 0.5, "visibility": 0.7},
                "left_knee": {"x": 0.5, "y": 0.7, "visibility": 0.75},
                "left_ankle": {"x": 0.5, "y": 0.9, "visibility": 0.65},
                "right_knee": {"x": 0.7, "y": 0.7, "visibility": 0.72},
                "right_ankle": {"x": 0.8, "y": 0.8, "visibility": 0.62},
            },
        }

    return payload


class SingleAttemptMetricMathTest(TestCase):
    def test_valid_duration_uses_timestamp_difference(self) -> None:
        self.assertEqual(execution_duration_seconds(1250, 3000), 1.75)

    def test_duration_rejects_reversed_equal_negative_or_non_integer_values(
        self,
    ) -> None:
        invalid = ((3000, 1250), (1000, 1000), (-1, 1000), (True, 1000))
        for start, end in invalid:
            with self.subTest(start=start, end=end):
                with self.assertRaises(ValueError):
                    execution_duration_seconds(start, end)

    def test_projected_trunk_geometry(self) -> None:
        upright = projected_trunk_inclination_degrees(
            left_shoulder=Point2D(0.4, 0.2),
            right_shoulder=Point2D(0.6, 0.2),
            left_hip=Point2D(0.4, 0.6),
            right_hip=Point2D(0.6, 0.6),
        )
        horizontal = projected_trunk_inclination_degrees(
            left_shoulder=Point2D(0.8, 0.4),
            right_shoulder=Point2D(0.8, 0.6),
            left_hip=Point2D(0.2, 0.4),
            right_hip=Point2D(0.2, 0.6),
        )

        self.assertAlmostEqual(upright, 0.0)
        self.assertAlmostEqual(horizontal, 90.0)

    def test_projected_knee_geometry(self) -> None:
        straight = projected_knee_angle_degrees(
            hip=Point2D(0.0, 0.0),
            knee=Point2D(0.0, 1.0),
            ankle=Point2D(0.0, 2.0),
        )
        right_angle = projected_knee_angle_degrees(
            hip=Point2D(0.0, 0.0),
            knee=Point2D(0.0, 1.0),
            ankle=Point2D(1.0, 1.0),
        )

        self.assertAlmostEqual(straight, 180.0)
        self.assertAlmostEqual(right_angle, 90.0)

    def test_geometry_rejects_degenerate_and_nan_coordinates(self) -> None:
        with self.assertRaises(ValueError):
            projected_trunk_inclination_degrees(
                left_shoulder=Point2D(0.5, 0.5),
                right_shoulder=Point2D(0.5, 0.5),
                left_hip=Point2D(0.5, 0.5),
                right_hip=Point2D(0.5, 0.5),
            )

        with self.assertRaises(ValueError):
            projected_knee_angle_degrees(
                hip=Point2D(0.0, 0.0),
                knee=Point2D(0.0, 0.0),
                ankle=Point2D(0.0, 1.0),
            )

        with self.assertRaises(ValueError):
            Point2D(math.nan, 0.0)


class SingleAttemptAnalysisContractTest(TestCase):
    def test_serializes_versioned_reportable_results_and_blue_geometry(self) -> None:
        request = SingleAttemptAnalysisRequest.model_validate(_request_payload())
        response = analyze_single_attempt(request, analysis_id="analysis-v2a-1")
        serialized = response.model_dump(mode="json")

        self.assertEqual(serialized["schema_version"], "2.0.0")
        self.assertEqual(serialized["analysis_variant"], "single_attempt_v2a")
        self.assertEqual(
            [metric["metric_id"] for metric in serialized["metrics"]],
            ["UM-TIM-001", "UM-ANG-001", "UM-ANG-002", "UM-ANG-003"],
        )
        self.assertEqual(serialized["metrics"][0]["value"], 2.0)
        self.assertEqual(serialized["metrics"][0]["provenance"], "measured")
        self.assertEqual(serialized["metrics"][1]["provenance"], "model-estimated")
        self.assertEqual(serialized["metrics"][2]["provenance"], "model-estimated")
        self.assertEqual(serialized["metrics"][3]["provenance"], "model-estimated")
        self.assertTrue(
            all(
                primitive["color_layer"] == "blue"
                for metric in serialized["metrics"][1:]
                for primitive in metric["overlay"]
            )
        )
        self.assertFalse(serialized["capabilities"]["automatic_tori_uke_identity"])
        self.assertFalse(serialized["capabilities"]["automatic_phase_detection"])
        self.assertFalse(serialized["capabilities"]["force_torque_power"])

        for mutation in (
            lambda payload: payload["limitations"].pop(),
            lambda payload: payload["metrics"][1]["temporal_reference"].update(
                {"frame": {"frame_index": 61, "timestamp_ms": 2040}}
            ),
            lambda payload: payload.update(
                {"technique": {"id": "seoi-nage"}}
            ),
        ):
            invalid = response.model_dump(mode="json")
            mutation(invalid)
            with self.assertRaises(ValidationError):
                SingleAttemptAnalysisResponse.model_validate(invalid)

    def test_left_and_right_support_leg_choose_corresponding_landmarks(self) -> None:
        left = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(
                _request_payload(support_leg="left")
            )
        )
        right = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(
                _request_payload(support_leg="right")
            )
        )

        left_value = next(
            metric.value for metric in left.metrics if metric.metric_id == "UM-ANG-002"
        )
        right_value = next(
            metric.value for metric in right.metrics if metric.metric_id == "UM-ANG-002"
        )

        self.assertAlmostEqual(left_value or 0.0, 180.0)
        self.assertAlmostEqual(right_value or 0.0, 119.3577535)

    def test_normalized_landmarks_are_aspect_corrected_for_metric_math(
        self,
    ) -> None:
        payload = _request_payload()
        observation = payload["pose_observation"]
        assert isinstance(observation, dict)
        landmarks = observation["landmarks"]
        assert isinstance(landmarks, dict)
        observation["image_width"] = 200
        observation["image_height"] = 100
        landmarks["left_shoulder"] = {"x": 0.55, "y": 0.4, "visibility": 0.9}
        landmarks["right_shoulder"] = {"x": 0.55, "y": 0.4, "visibility": 0.9}
        landmarks["left_hip"] = {"x": 0.45, "y": 0.5, "visibility": 0.9}
        landmarks["right_hip"] = {"x": 0.45, "y": 0.5, "visibility": 0.9}

        response = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(payload)
        )
        trunk = response.metrics[1]

        self.assertAlmostEqual(trunk.value or 0.0, 63.4349488)
        self.assertEqual(trunk.overlay[0].points[0].x, 0.45)
        self.assertEqual(trunk.overlay[0].points[1].x, 0.55)

    def test_missing_pose_withholds_angles_but_preserves_duration(self) -> None:
        response = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(
                _request_payload(pose_observation=False)
            )
        )

        self.assertEqual(response.metrics[0].status.value, "reportable")
        for metric in response.metrics[1:]:
            self.assertEqual(metric.status.value, "withheld")
            self.assertIsNone(metric.value)
            self.assertTrue(metric.withheld_reason)
            self.assertEqual(metric.overlay, [])

    def test_missing_landmark_withholds_only_affected_metric(self) -> None:
        payload = _request_payload()
        observation = payload["pose_observation"]
        assert isinstance(observation, dict)
        landmarks = observation["landmarks"]
        assert isinstance(landmarks, dict)
        landmarks.pop("left_ankle")
        response = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(payload)
        )

        self.assertEqual(response.metrics[1].status.value, "reportable")
        self.assertEqual(response.metrics[2].status.value, "withheld")

    def test_landmark_visibility_is_preserved_without_accuracy_claim(self) -> None:
        response = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(_request_payload())
        )
        trunk_confidence = response.metrics[1].confidence
        knee_confidence = response.metrics[2].confidence

        self.assertTrue(trunk_confidence.available)
        self.assertEqual(trunk_confidence.value, 0.7)
        self.assertTrue(knee_confidence.available)
        self.assertEqual(knee_confidence.value, 0.65)
        self.assertIn("not pose accuracy", trunk_confidence.interpretation)

    def test_missing_visibility_requires_review_without_inventing_confidence(
        self,
    ) -> None:
        payload = _request_payload()
        observation = payload["pose_observation"]
        assert isinstance(observation, dict)
        landmarks = observation["landmarks"]
        assert isinstance(landmarks, dict)
        shoulder = landmarks["left_shoulder"]
        assert isinstance(shoulder, dict)
        shoulder.pop("visibility")

        response = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(payload)
        )
        trunk = response.metrics[1]

        self.assertEqual(trunk.status.value, "review_required")
        self.assertFalse(trunk.confidence.available)
        self.assertIsNotNone(trunk.value)

    def test_unsuitable_camera_requires_review_not_rejection(self) -> None:
        response = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(
                _request_payload(camera_suitable=False)
            )
        )

        self.assertEqual(response.metrics[0].status.value, "reportable")
        self.assertEqual(response.metrics[1].status.value, "review_required")
        self.assertEqual(response.metrics[2].status.value, "review_required")

    def test_rejects_non_human_role_and_misaligned_observation(self) -> None:
        payload = _request_payload()
        subject = payload["subject"]
        assert isinstance(subject, dict)
        subject["confirmation_source"] = "AI-inferred"
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)

        payload = _request_payload()
        observation = payload["pose_observation"]
        assert isinstance(observation, dict)
        observation["neutral_track_id"] = "Track B"
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)

        payload = _request_payload()
        subject = payload["subject"]
        assert isinstance(subject, dict)
        subject["selected_detection_index"] = 0
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)

    def test_rejects_reversed_boundaries_and_nan_landmarks(self) -> None:
        payload = _request_payload()
        attempt = payload["attempt"]
        assert isinstance(attempt, dict)
        attempt["end"] = {"frame_index": 20, "timestamp_ms": 500}
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)

    def test_metric_registry_rejects_wrong_unit_provenance_method_or_range(
        self,
    ) -> None:
        request = SingleAttemptAnalysisRequest.model_validate(_request_payload())
        reference = MetricTemporalReference(
            kind="interval",
            start=request.attempt.start,
            end=request.attempt.end,
        )
        base = {
            "metric_id": "UM-TIM-001",
            "name": "Reviewed execution duration",
            "status": "reportable",
            "value": 2.0,
            "unit": "seconds",
            "provenance": AnalysisProvenance.MEASURED,
            "temporal_reference": reference,
            "confidence": MetricConfidence(
                available=False,
                interpretation="Human-reviewed boundaries.",
            ),
            "method_version": "reviewed-event-elapsed-time-1.0.0",
            "limitation": "Same event schema only.",
            "descriptive_text": "Reviewed duration is 2.0 seconds.",
        }

        for key, invalid_value in (
            ("unit", "degrees"),
            ("provenance", AnalysisProvenance.MODEL_ESTIMATED),
            ("method_version", "unapproved-method"),
            ("value", 0.0),
        ):
            with self.subTest(key=key):
                payload = {**base, key: invalid_value}
                with self.assertRaises(ValidationError):
                    MetricResult.model_validate(payload)

        response_payload = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(_request_payload())
        ).model_dump(mode="json")
        response_payload["metrics"][1]["overlay"] = []
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisResponse.model_validate(response_payload)

        for mutate_overlay in (
            lambda overlay: overlay[0]["points"][0].update({"x": 1.01}),
            lambda overlay: overlay[0]["points"].append(
                {"x": 0.6, "y": 0.4, "label": None}
            ),
            lambda overlay: overlay.append(overlay[1]),
            lambda overlay: overlay[1].update({"label": ""}),
        ):
            invalid_geometry = analyze_single_attempt(
                SingleAttemptAnalysisRequest.model_validate(_request_payload())
            ).model_dump(mode="json")
            mutate_overlay(invalid_geometry["metrics"][1]["overlay"])
            with self.assertRaises(ValidationError):
                SingleAttemptAnalysisResponse.model_validate(invalid_geometry)

        payload = _request_payload()
        observation = payload["pose_observation"]
        assert isinstance(observation, dict)
        landmarks = observation["landmarks"]
        assert isinstance(landmarks, dict)
        left_knee = landmarks["left_knee"]
        assert isinstance(left_knee, dict)
        left_knee["x"] = math.nan
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)

        payload = _request_payload()
        observation = payload["pose_observation"]
        assert isinstance(observation, dict)
        landmarks = observation["landmarks"]
        assert isinstance(landmarks, dict)
        left_knee = landmarks["left_knee"]
        assert isinstance(left_knee, dict)
        left_knee["x"] = 1.01
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)
