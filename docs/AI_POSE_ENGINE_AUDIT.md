# Judo Mind 2D Pose Engine Audit

Date: 2026-08-08

Status: Current-source audit plus non-production benchmark foundation

Scope: Single-camera 2D pose estimation only

This audit records what the current Python source actually executes. It does
not approve an engine for production identity, Judo phase detection, 3D
biomechanics, force, torque or coaching.

## Current Runtime Path

The versioned FastAPI endpoint
`POST /v1/analysis/single-camera/pose-summary` currently uses the shared
`JudoPoseEngine` from `ai_engine/pose_engine.py`. The endpoint therefore runs
MediaPipe Pose Landmarker Heavy. RTMPose-M remains the research baseline in the
architecture decision records, but it is not the engine behind the current
vertical-slice endpoint.

## Capability Matrix

| Engine/path | Multi-person behavior | Current implementation | Model and dependencies | Keypoint format | Confidence signal | CPU execution | Tracking support | Current limitations |
|---|---|---|---|---|---|---|---|---|
| MediaPipe Heavy API path | Configured for up to two frame-local poses | `JudoPoseEngine`; used by `ai_engine/main.py` | Ignored local `pose_landmarker_heavy.task`; MediaPipe Tasks | 33 normalized image landmarks plus model-relative world landmarks | Landmark visibility and presence | MediaPipe Tasks CPU; current development endpoint is locally runnable | MediaPipe VIDEO mode has internal temporal tracking, but the project exposes no persistent athlete identity | `pose_index` is frame-local; world landmarks are model-estimated and are not calibrated/reconstructed 3D; two-athlete coverage is not production quality |
| RTMO-M experiment | Native one-stage multi-person pose inference | `JudoRTMOEngine` in the misleadingly named `ai_engine/rtmpose_engine.py`; `Body(pose="rtmo", mode="balanced")` | RTMLib 0.0.16, RTMO-M body7 ONNX, ONNX Runtime 1.28.0 | COCO 17 image-pixel keypoints | Per-keypoint model score | ONNX Runtime CPU; locally installed/cached | No identity tracker in the project wrapper | Summary only; no frame-level identity; file name must not be interpreted as RTMPose-M |
| RTMPose-M diagnostic | YOLOX-M person detector followed by top-down RTMPose-M | `JudoPoseDiagnostic` in `ai_engine/diagnostic_overlay.py`; default balanced `Body(...)` without `pose="rtmo"` | RTMLib 0.0.16, YOLOX-M and RTMPose-M body7 ONNX, ONNX Runtime 1.28.0 | COCO 17 image-pixel keypoints | Per-keypoint model score | ONNX Runtime CPU; locally installed/cached | No persistent identity in this diagnostic | Development diagnostic writes ignored overlay/failure artifacts; labels such as ATHLETE 1/2 are display order, not identity |
| RTMPose-M clean benchmark adapter | Top-down multi-person detections from YOLOX-M boxes | `RTMPoseMRunner` in the non-production benchmark harness | Same locally cached RTMLib/YOLOX-M/RTMPose-M stack | COCO 17 image-pixel keypoints | Per-keypoint model score | ONNX Runtime CPU | Deliberately disabled; pose order remains frame-local | Benchmark-only; not connected to FastAPI or Flutter |
| RTMPose-M + RTMLib PoseTracker | Library tracker can associate pose boxes using greedy IoU and can reuse boxes between detector frames | Available in the installed RTMLib package and represented in historical project benchmark records; no current Judo Mind source adapter | RTMLib `PoseTracker` plus YOLOX-M and RTMPose-M | COCO 17 keypoints reordered internally by the tracker | Pose scores; no validated Judo identity confidence contract | Library is CPU-capable through ONNX Runtime | Dependency capability only; not a current project feature | No current source path exposes stable IDs; greedy IoU is not validated for Judo crossing, prolonged occlusion or reappearance; historical results were not rerun in this shift |

## Deterministic Sampling Correction

The former integer-stride calculation rounded `25 / 10` to a stride of 2 and
therefore analyzed approximately 12.5 FPS. The current worktree replaces that
logic in all three existing single-camera 2D paths with the shared strategy
`nearest_source_frame_to_target_timestamp`.

For every requested timestamp, the plan selects the nearest source frame using
deterministic half-up rounding. It never duplicates frames when the requested
rate exceeds the source rate. Boundary behavior is explicit: a 25 FPS,
593-frame source produces a 238-frame plan for a requested 10 FPS. This is a
unit-tested plan calculation, not a new analysis of the prior real video.

The same plan is now validated for 24, 25, 30, 50 and 60 FPS, non-integer
29.97 FPS, one-frame clips and high-rate integer-millisecond tie cases. Source
frame timestamps use deterministic half-up rounding and must be strictly
increasing. Effective sampling is capped by the source rate and the 1000 Hz
integer-millisecond timebase.

`JudoPoseEngine` reports source-relative timestamps for every video. Its shared
MediaPipe VIDEO landmarker is serialized and receives a separate monotonically
increasing internal time range for each video, preventing timestamp reset or
concurrent-call ordering from violating the MediaPipe runtime contract.

## Benchmark Harness

`ai_engine/benchmarks/pose_engine_benchmark.py` is an experimental,
non-production comparison harness. An operator must provide an explicit video
path. It gives every runner the same video and timestamp-based sampling plan,
then emits versioned JSON and a human-readable comparison.

The harness performs an offline cache preflight for RTMO-M, RTMPose-M and
YOLOX-M. If any required ONNX file is absent, that engine fails independently
with automatic model download disabled.

Completed and failed runners expose the same metric-key schema. A failed runner
uses zero coverage, unavailable timing and confidence values, and a structured
failure record; it does not abort the other engines or invent results.

Recorded metrics are:

- processed frames;
- frames with at least one pose;
- frames with at least two poses;
- one-pose and two-or-more-pose coverage;
- initialization and processing time;
- processing FPS and effective analyzed FPS;
- whether the engine exposes a keypoint confidence signal;
- isolated engine failures.

The output explicitly states that pose order is frame-local and does not claim
Tori/Uke identity, phase classification, measured or reconstructed 3D, force,
torque or coaching validity.

Video container metadata is labeled `measured`. Pose coverage and model
confidence signals are labeled `model-estimated`; the harness does not promote
either to measurement, reconstruction or identity truth.

## Neutral Tracking Foundation

`ai_engine/tracking/identity_contract.py` defines an interface and evaluation
contract only. It does not implement or approve a production tracker.

- Detections remain `model-estimated`.
- Cross-frame associations remain `AI-inferred`.
- Only neutral identifiers such as `Track A` and `Track B` are allowed.
- Tori/Uke labels are rejected at this layer.
- Synthetic evaluation can count assignment coverage, identity switches,
  switches during annotated crossings and continuity after occlusion or
  reappearance.
- Detection-order swaps, one-person intervals and explicit track
  termination/reinitialization are evaluated separately from identity switches.
- Lost or terminated observations cannot claim an active detection or
  association confidence.
- Association-confidence availability and mean are reported only when a tracker
  supplies confidence; the evaluator never invents missing confidence.

Real Judo identity quality must later be evaluated with explicit annotations
covering crossing, partial and full occlusion, fast motion, entry/exit and
reappearance. Synthetic tests prove contract behavior only.

## Real-Video Execution Status

An explicitly authorized single-camera Uchi Mata benchmark video is now present
under ignored runtime input storage. It is 110.72 seconds long, 640 x 360, 25
FPS and 2,768 native frames. The deterministic 10 FPS full plan contains 1,108
source frames from frame 0 / 0 ms through frame 2,767 / 110,680 ms.

The previous run produced two completed ignored JSON artifacts:

| Engine | Planned | Processed | Missing | Initialization | Processing | Processing FPS | Device |
|---|---:|---:|---:|---:|---:|---:|---|
| MediaPipe Heavy | 1,108 | 1,108 | 0 | 2.514 s | 1,041.077 s | 1.064 | CPU, MediaPipe/TFLite XNNPACK |
| RTMPose-M + YOLOX-M | 1,108 | 1,108 | 0 | 2.727 s | 8,658.745 s | 0.128 | CPU, ONNX Runtime CPUExecutionProvider |
| RTMO-M | 1,108 | not recoverable | not recoverable | not recoverable | not completed | not available | CPU configuration, ONNX Runtime CPUExecutionProvider |

Both completed artifacts exactly match the shared 1,108-frame plan. The code
decoded the 2,768 native frames sequentially to reach the distributed samples,
but model inference ran only on the selected 1,108 frames. Neither completed
engine inferred every native frame.

RTMPose-M was the long-running engine. Its processing took approximately 8.32
times MediaPipe Heavy and the initialization time for both engines was only
about 2.5--2.7 seconds. The old artifact schema did not separate decode,
wrapper preprocessing and model-call time, so an exact historical stage split
cannot be recovered. Code inspection nevertheless shows that every sampled
RTMPose frame invokes synchronous YOLOX-M person detection followed by
RTMPose-M inference on CPU. The common sequential decode path cannot explain
the additional 7,617.669 seconds, making the two-stage CPU model call the
dominant supported cause. This is a diagnosis from code and comparative timing,
not a recovered per-stage measurement.

There is no retry loop in any of the three runners. RTMPose-M completed all
samples, so the long run was not a model hang. The prior combined runner wrote
only at the end and therefore lost in-progress evidence when externally timed
out. RTMO-M was subsequently cancelled after approximately 239.8 process CPU
seconds, before an engine artifact or a recoverable processed-frame count was
written. No RTMO performance or coverage result is claimed from that aborted
attempt.

No CUDA provider was available or selected. The observed ONNX Runtime provider
set was AzureExecutionProvider plus CPUExecutionProvider; project runners
explicitly requested `device="cpu"`. MediaPipe reported its CPU XNNPACK
delegate. No engine used GPU/CUDA.

## Benchmark Control Hardening

The benchmark schema is now version 1.2.0. The control path adds:

- per-engine processed/total progress, elapsed time, effective processing FPS
  and ETA after a minimum stable sample count;
- an explicit per-engine wall-clock budget, checked before and after each model
  call, so a slow engine becomes `timed_out` and the next engine can continue;
- cooperative Ctrl+C cancellation with a final partial engine record;
- partial observations and missing-frame counts for timed-out or cancelled
  engines;
- atomic JSON/report checkpoint replacement after every engine;
- explicit runtime device and execution-provider fields;
- stage timing for decode, wrapper preprocessing, model call and
  postprocessing in newly completed runs.

Timeout and cancellation are intentionally cooperative at sample boundaries.
Native C/ONNX inference cannot be interrupted safely in the middle of one model
call; a cancellation request or deadline is applied as soon as that call
returns. This limitation is reported rather than hidden.

## FAST SCREENING Mode

FAST SCREENING Run 01 completed on 2026-08-08. It selected 100 timestamp-plan
entries by deterministic, content-neutral, even distribution across the full
1,108-sample plan. The selection includes frame 0 / 0 ms and frame 2,767 /
110,680 ms. The ignored combined JSON artifact retains all 100 exact frame
indices and timestamps and confirms that every engine observation matches them.

The completed 1,108-observation MediaPipe Heavy and RTMPose-M artifacts already
contained every selected timestamp and pose count. Those engines were not run
again. Their 100-sample coverage was derived from stored observations. Only
RTMO-M performed new inference, with a 20-minute per-engine budget.

| Engine | Result source | Processed | Missing | >=1 person | >=2 persons | New processing | Processing FPS evidence |
|---|---|---:|---:|---:|---:|---:|---:|
| MediaPipe Heavy | Reused 1,108-sample artifact | 100 | 0 | 91% | 25% | 0 s | 1.064 from complete source run; no subset runtime reconstructed |
| RTMPose-M + YOLOX-M | Reused 1,108-sample artifact | 100 | 0 | 95% | 46% | 0 s | 0.128 from complete source run; no subset runtime reconstructed |
| RTMO-M | New 100-sample inference | 100 | 0 | 86% | 42% | 677.966 s | 0.147 screening FPS |

RTMO initialization plus processing was 681.351 seconds; the observed complete
command wall time was 693.4 seconds. It completed without failure or timeout on
ONNX Runtime CPUExecutionProvider. Of its processing time, 668.960 seconds was
inside the RTMLib model call, 8.893 seconds in sequential video decode, 0.011
seconds in wrapper preprocessing and 0.031 seconds in wrapper postprocessing.

Screening reports only at-least-one-person coverage, at-least-two-person
coverage, available keypoint confidence, failures and runtime. It does not
claim athlete identity, Uchi Mata phase, technique quality, 3D, force, torque,
COM or biomechanics. Completion makes an engine eligible for manual review;
the harness does not invent an automatic scientific pass threshold.
The CLI refuses a longer benchmark unless engines are selected explicitly with
`--engine` after that review, preventing an accidental all-engine rerun.

The 10 FPS benchmark target remains an engineering/evaluation setting. It is
not a fixed temporal resolution for future scientific biomechanics analysis.

All three model families expose a keypoint-confidence signal. The reused
artifacts retain only their full-run aggregate confidence, not a subset-specific
aggregate. RTMO retains its 100-sample model-specific mean. These raw scores
have different model semantics and are not directly ranked. The artifacts do
not retain a common per-keypoint completeness contract, so keypoint
completeness is reported as unavailable rather than invented.

This screening measures detection coverage, reliability and operational CPU
cost. It contains no ground-truth landmark or athlete-role annotations and
therefore makes no pose-accuracy claim. RTMPose-M and RTMO-M are the two
operational candidates for the next role-neutral Track A/B and annotated
identity/reliability evaluation. Their four-point two-person coverage difference
is not scientific proof that either pose model is more accurate. MediaPipe
Heavy remains a useful fast API baseline but is not the leading two-person
coverage candidate on this subset.
