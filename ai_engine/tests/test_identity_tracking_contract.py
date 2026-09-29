from __future__ import annotations

import math
from unittest import TestCase

from ai_engine.tracking.identity_contract import (
    AI_INFERRED,
    AnnotatedTrackAssignment,
    BoundingBox2D,
    HumanRoleConfirmation,
    NeutralTrackObservation,
    NeutralTrackEvent,
    PoseDetection2D,
    PoseFrameObservation,
    TrackAssociationDecision,
    evaluate_tracking_assignments,
    neutral_track_label,
)


class IdentityTrackingContractTest(TestCase):
    def _detection(self, detection_index: int = 0) -> PoseDetection2D:
        return PoseDetection2D(
            detection_index=detection_index,
            bounding_box=BoundingBox2D(0.0, 0.0, 10.0, 20.0),
            keypoints=((2.0, 3.0),),
            keypoint_scores=(0.9,),
        )

    def test_generates_role_neutral_labels(self) -> None:
        self.assertEqual(neutral_track_label(0), "Track A")
        self.assertEqual(neutral_track_label(1), "Track B")
        self.assertEqual(neutral_track_label(26), "Track AA")

    def test_rejects_tori_or_uke_as_tracking_identity(self) -> None:
        detection = PoseDetection2D(
            detection_index=0,
            bounding_box=BoundingBox2D(0.0, 0.0, 10.0, 20.0),
            keypoints=((2.0, 3.0),),
            keypoint_scores=(0.9,),
        )

        with self.assertRaises(ValueError):
            NeutralTrackObservation(
                track_id="Track Tori",
                detection=detection,
                association_confidence=0.8,
                age_frames=2,
                missed_frames=0,
                status="confirmed",
                provenance=AI_INFERRED,
            )

        with self.assertRaises(ValueError):
            AnnotatedTrackAssignment("Tori", 0, 0, True, "Track A")

        with self.assertRaises(ValueError):
            NeutralTrackObservation(
                track_id="Track TORI",
                detection=detection,
                association_confidence=0.8,
                age_frames=2,
                missed_frames=0,
                status="confirmed",
                provenance=AI_INFERRED,
            )

    def test_tracking_evaluation_provenance_is_explicit_and_fixed(self) -> None:
        row = AnnotatedTrackAssignment(
            "person-1",
            0,
            0,
            True,
            "Track A",
        )
        result = evaluate_tracking_assignments([row])

        self.assertEqual(row.reference_source, "human-reviewed")
        self.assertEqual(row.prediction_provenance, "AI-inferred")
        self.assertEqual(result.reference_source, "human-reviewed")
        self.assertEqual(result.prediction_provenance, "AI-inferred")
        self.assertFalse(result.tracking_accuracy_claimed)

        with self.assertRaisesRegex(ValueError, "human-reviewed"):
            AnnotatedTrackAssignment(
                "person-1",
                0,
                0,
                True,
                "Track A",
                reference_source="model-estimated",
            )

        with self.assertRaisesRegex(ValueError, "AI-inferred"):
            AnnotatedTrackAssignment(
                "person-1",
                0,
                0,
                True,
                "Track A",
                prediction_provenance="measured",
            )

    def test_timestamped_observation_requires_unique_detection_order(self) -> None:
        observation = PoseFrameObservation(
            frame_index=4,
            timestamp_ms=160,
            detections=(self._detection(0), self._detection(1)),
        )
        self.assertEqual(len(observation.detections), 2)

        with self.assertRaises(ValueError):
            PoseFrameObservation(
                frame_index=4,
                timestamp_ms=160,
                detections=(self._detection(0), self._detection(0)),
            )

    def test_association_can_be_withheld_without_leaking_identity(self) -> None:
        decision = TrackAssociationDecision(
            frame_index=5,
            timestamp_ms=200,
            detection_index=None,
            track_id=None,
            status="withheld",
            association_confidence=None,
            uncertainty_reasons=("occlusion", "ambiguous_overlap"),
        )
        self.assertEqual(decision.status, "withheld")

        with self.assertRaises(ValueError):
            TrackAssociationDecision(
                frame_index=5,
                timestamp_ms=200,
                detection_index=0,
                track_id="Track A",
                status="withheld",
                association_confidence=0.2,
                uncertainty_reasons=("ambiguous_overlap",),
            )

    def test_association_confidence_unavailability_is_explicit(self) -> None:
        decision = TrackAssociationDecision(
            frame_index=1,
            timestamp_ms=40,
            detection_index=1,
            track_id="Track B",
            status="associated",
            association_confidence=None,
            uncertainty_reasons=("association_confidence_unavailable",),
        )
        self.assertIsNone(decision.association_confidence)

        with self.assertRaises(ValueError):
            TrackAssociationDecision(
                frame_index=1,
                timestamp_ms=40,
                detection_index=1,
                track_id="Track B",
                status="associated",
                association_confidence=None,
            )

    def test_crossing_occlusion_and_reappearance_events_remain_neutral(self) -> None:
        events = tuple(
            NeutralTrackEvent(
                frame_index=index,
                timestamp_ms=index * 40,
                track_id="Track A",
                event_type=event_type,
            )
            for index, event_type in enumerate(
                ("crossing", "occluded", "disappeared", "reappeared")
            )
        )
        self.assertEqual(events[-1].event_type, "reappeared")

        with self.assertRaises(ValueError):
            NeutralTrackEvent(0, 0, "Track Tori", "crossing")

    def test_role_confirmation_is_a_separate_human_gate(self) -> None:
        confirmation = HumanRoleConfirmation("Track A", "Tori")
        self.assertEqual(confirmation.confirmation_source, "human-confirmed")

        with self.assertRaises(ValueError):
            HumanRoleConfirmation(
                "Track A",
                "Tori",
                confirmation_source="AI-inferred",
            )

    def test_lost_and_terminated_tracks_cannot_claim_detections(self) -> None:
        detection = PoseDetection2D(
            detection_index=0,
            bounding_box=BoundingBox2D(0.0, 0.0, 10.0, 20.0),
            keypoints=((2.0, 3.0),),
            keypoint_scores=(0.9,),
        )

        for status in ("lost", "terminated"):
            with self.subTest(status=status):
                with self.assertRaises(ValueError):
                    NeutralTrackObservation(
                        track_id="Track A",
                        detection=detection,
                        association_confidence=None,
                        age_frames=5,
                        missed_frames=1,
                        status=status,
                    )

        lost = NeutralTrackObservation(
            track_id="Track A",
            detection=None,
            association_confidence=None,
            age_frames=5,
            missed_frames=1,
            status="lost",
        )
        self.assertEqual(lost.status, "lost")

        with self.assertRaises(ValueError):
            AnnotatedTrackAssignment(
                "person-1",
                0,
                0,
                True,
                "Track A",
                event_tags=("track_terminated",),
            )

    def test_synthetic_crossing_switch_is_detected(self) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment("person-1", 0, 0, True, "Track A"),
                AnnotatedTrackAssignment(
                    "person-1", 1, 40, True, "Track B", ("crossing",)
                ),
                AnnotatedTrackAssignment("person-2", 0, 0, True, "Track B"),
                AnnotatedTrackAssignment(
                    "person-2", 1, 40, True, "Track A", ("crossing",)
                ),
            )
        )

        self.assertEqual(evaluation.identity_switches, 2)
        self.assertEqual(evaluation.crossing_identity_switches, 2)

    def test_synthetic_occlusion_reappearance_continuity_is_measured(self) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment("person-1", 0, 0, True, "Track A"),
                AnnotatedTrackAssignment("person-1", 1, 40, False, None),
                AnnotatedTrackAssignment("person-1", 2, 80, False, None),
                AnnotatedTrackAssignment("person-1", 3, 120, True, "Track A"),
                AnnotatedTrackAssignment("person-2", 0, 0, True, "Track B"),
                AnnotatedTrackAssignment("person-2", 1, 40, False, None),
                AnnotatedTrackAssignment("person-2", 2, 80, True, "Track C"),
            )
        )

        self.assertEqual(evaluation.reappearance_events, 2)
        self.assertEqual(evaluation.reappearance_preserved, 1)
        self.assertEqual(evaluation.reappearance_changed, 1)
        self.assertEqual(evaluation.identity_switches, 1)
        self.assertEqual(evaluation.assignment_coverage, 1.0)

    def test_visible_unassigned_frame_reduces_assignment_coverage(self) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment("person-1", 0, 0, True, "Track A"),
                AnnotatedTrackAssignment("person-1", 1, 40, True, None),
                AnnotatedTrackAssignment("person-1", 2, 80, True, "Track A"),
            )
        )

        self.assertEqual(evaluation.visible_observations, 3)
        self.assertEqual(evaluation.assigned_observations, 2)
        self.assertAlmostEqual(evaluation.assignment_coverage, 2 / 3)
        self.assertEqual(evaluation.reappearance_preserved, 1)

    def test_reports_association_confidence_availability_without_inventing_it(
        self,
    ) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment(
                    "person-1",
                    0,
                    0,
                    True,
                    "Track A",
                    association_confidence=0.8,
                ),
                AnnotatedTrackAssignment("person-1", 1, 40, True, "Track A"),
            )
        )

        self.assertEqual(evaluation.confidence_observations, 1)
        self.assertEqual(evaluation.confidence_coverage, 0.5)
        self.assertEqual(evaluation.mean_association_confidence, 0.8)

    def test_detection_order_swap_does_not_imply_identity_switch(self) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment(
                    "person-1", 0, 0, True, "Track A", detection_index=0
                ),
                AnnotatedTrackAssignment(
                    "person-1", 1, 40, True, "Track A", detection_index=1
                ),
                AnnotatedTrackAssignment(
                    "person-2", 0, 0, True, "Track B", detection_index=1
                ),
                AnnotatedTrackAssignment(
                    "person-2", 1, 40, True, "Track B", detection_index=0
                ),
            )
        )

        self.assertEqual(evaluation.detection_order_changes, 2)
        self.assertEqual(evaluation.identity_switches, 0)
        self.assertEqual(
            evaluation.detection_order_change_identity_switches,
            0,
        )

    def test_one_person_interval_is_reported_without_role_assignment(self) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment("person-1", 0, 0, True, "Track A"),
                AnnotatedTrackAssignment("person-2", 0, 0, True, "Track B"),
                AnnotatedTrackAssignment("person-1", 1, 40, True, "Track A"),
                AnnotatedTrackAssignment("person-2", 1, 40, False, None),
            )
        )

        self.assertEqual(evaluation.multiple_visible_subject_frames, 1)
        self.assertEqual(evaluation.single_visible_subject_frames, 1)

    def test_explicit_termination_allows_neutral_reinitialization(self) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment("person-1", 0, 0, True, "Track A"),
                AnnotatedTrackAssignment(
                    "person-1",
                    1,
                    40,
                    False,
                    None,
                    event_tags=("track_terminated",),
                ),
                AnnotatedTrackAssignment("person-1", 2, 80, True, "Track C"),
            )
        )

        self.assertEqual(evaluation.track_termination_events, 1)
        self.assertEqual(evaluation.post_termination_reinitializations, 1)
        self.assertEqual(evaluation.reappearance_unverified, 1)
        self.assertEqual(evaluation.identity_switches, 0)

    def test_reports_one_to_one_track_and_detection_collisions(self) -> None:
        evaluation = evaluate_tracking_assignments(
            (
                AnnotatedTrackAssignment(
                    "person-1",
                    0,
                    0,
                    True,
                    "Track A",
                    detection_index=0,
                ),
                AnnotatedTrackAssignment(
                    "person-2",
                    0,
                    0,
                    True,
                    "Track A",
                    detection_index=0,
                ),
            )
        )

        self.assertEqual(evaluation.annotated_frames, 1)
        self.assertEqual(evaluation.track_assignment_collision_frames, 1)
        self.assertEqual(evaluation.track_assignment_collisions, 1)
        self.assertEqual(evaluation.detection_assignment_collision_frames, 1)
        self.assertEqual(evaluation.detection_assignment_collisions, 1)
        self.assertFalse(evaluation.tracking_accuracy_claimed)

    def test_rejects_timestamp_conflicts_unknown_events_and_leaked_detection(
        self,
    ) -> None:
        with self.assertRaises(ValueError):
            evaluate_tracking_assignments(
                (
                    AnnotatedTrackAssignment(
                        "person-1", 0, 0, True, "Track A"
                    ),
                    AnnotatedTrackAssignment(
                        "person-2", 0, 40, True, "Track B"
                    ),
                )
            )

        with self.assertRaises(ValueError):
            AnnotatedTrackAssignment(
                "person-1",
                0,
                0,
                True,
                "Track A",
                event_tags=("automatic_tori",),
            )

        with self.assertRaises(ValueError):
            AnnotatedTrackAssignment(
                "person-1",
                0,
                0,
                True,
                None,
                detection_index=0,
            )

    def test_rejects_non_finite_geometry_scores_and_confidence(self) -> None:
        with self.assertRaises(ValueError):
            BoundingBox2D(0.0, 0.0, math.inf, 20.0)

        with self.assertRaises(ValueError):
            PoseDetection2D(
                detection_index=0,
                bounding_box=BoundingBox2D(0.0, 0.0, 10.0, 20.0),
                keypoints=((math.nan, 3.0),),
                keypoint_scores=(0.9,),
            )

        with self.assertRaises(ValueError):
            PoseDetection2D(
                detection_index=0,
                bounding_box=BoundingBox2D(0.0, 0.0, 10.0, 20.0),
                keypoints=((2.0, 3.0),),
                keypoint_scores=(1.1,),
            )

        with self.assertRaises(ValueError):
            AnnotatedTrackAssignment(
                "person-1",
                0,
                0,
                True,
                "Track A",
                association_confidence=math.nan,
            )
