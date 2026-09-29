from __future__ import annotations

import argparse
from pathlib import Path

import cv2

from ai_engine.annotations.single_attempt_annotation import (
    AnnotationDraftReadinessReport,
    SingleAttemptAnnotationDraft,
    inspect_annotation_draft,
)
from ai_engine.annotations.output_safety import write_new_text_file


def inspect_annotation_draft_path(
    path: Path,
) -> AnnotationDraftReadinessReport:
    """Inspect a draft without changing it or defaulting human labels."""

    draft = SingleAttemptAnnotationDraft.model_validate_json(
        path.read_text(encoding="utf-8")
    )
    report = inspect_annotation_draft(draft)

    missing: list[int] = []
    unreadable: list[int] = []
    dimension_mismatch: list[int] = []
    readable_count = 0
    review_root = path.parent.resolve()

    for frame in draft.frames:
        asset_path = (review_root / frame.image).resolve()
        if not asset_path.is_relative_to(review_root) or not asset_path.is_file():
            missing.append(frame.sample_position)
            continue

        image = cv2.imread(str(asset_path), cv2.IMREAD_COLOR)
        if image is None:
            unreadable.append(frame.sample_position)
            continue

        readable_count += 1
        height, width = image.shape[:2]
        if width != draft.video.width or height != draft.video.height:
            dimension_mismatch.append(frame.sample_position)

    assets_ready = not (missing or unreadable or dimension_mismatch)
    payload = report.model_dump(mode="json")
    payload.update(
        {
            "can_finalize": report.can_finalize and assets_ready,
            "status": (
                "ready_to_finalize"
                if report.can_finalize and assets_ready
                else "awaiting_human_annotation"
            ),
            "review_asset_check_performed": True,
            "expected_review_asset_count": len(draft.frames),
            "readable_review_asset_count": readable_count,
            "missing_review_asset_sample_positions": missing,
            "unreadable_review_asset_sample_positions": unreadable,
            "dimension_mismatch_review_asset_sample_positions": (
                dimension_mismatch
            ),
            "review_assets_ready": assets_ready,
        }
    )
    return AnnotationDraftReadinessReport.model_validate(payload)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("annotation_draft", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--require-ready",
        action="store_true",
        help="Exit with status 2 when human annotation is incomplete.",
    )
    arguments = parser.parse_args()

    report = inspect_annotation_draft_path(arguments.annotation_draft)
    serialized = report.model_dump_json(indent=2)
    if arguments.output is not None:
        write_new_text_file(arguments.output, serialized)
    print(serialized)

    if arguments.require_ready and not report.can_finalize:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
