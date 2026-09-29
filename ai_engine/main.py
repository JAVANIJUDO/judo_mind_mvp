from __future__ import annotations

from contextlib import asynccontextmanager
from dataclasses import replace
from pathlib import Path
from uuid import uuid4
import base64
import json
import math
import shutil

import cv2
from fastapi import (
    FastAPI,
    File,
    Form,
    HTTPException,
    UploadFile,
)
from fastapi.concurrency import run_in_threadpool
from pydantic import BaseModel
from pydantic import ValidationError

from ai_engine.pose_engine import JudoPoseEngine
from ai_engine.contracts.single_attempt_analysis_v2a import (
    FrameReference,
    SingleAttemptAnalysisRequest,
    SingleAttemptAnalysisResponse,
)
from ai_engine.contracts.guided_single_attempt_review import (
    GuidedBoundaryPreviewInput,
    GuidedBoundaryPreviewResponse,
    GuidedTimingManifestInput,
    GuidedTimingManifestResponse,
    GuidedReviewCandidate,
    GuidedReviewConfirmInput,
    GuidedReviewPrepareInput,
    GuidedReviewPrepareResponse,
)
from ai_engine.contracts.single_camera_pose_summary import (
    PoseCoverageSummary,
    PoseEngineMetadata,
    SINGLE_CAMERA_POSE_LIMITATIONS,
    SingleCameraPoseSummaryResponse,
    TechniqueReference,
    VideoMetadata,
)
from ai_engine.single_attempt.analysis import analyze_single_attempt
from ai_engine.single_attempt.pose_observation_adapter import (
    mediapipe_frame_pose_to_candidate,
    mediapipe_frame_pose_to_observation,
)
from ai_engine.single_attempt.guided_review_session import (
    GuidedReviewSessionStore,
    ReviewSessionError,
    ReviewSessionExpired,
    ReviewSessionInsufficientCandidateEvidence,
)
from ai_engine.single_attempt.timing_manifest import (
    TIMING_METHOD_VERSION,
    TimingManifestError,
    TimingManifestExpired,
    TimingManifestStore,
    decode_timing_manifest,
    file_sha256,
)
from ai_engine.video_sampling import (
    build_bounded_review_context_plan,
    build_human_selected_frame_plan,
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

GUIDED_REVIEW_STORE = GuidedReviewSessionStore()
TIMING_MANIFEST_STORE = TimingManifestStore()
GUIDED_REVIEW_LIMITATIONS = [
    "Candidate selection is human-confirmed; athlete identity is not inferred.",
    "Candidates are frame-local and do not establish identity across time.",
    (
        "Detected pose count is model-returned poses in the selected frame; "
        "it does not establish how many people or judoka are present."
    ),
    "Track metadata and association confidence are unavailable in D2.",
    "Single-camera pose geometry is model-estimated 2D evidence, not 3D.",
]


class HealthResponse(BaseModel):
    status: str
    service: str
    version: str


@asynccontextmanager
async def lifespan(app: FastAPI):
    pose_engine = JudoPoseEngine()

    app.state.pose_engine = pose_engine
    app.state.guided_review_store = GUIDED_REVIEW_STORE
    app.state.timing_manifest_store = TIMING_MANIFEST_STORE

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


def analyze_single_attempt_v2a(
    request: SingleAttemptAnalysisRequest,
) -> SingleAttemptAnalysisResponse:
    """Internal pure evaluation for one selected 2D observation.

    This endpoint intentionally does not infer roles, phases or support leg.
    The public video route derives the pose observation inside the AI Engine.
    """

    return analyze_single_attempt(request)


def _is_supported_video(
    video: UploadFile,
) -> bool:
    content_type = video.content_type or ""
    suffix = Path(video.filename or "").suffix.lower()

    return content_type.startswith("video/") or (
        content_type in {"", "application/octet-stream"}
        and suffix in SUPPORTED_VIDEO_SUFFIXES
    )


def _read_video_sampling_metadata(video_path: Path) -> tuple[float, int]:
    capture = cv2.VideoCapture(str(video_path))
    if not capture.isOpened():
        raise ValueError("Uploaded video could not be opened.")

    try:
        source_fps = float(capture.get(cv2.CAP_PROP_FPS))
        if not math.isfinite(source_fps) or source_fps <= 0:
            raise ValueError(
                "Source FPS is unavailable; V2A will not assume a frame rate."
            )
        frame_count = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))
    finally:
        capture.release()

    if frame_count < 1:
        raise ValueError("Uploaded video has no decodable source frames.")

    return source_fps, frame_count


def _canonical_frame_reference(
    position_ms: int,
    *,
    source_fps: float,
    frame_count: int,
) -> FrameReference:
    duration_ceiling_ms = math.ceil(frame_count * 1000.0 / source_fps)
    if position_ms < 0 or position_ms > duration_ceiling_ms:
        raise ValueError("Selected position is outside the source video.")
    frame_index = min(
        frame_count - 1,
        int(math.floor(position_ms * source_fps / 1000.0 + 0.5)),
    )
    plan = build_human_selected_frame_plan(
        source_fps=source_fps,
        frame_count=frame_count,
        frame_index=frame_index,
    )
    return FrameReference(
        frame_index=frame_index,
        timestamp_ms=plan.timestamps_ms[0],
    )


def _candidate_preview_jpegs(
    video_path: Path,
    *,
    frame_index: int,
    frame_result: dict[str, object],
) -> list[str | None]:
    capture = cv2.VideoCapture(str(video_path))
    if not capture.isOpened():
        raise ValueError("Selected review frame could not be opened.")
    try:
        capture.set(cv2.CAP_PROP_POS_FRAMES, frame_index)
        ok, image = capture.read()
    finally:
        capture.release()
    if not ok or image is None:
        raise ValueError("Selected review frame could not be decoded.")

    poses = frame_result.get("poses")
    if not isinstance(poses, list):
        raise ValueError("Pose engine returned invalid review candidates.")
    height, width = image.shape[:2]
    previews: list[str | None] = []
    for selected_pose in poses:
        if not isinstance(selected_pose, dict):
            previews.append(None)
            continue
        landmarks = selected_pose.get("landmarks")
        if not isinstance(landmarks, list) or not landmarks:
            previews.append(None)
            continue
        points = []
        for point in landmarks:
            if not isinstance(point, dict) or "x" not in point or "y" not in point:
                continue
            try:
                x = float(point["x"])
                y = float(point["y"])
            except (TypeError, ValueError):
                continue
            if math.isfinite(x) and math.isfinite(y):
                points.append((x, y))
        if not points:
            previews.append(None)
            continue
        x_values = [point[0] for point in points]
        y_values = [point[1] for point in points]
        left = max(0, int(min(x_values) * width) - 12)
        right = min(width - 1, int(max(x_values) * width) + 12)
        top = max(0, int(min(y_values) * height) - 12)
        bottom = min(height - 1, int(max(y_values) * height) + 12)
        annotated = image.copy()
        cv2.rectangle(annotated, (left, top), (right, bottom), (255, 90, 0), 5)
        encoded_ok, encoded = cv2.imencode(".jpg", annotated)
        if not encoded_ok:
            previews.append(None)
            continue
        previews.append(base64.b64encode(encoded.tobytes()).decode("ascii"))
    return previews


def _guided_review_store() -> GuidedReviewSessionStore:
    return getattr(app.state, "guided_review_store", GUIDED_REVIEW_STORE)


def _timing_manifest_store() -> TimingManifestStore:
    return getattr(app.state, "timing_manifest_store", TIMING_MANIFEST_STORE)


def _decoded_frame_preview(video_path: Path, frame_index: int) -> str:
    capture = cv2.VideoCapture(str(video_path))
    if not capture.isOpened():
        raise TimingManifestError("Boundary preview video could not be opened.")
    try:
        capture.set(cv2.CAP_PROP_POS_FRAMES, frame_index)
        ok, image = capture.read()
    finally:
        capture.release()
    if not ok or image is None:
        raise TimingManifestError("Boundary frame could not be decoded.")
    encoded_ok, encoded = cv2.imencode(".jpg", image)
    if not encoded_ok:
        raise TimingManifestError("Boundary preview could not be encoded.")
    return base64.b64encode(encoded.tobytes()).decode("ascii")


@app.post(
    "/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/timing-manifest",
    response_model=GuidedTimingManifestResponse,
)
async def prepare_guided_timing_manifest(
    video: UploadFile = File(...),
    timing_json: str = Form(...),
) -> GuidedTimingManifestResponse:
    """Decode a bounded server-owned timeline without running pose inference."""
    upload_path: Path | None = None
    try:
        if not _is_supported_video(video):
            raise HTTPException(400, "Uploaded file must be a supported video.")
        try:
            request = GuidedTimingManifestInput.model_validate_json(timing_json)
        except ValidationError as error:
            raise HTTPException(400, "timing_json does not satisfy the timing contract.") from error
        suffix = Path(video.filename or "video.mp4").suffix.lower()
        if suffix not in SUPPORTED_VIDEO_SUFFIXES:
            suffix = ".mp4"
        upload_path = UPLOAD_DIRECTORY / f"{uuid4().hex}{suffix}"
        with upload_path.open("wb") as buffer:
            shutil.copyfileobj(video.file, buffer)
        frames, mode, duration_ms, fps, provenance = await run_in_threadpool(
            decode_timing_manifest, upload_path
        )
        digest = await run_in_threadpool(file_sha256, upload_path)
        manifest = _timing_manifest_store().create(
            video_id=request.video_id,
            video_sha256=digest,
            frames=frames,
            timing_mode=mode,
            duration_ms=duration_ms,
            source_fps=fps,
            timestamp_provenance=provenance,
            source_timing_state=request.source_timing_state,
            physical_time_scale=request.physical_time_scale,
        )
        return GuidedTimingManifestResponse(
            timing_manifest_id=manifest.manifest_id,
            expires_in_seconds=_timing_manifest_store().ttl_seconds,
            total_decoded_frames=len(manifest.frames),
            frame_timestamps_ms=[frame.timestamp_ms for frame in manifest.frames],
            timing_mode=manifest.timing_mode.value,
            duration_ms=manifest.duration_ms,
            source_fps=manifest.source_fps,
            timestamp_provenance=manifest.timestamp_provenance,
            source_timing_state=manifest.source_timing_state,
            physical_time_scale=manifest.physical_time_scale,
            limitations=[
                "Frame indexes are server-owned decoded-frame references.",
                "Decoder-reported timestamps are not represented as raw container PTS.",
                "Source timing state is human-declared; slow motion is not inferred.",
            ],
        )
    except HTTPException:
        raise
    except TimingManifestError as error:
        raise HTTPException(400, str(error)) from error
    finally:
        await video.close()
        if upload_path is not None and upload_path.exists():
            upload_path.unlink()


@app.post(
    "/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/boundary-preview",
    response_model=GuidedBoundaryPreviewResponse,
)
async def preview_guided_attempt_boundaries(
    video: UploadFile = File(...),
    selection_json: str = Form(...),
) -> GuidedBoundaryPreviewResponse:
    """Return exact decoded start/end images before human confirmation."""
    upload_path: Path | None = None
    try:
        if not _is_supported_video(video):
            raise HTTPException(400, "Uploaded file must be a supported video.")
        try:
            request = GuidedBoundaryPreviewInput.model_validate_json(selection_json)
        except ValidationError as error:
            raise HTTPException(400, "selection_json does not satisfy boundary review.") from error
        suffix = Path(video.filename or "video.mp4").suffix.lower()
        if suffix not in SUPPORTED_VIDEO_SUFFIXES:
            suffix = ".mp4"
        upload_path = UPLOAD_DIRECTORY / f"{uuid4().hex}{suffix}"
        with upload_path.open("wb") as buffer:
            shutil.copyfileobj(video.file, buffer)
        digest = await run_in_threadpool(file_sha256, upload_path)
        manifest = _timing_manifest_store().resolve(
            request.timing_manifest_id,
            video_id=request.video_id,
            video_sha256=digest,
        )
        start = manifest.frame(request.attempt_start_frame)
        end = manifest.frame(request.attempt_end_frame)
        manifest.frame(request.review_frame)
        start_preview = await run_in_threadpool(
            _decoded_frame_preview, upload_path, start.frame_index
        )
        end_preview = await run_in_threadpool(
            _decoded_frame_preview, upload_path, end.frame_index
        )
        return GuidedBoundaryPreviewResponse(
            timing_manifest_id=manifest.manifest_id,
            start_frame=start.frame_index,
            end_frame=end.frame_index,
            review_frame=request.review_frame,
            start_timestamp_ms=start.timestamp_ms,
            end_timestamp_ms=end.timestamp_ms,
            start_preview_jpeg_base64=start_preview,
            end_preview_jpeg_base64=end_preview,
        )
    except HTTPException:
        raise
    except TimingManifestExpired as error:
        raise HTTPException(410, str(error)) from error
    except TimingManifestError as error:
        raise HTTPException(400, str(error)) from error
    finally:
        await video.close()
        if upload_path is not None and upload_path.exists():
            upload_path.unlink()


@app.post(
    "/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/prepare",
    response_model=GuidedReviewPrepareResponse,
)
async def prepare_guided_single_attempt_review(
    video: UploadFile = File(...),
    selection_json: str = Form(...),
) -> GuidedReviewPrepareResponse:
    """Prepare frame-local candidates; no athlete identity is inferred."""
    upload_path: Path | None = None
    try:
        if not _is_supported_video(video):
            raise HTTPException(400, "Uploaded file must be a supported video.")
        try:
            selection = GuidedReviewPrepareInput.model_validate_json(selection_json)
        except ValidationError as error:
            raise HTTPException(
                400, "selection_json does not satisfy the guided review contract."
            ) from error

        suffix = Path(video.filename or "video.mp4").suffix.lower()
        if suffix not in SUPPORTED_VIDEO_SUFFIXES:
            suffix = ".mp4"
        upload_path = UPLOAD_DIRECTORY / f"{uuid4().hex}{suffix}"
        with upload_path.open("wb") as buffer:
            shutil.copyfileobj(video.file, buffer)

        digest = await run_in_threadpool(file_sha256, upload_path)
        try:
            manifest = _timing_manifest_store().resolve(
                selection.timing_manifest_id,
                video_id=selection.video_id,
                video_sha256=digest,
            )
        except TimingManifestExpired as error:
            raise HTTPException(410, str(error)) from error
        except TimingManifestError as error:
            raise HTTPException(400, str(error)) from error

        def reference(frame_index: int) -> FrameReference:
            timing = manifest.frame(frame_index)
            true_pts = (
                int(round(timing.decoder_timestamp_ms))
                if manifest.timestamp_provenance == "decoder-reported-timestamp"
                and timing.decoder_timestamp_ms is not None
                else None
            )
            return FrameReference(
                frame_index=timing.frame_index,
                timestamp_ms=timing.timestamp_ms,
                pts_ms=true_pts,
                timing_provenance=manifest.timestamp_provenance,
                timing_manifest_id=manifest.manifest_id,
                video_id=manifest.video_id,
                canonicalization_method_version=TIMING_METHOD_VERSION,
            )

        start = reference(selection.attempt_start_frame)
        end = reference(selection.attempt_end_frame)
        review_frame = reference(selection.review_frame)
        if end.frame_index <= start.frame_index:
            raise HTTPException(400, "Attempt end frame must follow start frame.")
        if not start.frame_index <= review_frame.frame_index <= end.frame_index:
            raise HTTPException(400, "Review frame must be inside the confirmed attempt.")

        source_fps = manifest.source_fps
        frame_count = len(manifest.frames)
        if source_fps is None:
            raise HTTPException(422, "Pose sampling FPS is unavailable for this source.")

        plan = build_bounded_review_context_plan(
            source_fps=source_fps,
            frame_count=frame_count,
            attempt_start_frame=start.frame_index,
            review_frame=review_frame.frame_index,
        )
        engine: JudoPoseEngine = app.state.pose_engine
        result = await run_in_threadpool(
            engine.analyze_video,
            upload_path,
            source_fps,
            sampling_plan=plan,
            isolate_video_context=True,
        )
        frames = result.get("frames", [])
        video_metadata = result.get("video", {})
        if not isinstance(frames, list):
            raise HTTPException(422, "Selected review frame is unavailable.")
        review_frame_results = [
            frame
            for frame in frames
            if isinstance(frame, dict)
            and frame.get("frame_index") == review_frame.frame_index
        ]
        if len(review_frame_results) != 1:
            raise HTTPException(422, "Selected review frame is unavailable.")
        frame_result = review_frame_results[0]
        poses = frame_result.get("poses", [])
        if not isinstance(poses, list):
            raise HTTPException(422, "Model-returned pose evidence is unavailable.")
        width = video_metadata.get("width")
        height = video_metadata.get("height")
        if not isinstance(width, int) or width <= 0 or not isinstance(height, int) or height <= 0:
            raise RuntimeError("Pose engine did not return valid image dimensions.")

        previews = _candidate_preview_jpegs(
            upload_path, frame_index=review_frame.frame_index, frame_result=frame_result
        )
        candidate_poses = []
        candidate_evidence = []
        valid_indices = [
            pose.get("pose_index")
            for pose in poses
            if isinstance(pose, dict)
            and isinstance(pose.get("pose_index"), int)
            and not isinstance(pose.get("pose_index"), bool)
        ]
        for pose, preview in zip(poses, previews, strict=True):
            if not isinstance(pose, dict) or preview is None:
                continue
            detection_index = pose.get("pose_index")
            if (
                not isinstance(detection_index, int)
                or isinstance(detection_index, bool)
                or valid_indices.count(detection_index) != 1
            ):
                continue
            try:
                candidate_pose = mediapipe_frame_pose_to_candidate(
                    frame_result,
                    detection_index=detection_index,
                    image_width=width,
                    image_height=height,
                )
            except ValueError:
                continue
            candidate_pose = replace(candidate_pose, frame=review_frame)
            visibility_count = candidate_pose.model_landmark_visibility_count
            required_count = candidate_pose.required_landmark_count
            visibility_status = (
                "unavailable"
                if visibility_count == 0
                else "available"
                if visibility_count == required_count
                else "partial"
            )
            candidate_poses.append(candidate_pose)
            candidate_evidence.append(
                (preview, required_count, visibility_count, visibility_status)
            )
        session = _guided_review_store().create(
            video_id=selection.video_id,
            camera_view=selection.camera_view,
            attempt_start=start,
            attempt_end=end,
            review_frame=review_frame,
            source_timing={
                "state": manifest.source_timing_state.value,
                "timing_mode": manifest.timing_mode.value,
                "timestamp_provenance": manifest.timestamp_provenance,
                "physical_time_scale": manifest.physical_time_scale,
            },
            attempt_scope={
                "single_attempt_confirmed": selection.single_attempt_confirmed,
                "attempt_scope": selection.attempt_scope,
                "attempt_scope_source": selection.attempt_scope_source,
                "attempt_scope_contract_version": (
                    selection.attempt_scope_contract_version
                ),
            },
            detected_pose_count=len(poses),
            candidate_poses=candidate_poses,
        )
        # Keep the server-owned manifest available for bounded human boundary
        # edits. It remains video/hash-bound and expires through the manifest
        # store TTL; each PREPARE still creates a fresh review session.
        candidates = [
            GuidedReviewCandidate(
                candidate_token=token,
                preview_jpeg_base64=evidence[0],
                required_landmark_count=evidence[1],
                available_required_landmark_count=evidence[1],
                model_landmark_visibility_count=evidence[2],
                model_landmark_visibility_status=evidence[3],
            )
            for token, evidence in zip(
                session.candidates, candidate_evidence, strict=True
            )
        ]
        return GuidedReviewPrepareResponse(
            review_session_id=session.session_id,
            expires_in_seconds=_guided_review_store().ttl_seconds,
            canonical_start_ms=start.timestamp_ms,
            canonical_end_ms=end.timestamp_ms,
            canonical_review_moment_ms=review_frame.timestamp_ms,
            canonical_start_frame=start.frame_index,
            canonical_end_frame=end.frame_index,
            canonical_review_frame=review_frame.frame_index,
            timing_mode=manifest.timing_mode.value,
            timestamp_provenance=manifest.timestamp_provenance,
            source_timing_state=manifest.source_timing_state,
            physical_time_scale=manifest.physical_time_scale,
            single_attempt_confirmed=True,
            attempt_scope="SINGLE_ATTEMPT",
            attempt_scope_source="HUMAN_CONFIRMED",
            attempt_scope_contract_version=(
                "single-attempt-human-confirmation-1.0.0"
            ),
            detected_pose_count=session.detected_pose_count,
            selectable_candidate_count=session.selectable_candidate_count,
            candidate_selection_status=session.candidate_selection_status,
            candidates=candidates,
            limitations=GUIDED_REVIEW_LIMITATIONS,
        )
    except HTTPException:
        raise
    except ValueError as error:
        raise HTTPException(400, str(error)) from error
    except Exception as error:
        raise HTTPException(500, "Guided review preparation failed.") from error
    finally:
        await video.close()
        if upload_path is not None and upload_path.exists():
            upload_path.unlink()


@app.post(
    "/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/analyze",
    response_model=SingleAttemptAnalysisResponse,
)
def analyze_guided_single_attempt_review(
    confirmation: GuidedReviewConfirmInput,
) -> SingleAttemptAnalysisResponse:
    store = _guided_review_store()
    try:
        session, candidate_pose = store.resolve(
            confirmation.review_session_id,
            confirmation.role_assignment.candidate_token,
        )
    except ReviewSessionExpired as error:
        raise HTTPException(410, str(error)) from error
    except ReviewSessionInsufficientCandidateEvidence as error:
        raise HTTPException(422, str(error)) from error
    except ReviewSessionError as error:
        raise HTTPException(400, str(error)) from error

    if not confirmation.tori_confirmed:
        store.discard(session.session_id)
        raise HTTPException(422, "Explicit human Tori confirmation is required.")
    if confirmation.reviewer_uncertain:
        store.discard(session.session_id)
        raise HTTPException(422, "Uncertain athlete review cannot be analyzed.")

    observation = candidate_pose.to_human_confirmed_observation(
        neutral_track_id="Track A"
    )

    payload = {
        "schema_version": "2.0.0",
        "analysis_variant": "single_attempt_v2a",
        "video_id": session.video_id,
        "technique": {"id": "uchi-mata"},
        "camera_view": session.camera_view,
        "attempt": {
            "start": session.attempt_start.model_dump(),
            "end": session.attempt_end.model_dump(),
            "event_schema_id": "human-single-attempt-boundaries-v1",
            "selection_source": "human-selected",
            "boundaries_human_confirmed": True,
            "source_timing": session.source_timing,
            **session.attempt_scope,
        },
        "subject": {
            "neutral_track_id": "Track A",
            "selected_detection_index": observation.detection_index,
            "role": "Tori",
            "confirmation_source": "human-confirmed",
        },
        "support_leg": {
            "side": confirmation.support_leg.value,
            "confirmation_source": "human-confirmed",
        },
        "attacking_leg": {
            "side": confirmation.attacking_leg.value,
            "confirmation_source": "human-confirmed",
        },
        "angle_frame": {
            "frame": session.review_frame.model_dump(),
            "selection_source": "human-selected",
            "event_label": "user-selected-review-moment",
        },
        "camera_suitability": {
            "projected_angle_view_suitable": confirmation.projected_angle_view_suitable,
            "low_roll_confirmed": confirmation.low_roll_confirmed,
            "review_source": "human-reviewed",
        },
        "pose_observation": observation.model_dump(mode="json"),
    }
    try:
        request = SingleAttemptAnalysisRequest.model_validate(payload)
        return analyze_single_attempt(request)
    finally:
        store.discard(session.session_id)


@app.post(
    "/v2a/analysis/single-camera/uchi-mata/single-attempt/video",
    response_model=SingleAttemptAnalysisResponse,
)
async def analyze_single_attempt_v2a_video(
    video: UploadFile = File(...),
    review_json: str = Form(...),
) -> SingleAttemptAnalysisResponse:
    """Evaluate one reviewed source frame without benchmark-rate sampling."""

    upload_path: Path | None = None

    try:
        if not _is_supported_video(video):
            raise HTTPException(
                status_code=400,
                detail="Uploaded file must be a supported video.",
            )

        try:
            review_payload = json.loads(review_json)
            review = SingleAttemptAnalysisRequest.model_validate(review_payload)
        except (json.JSONDecodeError, ValidationError, TypeError) as error:
            raise HTTPException(
                status_code=400,
                detail="review_json does not satisfy the V2A contract.",
            ) from error

        if review.pose_observation is not None:
            raise HTTPException(
                status_code=400,
                detail=(
                    "The video route derives pose observations internally; "
                    "review_json must not provide one."
                ),
            )

        suffix = Path(video.filename or "video.mp4").suffix.lower()
        if suffix not in SUPPORTED_VIDEO_SUFFIXES:
            suffix = ".mp4"
        upload_path = UPLOAD_DIRECTORY / f"{uuid4().hex}{suffix}"

        with upload_path.open("wb") as buffer:
            shutil.copyfileobj(video.file, buffer)

        source_fps, frame_count = _read_video_sampling_metadata(upload_path)
        reviewed_references = (
            review.attempt.start,
            review.attempt.end,
            review.angle_frame.frame,
        )
        plans_by_frame = {
            reference.frame_index: build_human_selected_frame_plan(
                source_fps=source_fps,
                frame_count=frame_count,
                frame_index=reference.frame_index,
            )
            for reference in reviewed_references
        }
        for reference in reviewed_references:
            measured_timestamp_ms = plans_by_frame[
                reference.frame_index
            ].timestamps_ms[0]
            if measured_timestamp_ms != reference.timestamp_ms:
                raise HTTPException(
                    status_code=400,
                    detail=(
                        "Reviewed frame timestamps do not match the source "
                        "video timebase."
                    ),
                )

        sampling_plan = plans_by_frame[review.angle_frame.frame.frame_index]

        engine: JudoPoseEngine = app.state.pose_engine
        result = await run_in_threadpool(
            engine.analyze_video,
            upload_path,
            source_fps,
            sampling_plan=sampling_plan,
        )
        frames = result.get("frames", [])
        analyzed_video = result.get("video", {})
        image_width = analyzed_video.get("width")
        image_height = analyzed_video.get("height")
        if (
            not isinstance(image_width, int)
            or isinstance(image_width, bool)
            or image_width <= 0
            or not isinstance(image_height, int)
            or isinstance(image_height, bool)
            or image_height <= 0
        ):
            raise RuntimeError("Pose engine did not return valid image dimensions.")
        pose_observation = None

        if len(frames) == 1:
            try:
                pose_observation = mediapipe_frame_pose_to_observation(
                    frames[0],
                    detection_index=review.subject.selected_detection_index,
                    human_confirmed_neutral_track_id=(
                        review.subject.neutral_track_id
                    ),
                    image_width=image_width,
                    image_height=image_height,
                )
            except ValueError:
                pose_observation = None

        completed_payload = review.model_dump(mode="json")
        completed_payload["pose_observation"] = (
            pose_observation.model_dump(mode="json")
            if pose_observation is not None
            else None
        )
        completed_request = SingleAttemptAnalysisRequest.model_validate(
            completed_payload
        )
        return analyze_single_attempt(completed_request)
    except HTTPException:
        raise
    except ValueError as error:
        raise HTTPException(status_code=400, detail=str(error)) from error
    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail="Single-attempt V2A video analysis failed.",
        ) from error
    finally:
        await video.close()
        if upload_path is not None and upload_path.exists():
            upload_path.unlink()


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

    upload_path: Path | None = None

    try:
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

        if upload_path is not None and upload_path.exists():
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
