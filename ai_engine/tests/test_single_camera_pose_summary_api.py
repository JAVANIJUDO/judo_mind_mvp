from __future__ import annotations

import asyncio
from io import BytesIO
import json
from pathlib import Path
from unittest import TestCase

from fastapi import HTTPException
from starlette.datastructures import Headers, UploadFile

from ai_engine.main import (
    UPLOAD_DIRECTORY,
    analyze_single_camera_pose_summary,
    app,
)


class _FakePoseEngine:
    def close(self) -> None:
        return None

    def analyze_video(
        self,
        video_path: str | Path,
        target_fps: float,
    ) -> dict:
        path = Path(video_path)
        if not path.exists():
            raise AssertionError("Temporary upload was not created.")
        if target_fps != 10.0:
            raise AssertionError("Unexpected sampling rate.")

        return {
            "video": {
                "path": str(path),
                "width": 1920,
                "height": 1080,
                "source_fps": 30.0,
                "frame_count": 90,
                "duration_seconds": 3.0,
            },
            "analysis": {
                "target_fps": target_fps,
                "sample_stride": 3,
                "analyzed_frame_count": 30,
                "frames_with_pose": 27,
                "frames_with_two_poses": 21,
                "single_or_multi_pose_rate": 0.9,
                "two_pose_detection_rate": 0.7,
            },
            "frames": [],
        }


class SingleCameraPoseSummaryApiTest(TestCase):
    def test_returns_bounded_versioned_summary_and_cleans_upload(self) -> None:
        existing_uploads = set(UPLOAD_DIRECTORY.iterdir())
        app.state.pose_engine = _FakePoseEngine()
        upload = UploadFile(
            filename="uchi-mata.mp4",
            file=BytesIO(b"not-a-real-video"),
            headers=Headers({"content-type": "video/mp4"}),
        )

        response = asyncio.run(
            analyze_single_camera_pose_summary(
                video=upload,
                technique_id="uchi-mata",
                camera_view="side",
            )
        )
        payload = json.loads(response.model_dump_json())
        self.assertEqual(payload["schema_version"], "1.0.0")
        self.assertEqual(payload["analysis_mode"], "single_camera_2d")
        self.assertEqual(payload["video"]["provenance"], "measured")
        self.assertEqual(
            payload["pose_coverage"]["provenance"],
            "model-estimated",
        )
        self.assertFalse(payload["pose_coverage"]["confidence_available"])
        self.assertFalse(payload["capabilities"]["athlete_identity"])
        self.assertFalse(payload["capabilities"]["phase_detection"])
        self.assertFalse(
            payload["capabilities"]["three_dimensional_reconstruction"]
        )
        self.assertFalse(payload["capabilities"]["force_or_torque"])
        self.assertEqual(
            {item["code"] for item in payload["limitations"]},
            {
                "pose_identity_not_available",
                "phase_detection_not_available",
                "single_camera_2d_only",
                "force_torque_not_available",
                "experimental_pose_baseline",
            },
        )
        self.assertEqual(set(UPLOAD_DIRECTORY.iterdir()), existing_uploads)

    def test_rejects_non_video_upload(self) -> None:
        upload = UploadFile(
            filename="notes.txt",
            file=BytesIO(b"not a video"),
            headers=Headers({"content-type": "text/plain"}),
        )

        with self.assertRaises(HTTPException) as raised:
            asyncio.run(
                analyze_single_camera_pose_summary(
                    video=upload,
                    technique_id="uchi-mata",
                    camera_view="unknown",
                )
            )

        self.assertEqual(raised.exception.status_code, 400)
