from __future__ import annotations

from unittest import TestCase

from ai_engine.tracking.experimental_rtmlib_iou_tracker import (
    ExperimentalRTMLibIoUTracker,
)
from ai_engine.tracking.identity_contract import (
    BoundingBox2D,
    NeutralIdentityTracker,
    PoseDetection2D,
)


def _detection(
    detection_index: int,
    left: float,
    *,
    width: float = 20.0,
) -> PoseDetection2D:
    return PoseDetection2D(
        detection_index=detection_index,
        bounding_box=BoundingBox2D(left, 0.0, left + width, 40.0),
        keypoints=((left + 5.0, 10.0),),
        keypoint_scores=(0.9,),
    )


class ExperimentalRTMLibIoUTrackerTest(TestCase):
    def test_creates_neutral_track_a_and_b_and_implements_protocol(self) -> None:
        tracker: NeutralIdentityTracker = ExperimentalRTMLibIoUTracker()
        observations = tracker.update(
            (_detection(0, 0.0), _detection(1, 100.0)),
            frame_index=0,
            timestamp_ms=0,
        )

        self.assertEqual(
            tuple(observation.track_id for observation in observations),
            ("Track A", "Track B"),
        )
        self.assertTrue(all(item.status == "tentative" for item in observations))
        self.assertNotIn("Tori", repr(observations))
        self.assertNotIn("Uke", repr(observations))

    def test_stable_two_person_continuation_is_one_to_one(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(0, 0.0), _detection(1, 100.0)),
            frame_index=0,
            timestamp_ms=0,
        )
        observations = tracker.update(
            (_detection(0, 2.0), _detection(1, 102.0)),
            frame_index=1,
            timestamp_ms=40,
        )

        active = [item for item in observations if item.detection is not None]
        self.assertEqual(len(active), 2)
        self.assertEqual({item.track_id for item in active}, {"Track A", "Track B"})
        self.assertEqual(
            len({item.detection.detection_index for item in active}),
            2,
        )
        self.assertTrue(all(item.status == "confirmed" for item in active))

    def test_detection_order_swap_does_not_swap_identity(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(0, 0.0), _detection(1, 100.0)),
            frame_index=0,
            timestamp_ms=0,
        )
        observations = tracker.update(
            (_detection(0, 102.0), _detection(1, 2.0)),
            frame_index=1,
            timestamp_ms=40,
        )
        by_track = {item.track_id: item for item in observations}

        self.assertEqual(by_track["Track A"].detection.detection_index, 1)
        self.assertEqual(by_track["Track B"].detection.detection_index, 0)
        self.assertEqual(
            {event.event_type for event in tracker.last_events},
            {"detection_order_changed"},
        )

    def test_ambiguous_overlap_fails_closed(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(0, 0.0), _detection(1, 12.0)),
            frame_index=0,
            timestamp_ms=0,
        )
        observations = tracker.update(
            (_detection(0, 5.0), _detection(1, 7.0)),
            frame_index=1,
            timestamp_ms=40,
        )

        self.assertTrue(all(item.status == "lost" for item in observations))
        self.assertTrue(
            all(
                decision.status == "review_required"
                for decision in tracker.last_decisions
            )
        )
        self.assertTrue(
            any(
                "ambiguous_overlap" in decision.uncertainty_reasons
                for decision in tracker.last_decisions
            )
        )
        self.assertIn("crossing", {event.event_type for event in tracker.last_events})

    def test_disappearance_marks_track_lost(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(0, 0.0),),
            frame_index=0,
            timestamp_ms=0,
        )
        observations = tracker.update((), frame_index=1, timestamp_ms=40)

        self.assertEqual(len(observations), 1)
        self.assertEqual(observations[0].track_id, "Track A")
        self.assertEqual(observations[0].status, "lost")
        self.assertIsNone(observations[0].detection)
        self.assertEqual(tracker.last_events[0].event_type, "disappeared")

    def test_reappearance_is_new_and_not_silently_verified(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(0, 0.0),),
            frame_index=0,
            timestamp_ms=0,
        )
        tracker.update((), frame_index=1, timestamp_ms=40)
        observations = tracker.update(
            (_detection(7, 1.0),),
            frame_index=2,
            timestamp_ms=80,
        )

        by_track = {item.track_id: item for item in observations}
        self.assertEqual(by_track["Track A"].status, "lost")
        self.assertEqual(by_track["Track B"].status, "tentative")
        decision = next(
            item for item in tracker.last_decisions if item.track_id == "Track B"
        )
        self.assertEqual(decision.status, "review_required")
        self.assertIn("reappearance_not_verified", decision.uncertainty_reasons)

    def test_occlusion_collapse_does_not_transfer_identity(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(0, 0.0), _detection(1, 100.0)),
            frame_index=0,
            timestamp_ms=0,
        )
        observations = tracker.update(
            (_detection(0, 2.0),),
            frame_index=1,
            timestamp_ms=40,
        )

        self.assertTrue(all(item.status == "lost" for item in observations))
        self.assertFalse(any(item.detection is not None for item in observations))
        self.assertTrue(
            any(
                "occlusion" in decision.uncertainty_reasons
                for decision in tracker.last_decisions
            )
        )

    def test_reset_clears_state_and_restarts_neutral_labels(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(4, 100.0),),
            frame_index=10,
            timestamp_ms=400,
        )
        tracker.reset()
        observations = tracker.update(
            (_detection(9, 0.0),),
            frame_index=0,
            timestamp_ms=0,
        )

        self.assertEqual(len(observations), 1)
        self.assertEqual(observations[0].track_id, "Track A")

    def test_association_confidence_is_always_unavailable(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        tracker.update(
            (_detection(0, 0.0),),
            frame_index=0,
            timestamp_ms=0,
        )
        observations = tracker.update(
            (_detection(0, 1.0),),
            frame_index=1,
            timestamp_ms=40,
        )

        self.assertTrue(
            all(item.association_confidence is None for item in observations)
        )
        self.assertTrue(
            all(
                decision.association_confidence is None
                and "association_confidence_unavailable"
                in decision.uncertainty_reasons
                for decision in tracker.last_decisions
            )
        )

    def test_duplicate_detection_indices_are_rejected(self) -> None:
        tracker = ExperimentalRTMLibIoUTracker()
        with self.assertRaisesRegex(ValueError, "unique"):
            tracker.update(
                (_detection(0, 0.0), _detection(0, 100.0)),
                frame_index=0,
                timestamp_ms=0,
            )
