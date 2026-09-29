from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from secrets import token_urlsafe
from threading import Lock
from typing import Callable

from ai_engine.contracts.guided_single_attempt_review import (
    CandidateSelectionStatus,
    candidate_selection_status_for_count,
)
from ai_engine.contracts.single_attempt_analysis_v2a import FrameReference
from ai_engine.single_attempt.pose_observation_adapter import FrameCandidatePose2D


class ReviewSessionError(ValueError):
    pass


class ReviewSessionExpired(ReviewSessionError):
    pass


class ReviewSessionInsufficientCandidateEvidence(ReviewSessionError):
    pass


@dataclass(frozen=True)
class GuidedReviewSession:
    session_id: str
    expires_at: datetime
    video_id: str
    camera_view: str
    attempt_start: FrameReference
    attempt_end: FrameReference
    review_frame: FrameReference
    source_timing: dict[str, object]
    attempt_scope: dict[str, object]
    detected_pose_count: int
    selectable_candidate_count: int
    candidate_selection_status: CandidateSelectionStatus
    candidates: dict[str, FrameCandidatePose2D]

    @property
    def candidate_selection_ready(self) -> bool:
        return (
            self.candidate_selection_status
            is CandidateSelectionStatus.READY_FOR_HUMAN_SELECTION
        )


class GuidedReviewSessionStore:
    """Bounded in-process store; process restart intentionally loses sessions."""

    def __init__(
        self,
        *,
        ttl: timedelta = timedelta(minutes=10),
        max_sessions: int = 32,
        clock: Callable[[], datetime] | None = None,
    ) -> None:
        if max_sessions < 1:
            raise ValueError("max_sessions must be positive.")
        self._ttl = ttl
        self._max_sessions = max_sessions
        self._clock = clock or (lambda: datetime.now(timezone.utc))
        self._sessions: dict[str, GuidedReviewSession] = {}
        self._lock = Lock()

    @property
    def ttl_seconds(self) -> int:
        return int(self._ttl.total_seconds())

    def create(
        self,
        *,
        video_id: str,
        camera_view: str,
        attempt_start: FrameReference,
        attempt_end: FrameReference,
        review_frame: FrameReference,
        source_timing: dict[str, object],
        attempt_scope: dict[str, object],
        detected_pose_count: int,
        candidate_poses: list[FrameCandidatePose2D],
    ) -> GuidedReviewSession:
        if detected_pose_count < len(candidate_poses):
            raise ReviewSessionError(
                "Selectable candidates cannot exceed model-returned poses."
            )
        with self._lock:
            self._remove_expired_locked()
            if len(self._sessions) >= self._max_sessions:
                raise ReviewSessionError(
                    "Guided review capacity is temporarily unavailable."
                )
            session_id = token_urlsafe(32)
            candidates = {
                token_urlsafe(32): candidate for candidate in candidate_poses
            }
            candidate_selection_status = candidate_selection_status_for_count(
                len(candidates)
            )
            session = GuidedReviewSession(
                session_id=session_id,
                expires_at=self._clock() + self._ttl,
                video_id=video_id,
                camera_view=camera_view,
                attempt_start=attempt_start,
                attempt_end=attempt_end,
                review_frame=review_frame,
                source_timing=dict(source_timing),
                attempt_scope=dict(attempt_scope),
                detected_pose_count=detected_pose_count,
                selectable_candidate_count=len(candidates),
                candidate_selection_status=candidate_selection_status,
                candidates=candidates,
            )
            self._sessions[session_id] = session
            return session

    def resolve(self, session_id: str, candidate_token: str) -> tuple[
        GuidedReviewSession, FrameCandidatePose2D
    ]:
        with self._lock:
            session = self._sessions.get(session_id)
            if session is None:
                self._remove_expired_locked()
                raise ReviewSessionError("Review session is invalid or unavailable.")
            if self._clock() >= session.expires_at:
                del self._sessions[session_id]
                raise ReviewSessionExpired("Review session has expired.")
            if not session.candidate_selection_ready:
                raise ReviewSessionInsufficientCandidateEvidence(
                    "Two selectable frame candidates are required before analysis."
                )
            candidate = session.candidates.get(candidate_token)
            if candidate is None:
                raise ReviewSessionError(
                    "Candidate token is invalid for this review session."
                )
            return session, candidate

    def discard(self, session_id: str) -> None:
        with self._lock:
            self._sessions.pop(session_id, None)

    def cleanup_expired(self) -> int:
        with self._lock:
            return self._remove_expired_locked()

    def _remove_expired_locked(self) -> int:
        now = self._clock()
        expired = [
            session_id
            for session_id, session in self._sessions.items()
            if now >= session.expires_at
        ]
        for session_id in expired:
            del self._sessions[session_id]
        return len(expired)
