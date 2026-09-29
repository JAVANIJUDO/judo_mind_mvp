from __future__ import annotations

from uuid import uuid4

from ai_engine.contracts.single_attempt_analysis_v2a import (
    Landmark2D,
    MetricConfidence,
    MetricResult,
    MetricStatus,
    MetricTemporalReference,
    OverlayPoint,
    OverlayPrimitive,
    SINGLE_ATTEMPT_LIMITATIONS,
    SingleAttemptAnalysisRequest,
    SingleAttemptAnalysisResponse,
    SingleAttemptCapabilities,
    SupportLegSide,
)
from ai_engine.contracts.single_camera_pose_summary import AnalysisProvenance
from ai_engine.single_attempt.metrics import (
    Point2D,
    execution_duration_seconds,
    minimum_available_confidence,
    projected_knee_angle_degrees,
    projected_trunk_inclination_degrees,
)


TRUNK_METHOD_VERSION = "projected-trunk-inclination-1.0.0"
KNEE_METHOD_VERSION = "projected-knee-angle-1.0.0"
ATTACKING_KNEE_METHOD_VERSION = "projected-knee-angle-1.0.0"
DURATION_METHOD_VERSION = "reviewed-event-elapsed-time-1.0.0"


def _unavailable_confidence(reason: str) -> MetricConfidence:
    return MetricConfidence(
        available=False,
        interpretation=reason,
    )


def _landmark_confidence(points: tuple[Point2D, ...]) -> MetricConfidence:
    confidence = minimum_available_confidence(points)

    if confidence is None:
        return _unavailable_confidence(
            "The pose engine did not provide visibility for every required "
            "landmark; no aggregate scientific confidence is invented."
        )

    return MetricConfidence(
        available=True,
        kind="minimum_model_landmark_visibility",
        value=confidence,
        provenance=AnalysisProvenance.MODEL_ESTIMATED,
        interpretation=(
            "Minimum model landmark visibility used by this metric. This is "
            "not pose accuracy or biomechanical validity."
        ),
    )


def _metric_point(
    landmark: Landmark2D,
    *,
    image_width: int,
    image_height: int,
) -> Point2D:
    return Point2D(
        x=landmark.x * image_width,
        y=landmark.y * image_height,
        confidence=landmark.visibility,
    )


def _metric_status(
    request: SingleAttemptAnalysisRequest,
    confidence: MetricConfidence,
    *,
    used_landmark_names: tuple[str, ...] = (),
) -> MetricStatus:
    observation = request.pose_observation

    if observation is not None and used_landmark_names:
        boundary_normalized = set(
            observation.boundary_normalized_landmarks
        )
        if boundary_normalized.intersection(used_landmark_names):
            return MetricStatus.REVIEW_REQUIRED

    if (
        request.camera_suitability.permits_reportable_angles
        and confidence.available
    ):
        return MetricStatus.REPORTABLE

    return MetricStatus.REVIEW_REQUIRED


def _duration_metric(request: SingleAttemptAnalysisRequest) -> MetricResult:
    playback_duration = execution_duration_seconds(
        request.attempt.start.timestamp_ms,
        request.attempt.end.timestamp_ms,
    )
    timing = request.attempt.source_timing
    timing_unreliable = timing is not None and (
        timing.state == "UNKNOWN"
        or timing.timing_mode == "UNKNOWN"
        or timing.timestamp_provenance == "average-fps-derived-not-true-pts"
    )
    if timing_unreliable:
        return MetricResult(
            metric_id="UM-TIM-001",
            name="Selected-window elapsed time",
            status=MetricStatus.WITHHELD,
            value=None,
            unit="seconds",
            provenance=AnalysisProvenance.MEASURED,
            temporal_reference=MetricTemporalReference(
                kind="interval", start=request.attempt.start, end=request.attempt.end
            ),
            confidence=_unavailable_confidence(
                "Physical timing is unavailable because source timing is unknown."
            ),
            method_version=DURATION_METHOD_VERSION,
            limitation=(
                "Playback timing is retained for audit only and is not reported as "
                "physical Uchi Mata execution duration."
            ),
            withheld_reason=(
                "Physical execution duration is unavailable for a source with "
                "unknown timing or time stretching."
            ),
        )
    scale = (
        timing.physical_time_scale
        if timing is not None and timing.state == "KNOWN_TIME_SCALE"
        else 1.0
    )
    duration = playback_duration * (scale or 1.0)

    return MetricResult(
        metric_id="UM-TIM-001",
        name="Selected-window elapsed time",
        status=MetricStatus.REPORTABLE,
        value=duration,
        unit="seconds",
        provenance=AnalysisProvenance.MEASURED,
        temporal_reference=MetricTemporalReference(
            kind="interval",
            start=request.attempt.start,
            end=request.attempt.end,
        ),
        confidence=_unavailable_confidence(
            "No model confidence applies: exact frame boundaries were selected "
            "and confirmed by a human reviewer."
        ),
        method_version=DURATION_METHOD_VERSION,
        limitation=(
            "This is elapsed time between human-confirmed boundaries, not an "
            "automatically detected Uchi Mata phase or technique duration."
        ),
        descriptive_text=(
            f"Selected-window elapsed time is {duration:.3f} seconds between "
            f"human-confirmed frames {request.attempt.start.frame_index} and "
            f"{request.attempt.end.frame_index}."
        ),
    )


def _withheld_angle(
    *,
    metric_id: str,
    name: str,
    request: SingleAttemptAnalysisRequest,
    method_version: str,
    reason: str,
) -> MetricResult:
    return MetricResult(
        metric_id=metric_id,
        name=name,
        status=MetricStatus.WITHHELD,
        value=None,
        unit="degrees",
        provenance=AnalysisProvenance.MODEL_ESTIMATED,
        temporal_reference=MetricTemporalReference(
            kind="instant",
            frame=request.angle_frame.frame,
        ),
        confidence=_unavailable_confidence(
            "Confidence is unavailable because the metric was withheld."
        ),
        method_version=method_version,
        limitation=(
            "This is a projected 2D metric and cannot represent a true 3D "
            "anatomical angle."
        ),
        withheld_reason=reason,
    )


def _trunk_metric(request: SingleAttemptAnalysisRequest) -> MetricResult:
    observation = request.pose_observation
    name = "Projected trunk inclination"

    if observation is None:
        return _withheld_angle(
            metric_id="UM-ANG-001",
            name=name,
            request=request,
            method_version=TRUNK_METHOD_VERSION,
            reason="No model-estimated pose observation is available.",
        )

    names = ("left_shoulder", "right_shoulder", "left_hip", "right_hip")
    missing = [name for name in names if name not in observation.landmarks]
    if missing:
        return _withheld_angle(
            metric_id="UM-ANG-001",
            name=name,
            request=request,
            method_version=TRUNK_METHOD_VERSION,
            reason=f"Required landmarks are missing: {', '.join(missing)}.",
        )

    points = tuple(
        _metric_point(
            observation.landmarks[item],
            image_width=observation.image_width,
            image_height=observation.image_height,
        )
        for item in names
    )
    left_shoulder, right_shoulder, left_hip, right_hip = points

    try:
        value = projected_trunk_inclination_degrees(
            left_shoulder=left_shoulder,
            right_shoulder=right_shoulder,
            left_hip=left_hip,
            right_hip=right_hip,
        )
    except ValueError as error:
        return _withheld_angle(
            metric_id="UM-ANG-001",
            name=name,
            request=request,
            method_version=TRUNK_METHOD_VERSION,
            reason=str(error),
        )

    shoulder_landmarks = (
        observation.landmarks["left_shoulder"],
        observation.landmarks["right_shoulder"],
    )
    hip_landmarks = (
        observation.landmarks["left_hip"],
        observation.landmarks["right_hip"],
    )
    shoulder_overlay = (
        (shoulder_landmarks[0].x + shoulder_landmarks[1].x) / 2.0,
        (shoulder_landmarks[0].y + shoulder_landmarks[1].y) / 2.0,
    )
    hip_overlay = (
        (hip_landmarks[0].x + hip_landmarks[1].x) / 2.0,
        (hip_landmarks[0].y + hip_landmarks[1].y) / 2.0,
    )
    timestamp_ms = request.angle_frame.frame.timestamp_ms
    confidence = _landmark_confidence(points)

    return MetricResult(
        metric_id="UM-ANG-001",
        name=name,
        status=_metric_status(
            request,
            confidence,
            used_landmark_names=names,
        ),
        value=value,
        unit="degrees",
        provenance=AnalysisProvenance.MODEL_ESTIMATED,
        temporal_reference=MetricTemporalReference(
            kind="instant",
            frame=request.angle_frame.frame,
        ),
        confidence=confidence,
        method_version=TRUNK_METHOD_VERSION,
        limitation=(
            "Image-plane inclination is affected by view, roll, occlusion and "
            "out-of-plane motion; it is not a 3D trunk angle."
        ),
        descriptive_text=(
            f"Projected trunk inclination is {value:.1f} degrees at timestamp "
            f"{timestamp_ms} ms."
        ),
        overlay=[
            OverlayPrimitive(
                kind="line",
                points=[
                    OverlayPoint(x=hip_overlay[0], y=hip_overlay[1]),
                    OverlayPoint(
                        x=shoulder_overlay[0],
                        y=shoulder_overlay[1],
                    ),
                ],
                label="Projected trunk line",
            ),
            OverlayPrimitive(
                kind="angle_label",
                points=[
                    OverlayPoint(
                        x=shoulder_overlay[0],
                        y=shoulder_overlay[1],
                    )
                ],
                label=f"{value:.1f} degrees projected",
            ),
        ],
    )


def _knee_metric(request: SingleAttemptAnalysisRequest) -> MetricResult:
    observation = request.pose_observation
    name = "Projected support-leg knee angle"

    if observation is None:
        return _withheld_angle(
            metric_id="UM-ANG-002",
            name=name,
            request=request,
            method_version=KNEE_METHOD_VERSION,
            reason="No model-estimated pose observation is available.",
        )

    side = request.support_leg.side.value
    names = (f"{side}_hip", f"{side}_knee", f"{side}_ankle")
    missing = [name for name in names if name not in observation.landmarks]
    if missing:
        return _withheld_angle(
            metric_id="UM-ANG-002",
            name=name,
            request=request,
            method_version=KNEE_METHOD_VERSION,
            reason=f"Required landmarks are missing: {', '.join(missing)}.",
        )

    points = tuple(
        _metric_point(
            observation.landmarks[item],
            image_width=observation.image_width,
            image_height=observation.image_height,
        )
        for item in names
    )
    hip, knee, ankle = points

    try:
        value = projected_knee_angle_degrees(hip=hip, knee=knee, ankle=ankle)
    except ValueError as error:
        return _withheld_angle(
            metric_id="UM-ANG-002",
            name=name,
            request=request,
            method_version=KNEE_METHOD_VERSION,
            reason=str(error),
        )

    timestamp_ms = request.angle_frame.frame.timestamp_ms
    confidence = _landmark_confidence(points)
    hip_landmark, knee_landmark, ankle_landmark = (
        observation.landmarks[item] for item in names
    )

    return MetricResult(
        metric_id="UM-ANG-002",
        name=name,
        status=_metric_status(
            request,
            confidence,
            used_landmark_names=names,
        ),
        value=value,
        unit="degrees",
        provenance=AnalysisProvenance.MODEL_ESTIMATED,
        temporal_reference=MetricTemporalReference(
            kind="instant",
            frame=request.angle_frame.frame,
        ),
        confidence=confidence,
        method_version=KNEE_METHOD_VERSION,
        limitation=(
            "The hip-knee-ankle angle is projected into the image plane and "
            "does not indicate load, moment, injury risk or a true 3D angle."
        ),
        descriptive_text=(
            f"Projected {side} support-leg knee angle is {value:.1f} degrees "
            f"at timestamp {timestamp_ms} ms."
        ),
        overlay=[
            OverlayPrimitive(
                kind="polyline",
                points=[
                    OverlayPoint(
                        x=hip_landmark.x,
                        y=hip_landmark.y,
                        label=f"{side} hip",
                    ),
                    OverlayPoint(
                        x=knee_landmark.x,
                        y=knee_landmark.y,
                        label=f"{side} knee",
                    ),
                    OverlayPoint(
                        x=ankle_landmark.x,
                        y=ankle_landmark.y,
                        label=f"{side} ankle",
                    ),
                ],
                label=f"Projected {side} support leg",
            ),
            OverlayPrimitive(
                kind="angle_label",
                points=[
                    OverlayPoint(x=knee_landmark.x, y=knee_landmark.y)
                ],
                label=f"{value:.1f} degrees projected",
            ),
        ],
    )


def _attacking_knee_metric(
    request: SingleAttemptAnalysisRequest,
) -> MetricResult:
    name = "Projected attacking-leg knee angle"

    if request.attacking_leg is None:
        return _withheld_angle(
            metric_id="UM-ANG-003",
            name=name,
            request=request,
            method_version=ATTACKING_KNEE_METHOD_VERSION,
            reason=(
                "Attacking leg has not been human-confirmed."
            ),
        )

    observation = request.pose_observation

    if observation is None:
        return _withheld_angle(
            metric_id="UM-ANG-003",
            name=name,
            request=request,
            method_version=ATTACKING_KNEE_METHOD_VERSION,
            reason="No model-estimated pose observation is available.",
        )

    side = request.attacking_leg.side.value
    names = (
        f"{side}_hip",
        f"{side}_knee",
        f"{side}_ankle",
    )

    missing = [
        landmark_name
        for landmark_name in names
        if landmark_name not in observation.landmarks
    ]

    if missing:
        return _withheld_angle(
            metric_id="UM-ANG-003",
            name=name,
            request=request,
            method_version=ATTACKING_KNEE_METHOD_VERSION,
            reason=(
                "Required landmarks are missing: "
                + ", ".join(missing)
                + "."
            ),
        )

    points = tuple(
        _metric_point(
            observation.landmarks[item],
            image_width=observation.image_width,
            image_height=observation.image_height,
        )
        for item in names
    )

    hip, knee, ankle = points

    try:
        value = projected_knee_angle_degrees(
            hip=hip,
            knee=knee,
            ankle=ankle,
        )
    except ValueError as error:
        return _withheld_angle(
            metric_id="UM-ANG-003",
            name=name,
            request=request,
            method_version=ATTACKING_KNEE_METHOD_VERSION,
            reason=str(error),
        )

    confidence = _landmark_confidence(points)

    hip_landmark, knee_landmark, ankle_landmark = (
        observation.landmarks[item]
        for item in names
    )

    timestamp_ms = request.angle_frame.frame.timestamp_ms

    return MetricResult(
        metric_id="UM-ANG-003",
        name=name,
        status=_metric_status(
            request,
            confidence,
            used_landmark_names=names,
        ),
        value=value,
        unit="degrees",
        provenance=AnalysisProvenance.MODEL_ESTIMATED,
        temporal_reference=MetricTemporalReference(
            kind="instant",
            frame=request.angle_frame.frame,
        ),
        confidence=confidence,
        method_version=ATTACKING_KNEE_METHOD_VERSION,
        limitation=(
            "The attacking-leg hip-knee-ankle angle is projected "
            "into the image plane and is not a true 3D anatomical "
            "joint angle."
        ),
        descriptive_text=(
            f"Projected {side} attacking-leg knee angle is "
            f"{value:.1f} degrees at timestamp {timestamp_ms} ms."
        ),
        overlay=[
            OverlayPrimitive(
                kind="polyline",
                points=[
                    OverlayPoint(
                        x=hip_landmark.x,
                        y=hip_landmark.y,
                        label=f"{side} hip",
                    ),
                    OverlayPoint(
                        x=knee_landmark.x,
                        y=knee_landmark.y,
                        label=f"{side} knee",
                    ),
                    OverlayPoint(
                        x=ankle_landmark.x,
                        y=ankle_landmark.y,
                        label=f"{side} ankle",
                    ),
                ],
                label=f"Projected {side} attacking leg",
            ),
            OverlayPrimitive(
                kind="angle_label",
                points=[
                    OverlayPoint(
                        x=knee_landmark.x,
                        y=knee_landmark.y,
                    )
                ],
                label=f"{value:.1f} degrees projected",
            ),
        ],
    )


def analyze_single_attempt(
    request: SingleAttemptAnalysisRequest,
    *,
    analysis_id: str | None = None,
) -> SingleAttemptAnalysisResponse:
    """Evaluate the three V2A metrics from reviewed selections and one pose."""

    return SingleAttemptAnalysisResponse(
        analysis_id=analysis_id or uuid4().hex,
        technique=request.technique,
        video_id=request.video_id,
        camera_view=request.camera_view,
        attempt=request.attempt,
        subject=request.subject,
        support_leg=request.support_leg,
        attacking_leg=request.attacking_leg,
        angle_frame=request.angle_frame,
        camera_suitability=request.camera_suitability,
        metrics=[
            _duration_metric(request),
            _trunk_metric(request),
            _knee_metric(request),
            _attacking_knee_metric(request),
        ],
        capabilities=SingleAttemptCapabilities(),
        limitations=SINGLE_ATTEMPT_LIMITATIONS,
    )
