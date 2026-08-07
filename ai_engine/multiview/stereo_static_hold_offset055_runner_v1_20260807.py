from __future__ import annotations

"""Static-hold stereo test with the fine-search +0.55 s video correction."""

import copy
from pathlib import Path

import stereo_static_hold_calibration_v1_20260807 as base
from stereo_static_hold_calibration_v3_20260807 import (
    fixed_orientation,
    intrinsic_orient_frame,
)


VIDEO_CORRECTION_SECONDS = 0.55


def main() -> None:
    base.orient_frame = intrinsic_orient_frame
    base.select_orientation = fixed_orientation

    original_load_json = base.load_json

    def adjusted_load_json(path: Path) -> dict:
        data = original_load_json(path)
        if "time_mapping" not in data:
            return data
        adjusted = copy.deepcopy(data)
        original = float(adjusted["time_mapping"]["intercept_seconds"])
        adjusted["time_mapping"]["intercept_seconds"] = (
            original + VIDEO_CORRECTION_SECONDS
        )
        print(
            "Applying geometric video correction: "
            f"{VIDEO_CORRECTION_SECONDS:+.3f} s"
        )
        return adjusted

    base.load_json = adjusted_load_json
    base.main()


if __name__ == "__main__":
    main()