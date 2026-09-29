from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest import TestCase

from ai_engine.annotations.evaluate_detection_artifact import (
    evaluate_completed_draft_and_artifact,
    predictions_from_benchmark_artifact,
    validate_benchmark_artifact_alignment,
)
from ai_engine.annotations.single_attempt_annotation import (
    SingleAttemptAnnotationDraft,
)


PROJECT_ROOT = Path(__file__).resolve().parents[2]


class DetectionArtifactEvaluatorTest(TestCase):
    def test_evaluation_cannot_bypass_review_asset_readiness(self) -> None:
        with TemporaryDirectory() as directory:
            draft_path = Path(directory) / "draft.json"
            draft_path.write_text(
                json.dumps(
                    {
                        "schema_version": "1.1.0",
                        "source_screening_artifact": "missing.json",
                        "source_screening_artifact_sha256": "b" * 64,
                        "video": {
                            "video_id": "fixture:aaaaaaaaaaaa",
                            "filename": "fixture.mp4",
                            "sha256": "a" * 64,
                            "width": 640,
                            "height": 360,
                            "source_fps": 25.0,
                            "frame_count": 1,
                            "duration_seconds": 0.04,
                        },
                        "selection": {
                            "method": "distributed",
                            "sample_count": 1,
                            "same_timestamps_as_fast_screening": True,
                            "pose_inference_run": False,
                        },
                        "human_review": {},
                        "frames": [
                            {
                                "sample_position": 0,
                                "frame": {
                                    "frame_index": 0,
                                    "timestamp_ms": 0,
                                },
                                "image": (
                                    "frames/sample_000_f000000_"
                                    "t000000ms.jpg"
                                ),
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )

            with self.assertRaisesRegex(ValueError, "Review assets must"):
                evaluate_completed_draft_and_artifact(
                    annotation_draft_path=draft_path,
                    benchmark_artifact_path=Path(directory) / "missing.json",
                    engine_id="engine-a",
                )

    def test_reads_role_neutral_counts_without_promoting_coverage(self) -> None:
        artifact = {
            "engines": [
                {
                    "engine_id": "engine-a",
                    "observations": [
                        {"frame_index": 0, "timestamp_ms": 0, "pose_count": 0},
                        {
                            "frame_index": 3,
                            "timestamp_ms": 120,
                            "pose_count": 2,
                        },
                    ],
                }
            ]
        }

        predictions = predictions_from_benchmark_artifact(
            artifact,
            engine_id="engine-a",
        )

        self.assertEqual(len(predictions), 2)
        self.assertEqual(predictions[1].detected_person_count, 2)
        self.assertEqual(predictions[1].observation_source, "model-estimated")

    def test_rejects_missing_duplicate_or_incomplete_engine_artifacts(self) -> None:
        with self.assertRaises(ValueError):
            predictions_from_benchmark_artifact(
                {"engines": []},
                engine_id="engine-a",
            )

        duplicate = {
            "engines": [
                {"engine_id": "engine-a", "observations": []},
                {"engine_id": "engine-a", "observations": []},
            ]
        }
        with self.assertRaises(ValueError):
            predictions_from_benchmark_artifact(
                duplicate,
                engine_id="engine-a",
            )

        incomplete = {
            "engines": [
                {
                    "engine_id": "engine-a",
                    "observations": [{"frame_index": 0, "timestamp_ms": 0}],
                }
            ]
        }
        with self.assertRaises(ValueError):
            predictions_from_benchmark_artifact(
                incomplete,
                engine_id="engine-a",
            )

    def test_verifies_artifact_video_hash_metadata_and_exact_subset(self) -> None:
        inputs_root = PROJECT_ROOT / "ai_engine" / "runtime" / "benchmark_inputs"
        outputs_root = PROJECT_ROOT / "ai_engine" / "runtime" / "benchmark_outputs"
        inputs_root.mkdir(parents=True, exist_ok=True)
        outputs_root.mkdir(parents=True, exist_ok=True)

        with (
            TemporaryDirectory(dir=inputs_root) as input_directory,
            TemporaryDirectory(dir=outputs_root) as output_directory,
        ):
            video_path = Path(input_directory) / "fixture.mp4"
            video_path.write_bytes(b"role-neutral-video-fixture")
            video_sha256 = sha256(video_path.read_bytes()).hexdigest()
            artifact_path = Path(output_directory) / "screening.json"
            artifact = {
                "run_id": "fixture-run",
                "run_status": "completed",
                "scientific_status": (
                    "experimental_detection_screening_only"
                ),
                "video": {
                    "path": str(video_path.relative_to(PROJECT_ROOT)),
                    "width": 640,
                    "height": 360,
                    "source_fps": 25.0,
                    "frame_count": 2,
                    "duration_seconds": 0.08,
                },
                "sampling": {
                    "screening_selection": "distributed",
                    "screening_count": 2,
                    "same_timestamps_for_all_engines": True,
                    "frame_indices": [0, 1],
                    "timestamps_ms": [0, 40],
                },
                "engines": [],
            }
            artifact_path.write_text(
                json.dumps(artifact),
                encoding="utf-8",
            )
            artifact_sha256 = sha256(artifact_path.read_bytes()).hexdigest()
            draft = SingleAttemptAnnotationDraft.model_validate(
                {
                    "schema_version": "1.1.0",
                    "source_screening_artifact": str(
                        artifact_path.relative_to(PROJECT_ROOT)
                    ),
                    "source_screening_artifact_sha256": artifact_sha256,
                    "video": {
                        "video_id": f"fixture-run:{video_sha256[:12]}",
                        "filename": video_path.name,
                        "sha256": video_sha256,
                        "width": 640,
                        "height": 360,
                        "source_fps": 25.0,
                        "frame_count": 2,
                        "duration_seconds": 0.08,
                    },
                    "selection": {
                        "method": "distributed",
                        "sample_count": 2,
                        "same_timestamps_as_fast_screening": True,
                        "pose_inference_run": False,
                    },
                    "human_review": {},
                    "frames": [
                        {
                            "sample_position": 0,
                            "frame": {"frame_index": 0, "timestamp_ms": 0},
                            "image": "frames/sample_000_f000000_t000000ms.jpg",
                        },
                        {
                            "sample_position": 1,
                            "frame": {"frame_index": 1, "timestamp_ms": 40},
                            "image": "frames/sample_001_f000001_t000040ms.jpg",
                        },
                    ],
                }
            )

            self.assertEqual(
                validate_benchmark_artifact_alignment(
                    draft,
                    artifact,
                    benchmark_artifact_path=artifact_path,
                ),
                artifact_sha256,
            )

            artifact["sampling"]["timestamps_ms"] = [0, 41]
            with self.assertRaisesRegex(ValueError, "timestamp subset"):
                validate_benchmark_artifact_alignment(
                    draft,
                    artifact,
                    benchmark_artifact_path=artifact_path,
                )
