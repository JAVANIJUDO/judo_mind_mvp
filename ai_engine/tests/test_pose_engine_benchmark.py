from __future__ import annotations

import json
from pathlib import Path
from threading import Event
from unittest import TestCase

from ai_engine.benchmarks.benchmark_control import BenchmarkTimedOut
from ai_engine.benchmarks.pose_engine_benchmark import (
    EngineCapability,
    PoseEngineBenchmark,
    _coverage_from_pose_counts,
    _successful_engine_result,
    build_benchmark_runners,
    require_cached_rtmlib_models,
    render_human_report,
)


_FAKE_CAPABILITY = EngineCapability(
    engine_id="fake-pose",
    implementation="test fake",
    model="none",
    multi_person="test_only",
    keypoint_format="test points",
    confidence_signal="test score",
    cpu_backend="test",
    runtime_device="cpu",
    execution_provider="test provider",
    tracking_support="none",
    limitations=("test-only output",),
)


class _FakeRunner:
    capability = _FAKE_CAPABILITY

    def run(self, video_path, sampling_plan, keypoint_threshold, control):
        del video_path, keypoint_threshold
        self.observed_indices = sampling_plan.frame_indices
        pose_counts = tuple(
            (0, 1, 2, 2)[index % 4]
            for index in range(sampling_plan.planned_frame_count)
        )

        for frame_index, timestamp_ms, pose_count in zip(
            sampling_plan.frame_indices,
            sampling_plan.timestamps_ms,
            pose_counts,
        ):
            control.before_sample()
            control.record_sample(
                frame_index=frame_index,
                timestamp_ms=timestamp_ms,
                pose_count=pose_count,
            )

        return _successful_engine_result(
            capability=self.capability,
            pose_counts=pose_counts,
            frame_indices=sampling_plan.frame_indices,
            timestamps_ms=sampling_plan.timestamps_ms,
            initialization_seconds=0.1,
            processing_seconds=2.0,
            duration_seconds=1.0,
            confidence_values=(0.5, 0.7),
            stage_timings_seconds={
                "decode": 0.1,
                "preprocessing": 0.2,
                "inference": 1.5,
                "postprocessing": 0.2,
            },
        )


class _FailingRunner:
    capability = EngineCapability(
        **{
            **_FAKE_CAPABILITY.__dict__,
            "engine_id": "failing-pose",
        }
    )

    def run(self, video_path, sampling_plan, keypoint_threshold, control):
        del video_path, sampling_plan, keypoint_threshold, control
        raise RuntimeError("expected test failure")


class _MissingDependencyRunner:
    capability = EngineCapability(
        **{
            **_FAKE_CAPABILITY.__dict__,
            "engine_id": "missing-dependency",
        }
    )

    def run(self, video_path, sampling_plan, keypoint_threshold, control):
        del video_path, sampling_plan, keypoint_threshold, control
        raise ModuleNotFoundError("offline dependency unavailable")


class _TimeoutRunner:
    capability = EngineCapability(
        **{
            **_FAKE_CAPABILITY.__dict__,
            "engine_id": "timeout-pose",
        }
    )

    def run(self, video_path, sampling_plan, keypoint_threshold, control):
        del video_path, keypoint_threshold
        control.record_sample(
            frame_index=sampling_plan.frame_indices[0],
            timestamp_ms=sampling_plan.timestamps_ms[0],
            pose_count=1,
        )
        raise BenchmarkTimedOut("synthetic per-engine timeout")


def _fake_video_probe(video_path: Path) -> dict:
    return {
        "path": str(video_path),
        "width": 1920,
        "height": 1080,
        "source_fps": 25.0,
        "frame_count": 10,
        "duration_seconds": 0.4,
        "provenance": "measured",
    }


def _real_shape_video_probe(video_path: Path) -> dict:
    return {
        "path": str(video_path),
        "width": 640,
        "height": 360,
        "source_fps": 25.0,
        "frame_count": 2768,
        "duration_seconds": 110.72,
        "provenance": "measured",
    }


class PoseEngineBenchmarkTest(TestCase):
    def test_coverage_metrics_keep_one_and_two_pose_counts_separate(
        self,
    ) -> None:
        metrics = _coverage_from_pose_counts((0, 1, 2, 3))

        self.assertEqual(metrics["processed_frames"], 4)
        self.assertEqual(metrics["zero_pose_frames"], 1)
        self.assertEqual(metrics["one_pose_frames"], 1)
        self.assertEqual(metrics["two_or_more_pose_frames"], 2)
        self.assertEqual(metrics["at_least_one_pose_coverage"], 0.75)
        self.assertEqual(metrics["at_least_two_pose_coverage"], 0.5)

    def test_coverage_handles_no_one_and_two_pose_sequences(self) -> None:
        cases = (
            ((), 0.0, 0.0),
            ((0, 0), 0.0, 0.0),
            ((1, 1), 1.0, 0.0),
            ((2, 2), 1.0, 1.0),
        )

        for pose_counts, one_coverage, two_coverage in cases:
            with self.subTest(pose_counts=pose_counts):
                metrics = _coverage_from_pose_counts(pose_counts)
                self.assertEqual(
                    metrics["at_least_one_pose_coverage"],
                    one_coverage,
                )
                self.assertEqual(
                    metrics["at_least_two_pose_coverage"],
                    two_coverage,
                )

    def test_harness_shares_sampling_plan_and_isolates_engine_failure(
        self,
    ) -> None:
        fake_runner = _FakeRunner()
        benchmark = PoseEngineBenchmark(
            runners=(fake_runner, _FailingRunner()),
            video_probe=_fake_video_probe,
        )

        result = benchmark.run("explicit-single-camera.mp4", target_fps=10.0)

        self.assertEqual(result["schema_version"], "1.2.0")
        self.assertEqual(result["sampling"]["frame_indices"], [0, 3, 5, 8])
        self.assertEqual(fake_runner.observed_indices, (0, 3, 5, 8))
        self.assertEqual(result["engines"][0]["status"], "completed")
        self.assertEqual(
            result["engines"][0]["observations"][1],
            {"frame_index": 3, "timestamp_ms": 120, "pose_count": 1},
        )
        self.assertEqual(
            result["engines"][0]["metrics"]["pose_coverage_provenance"],
            "model-estimated",
        )
        self.assertEqual(result["engines"][1]["status"], "failed")
        self.assertEqual(
            result["engines"][1]["metrics"]["failure_count"],
            1,
        )
        self.assertEqual(
            set(result["engines"][0]["metrics"]),
            set(result["engines"][1]["metrics"]),
        )
        self.assertEqual(result["engines"][1]["observations"], [])
        self.assertEqual(result["engines"][1]["metrics"]["missing_frames"], 4)
        self.assertGreaterEqual(
            result["engines"][1]["metrics"]["processing_seconds"],
            0.0,
        )
        self.assertIn(
            "Pose order is frame-local",
            " ".join(result["limitations"]),
        )

    def test_missing_dependency_is_reported_without_aborting_other_engines(
        self,
    ) -> None:
        benchmark = PoseEngineBenchmark(
            runners=(_MissingDependencyRunner(), _FakeRunner()),
            video_probe=_fake_video_probe,
        )

        result = benchmark.run("explicit-single-camera.mp4")

        self.assertEqual(result["engines"][0]["status"], "failed")
        self.assertEqual(
            result["engines"][0]["failures"][0]["type"],
            "ModuleNotFoundError",
        )
        self.assertEqual(result["engines"][1]["status"], "completed")

    def test_timing_metrics_are_derived_from_processed_frames(self) -> None:
        benchmark = PoseEngineBenchmark(
            runners=(_FakeRunner(),),
            video_probe=_fake_video_probe,
        )

        metrics = benchmark.run("explicit-single-camera.mp4")["engines"][0][
            "metrics"
        ]

        self.assertEqual(metrics["processing_fps"], 2.0)
        self.assertEqual(metrics["effective_analyzed_fps"], 4.0)

    def test_result_schema_is_json_serializable_and_stable(self) -> None:
        benchmark = PoseEngineBenchmark(
            runners=(_FakeRunner(), _FailingRunner()),
            video_probe=_fake_video_probe,
        )

        result = benchmark.run("explicit-single-camera.mp4")
        restored = json.loads(json.dumps(result))

        self.assertEqual(restored["schema_version"], "1.2.0")
        self.assertEqual(
            set(restored["engines"][0]),
            set(restored["engines"][1]),
        )
        self.assertEqual(
            set(restored["engines"][0]["metrics"]),
            set(restored["engines"][1]["metrics"]),
        )

    def test_progress_callback_receives_partial_then_completed_checkpoint(
        self,
    ) -> None:
        checkpoints: list[dict] = []
        benchmark = PoseEngineBenchmark(
            runners=(_FakeRunner(), _FailingRunner()),
            video_probe=_fake_video_probe,
        )

        result = benchmark.run(
            "explicit-single-camera.mp4",
            progress_callback=checkpoints.append,
        )

        self.assertEqual(
            [checkpoint["run_status"] for checkpoint in checkpoints],
            ["partial", "completed"],
        )
        self.assertEqual(
            [checkpoint["completed_engine_count"] for checkpoint in checkpoints],
            [1, 2],
        )
        self.assertEqual(result["run_status"], "completed")

    def test_builds_selected_runners_in_requested_order(self) -> None:
        runners = build_benchmark_runners(("rtmo-m", "mediapipe-heavy"))

        self.assertEqual(
            [runner.capability.engine_id for runner in runners],
            ["rtmo-m", "mediapipe-heavy"],
        )

    def test_human_report_contains_comparable_engine_metrics(self) -> None:
        benchmark = PoseEngineBenchmark(
            runners=(_FakeRunner(),),
            video_probe=_fake_video_probe,
        )
        report = render_human_report(
            benchmark.run("explicit-single-camera.mp4")
        )

        self.assertIn(
            "fake-pose | cpu | completed | 4 | 75.00% | 50.00%",
            report,
        )
        self.assertIn("Scientific limitations:", report)

    def test_missing_cached_model_fails_without_downloading(self) -> None:
        with self.assertRaisesRegex(
            FileNotFoundError,
            "automatic model download is disabled",
        ):
            require_cached_rtmlib_models(
                ("missing-model.onnx",),
                checkpoint_directory=Path("definitely-missing-cache"),
            )

    def test_rejects_invalid_keypoint_threshold(self) -> None:
        benchmark = PoseEngineBenchmark(
            runners=(_FakeRunner(),),
            video_probe=_fake_video_probe,
        )

        with self.assertRaises(ValueError):
            benchmark.run(
                "explicit-single-camera.mp4",
                keypoint_threshold=1.1,
            )

    def test_fast_screening_uses_same_100_full_span_timestamps(self) -> None:
        first_runner = _FakeRunner()
        second_runner = _FakeRunner()
        benchmark = PoseEngineBenchmark(
            runners=(first_runner, second_runner),
            video_probe=_real_shape_video_probe,
        )

        result = benchmark.run(
            "authorized-input.mp4",
            fast_screening=True,
        )

        self.assertEqual(result["benchmark_mode"], "fast_screening")
        self.assertEqual(result["sampling"]["full_plan_frame_count"], 1108)
        self.assertEqual(result["sampling"]["planned_frame_count"], 100)
        self.assertEqual(result["sampling"]["frame_indices"][0], 0)
        self.assertEqual(result["sampling"]["frame_indices"][-1], 2767)
        self.assertEqual(first_runner.observed_indices, second_runner.observed_indices)
        self.assertEqual(len(first_runner.observed_indices), 100)
        self.assertFalse(result["screening"]["automatic_pass_decision"])

    def test_timeout_keeps_partial_observation_and_continues(self) -> None:
        benchmark = PoseEngineBenchmark(
            runners=(_TimeoutRunner(), _FakeRunner()),
            video_probe=_fake_video_probe,
        )

        result = benchmark.run("explicit-single-camera.mp4")

        self.assertEqual(result["engines"][0]["status"], "timed_out")
        self.assertEqual(result["engines"][0]["metrics"]["processed_frames"], 1)
        self.assertEqual(result["engines"][0]["metrics"]["missing_frames"], 3)
        self.assertEqual(result["engines"][1]["status"], "completed")

    def test_preexisting_cancellation_skips_all_engines(self) -> None:
        cancellation = Event()
        cancellation.set()
        benchmark = PoseEngineBenchmark(
            runners=(_FakeRunner(),),
            video_probe=_fake_video_probe,
        )

        result = benchmark.run(
            "explicit-single-camera.mp4",
            cancellation_event=cancellation,
        )

        self.assertEqual(result["run_status"], "cancelled")
        self.assertEqual(result["completed_engine_count"], 0)
