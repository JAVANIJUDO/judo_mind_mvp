from __future__ import annotations

import json
from unittest import TestCase

from pydantic import ValidationError

from ai_engine.contracts.single_attempt_analysis_v2a import (
    SingleAttemptAnalysisResponse,
    SingleAttemptAnalysisRequest,
)
from ai_engine.main import analyze_single_attempt_v2a, app


def _payload() -> dict[str, object]:
    return {
        "schema_version": "2.0.0",
        "analysis_variant": "single_attempt_v2a",
        "video_id": "video-1",
        "technique": {"id": "uchi-mata"},
        "camera_view": "side",
        "attempt": {
            "start": {"frame_index": 25, "timestamp_ms": 1000},
            "end": {"frame_index": 75, "timestamp_ms": 3000},
            "event_schema_id": "human-single-attempt-boundaries-v1",
            "selection_source": "human-selected",
        },
        "subject": {
            "neutral_track_id": "Track A",
            "selected_detection_index": 0,
            "role": "Tori",
            "confirmation_source": "human-confirmed",
        },
        "support_leg": {
            "side": "left",
            "confirmation_source": "human-confirmed",
        },
        "angle_frame": {
            "frame": {"frame_index": 50, "timestamp_ms": 2000},
            "selection_source": "human-selected",
            "event_label": "reviewed-angle-observation",
        },
        "camera_suitability": {
            "projected_angle_view_suitable": True,
            "low_roll_confirmed": True,
            "review_source": "human-reviewed",
        },
        "pose_observation": {
            "frame": {"frame_index": 50, "timestamp_ms": 2000},
            "neutral_track_id": "Track A",
            "detection_index": 0,
            "image_width": 640,
            "image_height": 360,
            "coordinate_space": "normalized_image",
            "provenance": "model-estimated",
            "landmarks": {
                "left_shoulder": {"x": 0.4, "y": 0.2, "visibility": 0.9},
                "right_shoulder": {"x": 0.6, "y": 0.2, "visibility": 0.9},
                "left_hip": {"x": 0.4, "y": 0.5, "visibility": 0.8},
                "right_hip": {"x": 0.6, "y": 0.5, "visibility": 0.8},
                "left_knee": {"x": 0.4, "y": 0.7, "visibility": 0.8},
                "left_ankle": {"x": 0.4, "y": 0.9, "visibility": 0.7},
            },
        },
    }


class SingleAttemptV2AApiTest(TestCase):
    def test_openapi_exposes_only_the_server_derived_video_contract(self) -> None:
        paths = app.openapi()["paths"]
        self.assertNotIn(
            "/v2a/analysis/single-camera/uchi-mata/single-attempt",
            paths,
        )
        operation = paths[
            "/v2a/analysis/single-camera/uchi-mata/single-attempt/video"
        ]["post"]

        self.assertIn("requestBody", operation)
        self.assertIn("200", operation["responses"])
        self.assertEqual(
            operation["responses"]["200"]["content"]["application/json"][
                "schema"
            ]["$ref"],
            "#/components/schemas/SingleAttemptAnalysisResponse",
        )

    def test_returns_versioned_scientifically_bounded_payload(self) -> None:
        response = analyze_single_attempt_v2a(
            SingleAttemptAnalysisRequest.model_validate(_payload())
        )
        payload = json.loads(response.model_dump_json())

        self.assertEqual(payload["schema_version"], "2.0.0")
        self.assertEqual(payload["analysis_mode"], "single_camera_2d_single_attempt")
        self.assertEqual(payload["scientific_level"], "level_1")
        self.assertEqual(
            [metric["metric_id"] for metric in payload["metrics"]],
            [
                "UM-TIM-001",
                "UM-ANG-001",
                "UM-ANG-002",
                "UM-ANG-003",
            ],
        )
        self.assertEqual(payload["metrics"][0]["provenance"], "measured")
        self.assertTrue(
            all(
                metric["provenance"] == "model-estimated"
                for metric in payload["metrics"][1:]
            )
        )
        self.assertFalse(payload["capabilities"]["automatic_tori_uke_identity"])
        self.assertFalse(payload["capabilities"]["automatic_phase_detection"])
        self.assertFalse(payload["capabilities"]["three_dimensional_reconstruction"])
        self.assertFalse(payload["capabilities"]["force_torque_power"])
        self.assertFalse(payload["capabilities"]["normative_coaching"])
        self.assertEqual(
            payload["capabilities"]["multi_person_evidence_status"],
            "insufficient",
        )
        self.assertFalse(
            payload["capabilities"][
                "multi_person_interaction_metrics_reportable"
            ]
        )

        round_trip = SingleAttemptAnalysisResponse.model_validate_json(
            response.model_dump_json()
        )
        self.assertEqual(round_trip, response)

    def test_missing_pose_returns_success_with_angles_withheld(self) -> None:
        payload = _payload()
        payload["pose_observation"] = None
        response = analyze_single_attempt_v2a(
            SingleAttemptAnalysisRequest.model_validate(payload)
        )

        self.assertEqual(response.metrics[0].status.value, "reportable")
        self.assertEqual(response.metrics[1].status.value, "withheld")
        self.assertEqual(response.metrics[2].status.value, "withheld")

    def test_request_fails_closed_on_automatic_role_or_wrong_schema(self) -> None:
        payload = _payload()
        subject = payload["subject"]
        assert isinstance(subject, dict)
        subject["confirmation_source"] = "automatic"
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)

        payload = _payload()
        payload["schema_version"] = "1.0.0"
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)
