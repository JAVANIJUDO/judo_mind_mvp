# Judo Mind Away Shift 01 Progress Report

## Shift Control

- Objective: First coach-useful Single-Attempt Uchi Mata Analysis V2A
- Start: 2026-08-08 16:33:53 +03:30
- Interim checkpoint: 2026-08-08 19:04:11 +03:30
- Continuation started: 2026-08-08 19:12:08 +03:30
- End: 2026-08-08 21:01:06 +03:30
- Actual elapsed: 4 hours 27 minutes 13 seconds
- Status: V2A implementation, ground-truth readiness, conditional evaluation,
  neutral tracking and final API/presentation hardening complete within the
  safe shift boundary; real reviewed input remains blocked on human selection
- Governing decisions: JM-DEC-018, JM-DEC-019, JM-DEC-021, JM-DEC-022
- Governing metric specification: `UCHI_MATA_SCIENTIFIC_METRICS_V1.md`

## Safety Boundary

- Preserve all existing uncommitted work.
- No Stereo, Calibration, Multiview or OpenSim processing.
- No model download or new heavy/full-video benchmark.
- No Git stage, commit, push, merge, reset or destructive cleanup.
- Human selection remains required for attempt boundaries, Tori and support leg
  until corresponding automation is validated.

## Progress

### 2026-08-08 16:33 +03:30

- Shift started and Goal registered.
- Repository governance, JM-DEC-021 and the Uchi Mata scientific metric
  specification reviewed.
- Working-tree preservation audit started.

### 2026-08-08 16:34-17:16 +03:30

- Audited existing V1 FastAPI/Flutter flow and neutral identity contracts.
- Implemented V2A contracts and the three versioned metric methods with
  reportable/review-required/withheld behavior.
- Added a selected-frame MediaPipe observation adapter and internal V2A
  evaluation endpoint without changing the V1 upload route.
- Added human annotation and conditional detection evaluators without creating
  labels.
- Prepared 100 ignored review frames and four contact sheets from the existing
  exact fast-screening timestamps; no pose inference ran.
- Extended neutral Track A/B readiness for timestamped observations,
  uncertainty, withholding, crossing, occlusion and reappearance.
- Added the Flutter V2A parser, result card and blue overlay layer.
- Added exact human-selected source-frame sampling, source-time validation,
  early decode stop, a reviewed-video V2A endpoint and typed Flutter HTTP
  service. Tests use fake inference only; no real pose run occurred.
- Added English/Persian result localization and synchronized scientific,
  architecture, product, status and changelog documentation.
- Added source image dimensions to the pose observation boundary and converted
  normalized landmarks to aspect-correct image-pixel geometry before angle
  math; overlays remain normalized for rendering.
- Hardened the Flutter boundary against malformed overlay shapes and prevented
  transport errors from exposing internal exception details.
- Final validation: all 98 Python tests and 13 focused Flutter
  parser/widget/service and V1 regression tests pass. Targeted Dart static
  analysis reports no issues. Full-project `flutter analyze --no-pub` reached
  its 244.1-second timeout without emitting a diagnostic and is not counted as
  a pass.

## Interim Checkpoint 1

The safe implementation and quality-hardening backlog within V2A is complete.
No real coach-useful result was generated because the required reviewed human
selections do not yet exist. Synthetic/fake tests validate software behavior,
contract boundaries and math only; they do not validate real pose accuracy or
scientific correctness on an athlete.

Final safety audit:

- `git diff --check` passes; only Git's existing LF-to-CRLF notices remain.
- The Git index is empty: no file is staged.
- The authorized input SHA-256 is still
  `603c1bcd79857c928811a32ec97de5de002e7f2f90b6a1e48a5a4a7b8ca02f14`.
- Review artifacts remain under ignored runtime storage with
  `pose_inference_run=false` and `status=awaiting_human_annotation`.
- No commit, push, merge, reset or destructive cleanup occurred.

### 2026-08-08 19:12 +03:30 - continuation

- Re-read the live progress, mandatory project references and complete Git
  working-tree state; no completed V2A core work was repeated.
- Upgraded the annotation contract to `1.1.0`, binding draft/final ground truth
  to screening-artifact and source-video SHA-256 provenance.
- Added a read-only readiness tool that reports every missing review field and
  incomplete frame without converting nulls to labels.
- Added exact source-timebase and reviewed-attempt Tori-confirmation gates plus
  protection against overwriting an existing annotation draft.
- Preserved canonical sample/image references through finalization, rejected
  swapped image/frame/timestamp rows and guarded against a screening artifact
  changing during review-asset extraction.
- Added an offline CSV round trip for the 100 frame labels; it locks evidence
  columns, preserves blanks, validates into a new draft and refuses overwrite.
- Rejected boolean/floating-point coercion for integer frame/time/count evidence.
- Rejected embedded Tori/Uke role tokens from role-neutral subject IDs.
- Added review-asset preflight; the live set has 100/100 readable 640x360 JPEGs
  with no missing, corrupt or dimension-mismatched asset.
- Required conditional artifact evaluation to pass that same asset preflight,
  preventing direct model finalization from bypassing the path gate.
- Made readiness reports reject inconsistent counts, finalization/status flags
  and missing/unreadable/readable asset partitions.
- Made every annotation manifest/report/evaluation/CSV/merged-draft output
  create-new so an existing reviewer or result file cannot be overwritten.
- Added fail-closed artifact/video/subset alignment and conditional detection
  slices for occlusion, crossing and clear frames, then added mutually exclusive
  occlusion-only/crossing-only/both/neither strata with a partition invariant.
- Hardened role-neutral Track A/B evaluation with timestamps, finite
  geometry/score/confidence checks, controlled event tags and explicit
  one-to-one track/detection collision counts.
- Fixed Track A/B evaluation sources to `human-reviewed` references and
  `AI-inferred` predicted associations.
- The live draft remains honestly blocked: 0/100 frames complete, all required
  reviewer fields missing and `labels_inferred_or_defaulted=false`.
- All 118 Python tests pass after the continuation hardening; no Flutter source
  changed, so no additional Flutter-tool run was required.
- A final repeat of the three focused Flutter files produced no output before a
  183.2-second timeout. It is neither a pass nor a source failure; the earlier
  13-test pass remains the latest successful Flutter result.
- No inference, Stereo, Calibration, Multiview or OpenSim processing occurred.

### 2026-08-08 20:28-21:01 +03:30 - final integration audit

- Audited the Python response contract, Flutter parser/service/result card and
  current Analyze routing against JM-DEC-022.
- Bound an accepted Flutter response to the exact reviewed video, camera,
  attempt, neutral track, detection, support leg, angle frame/event and
  camera-suitability request so a stale or crossed result fails closed.
- Tightened Python and Flutter BLUE geometry to finite normalized in-frame
  coordinates, non-blank labels and the exact approved primitive order and
  point counts. Extra, reordered or malformed geometry is rejected.
- Kept the existing V1 Analyze action unchanged. Connecting V2A requires a
  deliberate human-review UI for the five manual gates; no automatic defaults
  or guessed frame/person selections were introduced.
- Focused Python metric/video-API tests passed 23/23; the full Python suite
  passed 118/118; relevant Python syntax compilation and `git diff --check`
  passed.
- `dart format` produced no output before a 121.9-second timeout. A focused
  two-file V2A Flutter test command also produced no output before a
  259.3-second timeout. Neither timeout is recorded as a pass or source
  failure; the current Flutter hardening still needs a successful tool run.
- No inference, Stereo, Calibration, Multiview or OpenSim processing occurred.
- No Git staging, commit, push, merge, reset or destructive cleanup occurred.

## Blockers

### BLOCKED — NEEDS MOHAMMAD: first real coach-useful result

Required decision/input:

- choose exactly one attempt and provide reviewed start/end source
  frame/timestamp plus event-pair schema;
- confirm which frame-local detection/neutral track is Tori;
- confirm left/right support leg;
- select the angle frame/timestamp and event label;
- confirm near-planar view suitability and low camera roll.

No AI/system default is permitted for these gates. Implementation and quality
hardening continue independently.

### BLOCKED — NEEDS HUMAN REVIEWER: real detection ground truth

The prepared 100-frame draft still contains null labels. A human reviewer must
complete visible judoka count, role-neutral subject references, Tori visibility,
occlusion and crossing fields before conditional detection coverage can be
calculated. Null fields are not treated as zero/false.
