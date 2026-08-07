from __future__ import annotations

"""Judo Mind video-offset search using same-session intrinsic coordinates."""

import stereo_video_offset_search_v1_20260807 as base


def main() -> None:
    # The 101 intrinsic was created from OpenCV's 180-degree displayed frame.
    base.CAMERA_1_ORIENTATION = "rotate180"

    # The 102 intrinsic was created from OpenCV's 90-degree clockwise display.
    base.CAMERA_2_ORIENTATION = "clockwise"

    # Keep memory and processing bounded while scaling K consistently.
    base.CAMERA_2_SCALE = 0.50

    base.main()


if __name__ == "__main__":
    main()