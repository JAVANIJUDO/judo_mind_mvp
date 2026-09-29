from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
import json
import os
from pathlib import Path
import signal
from threading import Event
import time
from typing import Any, Callable, Protocol, Sequence

import cv2
import numpy as np

from ai_engine.pose_engine import JudoPoseEngine
from ai_engine.rtmpose_engine import JudoRTMOEngine
from ai_engine.benchmarks.benchmark_control import (
    BenchmarkCancelled,
    BenchmarkRunControl,
    BenchmarkTimedOut,
)
from ai_engine.video_sampling import (
    VideoSamplingPlan,
    build_video_sampling_plan,
    select_distributed_sampling_subset,
)


SCHEMA_VERSION = "1.2.0"
DEFAULT_KEYPOINT_THRESHOLD = 0.30
DEFAULT_ENGINE_TIMEOUT_SECONDS = 1800.0
DEFAULT_PROGRESS_INTERVAL_FRAMES = 10
MAX_FAST_SCREENING_FRAMES = 100
MINIMUM_VISIBLE_KEYPOINTS = 8
RTMO_M_FILENAME = (
    "rtmo-m_16xb16-600e_body7-640x640-39e78cc4_20231211.onnx"
)
RTMPOSE_M_FILENAME = (
    "rtmpose-m_simcc-body7_pt-body7_420e-256x192-e48f03d0_20230504.onnx"
)
YOLOX_M_FILENAME = "yolox_m_8xb8-300e_humanart-c2c7a14a.onnx"


@dataclass(frozen=True)
class EngineCapability:
    engine_id: str
    implementation: str
    model: str
    multi_person: str
    keypoint_format: str
    confidence_signal: str | None
    cpu_backend: str
    runtime_device: str
    execution_provider: str
    tracking_support: str
    limitations: tuple[str, ...]


class BenchmarkRunner(Protocol):
    capability: EngineCapability

    def run(
        self,
        video_path: Path,
        sampling_plan: VideoSamplingPlan,
        keypoint_threshold: float,
        control: BenchmarkRunControl,
    ) -> dict[str, Any]: ...


def _rtmlib_checkpoint_directory() -> Path:
    cache_root = Path(
        os.path.expanduser(os.getenv("XDG_CACHE_HOME", "~/.cache"))
    )
    return cache_root / "rtmlib" / "hub" / "checkpoints"


def require_cached_rtmlib_models(
    filenames: Sequence[str],
    *,
    checkpoint_directory: Path | None = None,
) -> dict[str, Path]:
    """Fail closed instead of allowing RTMLib to download benchmark models."""

    directory = checkpoint_directory or _rtmlib_checkpoint_directory()
    resolved = {filename: directory / filename for filename in filenames}
    missing = [str(path) for path in resolved.values() if not path.is_file()]

    if missing:
        raise FileNotFoundError(
            "Benchmark model cache is incomplete; automatic model download "
            f"is disabled. Missing: {', '.join(missing)}"
        )

    return resolved


def probe_video_metadata(video_path: Path) -> dict[str, Any]:
    if not video_path.exists():
        raise FileNotFoundError(f"Video not found: {video_path}")

    capture = cv2.VideoCapture(str(video_path))

    if not capture.isOpened():
        raise RuntimeError(f"Unable to open video: {video_path}")

    try:
        source_fps = float(capture.get(cv2.CAP_PROP_FPS))
        frame_count = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))
        width = int(capture.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(capture.get(cv2.CAP_PROP_FRAME_HEIGHT))
    finally:
        capture.release()

    if source_fps <= 0:
        raise RuntimeError("Video does not report a valid source FPS.")

    if frame_count <= 0:
        raise RuntimeError("Video does not report a valid frame count.")

    return {
        "path": str(video_path),
        "width": width,
        "height": height,
        "source_fps": source_fps,
        "frame_count": frame_count,
        "duration_seconds": frame_count / source_fps,
        "provenance": "measured",
    }


def _coverage_from_pose_counts(pose_counts: Sequence[int]) -> dict[str, Any]:
    processed_frames = len(pose_counts)
    frames_with_at_least_one = sum(count >= 1 for count in pose_counts)
    frames_with_at_least_two = sum(count >= 2 for count in pose_counts)
    one_pose_frames = sum(count == 1 for count in pose_counts)

    return {
        "processed_frames": processed_frames,
        "zero_pose_frames": sum(count == 0 for count in pose_counts),
        "one_pose_frames": one_pose_frames,
        "two_or_more_pose_frames": frames_with_at_least_two,
        "frames_with_at_least_one_pose": frames_with_at_least_one,
        "frames_with_at_least_two_poses": frames_with_at_least_two,
        "at_least_one_pose_coverage": (
            frames_with_at_least_one / processed_frames
            if processed_frames
            else 0.0
        ),
        "at_least_two_pose_coverage": (
            frames_with_at_least_two / processed_frames
            if processed_frames
            else 0.0
        ),
    }


def _mean_or_none(values: Sequence[float]) -> float | None:
    if not values:
        return None

    return float(sum(values) / len(values))


class MediaPipeHeavyRunner:
    capability = EngineCapability(
        engine_id="mediapipe-heavy",
        implementation="ai_engine.pose_engine.JudoPoseEngine",
        model="MediaPipe Pose Landmarker Heavy",
        multi_person="configured_for_up_to_2_frame_local_poses",
        keypoint_format=(
            "33 normalized image landmarks plus model-relative world landmarks"
        ),
        confidence_signal="landmark visibility and presence",
        cpu_backend="MediaPipe Tasks CPU",
        runtime_device="cpu",
        execution_provider="MediaPipe Tasks / TensorFlow Lite XNNPACK CPU",
        tracking_support=(
            "internal temporal pose tracking; no persistent athlete identity"
        ),
        limitations=(
            "pose_index is frame-local and must not be treated as identity",
            "world landmarks are model-estimated, not reconstructed 3D",
        ),
    )

    def run(
        self,
        video_path: Path,
        sampling_plan: VideoSamplingPlan,
        keypoint_threshold: float,
        control: BenchmarkRunControl,
    ) -> dict[str, Any]:
        del keypoint_threshold
        initialization_started = time.perf_counter()
        engine = JudoPoseEngine()
        initialization_seconds = time.perf_counter() - initialization_started

        try:
            processing_started = time.perf_counter()
            raw = engine.analyze_video(
                video_path,
                target_fps=sampling_plan.requested_target_fps,
                sampling_plan=sampling_plan,
                before_sample=control.before_sample,
                after_sample=lambda frame_index, timestamp_ms, pose_count: (
                    control.record_sample(
                        frame_index=frame_index,
                        timestamp_ms=timestamp_ms,
                        pose_count=pose_count,
                    )
                ),
            )
            processing_seconds = time.perf_counter() - processing_started
        finally:
            engine.close()

        frames = raw["frames"]
        pose_counts = [int(frame["pose_count"]) for frame in frames]
        observed_indices = tuple(int(frame["frame_index"]) for frame in frames)

        if observed_indices != sampling_plan.frame_indices:
            raise RuntimeError(
                "MediaPipe sampled frames differ from the shared sampling plan."
            )

        visibility_values = [
            float(landmark["visibility"])
            for frame in frames
            for pose in frame["poses"]
            for landmark in pose["landmarks"]
            if landmark.get("visibility") is not None
        ]

        return _successful_engine_result(
            capability=self.capability,
            pose_counts=pose_counts,
            frame_indices=observed_indices,
            timestamps_ms=tuple(
                int(frame["timestamp_ms"]) for frame in frames
            ),
            initialization_seconds=initialization_seconds,
            processing_seconds=processing_seconds,
            duration_seconds=raw["video"]["duration_seconds"],
            confidence_values=visibility_values,
            stage_timings_seconds=raw["analysis"].get(
                "stage_timings_seconds"
            ),
        )


class RTMORunner:
    capability = EngineCapability(
        engine_id="rtmo-m",
        implementation="ai_engine.rtmpose_engine.JudoRTMOEngine",
        model="RTMO-M body7 balanced",
        multi_person="native_one_stage_multi_person",
        keypoint_format="COCO 17 image-pixel keypoints",
        confidence_signal="per-keypoint model score",
        cpu_backend="ONNX Runtime CPU",
        runtime_device="cpu",
        execution_provider="ONNX Runtime CPUExecutionProvider",
        tracking_support="none in the current project wrapper",
        limitations=(
            "the project filename rtmpose_engine.py is misleading",
            "detections have no persistent athlete identity",
        ),
    )

    def run(
        self,
        video_path: Path,
        sampling_plan: VideoSamplingPlan,
        keypoint_threshold: float,
        control: BenchmarkRunControl,
    ) -> dict[str, Any]:
        require_cached_rtmlib_models((RTMO_M_FILENAME,))
        initialization_started = time.perf_counter()
        engine = JudoRTMOEngine()
        initialization_seconds = time.perf_counter() - initialization_started
        raw = engine.analyze_video(
            video_path,
            target_fps=sampling_plan.requested_target_fps,
            keypoint_threshold=keypoint_threshold,
            sampling_plan=sampling_plan,
            before_sample=control.before_sample,
            after_sample=lambda frame_index, timestamp_ms, pose_count: (
                control.record_sample(
                    frame_index=frame_index,
                    timestamp_ms=timestamp_ms,
                    pose_count=pose_count,
                )
            ),
        )
        analysis = raw["analysis"]
        frames = raw["frames"]
        observed_indices = tuple(
            int(frame["frame_index"]) for frame in frames
        )

        if observed_indices != sampling_plan.frame_indices:
            raise RuntimeError(
                "RTMO sampled frames differ from the shared sampling plan."
            )

        pose_counts = tuple(
            int(frame["pose_count"]) for frame in frames
        )
        mean_confidence = analysis.get("mean_keypoint_confidence")

        return _successful_engine_result(
            capability=self.capability,
            pose_counts=pose_counts,
            frame_indices=observed_indices,
            timestamps_ms=tuple(
                int(frame["timestamp_ms"]) for frame in frames
            ),
            initialization_seconds=initialization_seconds,
            processing_seconds=float(analysis["processing_seconds"]),
            duration_seconds=raw["video"]["duration_seconds"],
            confidence_values=(
                (float(mean_confidence),)
                if mean_confidence is not None
                else ()
            ),
            stage_timings_seconds=analysis.get("stage_timings_seconds"),
        )


class RTMPoseMRunner:
    capability = EngineCapability(
        engine_id="rtmpose-m",
        implementation="rtmlib.Body balanced two-stage benchmark adapter",
        model="YOLOX-M detector plus RTMPose-M body7",
        multi_person="top_down_multi_person_from_detector_boxes",
        keypoint_format="COCO 17 image-pixel keypoints",
        confidence_signal="per-keypoint model score",
        cpu_backend="ONNX Runtime CPU",
        runtime_device="cpu",
        execution_provider="ONNX Runtime CPUExecutionProvider",
        tracking_support=(
            "RTMLib PoseTracker is available but is not wired into this runner"
        ),
        limitations=(
            "benchmark-only adapter; not the production FastAPI pose engine",
            "detections have no persistent athlete identity",
        ),
    )

    def run(
        self,
        video_path: Path,
        sampling_plan: VideoSamplingPlan,
        keypoint_threshold: float,
        control: BenchmarkRunControl,
    ) -> dict[str, Any]:
        from rtmlib import Body

        cached_models = require_cached_rtmlib_models(
            (YOLOX_M_FILENAME, RTMPOSE_M_FILENAME)
        )
        initialization_started = time.perf_counter()
        model = Body(
            det=str(cached_models[YOLOX_M_FILENAME]),
            det_input_size=(640, 640),
            pose=str(cached_models[RTMPOSE_M_FILENAME]),
            pose_input_size=(192, 256),
            to_openpose=False,
            backend="onnxruntime",
            device="cpu",
        )
        initialization_seconds = time.perf_counter() - initialization_started
        capture = cv2.VideoCapture(str(video_path))

        if not capture.isOpened():
            raise RuntimeError(f"Unable to open video: {video_path}")

        selected_indices = set(sampling_plan.frame_indices)
        pose_counts: list[int] = []
        confidence_values: list[float] = []
        frame_index = 0
        decode_seconds = 0.0
        inference_seconds = 0.0
        postprocessing_seconds = 0.0
        processing_started = time.perf_counter()

        try:
            while True:
                decode_started = time.perf_counter()
                success, frame = capture.read()
                decode_seconds += time.perf_counter() - decode_started

                if not success:
                    break

                if frame_index not in selected_indices:
                    frame_index += 1
                    continue

                control.before_sample()
                inference_started = time.perf_counter()
                keypoints, scores = model(frame)
                inference_seconds += time.perf_counter() - inference_started
                postprocessing_started = time.perf_counter()
                keypoints_array = np.asarray(keypoints)
                scores_array = np.asarray(scores)
                valid_indices = _valid_pose_indices(
                    keypoints_array,
                    scores_array,
                    keypoint_threshold,
                )
                pose_counts.append(len(valid_indices))

                for pose_index in valid_indices:
                    confidence_values.extend(
                        float(value) for value in scores_array[pose_index]
                    )

                postprocessing_seconds += (
                    time.perf_counter() - postprocessing_started
                )
                control.record_sample(
                    frame_index=frame_index,
                    timestamp_ms=(
                        sampling_plan.timestamps_ms[len(pose_counts) - 1]
                    ),
                    pose_count=len(valid_indices),
                )

                frame_index += 1
        finally:
            capture.release()

        processing_seconds = time.perf_counter() - processing_started

        if len(pose_counts) != sampling_plan.planned_frame_count:
            raise RuntimeError(
                "RTMPose processed frame count differs from the shared plan."
            )

        duration_seconds = (
            sampling_plan.frame_count / sampling_plan.source_fps
        )

        return _successful_engine_result(
            capability=self.capability,
            pose_counts=pose_counts,
            frame_indices=sampling_plan.frame_indices,
            timestamps_ms=sampling_plan.timestamps_ms,
            initialization_seconds=initialization_seconds,
            processing_seconds=processing_seconds,
            duration_seconds=duration_seconds,
            confidence_values=confidence_values,
            stage_timings_seconds={
                "decode": decode_seconds,
                "preprocessing": 0.0,
                "inference": inference_seconds,
                "postprocessing": postprocessing_seconds,
            },
        )


def _valid_pose_indices(
    keypoints: np.ndarray,
    scores: np.ndarray,
    threshold: float,
) -> list[int]:
    if keypoints.size == 0 or scores.size == 0:
        return []

    normalized_scores = scores

    if normalized_scores.ndim == 1:
        normalized_scores = np.expand_dims(normalized_scores, axis=0)

    return [
        index
        for index, person_scores in enumerate(normalized_scores)
        if int(np.sum(person_scores >= threshold))
        >= MINIMUM_VISIBLE_KEYPOINTS
    ]


def _successful_engine_result(
    *,
    capability: EngineCapability,
    pose_counts: Sequence[int],
    frame_indices: Sequence[int],
    timestamps_ms: Sequence[int],
    initialization_seconds: float,
    processing_seconds: float,
    duration_seconds: float,
    confidence_values: Sequence[float] | None,
    stage_timings_seconds: dict[str, float] | None = None,
) -> dict[str, Any]:
    if not (
        len(pose_counts) == len(frame_indices) == len(timestamps_ms)
    ):
        raise ValueError(
            "Pose counts, frame indices and timestamps must have equal length."
        )

    coverage = _coverage_from_pose_counts(pose_counts)
    processed_frames = coverage["processed_frames"]
    observations = [
        {
            "frame_index": int(frame_index),
            "timestamp_ms": int(timestamp_ms),
            "pose_count": int(pose_count),
        }
        for frame_index, timestamp_ms, pose_count in zip(
            frame_indices,
            timestamps_ms,
            pose_counts,
        )
    ]

    return {
        "status": "completed",
        "availability": "available",
        **asdict(capability),
        "metrics": {
            **coverage,
            "pose_coverage_provenance": "model-estimated",
            "initialization_seconds": initialization_seconds,
            "processing_seconds": processing_seconds,
            "processing_fps": (
                processed_frames / processing_seconds
                if processing_seconds > 0
                else 0.0
            ),
            "effective_analyzed_fps": (
                processed_frames / duration_seconds
                if duration_seconds > 0
                else 0.0
            ),
            "keypoint_confidence_available": (
                capability.confidence_signal is not None
            ),
            "keypoint_confidence_provenance": "model-estimated",
            "mean_keypoint_confidence": (
                _mean_or_none(confidence_values)
                if confidence_values is not None
                else None
            ),
            "stage_timings_seconds": stage_timings_seconds,
            "failure_count": 0,
            "missing_frames": 0,
        },
        "observations": observations,
        "failures": [],
    }


def _failed_engine_result(
    *,
    capability: EngineCapability,
    error: Exception,
    planned_frame_count: int,
    observations: Sequence[dict[str, int]] = (),
    elapsed_seconds: float | None = None,
) -> dict[str, Any]:
    """Return the same metrics schema as a completed runner, with no claims."""

    coverage = _coverage_from_pose_counts(
        tuple(int(item["pose_count"]) for item in observations)
    )
    status = (
        "timed_out"
        if isinstance(error, BenchmarkTimedOut)
        else "cancelled"
        if isinstance(error, BenchmarkCancelled)
        else "failed"
    )

    return {
        "status": status,
        "availability": (
            "unavailable"
            if isinstance(error, (FileNotFoundError, ModuleNotFoundError))
            else "available_but_failed"
        ),
        **asdict(capability),
        "metrics": {
            **coverage,
            "pose_coverage_provenance": "model-estimated",
            "initialization_seconds": None,
            "processing_seconds": elapsed_seconds,
            "processing_fps": (
                coverage["processed_frames"] / elapsed_seconds
                if elapsed_seconds and elapsed_seconds > 0
                else 0.0
            ),
            "effective_analyzed_fps": 0.0,
            "keypoint_confidence_available": (
                capability.confidence_signal is not None
            ),
            "keypoint_confidence_provenance": "model-estimated",
            "mean_keypoint_confidence": None,
            "stage_timings_seconds": None,
            "failure_count": 1,
            "missing_frames": max(
                0,
                planned_frame_count - coverage["processed_frames"],
            ),
        },
        "observations": list(observations),
        "failures": [
            {
                "stage": "engine_run",
                "type": type(error).__name__,
                "message": str(error),
            }
        ],
    }


class PoseEngineBenchmark:
    def __init__(
        self,
        runners: Sequence[BenchmarkRunner] | None = None,
        video_probe: Callable[[Path], dict[str, Any]] = probe_video_metadata,
    ) -> None:
        self._runners = tuple(
            runners
            if runners is not None
            else (
                MediaPipeHeavyRunner(),
                RTMPoseMRunner(),
                RTMORunner(),
            )
        )
        self._video_probe = video_probe

    def run(
        self,
        video_path: str | Path,
        *,
        target_fps: float = 10.0,
        keypoint_threshold: float = DEFAULT_KEYPOINT_THRESHOLD,
        progress_callback: Callable[[dict[str, Any]], None] | None = None,
        engine_progress_callback: (
            Callable[[dict[str, Any]], None] | None
        ) = None,
        engine_timeout_seconds: float = DEFAULT_ENGINE_TIMEOUT_SECONDS,
        progress_interval_frames: int = DEFAULT_PROGRESS_INTERVAL_FRAMES,
        cancellation_event: Event | None = None,
        fast_screening: bool = False,
        screening_max_frames: int = MAX_FAST_SCREENING_FRAMES,
    ) -> dict[str, Any]:
        path = Path(video_path)

        if not 0.0 <= keypoint_threshold <= 1.0:
            raise ValueError("keypoint_threshold must be between 0 and 1.")

        if fast_screening:
            if screening_max_frames < 1:
                raise ValueError("screening_max_frames must be positive.")

            if screening_max_frames > MAX_FAST_SCREENING_FRAMES:
                raise ValueError(
                    "FAST SCREENING cannot exceed "
                    f"{MAX_FAST_SCREENING_FRAMES} frames per engine."
                )

        video = self._video_probe(path)
        full_sampling_plan = build_video_sampling_plan(
            source_fps=video["source_fps"],
            target_fps=target_fps,
            frame_count=video["frame_count"],
        )
        sampling_plan = (
            select_distributed_sampling_subset(
                full_sampling_plan,
                maximum_frames=screening_max_frames,
            )
            if fast_screening
            else full_sampling_plan
        )
        engine_results: list[dict[str, Any]] = []
        cancel_event = cancellation_event or Event()
        cancellation_observed = False

        def build_result() -> dict[str, Any]:
            completed_runner_count = len(engine_results)

            return {
                "schema_version": SCHEMA_VERSION,
                "run_status": (
                    "cancelled"
                    if cancellation_observed
                    else "completed"
                    if completed_runner_count == len(self._runners)
                    else "partial"
                ),
                "expected_engine_count": len(self._runners),
                "completed_engine_count": completed_runner_count,
                "analysis_mode": "single_camera_2d_pose_benchmark",
                "benchmark_mode": (
                    "fast_screening"
                    if fast_screening
                    else "full_benchmark"
                ),
                "scientific_status": "experimental_non_production",
                "video": video,
                "sampling": {
                    "strategy": sampling_plan.strategy,
                    "selection": (
                        "distributed_full_span_subset"
                        if fast_screening
                        else "full_timestamp_plan"
                    ),
                    "requested_target_fps": target_fps,
                    "effective_target_fps": (
                        sampling_plan.effective_target_fps
                    ),
                    "planned_frame_count": (
                        sampling_plan.planned_frame_count
                    ),
                    "full_plan_frame_count": (
                        full_sampling_plan.planned_frame_count
                    ),
                    "frame_indices": list(sampling_plan.frame_indices),
                    "timestamps_ms": list(sampling_plan.timestamps_ms),
                    "engineering_setting_only": True,
                    "scientific_temporal_resolution_note": (
                        "Benchmark sampling rate is an engineering/evaluation "
                        "setting and is not a fixed temporal resolution for "
                        "future scientific biomechanics analysis."
                    ),
                },
                "engine_timeout_seconds": engine_timeout_seconds,
                "screening": {
                    "enabled": fast_screening,
                    "maximum_frames_per_engine": (
                        screening_max_frames if fast_screening else None
                    ),
                    "timestamp_selection": (
                        "deterministic_content_neutral_distribution_across_"
                        "the_full_video"
                        if fast_screening
                        else None
                    ),
                    "automatic_pass_decision": False,
                    "gate": (
                        "manual_scientific_and_engineering_review_required_"
                        "before_long_benchmark"
                        if fast_screening
                        else None
                    ),
                },
                "engines": list(engine_results),
                "limitations": [
                    (
                        "Coverage is model-estimated and is not athlete "
                        "identity accuracy."
                    ),
                    (
                        "Pose order is frame-local; Tori and Uke are not "
                        "identified."
                    ),
                    (
                        "No result is measured or reconstructed 3D "
                        "biomechanics."
                    ),
                    (
                        "No force, torque, technique phase, or coaching "
                        "claim is produced."
                    ),
                    (
                        "FAST SCREENING, when enabled, compares only pose "
                        "coverage, available confidence, failures, and runtime."
                    ),
                ],
            }

        for runner in self._runners:
            if cancel_event.is_set():
                cancellation_observed = True
                break

            control = BenchmarkRunControl(
                engine_id=runner.capability.engine_id,
                total_samples=sampling_plan.planned_frame_count,
                timeout_seconds=engine_timeout_seconds,
                progress_callback=engine_progress_callback,
                cancellation_event=cancel_event,
                progress_interval_frames=progress_interval_frames,
            )

            try:
                result = runner.run(
                    path,
                    sampling_plan,
                    keypoint_threshold,
                    control,
                )
            except Exception as error:  # Each engine must fail independently.
                result = _failed_engine_result(
                    capability=runner.capability,
                    error=error,
                    planned_frame_count=sampling_plan.planned_frame_count,
                    observations=control.observations,
                    elapsed_seconds=control.elapsed_seconds,
                )

                if isinstance(error, BenchmarkCancelled):
                    cancellation_observed = True

            if fast_screening:
                result["screening_disposition"] = (
                    "eligible_for_manual_review"
                    if result["status"] == "completed"
                    else "not_eligible"
                )

            engine_results.append(result)

            if progress_callback is not None:
                progress_callback(build_result())

            if cancellation_observed:
                break

        return build_result()


def build_benchmark_runners(
    engine_ids: Sequence[str] | None = None,
) -> tuple[BenchmarkRunner, ...]:
    factories = {
        "mediapipe-heavy": MediaPipeHeavyRunner,
        "rtmpose-m": RTMPoseMRunner,
        "rtmo-m": RTMORunner,
    }
    selected_ids = tuple(engine_ids) if engine_ids else tuple(factories)
    return tuple(factories[engine_id]() for engine_id in selected_ids)


def _write_text_artifact(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary_path = path.with_suffix(path.suffix + ".tmp")
    temporary_path.write_text(content, encoding="utf-8")
    temporary_path.replace(path)


def render_human_report(result: dict[str, Any]) -> str:
    sampling = result["sampling"]
    lines = [
        "Judo Mind single-camera 2D pose benchmark",
        f"Schema: {result['schema_version']}",
        f"Mode: {result['benchmark_mode']}",
        (
            "Sampling: "
            f"{sampling['strategy']} at "
            f"{sampling['requested_target_fps']:.3f} requested FPS "
            f"({sampling['planned_frame_count']} frames)"
        ),
        "",
        (
            "Engine | Device | Status | Frames | >=1 coverage | >=2 coverage | "
            "Seconds | Processing FPS | Confidence"
        ),
        "--- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---",
    ]

    for engine in result["engines"]:
        metrics = engine["metrics"]
        one_coverage = metrics.get("at_least_one_pose_coverage")
        two_coverage = metrics.get("at_least_two_pose_coverage")
        processing_seconds = metrics.get("processing_seconds")
        processing_fps = metrics.get("processing_fps")

        lines.append(
            " | ".join(
                (
                    engine["engine_id"],
                    engine["runtime_device"],
                    engine["status"],
                    str(metrics.get("processed_frames", 0)),
                    _format_percent(one_coverage),
                    _format_percent(two_coverage),
                    _format_number(processing_seconds),
                    _format_number(processing_fps),
                    (
                        "available"
                        if metrics.get("keypoint_confidence_available")
                        else "unavailable"
                    ),
                )
            )
        )

    lines.extend(("", "Scientific limitations:"))
    lines.extend(f"- {item}" for item in result["limitations"])

    return "\n".join(lines)


def _format_percent(value: float | None) -> str:
    return f"{value * 100.0:.2f}%" if value is not None else "n/a"


def _format_number(value: float | None) -> str:
    return f"{value:.3f}" if value is not None else "n/a"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Compare experimental single-camera 2D pose engines."
    )
    parser.add_argument("video", help="Explicit single-camera test video path")
    parser.add_argument("--target-fps", type=float, default=10.0)
    parser.add_argument(
        "--keypoint-threshold",
        type=float,
        default=DEFAULT_KEYPOINT_THRESHOLD,
    )
    parser.add_argument("--json-output", type=Path)
    parser.add_argument("--report-output", type=Path)
    parser.add_argument(
        "--engine-timeout-seconds",
        type=float,
        default=DEFAULT_ENGINE_TIMEOUT_SECONDS,
        help=(
            "Cooperative per-engine timeout checked between model calls "
            f"(default: {DEFAULT_ENGINE_TIMEOUT_SECONDS:.0f}s)."
        ),
    )
    parser.add_argument(
        "--progress-interval-frames",
        type=int,
        default=DEFAULT_PROGRESS_INTERVAL_FRAMES,
    )
    parser.add_argument(
        "--fast-screening",
        action="store_true",
        help=(
            "Use a deterministic full-span subset shared by all engines; "
            "does not make athlete, technique, or biomechanics claims."
        ),
    )
    parser.add_argument(
        "--screening-max-frames",
        type=int,
        default=MAX_FAST_SCREENING_FRAMES,
        help=f"FAST SCREENING cap (maximum {MAX_FAST_SCREENING_FRAMES}).",
    )
    parser.add_argument(
        "--engine",
        action="append",
        choices=("mediapipe-heavy", "rtmpose-m", "rtmo-m"),
        help="Run only the selected engine; may be repeated.",
    )
    args = parser.parse_args()

    if not args.fast_screening and not args.engine:
        parser.error(
            "A longer benchmark requires explicit --engine selections after "
            "manual review of FAST SCREENING results."
        )

    cancel_event = Event()

    def request_cancellation(signum: int, frame: Any) -> None:
        del signum, frame
        cancel_event.set()
        print(
            "Cancellation requested; the current model call may finish, "
            "then the benchmark will checkpoint and stop.",
            flush=True,
        )

    signal.signal(signal.SIGINT, request_cancellation)

    def print_engine_progress(progress: dict[str, Any]) -> None:
        eta = (
            f"{progress['eta_seconds']:.1f}s"
            if progress["eta_reliable"]
            else "pending"
        )
        print(
            f"[{progress['engine_id']}] {progress['status']}: "
            f"{progress['processed_samples']}/"
            f"{progress['total_samples']} samples; "
            f"elapsed={progress['elapsed_seconds']:.1f}s; "
            f"effective_fps={progress['effective_processing_fps']:.3f}; "
            f"ETA={eta}",
            flush=True,
        )

    def checkpoint(partial_result: dict[str, Any]) -> None:
        if args.json_output:
            _write_text_artifact(
                args.json_output,
                json.dumps(
                    partial_result,
                    indent=2,
                    ensure_ascii=False,
                )
                + "\n",
            )

        if args.report_output:
            _write_text_artifact(
                args.report_output,
                render_human_report(partial_result) + "\n",
            )

        latest = partial_result["engines"][-1]
        print(
            f"Checkpointed {latest['engine_id']}: {latest['status']}",
            flush=True,
        )

    result = PoseEngineBenchmark(
        runners=build_benchmark_runners(args.engine),
    ).run(
        args.video,
        target_fps=args.target_fps,
        keypoint_threshold=args.keypoint_threshold,
        progress_callback=checkpoint,
        engine_progress_callback=print_engine_progress,
        engine_timeout_seconds=args.engine_timeout_seconds,
        progress_interval_frames=args.progress_interval_frames,
        cancellation_event=cancel_event,
        fast_screening=args.fast_screening,
        screening_max_frames=args.screening_max_frames,
    )
    human_report = render_human_report(result)
    serialized = json.dumps(result, indent=2, ensure_ascii=False)

    print(human_report)

    if not args.json_output:
        print()
        print(serialized)
    else:
        print(f"JSON artifact: {args.json_output}")

    if args.json_output:
        _write_text_artifact(args.json_output, serialized + "\n")

    if args.report_output:
        _write_text_artifact(args.report_output, human_report + "\n")


if __name__ == "__main__":
    main()
