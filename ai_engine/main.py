from __future__ import annotations

from contextlib import asynccontextmanager
from pathlib import Path
from uuid import uuid4
import shutil

from fastapi import (
    FastAPI,
    File,
    Form,
    HTTPException,
    UploadFile,
)
from fastapi.concurrency import run_in_threadpool
from pydantic import BaseModel

from ai_engine.pose_engine import JudoPoseEngine
from ai_engine.contracts.single_camera_pose_summary import (
    PoseCoverageSummary,
    PoseEngineMetadata,
    SINGLE_CAMERA_POSE_LIMITATIONS,
    SingleCameraPoseSummaryResponse,
    TechniqueReference,
    VideoMetadata,
)


ENGINE_ROOT = Path(__file__).resolve().parent

UPLOAD_DIRECTORY = (
    ENGINE_ROOT
    / "runtime"
    / "uploads"
)

UPLOAD_DIRECTORY.mkdir(
    parents=True,
    exist_ok=True,
)

SUPPORTED_VIDEO_SUFFIXES = {
    ".avi",
    ".m4v",
    ".mkv",
    ".mov",
    ".mp4",
    ".webm",
}


class HealthResponse(BaseModel):
    status: str
    service: str
    version: str


@asynccontextmanager
async def lifespan(app: FastAPI):
    pose_engine = JudoPoseEngine()

    app.state.pose_engine = pose_engine

    print(
        "Judo Mind Pose Engine initialized."
    )

    try:
        yield
    finally:
        pose_engine.close()

        print(
            "Judo Mind Pose Engine closed."
        )


app = FastAPI(
    title=(
        "Judo Mind AI Fight "
        "Intelligence 360"
    ),
    version="0.2.0",
    description=(
        "Biomechanical and technical "
        "video analysis engine for the "
        "Judo Mind Super App."
    ),
    lifespan=lifespan,
)


@app.get(
    "/",
    response_model=HealthResponse,
)
def root() -> HealthResponse:
    return HealthResponse(
        status="online",
        service=(
            "Judo Mind AI Fight "
            "Intelligence 360"
        ),
        version="0.2.0",
    )


@app.get(
    "/health",
    response_model=HealthResponse,
)
def health() -> HealthResponse:
    return HealthResponse(
        status="healthy",
        service=(
            "Judo Mind AI Fight "
            "Intelligence 360"
        ),
        version="0.2.0",
    )


def _is_supported_video(
    video: UploadFile,
) -> bool:
    content_type = video.content_type or ""
    suffix = Path(video.filename or "").suffix.lower()

    return content_type.startswith("video/") or (
        content_type in {"", "application/octet-stream"}
        and suffix in SUPPORTED_VIDEO_SUFFIXES
    )


@app.post(
    "/v1/analysis/single-camera/pose-summary",
    response_model=SingleCameraPoseSummaryResponse,
)
async def analyze_single_camera_pose_summary(
    video: UploadFile = File(...),
    technique_id: str = Form(...),
    camera_view: str = Form("unknown"),
) -> SingleCameraPoseSummaryResponse:
    """Return a scientifically bounded single-camera pose diagnostic."""

    if not _is_supported_video(video):
        raise HTTPException(
            status_code=400,
            detail="Uploaded file must be a supported video.",
        )

    normalized_technique_id = technique_id.strip()

    if not normalized_technique_id:
        raise HTTPException(
            status_code=400,
            detail="technique_id must not be empty.",
        )

    suffix = Path(video.filename or "video.mp4").suffix.lower()

    if suffix not in SUPPORTED_VIDEO_SUFFIXES:
        suffix = ".mp4"

    upload_path = UPLOAD_DIRECTORY / f"{uuid4().hex}{suffix}"

    try:
        with upload_path.open("wb") as buffer:
            shutil.copyfileobj(video.file, buffer)

        engine: JudoPoseEngine = app.state.pose_engine
        target_fps = 10.0
        result = await run_in_threadpool(
            engine.analyze_video,
            upload_path,
            target_fps,
        )
        raw_video = result["video"]
        raw_analysis = result["analysis"]

        return SingleCameraPoseSummaryResponse(
            analysis_id=uuid4().hex,
            technique=TechniqueReference(
                id=normalized_technique_id,
            ),
            camera_view=camera_view.strip() or "unknown",
            engine=PoseEngineMetadata(
                id="mediapipe_pose_landmarker_heavy",
                display_name="MediaPipe Pose Landmarker Heavy",
                target_fps=target_fps,
            ),
            video=VideoMetadata(
                filename=video.filename or "video.mp4",
                width=raw_video["width"],
                height=raw_video["height"],
                source_fps=raw_video["source_fps"],
                frame_count=raw_video["frame_count"],
                duration_seconds=raw_video["duration_seconds"],
            ),
            pose_coverage=PoseCoverageSummary(
                analyzed_frame_count=(
                    raw_analysis["analyzed_frame_count"]
                ),
                frames_with_at_least_one_pose=(
                    raw_analysis["frames_with_pose"]
                ),
                frames_with_two_poses=(
                    raw_analysis["frames_with_two_poses"]
                ),
                at_least_one_pose_rate=(
                    raw_analysis["single_or_multi_pose_rate"]
                ),
                two_pose_rate=(
                    raw_analysis["two_pose_detection_rate"]
                ),
            ),
            limitations=SINGLE_CAMERA_POSE_LIMITATIONS,
        )
    except HTTPException:
        raise
    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail="Single-camera pose analysis failed.",
        ) from error
    finally:
        await video.close()

        if upload_path.exists():
            upload_path.unlink()


@app.post("/analysis/pose")
async def analyze_pose(
    video: UploadFile = File(...),
):
    content_type = (
        video.content_type or ""
    )

    if not content_type.startswith(
        "video/"
    ):
        raise HTTPException(
            status_code=400,
            detail=(
                "Uploaded file must "
                "be a video."
            ),
        )

    suffix = Path(
        video.filename or "video.mp4"
    ).suffix

    if not suffix:
        suffix = ".mp4"

    upload_path = (
        UPLOAD_DIRECTORY
        / f"{uuid4().hex}{suffix}"
    )

    try:
        with upload_path.open("wb") as buffer:
            shutil.copyfileobj(
                video.file,
                buffer,
            )

        engine: JudoPoseEngine = (
            app.state.pose_engine
        )

        result = await run_in_threadpool(
            engine.analyze_video,
            upload_path,
            10.0,
        )

        return {
            "status": "completed",
            "filename": video.filename,
            "video": result["video"],
            "pose_analysis": (
                result["analysis"]
            ),
        }

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error),
        ) from error

    finally:
        await video.close()

        if upload_path.exists():
            upload_path.unlink()
