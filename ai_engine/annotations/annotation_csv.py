from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any

from ai_engine.annotations.single_attempt_annotation import (
    AnnotationDraftReadinessReport,
    SingleAttemptAnnotationDraft,
    inspect_annotation_draft,
)
from ai_engine.annotations.output_safety import write_new_text_file


ANNOTATION_CSV_COLUMNS = (
    "sample_position",
    "frame_index",
    "timestamp_ms",
    "image",
    "visible_judoka_count",
    "visible_subject_reference_ids",
    "selected_tori_subject_reference_id",
    "occlusion",
    "crossing",
    "reviewer_notes",
)


def _refuse_overwrite(path: Path) -> None:
    if path.exists():
        raise FileExistsError(
            f"Refusing to overwrite existing annotation work: {path}"
        )


def export_annotation_csv(
    *,
    annotation_draft_path: Path,
    output_csv_path: Path,
) -> Path:
    """Export the frame-label portion without changing the draft."""

    _refuse_overwrite(output_csv_path)
    draft = SingleAttemptAnnotationDraft.model_validate_json(
        annotation_draft_path.read_text(encoding="utf-8")
    )

    output_csv_path.parent.mkdir(parents=True, exist_ok=True)
    with output_csv_path.open("x", encoding="utf-8-sig", newline="") as target:
        writer = csv.DictWriter(target, fieldnames=ANNOTATION_CSV_COLUMNS)
        writer.writeheader()
        for item in draft.frames:
            writer.writerow(
                {
                    "sample_position": item.sample_position,
                    "frame_index": item.frame.frame_index,
                    "timestamp_ms": item.frame.timestamp_ms,
                    "image": item.image,
                    "visible_judoka_count": (
                        ""
                        if item.visible_judoka_count is None
                        else item.visible_judoka_count
                    ),
                    "visible_subject_reference_ids": (
                        ""
                        if item.visible_subject_reference_ids is None
                        else (
                            "[]"
                            if not item.visible_subject_reference_ids
                            else ";".join(item.visible_subject_reference_ids)
                        )
                    ),
                    "selected_tori_subject_reference_id": (
                        item.selected_tori_subject_reference_id or ""
                    ),
                    "occlusion": (
                        "" if item.occlusion is None else str(item.occlusion).lower()
                    ),
                    "crossing": (
                        "" if item.crossing is None else str(item.crossing).lower()
                    ),
                    "reviewer_notes": item.reviewer_notes or "",
                }
            )

    return output_csv_path


def _parse_optional_count(value: str, *, row_number: int) -> int | None:
    normalized = value.strip()
    if not normalized:
        return None
    try:
        parsed = int(normalized)
    except ValueError as error:
        raise ValueError(
            f"CSV row {row_number} has a non-integer visible count."
        ) from error
    if str(parsed) != normalized or parsed < 0:
        raise ValueError(
            f"CSV row {row_number} has an invalid visible count."
        )
    return parsed


def _parse_optional_bool(value: str, *, field: str, row_number: int) -> bool | None:
    normalized = value.strip().lower()
    if not normalized:
        return None
    if normalized == "true":
        return True
    if normalized == "false":
        return False
    raise ValueError(
        f"CSV row {row_number} field {field} must be blank, true or false."
    )


def _parse_optional_subjects(
    value: str,
    *,
    row_number: int,
) -> list[str] | None:
    normalized = value.strip()
    if not normalized:
        return None
    if normalized == "[]":
        return []
    subjects = [part.strip() for part in normalized.split(";")]
    if any(not subject for subject in subjects):
        raise ValueError(
            f"CSV row {row_number} has an empty subject reference."
        )
    return subjects


def _validate_immutable_cell(
    *,
    row: dict[str, str],
    field: str,
    expected: str,
    row_number: int,
) -> None:
    if row[field].strip() != expected:
        raise ValueError(
            f"CSV row {row_number} changed immutable field {field}."
        )


def import_annotation_csv(
    *,
    annotation_draft_path: Path,
    input_csv_path: Path,
    output_draft_path: Path,
) -> AnnotationDraftReadinessReport:
    """Merge human frame labels into a new draft; never overwrite the source."""

    _refuse_overwrite(output_draft_path)
    draft = SingleAttemptAnnotationDraft.model_validate_json(
        annotation_draft_path.read_text(encoding="utf-8")
    )

    with input_csv_path.open("r", encoding="utf-8-sig", newline="") as source:
        reader = csv.DictReader(source)
        if tuple(reader.fieldnames or ()) != ANNOTATION_CSV_COLUMNS:
            raise ValueError("Annotation CSV columns do not match the contract.")
        rows = list(reader)

    if len(rows) != len(draft.frames):
        raise ValueError("Annotation CSV row count does not match the draft.")

    completed_rows: list[dict[str, Any]] = []
    for row_number, (row, frame) in enumerate(
        zip(rows, draft.frames, strict=True),
        start=2,
    ):
        for field, expected in (
            ("sample_position", str(frame.sample_position)),
            ("frame_index", str(frame.frame.frame_index)),
            ("timestamp_ms", str(frame.frame.timestamp_ms)),
            ("image", frame.image),
        ):
            _validate_immutable_cell(
                row=row,
                field=field,
                expected=expected,
                row_number=row_number,
            )

        selected_tori = row["selected_tori_subject_reference_id"].strip()
        reviewer_notes = row["reviewer_notes"].strip()
        completed_rows.append(
            {
                "sample_position": frame.sample_position,
                "frame": frame.frame.model_dump(mode="json"),
                "image": frame.image,
                "visible_judoka_count": _parse_optional_count(
                    row["visible_judoka_count"],
                    row_number=row_number,
                ),
                "visible_subject_reference_ids": _parse_optional_subjects(
                    row["visible_subject_reference_ids"],
                    row_number=row_number,
                ),
                "selected_tori_subject_reference_id": selected_tori or None,
                "occlusion": _parse_optional_bool(
                    row["occlusion"],
                    field="occlusion",
                    row_number=row_number,
                ),
                "crossing": _parse_optional_bool(
                    row["crossing"],
                    field="crossing",
                    row_number=row_number,
                ),
                "reviewer_notes": reviewer_notes or None,
            }
        )

    payload = draft.model_dump(mode="json")
    payload["frames"] = completed_rows
    merged = SingleAttemptAnnotationDraft.model_validate(payload)
    readiness = inspect_annotation_draft(merged)

    write_new_text_file(
        output_draft_path,
        merged.model_dump_json(indent=2),
    )
    return readiness


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    export_parser = subparsers.add_parser("export")
    export_parser.add_argument("annotation_draft", type=Path)
    export_parser.add_argument("output_csv", type=Path)

    import_parser = subparsers.add_parser("import")
    import_parser.add_argument("annotation_draft", type=Path)
    import_parser.add_argument("input_csv", type=Path)
    import_parser.add_argument("output_draft", type=Path)

    arguments = parser.parse_args()
    if arguments.command == "export":
        path = export_annotation_csv(
            annotation_draft_path=arguments.annotation_draft,
            output_csv_path=arguments.output_csv,
        )
        print(json.dumps({"status": "exported", "path": str(path)}))
        return

    readiness = import_annotation_csv(
        annotation_draft_path=arguments.annotation_draft,
        input_csv_path=arguments.input_csv,
        output_draft_path=arguments.output_draft,
    )
    print(readiness.model_dump_json(indent=2))


if __name__ == "__main__":
    main()
