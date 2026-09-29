from __future__ import annotations

from datetime import datetime, timedelta, timezone
from unittest import TestCase

from pydantic import ValidationError

from ai_engine.contracts.single_attempt_analysis_v2a import (
    SingleAttemptAnalysisRequest,
)
from ai_engine.single_attempt.analysis import analyze_single_attempt
from ai_engine.single_attempt.timing_manifest import (
    DecodedFrameTiming,
    SourceTimingState,
    TimingManifestError,
    TimingManifestExpired,
    TimingManifestStore,
    TimingMode,
)


def _payload(state: str, scale: float | None = None) -> dict[str, object]:
    def frame(index: int, timestamp: int) -> dict[str, object]:
        return {
            "frame_index": index,
            "timestamp_ms": timestamp,
            "pts_ms": timestamp,
            "timing_provenance": "decoder-reported-timestamp",
            "timing_manifest_id": "m" * 32,
            "video_id": "video-1",
            "canonicalization_method_version": "opencv-decoded-timeline-1.0.0",
        }
    return {
        "video_id": "video-1",
        "technique": {"id": "uchi-mata"},
        "camera_view": "side",
        "attempt": {
            "start": frame(10, 400),
            "end": frame(40, 1600),
            "event_schema_id": "human-single-attempt-boundaries-v1",
            "boundaries_human_confirmed": True,
            "source_timing": {
                "state": state,
                "timing_mode": "CFR",
                "timestamp_provenance": "decoder-reported-timestamp",
                "physical_time_scale": scale,
            },
        },
        "subject": {
            "neutral_track_id": "Track A",
            "selected_detection_index": 0,
            "role": "Tori",
        },
        "support_leg": {"side": "left"},
        "attacking_leg": {"side": "right"},
        "angle_frame": {
            "frame": frame(20, 800),
            "event_label": "human-review",
        },
        "camera_suitability": {
            "projected_angle_view_suitable": False,
            "low_roll_confirmed": False,
        },
    }


class FrameAccurateTimingTest(TestCase):
    def test_equal_reversed_and_outside_review_boundaries_are_rejected(self) -> None:
        for start, end in ((10, 10), (11, 10)):
            payload = _payload("REAL_TIME")
            payload["attempt"]["start"]["frame_index"] = start  # type: ignore[index]
            payload["attempt"]["end"]["frame_index"] = end  # type: ignore[index]
            with self.assertRaises(ValidationError):
                SingleAttemptAnalysisRequest.model_validate(payload)
        payload = _payload("REAL_TIME")
        payload["angle_frame"]["frame"]["frame_index"] = 41  # type: ignore[index]
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(payload)

    def test_real_time_uses_exact_confirmed_frames(self) -> None:
        result = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(_payload("REAL_TIME"))
        )
        metric = next(item for item in result.metrics if item.metric_id == "UM-TIM-001")
        self.assertEqual(metric.value, 1.2)
        self.assertEqual(metric.temporal_reference.start.frame_index, 10)
        self.assertIn("human-confirmed", metric.descriptive_text or "")

    def test_unknown_timing_withholds_physical_duration(self) -> None:
        result = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(_payload("UNKNOWN"))
        )
        metric = next(item for item in result.metrics if item.metric_id == "UM-TIM-001")
        self.assertEqual(metric.status.value, "withheld")
        self.assertIsNone(metric.value)
        self.assertIn("unknown", metric.withheld_reason or "")

    def test_average_fps_fallback_withholds_even_when_user_declares_real_time(self) -> None:
        payload = _payload("REAL_TIME")
        source = payload["attempt"]["source_timing"]  # type: ignore[index]
        source["timing_mode"] = "UNKNOWN"  # type: ignore[index]
        source["timestamp_provenance"] = "average-fps-derived-not-true-pts"  # type: ignore[index]
        result = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(payload)
        )
        metric = next(item for item in result.metrics if item.metric_id == "UM-TIM-001")
        self.assertEqual(metric.status.value, "withheld")

    def test_vfr_decoder_timestamps_can_preserve_selected_window(self) -> None:
        payload = _payload("REAL_TIME")
        payload["attempt"]["source_timing"]["timing_mode"] = "VFR"  # type: ignore[index]
        result = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(payload)
        )
        metric = next(item for item in result.metrics if item.metric_id == "UM-TIM-001")
        self.assertEqual(metric.value, 1.2)

    def test_known_time_scale_is_explicitly_applied(self) -> None:
        result = analyze_single_attempt(
            SingleAttemptAnalysisRequest.model_validate(
                _payload("KNOWN_TIME_SCALE", 0.25)
            )
        )
        metric = next(item for item in result.metrics if item.metric_id == "UM-TIM-001")
        self.assertAlmostEqual(metric.value or 0, 0.3)
        with self.assertRaises(ValidationError):
            SingleAttemptAnalysisRequest.model_validate(_payload("KNOWN_TIME_SCALE"))

    def test_manifest_rejects_wrong_video_stale_and_out_of_range(self) -> None:
        now = [datetime(2026, 1, 1, tzinfo=timezone.utc)]
        store = TimingManifestStore(ttl=timedelta(seconds=1), clock=lambda: now[0])
        manifest = store.create(
            video_id="video-1",
            video_sha256="abc",
            frames=(DecodedFrameTiming(0, 0, 0.0), DecodedFrameTiming(1, 40, 40.0)),
            timing_mode=TimingMode.CFR,
            duration_ms=80,
            source_fps=25.0,
            timestamp_provenance="decoder-reported-timestamp",
            source_timing_state=SourceTimingState.REAL_TIME,
            physical_time_scale=None,
        )
        with self.assertRaises(TimingManifestError):
            store.resolve(manifest.manifest_id, video_id="other", video_sha256="abc")
        with self.assertRaises(TimingManifestError):
            manifest.frame(2)
        now[0] += timedelta(seconds=2)
        with self.assertRaises(TimingManifestExpired):
            store.resolve(manifest.manifest_id, video_id="video-1", video_sha256="abc")
