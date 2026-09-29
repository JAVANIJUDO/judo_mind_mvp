from __future__ import annotations

from threading import Event
from unittest import TestCase

from ai_engine.benchmarks.benchmark_control import (
    BenchmarkCancelled,
    BenchmarkRunControl,
    BenchmarkTimedOut,
)


class _FakeClock:
    def __init__(self) -> None:
        self.value = 0.0

    def __call__(self) -> float:
        return self.value


class BenchmarkRunControlTest(TestCase):
    def test_progress_reports_count_elapsed_rate_and_reliable_eta(self) -> None:
        clock = _FakeClock()
        progress: list[dict] = []
        control = BenchmarkRunControl(
            engine_id="fake-engine",
            total_samples=100,
            timeout_seconds=60.0,
            progress_callback=progress.append,
            progress_interval_frames=1,
            clock=clock,
        )

        for sample in range(5):
            clock.value = float(sample + 1)
            control.record_sample(
                frame_index=sample,
                timestamp_ms=sample * 100,
                pose_count=1,
            )

        latest = progress[-1]
        self.assertEqual(latest["processed_samples"], 5)
        self.assertEqual(latest["total_samples"], 100)
        self.assertEqual(latest["elapsed_seconds"], 5.0)
        self.assertEqual(latest["effective_processing_fps"], 1.0)
        self.assertTrue(latest["eta_reliable"])
        self.assertEqual(latest["eta_seconds"], 95.0)

    def test_timeout_retains_completed_sample(self) -> None:
        clock = _FakeClock()
        control = BenchmarkRunControl(
            engine_id="slow-engine",
            total_samples=10,
            timeout_seconds=5.0,
            clock=clock,
        )
        clock.value = 6.0

        with self.assertRaises(BenchmarkTimedOut):
            control.record_sample(
                frame_index=3,
                timestamp_ms=120,
                pose_count=2,
            )

        self.assertEqual(control.processed_samples, 1)
        self.assertEqual(control.observations[0]["pose_count"], 2)

    def test_cancellation_is_cooperative_between_model_calls(self) -> None:
        cancellation = Event()
        control = BenchmarkRunControl(
            engine_id="cancelled-engine",
            total_samples=10,
            timeout_seconds=60.0,
            cancellation_event=cancellation,
        )
        cancellation.set()

        with self.assertRaises(BenchmarkCancelled):
            control.before_sample()

        self.assertEqual(control.processed_samples, 0)
