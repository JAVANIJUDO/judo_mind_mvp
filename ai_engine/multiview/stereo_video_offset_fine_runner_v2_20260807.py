from __future__ import annotations

"""Fine same-session video-offset runner; preserves the full search engine."""

import stereo_video_offset_search_v1_20260807 as base


def main() -> None:
    base.CAMERA_1_ORIENTATION = "rotate180"
    base.CAMERA_2_ORIENTATION = "clockwise"
    base.CAMERA_2_SCALE = 0.50

    base.OFFSET_MIN_SECONDS = 0.30
    base.OFFSET_MAX_SECONDS = 0.70
    base.OFFSET_STEP_SECONDS = 0.01

    base.main()


if __name__ == "__main__":
    main()