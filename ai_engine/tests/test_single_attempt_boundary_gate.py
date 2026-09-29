import unittest
from pathlib import Path

from ai_engine.contracts.single_attempt_analysis_v2a import (
    AnalysisFrameSelection,
    AttemptBoundarySelection,
    CameraSuitabilityReview,
    FrameReference,
    PoseObservation2D,
    SingleAttemptAnalysisRequest,
    SubjectSelection,
    SupportLegSelection,
    SupportLegSide,
)
from ai_engine.single_attempt.analysis import analyze_single_attempt


class SingleAttemptBoundaryGateTest(unittest.TestCase):

    def test_boundary_normalized_trunk_is_review_required_but_knee_remains_reportable(
        self,
    ) -> None:
        root = Path(r"D:\projects\judo_mind")

        pose_path = (
            root
            / "ai_engine/runtime/annotation_review/run01/v2a_angle_frame_pose"
            / "frame_1760_tori_pose_observation_boundary_gated.json"
        )

        pose = PoseObservation2D.model_validate_json(
            pose_path.read_text(encoding="utf-8")
        )

        request = SingleAttemptAnalysisRequest(
            schema_version="2.0.0",
            analysis_variant="single_attempt_v2a",
            video_id=(
                "real_uchi_mata_fast_screening_run_01:"
                "603c1bcd7985"
            ),
            technique={"id": "uchi-mata"},
            camera_view="unknown",
            attempt=AttemptBoundarySelection(
                start=FrameReference(
                    frame_index=1750,
                    timestamp_ms=70000,
                ),
                end=FrameReference(
                    frame_index=1875,
                    timestamp_ms=75000,
                ),
                event_schema_id=(
                    "human-single-attempt-boundaries-v1"
                ),
                selection_source="human-selected",
            ),
            subject=SubjectSelection(
                neutral_track_id="Track B",
                selected_detection_index=1,
                role="Tori",
                confirmation_source="human-confirmed",
            ),
            support_leg=SupportLegSelection(
                side=SupportLegSide.RIGHT,
                confirmation_source="human-confirmed",
            ),
            angle_frame=AnalysisFrameSelection(
                frame=FrameReference(
                    frame_index=1760,
                    timestamp_ms=70400,
                ),
                selection_source="human-selected",
                event_label="uchi-mata-v2a-angle-frame",
            ),
            camera_suitability=CameraSuitabilityReview(
                projected_angle_view_suitable=True,
                low_roll_confirmed=True,
                review_source="human-reviewed",
            ),
            pose_observation=pose,
        )

        response = analyze_single_attempt(
            request,
            analysis_id="boundary-gate-regression-test",
        )

        by_id = {
            metric.metric_id: metric
            for metric in response.metrics
        }

        self.assertEqual(
            by_id["UM-TIM-001"].status.value,
            "reportable",
        )
        self.assertEqual(
            by_id["UM-ANG-001"].status.value,
            "review_required",
        )
        self.assertEqual(
            by_id["UM-ANG-002"].status.value,
            "reportable",
        )

        self.assertIsNotNone(by_id["UM-ANG-001"].value)
        self.assertIsNotNone(by_id["UM-ANG-002"].value)

        self.assertEqual(
            response.capabilities.multi_person_evidence_status.value,
            "insufficient",
        )
        self.assertFalse(
            response.capabilities
            .multi_person_interaction_metrics_reportable
        )


if __name__ == "__main__":
    unittest.main()
