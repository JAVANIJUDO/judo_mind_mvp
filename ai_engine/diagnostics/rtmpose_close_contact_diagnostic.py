from __future__ import annotations

import argparse
import json
from pathlib import Path

import cv2
import numpy as np
from rtmlib import Body


# Human-reviewed representative Run 01 failure samples.
DEFAULT_SAMPLES = [
    7,   # surplus, clear
    11,  # deficit, clear
    12,  # deficit, occlusion + crossing
    20,  # deficit, clear
    31,  # surplus, occlusion
    39,  # complete dropout
    46,  # deficit, occlusion + crossing
    49,  # deficit, clear
    64,  # deficit, occlusion + crossing
    82,  # severe surplus: V2/D4
    94,  # deficit, occlusion + crossing
    99,  # surplus
]


def normalize_bboxes(raw) -> list:
    if raw is None:
        return []

    if isinstance(raw, np.ndarray):
        return raw.tolist()

    if isinstance(raw, (list, tuple)):
        result = []
        for item in raw:
            if isinstance(item, np.ndarray):
                result.append(item.tolist())
            elif isinstance(item, (list, tuple)):
                result.append(list(item))
            else:
                result.append(item)
        return result

    return [raw]


def draw_bbox(image, box, index):
    if not isinstance(box, (list, tuple)) or len(box) < 4:
        return

    x1, y1, x2, y2 = map(int, box[:4])

    cv2.rectangle(
        image,
        (x1, y1),
        (x2, y2),
        (255, 255, 255),
        2,
    )

    label = f"DET {index}"

    if len(box) >= 5:
        try:
            label += f" {float(box[4]):.3f}"
        except Exception:
            pass

    cv2.putText(
        image,
        label,
        (x1, max(18, y1 - 6)),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.5,
        (255, 255, 255),
        1,
        cv2.LINE_AA,
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("ground_truth")
    parser.add_argument("review_root")
    parser.add_argument("output_dir")
    parser.add_argument(
        "--keypoint-threshold",
        type=float,
        default=0.30,
    )
    args = parser.parse_args()

    gt_path = Path(args.ground_truth)
    review_root = Path(args.review_root)
    output_dir = Path(args.output_dir)

    if output_dir.exists():
        raise RuntimeError(
            f"Output directory already exists; nothing overwritten: "
            f"{output_dir}"
        )

    output_dir.mkdir(parents=True)

    gt = json.loads(gt_path.read_text(encoding="utf-8"))

    by_sample = {
        int(item["sample_position"]): item
        for item in gt["frames"]
    }

    print("Initializing RTMPose-M diagnostic runner...")

    # Same RTMLib balanced configuration used by the current baseline.
    model = Body(
        mode="balanced",
        backend="onnxruntime",
        device="cpu",
    )

    if getattr(model, "one_stage", False):
        raise RuntimeError(
            "Expected two-stage detector + pose pipeline, "
            "but RTMLib reports one_stage=True."
        )

    summary = []

    for sample_position in DEFAULT_SAMPLES:
        item = by_sample[sample_position]

        image_path = review_root / item["image"]
        image = cv2.imread(str(image_path))

        if image is None:
            raise RuntimeError(f"Cannot read image: {image_path}")

        # Diagnostic access to the two internal stages.
        raw_bboxes = model.det_model(image)

        keypoints, scores = model.pose_model(
            image,
            bboxes=raw_bboxes,
        )

        bboxes = normalize_bboxes(raw_bboxes)

        keypoints_array = np.asarray(keypoints)
        scores_array = np.asarray(scores)

        if scores_array.ndim == 1:
            scores_array = scores_array[None, :]

        if keypoints_array.ndim == 2 and keypoints_array.size:
            keypoints_array = keypoints_array[None, :, :]

        valid_pose_indices = []

        for pose_index in range(len(scores_array)):
            pose_scores = scores_array[pose_index]

            if np.any(
                np.asarray(pose_scores, dtype=float)
                >= args.keypoint_threshold
            ):
                valid_pose_indices.append(pose_index)

        overlay = image.copy()

        for bbox_index, bbox in enumerate(bboxes):
            draw_bbox(overlay, bbox, bbox_index)

        # Draw returned pose keypoints.
        if keypoints_array.size and scores_array.size:
            for pose_index in range(len(keypoints_array)):
                for kp_index in range(len(keypoints_array[pose_index])):
                    score = float(scores_array[pose_index][kp_index])

                    if score < args.keypoint_threshold:
                        continue

                    x = int(keypoints_array[pose_index][kp_index][0])
                    y = int(keypoints_array[pose_index][kp_index][1])

                    cv2.circle(
                        overlay,
                        (x, y),
                        3,
                        (255, 255, 255),
                        -1,
                    )

        label = (
            f"sample #{sample_position:03d} | "
            f"human={item['visible_judoka_count']} | "
            f"det_boxes={len(bboxes)} | "
            f"valid_poses={len(valid_pose_indices)}"
        )

        cv2.rectangle(
            overlay,
            (0, 0),
            (overlay.shape[1], 32),
            (0, 0, 0),
            -1,
        )

        cv2.putText(
            overlay,
            label,
            (8, 22),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.48,
            (255, 255, 255),
            1,
            cv2.LINE_AA,
        )

        stem = f"sample_{sample_position:03d}"

        overlay_path = output_dir / f"{stem}_overlay.jpg"
        json_path = output_dir / f"{stem}_raw.json"

        if not cv2.imwrite(str(overlay_path), overlay):
            raise RuntimeError(
                f"Could not save overlay: {overlay_path}"
            )

        record = {
            "sample_position": sample_position,
            "frame_index": item["frame"]["frame_index"],
            "timestamp_ms": item["frame"]["timestamp_ms"],
            "human_visible_judoka_count": item[
                "visible_judoka_count"
            ],
            "human_occlusion": item["occlusion"],
            "human_crossing": item["crossing"],
            "diagnostic_only": True,
            "model": "rtmpose-m",
            "pipeline": "rtmlib-balanced-two-stage",
            "keypoint_threshold": args.keypoint_threshold,
            "detector_box_count": len(bboxes),
            "detector_boxes": bboxes,
            "pose_output_count": (
                int(len(scores_array))
                if scores_array.size
                else 0
            ),
            "valid_pose_indices": valid_pose_indices,
            "valid_pose_count": len(valid_pose_indices),
            "keypoints": (
                keypoints_array.tolist()
                if keypoints_array.size
                else []
            ),
            "keypoint_scores": (
                scores_array.tolist()
                if scores_array.size
                else []
            ),
        }

        json_path.write_text(
            json.dumps(record, indent=2),
            encoding="utf-8",
        )

        summary.append({
            "sample_position": sample_position,
            "human_visible": item["visible_judoka_count"],
            "occlusion": item["occlusion"],
            "crossing": item["crossing"],
            "detector_boxes": len(bboxes),
            "pose_outputs": (
                int(len(scores_array))
                if scores_array.size
                else 0
            ),
            "valid_poses": len(valid_pose_indices),
        })

        print(
            f"#{sample_position:03d} | "
            f"human={item['visible_judoka_count']} | "
            f"boxes={len(bboxes)} | "
            f"pose_outputs="
            f"{summary[-1]['pose_outputs']} | "
            f"valid={len(valid_pose_indices)}"
        )

    summary_path = output_dir / "diagnostic_summary.json"

    summary_path.write_text(
        json.dumps(
            {
                "diagnostic_type":
                    "rtmpose_close_contact_failure_diagnostic",
                "scientific_status": "diagnostic_only",
                "samples": summary,
            },
            indent=2,
        ),
        encoding="utf-8",
    )

    print()
    print("DIAGNOSTIC COMPLETE")
    print("SAMPLES:", len(summary))
    print("SUMMARY:", summary_path)
    print("PRODUCTION CODE UNCHANGED")


if __name__ == "__main__":
    main()
