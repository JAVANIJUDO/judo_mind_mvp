from __future__ import annotations

from enum import Enum
from typing import Literal

from pydantic import BaseModel, Field


class AnalysisProvenance(str, Enum):
    """Scientific origin of a value returned by the AI Engine."""

    MEASURED = "measured"
    RECONSTRUCTED = "reconstructed"
    MODEL_ESTIMATED = "model-estimated"
    AI_INFERRED = "AI-inferred"


class TechniqueReference(BaseModel):
    id: str


class PoseEngineMetadata(BaseModel):
    id: str
    display_name: str
    maturity: Literal["experimental"] = "experimental"
    target_fps: float = Field(gt=0)


class VideoMetadata(BaseModel):
    filename: str
    width: int = Field(ge=0)
    height: int = Field(ge=0)
    source_fps: float = Field(ge=0)
    frame_count: int = Field(ge=0)
    duration_seconds: float = Field(ge=0)
    provenance: Literal[AnalysisProvenance.MEASURED] = (
        AnalysisProvenance.MEASURED
    )


class PoseCoverageSummary(BaseModel):
    analyzed_frame_count: int = Field(ge=0)
    frames_with_at_least_one_pose: int = Field(ge=0)
    frames_with_two_poses: int = Field(ge=0)
    at_least_one_pose_rate: float = Field(ge=0, le=1)
    two_pose_rate: float = Field(ge=0, le=1)
    provenance: Literal[AnalysisProvenance.MODEL_ESTIMATED] = (
        AnalysisProvenance.MODEL_ESTIMATED
    )
    confidence_available: Literal[False] = False


class SingleCameraCapabilities(BaseModel):
    athlete_identity: Literal[False] = False
    phase_detection: Literal[False] = False
    three_dimensional_reconstruction: Literal[False] = False
    force_or_torque: Literal[False] = False


class AnalysisLimitation(BaseModel):
    code: str
    message: str
    affects_interpretation: bool = True


class SingleCameraPoseSummaryResponse(BaseModel):
    schema_version: Literal["1.0.0"] = "1.0.0"
    analysis_id: str
    status: Literal["completed"] = "completed"
    analysis_mode: Literal["single_camera_2d"] = "single_camera_2d"
    technique: TechniqueReference
    camera_view: str
    engine: PoseEngineMetadata
    video: VideoMetadata
    pose_coverage: PoseCoverageSummary
    capabilities: SingleCameraCapabilities = Field(
        default_factory=SingleCameraCapabilities
    )
    limitations: list[AnalysisLimitation]


SINGLE_CAMERA_POSE_LIMITATIONS = [
    AnalysisLimitation(
        code="pose_identity_not_available",
        message=(
            "Detected pose order is frame-local and must not be interpreted "
            "as persistent Tori or Uke identity."
        ),
    ),
    AnalysisLimitation(
        code="phase_detection_not_available",
        message=(
            "Kuzushi, Tsukuri and Kake are not detected in this version."
        ),
    ),
    AnalysisLimitation(
        code="single_camera_2d_only",
        message=(
            "This single-camera result is not measured or reconstructed 3D."
        ),
    ),
    AnalysisLimitation(
        code="force_torque_not_available",
        message=(
            "No real force, torque or laboratory-grade biomechanics is "
            "reported."
        ),
    ),
    AnalysisLimitation(
        code="experimental_pose_baseline",
        message=(
            "Pose coverage comes from an experimental model baseline and is "
            "not a scientific confidence score."
        ),
    ),
]
