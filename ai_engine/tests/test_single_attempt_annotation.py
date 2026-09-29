from __future__ import annotations

from unittest import TestCase

from pydantic import ValidationError

from ai_engine.annotations.single_attempt_annotation import (
    PoseDetectionCount,
    SingleAttemptAnnotationDraft,
    SingleAttemptAnnotationSet,
    evaluate_detection_against_human_labels,
    finalize_annotation_draft,
    inspect_annotation_draft,
)


def _annotations() -> SingleAttemptAnnotationSet:
    return SingleAttemptAnnotationSet.model_validate(
        {
            "schema_version": "1.1.0",
            "annotation_type": "single_attempt_uchi_mata_ground_truth",
            "status": "complete",
            "source_screening_artifact": "runtime/screening.json",
            "source_screening_artifact_sha256": "b" * 64,
            "video": {
                "video_id": "authorized-video-1",
                "filename": "authorized.mp4",
                "sha256": "a" * 64,
                "width": 640,
                "height": 360,
                "source_fps": 25.0,
                "frame_count": 100,
                "duration_seconds": 4.0,
            },
            "selection": {
                "method": "distributed",
                "sample_count": 4,
                "same_timestamps_as_fast_screening": True,
                "pose_inference_run": False,
            },
            "reviewer": {
                "annotation_source": "human-reviewed",
                "reviewer_reference": "reviewer-1",
            },
            "reviewed_attempt": {
                "start": {"frame_index": 0, "timestamp_ms": 0},
                "end": {"frame_index": 3, "timestamp_ms": 120},
                "event_schema_id": "reviewed-event-pair-v1",
                "selection_source": "human-selected",
            },
            "selected_tori_subject_reference_id": "subject-1",
            "support_leg": {
                "side": "left",
                "confirmation_source": "human-confirmed",
            },
            "frames": [
                {
                    "sample_position": 0,
                    "frame": {"frame_index": 0, "timestamp_ms": 0},
                    "image": "frames/sample_000_f000000_t000000ms.jpg",
                    "visible_judoka_count": 2,
                    "visible_subject_reference_ids": ["subject-1", "subject-2"],
                    "selected_tori_subject_reference_id": "subject-1",
                    "occlusion": False,
                    "crossing": False,
                },
                {
                    "sample_position": 1,
                    "frame": {"frame_index": 1, "timestamp_ms": 40},
                    "image": "frames/sample_001_f000001_t000040ms.jpg",
                    "visible_judoka_count": 2,
                    "visible_subject_reference_ids": ["subject-1", "subject-2"],
                    "selected_tori_subject_reference_id": "subject-1",
                    "occlusion": True,
                    "crossing": True,
                },
                {
                    "sample_position": 2,
                    "frame": {"frame_index": 2, "timestamp_ms": 80},
                    "image": "frames/sample_002_f000002_t000080ms.jpg",
                    "visible_judoka_count": 1,
                    "visible_subject_reference_ids": ["subject-1"],
                    "selected_tori_subject_reference_id": "subject-1",
                    "occlusion": True,
                    "crossing": False,
                },
                {
                    "sample_position": 3,
                    "frame": {"frame_index": 3, "timestamp_ms": 120},
                    "image": "frames/sample_003_f000003_t000120ms.jpg",
                    "visible_judoka_count": 0,
                    "visible_subject_reference_ids": [],
                    "selected_tori_subject_reference_id": None,
                    "occlusion": False,
                    "crossing": False,
                },
            ],
        }
    )


class HumanAnnotationContractTest(TestCase):
    def test_unfilled_draft_is_versioned_but_cannot_be_ground_truth(self) -> None:
        draft = SingleAttemptAnnotationDraft.model_validate(
            {
                "schema_version": "1.1.0",
                "annotation_type": "single_attempt_uchi_mata_ground_truth_draft",
                "status": "awaiting_human_annotation",
                "source_screening_artifact": "runtime/screening.json",
                "source_screening_artifact_sha256": "b" * 64,
                "video": {
                    "video_id": "video-1",
                    "filename": "authorized.mp4",
                    "sha256": "a" * 64,
                    "width": 640,
                    "height": 360,
                    "source_fps": 25.0,
                    "frame_count": 100,
                    "duration_seconds": 4.0,
                },
                "selection": {
                    "method": "distributed",
                    "sample_count": 1,
                    "same_timestamps_as_fast_screening": True,
                    "pose_inference_run": False,
                },
                "human_review": {
                    "annotation_source": None,
                    "reviewer_reference": None,
                    "reviewer_notes": None,
                    "reviewed_attempt": None,
                    "selected_tori_subject_reference_id": None,
                    "support_leg": None,
                },
                "frames": [
                    {
                        "sample_position": 0,
                        "frame": {"frame_index": 0, "timestamp_ms": 0},
                        "image": "frames/sample_000_f000000_t000000ms.jpg",
                        "visible_judoka_count": None,
                        "visible_subject_reference_ids": None,
                        "selected_tori_subject_reference_id": None,
                        "occlusion": None,
                        "crossing": None,
                        "reviewer_notes": None,
                    }
                ],
            }
        )

        readiness = inspect_annotation_draft(draft)
        self.assertFalse(readiness.can_finalize)
        self.assertEqual(readiness.incomplete_frame_count, 1)
        self.assertIn(
            "reviewed_attempt",
            readiness.missing_human_review_fields,
        )
        self.assertFalse(readiness.labels_inferred_or_defaulted)

        with self.assertRaises(ValueError):
            finalize_annotation_draft(draft)

    def test_completed_draft_converts_to_valid_human_ground_truth(self) -> None:
        complete = _annotations()
        frame = complete.frames[0]
        draft = SingleAttemptAnnotationDraft.model_validate(
            {
                "schema_version": "1.1.0",
                "annotation_type": "single_attempt_uchi_mata_ground_truth_draft",
                "status": "awaiting_human_annotation",
                "source_screening_artifact": (
                    complete.source_screening_artifact
                ),
                "source_screening_artifact_sha256": (
                    complete.source_screening_artifact_sha256
                ),
                "video": complete.video.model_dump(mode="json"),
                "selection": {
                    "method": "distributed",
                    "sample_count": 1,
                    "same_timestamps_as_fast_screening": True,
                    "pose_inference_run": False,
                },
                "human_review": {
                    "annotation_source": "human-reviewed",
                    "reviewer_reference": "reviewer-1",
                    "reviewed_attempt": complete.reviewed_attempt.model_dump(
                        mode="json"
                    ),
                    "selected_tori_subject_reference_id": "subject-1",
                    "support_leg": complete.support_leg.model_dump(mode="json"),
                },
                "frames": [
                    {
                        "sample_position": 0,
                        "frame": frame.frame.model_dump(mode="json"),
                        "image": frame.image,
                        "visible_judoka_count": frame.visible_judoka_count,
                        "visible_subject_reference_ids": (
                            frame.visible_subject_reference_ids
                        ),
                        "selected_tori_subject_reference_id": "subject-1",
                        "occlusion": frame.occlusion,
                        "crossing": frame.crossing,
                    }
                ],
            }
        )

        finalized = finalize_annotation_draft(draft)
        self.assertEqual(finalized.reviewer.annotation_source, "human-reviewed")
        self.assertEqual(finalized.frames[0].visible_judoka_count, 2)
        self.assertEqual(
            finalized.source_screening_artifact_sha256,
            "b" * 64,
        )
        self.assertEqual(finalized.frames[0].sample_position, 0)
        self.assertEqual(
            finalized.frames[0].image,
            "frames/sample_000_f000000_t000000ms.jpg",
        )
        self.assertTrue(inspect_annotation_draft(draft).can_finalize)

    def test_rejects_unsafe_or_duplicate_review_image_paths(self) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["frames"][0]["image"] = "../outside.jpg"
        with self.assertRaisesRegex(
            ValidationError,
            "relative JPEG inside the frames directory",
        ):
            SingleAttemptAnnotationSet.model_validate(payload)

        payload = _annotations().model_dump(mode="json")
        payload["frames"][1]["image"] = payload["frames"][0]["image"]
        with self.assertRaisesRegex(
            ValidationError,
            "review image paths must be unique",
        ):
            SingleAttemptAnnotationSet.model_validate(payload)

    def test_rejects_noncontiguous_sample_positions(self) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["frames"][2]["sample_position"] = 4

        with self.assertRaisesRegex(
            ValidationError,
            "sample positions must be contiguous and ordered",
        ):
            SingleAttemptAnnotationSet.model_validate(payload)

    def test_rejects_review_image_attached_to_the_wrong_frame(self) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["frames"][0]["image"] = (
            "frames/sample_000_f000001_t000040ms.jpg"
        )

        with self.assertRaisesRegex(
            ValidationError,
            "does not match its sample position",
        ):
            SingleAttemptAnnotationSet.model_validate(payload)

    def test_evaluates_two_person_detection_conditionally_on_visibility(self) -> None:
        annotations = _annotations()
        predictions = [
            PoseDetectionCount(
                frame=row.frame,
                detected_person_count=count,
                engine_id="engine-a",
            )
            for row, count in zip(annotations.frames, (2, 1, 1, 1), strict=True)
        ]

        result = evaluate_detection_against_human_labels(annotations, predictions)

        self.assertEqual(result.matched_frame_count, 4)
        self.assertEqual(result.frames_with_at_least_two_visible_judoka, 2)
        self.assertEqual(result.frames_with_two_detections_when_at_least_two_visible, 1)
        self.assertEqual(result.two_detection_coverage_given_two_visible, 0.5)
        self.assertEqual(result.detection_coverage_given_at_least_one_visible, 1.0)
        self.assertEqual(result.frames_with_detection_deficit, 1)
        self.assertEqual(result.frames_with_detection_surplus, 1)
        self.assertEqual(result.schema_version, "1.2.0")
        self.assertFalse(result.coverage_is_confidence)
        crossing = next(
            item
            for item in result.conditional_slices
            if item.condition == "crossing_present"
        )
        self.assertEqual(crossing.annotated_frame_count, 1)
        self.assertEqual(crossing.two_detection_coverage_given_two_visible, 0.0)
        both = next(
            item
            for item in result.conditional_slices
            if item.condition == "occlusion_and_crossing"
        )
        occlusion_only = next(
            item
            for item in result.conditional_slices
            if item.condition == "occlusion_without_crossing"
        )
        crossing_only = next(
            item
            for item in result.conditional_slices
            if item.condition == "crossing_without_occlusion"
        )
        self.assertEqual(both.annotated_frame_count, 1)
        self.assertEqual(both.two_detection_coverage_given_two_visible, 0.0)
        self.assertEqual(occlusion_only.annotated_frame_count, 1)
        self.assertIsNone(
            occlusion_only.two_detection_coverage_given_two_visible
        )
        self.assertEqual(crossing_only.annotated_frame_count, 0)

        payload = result.model_dump(mode="json")
        crossing_only_payload = next(
            item
            for item in payload["conditional_slices"]
            if item["condition"] == "crossing_without_occlusion"
        )
        crossing_only_payload["annotated_frame_count"] = 1
        crossing_only_payload["matched_prediction_count"] = 1
        with self.assertRaisesRegex(
            ValidationError,
            "must partition the all-frame metrics",
        ):
            type(result).model_validate(payload)

    def test_missing_predictions_are_explicit_and_not_counted_as_detection(
        self,
    ) -> None:
        annotations = _annotations()
        result = evaluate_detection_against_human_labels(
            annotations,
            [
                PoseDetectionCount(
                    frame=annotations.frames[0].frame,
                    detected_person_count=2,
                    engine_id="engine-a",
                )
            ],
        )

        self.assertEqual(result.matched_frame_count, 1)
        self.assertEqual(result.missing_prediction_count, 3)
        self.assertEqual(result.two_detection_coverage_given_two_visible, 0.5)
        self.assertAlmostEqual(
            result.detection_coverage_given_at_least_one_visible or 0.0,
            1 / 3,
        )
        self.assertEqual(result.frames_with_detection_deficit, 2)

    def test_reports_predictions_outside_the_human_review_set(self) -> None:
        annotations = _annotations()
        predictions = [
            PoseDetectionCount(
                frame=annotations.frames[0].frame,
                detected_person_count=2,
                engine_id="engine-a",
            ),
            PoseDetectionCount(
                frame={"frame_index": 99, "timestamp_ms": 3960},
                detected_person_count=2,
                engine_id="engine-a",
            ),
        ]

        result = evaluate_detection_against_human_labels(annotations, predictions)
        self.assertEqual(result.unexpected_prediction_count, 1)

    def test_zero_two_visible_frames_withholds_conditional_rate(self) -> None:
        payload = _annotations().model_dump(mode="json")
        for row in payload["frames"]:
            row["visible_judoka_count"] = min(row["visible_judoka_count"], 1)
            row["visible_subject_reference_ids"] = row[
                "visible_subject_reference_ids"
            ][:1]
        annotations = SingleAttemptAnnotationSet.model_validate(payload)
        predictions = [
            PoseDetectionCount(
                frame=row.frame,
                detected_person_count=1,
                engine_id="engine-a",
            )
            for row in annotations.frames
        ]

        result = evaluate_detection_against_human_labels(annotations, predictions)
        self.assertIsNone(result.two_detection_coverage_given_two_visible)

    def test_rejects_non_human_source_and_inconsistent_tori_selection(self) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["reviewer"]["annotation_source"] = "AI-inferred"
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

        payload = _annotations().model_dump(mode="json")
        payload["selected_tori_subject_reference_id"] = "subject-absent"
        for frame in payload["frames"]:
            frame["selected_tori_subject_reference_id"] = None
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

        payload = _annotations().model_dump(mode="json")
        payload["selected_tori_subject_reference_id"] = "Tori"
        payload["frames"][0]["visible_subject_reference_ids"][0] = "Tori"
        payload["frames"][0]["selected_tori_subject_reference_id"] = "Tori"
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

        payload = _annotations().model_dump(mode="json")
        payload["frames"][0]["visible_subject_reference_ids"][0] = (
            "subject-tori"
        )
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

        payload = _annotations().model_dump(mode="json")
        payload["frames"][0]["selected_tori_subject_reference_id"] = "subject-2"
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

    def test_rejects_mixed_engines_and_duplicate_prediction_frames(self) -> None:
        annotations = _annotations()
        first = PoseDetectionCount(
            frame=annotations.frames[0].frame,
            detected_person_count=2,
            engine_id="engine-a",
        )
        with self.assertRaises(ValueError):
            evaluate_detection_against_human_labels(
                annotations,
                [
                    first,
                    PoseDetectionCount(
                        frame=annotations.frames[1].frame,
                        detected_person_count=2,
                        engine_id="engine-b",
                    ),
                ],
            )

        with self.assertRaises(ValueError):
            evaluate_detection_against_human_labels(annotations, [first, first])

    def test_rejects_source_timebase_subset_and_attempt_identity_mismatches(
        self,
    ) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["frames"][1]["frame"]["timestamp_ms"] = 41
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

        payload = _annotations().model_dump(mode="json")
        payload["selection"]["sample_count"] = 3
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

        payload = _annotations().model_dump(mode="json")
        payload["reviewed_attempt"] = {
            "start": {"frame_index": 2, "timestamp_ms": 80},
            "end": {"frame_index": 3, "timestamp_ms": 120},
            "event_schema_id": "reviewed-event-pair-v1",
            "selection_source": "human-selected",
        }
        payload["frames"][2]["selected_tori_subject_reference_id"] = None
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

    def test_normalizes_role_neutral_subject_references(self) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["selected_tori_subject_reference_id"] = " subject-1 "
        payload["frames"][0]["visible_subject_reference_ids"][0] = (
            " subject-1 "
        )
        payload["frames"][0]["selected_tori_subject_reference_id"] = (
            " subject-1 "
        )

        annotations = SingleAttemptAnnotationSet.model_validate(payload)
        self.assertEqual(
            annotations.selected_tori_subject_reference_id,
            "subject-1",
        )
        self.assertEqual(
            annotations.frames[0].visible_subject_reference_ids[0],
            "subject-1",
        )

    def test_rejects_non_finite_video_metadata(self) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["video"]["source_fps"] = float("inf")
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

    def test_rejects_boolean_or_float_integer_evidence(self) -> None:
        payload = _annotations().model_dump(mode="json")
        payload["frames"][0]["visible_judoka_count"] = True
        with self.assertRaises(ValidationError):
            SingleAttemptAnnotationSet.model_validate(payload)

        with self.assertRaises(ValidationError):
            PoseDetectionCount(
                frame={"frame_index": 0, "timestamp_ms": 0},
                detected_person_count=True,
                engine_id="engine-a",
            )

        with self.assertRaises(ValidationError):
            PoseDetectionCount(
                frame={"frame_index": 0.0, "timestamp_ms": 0},
                detected_person_count=1,
                engine_id="engine-a",
            )
