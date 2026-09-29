from __future__ import annotations

from unittest import TestCase

from ai_engine.video_sampling import (
    BOUNDED_REVIEW_CONTEXT_STRATEGY,
    GUIDED_REVIEW_CONTEXT_MAX_PREROLL_MS,
    HUMAN_SELECTED_FRAME_STRATEGY,
    SAMPLING_STRATEGY,
    build_bounded_review_context_plan,
    build_human_selected_frame_plan,
    build_video_sampling_plan,
    select_distributed_sampling_subset,
)


class VideoSamplingPlanTest(TestCase):
    def test_bounded_review_context_is_time_based_and_retains_review_frame(
        self,
    ) -> None:
        plan = build_bounded_review_context_plan(
            source_fps=30.0,
            frame_count=395,
            attempt_start_frame=0,
            review_frame=64,
        )

        self.assertEqual(plan.frame_indices, tuple(range(49, 65)))
        self.assertEqual(plan.timestamps_ms[0], 1633)
        self.assertEqual(plan.timestamps_ms[-1], 2133)
        self.assertLessEqual(
            plan.timestamps_ms[-1] - plan.timestamps_ms[0],
            GUIDED_REVIEW_CONTEXT_MAX_PREROLL_MS,
        )
        self.assertEqual(plan.strategy, BOUNDED_REVIEW_CONTEXT_STRATEGY)

    def test_bounded_review_context_never_crosses_attempt_start(self) -> None:
        plan = build_bounded_review_context_plan(
            source_fps=30.0,
            frame_count=395,
            attempt_start_frame=55,
            review_frame=64,
        )

        self.assertEqual(plan.frame_indices, tuple(range(55, 65)))
        self.assertEqual(plan.timestamps_ms[-1], 2133)

    def test_bounded_review_context_rejects_invalid_boundaries(self) -> None:
        for values in (
            {"attempt_start_frame": 65, "review_frame": 64},
            {"attempt_start_frame": -1, "review_frame": 64},
            {"attempt_start_frame": 0, "review_frame": 395},
            {"attempt_start_frame": 0, "review_frame": 64, "max_preroll_ms": -1},
        ):
            with self.subTest(values=values):
                with self.assertRaises(ValueError):
                    build_bounded_review_context_plan(
                        source_fps=30.0,
                        frame_count=395,
                        **values,
                    )

    def test_human_selected_frame_plan_preserves_exact_source_time(self) -> None:
        plan = build_human_selected_frame_plan(
            source_fps=25.0,
            frame_count=2768,
            frame_index=55,
        )

        self.assertEqual(plan.frame_indices, (55,))
        self.assertEqual(plan.timestamps_ms, (2200,))
        self.assertEqual(plan.strategy, HUMAN_SELECTED_FRAME_STRATEGY)
        self.assertEqual(plan.requested_target_fps, 25.0)

    def test_human_selected_frame_plan_rejects_invalid_source_frame(self) -> None:
        for frame_index in (-1, 10, True):
            with self.subTest(frame_index=frame_index):
                with self.assertRaises(ValueError):
                    build_human_selected_frame_plan(
                        source_fps=25.0,
                        frame_count=10,
                        frame_index=frame_index,
                    )

    def test_25_fps_to_10_fps_uses_ten_nearest_frames_per_second(
        self,
    ) -> None:
        plan = build_video_sampling_plan(
            source_fps=25.0,
            target_fps=10.0,
            frame_count=25,
        )

        self.assertEqual(
            plan.frame_indices,
            (0, 3, 5, 8, 10, 13, 15, 18, 20, 23),
        )
        self.assertEqual(plan.planned_frame_count, 10)
        self.assertEqual(plan.strategy, SAMPLING_STRATEGY)
        self.assertEqual(plan.nominal_interval_frames, 2.5)

    def test_plan_matches_previous_real_video_boundary_count(self) -> None:
        plan = build_video_sampling_plan(
            source_fps=25.0,
            target_fps=10.0,
            frame_count=593,
        )

        self.assertEqual(plan.planned_frame_count, 238)
        self.assertEqual(plan.frame_indices[0], 0)
        self.assertEqual(plan.frame_indices[-1], 592)
        self.assertEqual(len(set(plan.frame_indices)), 238)

    def test_target_above_source_rate_never_duplicates_frames(self) -> None:
        plan = build_video_sampling_plan(
            source_fps=24.0,
            target_fps=30.0,
            frame_count=5,
        )

        self.assertEqual(plan.frame_indices, (0, 1, 2, 3, 4))
        self.assertEqual(plan.effective_target_fps, 24.0)

    def test_representative_source_rates_have_stable_boundaries(self) -> None:
        for source_fps in (24.0, 25.0, 30.0, 50.0, 60.0):
            with self.subTest(source_fps=source_fps):
                frame_count = int(source_fps * 2)
                plan = build_video_sampling_plan(
                    source_fps=source_fps,
                    target_fps=10.0,
                    frame_count=frame_count,
                )

                self.assertEqual(plan.frame_indices[0], 0)
                self.assertLess(plan.frame_indices[-1], frame_count)
                self.assertEqual(plan.planned_frame_count, 20)
                self.assertEqual(
                    len(set(plan.frame_indices)),
                    plan.planned_frame_count,
                )
                self.assertTrue(
                    all(
                        current > previous
                        for previous, current in zip(
                            plan.timestamps_ms,
                            plan.timestamps_ms[1:],
                        )
                    )
                )

    def test_non_integer_source_fps_is_deterministic(self) -> None:
        first = build_video_sampling_plan(
            source_fps=29.97,
            target_fps=10.0,
            frame_count=300,
        )
        second = build_video_sampling_plan(
            source_fps=29.97,
            target_fps=10.0,
            frame_count=300,
        )

        self.assertEqual(first, second)
        self.assertEqual(first.planned_frame_count, 101)
        self.assertEqual(first.frame_indices[0], 0)
        self.assertEqual(first.frame_indices[-1], 299)
        self.assertEqual(len(set(first.timestamps_ms)), 101)

    def test_short_clip_still_samples_first_frame_without_overrun(self) -> None:
        plan = build_video_sampling_plan(
            source_fps=60.0,
            target_fps=10.0,
            frame_count=1,
        )

        self.assertEqual(plan.frame_indices, (0,))
        self.assertEqual(plan.timestamps_ms, (0,))

    def test_integer_millisecond_ties_never_duplicate_timestamps(self) -> None:
        plan = build_video_sampling_plan(
            source_fps=2000.0,
            target_fps=800.0,
            frame_count=20,
        )

        self.assertEqual(len(set(plan.timestamps_ms)), len(plan.timestamps_ms))
        self.assertTrue(
            all(
                current > previous
                for previous, current in zip(
                    plan.timestamps_ms,
                    plan.timestamps_ms[1:],
                )
            )
        )

    def test_zero_frame_video_has_empty_plan(self) -> None:
        plan = build_video_sampling_plan(
            source_fps=30.0,
            target_fps=10.0,
            frame_count=0,
        )

        self.assertEqual(plan.frame_indices, ())
        self.assertEqual(plan.timestamps_ms, ())

    def test_invalid_rates_are_rejected(self) -> None:
        for source_fps, target_fps in (
            (0.0, 10.0),
            (25.0, 0.0),
            (float("nan"), 10.0),
        ):
            with self.subTest(
                source_fps=source_fps,
                target_fps=target_fps,
            ):
                with self.assertRaises(ValueError):
                    build_video_sampling_plan(
                        source_fps=source_fps,
                        target_fps=target_fps,
                        frame_count=100,
                    )

    def test_invalid_frame_counts_are_rejected(self) -> None:
        for frame_count in (-1, 2.5, True):
            with self.subTest(frame_count=frame_count):
                with self.assertRaises(ValueError):
                    build_video_sampling_plan(
                        source_fps=25.0,
                        target_fps=10.0,
                        frame_count=frame_count,
                    )

    def test_fast_screening_subset_is_full_span_and_deterministic(self) -> None:
        plan = build_video_sampling_plan(
            source_fps=25.0,
            target_fps=10.0,
            frame_count=2768,
        )

        first = select_distributed_sampling_subset(
            plan,
            maximum_frames=100,
        )
        second = select_distributed_sampling_subset(
            plan,
            maximum_frames=100,
        )

        self.assertEqual(first, second)
        self.assertEqual(first.planned_frame_count, 100)
        self.assertEqual(first.frame_indices[0], plan.frame_indices[0])
        self.assertEqual(first.frame_indices[-1], plan.frame_indices[-1])
        self.assertEqual(first.timestamps_ms[0], 0)
        self.assertEqual(first.timestamps_ms[-1], 110680)
        self.assertEqual(len(set(first.frame_indices)), 100)

    def test_one_frame_subset_uses_temporal_midpoint(self) -> None:
        plan = build_video_sampling_plan(
            source_fps=25.0,
            target_fps=10.0,
            frame_count=25,
        )

        subset = select_distributed_sampling_subset(
            plan,
            maximum_frames=1,
        )

        self.assertEqual(subset.frame_indices, (13,))
        self.assertEqual(subset.timestamps_ms, (520,))
