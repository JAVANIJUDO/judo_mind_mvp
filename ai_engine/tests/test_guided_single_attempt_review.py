from __future__ import annotations

import asyncio
from datetime import datetime, timedelta, timezone
from io import BytesIO
import json
from pathlib import Path
from unittest import TestCase
from unittest.mock import patch

from fastapi import HTTPException
from pydantic import ValidationError
from starlette.datastructures import Headers, UploadFile

from ai_engine.contracts.guided_single_attempt_review import GuidedReviewConfirmInput
from ai_engine.main import (
    UPLOAD_DIRECTORY,
    _canonical_frame_reference,
    analyze_guided_single_attempt_review,
    app,
    preview_guided_attempt_boundaries,
    prepare_guided_single_attempt_review,
)
from ai_engine.single_attempt.analysis import analyze_single_attempt
from ai_engine.single_attempt.guided_review_session import GuidedReviewSessionStore
from ai_engine.single_attempt.timing_manifest import (
    DecodedFrameTiming,
    SourceTimingState,
    TimingManifest,
    TimingManifestStore,
    TimingMode,
)


def _upload() -> UploadFile:
    return UploadFile(
        filename="attempt.mp4",
        file=BytesIO(b"bounded-test-video"),
        headers=Headers({"content-type": "video/mp4"}),
    )


def _selection(manifest_id: str = "m" * 32, **changes: object) -> str:
    value: dict[str, object] = {
        "video_id": "local-video",
        "technique_id": "uchi-mata",
        "camera_view": "side",
        "timing_manifest_id": manifest_id,
        "attempt_start_frame": 25,
        "attempt_end_frame": 75,
        "review_frame": 50,
        "boundaries_confirmed": True,
        "single_attempt_confirmed": True,
        "attempt_scope": "SINGLE_ATTEMPT",
        "attempt_scope_source": "HUMAN_CONFIRMED",
        "attempt_scope_contract_version": (
            "single-attempt-human-confirmation-1.0.0"
        ),
    }
    value.update(changes)
    return json.dumps(value)


def _landmarks(*, visibility: float | None = 0.9) -> list[dict[str, object]]:
    return [
        {
            "x": 0.1 + index / 100.0,
            "y": 0.1 + index / 200.0,
            "visibility": visibility,
            "presence": 0.9,
            "z": 0.0,
        }
        for index in range(33)
    ]


class _Engine:
    def __init__(
        self,
        pose_count: int = 2,
        *,
        poses: list[dict[str, object]] | None = None,
        warmup_poses: list[dict[str, object]] | None = None,
    ) -> None:
        self.poses = poses or [
            {
                "pose_index": index,
                "landmarks": _landmarks(),
                "world_landmarks": [],
            }
            for index in range(pose_count)
        ]
        self.pose_count = len(self.poses)
        self.warmup_poses = warmup_poses if warmup_poses is not None else []
        self.calls = 0
        self.sampling_plans = []
        self.context_isolation_values: list[bool] = []

    def analyze_video(
        self,
        path: Path,
        fps: float,
        *,
        sampling_plan,
        isolate_video_context: bool = False,
    ) -> dict:
        self.calls += 1
        self.sampling_plans.append(sampling_plan)
        self.context_isolation_values.append(isolate_video_context)
        return {
            "video": {"width": 640, "height": 360},
            "frames": [
                {
                    "frame_index": frame_index,
                    "timestamp_ms": timestamp_ms,
                    "poses": (
                        self.poses
                        if frame_index == sampling_plan.frame_indices[-1]
                        else self.warmup_poses
                    ),
                    "pose_count": len(
                        self.poses
                        if frame_index == sampling_plan.frame_indices[-1]
                        else self.warmup_poses
                    ),
                }
                for frame_index, timestamp_ms in zip(
                    sampling_plan.frame_indices,
                    sampling_plan.timestamps_ms,
                    strict=True,
                )
            ],
        }


def _create_timing_manifest(store: TimingManifestStore) -> TimingManifest:
    return store.create(
        video_id="local-video",
        video_sha256="digest",
        frames=tuple(
            DecodedFrameTiming(index, index * 40, float(index * 40))
            for index in range(100)
        ),
        timing_mode=TimingMode.CFR,
        duration_ms=4000,
        source_fps=25.0,
        timestamp_provenance="decoder-reported-timestamp",
        source_timing_state=SourceTimingState.REAL_TIME,
        physical_time_scale=None,
    )


async def _prepare(
    engine: _Engine | None = None,
    *,
    store: GuidedReviewSessionStore | None = None,
    timing_store: TimingManifestStore | None = None,
    manifest: TimingManifest | None = None,
):
    app.state.pose_engine = engine or _Engine()
    app.state.guided_review_store = store or GuidedReviewSessionStore()
    app.state.timing_manifest_store = timing_store or TimingManifestStore()
    manifest = manifest or _create_timing_manifest(app.state.timing_manifest_store)
    with (
        patch("ai_engine.main.file_sha256", return_value="digest"),
        patch("ai_engine.main._candidate_preview_jpegs", side_effect=lambda *a, **k: ["cHJldmlldw=="] * app.state.pose_engine.pose_count),
    ):
        return await prepare_guided_single_attempt_review(
            video=_upload(), selection_json=_selection(manifest.manifest_id)
        )


def _confirmation(session_id: str, token: str, **changes: object) -> GuidedReviewConfirmInput:
    value: dict[str, object] = {
        "review_session_id": session_id,
        "role_assignment": {
            "role": "TORI",
            "source": "HUMAN_CONFIRMATION",
            "candidate_token": token,
        },
        "tori_confirmed": True,
        "support_leg": "left",
        "attacking_leg": "right",
        "projected_angle_view_suitable": True,
        "low_roll_confirmed": True,
        "reviewer_uncertain": False,
    }
    value.update(changes)
    return GuidedReviewConfirmInput.model_validate(value)


class GuidedSingleAttemptReviewTest(TestCase):
    def test_canonicalization_is_deterministic_and_bounded(self) -> None:
        self.assertEqual(
            _canonical_frame_reference(2020, source_fps=25.0, frame_count=100).frame_index,
            51,
        )
        with self.assertRaisesRegex(ValueError, "outside"):
            _canonical_frame_reference(5000, source_fps=25.0, frame_count=100)

    def test_prepare_returns_multiple_opaque_session_bound_candidates(self) -> None:
        existing = set(UPLOAD_DIRECTORY.iterdir())
        response = asyncio.run(_prepare())
        payload = response.model_dump(mode="json")
        self.assertEqual(len(response.candidates), 2)
        self.assertEqual(response.detected_pose_count, 2)
        self.assertEqual(response.selectable_candidate_count, 2)
        self.assertEqual(
            response.candidate_selection_status,
            "ready_for_human_selection",
        )
        self.assertNotEqual(
            response.candidates[0].candidate_token,
            response.candidates[1].candidate_token,
        )
        self.assertNotIn("0", response.candidates[0].model_dump().keys())
        for candidate in payload["candidates"]:
            self.assertEqual(candidate["pose_availability"], "available")
            self.assertEqual(candidate["pose_provenance"], "model-estimated")
            self.assertEqual(candidate["required_landmark_count"], 8)
            self.assertEqual(candidate["available_required_landmark_count"], 8)
            self.assertNotIn("role", candidate)
            self.assertNotIn("identity", candidate)
            self.assertNotIn("confidence", candidate)
            self.assertEqual(candidate["track_metadata"], {
                "status": "unavailable",
                "neutral_track_id": None,
                "association_confidence": None,
                "reason": "frame_local_candidate_only_no_tracking",
            })
        self.assertEqual(set(UPLOAD_DIRECTORY.iterdir()), existing)

    def test_prepare_uses_attempt_clamped_context_and_only_review_evidence(
        self,
    ) -> None:
        warmup_poses = [
            {
                "pose_index": index,
                "landmarks": _landmarks(),
                "world_landmarks": [],
            }
            for index in range(2)
        ]
        engine = _Engine(pose_count=1, warmup_poses=warmup_poses)
        app.state.pose_engine = engine
        app.state.guided_review_store = GuidedReviewSessionStore()
        app.state.timing_manifest_store = TimingManifestStore()
        manifest = _create_timing_manifest(app.state.timing_manifest_store)

        with (
            patch("ai_engine.main.file_sha256", return_value="digest"),
            patch(
                "ai_engine.main._candidate_preview_jpegs",
                return_value=["cHJldmlldw=="],
            ),
        ):
            response = asyncio.run(
                prepare_guided_single_attempt_review(
                    video=_upload(),
                    selection_json=_selection(
                        manifest.manifest_id,
                        attempt_start_frame=45,
                        attempt_end_frame=75,
                        review_frame=50,
                    ),
                )
            )

        plan = engine.sampling_plans[0]
        self.assertEqual(plan.frame_indices, (45, 46, 47, 48, 49, 50))
        self.assertTrue(all(frame >= 45 for frame in plan.frame_indices))
        self.assertEqual(plan.frame_indices[-1], 50)
        self.assertEqual(engine.context_isolation_values, [True])
        self.assertEqual(response.canonical_review_frame, 50)
        self.assertEqual(response.canonical_review_moment_ms, 2000)
        self.assertEqual(response.detected_pose_count, 1)
        self.assertEqual(response.selectable_candidate_count, 1)
        self.assertEqual(len(response.candidates), 1)
        self.assertEqual(
            response.candidate_selection_status,
            "insufficient_candidate_evidence",
        )

    def test_one_returned_pose_is_not_a_single_person_scene_and_blocks_analyze(
        self,
    ) -> None:
        response = asyncio.run(_prepare(_Engine(pose_count=1)))
        self.assertEqual(response.detected_pose_count, 1)
        self.assertEqual(response.selectable_candidate_count, 1)
        self.assertEqual(
            response.candidate_selection_status,
            "insufficient_candidate_evidence",
        )
        self.assertIn(
            "does not establish how many people or judoka are present",
            " ".join(response.limitations),
        )
        with self.assertRaises(HTTPException) as raised:
            analyze_guided_single_attempt_review(
                _confirmation(
                    response.review_session_id,
                    response.candidates[0].candidate_token,
                )
            )
        self.assertEqual(raised.exception.status_code, 422)

    def test_no_selectable_candidate_returns_bounded_state_and_blocks_analyze(
        self,
    ) -> None:
        response = asyncio.run(_prepare(_Engine(pose_count=0)))
        self.assertEqual(response.detected_pose_count, 0)
        self.assertEqual(response.selectable_candidate_count, 0)
        self.assertEqual(response.candidates, [])
        self.assertEqual(
            response.candidate_selection_status,
            "no_selectable_candidate",
        )
        with self.assertRaises(HTTPException) as raised:
            analyze_guided_single_attempt_review(
                _confirmation(response.review_session_id, "x" * 32)
            )
        self.assertEqual(raised.exception.status_code, 422)

    def test_malformed_returned_pose_is_not_counted_as_multi_person_evidence(
        self,
    ) -> None:
        engine = _Engine(
            poses=[
                {
                    "pose_index": 0,
                    "landmarks": _landmarks(),
                    "world_landmarks": [],
                },
                {
                    "pose_index": 1,
                    "landmarks": _landmarks()[:4],
                    "world_landmarks": [],
                },
            ]
        )
        response = asyncio.run(_prepare(engine))
        self.assertEqual(response.detected_pose_count, 2)
        self.assertEqual(response.selectable_candidate_count, 1)
        self.assertEqual(len(response.candidates), 1)
        self.assertEqual(
            response.candidate_selection_status,
            "insufficient_candidate_evidence",
        )

    def test_duplicate_detection_indexes_are_not_independent_candidates(self) -> None:
        engine = _Engine(
            poses=[
                {
                    "pose_index": 0,
                    "landmarks": _landmarks(),
                    "world_landmarks": [],
                },
                {
                    "pose_index": 0,
                    "landmarks": _landmarks(),
                    "world_landmarks": [],
                },
            ]
        )
        response = asyncio.run(_prepare(engine))
        self.assertEqual(response.detected_pose_count, 2)
        self.assertEqual(response.selectable_candidate_count, 0)
        self.assertEqual(response.candidates, [])
        self.assertEqual(
            response.candidate_selection_status,
            "no_selectable_candidate",
        )

    def test_missing_visibility_is_explicit_but_never_accuracy_or_confidence(
        self,
    ) -> None:
        engine = _Engine(
            poses=[
                {
                    "pose_index": index,
                    "landmarks": _landmarks(visibility=None),
                    "world_landmarks": [],
                }
                for index in range(2)
            ]
        )
        response = asyncio.run(_prepare(engine))
        self.assertEqual(
            response.candidate_selection_status,
            "ready_for_human_selection",
        )
        for candidate in response.model_dump(mode="json")["candidates"]:
            self.assertEqual(
                candidate["model_landmark_visibility_status"], "unavailable"
            )
            self.assertEqual(candidate["model_landmark_visibility_count"], 0)
            serialized = json.dumps(candidate).lower()
            self.assertNotIn("accuracy", serialized)
            self.assertIsNone(candidate["track_metadata"]["association_confidence"])

    def test_prepare_can_repeat_after_human_edits_boundaries(self) -> None:
        engine = _Engine()
        app.state.pose_engine = engine
        app.state.guided_review_store = GuidedReviewSessionStore()
        app.state.timing_manifest_store = TimingManifestStore()
        manifest = app.state.timing_manifest_store.create(
            video_id="local-video",
            video_sha256="digest",
            frames=tuple(
                DecodedFrameTiming(index, index * 40, float(index * 40))
                for index in range(100)
            ),
            timing_mode=TimingMode.CFR,
            duration_ms=4000,
            source_fps=25.0,
            timestamp_provenance="decoder-reported-timestamp",
            source_timing_state=SourceTimingState.REAL_TIME,
            physical_time_scale=None,
        )
        first_selection = _selection(
            manifest.manifest_id,
            attempt_start_frame=25,
            attempt_end_frame=75,
            review_frame=50,
        )
        edited_selection = _selection(
            manifest.manifest_id,
            attempt_start_frame=26,
            attempt_end_frame=74,
            review_frame=51,
        )

        with (
            patch("ai_engine.main.file_sha256", return_value="digest"),
            patch(
                "ai_engine.main._candidate_preview_jpegs",
                side_effect=lambda *a, **k: ["cHJldmlldw=="] * engine.pose_count,
            ),
        ):
            first = asyncio.run(
                prepare_guided_single_attempt_review(
                    video=_upload(), selection_json=first_selection
                )
            )
            second = asyncio.run(
                prepare_guided_single_attempt_review(
                    video=_upload(), selection_json=edited_selection
                )
            )

        self.assertNotEqual(first.review_session_id, second.review_session_id)
        self.assertEqual(second.canonical_start_frame, 26)
        self.assertEqual(second.canonical_end_frame, 74)
        self.assertEqual(second.canonical_review_frame, 51)
        self.assertEqual(engine.calls, 2)

    def test_boundary_preview_uses_exact_manifest_frames_without_inference(self) -> None:
        app.state.timing_manifest_store = TimingManifestStore()
        manifest = app.state.timing_manifest_store.create(
            video_id="local-video",
            video_sha256="digest",
            frames=tuple(
                DecodedFrameTiming(index, index * 40, float(index * 40))
                for index in range(100)
            ),
            timing_mode=TimingMode.CFR,
            duration_ms=4000,
            source_fps=25.0,
            timestamp_provenance="decoder-reported-timestamp",
            source_timing_state=SourceTimingState.REAL_TIME,
            physical_time_scale=None,
        )
        engine = _Engine()
        app.state.pose_engine = engine
        with (
            patch("ai_engine.main.file_sha256", return_value="digest"),
            patch(
                "ai_engine.main._decoded_frame_preview",
                side_effect=lambda _path, index: f"preview-{index}",
            ),
        ):
            response = asyncio.run(
                preview_guided_attempt_boundaries(
                    video=_upload(),
                    selection_json=json.dumps(
                        {
                            "video_id": "local-video",
                            "timing_manifest_id": manifest.manifest_id,
                            "attempt_start_frame": 25,
                            "attempt_end_frame": 75,
                            "review_frame": 50,
                        }
                    ),
                )
            )
        self.assertEqual(response.start_frame, 25)
        self.assertEqual(response.end_frame, 75)
        self.assertEqual(response.start_preview_jpeg_base64, "preview-25")
        self.assertEqual(response.end_preview_jpeg_base64, "preview-75")
        self.assertEqual(engine.calls, 0)

    def test_unsupported_technique_is_rejected_before_inference(self) -> None:
        engine = _Engine()
        app.state.pose_engine = engine
        with self.assertRaises(HTTPException) as raised:
            asyncio.run(
                prepare_guided_single_attempt_review(
                    video=_upload(), selection_json=_selection(technique_id="seoi-nage")
                )
            )
        self.assertEqual(raised.exception.status_code, 400)
        self.assertEqual(engine.calls, 0)

    def test_single_attempt_confirmation_is_required_before_inference(self) -> None:
        engine = _Engine()
        app.state.pose_engine = engine
        value = json.loads(_selection())
        del value["single_attempt_confirmed"]
        with self.assertRaises(HTTPException) as raised:
            asyncio.run(
                prepare_guided_single_attempt_review(
                    video=_upload(), selection_json=json.dumps(value)
                )
            )
        self.assertEqual(raised.exception.status_code, 400)
        self.assertEqual(engine.calls, 0)

    def test_single_attempt_confirmation_cannot_claim_automatic_source(self) -> None:
        engine = _Engine()
        app.state.pose_engine = engine
        value = json.loads(_selection())
        value["attempt_scope_source"] = "AI_DETECTED_SINGLE_ATTEMPT"
        with self.assertRaises(HTTPException) as raised:
            asyncio.run(
                prepare_guided_single_attempt_review(
                    video=_upload(), selection_json=json.dumps(value)
                )
            )
        self.assertEqual(raised.exception.status_code, 400)
        self.assertEqual(engine.calls, 0)

    def test_human_tori_role_assignment_is_explicit_and_candidate_bound(self) -> None:
        prepared = asyncio.run(_prepare())
        token = prepared.candidates[1].candidate_token
        confirmation = _confirmation(prepared.review_session_id, token)

        payload = confirmation.model_dump(mode="json")
        self.assertNotIn("candidate_token", payload)
        self.assertEqual(
            payload["role_assignment"],
            {
                "role": "TORI",
                "source": "HUMAN_CONFIRMATION",
                "candidate_token": token,
            },
        )
        result = analyze_guided_single_attempt_review(confirmation)
        self.assertEqual(result.subject.selected_detection_index, 1)
        self.assertEqual(result.subject.role, "Tori")
        self.assertEqual(result.subject.confirmation_source, "human-confirmed")

    def test_missing_human_role_assignment_is_rejected(self) -> None:
        with self.assertRaises(ValidationError):
            GuidedReviewConfirmInput.model_validate(
                {
                    "review_session_id": "session-token-with-safe-length",
                    "tori_confirmed": True,
                    "support_leg": "left",
                    "attacking_leg": "right",
                    "projected_angle_view_suitable": True,
                    "low_roll_confirmed": True,
                    "reviewer_uncertain": False,
                }
            )

    def test_ai_role_or_identity_claim_is_rejected(self) -> None:
        valid = _confirmation(
            "session-token-with-safe-length",
            "candidate-token-with-safe-length",
        ).model_dump(mode="json")
        for forbidden_role_assignment in (
            {
                **valid["role_assignment"],
                "source": "AI_DETECTION",
            },
            {
                **valid["role_assignment"],
                "identity": "athlete-1",
            },
        ):
            invalid = {**valid, "role_assignment": forbidden_role_assignment}
            with self.subTest(role_assignment=forbidden_role_assignment):
                with self.assertRaises(ValidationError):
                    GuidedReviewConfirmInput.model_validate(invalid)

        for forbidden_top_level_claim in (
            {"identity": "athlete-1"},
            {"candidate_token": "legacy-client-controlled-token"},
        ):
            invalid = {**valid, **forbidden_top_level_claim}
            with self.subTest(top_level_claim=forbidden_top_level_claim):
                with self.assertRaises(ValidationError):
                    GuidedReviewConfirmInput.model_validate(invalid)

    def test_explicit_tori_confirmation_is_required_and_session_is_cleaned(self) -> None:
        prepared = asyncio.run(_prepare())
        token = prepared.candidates[0].candidate_token
        with self.assertRaises(HTTPException) as raised:
            analyze_guided_single_attempt_review(
                _confirmation(prepared.review_session_id, token, tori_confirmed=False)
            )
        self.assertEqual(raised.exception.status_code, 422)
        with self.assertRaises(HTTPException):
            analyze_guided_single_attempt_review(
                _confirmation(prepared.review_session_id, token)
            )

    def test_uncertainty_fails_closed(self) -> None:
        prepared = asyncio.run(_prepare())
        with self.assertRaises(HTTPException) as raised:
            analyze_guided_single_attempt_review(
                _confirmation(
                    prepared.review_session_id,
                    prepared.candidates[0].candidate_token,
                    reviewer_uncertain=True,
                )
            )
        self.assertEqual(raised.exception.status_code, 422)

    def test_wrong_session_token_is_rejected_without_cross_assignment(self) -> None:
        store = GuidedReviewSessionStore()
        first = asyncio.run(_prepare(store=store))
        second = asyncio.run(_prepare(store=store))
        with (
            patch("ai_engine.main.analyze_single_attempt") as analyzer,
            self.assertRaises(HTTPException) as raised,
        ):
            analyze_guided_single_attempt_review(
                _confirmation(
                    first.review_session_id,
                    second.candidates[0].candidate_token,
                )
            )
        self.assertEqual(raised.exception.status_code, 400)
        analyzer.assert_not_called()

    def test_candidate_token_binding_is_invariant_to_prepare_order(self) -> None:
        token_a = "candidate-token-A-opaque-safe-length"
        token_b = "candidate-token-B-opaque-safe-length"
        poses = _Engine().poses
        captured_requests = []
        timing_store = TimingManifestStore()
        manifest = _create_timing_manifest(timing_store)

        def capture_analysis(request):
            captured_requests.append(request)
            return analyze_single_attempt(request)

        with patch(
            "ai_engine.main.analyze_single_attempt",
            side_effect=capture_analysis,
        ):
            with patch(
                "ai_engine.single_attempt.guided_review_session.token_urlsafe",
                side_effect=[
                    "original-order-session-opaque-safe-length",
                    token_a,
                    token_b,
                ],
            ):
                original = asyncio.run(
                    _prepare(
                        _Engine(poses=poses),
                        timing_store=timing_store,
                        manifest=manifest,
                    )
                )
            self.assertEqual(
                [candidate.candidate_token for candidate in original.candidates],
                [token_a, token_b],
            )
            original_result = analyze_guided_single_attempt_review(
                _confirmation(original.review_session_id, token_b)
            )

            with patch(
                "ai_engine.single_attempt.guided_review_session.token_urlsafe",
                side_effect=[
                    "reversed-order-session-opaque-safe-length",
                    token_b,
                    token_a,
                ],
            ):
                reversed_order = asyncio.run(
                    _prepare(
                        _Engine(poses=list(reversed(poses))),
                        timing_store=timing_store,
                        manifest=manifest,
                    )
                )
            self.assertEqual(
                [
                    candidate.candidate_token
                    for candidate in reversed_order.candidates
                ],
                [token_b, token_a],
            )
            reversed_result = analyze_guided_single_attempt_review(
                _confirmation(reversed_order.review_session_id, token_b)
            )

        self.assertEqual(len(captured_requests), 2)
        first_observation = captured_requests[0].pose_observation.model_dump(
            mode="json"
        )
        second_observation = captured_requests[1].pose_observation.model_dump(
            mode="json"
        )
        self.assertEqual(first_observation, second_observation)
        self.assertEqual(first_observation["detection_index"], 1)

        first_result = original_result.model_dump(mode="json")
        second_result = reversed_result.model_dump(mode="json")
        first_result.pop("analysis_id")
        second_result.pop("analysis_id")
        self.assertEqual(first_result, second_result)

    def test_expired_session_is_rejected(self) -> None:
        now = [datetime(2026, 1, 1, tzinfo=timezone.utc)]
        store = GuidedReviewSessionStore(
            ttl=timedelta(seconds=1), clock=lambda: now[0]
        )
        app.state.guided_review_store = store
        app.state.pose_engine = _Engine(1)
        app.state.timing_manifest_store = TimingManifestStore()
        store_manifest = app.state.timing_manifest_store.create(
            video_id="local-video",
            video_sha256="digest",
            frames=tuple(
                DecodedFrameTiming(index, index * 40, float(index * 40))
                for index in range(100)
            ),
            timing_mode=TimingMode.CFR,
            duration_ms=4000,
            source_fps=25.0,
            timestamp_provenance="decoder-reported-timestamp",
            source_timing_state=SourceTimingState.REAL_TIME,
            physical_time_scale=None,
        )
        with (
            patch("ai_engine.main.file_sha256", return_value="digest"),
            patch("ai_engine.main._candidate_preview_jpegs", return_value=["cHJldmlldw=="]),
        ):
            prepared = asyncio.run(
                prepare_guided_single_attempt_review(
                    video=_upload(), selection_json=_selection(
                        store_manifest.manifest_id
                    )
                )
            )
        now[0] += timedelta(seconds=2)
        with self.assertRaises(HTTPException) as raised:
            analyze_guided_single_attempt_review(
                _confirmation(prepared.review_session_id, prepared.candidates[0].candidate_token)
            )
        self.assertEqual(raised.exception.status_code, 410)

    def test_confirm_uses_stored_pose_once_and_preserves_v2a_boundary(self) -> None:
        engine = _Engine()
        prepared = asyncio.run(_prepare(engine))
        result = analyze_guided_single_attempt_review(
            _confirmation(prepared.review_session_id, prepared.candidates[1].candidate_token)
        )
        self.assertEqual(engine.calls, 1, "confirm must not rerun pose inference")
        self.assertEqual(result.schema_version, "2.0.0")
        self.assertEqual([metric.metric_id for metric in result.metrics], [
            "UM-TIM-001", "UM-ANG-001", "UM-ANG-002", "UM-ANG-003"
        ])
        self.assertEqual(result.subject.selected_detection_index, 1)
        self.assertTrue(result.capabilities.human_confirmed_tori)
        self.assertFalse(result.capabilities.automatic_tori_uke_identity)
        self.assertFalse(result.capabilities.automatic_phase_detection)
        self.assertEqual(
            result.capabilities.multi_person_evidence_status,
            "insufficient",
        )
        self.assertFalse(
            result.capabilities.multi_person_interaction_metrics_reportable
        )
        self.assertTrue(result.attempt.single_attempt_confirmed)
        self.assertEqual(result.attempt.attempt_scope, "SINGLE_ATTEMPT")
        self.assertEqual(result.attempt.attempt_scope_source, "HUMAN_CONFIRMED")
        with self.assertRaises(HTTPException):
            analyze_guided_single_attempt_review(
                _confirmation(prepared.review_session_id, prepared.candidates[1].candidate_token)
            )
