from __future__ import annotations

"""Judo Mind static-hold stereo calibration -- orientation correction.

This runner preserves the validated v1 static-hold pipeline but fixes a
coordinate-system mismatch discovered by comparing the calibration-video
rotation metadata with the new stereo recordings.

The intrinsic files were estimated from OpenCV frames after VideoCapture had
applied each calibration video's rotation metadata.  PyAV, which is used by
the timestamp-accurate stereo pipeline, returns raw encoded frames instead.
Therefore raw frames must be transformed into the same coordinate systems as
the intrinsic calibration before ChArUco observations are used.

Camera 1 intrinsic coordinate system: 90-degree calibration orientation.
Validated transform for the raw frame: clockwise.

Camera 2 intrinsic coordinate system: 180-degree calibration orientation.
Required raw-frame transform: 180 degrees.
"""

import cv2
import numpy as np

import stereo_static_hold_calibration_v1_20260807 as base


CAMERA_1_INTRINSIC_ORIENTATION = "clockwise"
CAMERA_2_INTRINSIC_ORIENTATION = "rotate180"


def intrinsic_orient_frame(
    frame: np.ndarray,
    orientation: str,
) -> np.ndarray:
    """Transform a raw PyAV frame into its intrinsic calibration coordinates."""
    if orientation == "clockwise":
        return cv2.rotate(frame, cv2.ROTATE_90_CLOCKWISE)
    if orientation == "counterclockwise":
        return cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
    if orientation == "rotate180":
        return cv2.rotate(frame, cv2.ROTATE_180)
    if orientation == "none":
        return frame
    raise ValueError(f"Unsupported orientation: {orientation}")


def fixed_orientation(
    label: str,
    selected_frames: list[tuple[float, np.ndarray]],
    target_size: tuple[int, int],
    detector: object,
    matrix: np.ndarray,
    distortion: np.ndarray,
) -> str:
    """Return the known transform tied to the intrinsic calibration video."""
    del selected_frames, target_size, detector, matrix, distortion

    if label == "Camera 1":
        orientation = CAMERA_1_INTRINSIC_ORIENTATION
    elif label == "Camera 2":
        orientation = CAMERA_2_INTRINSIC_ORIENTATION
    else:
        raise ValueError(f"Unknown camera label: {label}")

    print(
        f"{label} orientation: {orientation} "
        "(fixed from intrinsic calibration coordinate system)"
    )
    return orientation


def main() -> None:
    # The v1 implementation references these helpers as module globals at
    # runtime.  Override only those two helpers; all timing, hold detection,
    # common-corner matching, robust rejection and reporting remain unchanged.
    base.orient_frame = intrinsic_orient_frame
    base.select_orientation = fixed_orientation
    base.main()


if __name__ == "__main__":
    main()