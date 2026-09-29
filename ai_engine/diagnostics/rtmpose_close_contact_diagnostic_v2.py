from __future__ import annotations

import json
from pathlib import Path

import cv2
import numpy as np
from rtmlib import Body

from ai_engine.benchmarks.pose_engine_benchmark import (
    YOLOX_M_FILENAME,
    RTMPOSE_M_FILENAME,
    require_cached_rtmlib_models,
    _valid_pose_indices,
)

ROOT = Path(r"D:\projects\judo_mind")

VIDEO = (
    ROOT / "ai_engine/runtime/benchmark_inputs"
    / "c18aa4e175f37ac41c7725009798b87e69088153-360p.mp4"
)

GT = (
    ROOT / "ai_engine/runtime/annotation_review/run01"
    / "uchi_mata_ground_truth_run01.json"
)

BENCHMARK = (
    ROOT / "ai_engine/runtime/benchmark_outputs"
    / "run01_fast_screening_combined.json"
)

OUTPUT = (
    ROOT / "ai_engine/runtime/annotation_review/run01"
    / "rtmpose_raw_diagnostic_v2"
)

SAMPLES = [7, 11, 12, 20, 31, 39, 46, 49, 64, 82, 94, 99]

KEYPOINT_THRESHOLD = 0.30


def normalize_boxes(raw):
    if raw is None:
        return []
    arr = np.asarray(raw)
    if arr.size == 0:
        return []
    return arr.tolist()


def main():
    if OUTPUT.exists():
        raise RuntimeError(
            f"Output already exists; nothing overwritten: {OUTPUT}"
        )

    OUTPUT.mkdir(parents=True)

    gt = json.loads(GT.read_text(encoding="utf-8"))
    benchmark = json.loads(BENCHMARK.read_text(encoding="utf-8"))

    gt_by_sample = {
        int(x["sample_position"]): x
        for x in gt["frames"]
    }

    rtmpose = next(
        x for x in benchmark["engines"]
        if x.get("engine_id") == "rtmpose-m"
    )

    oracle = {
        int(x["frame_index"]): int(x["pose_count"])
        for x in rtmpose["observations"]
    }

    selected = {
        int(gt_by_sample[s]["frame"]["frame_index"]): s
        for s in SAMPLES
    }

    cached = require_cached_rtmlib_models(
        (YOLOX_M_FILENAME, RTMPOSE_M_FILENAME)
    )

    model = Body(
        det=str(cached[YOLOX_M_FILENAME]),
        det_input_size=(640, 640),
        pose=str(cached[RTMPOSE_M_FILENAME]),
        pose_input_size=(192, 256),
        to_openpose=False,
        backend="onnxruntime",
        device="cpu",
    )

    cap = cv2.VideoCapture(str(VIDEO))
    if not cap.isOpened():
        raise RuntimeError(f"Cannot open video: {VIDEO}")

    results = []
    frame_index = 0

    try:
        while True:
            ok, frame = cap.read()
            if not ok:
                break

            if frame_index not in selected:
                frame_index += 1
                continue

            sample = selected[frame_index]
            gt_item = gt_by_sample[sample]

            # Exact two-stage path used by RTMLib Body.
            raw_boxes = model.det_model(frame)
            keypoints, scores = model.pose_model(
                frame,
                bboxes=raw_boxes,
            )

            kp = np.asarray(keypoints)
            sc = np.asarray(scores)

            valid = _valid_pose_indices(
                kp,
                sc,
                KEYPOINT_THRESHOLD,
            )

            reproduced_count = len(valid)
            expected_count = oracle[frame_index]
            reproduction_pass = reproduced_count == expected_count

            boxes = normalize_boxes(raw_boxes)

            record = {
                "sample_position": sample,
                "frame_index": frame_index,
                "timestamp_ms": int(
                    gt_item["frame"]["timestamp_ms"]
                ),
                "human_visible_judoka_count": int(
                    gt_item["visible_judoka_count"]
                ),
                "human_occlusion": bool(gt_item["occlusion"]),
                "human_crossing": bool(gt_item["crossing"]),
                "benchmark_expected_pose_count": expected_count,
                "reproduced_pose_count": reproduced_count,
                "reproduction_pass": reproduction_pass,
                "detector_box_count": len(boxes),
                "detector_boxes": boxes,
                "raw_pose_output_count": (
                    int(len(sc)) if sc.size else 0
                ),
                "valid_pose_indices": valid,
                "keypoint_threshold": KEYPOINT_THRESHOLD,
                "minimum_visible_keypoints": 8,
            }

            (OUTPUT / f"sample_{sample:03d}.json").write_text(
                json.dumps(record, indent=2),
                encoding="utf-8",
            )

            results.append(record)

            print(
                f"#{sample:03d} | "
                f"benchmark={expected_count} | "
                f"reproduced={reproduced_count} | "
                f"boxes={len(boxes)} | "
                f"{'PASS' if reproduction_pass else 'FAIL'}"
            )

            frame_index += 1

    finally:
        cap.release()

    if len(results) != len(SAMPLES):
        raise RuntimeError(
            f"Expected {len(SAMPLES)} diagnostic frames; "
            f"processed {len(results)}."
        )

    passed = sum(x["reproduction_pass"] for x in results)

    summary = {
        "diagnostic_version": "v2",
        "scientific_status": "diagnostic_only",
        "video_source": str(VIDEO),
        "keypoint_threshold_candidate": KEYPOINT_THRESHOLD,
        "minimum_visible_keypoints": 8,
        "sample_count": len(results),
        "reproduction_pass_count": passed,
        "reproduction_fail_count": len(results) - passed,
        "full_reproduction_pass": passed == len(results),
        "samples": results,
    }

    (OUTPUT / "diagnostic_summary.json").write_text(
        json.dumps(summary, indent=2),
        encoding="utf-8",
    )

    print()
    print("=== V2 REPRODUCTION GATE ===")
    print(f"PASS: {passed}/{len(results)}")

    if passed == len(results):
        print("STATUS: REPRODUCTION PASS")
        print("BBOX EVIDENCE MAY NOW BE INTERPRETED")
    else:
        print("STATUS: REPRODUCTION FAIL")
        print("STOP THIS DIAGNOSTIC BRANCH")
        print("DO NOT INTERPRET BBOX EVIDENCE")

    print("PRODUCTION CODE UNCHANGED")


if __name__ == "__main__":
    main()
