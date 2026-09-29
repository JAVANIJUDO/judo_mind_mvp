# Judo Mind Night Shift 01 Audit

Date: 2026-08-08

Scope: Safe fallback audits after the real single-camera benchmark was blocked

This document is an evidence-based audit. It does not approve new product
modules, scientific thresholds or production AI capabilities.

## A. Single-Camera Pipeline Test-Coverage Gaps

### High priority

1. Repeated and concurrent FastAPI requests do not have a test proving that the
   shared MediaPipe VIDEO-mode landmarker is safe when each video restarts its
   timestamps at zero. This is a concurrency/timestamp-lifecycle risk requiring
   an isolated test before production use.
2. Flutter's scientific boundary currently checks analysis mode and the four
   capability flags. Tests do not require schema version `1.0.0`, completed
   status, expected provenance values or the complete limitation set. An
   incompatible response could therefore pass a narrower boundary than the
   contract intends.
3. The UI tells users that the maximum duration is three minutes, but no test
   proves a server-side duration/file-size limit. The current upload is copied
   before decoding, so resource limits require explicit backend enforcement.

### Medium priority

4. API validation lacks focused tests for empty `technique_id`, suffix/content-
   type combinations, corrupt video bytes and unsupported container behavior.
5. Flutter service tests do not cover timeout, structured non-2xx detail,
   malformed JSON, incompatible schema or an affirmative forbidden capability.
6. `AnalyzeSection` has no widget test for consent gating, loading, error,
   retry, result replacement or disposal/cancellation behavior.
7. Cross-field invariants are not validated in the response model: frame counts
   can theoretically exceed analyzed frames or disagree with reported rates.
8. The unversioned legacy `/analysis/pose` endpoint has no equivalent
    provenance/capability contract or regression test.

### Real-validation gap

9. The corrected sampler, benchmark harness and identity contract have only
    synthetic/unit validation. A new explicit single-camera Uchi Mata video and
    annotated identity ground truth are separately required for real coverage
    and continuity evaluation.

## B. Flutter Analyzer Classification

The direct `flutter analyze --no-pub` command produced no output and stalled in
two attempts. `dart analyze --format machine` returned the exact 20 known
diagnostics, then encountered a denied write to the user-level Dart telemetry
session outside the workspace. No approval or system change was requested.

Summary:

| Classification | Count | Meaning |
|---|---:|---|
| Real maintenance debt | 4 | Unreferenced private UI implementations |
| Stylistic/cleanup | 10 | Imports and low-risk lint cleanup |
| Generated | 0 | No diagnostic points to generated localization code |
| Potentially risky | 6 | One apparently unused feature gate and five deprecated API uses |

### Real maintenance debt

| Diagnostic | File |
|---|---|
| `_MediaLibraryIntro` is unused | `lib/screens/technique_detail/widgets/media/media_section.dart:614` |
| `_MediaThumbnail` is unused | `lib/screens/technique_detail/widgets/media/media_section.dart:750` |
| `_MediaItemInformation` is unused | `lib/screens/technique_detail/widgets/media/media_section.dart:847` |
| `_VideoPreview` is unused | `lib/screens/technique_detail/widgets/media/video_detail_screen.dart:273` |

### Stylistic/cleanup

| Diagnostic | File |
|---|---|
| Unused `judo_icons.dart` import | `lib/core/design_system/widgets/judo_icon.dart:3` |
| Duplicate import | `lib/core/providers/technique_provider.dart:3` |
| Unused `app_theme.dart` import | `lib/main.dart:10` |
| Unused `judo_design_tokens.dart` import | `lib/screens/technique_detail/widgets/media/media_header.dart:3` |
| Unused `video_player_placeholder.dart` import | `lib/screens/technique_detail/widgets/media/video_detail_screen.dart:3` |
| Dangling library doc comment | `lib/core/design_system/illustrations/judo_illustration_type.dart:1` |
| Prefer null-aware collection element | `lib/core/widgets/judo_app_bar.dart:146` |
| Prefer null-aware collection element | `lib/core/widgets/judo_section.dart:159` |
| Unnecessary `const` | `lib/data/media/uchi_mata_media_catalog.dart:121` |
| Unnecessary multiple underscores | `lib/screens/technique_detail/widgets/media/media_filter_bar.dart:58` |

### Potentially risky

| Diagnostic | Risk |
|---|---|
| `_TechniqueDashboardItemData.isEnabled` is never supplied (`technique_dashboard_grid.dart:344`) | Intended dashboard feature gating may not be wired; behavior should be reviewed before deleting or enabling it |
| Deprecated `withOpacity` (`home_screen.dart:195`) | Flutter compatibility debt |
| Deprecated `withOpacity` (`quiz_section.dart:250`) | Flutter compatibility debt |
| Deprecated `withOpacity` (`quiz_section.dart:259`) | Flutter compatibility debt |
| Deprecated `Radio.groupValue` (`quiz_section.dart:284`) | Requires planned RadioGroup migration |
| Deprecated `Radio.onChanged` (`quiz_section.dart:290`) | Requires planned RadioGroup migration |

No bulk fix was performed.

## C. Official Module Audit

Status basis:

- `Implemented`: a registered, usable screen and material core flow exist.
- `Partial`: some source/UI entry exists, but the documented module flow is not
  complete or not routed.
- `Documentation only`: official requirements exist without a current module
  screen/route.

| # | Official module | Status | Evidence summary |
|---:|---|---|---|
| 1 | Home | Implemented | Registered `/home` screen and dashboard grid exist; full personalization remains future work |
| 2 | Techniques | Implemented | Registered list/detail flow, repository/data, Uchi Mata reference sections and AI vertical slice exist |
| 3 | Sensi Bot | Partial | Technique entry/placeholder and localization exist; no standalone registered route |
| 4 | Sensi Bet | Documentation only | Official requirements/localization exist; no dashboard entry, screen or route |
| 5 | Monitoring | Partial | Dashboard tile/localization exist; no registered screen/route |
| 6 | Judo Cast | Partial | Source has an `AudioCast` dashboard tile and Judo Cast localization; no registered screen/route |
| 7 | Athlete Profile | Partial | Dashboard tile/localization exist; no registered module flow |
| 8 | Training Center | Partial | Dashboard tile and roadmap phase exist; no registered module flow |
| 9 | Champions Hub | Partial | Dashboard tile/localization exist; no registered module flow |
| 10 | Competitions & Challenges | Partial | Competitions tile/localization exist; challenges/rankings/results flow is not implemented |
| 11 | News | Partial | Dashboard tile/localization exist; no registered module flow |
| 12 | Store & Subscription | Partial | Store tile/localization exist; subscription/payment flow is not implemented |
| 13 | Club Management | Partial | `Club Admin` tile exists; no registered management flow |
| 14 | Coach Forum | Partial | Dashboard tile/localization exist; no registered forum flow |
| 15 | Online Courses | Partial | Dashboard tile/localization exist; no registered course flow |
| 16 | Country Judo History | Partial | `Country History` tile/localization exist; no registered content flow |
| 17 | Administration & System Settings | Partial | A registered settings screen exists; documented CMS/user/admin capabilities are not implemented |

### Module-count discrepancy

At the time of this audit, the approved requirements, AGENTS.md and project
status defined exactly 17 official modules. JM-DEC-020, approved later on
2026-08-08, supersedes that current module count by establishing AI Training
Plan Intelligence as Module 18. The source dashboard currently contains 16 tiles,
including `Medical Support` and `Nutrition`, which are not separate modules in
JM-DEC-020. It also omits direct tiles for Sensi Bet, Administration/System
Settings and the new Module 18. This dashboard discrepancy needs a future
product decision; it was not resolved in this shift.

`BLOCKED — NEEDS MOHAMMAD`: decide whether the two non-official tiles are
subfeatures, future modules or obsolete entries before changing the approved
module architecture or dashboard.

## D. AI Pipeline Technical Debt

### Correctness and lifecycle

- Prove or isolate MediaPipe VIDEO-mode state per request, including monotonically
  increasing timestamps and concurrent FastAPI requests.
- Temporary-upload cleanup now has focused success and engine-failure tests; add
  corrupt-decoder and cancellation coverage later.
- A synthetic engine-level integration test proves the selected frame indices
  and monotonic timestamps passed to MediaPipe for 25 FPS to 10 FPS sampling.
- Handle invalid or unknown OpenCV frame counts without silently producing an
  empty sampling plan.
- Centralize the duplicated RTMLib valid-pose rule (eight keypoints at 0.30) only
  after its purpose is documented; it is an engineering filter, not a scientific
  acceptance threshold.
- Resolve the misleading `rtmpose_engine.py` name through a reviewed migration,
  not an unattended rename.

### Reproducibility and dependency control

- Add a reviewed Python dependency lock/manifest for MediaPipe, RTMLib, OpenCV,
  ONNX Runtime, FastAPI and test tooling.
- Record model identity and integrity hashes without committing the large model
  binaries until an explicit repository decision exists.
- Keep benchmark execution offline by default. The new harness now fails closed
  if cached RTMO-M, RTMPose-M or YOLOX-M models are absent.
- A broad `compileall ai_engine` traverses the ignored `.venv` and finds an
  invalid character in MediaPipe's packaged `text_embedder_test.py`. Targeted
  compilation of all project-owned Python modules passes; the third-party
  environment anomaly should be resolved only through a reviewed dependency
  rebuild, not by editing site-packages.

### API and resource safety

- Enforce server-side upload size, decoded duration and resource limits.
- Decide whether to remove, restrict or version the legacy `/analysis/pose`
  endpoint; no action is taken without review.
- Add structured analysis/job logging without storing raw videos or personal
  identifiers.

### Scientific validity

- Two-pose coverage remains detection coverage, not identity continuity.
- Identity requires annotated real Judo crossing/occlusion/reappearance data and
  uncertainty reporting before Tori/Uke classification.
- Camera view is collected but does not yet alter inference or quality checks.
- MediaPipe world landmarks must remain model-estimated and must never enter the
  reconstructed-3D/OpenSim path.
- Phase, trunk/knee/COM metrics and AI coaching remain gated until upstream pose,
  identity and event annotations are trustworthy.

### Performance

- The previous local MediaPipe vertical slice took about 4 minutes 40 seconds
  for 23.72 seconds of video. Profiling and production execution architecture
  remain unresolved.
- The benchmark intentionally decodes the same video per engine for isolation;
  this is reproducible but not optimized for production throughput.

## E. Autonomous Shift Follow-Up

Resolved safely on 2026-08-08:

- Shared MediaPipe VIDEO-mode inference is serialized and receives monotonic
  internal timestamps across repeated videos, while response timestamps remain
  source-relative.
- Invalid-media and empty-technique validation paths now close the upload stream;
  success and inference-failure temporary-file cleanup remain covered.
- Sampler tests cover representative and non-integer FPS, short clips, boundary
  frames and duplicate-timestamp prevention.
- Benchmark success/failure JSON schemas are aligned and round-trip serialized
  in offline tests.
- Neutral evaluation now distinguishes detection-order changes, one-person
  intervals and explicit termination/reinitialization from identity switches.

Still open:

- Unknown or unreliable OpenCV frame counts require a reviewed streaming
  fallback rather than an empty plan.
- Corrupt-decoder cancellation, request-size/duration limits and structured
  privacy-safe job logging remain unimplemented.
- No authorized real single-camera video is present, so neither engine coverage
  nor identity continuity received new real evidence.

### Smallest next vertical slice after reliable two-person detection

After a real, explicitly authorized Uchi Mata benchmark demonstrates repeatable
two-person observation and a reviewed annotation set exists, connect one neutral
tracker adapter to the benchmark only. Emit frame-level `Track A`/`Track B`
associations, unknown/unassigned states, association-confidence availability and
annotated continuity metrics. Do not assign Tori/Uke, detect phases, score the
technique or expose coaching UI in that slice.
