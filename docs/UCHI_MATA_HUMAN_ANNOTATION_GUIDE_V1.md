# Uchi Mata Human Annotation Guide v1

Status: ready for human review; no labels completed

Related workflow: `SINGLE_ATTEMPT_UCHI_MATA_V2A_RUNBOOK.md`

## Scientific Boundary

This annotation task records visible video evidence and explicit reviewer
selections. It is not pose inference, technique scoring or a medical/safety
assessment. Do not infer hidden joints, force, torque, power, load, COM, true
3D geometry or Kuzushi/Tsukuri/Kake when they are not directly reviewable under
an approved event schema.

## Review Assets

The current draft is:

`ai_engine/runtime/annotation_review/run01/annotation_template.json`

Images and contact sheets are in sibling `frames/` and `contact_sheets/`
directories. Runtime content is intentionally ignored by Git.

The draft must retain:

- `schema_version = 1.1.0`
- `annotation_type = single_attempt_uchi_mata_ground_truth_draft`
- `status = awaiting_human_annotation`
- `pose_inference_run = false`
- the existing video SHA-256, screening-artifact SHA-256, sample positions,
  frame indices, timestamps and image paths

Do not change source video, sample order, frame index, timestamp or image path.
The preparation command refuses to overwrite an existing annotation template,
so a later rerun cannot silently destroy reviewer work. It also verifies that
the source video and screening artifact do not change during preparation.
Validation requires each JPEG path to encode its exact sample position, frame
index and timestamp, preventing an image/label row from being silently swapped.

Before and during review, inspect completion without modifying the draft:

```powershell
ai_engine/.venv/Scripts/python.exe -m ai_engine.annotations.validate_annotation_draft `
  ai_engine/runtime/annotation_review/run01/annotation_template.json
```

The report lists every missing reviewer field, per-field missing-frame count and
incomplete sample position. `labels_inferred_or_defaulted` must remain `false`.
Use `--require-ready` in validation automation when an incomplete draft should
return exit status 2. Readiness schema `1.1.0` also verifies that every review
JPEG exists, is readable and matches the source width/height; label completion
cannot pass if those review assets are missing, corrupt or dimensionally wrong.
The conditional artifact evaluator invokes this same asset gate and cannot
bypass it by finalizing the in-memory JSON model directly.

### Optional CSV frame-label workflow

To avoid manually editing 100 JSON frame rows, export an offline CSV:

```powershell
ai_engine/.venv/Scripts/python.exe -m ai_engine.annotations.annotation_csv export `
  ai_engine/runtime/annotation_review/run01/annotation_template.json `
  ai_engine/runtime/annotation_review/run01/frame_labels.csv
```

Only edit the six human-label columns. The sample position, frame index,
timestamp and image columns are immutable evidence references. Use semicolons
between multiple subject IDs. A blank subject-list cell remains incomplete;
write `[]` only when the human reviewer confirms that no visible subject ID
applies. For `occlusion` and `crossing`, use only `true`, `false` or blank.

Import into a new draft path:

```powershell
ai_engine/.venv/Scripts/python.exe -m ai_engine.annotations.annotation_csv import `
  ai_engine/runtime/annotation_review/run01/annotation_template.json `
  ai_engine/runtime/annotation_review/run01/frame_labels.csv `
  ai_engine/runtime/annotation_review/run01/annotation_with_frame_labels.json
```

Export and import refuse to overwrite existing outputs. Import validates the
immutable evidence columns and the full draft contract before writing. It does
not fill the top-level `human_review` fields and never converts blanks to
negative labels.

## Reviewer Metadata

Complete `human_review` only after inspecting the video/contact sheets:

- `annotation_source`: exactly `human-reviewed`
- `reviewer_reference`: a stable non-sensitive reviewer label
- `reviewer_notes`: optional uncertainty/context notes
- `reviewed_attempt`: one start/end frame and timestamp plus declared event
  schema
- `selected_tori_subject_reference_id`: a role-neutral subject reference such
  as `subject-1`, after human role confirmation
- `support_leg`: `left` or `right`, with `human-confirmed` source

If the video contains multiple attempts, select exactly one. Do not average or
combine attempts.

## Per-Frame Labels

For every one of the 100 frames, complete:

### `visible_judoka_count`

Count judoka who are actually visible enough to be recognized as a person in
the frame. Do not use model detections while assigning this label.

- `0`: no judoka visibly present
- `1`: one judoka visibly present
- `2`: two judoka visibly present
- greater values only if additional judoka truly appear

Partial body visibility can still count as visible if the reviewer can identify
the person as present. Explain genuinely ambiguous cases in `reviewer_notes`.

### `visible_subject_reference_ids`

Use stable role-neutral IDs such as `subject-1`, `subject-2`. Keep the same ID
through crossing and reappearance when the human reviewer can verify
continuity. Do not use `Tori` or `Uke`, including those role words embedded as
tokens inside a longer ID, as tracking IDs.

The number of named visible subjects cannot exceed `visible_judoka_count`.

### `selected_tori_subject_reference_id`

Use the reviewed attempt-level subject ID only when that subject is visible in
the frame. Use `null` when the reviewed Tori is not visible or cannot be
verified. Never guess from left/right position or detection order.

### `occlusion`

Set `true` when one body/judoka materially blocks another or important body
parts are hidden. Clothing overlap alone is not necessarily an occlusion;
record what affects person/landmark interpretation.

### `crossing`

Set `true` when the visible subjects cross or exchange image-plane ordering in
a way that challenges identity continuity. Crossing does not itself prove an
identity switch.

### `reviewer_notes`

Record ambiguity, unusual camera framing, entry/exit, disappearance,
reappearance, or why a subject ID is withheld. Notes are evidence context, not
coaching judgments.

## Completion Gate

The draft cannot become ground truth until:

- all reviewer metadata is complete;
- all 100 frames have visible count, visible subject list, occlusion and
  crossing labels;
- per-frame Tori selections agree with the attempt-level reviewed subject;
- frame indices/timestamps remain unique and ordered;
- every frame and attempt boundary matches the measured source-video timebase;
- the reviewed Tori is visibly confirmed in at least one annotated frame inside
  the selected attempt;
- support leg and attempt boundaries are human-confirmed.

The Python finalizer fails closed on any missing required field. Null draft
fields are not negative labels and must never be converted to zero/false by
default.

## Conditional Detection Evaluation

After completion, run the artifact evaluator separately for each engine. It
reads stored pose counts and performs no new inference. It calculates:

- `P(at least one detected | at least one judoka visible)`
- `P(at least two detected | at least two judoka visible)`
- detection-deficit and detection-surplus frames
- missing and unexpected prediction rows
- the same conditional metrics for frames with occlusion, frames with crossing,
  and frames clear of both conditions
- four mutually exclusive strata: occlusion only, crossing only, both present,
  and neither present

Missing predictions count as failures for labelled visible frames; they are not
removed from the denominator. Extra predictions outside the human review set
are reported separately. The broad occlusion and crossing slices can overlap;
use the four exclusive strata for direct between-condition comparisons. Their
additive counts must partition the all-frame metrics exactly.

Example command after labels are complete:

```powershell
ai_engine/.venv/Scripts/python.exe -m ai_engine.annotations.evaluate_detection_artifact `
  ai_engine/runtime/annotation_review/run01/annotation_template.json `
  ai_engine/runtime/benchmark_outputs/run01_fast_screening_combined.json `
  rtmpose-m `
  --output ai_engine/runtime/annotation_review/run01/rtmpose_m_evaluation.json
```

Repeat with `mediapipe-heavy` and `rtmo-m`. Do not compare raw confidence values
across model families. Conditional detection coverage is not pose accuracy,
identity accuracy or biomechanics validity. Before evaluation, the tool verifies
the screening-artifact SHA-256, source-video SHA-256 and metadata, exact
100-frame/timestamp subset, selection method and shared-timestamp declaration.
An artifact mismatch fails closed.
All annotation-tool outputs use create-new semantics. Existing manifests, CSVs,
merged drafts, readiness reports and evaluation JSON files are never silently
overwritten; choose a new output path when retaining another run.

## Neutral Track A/B Evaluation Boundary

Role-neutral tracking evaluation requires frame index and source timestamp for
every assignment. It rejects non-finite boxes/keypoints/scores, unknown event
tags, conflicting frame/timestamp mappings and detection IDs attached to an
unassigned subject. The evaluator explicitly reports when two human subject
references are mapped to the same neutral track or the same frame-local
detection in one frame.

These collision, switch, crossing, disappearance and reappearance counts are
evaluation diagnostics only. They do not establish tracking accuracy and never
authorize automatic Tori/Uke identity. Reference rows explicitly remain
`human-reviewed`, while predicted neutral-track assignments remain
`AI-inferred`; either provenance value is fixed and validated.
