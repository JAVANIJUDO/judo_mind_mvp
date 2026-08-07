from __future__ import annotations

"""Full-resolution, memory-safe dual-hold timeline diagnostic runner."""

import stereo_dual_hold_timeline_diagnostic_v2_20260807 as base


def main() -> None:
    # Streaming keeps memory bounded; full resolution restores the pose
    # precision used by the earlier hold-pairing validation.
    base.CAMERA_2_SCALE = 1.0
    base.main()


if __name__ == "__main__":
    main()