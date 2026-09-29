from __future__ import annotations

from dataclasses import dataclass
import math
from typing import Iterable


@dataclass(frozen=True)
class Point2D:
    x: float
    y: float
    confidence: float | None = None

    def __post_init__(self) -> None:
        if not math.isfinite(self.x) or not math.isfinite(self.y):
            raise ValueError("Point coordinates must be finite.")

        if self.confidence is not None and (
            not math.isfinite(self.confidence)
            or not 0.0 <= self.confidence <= 1.0
        ):
            raise ValueError("Point confidence must be between zero and one.")


def execution_duration_seconds(start_timestamp_ms: int, end_timestamp_ms: int) -> float:
    """Return elapsed video time for a reviewed event pair."""

    if isinstance(start_timestamp_ms, bool) or isinstance(end_timestamp_ms, bool):
        raise ValueError("Timestamps must be integer milliseconds.")

    if not isinstance(start_timestamp_ms, int) or not isinstance(
        end_timestamp_ms,
        int,
    ):
        raise ValueError("Timestamps must be integer milliseconds.")

    if start_timestamp_ms < 0 or end_timestamp_ms < 0:
        raise ValueError("Timestamps cannot be negative.")

    if end_timestamp_ms <= start_timestamp_ms:
        raise ValueError("End timestamp must follow start timestamp.")

    return (end_timestamp_ms - start_timestamp_ms) / 1000.0


def midpoint(first: Point2D, second: Point2D) -> Point2D:
    confidence = minimum_available_confidence((first, second))
    return Point2D(
        x=(first.x + second.x) / 2.0,
        y=(first.y + second.y) / 2.0,
        confidence=confidence,
    )


def minimum_available_confidence(points: Iterable[Point2D]) -> float | None:
    values = [point.confidence for point in points]

    if not values or any(value is None for value in values):
        return None

    return min(value for value in values if value is not None)


def projected_trunk_inclination_degrees(
    *,
    left_shoulder: Point2D,
    right_shoulder: Point2D,
    left_hip: Point2D,
    right_hip: Point2D,
) -> float:
    """Return unsigned projected trunk inclination from image vertical-up.

    The trunk vector runs from the midpoint of the hips to the midpoint of the
    shoulders. Image y increases downward. The versioned formula is
    degrees(atan2(abs(dx), -dy)), yielding 0 degrees for upright vertical and
    90 degrees for horizontal. It is an image-plane projection, not a 3D angle.
    """

    shoulder_midpoint = midpoint(left_shoulder, right_shoulder)
    hip_midpoint = midpoint(left_hip, right_hip)
    dx = shoulder_midpoint.x - hip_midpoint.x
    dy = shoulder_midpoint.y - hip_midpoint.y

    if math.hypot(dx, dy) <= 1e-12:
        raise ValueError("Trunk axis is degenerate.")

    return math.degrees(math.atan2(abs(dx), -dy))


def projected_knee_angle_degrees(
    *,
    hip: Point2D,
    knee: Point2D,
    ankle: Point2D,
) -> float:
    """Return the image-plane internal hip-knee-ankle angle in degrees."""

    proximal = (hip.x - knee.x, hip.y - knee.y)
    distal = (ankle.x - knee.x, ankle.y - knee.y)
    proximal_norm = math.hypot(*proximal)
    distal_norm = math.hypot(*distal)

    if proximal_norm <= 1e-12 or distal_norm <= 1e-12:
        raise ValueError("Knee geometry is degenerate.")

    cosine = (
        proximal[0] * distal[0] + proximal[1] * distal[1]
    ) / (proximal_norm * distal_norm)
    bounded_cosine = max(-1.0, min(1.0, cosine))
    return math.degrees(math.acos(bounded_cosine))
