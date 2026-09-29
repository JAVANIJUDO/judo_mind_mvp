from __future__ import annotations

from dataclasses import dataclass
import math


SAMPLING_STRATEGY = "nearest_source_frame_to_target_timestamp"
HUMAN_SELECTED_FRAME_STRATEGY = "human_selected_source_frame"
BOUNDED_REVIEW_CONTEXT_STRATEGY = (
    "bounded_video_context_for_human_selected_review_frame"
)
GUIDED_REVIEW_CONTEXT_MAX_PREROLL_MS = 500
MILLISECONDS_PER_SECOND = 1000.0


def _validate_rate(name: str, value: float) -> float:
    rate = float(value)

    if not math.isfinite(rate) or rate <= 0:
        raise ValueError(f"{name} must be a finite positive number.")

    return rate


def _nearest_frame_index(
    sample_number: int,
    source_fps: float,
    effective_target_fps: float,
) -> int:
    exact_index = sample_number * source_fps / effective_target_fps

    # Explicit half-up rounding avoids Python's alternating tie behavior and
    # makes the selected source-frame sequence reproducible across engines.
    return int(math.floor(exact_index + 0.5))


def _frame_timestamp_ms(frame_index: int, source_fps: float) -> int:
    """Map a source frame to MediaPipe's integer-millisecond timebase."""

    exact_timestamp_ms = (
        frame_index / source_fps * MILLISECONDS_PER_SECOND
    )

    # Half-up rounding is deterministic and, unlike Python's bankers rounding,
    # does not collapse adjacent samples at exact x.5 millisecond ties.
    return int(math.floor(exact_timestamp_ms + 0.5))


@dataclass(frozen=True)
class VideoSamplingPlan:
    """Deterministic source frames nearest to fixed target timestamps."""

    source_fps: float
    requested_target_fps: float
    effective_target_fps: float
    frame_count: int
    frame_indices: tuple[int, ...]
    timestamps_ms: tuple[int, ...]
    strategy: str = SAMPLING_STRATEGY

    @property
    def nominal_interval_frames(self) -> float:
        return self.source_fps / self.effective_target_fps

    @property
    def planned_frame_count(self) -> int:
        return len(self.frame_indices)


def build_video_sampling_plan(
    *,
    source_fps: float,
    target_fps: float,
    frame_count: int,
) -> VideoSamplingPlan:
    """Build one reusable sampling plan for a video and target rate.

    Target timestamps start at zero and continue while they fall inside the
    nominal video duration. Each timestamp maps to its nearest source frame.
    The last mapping is clamped to the last available frame because a video
    frame represents the interval until the following frame boundary.
    """

    validated_source_fps = _validate_rate("source_fps", source_fps)
    validated_target_fps = _validate_rate("target_fps", target_fps)

    if isinstance(frame_count, bool) or not isinstance(frame_count, int):
        raise ValueError("frame_count must be an integer.")

    if frame_count < 0:
        raise ValueError("frame_count must be greater than or equal to zero.")

    effective_target_fps = min(
        validated_source_fps,
        validated_target_fps,
        MILLISECONDS_PER_SECOND,
    )

    if frame_count == 0:
        frame_indices: tuple[int, ...] = ()
    elif effective_target_fps == validated_source_fps:
        frame_indices = tuple(range(frame_count))
    else:
        exact_sample_count = (
            frame_count
            * effective_target_fps
            / validated_source_fps
        )
        sample_count = max(
            1,
            math.ceil(exact_sample_count - 1e-12),
        )
        selected: list[int] = []

        for sample_number in range(sample_count):
            frame_index = min(
                frame_count - 1,
                _nearest_frame_index(
                    sample_number,
                    validated_source_fps,
                    effective_target_fps,
                ),
            )

            if not selected or frame_index != selected[-1]:
                selected.append(frame_index)

        frame_indices = tuple(selected)

    timestamps_ms = tuple(
        _frame_timestamp_ms(frame_index, validated_source_fps)
        for frame_index in frame_indices
    )

    if any(
        current <= previous
        for previous, current in zip(timestamps_ms, timestamps_ms[1:])
    ):
        raise RuntimeError(
            "Sampling plan produced non-increasing millisecond timestamps."
        )

    return VideoSamplingPlan(
        source_fps=validated_source_fps,
        requested_target_fps=validated_target_fps,
        effective_target_fps=effective_target_fps,
        frame_count=frame_count,
        frame_indices=frame_indices,
        timestamps_ms=timestamps_ms,
    )


def select_distributed_sampling_subset(
    sampling_plan: VideoSamplingPlan,
    *,
    maximum_frames: int,
) -> VideoSamplingPlan:
    """Select an evenly distributed full-span subset without content bias."""

    if isinstance(maximum_frames, bool) or not isinstance(maximum_frames, int):
        raise ValueError("maximum_frames must be an integer.")

    if maximum_frames < 1:
        raise ValueError("maximum_frames must be positive.")

    available = sampling_plan.planned_frame_count

    if available <= maximum_frames:
        return sampling_plan

    if maximum_frames == 1:
        selected_positions = (available // 2,)
    else:
        selected_positions = tuple(
            int(math.floor(
                sample_number
                * (available - 1)
                / (maximum_frames - 1)
                + 0.5
            ))
            for sample_number in range(maximum_frames)
        )

    if len(set(selected_positions)) != len(selected_positions):
        raise RuntimeError("Distributed subset produced duplicate positions.")

    return VideoSamplingPlan(
        source_fps=sampling_plan.source_fps,
        requested_target_fps=sampling_plan.requested_target_fps,
        effective_target_fps=sampling_plan.effective_target_fps,
        frame_count=sampling_plan.frame_count,
        frame_indices=tuple(
            sampling_plan.frame_indices[position]
            for position in selected_positions
        ),
        timestamps_ms=tuple(
            sampling_plan.timestamps_ms[position]
            for position in selected_positions
        ),
        strategy=sampling_plan.strategy,
    )


def build_human_selected_frame_plan(
    *,
    source_fps: float,
    frame_count: int,
    frame_index: int,
) -> VideoSamplingPlan:
    """Build a one-frame plan without introducing a scientific FPS rule."""

    validated_source_fps = _validate_rate("source_fps", source_fps)

    if isinstance(frame_count, bool) or not isinstance(frame_count, int):
        raise ValueError("frame_count must be an integer.")

    if frame_count < 1:
        raise ValueError("A selected-frame plan requires a non-empty video.")

    if isinstance(frame_index, bool) or not isinstance(frame_index, int):
        raise ValueError("frame_index must be an integer.")

    if not 0 <= frame_index < frame_count:
        raise ValueError("Selected frame is outside the source video.")

    return VideoSamplingPlan(
        source_fps=validated_source_fps,
        requested_target_fps=validated_source_fps,
        effective_target_fps=min(validated_source_fps, MILLISECONDS_PER_SECOND),
        frame_count=frame_count,
        frame_indices=(frame_index,),
        timestamps_ms=(_frame_timestamp_ms(frame_index, validated_source_fps),),
        strategy=HUMAN_SELECTED_FRAME_STRATEGY,
    )


def build_bounded_review_context_plan(
    *,
    source_fps: float,
    frame_count: int,
    attempt_start_frame: int,
    review_frame: int,
    max_preroll_ms: int = GUIDED_REVIEW_CONTEXT_MAX_PREROLL_MS,
) -> VideoSamplingPlan:
    """Build bounded VIDEO-mode context ending at an exact review frame.

    The preceding frames are an engineering warm-up for the pose engine only.
    They are not analysis observations and the caller must discard their pose
    outputs. The plan never crosses the human-confirmed attempt start.
    """

    validated_source_fps = _validate_rate("source_fps", source_fps)

    if isinstance(frame_count, bool) or not isinstance(frame_count, int):
        raise ValueError("frame_count must be an integer.")
    if frame_count < 1:
        raise ValueError("A contextual review plan requires a non-empty video.")
    for name, value in (
        ("attempt_start_frame", attempt_start_frame),
        ("review_frame", review_frame),
    ):
        if isinstance(value, bool) or not isinstance(value, int):
            raise ValueError(f"{name} must be an integer.")
        if not 0 <= value < frame_count:
            raise ValueError(f"{name} is outside the source video.")
    if attempt_start_frame > review_frame:
        raise ValueError("Review frame must not precede the attempt start.")
    if isinstance(max_preroll_ms, bool) or not isinstance(max_preroll_ms, int):
        raise ValueError("max_preroll_ms must be an integer.")
    if max_preroll_ms < 0:
        raise ValueError("max_preroll_ms must be non-negative.")

    review_timestamp_ms = _frame_timestamp_ms(
        review_frame,
        validated_source_fps,
    )
    context_start_frame = review_frame
    while context_start_frame > attempt_start_frame:
        preceding_frame = context_start_frame - 1
        preceding_timestamp_ms = _frame_timestamp_ms(
            preceding_frame,
            validated_source_fps,
        )
        if review_timestamp_ms - preceding_timestamp_ms > max_preroll_ms:
            break
        context_start_frame = preceding_frame

    frame_indices = tuple(range(context_start_frame, review_frame + 1))
    timestamps_ms = tuple(
        _frame_timestamp_ms(frame_index, validated_source_fps)
        for frame_index in frame_indices
    )

    if timestamps_ms[-1] != review_timestamp_ms:
        raise RuntimeError("Context plan did not retain the exact review frame.")
    if any(
        current <= previous
        for previous, current in zip(timestamps_ms, timestamps_ms[1:])
    ):
        raise RuntimeError("Context plan produced non-increasing timestamps.")

    return VideoSamplingPlan(
        source_fps=validated_source_fps,
        requested_target_fps=validated_source_fps,
        effective_target_fps=min(validated_source_fps, MILLISECONDS_PER_SECOND),
        frame_count=frame_count,
        frame_indices=frame_indices,
        timestamps_ms=timestamps_ms,
        strategy=BOUNDED_REVIEW_CONTEXT_STRATEGY,
    )
