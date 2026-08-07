from __future__ import annotations

import json
import math
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Any, Mapping


class CalibrationPurpose(str, Enum):
    """Permitted use for an approved stereo calibration."""

    OFFLINE_3D_VALIDATION = "offline_3d_validation"
    SCIENTIFIC_3D = "scientific_3d"
    OPENSIM = "opensim"


class CalibrationRejectedError(ValueError):
    """Raised when calibration evidence is not safe for its requested use."""


@dataclass(frozen=True)
class CalibrationThresholds:
    accepted_qualities: frozenset[str]
    minimum_valid_stereo_holds: int
    maximum_rms_reprojection_error_px: float
    maximum_median_epipolar_error_px: float
    maximum_median_abs_sync_error_ms: float


VALIDATION_THRESHOLDS = CalibrationThresholds(
    accepted_qualities=frozenset(
        {
            "usable_for_3d_validation",
            "good",
            "excellent",
        }
    ),
    minimum_valid_stereo_holds=8,
    maximum_rms_reprojection_error_px=3.0,
    maximum_median_epipolar_error_px=2.0,
    maximum_median_abs_sync_error_ms=9.0,
)


SCIENTIFIC_THRESHOLDS = CalibrationThresholds(
    accepted_qualities=frozenset(
        {
            "good",
            "excellent",
        }
    ),
    minimum_valid_stereo_holds=10,
    maximum_rms_reprojection_error_px=2.0,
    maximum_median_epipolar_error_px=1.25,
    maximum_median_abs_sync_error_ms=8.5,
)


@dataclass(frozen=True)
class CalibrationMetrics:
    valid_stereo_holds: int
    rms_reprojection_error_px: float
    median_epipolar_error_px: float
    median_abs_sync_error_ms: float


@dataclass(frozen=True)
class CalibrationDecision:
    purpose: CalibrationPurpose
    accepted: bool
    status: str
    quality: str
    metrics: CalibrationMetrics | None
    reasons: tuple[str, ...]

    def require_accepted(self) -> None:
        if self.accepted:
            return

        reason_text = "; ".join(self.reasons)
        raise CalibrationRejectedError(
            "Stereo calibration rejected for "
            f"{self.purpose.value}: {reason_text}"
        )


_APPROVAL_SEAL = object()


@dataclass(frozen=True)
class ValidatedCalibrationContext:
    """
    Evidence that a report passed the centralized calibration gate.

    This context is necessary, but not sufficient, for OpenSim. Identity,
    reconstruction, anatomical mapping, and motion-quality gates must also
    pass before musculoskeletal processing.
    """

    calibration_id: str
    purpose: CalibrationPurpose
    quality: str
    metrics: CalibrationMetrics
    _seal: object = field(
        repr=False,
        compare=False,
    )

    def __post_init__(self) -> None:
        if self._seal is not _APPROVAL_SEAL:
            raise CalibrationRejectedError(
                "ValidatedCalibrationContext must be created by the "
                "calibration quality gate."
            )

    @property
    def allows_user_facing_scientific_3d(self) -> bool:
        return self.purpose in {
            CalibrationPurpose.SCIENTIFIC_3D,
            CalibrationPurpose.OPENSIM,
        }


def thresholds_for(
    purpose: CalibrationPurpose,
) -> CalibrationThresholds:
    if not isinstance(purpose, CalibrationPurpose):
        raise CalibrationRejectedError(
            "Calibration purpose must be a CalibrationPurpose value."
        )

    if purpose == CalibrationPurpose.OFFLINE_3D_VALIDATION:
        return VALIDATION_THRESHOLDS
    return SCIENTIFIC_THRESHOLDS


def evaluate_calibration_report(
    report: Mapping[str, Any],
    purpose: CalibrationPurpose,
) -> CalibrationDecision:
    """Evaluate a calibration report without permitting missing evidence."""

    status = str(report.get("status", "missing"))
    quality = str(report.get("quality", "missing"))
    reasons: list[str] = []

    if status != "completed":
        reasons.append(
            f"status must be completed, received {status!r}"
        )

    thresholds = thresholds_for(purpose)
    if quality not in thresholds.accepted_qualities:
        reasons.append(
            f"quality {quality!r} is not accepted for {purpose.value}"
        )

    metrics, metric_reasons = _read_metrics(report)
    reasons.extend(metric_reasons)

    if metrics is not None:
        if (
            metrics.valid_stereo_holds
            < thresholds.minimum_valid_stereo_holds
        ):
            reasons.append(
                "valid stereo holds "
                f"{metrics.valid_stereo_holds} are below "
                f"{thresholds.minimum_valid_stereo_holds}"
            )

        if (
            metrics.rms_reprojection_error_px
            > thresholds.maximum_rms_reprojection_error_px
        ):
            reasons.append(
                "RMS reprojection error "
                f"{metrics.rms_reprojection_error_px:.6f} px exceeds "
                f"{thresholds.maximum_rms_reprojection_error_px:.6f} px"
            )

        if (
            metrics.median_epipolar_error_px
            > thresholds.maximum_median_epipolar_error_px
        ):
            reasons.append(
                "median epipolar error "
                f"{metrics.median_epipolar_error_px:.6f} px exceeds "
                f"{thresholds.maximum_median_epipolar_error_px:.6f} px"
            )

        if (
            metrics.median_abs_sync_error_ms
            > thresholds.maximum_median_abs_sync_error_ms
        ):
            reasons.append(
                "median absolute sync error "
                f"{metrics.median_abs_sync_error_ms:.6f} ms exceeds "
                f"{thresholds.maximum_median_abs_sync_error_ms:.6f} ms"
            )

    return CalibrationDecision(
        purpose=purpose,
        accepted=not reasons,
        status=status,
        quality=quality,
        metrics=metrics,
        reasons=tuple(reasons),
    )


def approve_calibration_report(
    report: Mapping[str, Any],
    purpose: CalibrationPurpose,
    calibration_id: str,
) -> ValidatedCalibrationContext:
    calibration_id = calibration_id.strip()
    if not calibration_id:
        raise CalibrationRejectedError(
            "Calibration ID is required."
        )

    decision = evaluate_calibration_report(
        report=report,
        purpose=purpose,
    )
    decision.require_accepted()

    if decision.metrics is None:
        raise CalibrationRejectedError(
            "Calibration metrics are required."
        )

    return ValidatedCalibrationContext(
        calibration_id=calibration_id,
        purpose=purpose,
        quality=decision.quality,
        metrics=decision.metrics,
        _seal=_APPROVAL_SEAL,
    )


def load_and_approve_calibration(
    report_path: Path,
    purpose: CalibrationPurpose,
) -> ValidatedCalibrationContext:
    report_path = report_path.resolve()
    report = json.loads(
        report_path.read_text(encoding="utf-8")
    )
    if not isinstance(report, Mapping):
        raise CalibrationRejectedError(
            "Calibration report must be a JSON object."
        )

    return approve_calibration_report(
        report=report,
        purpose=purpose,
        calibration_id=str(report_path),
    )


def require_validated_context(
    context: object,
) -> ValidatedCalibrationContext:
    if not isinstance(context, ValidatedCalibrationContext):
        raise CalibrationRejectedError(
            "Multi-view reconstruction requires a validated calibration "
            "context."
        )

    if context._seal is not _APPROVAL_SEAL:
        raise CalibrationRejectedError(
            "Calibration context approval seal is invalid."
        )

    return context


def _read_metrics(
    report: Mapping[str, Any],
) -> tuple[CalibrationMetrics | None, list[str]]:
    hold_detection = report.get("hold_detection")
    calibration = report.get("calibration")
    validation = report.get("validation")

    if not isinstance(hold_detection, Mapping):
        hold_detection = {}
    if not isinstance(calibration, Mapping):
        calibration = {}
    if not isinstance(validation, Mapping):
        validation = {}

    fields = {
        "valid_stereo_holds": hold_detection.get(
            "valid_stereo_holds"
        ),
        "rms_reprojection_error_px": calibration.get(
            "rms_reprojection_error_px"
        ),
        "median_epipolar_error_px": validation.get(
            "median_epipolar_error_px"
        ),
        "median_abs_sync_error_ms": validation.get(
            "median_abs_sync_error_ms"
        ),
    }

    reasons: list[str] = []
    parsed: dict[str, float] = {}
    for name, value in fields.items():
        if value is None:
            reasons.append(
                f"required metric {name!r} is missing"
            )
            continue

        if isinstance(value, bool):
            reasons.append(
                f"required metric {name!r} is not numeric"
            )
            continue

        try:
            numeric_value = float(value)
        except (TypeError, ValueError):
            reasons.append(
                f"required metric {name!r} is not numeric"
            )
            continue

        if not math.isfinite(numeric_value) or numeric_value < 0.0:
            reasons.append(
                f"required metric {name!r} is invalid"
            )
            continue

        parsed[name] = numeric_value

    hold_count = parsed.get("valid_stereo_holds")
    if (
        hold_count is not None
        and not hold_count.is_integer()
    ):
        reasons.append(
            "required metric 'valid_stereo_holds' must be an integer"
        )

    if reasons:
        return None, reasons

    return (
        CalibrationMetrics(
            valid_stereo_holds=int(
                parsed["valid_stereo_holds"]
            ),
            rms_reprojection_error_px=parsed[
                "rms_reprojection_error_px"
            ],
            median_epipolar_error_px=parsed[
                "median_epipolar_error_px"
            ],
            median_abs_sync_error_ms=parsed[
                "median_abs_sync_error_ms"
            ],
        ),
        [],
    )
