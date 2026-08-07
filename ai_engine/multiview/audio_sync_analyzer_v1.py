from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path

import av
import numpy as np


TARGET_SAMPLE_RATE = 8000
WINDOW_SECONDS = 6.0
SEARCH_RADIUS_SECONDS = 2.0


@dataclass(frozen=True)
class AudioSignal:
    samples: np.ndarray
    sample_rate: int
    first_pts_seconds: float
    source_rate: int

    @property
    def duration_seconds(self) -> float:
        return len(self.samples) / self.sample_rate

    @property
    def end_seconds(self) -> float:
        return self.first_pts_seconds + self.duration_seconds


def extract_audio(path: Path) -> AudioSignal:
    container = av.open(str(path))
    try:
        if not container.streams.audio:
            raise RuntimeError(f"No audio stream found: {path}")

        stream = container.streams.audio[0]
        source_rate = int(stream.codec_context.sample_rate or 0)
        resampler = av.AudioResampler(
            format="fltp",
            layout="mono",
            rate=TARGET_SAMPLE_RATE,
        )

        chunks: list[np.ndarray] = []
        first_pts_seconds: float | None = None

        for frame in container.decode(stream):
            if first_pts_seconds is None:
                if frame.pts is not None and frame.time_base is not None:
                    first_pts_seconds = float(frame.pts * frame.time_base)
                else:
                    first_pts_seconds = 0.0

            output_frames = resampler.resample(frame)
            for output in output_frames:
                array = output.to_ndarray()
                if array.ndim == 2:
                    array = array[0]
                chunks.append(np.asarray(array, dtype=np.float32).reshape(-1))

        for output in resampler.resample(None):
            array = output.to_ndarray()
            if array.ndim == 2:
                array = array[0]
            chunks.append(np.asarray(array, dtype=np.float32).reshape(-1))

        if not chunks:
            raise RuntimeError(f"Audio decode produced no samples: {path}")

        samples = np.concatenate(chunks)
        samples = np.nan_to_num(samples, copy=False)
        samples -= float(np.mean(samples))
        peak = float(np.max(np.abs(samples)))
        if peak > 1e-9:
            samples /= peak

        return AudioSignal(
            samples=samples,
            sample_rate=TARGET_SAMPLE_RATE,
            first_pts_seconds=(
                first_pts_seconds if first_pts_seconds is not None else 0.0
            ),
            source_rate=source_rate,
        )
    finally:
        container.close()


def time_to_index(signal: AudioSignal, seconds: float) -> int:
    return int(round((seconds - signal.first_pts_seconds) * signal.sample_rate))


def slice_time(signal: AudioSignal, start: float, end: float) -> np.ndarray:
    first = max(0, time_to_index(signal, start))
    last = min(len(signal.samples), time_to_index(signal, end))
    if last <= first:
        return np.empty(0, dtype=np.float32)
    return signal.samples[first:last]


def normalized_valid_correlation(
    search: np.ndarray,
    template: np.ndarray,
) -> np.ndarray:
    search = np.asarray(search, dtype=np.float64)
    template = np.asarray(template, dtype=np.float64)
    n = len(search)
    m = len(template)
    if m < 32 or n < m:
        return np.empty(0, dtype=np.float64)

    template = template - np.mean(template)
    template_norm = float(np.linalg.norm(template))
    if template_norm < 1e-9:
        return np.zeros(n - m + 1, dtype=np.float64)

    convolution_length = n + m - 1
    fft_size = 1 << (convolution_length - 1).bit_length()
    spectrum_search = np.fft.rfft(search, fft_size)
    spectrum_template = np.fft.rfft(template[::-1], fft_size)
    convolution = np.fft.irfft(
        spectrum_search * spectrum_template,
        fft_size,
    )[:convolution_length]
    cross = convolution[m - 1 : n]

    cumulative = np.concatenate(([0.0], np.cumsum(search)))
    cumulative_square = np.concatenate(([0.0], np.cumsum(search * search)))
    window_sum = cumulative[m:] - cumulative[:-m]
    window_square = cumulative_square[m:] - cumulative_square[:-m]
    window_variance_sum = np.maximum(
        window_square - (window_sum * window_sum) / m,
        1e-12,
    )
    denominator = template_norm * np.sqrt(window_variance_sum)
    return cross / denominator


def find_local_offset(
    camera_1: AudioSignal,
    camera_2: AudioSignal,
    center_camera_1: float,
    expected_offset: float,
    search_radius: float,
) -> tuple[float, float]:
    half_window = WINDOW_SECONDS / 2.0
    template_start = center_camera_1 - half_window
    template_end = center_camera_1 + half_window
    template = slice_time(camera_1, template_start, template_end)

    search_start = template_start + expected_offset - search_radius
    search_end = template_end + expected_offset + search_radius
    search = slice_time(camera_2, search_start, search_end)

    correlation = normalized_valid_correlation(search, template)
    if len(correlation) == 0:
        raise RuntimeError("Audio window is too short for synchronization.")

    best_index = int(np.argmax(np.abs(correlation)))
    best_score = float(abs(correlation[best_index]))
    matched_camera_2_start = search_start + best_index / camera_2.sample_rate
    offset = matched_camera_2_start - template_start
    return offset, best_score


def quality_label(score: float) -> str:
    if score >= 0.60:
        return "excellent"
    if score >= 0.35:
        return "good"
    if score >= 0.20:
        return "usable"
    return "review_required"


def analyze(camera_1_path: Path, camera_2_path: Path) -> dict:
    print("Decoding camera 1 audio...")
    camera_1 = extract_audio(camera_1_path)
    print("Decoding camera 2 audio...")
    camera_2 = extract_audio(camera_2_path)

    print(f"Camera 1 audio: {camera_1.duration_seconds:.3f} s")
    print(f"Camera 2 audio: {camera_2.duration_seconds:.3f} s")
    print(f"Analysis sample rate: {TARGET_SAMPLE_RATE} Hz")

    common_start = max(camera_1.first_pts_seconds, camera_2.first_pts_seconds)
    common_end = min(camera_1.end_seconds, camera_2.end_seconds)
    usable_duration = common_end - common_start
    if usable_duration < 24.0:
        raise RuntimeError("Not enough common audio duration for drift analysis.")

    centers = np.linspace(common_start + 7.0, common_end - 7.0, 3)

    # A wider first search establishes the coarse audio offset.
    coarse_center = float(centers[1])
    coarse_offset, coarse_score = find_local_offset(
        camera_1,
        camera_2,
        coarse_center,
        expected_offset=0.0,
        search_radius=4.0,
    )
    print(
        f"Coarse audio offset: {coarse_offset:+.6f} s "
        f"(score {coarse_score:.4f})"
    )

    measurements: list[dict] = []
    for center in centers:
        offset, score = find_local_offset(
            camera_1,
            camera_2,
            float(center),
            expected_offset=coarse_offset,
            search_radius=SEARCH_RADIUS_SECONDS,
        )
        measurements.append(
            {
                "camera_1_time_seconds": float(center),
                "camera_2_offset_seconds": float(offset),
                "correlation_score": float(score),
            }
        )
        print(
            f"Audio sync @ {center:.3f} s: "
            f"offset {offset:+.6f} s, score {score:.4f}"
        )

    times = np.asarray(
        [item["camera_1_time_seconds"] for item in measurements],
        dtype=np.float64,
    )
    offsets = np.asarray(
        [item["camera_2_offset_seconds"] for item in measurements],
        dtype=np.float64,
    )
    scores = np.asarray(
        [item["correlation_score"] for item in measurements],
        dtype=np.float64,
    )

    slope, intercept = np.polyfit(times, offsets, 1)
    predicted = intercept + slope * times
    residuals = offsets - predicted
    median_score = float(np.median(scores))

    report = {
        "status": "completed",
        "quality": quality_label(median_score),
        "method": "normalized_audio_cross_correlation_with_linear_drift",
        "camera_1": {
            "path": str(camera_1_path),
            "source_audio_rate_hz": camera_1.source_rate,
            "first_audio_pts_seconds": camera_1.first_pts_seconds,
            "audio_duration_seconds": camera_1.duration_seconds,
        },
        "camera_2": {
            "path": str(camera_2_path),
            "source_audio_rate_hz": camera_2.source_rate,
            "first_audio_pts_seconds": camera_2.first_pts_seconds,
            "audio_duration_seconds": camera_2.duration_seconds,
        },
        "analysis_sample_rate_hz": TARGET_SAMPLE_RATE,
        "coarse_audio_offset_seconds": coarse_offset,
        "coarse_correlation_score": coarse_score,
        "measurements": measurements,
        "time_mapping": {
            "formula": "camera_2_time = camera_1_time + intercept + slope * camera_1_time",
            "intercept_seconds": float(intercept),
            "slope_seconds_per_second": float(slope),
            "drift_ppm": float(slope * 1_000_000.0),
            "median_correlation_score": median_score,
            "max_fit_residual_seconds": float(np.max(np.abs(residuals))),
        },
    }

    output = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
        / "audio_sync.json"
    )
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )
    print(f"Audio synchronization saved: {output}")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Judo Mind two-camera audio synchronization analyzer"
    )
    parser.add_argument("camera_1", type=Path)
    parser.add_argument("camera_2", type=Path)
    args = parser.parse_args()

    print("Judo Mind Audio Synchronization")
    report = analyze(args.camera_1, args.camera_2)
    mapping = report["time_mapping"]
    print("\nJudo Mind Audio Synchronization Complete")
    print("Quality:", report["quality"])
    print("Offset intercept:", mapping["intercept_seconds"], "s")
    print("Clock drift:", mapping["drift_ppm"], "ppm")
    print("Median correlation:", mapping["median_correlation_score"])
    print("Max fit residual:", mapping["max_fit_residual_seconds"], "s")


if __name__ == "__main__":
    main()