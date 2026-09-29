from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from enum import Enum
from hashlib import sha256
from pathlib import Path
from secrets import token_urlsafe
from threading import Lock
from typing import Callable

import cv2


TIMING_METHOD_VERSION = "opencv-decoded-timeline-1.0.0"
MAX_TIMING_MANIFEST_FRAMES = 120_000


class TimingMode(str, Enum):
    CFR = "CFR"
    VFR = "VFR"
    UNKNOWN = "UNKNOWN"


class SourceTimingState(str, Enum):
    REAL_TIME = "REAL_TIME"
    KNOWN_TIME_SCALE = "KNOWN_TIME_SCALE"
    UNKNOWN = "UNKNOWN"


class TimingManifestError(ValueError):
    pass


class TimingManifestExpired(TimingManifestError):
    pass


@dataclass(frozen=True)
class DecodedFrameTiming:
    frame_index: int
    timestamp_ms: int
    decoder_timestamp_ms: float | None


@dataclass(frozen=True)
class TimingManifest:
    manifest_id: str
    expires_at: datetime
    video_id: str
    video_sha256: str
    frames: tuple[DecodedFrameTiming, ...]
    timing_mode: TimingMode
    duration_ms: int
    source_fps: float | None
    timestamp_provenance: str
    source_timing_state: SourceTimingState
    physical_time_scale: float | None

    def frame(self, frame_index: int) -> DecodedFrameTiming:
        if frame_index < 0 or frame_index >= len(self.frames):
            raise TimingManifestError("Frame reference is outside the timing manifest.")
        return self.frames[frame_index]


def file_sha256(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def decode_timing_manifest(path: Path) -> tuple[
    tuple[DecodedFrameTiming, ...], TimingMode, int, float | None, str
]:
    """Decode timing only; no pose/model inference occurs.

    OpenCV's decoder timestamp is retained when monotonic. It is explicitly
    described as decoder-reported timing, not fabricated as a raw container PTS.
    A deterministic FPS-derived fallback is kept only with derived provenance.
    """
    capture = cv2.VideoCapture(str(path))
    if not capture.isOpened():
        raise TimingManifestError("Uploaded video could not be opened.")
    fps_value = float(capture.get(cv2.CAP_PROP_FPS))
    source_fps = fps_value if fps_value > 0 else None
    decoded: list[tuple[int, float | None]] = []
    try:
        index = 0
        while True:
            ok, _ = capture.read()
            if not ok:
                break
            value = float(capture.get(cv2.CAP_PROP_POS_MSEC))
            decoded.append((index, value if value >= 0 else None))
            index += 1
            if index > MAX_TIMING_MANIFEST_FRAMES:
                raise TimingManifestError(
                    "Video exceeds the bounded timing-manifest frame limit."
                )
    finally:
        capture.release()
    if not decoded:
        raise TimingManifestError("Uploaded video has no decodable frames.")

    reported = [value for _, value in decoded]
    monotonic = all(
        reported[i] is not None
        and reported[i - 1] is not None
        and reported[i] > reported[i - 1]
        for i in range(1, len(reported))
    )
    if len(reported) == 1 and reported[0] is not None:
        monotonic = True

    if monotonic:
        timestamps = [int(round(value or 0.0)) for value in reported]
        deltas = [reported[i] - reported[i - 1] for i in range(1, len(reported))]
        if not deltas:
            mode = TimingMode.UNKNOWN
        else:
            median = sorted(deltas)[len(deltas) // 2]
            tolerance = max(0.5, abs(median) * 0.02)
            mode = (
                TimingMode.CFR
                if all(abs(delta - median) <= tolerance for delta in deltas)
                else TimingMode.VFR
            )
        provenance = "decoder-reported-timestamp"
    elif source_fps is not None:
        timestamps = [int(round(index * 1000.0 / source_fps)) for index, _ in decoded]
        mode = TimingMode.UNKNOWN
        provenance = "average-fps-derived-not-true-pts"
    else:
        raise TimingManifestError(
            "Decoded timestamps and source FPS are unavailable; timing is unknown."
        )

    frames = tuple(
        DecodedFrameTiming(index, timestamps[index], reported[index])
        for index in range(len(decoded))
    )
    duration_ms = timestamps[-1]
    if len(timestamps) > 1:
        duration_ms += max(1, timestamps[-1] - timestamps[-2])
    return frames, mode, duration_ms, source_fps, provenance


class TimingManifestStore:
    def __init__(
        self,
        *,
        ttl: timedelta = timedelta(minutes=10),
        max_manifests: int = 16,
        clock: Callable[[], datetime] | None = None,
    ) -> None:
        self._ttl = ttl
        self._max = max_manifests
        self._clock = clock or (lambda: datetime.now(timezone.utc))
        self._items: dict[str, TimingManifest] = {}
        self._lock = Lock()

    @property
    def ttl_seconds(self) -> int:
        return int(self._ttl.total_seconds())

    def create(
        self,
        *,
        video_id: str,
        video_sha256: str,
        frames: tuple[DecodedFrameTiming, ...],
        timing_mode: TimingMode,
        duration_ms: int,
        source_fps: float | None,
        timestamp_provenance: str,
        source_timing_state: SourceTimingState,
        physical_time_scale: float | None,
    ) -> TimingManifest:
        if source_timing_state is SourceTimingState.KNOWN_TIME_SCALE:
            if physical_time_scale is None or physical_time_scale <= 0:
                raise TimingManifestError("Known time scale requires a positive scale.")
        elif physical_time_scale is not None:
            raise TimingManifestError("Time scale is allowed only for KNOWN_TIME_SCALE.")
        with self._lock:
            self._cleanup_locked()
            if len(self._items) >= self._max:
                raise TimingManifestError("Timing manifest capacity is unavailable.")
            manifest_id = token_urlsafe(32)
            item = TimingManifest(
                manifest_id=manifest_id,
                expires_at=self._clock() + self._ttl,
                video_id=video_id,
                video_sha256=video_sha256,
                frames=frames,
                timing_mode=timing_mode,
                duration_ms=duration_ms,
                source_fps=source_fps,
                timestamp_provenance=timestamp_provenance,
                source_timing_state=source_timing_state,
                physical_time_scale=physical_time_scale,
            )
            self._items[manifest_id] = item
            return item

    def resolve(self, manifest_id: str, *, video_id: str, video_sha256: str) -> TimingManifest:
        with self._lock:
            item = self._items.get(manifest_id)
            if item is None:
                self._cleanup_locked()
                raise TimingManifestError("Timing manifest is invalid or unavailable.")
            if self._clock() >= item.expires_at:
                del self._items[manifest_id]
                raise TimingManifestExpired("Timing manifest has expired.")
            if item.video_id != video_id or item.video_sha256 != video_sha256:
                raise TimingManifestError("Timing manifest does not match this video.")
            return item

    def discard(self, manifest_id: str) -> None:
        with self._lock:
            self._items.pop(manifest_id, None)

    def _cleanup_locked(self) -> None:
        now = self._clock()
        for key in [key for key, value in self._items.items() if now >= value.expires_at]:
            del self._items[key]
