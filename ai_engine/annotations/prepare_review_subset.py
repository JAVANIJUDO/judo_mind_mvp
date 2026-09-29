from __future__ import annotations

import argparse
from hashlib import sha256
import json
from pathlib import Path

import cv2

from ai_engine.annotations.output_safety import write_new_text_file


def _file_sha256(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def prepare_review_subset(
    *,
    screening_artifact_path: Path,
    output_directory: Path,
) -> dict[str, object]:
    """Extract the existing deterministic subset without pose inference."""

    manifest_path = output_directory / "annotation_template.json"
    if manifest_path.exists():
        raise FileExistsError(
            "Annotation template already exists; refusing to overwrite "
            "possible human review work."
        )

    screening_artifact_sha256 = _file_sha256(screening_artifact_path)
    artifact = json.loads(screening_artifact_path.read_text(encoding="utf-8"))
    video = artifact["video"]
    sampling = artifact["sampling"]
    frame_indices = sampling["frame_indices"]
    timestamps_ms = sampling["timestamps_ms"]

    if len(frame_indices) != 100 or len(timestamps_ms) != 100:
        raise ValueError("The authorized fast-screening subset must contain 100 rows.")

    if not sampling.get("same_timestamps_for_all_engines"):
        raise ValueError("The review subset must use the shared engine timestamps.")

    project_root = Path(__file__).resolve().parents[2]
    video_path = project_root / Path(video["path"])
    if not video_path.is_file():
        raise FileNotFoundError(f"Authorized video not found: {video_path}")

    source_hash_before = _file_sha256(video_path)
    frames_directory = output_directory / "frames"
    sheets_directory = output_directory / "contact_sheets"
    frames_directory.mkdir(parents=True, exist_ok=True)
    sheets_directory.mkdir(parents=True, exist_ok=True)

    capture = cv2.VideoCapture(str(video_path))
    if not capture.isOpened():
        raise RuntimeError(f"Unable to open authorized video: {video_path}")

    extracted: list[dict[str, object]] = []
    thumbnails = []
    try:
        for position, (frame_index, timestamp_ms) in enumerate(
            zip(frame_indices, timestamps_ms, strict=True)
        ):
            capture.set(cv2.CAP_PROP_POS_FRAMES, frame_index)
            success, frame = capture.read()
            if not success:
                raise RuntimeError(f"Unable to decode source frame {frame_index}.")

            filename = (
                f"sample_{position:03d}_f{frame_index:06d}_"
                f"t{timestamp_ms:06d}ms.jpg"
            )
            frame_path = frames_directory / filename
            if not cv2.imwrite(str(frame_path), frame):
                raise RuntimeError(f"Unable to write review frame: {frame_path}")

            thumbnail = cv2.resize(frame, (320, 180), interpolation=cv2.INTER_AREA)
            label = f"#{position:03d}  f={frame_index}  t={timestamp_ms}ms"
            cv2.rectangle(thumbnail, (0, 0), (320, 24), (0, 0, 0), -1)
            cv2.putText(
                thumbnail,
                label,
                (6, 17),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.45,
                (255, 255, 255),
                1,
                cv2.LINE_AA,
            )
            thumbnails.append(thumbnail)
            extracted.append(
                {
                    "sample_position": position,
                    "frame": {
                        "frame_index": frame_index,
                        "timestamp_ms": timestamp_ms,
                    },
                    "image": f"frames/{filename}",
                    "visible_judoka_count": None,
                    "visible_subject_reference_ids": None,
                    "selected_tori_subject_reference_id": None,
                    "occlusion": None,
                    "crossing": None,
                    "reviewer_notes": None,
                }
            )
    finally:
        capture.release()

    for page_start in range(0, len(thumbnails), 25):
        page = thumbnails[page_start : page_start + 25]
        rows = [cv2.hconcat(page[row : row + 5]) for row in range(0, 25, 5)]
        sheet = cv2.vconcat(rows)
        sheet_path = sheets_directory / f"contact_sheet_{page_start // 25 + 1:02d}.jpg"
        if not cv2.imwrite(str(sheet_path), sheet):
            raise RuntimeError(f"Unable to write contact sheet: {sheet_path}")

    source_hash_after = _file_sha256(video_path)
    if source_hash_after != source_hash_before:
        raise RuntimeError("Authorized source video changed during frame extraction.")

    artifact_hash_after = _file_sha256(screening_artifact_path)
    if artifact_hash_after != screening_artifact_sha256:
        raise RuntimeError(
            "Screening artifact changed during review-subset preparation."
        )

    manifest: dict[str, object] = {
        "schema_version": "1.1.0",
        "annotation_type": "single_attempt_uchi_mata_ground_truth_draft",
        "status": "awaiting_human_annotation",
        "source_screening_artifact": str(screening_artifact_path),
        "source_screening_artifact_sha256": screening_artifact_sha256,
        "video": {
            "video_id": f"{artifact['run_id']}:{source_hash_before[:12]}",
            "filename": video_path.name,
            "sha256": source_hash_before,
            "width": video["width"],
            "height": video["height"],
            "source_fps": video["source_fps"],
            "frame_count": video["frame_count"],
            "duration_seconds": video["duration_seconds"],
        },
        "selection": {
            "method": sampling["screening_selection"],
            "sample_count": len(extracted),
            "same_timestamps_as_fast_screening": True,
            "pose_inference_run": False,
        },
        "human_review": {
            "annotation_source": None,
            "reviewer_reference": None,
            "reviewer_notes": None,
            "reviewed_attempt": None,
            "selected_tori_subject_reference_id": None,
            "support_leg": None,
        },
        "frames": extracted,
    }
    write_new_text_file(
        manifest_path,
        json.dumps(manifest, indent=2),
    )
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("screening_artifact", type=Path)
    parser.add_argument("output_directory", type=Path)
    arguments = parser.parse_args()
    manifest = prepare_review_subset(
        screening_artifact_path=arguments.screening_artifact,
        output_directory=arguments.output_directory,
    )
    selection = manifest["selection"]
    if not isinstance(selection, dict):
        raise RuntimeError("Generated annotation selection is invalid.")
    print(
        json.dumps(
            {
                "status": manifest["status"],
                "sample_count": selection["sample_count"],
                "pose_inference_run": selection["pose_inference_run"],
            }
        )
    )


if __name__ == "__main__":
    main()
