from __future__ import annotations

import argparse
import csv
import json
import math
import time
from pathlib import Path
from typing import Any

import cv2
import numpy as np
from rtmlib import Body

from ai_engine.benchmarks.pose_engine_benchmark import (
    DEFAULT_KEYPOINT_THRESHOLD,
    MINIMUM_VISIBLE_KEYPOINTS,
    RTMPOSE_M_FILENAME,
    YOLOX_M_FILENAME,
    _valid_pose_indices,
    probe_video_metadata,
    require_cached_rtmlib_models,
)
from ai_engine.video_sampling import build_video_sampling_plan


SCHEMA_VERSION = "1.0.0"
CONTACT_SHEET_COLUMNS = 3
CONTACT_SHEET_ROWS = 3
ALLOWED_SUBJECT_REFERENCE_IDS = (
    "subject-1",
    "subject-2",
    "unassigned",
)


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Prepare bounded, evaluation-only RTMPose-M geometry and a blank "
            "human-review mapping template."
        )
    )
    parser.add_argument("video", type=Path)
    parser.add_argument("ground_truth", type=Path)
    parser.add_argument("output_dir", type=Path)
    parser.add_argument("--start-ms", type=int, required=True)
    parser.add_argument("--end-ms", type=int, required=True)
    parser.add_argument("--target-fps", type=float, default=10.0)
    parser.add_argument(
        "--plan-only",
        action="store_true",
        help="Validate and print the bounded plan without decoding or inference.",
    )
    return parser.parse_args()


def _normalize_people(array: Any, *, dimensions: int) -> np.ndarray:
    normalized = np.asarray(array)

    if normalized.size == 0:
        if dimensions == 3:
            return np.empty((0, 0, 2), dtype=float)
        return np.empty((0, 0), dtype=float)

    if normalized.ndim == dimensions - 1:
        normalized = np.expand_dims(normalized, axis=0)

    if normalized.ndim != dimensions:
        raise RuntimeError(
            f"Unexpected RTMPose output rank {normalized.ndim}; "
            f"expected {dimensions}."
        )

    return normalized


def _normalize_boxes(raw_boxes: Any) -> list[list[float]]:
    if raw_boxes is None:
        return []

    boxes = np.asarray(raw_boxes)

    if boxes.size == 0:
        return []

    if boxes.ndim == 1:
        boxes = np.expand_dims(boxes, axis=0)

    if boxes.ndim != 2 or boxes.shape[1] < 4:
        raise RuntimeError("RTMLib returned an unexpected detector-box shape.")

    return [[float(value) for value in row] for row in boxes]


def _reviewed_anchors(
    ground_truth: dict[str, Any],
    *,
    start_ms: int,
    end_ms: int,
) -> list[dict[str, Any]]:
    anchors = []

    for item in ground_truth.get("frames", []):
        frame = item.get("frame", {})
        timestamp_ms = int(frame.get("timestamp_ms", -1))

        if start_ms <= timestamp_ms <= end_ms:
            anchors.append(
                {
                    "sample_position": int(item["sample_position"]),
                    "frame_index": int(frame["frame_index"]),
                    "timestamp_ms": timestamp_ms,
                    "visible_judoka_count": int(
                        item["visible_judoka_count"]
                    ),
                    "occlusion": bool(item["occlusion"]),
                    "crossing": bool(item["crossing"]),
                    "visible_subject_reference_ids": list(
                        item.get("visible_subject_reference_ids", [])
                    ),
                }
            )

    return anchors


def _bounded_plan(
    metadata: dict[str, Any],
    *,
    target_fps: float,
    start_ms: int,
    end_ms: int,
) -> list[tuple[int, int]]:
    if start_ms < 0 or end_ms < start_ms:
        raise ValueError("The evaluation interval is invalid.")

    if not math.isfinite(target_fps) or target_fps <= 0:
        raise ValueError("target_fps must be a finite positive value.")

    full_plan = build_video_sampling_plan(
        source_fps=float(metadata["source_fps"]),
        target_fps=target_fps,
        frame_count=int(metadata["frame_count"]),
    )
    bounded = [
        (frame_index, timestamp_ms)
        for frame_index, timestamp_ms in zip(
            full_plan.frame_indices,
            full_plan.timestamps_ms,
        )
        if start_ms <= timestamp_ms <= end_ms
    ]

    if not bounded:
        raise RuntimeError("The bounded sampling plan contains no frames.")

    return bounded


def _draw_overlay(
    frame: np.ndarray,
    *,
    sample_index: int,
    sample_count: int,
    frame_index: int,
    timestamp_ms: int,
    boxes: list[list[float]],
    keypoints: np.ndarray,
    scores: np.ndarray,
    valid_pose_indices: list[int],
) -> np.ndarray:
    overlay = frame.copy()
    valid_set = set(valid_pose_indices)

    for detection_index, box in enumerate(boxes):
        x1, y1, x2, y2 = (int(round(value)) for value in box[:4])
        color = (255, 255, 255) if detection_index in valid_set else (120, 120, 120)
        thickness = 2 if detection_index in valid_set else 1
        cv2.rectangle(overlay, (x1, y1), (x2, y2), color, thickness)
        label = (
            f"DET {detection_index} | subject: ______"
            if detection_index in valid_set
            else f"RAW BOX {detection_index} | pose withheld"
        )
        label_top = max(34, y1 - 21)
        label_bottom = min(overlay.shape[0] - 1, label_top + 21)
        cv2.rectangle(
            overlay,
            (x1, label_top),
            (min(overlay.shape[1] - 1, x1 + 245), label_bottom),
            (0, 0, 0),
            -1,
        )
        cv2.putText(
            overlay,
            label,
            (x1 + 3, label_top + 16),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.43,
            color,
            1,
            cv2.LINE_AA,
        )

    for detection_index in valid_pose_indices:
        if detection_index >= len(keypoints) or detection_index >= len(scores):
            raise RuntimeError(
                "Valid pose index is missing matching keypoint geometry."
            )

        for point, score in zip(
            keypoints[detection_index],
            scores[detection_index],
        ):
            if float(score) < DEFAULT_KEYPOINT_THRESHOLD:
                continue
            x, y = int(round(float(point[0]))), int(round(float(point[1])))
            cv2.circle(overlay, (x, y), 2, (255, 255, 255), -1)

    cv2.rectangle(
        overlay,
        (0, 0),
        (overlay.shape[1], 32),
        (0, 0, 0),
        -1,
    )
    banner = (
        f"sample {sample_index:02d}/{sample_count - 1:02d} | "
        f"frame {frame_index} | {timestamp_ms} ms | "
        f"valid detections {len(valid_pose_indices)}"
    )
    cv2.putText(
        overlay,
        banner,
        (8, 22),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.52,
        (255, 255, 255),
        1,
        cv2.LINE_AA,
    )

    return overlay


def _write_contact_sheets(
    overlays: list[np.ndarray],
    output_dir: Path,
) -> list[str]:
    if not overlays:
        raise RuntimeError("Cannot create contact sheets without overlays.")

    per_sheet = CONTACT_SHEET_COLUMNS * CONTACT_SHEET_ROWS
    height, width = overlays[0].shape[:2]
    contact_sheet_paths = []

    for sheet_index, start in enumerate(range(0, len(overlays), per_sheet), 1):
        sheet = np.zeros(
            (
                height * CONTACT_SHEET_ROWS,
                width * CONTACT_SHEET_COLUMNS,
                3,
            ),
            dtype=np.uint8,
        )
        page = overlays[start : start + per_sheet]

        for offset, overlay in enumerate(page):
            row, column = divmod(offset, CONTACT_SHEET_COLUMNS)
            y1, y2 = row * height, (row + 1) * height
            x1, x2 = column * width, (column + 1) * width
            sheet[y1:y2, x1:x2] = overlay

        path = output_dir / f"contact_sheet_{sheet_index:02d}.jpg"

        if not cv2.imwrite(str(path), sheet, [cv2.IMWRITE_JPEG_QUALITY, 92]):
            raise RuntimeError(f"Could not write contact sheet: {path}")

        contact_sheet_paths.append(str(path))

    return contact_sheet_paths


def _write_mapping_csv(rows: list[dict[str, Any]], path: Path) -> None:
    fieldnames = [
        "frame_index",
        "timestamp_ms",
        "detection_index",
        "human_subject_reference_id",
        "occlusion",
        "crossing",
        "reviewer_notes",
    ]

    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    args = _parse_args()
    video = args.video.resolve()
    ground_truth_path = args.ground_truth.resolve()
    output_dir = args.output_dir.resolve()

    if not video.is_file():
        raise FileNotFoundError(f"Video not found: {video}")

    if not ground_truth_path.is_file():
        raise FileNotFoundError(
            f"Ground-truth annotation not found: {ground_truth_path}"
        )

    ground_truth = json.loads(ground_truth_path.read_text(encoding="utf-8"))
    metadata = probe_video_metadata(video)
    plan = _bounded_plan(
        metadata,
        target_fps=args.target_fps,
        start_ms=args.start_ms,
        end_ms=args.end_ms,
    )
    anchors = _reviewed_anchors(
        ground_truth,
        start_ms=args.start_ms,
        end_ms=args.end_ms,
    )

    if not anchors:
        raise RuntimeError(
            "Selected interval has no existing human-reviewed Run 01 anchors."
        )

    if not any(
        anchor["occlusion"] or anchor["crossing"] for anchor in anchors
    ):
        raise RuntimeError(
            "Selected interval has no reviewed crossing or occlusion anchor."
        )

    print(f"INTERVAL_MS: {args.start_ms}-{args.end_ms}")
    print(f"SAMPLES: {len(plan)}")
    print(f"FRAME_RANGE: {plan[0][0]}-{plan[-1][0]}")
    print(f"TIMESTAMPS_MS: {','.join(str(item[1]) for item in plan)}")
    print(f"HUMAN_REVIEWED_ANCHORS: {len(anchors)}")

    if args.plan_only:
        print("PLAN_ONLY: no decoding, inference, or artifacts")
        return

    if output_dir.exists():
        raise RuntimeError(
            f"Output directory already exists; nothing overwritten: {output_dir}"
        )

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

    output_dir.mkdir(parents=True)
    overlays_dir = output_dir / "overlays"
    contact_sheets_dir = output_dir / "contact_sheets"
    frame_records_dir = output_dir / "frame_geometry"
    overlays_dir.mkdir()
    contact_sheets_dir.mkdir()
    frame_records_dir.mkdir()

    capture = cv2.VideoCapture(str(video))

    if not capture.isOpened():
        raise RuntimeError(f"Cannot open video: {video}")

    first_frame, last_frame = plan[0][0], plan[-1][0]
    selected = {frame_index: timestamp_ms for frame_index, timestamp_ms in plan}
    capture.set(cv2.CAP_PROP_POS_FRAMES, first_frame)
    frame_records = []
    mapping_rows = []
    overlays = []
    inference_seconds = 0.0
    processing_started = time.perf_counter()
    current_frame = first_frame

    try:
        while current_frame <= last_frame:
            success, frame = capture.read()

            if not success:
                raise RuntimeError(
                    f"Video decoding stopped before frame {current_frame}."
                )

            if current_frame not in selected:
                current_frame += 1
                continue

            timestamp_ms = selected[current_frame]
            sample_index = len(frame_records)
            inference_started = time.perf_counter()
            raw_boxes = model.det_model(frame)
            keypoints_raw, scores_raw = model.pose_model(
                frame,
                bboxes=raw_boxes,
            )
            inference_seconds += time.perf_counter() - inference_started
            boxes = _normalize_boxes(raw_boxes)
            keypoints = _normalize_people(keypoints_raw, dimensions=3)
            scores = _normalize_people(scores_raw, dimensions=2)
            valid_indices = _valid_pose_indices(
                keypoints,
                scores,
                DEFAULT_KEYPOINT_THRESHOLD,
            )

            if any(index >= len(boxes) for index in valid_indices):
                raise RuntimeError(
                    "A valid pose output has no matching detector box."
                )

            detections = []

            for detection_index in valid_indices:
                detection = {
                    "detection_index": detection_index,
                    "bounding_box": boxes[detection_index],
                    "keypoints": keypoints[detection_index].tolist(),
                    "keypoint_scores": scores[detection_index].tolist(),
                    "provenance": "model-estimated",
                }
                detections.append(detection)
                mapping_rows.append(
                    {
                        "frame_index": current_frame,
                        "timestamp_ms": timestamp_ms,
                        "detection_index": detection_index,
                        "human_subject_reference_id": "",
                        "occlusion": "",
                        "crossing": "",
                        "reviewer_notes": "",
                    }
                )

            record = {
                "sample_index": sample_index,
                "frame_index": current_frame,
                "timestamp_ms": timestamp_ms,
                "raw_detector_boxes": boxes,
                "raw_pose_output_count": int(len(scores)),
                "valid_detection_count": len(valid_indices),
                "valid_detection_indices": valid_indices,
                "detections": detections,
            }
            frame_records.append(record)

            frame_record_path = (
                frame_records_dir
                / f"frame_{current_frame:06d}_{timestamp_ms:06d}ms.json"
            )
            frame_record_path.write_text(
                json.dumps(record, indent=2),
                encoding="utf-8",
            )

            overlay = _draw_overlay(
                frame,
                sample_index=sample_index,
                sample_count=len(plan),
                frame_index=current_frame,
                timestamp_ms=timestamp_ms,
                boxes=boxes,
                keypoints=keypoints,
                scores=scores,
                valid_pose_indices=valid_indices,
            )
            overlay_path = (
                overlays_dir
                / f"sample_{sample_index:02d}_frame_{current_frame:06d}.jpg"
            )

            if not cv2.imwrite(
                str(overlay_path),
                overlay,
                [cv2.IMWRITE_JPEG_QUALITY, 94],
            ):
                raise RuntimeError(f"Could not write overlay: {overlay_path}")

            overlays.append(overlay)
            print(
                f"[{len(frame_records):02d}/{len(plan):02d}] "
                f"frame={current_frame} timestamp_ms={timestamp_ms} "
                f"detections={len(valid_indices)}",
                flush=True,
            )
            current_frame += 1
    finally:
        capture.release()

    if len(frame_records) != len(plan):
        raise RuntimeError(
            f"Expected {len(plan)} frames but processed {len(frame_records)}."
        )

    contact_sheet_paths = _write_contact_sheets(
        overlays,
        contact_sheets_dir,
    )
    processing_seconds = time.perf_counter() - processing_started
    geometry = {
        "schema_version": SCHEMA_VERSION,
        "artifact_type": "bounded_neutral_identity_evaluation_geometry",
        "scientific_status": "experimental_evaluation_only",
        "tracker_executed": False,
        "tracking_accuracy_claimed": False,
        "identity_policy": {
            "role_neutral_only": True,
            "allowed_human_subject_reference_ids": list(
                ALLOWED_SUBJECT_REFERENCE_IDS
            ),
            "detection_index_is_frame_local_only": True,
            "automatic_subject_identity_assignment": False,
        },
        "source": metadata,
        "interval": {
            "requested_start_ms": args.start_ms,
            "requested_end_ms": args.end_ms,
            "first_sample_timestamp_ms": plan[0][1],
            "last_sample_timestamp_ms": plan[-1][1],
            "first_source_frame_index": first_frame,
            "last_source_frame_index": last_frame,
        },
        "sampling": {
            "purpose": "engineering_identity_evaluation_only",
            "requested_target_fps": args.target_fps,
            "planned_frame_count": len(plan),
            "frame_indices": [item[0] for item in plan],
            "timestamps_ms": [item[1] for item in plan],
            "not_a_scientific_temporal_resolution_claim": True,
        },
        "model": {
            "engine": "RTMPose-M",
            "pipeline": "RTMLib balanced two-stage baseline",
            "detector": "YOLOX-M",
            "backend": "onnxruntime",
            "device": "cpu",
            "keypoint_threshold": DEFAULT_KEYPOINT_THRESHOLD,
            "minimum_visible_keypoints": MINIMUM_VISIBLE_KEYPOINTS,
            "threshold_unchanged_from_run01_baseline": True,
            "models_downloaded": False,
        },
        "timing": {
            "initialization_seconds": initialization_seconds,
            "inference_seconds": inference_seconds,
            "bounded_processing_seconds": processing_seconds,
        },
        "existing_human_reviewed_interval_anchors": anchors,
        "frames": frame_records,
    }
    geometry_path = output_dir / "run01_identity_geometry.json"
    geometry_path.write_text(
        json.dumps(geometry, indent=2),
        encoding="utf-8",
    )
    mapping = {
        "schema_version": SCHEMA_VERSION,
        "artifact_type": "neutral_identity_human_review_mapping_template",
        "status": "human_review_required",
        "tracker_executed": False,
        "instructions": [
            "Review frames in temporal order using overlays/contact sheets.",
            "Enter only subject-1, subject-2, or unassigned.",
            "Do not use frame-local detection_index as athlete identity.",
            "Set occlusion and crossing to true or false after human review.",
            "Do not infer technique roles.",
        ],
        "allowed_human_subject_reference_ids": list(
            ALLOWED_SUBJECT_REFERENCE_IDS
        ),
        "rows": mapping_rows,
    }
    mapping_json_path = output_dir / "human_identity_mapping_template.json"
    mapping_csv_path = output_dir / "human_identity_mapping_template.csv"
    mapping_json_path.write_text(
        json.dumps(mapping, indent=2),
        encoding="utf-8",
    )
    _write_mapping_csv(mapping_rows, mapping_csv_path)

    print("ARTIFACT COMPLETE")
    print(f"GEOMETRY: {geometry_path}")
    print(f"CONTACT_SHEETS: {len(contact_sheet_paths)}")
    print(f"MAPPING_JSON: {mapping_json_path}")
    print(f"MAPPING_CSV: {mapping_csv_path}")
    print("TRACKER_EXECUTED: NO")
    print("PRODUCTION_CODE_CHANGED: NO")


if __name__ == "__main__":
    main()
