from __future__ import annotations

"""Judo Mind static-hold stereo calibration for same-session intrinsics.

The 101/102 intrinsics were estimated directly from the two stereo-session
videos with OpenCV VideoCapture and ORIENTATION_AUTO enabled.  The stereo
pipeline decodes raw frames through PyAV, so this runner applies the exact
display transforms required to reproduce those intrinsic coordinate systems:

Camera 1 (VID_20260807_010753.mp4): raw 1920x1080 -> rotate 180 degrees.
Camera 2 (IMG_7398.MOV): raw 3840x2160 -> rotate 90 degrees clockwise,
                         producing 2160x3840.

All hold detection, audio synchronization, common-corner matching, robust
rejection and stereo-calibration logic remains in the validated v1 runner.
"""

import cv2
import numpy as np

import stereo_static_hold_calibration_v1_20260807 as base


CAMERA_1_INTRINSIC_ORIENTATION = "rotate180"
CAMERA_2_INTRINSIC_ORIENTATION = "clockwise"


def intrinsic_orient_frame(
    frame: np.ndarray,
    orientation: str,
) -> np.ndarray:
    """Transform a raw PyAV frame into same-session intrinsic coordinates."""
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
    """Return the transform defined by the new intrinsic calibration run."""
    del selected_frames, target_size, detector, matrix, distortion

    if label == "Camera 1":
        orientation = CAMERA_1_INTRINSIC_ORIENTATION
    elif label == "Camera 2":
        orientation = CAMERA_2_INTRINSIC_ORIENTATION
    else:
        raise ValueError(f"Unknown camera label: {label}")

    print(
        f"{label} orientation: {orientation} "
        "(fixed from same-session intrinsic coordinates)"
    )
    return orientation


def main() -> None:
    base.orient_frame = intrinsic_orient_frame
    base.select_orientation = fixed_orientation
    base.main()


if __name__ == "__main__":
    main()