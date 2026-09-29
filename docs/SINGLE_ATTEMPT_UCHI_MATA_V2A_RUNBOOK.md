# Single-Attempt Uchi Mata V2A Runbook

Status: implementation-ready, awaiting reviewed real-attempt inputs

Governing decisions: JM-DEC-021 and JM-DEC-022

Governing metric registry: `UCHI_MATA_SCIENTIFIC_METRICS_V1.md`

## Purpose

This runbook prepares the first real Level 1 Single-Attempt Uchi Mata result
for exactly three metrics:

- `UM-TIM-001` - reviewed execution duration
- `UM-ANG-001` - projected trunk inclination
- `UM-ANG-002` - projected support-leg knee angle

The workflow is descriptive. It does not judge correctness, identify an ideal
angle, infer Kuzushi/Tsukuri/Kake, reconstruct 3D, or estimate force, torque,
moment, power, load or injury risk.

## Required Human Review

Before a real V2A result can be produced, a reviewer must supply all of the
following from the same video:

1. One attempt start frame and source timestamp.
2. One attempt end frame and source timestamp.
3. The declared event-pair schema used by those boundaries.
4. The role-neutral track or frame-local pose selected as Tori, with explicit
   human confirmation.
5. The support leg (`left` or `right`), with explicit human confirmation.
6. One frame/timestamp and descriptive event label at which the two projected
   angles will be evaluated.
7. Human review of whether the selected frame has a suitable near-planar view
   and low camera roll for projected-angle reporting.

Frame-local pose order is never persistent identity. If Tori cannot be
confirmed at the selected frame, both angle metrics remain withheld. If camera
suitability is not confirmed but usable geometry exists, the angles remain
`review_required`, not `reportable`.

## Source-Time Rule

Use the video's source frame indices and source timestamps. The benchmark's
10 FPS sampling plan is an engineering evaluation setting and is not the V2A
biomechanics temporal resolution. The duration formula uses the reviewed
source timestamps directly:

`duration_seconds = (end_timestamp_ms - start_timestamp_ms) / 1000`

The multipart V2A video endpoint validates the reviewed start, end and angle
frame timestamps against the source FPS/frame timebase. It runs Pose Landmarker
only for the human-selected angle frame and stops decoding immediately after
that frame. It does not run a full-video pose pass. The pose engine must also
return the source image width and height; invalid or missing dimensions fail
closed rather than silently assuming a shape.

The prepared Flutter HTTP service sends `review_json` plus the video to:

`/v2a/analysis/single-camera/uchi-mata/single-attempt/video`

The current Analyze screen does not yet provide the required reviewed
frame/person/support-leg controls, so this service is not exposed as an
automatic user flow.

## Projected Geometry Methods

### Trunk inclination

Method version: `projected-trunk-inclination-1.0.0`

1. Compute the shoulder midpoint from left/right shoulder landmarks.
2. Compute the hip midpoint from left/right hip landmarks.
3. Build the image-plane vector from hip midpoint to shoulder midpoint.
4. Convert normalized landmark `x/y` to source-image pixel coordinates before
   computing geometry so a non-square frame does not distort the angle.
5. With image `y` increasing downward, compute the unsigned inclination from
   vertical-up as `degrees(atan2(abs(dx), -dy))`.

The result is `model-estimated` projected 2D geometry. It is not an anatomical
3D trunk angle.

### Support-leg knee angle

Method version: `projected-knee-angle-1.0.0`

Use the human-confirmed support-side hip, knee and ankle. Compute the internal
image-plane angle at the knee from the hip-to-knee and ankle-to-knee vectors
using source-image pixel coordinates and a bounded dot-product/arccos method.
Normalized coordinates are aspect-corrected with the source width/height first;
the blue overlay itself remains normalized for rendering. The result is
`model-estimated` and does not describe load, moment, injury risk or true 3D
anatomy.

## Confidence and Withholding

When all required model landmarks provide visibility, V2A preserves the
minimum required landmark visibility under the explicit label
`minimum_model_landmark_visibility`. It is not pose accuracy, scientific
validity or biomechanics confidence. No aggregate confidence is invented when
visibility is incomplete.

A spatial metric is withheld when:

- the selected pose observation is absent;
- a required landmark is absent or non-finite;
- trunk or knee geometry is degenerate;
- the selected observation does not match the reviewed frame and neutral
  track.

Withheld metrics expose no value and no overlay geometry.

## Blue Overlay

V2A may draw only the blue movement/geometry layer:

- trunk midpoint line;
- support-side hip-knee-ankle polyline;
- projected angle labels.

No force vector, COM proxy, balance direction, 3D skeleton or normative target
is part of this slice.

## Existing Authorized Benchmark Review Assets

The existing deterministic 100-timestamp fast-screening subset has been
decoded without pose inference into:

`ai_engine/runtime/annotation_review/run01/`

It contains 100 review frames, four contact sheets and an unfilled
`annotation_template.json`. The directory is runtime-only and ignored by Git.
Its status is `awaiting_human_annotation`; null fields are deliberately not
labels.

Those frames can later support human detection ground truth and the evaluator
for:

`P(two detected | at least two judoka actually visible)`

No such real conditional coverage value exists until the human labels are
complete.

## First Real Run Acceptance Criteria

- exactly one reviewed attempt;
- human-confirmed Tori and support leg;
- one reviewed angle frame inside the attempt;
- source frame/timestamp alignment preserved;
- duration provenance `measured` for the video timebase, with the human event
  source retained separately;
- both projected angles provenance `model-estimated`;
- status is `reportable`, `review_required` or `withheld` for each metric;
- no automatic role, phase, 3D, force, torque, power or normative claim;
- Flutter accepts the versioned `2.0.0` response and renders value/unit,
  provenance, meaningful visibility evidence, limitation and blue geometry.

## Exact Next Human Input

Provide one chosen attempt with start/end frame and timestamp, the selected
Tori neutral track or frame-local pose, left/right support leg, the angle
evaluation frame/timestamp and event label, plus the view-suitability/low-roll
review. If the authorized benchmark video is used, first identify which one of
its multiple attempts is the intended attempt; V2A must not average the whole
video.
