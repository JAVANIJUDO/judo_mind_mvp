from __future__ import annotations

import argparse
from hashlib import sha256
import json
import math
from pathlib import Path
from typing import Any

from ai_engine.annotations.single_attempt_annotation import (
    DetectionGroundTruthEvaluation,
    PoseDetectionCount,
    SingleAttemptAnnotationDraft,
    evaluate_detection_against_human_labels,
    finalize_annotation_draft,
)
from ai_engine.annotations.output_safety import write_new_text_file
from ai_engine.annotations.validate_annotation_draft import (
    inspect_annotation_draft_path,
)


def _file_sha256(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def _project_path(path: Path) -> Path:
    project_root = Path(__file__).resolve().parents[2]
    return path.resolve() if path.is_absolute() else (project_root / path).resolve()


def validate_benchmark_artifact_alignment(
    draft: SingleAttemptAnnotationDraft,
    artifact: dict[str, Any],
    *,
    benchmark_artifact_path: Path,
) -> str:
    """Verify artifact, source video and annotation subset provenance."""

    project_root = Path(__file__).resolve().parents[2]
    expected_artifact_path = _project_path(
        Path(draft.source_screening_artifact)
    )
    actual_artifact_path = _project_path(benchmark_artifact_path)
    if not expected_artifact_path.is_relative_to(project_root):
        raise ValueError("Draft benchmark artifact path leaves the project root.")
    if actual_artifact_path != expected_artifact_path:
        raise ValueError("Benchmark artifact path does not match the draft source.")

    artifact_sha256 = _file_sha256(actual_artifact_path)
    if artifact_sha256 != draft.source_screening_artifact_sha256:
        raise ValueError("Benchmark artifact SHA-256 does not match the draft.")

    if artifact.get("run_status") != "completed":
        raise ValueError("Benchmark artifact must be a completed run.")
    if artifact.get("scientific_status") != (
        "experimental_detection_screening_only"
    ):
        raise ValueError("Benchmark artifact has an incompatible scientific status.")

    video = artifact.get("video")
    sampling = artifact.get("sampling")
    if not isinstance(video, dict) or not isinstance(sampling, dict):
        raise ValueError("Benchmark video or sampling metadata is missing.")

    raw_video_path = video.get("path")
    if not isinstance(raw_video_path, str) or not raw_video_path:
        raise ValueError("Benchmark source video path is missing.")
    source_video_path = _project_path(Path(raw_video_path))
    benchmark_inputs = (
        project_root / "ai_engine" / "runtime" / "benchmark_inputs"
    ).resolve()
    if not source_video_path.is_relative_to(benchmark_inputs):
        raise ValueError("Benchmark source video must remain in runtime inputs.")
    if not source_video_path.is_file():
        raise ValueError("Benchmark source video is unavailable.")
    if _file_sha256(source_video_path) != draft.video.sha256:
        raise ValueError("Benchmark source video SHA-256 does not match the draft.")

    expected_video_metadata = {
        "width": draft.video.width,
        "height": draft.video.height,
        "frame_count": draft.video.frame_count,
    }
    for field, expected in expected_video_metadata.items():
        if video.get(field) != expected:
            raise ValueError(f"Benchmark video {field} does not match the draft.")

    for field, expected in (
        ("source_fps", draft.video.source_fps),
        ("duration_seconds", draft.video.duration_seconds),
    ):
        actual = video.get(field)
        if (
            isinstance(actual, bool)
            or not isinstance(actual, (int, float))
            or not math.isfinite(float(actual))
            or not math.isclose(float(actual), expected, rel_tol=1e-9)
        ):
            raise ValueError(f"Benchmark video {field} does not match the draft.")

    run_id = artifact.get("run_id")
    if (
        not isinstance(run_id, str)
        or not draft.video.video_id.startswith(f"{run_id}:")
        or Path(raw_video_path).name != draft.video.filename
    ):
        raise ValueError("Benchmark video identity does not match the draft.")

    expected_frames = [frame.frame.frame_index for frame in draft.frames]
    expected_timestamps = [frame.frame.timestamp_ms for frame in draft.frames]
    if sampling.get("frame_indices") != expected_frames:
        raise ValueError("Benchmark frame subset does not match the draft.")
    if sampling.get("timestamps_ms") != expected_timestamps:
        raise ValueError("Benchmark timestamp subset does not match the draft.")
    if sampling.get("screening_count") != draft.selection.sample_count:
        raise ValueError("Benchmark sample count does not match the draft.")
    if sampling.get("screening_selection") != draft.selection.method:
        raise ValueError("Benchmark selection method does not match the draft.")
    if sampling.get("same_timestamps_for_all_engines") is not True:
        raise ValueError("Benchmark timestamps are not shared across engines.")

    return artifact_sha256


def predictions_from_benchmark_artifact(
    artifact: dict[str, Any],
    *,
    engine_id: str,
) -> list[PoseDetectionCount]:
    """Read model-estimated detection counts without pose inference."""

    engines = artifact.get("engines")
    if not isinstance(engines, list):
        raise ValueError("Benchmark artifact does not contain an engine list.")

    matching = [
        engine
        for engine in engines
        if isinstance(engine, dict) and engine.get("engine_id") == engine_id
    ]
    if len(matching) != 1:
        raise ValueError("Benchmark artifact must contain the engine exactly once.")

    observations = matching[0].get("observations")
    if not isinstance(observations, list):
        raise ValueError("Selected engine has no per-timestamp observations.")

    predictions: list[PoseDetectionCount] = []
    for observation in observations:
        if not isinstance(observation, dict):
            raise ValueError("Benchmark observation is not an object.")

        try:
            predictions.append(
                PoseDetectionCount(
                    frame={
                        "frame_index": observation["frame_index"],
                        "timestamp_ms": observation["timestamp_ms"],
                    },
                    detected_person_count=observation["pose_count"],
                    engine_id=engine_id,
                )
            )
        except (KeyError, TypeError, ValueError) as error:
            raise ValueError("Benchmark observation is incomplete.") from error

    return predictions


def evaluate_completed_draft_and_artifact(
    *,
    annotation_draft_path: Path,
    benchmark_artifact_path: Path,
    engine_id: str,
) -> DetectionGroundTruthEvaluation:
    readiness = inspect_annotation_draft_path(annotation_draft_path)
    if readiness.review_assets_ready is not True:
        raise ValueError(
            "Review assets must be present, readable and dimensionally "
            "aligned before artifact evaluation."
        )

    draft = SingleAttemptAnnotationDraft.model_validate_json(
        annotation_draft_path.read_text(encoding="utf-8")
    )
    annotations = finalize_annotation_draft(draft)
    artifact = json.loads(benchmark_artifact_path.read_text(encoding="utf-8"))
    if not isinstance(artifact, dict):
        raise ValueError("Benchmark artifact must be a JSON object.")

    artifact_sha256 = validate_benchmark_artifact_alignment(
        draft,
        artifact,
        benchmark_artifact_path=benchmark_artifact_path,
    )

    predictions = predictions_from_benchmark_artifact(
        artifact,
        engine_id=engine_id,
    )
    return evaluate_detection_against_human_labels(
        annotations,
        predictions,
        engine_id=engine_id,
        benchmark_artifact_sha256=artifact_sha256,
        artifact_alignment_verified=True,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("annotation_draft", type=Path)
    parser.add_argument("benchmark_artifact", type=Path)
    parser.add_argument("engine_id")
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()

    result = evaluate_completed_draft_and_artifact(
        annotation_draft_path=arguments.annotation_draft,
        benchmark_artifact_path=arguments.benchmark_artifact,
        engine_id=arguments.engine_id,
    )
    serialized = result.model_dump_json(indent=2)

    if arguments.output is not None:
        write_new_text_file(arguments.output, serialized)

    print(serialized)


if __name__ == "__main__":
    main()
