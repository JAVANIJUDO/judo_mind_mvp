from __future__ import annotations

import csv
import json
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest import TestCase

import cv2
import numpy as np

from ai_engine.annotations.prepare_review_subset import prepare_review_subset
from ai_engine.annotations.output_safety import write_new_text_file
from ai_engine.annotations.single_attempt_annotation import (
    AnnotationDraftReadinessReport,
)
from ai_engine.annotations.annotation_csv import (
    export_annotation_csv,
    import_annotation_csv,
)
from ai_engine.annotations.validate_annotation_draft import (
    inspect_annotation_draft_path,
)


def _unfilled_draft_payload() -> dict[str, object]:
    return {
        "schema_version": "1.1.0",
        "annotation_type": "single_attempt_uchi_mata_ground_truth_draft",
        "status": "awaiting_human_annotation",
        "source_screening_artifact": "runtime/screening.json",
        "source_screening_artifact_sha256": "b" * 64,
        "video": {
            "video_id": "fixture-run:aaaaaaaaaaaa",
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
                "frame": {"frame_index": 0, "timestamp_ms": 0},
                "image": "frames/sample_000_f000000_t000000ms.jpg",
            }
        ],
    }


class AnnotationToolingTest(TestCase):
    def test_path_inspector_reports_missing_labels_without_defaulting(self) -> None:
        with TemporaryDirectory() as directory:
            draft_path = Path(directory) / "draft.json"
            draft_path.write_text(
                json.dumps(_unfilled_draft_payload()),
                encoding="utf-8",
            )

            report = inspect_annotation_draft_path(draft_path)

        self.assertFalse(report.can_finalize)
        self.assertEqual(report.incomplete_sample_positions, [0])
        self.assertEqual(report.missing_frame_field_counts["crossing"], 1)
        self.assertTrue(report.review_asset_check_performed)
        self.assertEqual(report.missing_review_asset_sample_positions, [0])
        self.assertFalse(report.review_assets_ready)
        self.assertFalse(report.labels_inferred_or_defaulted)

        tampered = report.model_dump(mode="json")
        tampered["review_assets_ready"] = True
        with self.assertRaisesRegex(ValueError, "asset readiness state"):
            AnnotationDraftReadinessReport.model_validate(tampered)

    def test_review_preparation_refuses_to_overwrite_existing_draft(self) -> None:
        with TemporaryDirectory() as directory:
            output_directory = Path(directory)
            (output_directory / "annotation_template.json").write_text(
                "existing human work",
                encoding="utf-8",
            )

            with self.assertRaisesRegex(FileExistsError, "refusing to overwrite"):
                prepare_review_subset(
                    screening_artifact_path=Path("missing.json"),
                    output_directory=output_directory,
                )

    def test_path_inspector_rejects_corrupt_or_wrong_dimension_assets(self) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            frames = root / "frames"
            frames.mkdir()
            draft_path = root / "draft.json"
            draft_path.write_text(
                json.dumps(_unfilled_draft_payload()),
                encoding="utf-8",
            )
            image_path = frames / "sample_000_f000000_t000000ms.jpg"

            image_path.write_bytes(b"not a jpeg")
            corrupt = inspect_annotation_draft_path(draft_path)
            self.assertEqual(
                corrupt.unreadable_review_asset_sample_positions,
                [0],
            )
            self.assertFalse(corrupt.review_assets_ready)

            self.assertTrue(
                cv2.imwrite(
                    str(image_path),
                    np.zeros((10, 10, 3), dtype=np.uint8),
                )
            )
            mismatched = inspect_annotation_draft_path(draft_path)
            self.assertEqual(
                mismatched.dimension_mismatch_review_asset_sample_positions,
                [0],
            )
            self.assertFalse(mismatched.review_assets_ready)

            self.assertTrue(
                cv2.imwrite(
                    str(image_path),
                    np.zeros((360, 640, 3), dtype=np.uint8),
                )
            )
            valid = inspect_annotation_draft_path(draft_path)
            self.assertTrue(valid.review_assets_ready)
            self.assertEqual(valid.readable_review_asset_count, 1)

    def test_csv_round_trip_preserves_evidence_and_does_not_default_labels(
        self,
    ) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            draft_path = root / "draft.json"
            csv_path = root / "labels.csv"
            merged_path = root / "merged.json"
            original = _unfilled_draft_payload()
            draft_path.write_text(json.dumps(original), encoding="utf-8")

            export_annotation_csv(
                annotation_draft_path=draft_path,
                output_csv_path=csv_path,
            )
            with csv_path.open(
                "r",
                encoding="utf-8-sig",
                newline="",
            ) as source:
                reader = csv.DictReader(source)
                fieldnames = reader.fieldnames
                rows = list(reader)

            rows[0].update(
                {
                    "visible_judoka_count": "2",
                    "visible_subject_reference_ids": "subject-1;subject-2",
                    "selected_tori_subject_reference_id": "subject-1",
                    "occlusion": "false",
                    "crossing": "true",
                    "reviewer_notes": "human note",
                }
            )
            with csv_path.open(
                "w",
                encoding="utf-8-sig",
                newline="",
            ) as target:
                writer = csv.DictWriter(target, fieldnames=fieldnames)
                writer.writeheader()
                writer.writerows(rows)

            readiness = import_annotation_csv(
                annotation_draft_path=draft_path,
                input_csv_path=csv_path,
                output_draft_path=merged_path,
            )
            merged = json.loads(merged_path.read_text(encoding="utf-8"))
            unchanged = json.loads(draft_path.read_text(encoding="utf-8"))

        self.assertEqual(unchanged, original)
        self.assertEqual(merged["frames"][0]["frame"]["frame_index"], 0)
        self.assertEqual(
            merged["frames"][0]["visible_subject_reference_ids"],
            ["subject-1", "subject-2"],
        )
        self.assertFalse(merged["frames"][0]["occlusion"])
        self.assertTrue(merged["frames"][0]["crossing"])
        self.assertEqual(readiness.complete_frame_count, 1)
        self.assertFalse(readiness.can_finalize)
        self.assertFalse(readiness.labels_inferred_or_defaulted)

    def test_csv_import_rejects_changed_evidence_columns(self) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            draft_path = root / "draft.json"
            csv_path = root / "labels.csv"
            draft_path.write_text(
                json.dumps(_unfilled_draft_payload()),
                encoding="utf-8",
            )
            export_annotation_csv(
                annotation_draft_path=draft_path,
                output_csv_path=csv_path,
            )
            text = csv_path.read_text(encoding="utf-8-sig")
            csv_path.write_text(
                text.replace("sample_000_f000000", "sample_000_f000001"),
                encoding="utf-8-sig",
            )

            with self.assertRaisesRegex(ValueError, "immutable field image"):
                import_annotation_csv(
                    annotation_draft_path=draft_path,
                    input_csv_path=csv_path,
                    output_draft_path=root / "merged.json",
                )

    def test_csv_tools_refuse_to_overwrite_outputs(self) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            draft_path = root / "draft.json"
            csv_path = root / "labels.csv"
            draft_path.write_text(
                json.dumps(_unfilled_draft_payload()),
                encoding="utf-8",
            )
            csv_path.write_text("existing", encoding="utf-8")

            with self.assertRaisesRegex(FileExistsError, "Refusing to overwrite"):
                export_annotation_csv(
                    annotation_draft_path=draft_path,
                    output_csv_path=csv_path,
                )

    def test_generated_text_outputs_preserve_existing_files(self) -> None:
        with TemporaryDirectory() as directory:
            output_path = Path(directory) / "existing.json"
            output_path.write_text("human work", encoding="utf-8")

            with self.assertRaisesRegex(FileExistsError, "Refusing to overwrite"):
                write_new_text_file(output_path, "replacement")

            self.assertEqual(
                output_path.read_text(encoding="utf-8"),
                "human work",
            )
