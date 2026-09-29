from __future__ import annotations

import asyncio
from io import BytesIO
import json
from pathlib import Path
from unittest import TestCase
from unittest.mock import patch

from fastapi import HTTPException
from starlette.datastructures import Headers, UploadFile

from ai_engine.main import (
    UPLOAD_DIRECTORY,
    _read_video_sampling_metadata,
    analyze_single_attempt_v2a_video,
    app,
)


def _review_json(*, timestamp_ms: int = 2000) -> str:
    return json.dumps(
        {
            "schema_version": "2.0.0",
            "analysis_variant": "single_attempt_v2a",
            "video_id": "authorized-video-1",
            "technique": {"id": "uchi-mata"},
            "camera_view": "side",
            "attempt": {
                "start": {"frame_index": 25, "timestamp_ms": 1000},
                "end": {"frame_index": 75, "timestamp_ms": 3000},
                "event_schema_id": "human-single-attempt-boundaries-v1",
                "selection_source": "human-selected",
            },
            "subject": {
                "neutral_track_id": "Track A",
                "selected_detection_index": 0,
                "role": "Tori",
                "confirmation_source": "human-confirmed",
            },
            "support_leg": {
                "side": "left",
                "confirmation_source": "human-confirmed",
            },
            "angle_frame": {
                "frame": {"frame_index": 50, "timestamp_ms": timestamp_ms},
                "selection_source": "human-selected",
                "event_label": "reviewed-angle-observation",
            },
            "camera_suitability": {
                "projected_angle_view_suitable": True,
                "low_roll_confirmed": True,
                "review_source": "human-reviewed",
            },
            "pose_observation": None,
        }
    )


class _SelectedFramePoseEngine:
    def __init__(self, *, include_pose: bool = True) -> None:
        self.include_pose = include_pose
        self.sampling_plan = None
        self.target_fps = None

    def analyze_video(
        self,
        video_path: Path,
        target_fps: float,
        *,
        sampling_plan,
    ) -> dict[str, object]:
        if not video_path.exists():
            raise AssertionError("Temporary upload was not created.")
        self.sampling_plan = sampling_plan
        self.target_fps = target_fps
        landmarks = [
            {
                "x": index / 100.0,
                "y": index / 200.0,
                "z": 0.0,
                "visibility": 0.9,
                "presence": 0.9,
            }
            for index in range(33)
        ]
        poses = (
            [{"pose_index": 0, "landmarks": landmarks, "world_landmarks": []}]
            if self.include_pose
            else []
        )
        return {
            "video": {"width": 640, "height": 360},
            "frames": [
                {
                    "frame_index": 50,
                    "timestamp_ms": 2000,
                    "pose_count": len(poses),
                    "poses": poses,
                }
            ]
        }


class _FailingSelectedFramePoseEngine:
    def analyze_video(self, video_path: Path, target_fps: float, **kwargs):
        del target_fps, kwargs
        if not video_path.exists():
            raise AssertionError("Temporary upload was not created.")
        raise RuntimeError("expected selected-frame inference failure")


class _InvalidDimensionsSelectedFramePoseEngine(_SelectedFramePoseEngine):
    def analyze_video(
        self,
        video_path: Path,
        target_fps: float,
        *,
        sampling_plan,
    ) -> dict[str, object]:
        result = super().analyze_video(
            video_path,
            target_fps,
            sampling_plan=sampling_plan,
        )
        result["video"] = {"width": 0, "height": 360}
        return result


class _MetadataCapture:
    def __init__(self, *, source_fps: float, frame_count: int) -> None:
        self.source_fps = source_fps
        self.frame_count = frame_count
        self.released = False

    def isOpened(self) -> bool:
        return True

    def get(self, property_id: int) -> float:
        from cv2 import CAP_PROP_FPS, CAP_PROP_FRAME_COUNT

        if property_id == CAP_PROP_FPS:
            return self.source_fps
        if property_id == CAP_PROP_FRAME_COUNT:
            return float(self.frame_count)
        return 0.0

    def release(self) -> None:
        self.released = True


def _upload() -> UploadFile:
    return UploadFile(
        filename="uchi-mata.mp4",
        file=BytesIO(b"not-a-real-video"),
        headers=Headers({"content-type": "video/mp4"}),
    )


class SingleAttemptV2AVideoApiTest(TestCase):
    def test_scientific_metadata_never_assumes_missing_source_fps(self) -> None:
        capture = _MetadataCapture(source_fps=0.0, frame_count=100)
        with patch(
            "ai_engine.main.cv2.VideoCapture",
            return_value=capture,
        ):
            with self.assertRaisesRegex(ValueError, "will not assume"):
                _read_video_sampling_metadata(Path("ignored.mp4"))

        self.assertTrue(capture.released)

    def test_inference_failure_is_bounded_and_cleans_upload(self) -> None:
        existing_uploads = set(UPLOAD_DIRECTORY.iterdir())
        upload = _upload()
        app.state.pose_engine = _FailingSelectedFramePoseEngine()

        with patch(
            "ai_engine.main._read_video_sampling_metadata",
            return_value=(25.0, 100),
        ):
            with self.assertRaises(HTTPException) as raised:
                asyncio.run(
                    analyze_single_attempt_v2a_video(
                        video=upload,
                        review_json=_review_json(),
                    )
                )

        self.assertEqual(raised.exception.status_code, 500)
        self.assertEqual(
            raised.exception.detail,
            "Single-attempt V2A video analysis failed.",
        )
        self.assertTrue(upload.file.closed)
        self.assertEqual(set(UPLOAD_DIRECTORY.iterdir()), existing_uploads)

    def test_invalid_image_dimensions_fail_closed_and_clean_upload(self) -> None:
        existing_uploads = set(UPLOAD_DIRECTORY.iterdir())
        upload = _upload()
        app.state.pose_engine = _InvalidDimensionsSelectedFramePoseEngine()

        with patch(
            "ai_engine.main._read_video_sampling_metadata",
            return_value=(25.0, 100),
        ):
            with self.assertRaises(HTTPException) as raised:
                asyncio.run(
                    analyze_single_attempt_v2a_video(
                        video=upload,
                        review_json=_review_json(),
                    )
                )

        self.assertEqual(raised.exception.status_code, 500)
        self.assertEqual(
            raised.exception.detail,
            "Single-attempt V2A video analysis failed.",
        )
        self.assertTrue(upload.file.closed)
        self.assertEqual(set(UPLOAD_DIRECTORY.iterdir()), existing_uploads)

    def test_uses_only_the_reviewed_source_frame_and_cleans_upload(self) -> None:
        existing_uploads = set(UPLOAD_DIRECTORY.iterdir())
        engine = _SelectedFramePoseEngine()
        app.state.pose_engine = engine
        upload = _upload()

        with patch(
            "ai_engine.main._read_video_sampling_metadata",
            return_value=(25.0, 100),
        ):
            response = asyncio.run(
                analyze_single_attempt_v2a_video(
                    video=upload,
                    review_json=_review_json(),
                )
            )

        self.assertEqual(engine.sampling_plan.frame_indices, (50,))
        self.assertEqual(engine.sampling_plan.timestamps_ms, (2000,))
        self.assertEqual(
            engine.sampling_plan.strategy,
            "human_selected_source_frame",
        )
        self.assertEqual(engine.target_fps, 25.0)
        self.assertEqual(response.metrics[0].status.value, "reportable")
        self.assertEqual(response.metrics[1].status.value, "reportable")
        self.assertEqual(response.metrics[2].status.value, "reportable")
        self.assertTrue(upload.file.closed)
        self.assertEqual(set(UPLOAD_DIRECTORY.iterdir()), existing_uploads)

    def test_missing_selected_pose_withholds_angles_without_failing_duration(
        self,
    ) -> None:
        engine = _SelectedFramePoseEngine(include_pose=False)
        app.state.pose_engine = engine

        with patch(
            "ai_engine.main._read_video_sampling_metadata",
            return_value=(25.0, 100),
        ):
            response = asyncio.run(
                analyze_single_attempt_v2a_video(
                    video=_upload(),
                    review_json=_review_json(),
                )
            )

        self.assertEqual(response.metrics[0].status.value, "reportable")
        self.assertEqual(response.metrics[1].status.value, "withheld")
        self.assertEqual(response.metrics[2].status.value, "withheld")

    def test_timestamp_mismatch_is_rejected_and_upload_is_cleaned(self) -> None:
        existing_uploads = set(UPLOAD_DIRECTORY.iterdir())
        upload = _upload()

        with patch(
            "ai_engine.main._read_video_sampling_metadata",
            return_value=(25.0, 100),
        ):
            with self.assertRaises(HTTPException) as raised:
                asyncio.run(
                    analyze_single_attempt_v2a_video(
                        video=upload,
                        review_json=_review_json(timestamp_ms=2040),
                    )
                )

        self.assertEqual(raised.exception.status_code, 400)
        self.assertIn("source video timebase", raised.exception.detail)
        self.assertTrue(upload.file.closed)
        self.assertEqual(set(UPLOAD_DIRECTORY.iterdir()), existing_uploads)

    def test_rejects_client_supplied_pose_observation(self) -> None:
        payload = json.loads(_review_json())
        payload["pose_observation"] = {
            "frame": {"frame_index": 50, "timestamp_ms": 2000},
            "neutral_track_id": "Track A",
            "detection_index": 0,
            "image_width": 640,
            "image_height": 360,
            "coordinate_space": "normalized_image",
            "provenance": "model-estimated",
            "landmarks": {},
        }

        with self.assertRaises(HTTPException) as raised:
            asyncio.run(
                analyze_single_attempt_v2a_video(
                    video=_upload(),
                    review_json=json.dumps(payload),
                )
            )

        self.assertEqual(raised.exception.status_code, 400)
        self.assertIn("derives pose observations internally", raised.exception.detail)
