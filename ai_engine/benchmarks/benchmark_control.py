from __future__ import annotations

from dataclasses import dataclass
import math
from threading import Event
import time
from typing import Any, Callable


ProgressCallback = Callable[[dict[str, Any]], None]


class BenchmarkControlError(RuntimeError):
    """Base class for cooperative benchmark interruption."""


class BenchmarkTimedOut(BenchmarkControlError):
    """Raised between samples when an engine exceeds its time budget."""


class BenchmarkCancelled(BenchmarkControlError):
    """Raised between samples after a graceful cancellation request."""


@dataclass(frozen=True)
class BenchmarkObservation:
    frame_index: int
    timestamp_ms: int
    pose_count: int

    def as_dict(self) -> dict[str, int]:
        return {
            "frame_index": self.frame_index,
            "timestamp_ms": self.timestamp_ms,
            "pose_count": self.pose_count,
        }


class BenchmarkRunControl:
    """Per-engine progress, timeout and cancellation between model calls."""

    def __init__(
        self,
        *,
        engine_id: str,
        total_samples: int,
        timeout_seconds: float,
        progress_callback: ProgressCallback | None = None,
        cancellation_event: Event | None = None,
        progress_interval_frames: int = 10,
        clock: Callable[[], float] = time.perf_counter,
    ) -> None:
        if total_samples < 0:
            raise ValueError("total_samples cannot be negative.")

        if not math.isfinite(timeout_seconds) or timeout_seconds <= 0:
            raise ValueError("timeout_seconds must be finite and positive.")

        if progress_interval_frames < 1:
            raise ValueError("progress_interval_frames must be positive.")

        self.engine_id = engine_id
        self.total_samples = total_samples
        self.timeout_seconds = float(timeout_seconds)
        self._progress_callback = progress_callback
        self._cancellation_event = cancellation_event or Event()
        self._progress_interval_frames = progress_interval_frames
        self._clock = clock
        self._started_at = clock()
        self._observations: list[BenchmarkObservation] = []
        self._emit("starting")

    @property
    def processed_samples(self) -> int:
        return len(self._observations)

    @property
    def elapsed_seconds(self) -> float:
        return max(0.0, self._clock() - self._started_at)

    @property
    def observations(self) -> tuple[dict[str, int], ...]:
        return tuple(item.as_dict() for item in self._observations)

    def before_sample(self) -> None:
        self._check_interruption()

    def record_sample(
        self,
        *,
        frame_index: int,
        timestamp_ms: int,
        pose_count: int,
    ) -> None:
        self._observations.append(
            BenchmarkObservation(
                frame_index=int(frame_index),
                timestamp_ms=int(timestamp_ms),
                pose_count=int(pose_count),
            )
        )
        self._check_interruption()

        processed = self.processed_samples

        if (
            processed == 1
            or processed == self.total_samples
            or processed % self._progress_interval_frames == 0
        ):
            self._emit(
                "completed"
                if processed == self.total_samples
                else "running"
            )

    def _check_interruption(self) -> None:
        if self._cancellation_event.is_set():
            self._emit("cancelled")
            raise BenchmarkCancelled(
                f"{self.engine_id} cancelled after "
                f"{self.processed_samples}/{self.total_samples} samples."
            )

        if self.elapsed_seconds >= self.timeout_seconds:
            self._emit("timed_out")
            raise BenchmarkTimedOut(
                f"{self.engine_id} exceeded {self.timeout_seconds:.1f}s after "
                f"{self.processed_samples}/{self.total_samples} samples."
            )

    def _emit(self, status: str) -> None:
        if self._progress_callback is None:
            return

        elapsed = self.elapsed_seconds
        processed = self.processed_samples
        effective_fps = processed / elapsed if elapsed > 0 else 0.0
        eta_minimum_samples = max(
            5,
            min(20, math.ceil(self.total_samples * 0.05)),
        )
        eta_reliable = (
            processed >= eta_minimum_samples
            and effective_fps > 0
            and status == "running"
        )
        eta_seconds = (
            (self.total_samples - processed) / effective_fps
            if eta_reliable
            else None
        )

        self._progress_callback(
            {
                "engine_id": self.engine_id,
                "status": status,
                "processed_samples": processed,
                "total_samples": self.total_samples,
                "elapsed_seconds": elapsed,
                "effective_processing_fps": effective_fps,
                "eta_seconds": eta_seconds,
                "eta_reliable": eta_reliable,
                "timeout_seconds": self.timeout_seconds,
            }
        )
