# Judo Mind Changelog

All important changes and development milestones are recorded here.

## 2026-09-11 — JM-UM-GS-1 Evidence Intake and Claim Matrix

### Added

- Added 22 source-bound Uchi-mata Gold claim records, a 22-item
  Evidence × Measurement matrix, per-item camera requirements and a ten-source
  data-acquisition register.
- Added typed claim, measurement-matrix, camera-requirement and acquisition
  contracts with extra-field rejection and hard non-production defaults.
- Added focused integrity tests for source/claim identity, explicit unknowns,
  threshold ineligibility, zero green activation, locked physical/medical
  outputs, camera scope, rights, Ono-source separation, markerless transfer
  limits and active D2 debt.

### Changed

- Formally intaken ten exact official, direct-Judo and measurement-method
  source identities as `JM-SRC-0063`–`0072`; added PMID `41133568` to the
  existing B1 record and expanded the Gold evidence/rights profiles to 16 rows.
- Recorded JM-DEC-040 and the evidence-to-interpretation separation required by
  JM-UM-GS-1.

This is a research/governance knowledge layer only. It activates no scientific
metric, threshold, event detector, identity/tracking, 3D/kinetic output,
technical judgement, coaching rule or media/data right. The interpretation
registry remains empty and D2 remains active/not closed. No inference,
benchmark, staging, commit or push occurred.

## 2026-09-11 — JM-UM-GS-0 Uchi-mata Gold Scientific Foundation

### Added

- Added a non-production typed Python schema for versioned Uchi-mata Gold
  evidence, observable events, source-specific phases, measurements,
  validation gaps, future interpretation rules and rights governance.
- Added a ten-row evidence profile, E0–E7 research event ontology, three
  source-operational phase definitions, a 15-row profile over existing Level-1
  metric IDs, a fail-closed gap matrix, an intentionally empty interpretation
  rule registry and a ten-row rights registry.
- Added focused tests for stable technique/version identity, explicit unknowns,
  no scientific/production activation, provisional E4/E5, no automatic event
  or phase output, canonical metric linkage, locked coaching, absent kinetics,
  empty rules, no training rights and preservation of active D2 debt.

### Changed

- Extended scientific-foundation taxonomy, architecture, implementation rules
  and decision governance with JM-DEC-039. Canonical source, metric, metric-gap
  and capability registries remain the source of truth; Gold profiles are
  additive and do not supersede them.

No application behavior, API, Flutter UI, V2A formula/schema, D1/D2 gate,
MediaPipe configuration, detector, tracker, identity, phase, score, coaching
rule, source/media asset or scientific claim was activated or changed. No
force, torque, power, injury-risk or single-camera 3D capability was added. No
inference, benchmark, video processing, commit or push occurred.

## 2026-09-11 — D2 Bounded MediaPipe Review Context

- Replaced isolated selected-frame VIDEO-mode inference in Guided PREPARE with
  a deterministic, contiguous and attempt-start-clamped context plan ending at
  the exact human-selected Review Frame.
- Added an engineering-only maximum pre-roll of 500 ms. Warm-up outputs are
  discarded; only the exact Review Frame can create D2 candidate evidence.
- Isolated the MediaPipe context used by each Guided PREPARE while preserving
  the existing analysis lock and strictly increasing per-instance timestamps.
- Preserved candidate eligibility, session binding, human-only Tori selection,
  V2A 2.0.0, four metrics and `multi_person_evidence_status=insufficient`.
- Added focused tests for frame-rate-aware bounds, attempt-start clamping,
  context isolation, lock cleanup and warm-up evidence exclusion. The focused
  batch passed `49/49`.
- The correct 640x640 diagnostic video produced two raw and two selectable
  candidates at Frame 64 / 2133 ms using Frames 49–64. This is one-video
  implementation evidence, not pose-accuracy or scientific validation. D2
  remains active pending positive real-device validation.
- Recorded JM-COMP-01 as future comparative-product governance only; no
  competitor feature or runtime behavior was implemented.

---

## 2026-09-11 — Human-First Tori Role Assignment Foundation

- Added an explicit Guided confirmation `role_assignment` containing only
  `role=TORI`, `source=HUMAN_CONFIRMATION` and the selected session-bound
  candidate token.
- Made the backend resolve the exact stored candidate through that assignment
  and reject missing assignments, AI-derived role sources, identity fields and
  cross-session token substitution.
- Kept Flutter candidate selection empty by default, required separate human
  Tori confirmation and retained candidate-change invalidation and disabled
  Run behavior until the full human review is valid.
- Preserved V2A 2.0.0, four metrics, formulas, BLUE geometry, provenance,
  MediaPipe configuration and all D1/D2 fail-closed gates.
- Documented Competition Timeline assistance and the Coach Analysis
  Marketplace as separate future layers only; no runtime feature, tactical
  judgment, payment or coaching-truth capability was added.
- Guided backend tests passed `21/21`; complete Guided Flutter tests passed
  `22/22`. Device revalidation remains pending.

---

## 2026-09-10 — D2 Multi-Person Frame-Candidate Evidence (Active)

- Added distinct `detected_pose_count`, `selectable_candidate_count` and
  fail-closed candidate-set statuses. Detected poses mean model-returned poses
  in one selected frame only, never actual people, judoka, tracks or identities.
- Required two independent selectable pose-available candidates before the D2
  human-selection path can analyze. One valid pose is insufficient and zero
  valid poses is explicitly non-selectable; both states are enforced in the
  server session as well as Flutter.
- Added candidate evidence for pose and required-landmark availability,
  model-estimated provenance and model visibility-field availability. Track ID
  and association confidence remain explicitly unavailable, and visibility is
  not presented as accuracy or scientific confidence.
- Kept PREPARE role- and track-neutral. The existing V2A adapter receives an
  analysis-local neutral label only after explicit human Tori confirmation of
  the exact session-bound stored candidate; it is not temporal tracking.
- Added English/Persian fail-closed presentation plus tests for two/one/zero,
  malformed and duplicate-index evidence, tampered contracts, no preselection,
  no automatic Tori, exact stored-pose use, token isolation and D1 regressions.
- Preserved V2A 2.0.0, its four metrics, formulas, BLUE geometry, timing and
  scientific limits. Automatic identity remains false and multi-person evidence
  remains insufficient. D2 is active and awaits real-device validation.

---

## 2026-09-09 — D1 Edit Attempt Boundaries and Review-State Integrity

- Fixed the real-device Edit -> reconfirm -> PREPARE lifecycle failure. The
  first PREPARE no longer consumes the server-owned timing manifest; the same
  video/hash-bound manifest remains reusable only within its existing bounded
  TTL, and every PREPARE still creates a fresh review session.
- Added backend and widget regressions for the complete prepare, candidate,
  edit, reconfirm and prepare-again path. Guided backend tests passed `13/13`,
  timing-integrity tests passed `7/7`, and guided widget tests passed `15/15`.
- Repaired three mojibake assertions in the Persian guided-review widget test
  using the exact canonical `app_fa.arb` title, description and single-attempt
  confirmation text.
- Added a localized Edit attempt boundaries action to the prepared candidate
  stage. It keeps the timing manifest, source timing and exact frame selections
  while requiring boundary preview, boundary confirmation, single-attempt
  confirmation and PREPARE again.
- Conservatively invalidated prepared session, candidate/Tori and limb/camera
  review, uncertainty, result and Grounded Sensei state whenever their attempt
  context changes. Returning to an earlier frame does not restore confirmation.
- Centralized Run eligibility and disabled context-changing review controls
  during an active request so incomplete or stale human review remains
  fail-closed.
- Added widget regressions for edit return, confirmation invalidation, frame
  round-trip invalidation, candidate/context cleanup and result/Sensei cleanup.
  Persian validation passed `1/1`, the complete guided file passed `15/15`, and
  targeted Flutter analysis passed with no issues.
- Real-device validation passed the VFR timing manifest, exact preview,
  boundary and single-attempt confirmations, Edit boundaries, invalidation,
  N -> N+1 -> N non-restoration, corrected Edit -> reconfirm -> Re-PREPARE and
  the uncertainty gate. D1 is PASS/CLOSED.
- No automatic attempt segmentation, Tori/Uke identity, tracking, phase claim,
  metric/formula change, 3D or kinetics capability was introduced. The existing
  candidate/Tori mismatch moved to the separately active D2 scope.

---

## 2026-09-07 — Frame-Accurate Attempt Boundary D1

- Added an expiring server-owned timing manifest with decoded frame count,
  canonical per-frame timestamps, timing mode/provenance and video SHA binding.
- Replaced final millisecond-only Guided boundaries with exact frame selection,
  one-frame controls, visual review prompts and required human confirmation.
- Added explicit real-time/known-scale/unknown source timing contracts.
  Unknown or average-FPS-only timing now withholds physical `UM-TIM-001` while
  preserving its selected-window audit reference.
- Persisted only minimal frame/timing provenance and kept video, thumbnails,
  pose arrays and opaque tokens out of ordinary History.
- Preserved MediaPipe Heavy, angle formulas, V2A version, BLUE, identity/phase
  locks and all D2-D8 non-goals.
- Added the P0 single-attempt integrity gate: exact boundaries now require an
  additional versioned human confirmation that the interval contains one
  continuous attempt. The backend rejects absent/malformed provenance and
  History retains only the minimal assertion fields.

---

## 2026-09-07 — Guided Selected-Frame Tori Confirmation V1

- Replaced the primary engineering-field V2A review entry with a visual
  start/end/review-moment flow; frame, timestamp, detection and schema IDs are
  no longer typed by the normal user.
- Added bounded FastAPI prepare/confirm orchestration with opaque session-bound
  candidate tokens, ten-minute in-process expiry, exact stored-pose reuse and
  cleanup after success, expiry or explicit uncertainty.
- Added visual frame-local candidate previews and an explicit human Tori
  confirmation. Candidate order/token is not athlete identity and no automatic
  Tori/Uke, tracking or phase claim is introduced.
- Preserved V2A 2.0.0, its four metrics, BLUE geometry, scientific provenance,
  limitations, History and downstream deterministic Grounded Sensei behavior.
- Added English/Persian guided-review presentation and focused Python/Flutter
  tests for canonicalization, abstention, token/session safety, expiry,
  no-reinference, explicit confirmation, uncertainty and downstream result
  compatibility.
- This is a Maker implementation awaiting Founder-side Checker/Challenger
  review; it is not scientific validation or production approval.

---

## 2026-08-20 — Club Administration Core Local Foundation

- Added a complete local single-device workflow for one club, current local
  Athlete Profile membership, training groups, scheduled sessions and typed
  attendance recovery.
- Added exact-schema domain validation, a repository abstraction,
  SharedPreferences storage and an app-scoped provider with fail-closed corrupt
  storage handling.
- Added a localized English/Persian Club workspace with RTL, honest empty and
  invalid states, record-derived dashboard counts and explicit local-only and
  single-athlete limitations.
- Activated Club Administration as a Platform Overview-only
  `foundationOnly` destination. The registry remains exactly 18 modules and
  Athlete Home gains no Club action.
- Added targeted serialization, repository, provider, UI, localization,
  navigation and V2A-preservation tests. The bounded validation passes; no
  Android build, inference or Git-history operation was run.

---

# Version 0.12

Status:
Stable Development


## Added

- Flutter project foundation created.
- Git version control enabled.
- Project migrated to D drive for better storage management.
- Multi-language structure started.
- Technique model architecture created.


## Techniques Module

Implemented:

- Technique list screen.
- Technique detail screen.
- Technique card component.
- Search system.
- Category filters.
- Difficulty filters.
- Filter bottom sheet.


## Sample Techniques

Implemented:

- Uchi Mata
- Seoi Nage
- Additional technique samples


---

# Version 0.13

Status:

Architecture Preparation Phase


## Added

### Documentation Foundation

Created:

- AI_DEVELOPMENT_RULES.md
- ARCHITECTURE.md
- CHANGELOG.md
- DECISION_LOG.md
- PROJECT_STATUS.md
- PRODUCT_REQUIREMENTS.md


### Development Foundation

Completed:

- Git workflow preparation
- Documentation workflow
- Initial modular architecture preparation
- Repository pattern preparation
- Local data source preparation
- Technique Bundle model architecture


## Techniques Module

Implemented:

- Technique data model expansion
- Technique repository structure
- Technique local data architecture
- Sample technique database preparation


## Technical Decisions

Approved:

- Feature-based architecture direction
- Provider state management
- Future Riverpod migration readiness
- Documentation synchronization rule


---

# Version 0.14

Status:

In Development


## Title:

Architecture Stabilization + Technique Intelligence Phase


## Added


### Technique UI 2.0

Implemented:

- Technique Dashboard Item
- Technique Dashboard Grid
- Technique Bottom Sheet architecture


### User Experience Improvements

Approved:

- Dashboard-based navigation
- Reduced long scrolling pages
- Section-based technique access


Technique sections:

- Overview
- Technical Analysis
- Biomechanics
- Training
- Shadow Training
- Conditioning
- Competition Analysis
- Combinations
- Counters
- Quiz
- Sources
- Progress
- AI Recommendations


---

## Technique Intelligence System

Architecture added:


### Technical Layer

- Kuzushi
- Tsukuri
- Kake
- Execution Steps
- Common Mistakes


### Biomechanics Layer

- Movement Analysis
- Force Direction
- Center of Gravity
- Muscle Activation


### Training Layer

- Shadow Training
- Uchikomi
- Nagekomi
- Conditioning
- Mobility


### Competition Layer

- Tactical Application
- Combination
- Counter
- Match Analysis


### AI Layer

- Progress Analysis
- Recommendations
- Personalized Training


---

## Internationalization

Approved:

- Localization First Strategy
- ARB localization architecture
- RTL/LTR preparation


Supported languages:

- English
- Persian
- French
- German
- Spanish
- Japanese
- Russian
- Arabic


---

## Product Architecture

Approved:

Judo Mind official 17 module structure.


Module 17:

Administration & System Settings


---

## CMS Architecture

Approved:


Future Administration Panel will manage:

- Techniques
- Images
- Videos
- News
- Courses
- Champions
- Quiz
- Advertisements
- Home Dashboard
- Translations
- Media Library

## Version 0.14.1

Status:
In Development


### Technique Module 2.0 Integration


Added:

- Technique Dashboard Grid enhancement
- Added Biomechanics section
- Added Shadow Training section
- Added Conditioning section
- Added Progress section
- Expanded Technique Dashboard architecture


Improved:

- Reduced long scrolling dependency
- Prepared section-based navigation
- Improved scalability of Technique Detail module


Architecture:

Updated:

- Technique Dashboard navigation
- Section component strategy
- Bottom Sheet integration preparation


Testing:

- flutter analyze passed successfully

## Version 0.14.2

Status:
In Development

### Technique Detail Integration - Phase 1

Added

- Technique Dashboard imports
- Technique Bottom Sheet imports

Verified

- flutter analyze passed

Architecture

- Preparing Dashboard Integration

## Version 0.14.3

Status:
In Development


### Technique Dashboard Connection

Completed:

- Connected Technique Detail Screen with Dashboard Grid.
- Connected Technique Bottom Sheet architecture.
- Fixed Quiz data binding with TechniqueModel.


Validation:

- flutter analyze passed successfully.

## Version 0.14.4

Status:
In Development


### Overview Section Implementation


Added:

- First Technique Dashboard content section.
- Overview Section widget.
- Technique data binding with Overview.


Architecture:

- Section-based content rendering validated.
- Dashboard to Bottom Sheet flow confirmed.


Validation:

- flutter analyze passed successfully.

## Version 0.14.5

Status:
In Development

### Technique Detail Refactor â€” Hero Section

Completed:

- Created reusable HeroSection widget.
- Moved technique title and favorite control into an independent component.
- Connected HeroSection to TechniqueDetailScreen.
- Connected real Overview and Technical Analysis sections to Bottom Sheets.

Validation:

- flutter analyze passed without errors.

## Version 0.14.6

Status:
In Development

### Technique Detail Refactor â€” Media Section

Completed:

- Created reusable MediaSection widget.
- Moved technique image and video presentation out of TechniqueDetailScreen.
- Replaced raw video URLs with professional video cards.
- Added media loading and invalid-link feedback.
- Preserved training and competition video actions.
- Reduced TechniqueDetailScreen responsibilities.

Validation:

- flutter analyze passed without errors.

## Version 0.14.7

Status:
In Development

### Technique Detail Refactor â€” IJF Profile

Completed:

- Created reusable IjfProfileSection.
- Moved IJF classification data out of TechniqueDetailScreen.
- Added a professional official-content badge.
- Improved IJF information hierarchy and visual density.
- Preserved localized labels.

Validation:

- flutter analyze passed without errors.

## Version 0.14.8

Status:
In Development

### Technique Detail Refactor â€” Description Section

Completed:

- Created reusable DescriptionSection.
- Moved technique description out of TechniqueDetailScreen.
- Preserved localized technique descriptions.
- Added empty-content fallback.
- Improved text readability and visual hierarchy.

Validation:

- flutter analyze passed without errors.
---

# Version 0.15

Status:

Planned


## Backend Preparation

Planned:

- CMS Architecture
- REST API Architecture
- Authentication
- Database Architecture
- Media Storage
- Cloud Infrastructure


## Design System

Planned:

- Color System
- Typography
- Icons
- Buttons
- Cards
- Dialogs
- Bottom Sheets
- Theme Management


## Administration Foundation

Planned:

- Admin Panel architecture
- Role management
- Permission system
- Content management foundation

## Version 0.15.0

Status:
Design System Development

### Approved

- Judo Mind Design System 1.0
- Centralized visual language for all 17 modules
- Global card, button, typography, spacing and radius standards
- RTL and LTR compatibility requirement
- Dark-theme-first architecture
- Reusable component strategy
---
## Version 0.16.0

Status:
Reference Technique Completion Phase

### Approved

- Uchi Mata selected as the official Reference Technique.
- Five-layer learning flow approved:
  Watch, Understand, Practice, Analyze and Master.
- Universal video-upload access approved.
- AI credit-based usage model approved.
- Sensi Bot AI Fight Intelligence 360 approved.
- Opponent guard, position and balance analysis approved.
- Push and pull reaction analysis approved.
- Technique Dashboard established as the primary navigation system.

### In Progress

- Removal of duplicated Technique Detail content.
- Connection of all Dashboard sections.
- Compact Dashboard polish.
- Uchi Mata visual-learning architecture.
- AI Analysis entry-point design.

# Version 0.16

Status:

Planned


## Athlete Ecosystem Expansion

Planned:

- Athlete Profile
- Monitoring System
- Progress Tracking
- Training History
- Performance Analytics


---

# Version 0.17

Status:

Planned


## AI Development

Planned:

- Sensi Bot Foundation
- AI Knowledge Layer
- Recommendation Engine
- Personalized Training Support


---

# Version 1.0

Status:

Target Release


## Version 0.17.0 â€” JMDS Dashboard Icon Foundation

Date: 2026-08-02
Status: Completed

### Added

- Added the centralized `JudoIcons` registry.
- Added the standard `JudoIcon` Design System widget.
- Migrated Technique Dashboard icons to the Judo Mind icon registry.
- Rebuilt `TechniqueDashboardItem` using JMDS components.
- Added standardized icon highlighting and semantic labels.
- Added compact AI and quiz badges.
- Added consistent disabled and locked states.

### Changed

- Reduced Technique Dashboard icon size to 19 px.
- Removed unnecessary decorative circles from dashboard cards.
- Reduced visual density and unused card space.
- Standardized card border, radius, spacing and typography.
- Prepared dashboard icons for future SVG and illustration replacement.

### Validation

- Dart formatting completed.
- Flutter Analyze passed without errors.
- Existing Dashboard navigation and Router behavior preserved.

## Professional Judo Mind MVP


Includes:

- 17 Modules
- Complete Technique Platform
- Sensi Bot Foundation
- Training Center
- Monitoring
- Athlete Profile
- Coach Panel
- Club Panel
- Competition Module
- News Center
- Online Courses
- Subscription System
- CMS
- Administration Panel
- Multi-language System
- Design System
- Backend Ready Architecture

### Design System 1.0 â€” Typography

Added:

- Centralized JudoTypography system
- Display, heading, title, body and label hierarchy
- Brand-specific technique title styles
- Responsive technique-title helper
- Preparation for language-specific font management

## Version - JM-DS-005

### Added
- Added JudoCard core UI component
- Added JudoSection reusable layout component
- Integrated Design System components
- Prepared shared UI architecture for all modules

### Impact
- Technique Detail module can migrate to reusable components
- Future modules will use centralized UI components

### JM-UX-012 â€” Media Architecture

- Replaced duplicated MediaSection on Technique Detail with TechniqueMediaPreview.
- Full media library is now accessible through the Videos dashboard section.
- Added branded official-media preview.
- Added support for asset and network preview images.
- Added media-count calculation.
- Prepared the reference technique for professional media metadata.

### JM-MEDIA-002 â€” Professional Technique Media Model

Added:

- TechniqueMediaItem model
- Professional media titles and descriptions
- Media type classification
- Verified-source classification
- Duration and thumbnail metadata
- Competition and athlete metadata
- Grip and attack-direction metadata
- Top-execution ordering
- AI-compatible media tags

The previous raw URL media structure will be migrated gradually without breaking the current application.

### JMDS-006 â€” Custom Illustration Renderer

- Added reusable JudoIllustration component.
- Added CustomPainter-based illustrations.
- Added initial support for Sensi Bot, Quiz, Training, Competition and Mastery.
- Added technical, tactical, grip, balance, champion and safety visual variants.
- Added semantic accessibility labels.
- Added dark-theme-compatible vector rendering.
- No external illustration dependency was introduced.

### JMDS-006 â€” Custom Illustration Renderer

- Added reusable `JudoIllustration` component.
- Added CustomPainter-based vector illustrations.
- Added initial support for Sensi Bot, Quiz, Training, Competition and Mastery.
- Added technical, tactical, grip, balance, champion, combination and safety variants.
- Added semantic accessibility labels.
- Added dark-theme-compatible vector rendering.
- Introduced no external illustration dependency.
- Flutter Analyze completed without errors.

### JMDS-007 â€” Selective Dashboard Illustration Integration

Date: 2026-08-02
Status: Completed

- Added optional illustration support to `TechniqueDashboardItem`.
- Connected custom JMDS illustrations to Training, Competition, Mastery, Sensi Bot and Quiz.
- Kept standard dashboard sections icon-based to control visual density.
- Preserved all Dashboard navigation and Router behavior.
- Added semantic labels for custom visuals.
- Updated card proportions for illustration-based content.
- Dart formatting completed.
- Flutter Analyze passed without errors.

### JM-MEDIA-005 â€” Professional Media Library

Date: 2026-08-02
Status: Completed

- Rebuilt MediaSection using TechniqueMediaResolver.
- Removed raw URL display from media cards.
- Added professional media titles and source labels.
- Added Featured Media presentation.
- Added categorized media collections.
- Added verified, premium and media-type indicators.
- Added direct-media URL validation.
- Blocked YouTube search-result URLs.
- Added image preview dialog.
- Added support for official, training, competition, Top Execution and analysis media.

---

# Version 0.14.2

Status:

In Development

## Title

Three-Layer Visual Learning Architecture

## Added

### Visual Learning Foundation

- Three-layer visual learning model
- Technique visual learning plan
- Reusable visual learning sequence architecture
- Layer visibility controls
- Animation playback controls
- Playback speed controls

### Visual Layer System

Implemented:

- Blue movement layer
- Gold control layer
- Green biomechanics layer
- Individual layer activation
- Synchronized layer playback

### Uchi Mata Reference Technique

Implemented:

- Uchi Mata visual learning data
- Uchi Mata biomechanics sequence
- Uchi Mata shadow-training sequence
- Uchi Mata conditioning sequence
- Tori and Uke visual separation
- Kuzushi phase indicator
- Tsukuri phase indicator
- Kake phase indicator
- Animated footwork path
- Animated grip-control visualization
- Center-of-gravity visualization
- Force-direction visualization

### Dashboard Integration

Added:

- Biomechanics Dashboard section
- Shadow Training Dashboard section
- Strength & Conditioning Dashboard section

### Design System

Updated:

- Judo Mind icon registry expanded
- Visual-learning icons centralized
- Three-layer colors connected to Design Tokens

## Validation

Completed:

- Flutter compilation validation
- Physical-device visual validation
- Three-layer animation playback validation
- Layer toggle validation
- Playback-speed validation

## Current Limitation

The current Tori and Uke figures are functional vector prototypes.

Future refinement will replace them with professional Judo Mind illustrations or advanced animation assets while preserving the approved three-layer architecture.

# Version 0.14.3

Status:

In Development

## AI Fight Intelligence 360 â€” Video Input Foundation

Implemented:

- Technique video selection from device gallery
- Direct video recording entry
- Local video preview
- Video playback
- Video file metadata
- Camera-angle selection
- Scientific analysis disclaimer
- Analysis consent workflow
- Prepare AI Analysis action
- Uchi Mata AI Analysis routing

## Biomechanical Analysis Architecture

Added structured support for:

- Tori pose tracking
- Uke pose tracking
- Joint-angle measurements
- Kuzushi detection
- Tsukuri detection
- Kake detection
- Center-of-mass tracking
- Biomechanical findings
- Confidence scoring
- Camera calibration metadata
- Video overlay output
- Analysis limitations

## Validation

Physical Android device validation completed successfully.

Video selection, preview, camera-angle selection and analysis preparation workflow verified.

---

# Version 0.15

Status:

In Development

## Title

AI Fight Intelligence 360 + Scientific Biomechanics Foundation

Date:

2026-08-05

---

## Uchi Mata Visual Learning

Added:

- Three-Layer Visual Learning architecture
- Movement Layer
- Control Layer
- Biomechanics Layer
- Layer visibility controls
- Animation playback controls
- Playback speed controls
- Uchi Mata technical-execution visual sequence
- Uchi Mata biomechanics visual sequence
- Shadow Training visual sequence
- Strength & Conditioning visual sequence

Approved visual language:

- Blue = Movement / Footwork
- Gold = Grip / Pull / Upper-Body Control
- Green = Force / Balance / Center of Gravity

Current CustomPainter implementation is classified as an instructional prototype rather than final biomechanical visualization.

---

## AI Fight Intelligence 360 â€” Flutter Foundation

Added:

- Analyze My Uchi Mata entry
- AI Analysis Dashboard routing
- Video selection from device
- Video recording entry
- Selected-video preview
- Video metadata display
- Camera-angle selection
- Scientific analysis disclaimer
- AI analysis preparation flow

Architecture:

Flutter is responsible for:

- Capture
- Upload
- Configuration
- User interaction
- Analysis result visualization

Heavy AI processing is delegated to the AI backend.

---

## Professional AI Analysis Models

Added:

- Expanded MediaAnalysisMetadata
- Structured biomechanical findings
- Confidence metadata
- Analysis status
- Technique phase metadata
- Joint-angle measurement architecture
- Center-of-mass data preparation
- Analysis limitations
- Overlay and report references
- VideoAnalysisRequest architecture
- BiomechanicsAnalysisService contract

---

## Python AI Engine

Created:

`ai_engine/`

Added:

- Python 3.12 AI environment
- FastAPI backend
- Uvicorn service
- Health endpoint
- Video upload endpoint foundation
- OpenCV processing
- MediaPipe integration
- MediaPipe Pose Landmarker Heavy
- RTMLib integration
- ONNX Runtime
- RTMPose integration
- PoseTracker evaluation
- RTMO evaluation

---

## Real Judo Video Benchmark

A single real Judo competition video was used as the common benchmark.

Video:

- Duration: 53.89 seconds
- Resolution: 1306 Ã— 720
- Source FPS: approximately 30
- Analyzed frames: 540
- Target analysis rate: approximately 10 FPS

Results:

| Engine | At Least One Athlete | Two Athletes |
|---|---:|---:|
| MediaPipe Heavy | 99.63% | 31.48% |
| RTMPose-M | 97.04% | 48.33% |
| RTMPose-M + PoseTracker | 96.85% | 46.85% |
| RTMO-M | 40.56% | 8.15% |

Decision:

RTMPose-M is the current baseline pose-estimation engine.

RTMPose-M is not considered sufficient by itself for production-grade Judo biomechanics.

---

## Scientific Biomechanics Architecture

Approved:

JM-DEC-017 â€” Scientific Biomechanics & Multi-View Motion Analysis Architecture

Major architectural decision:

Pose estimation is no longer considered the complete biomechanics system.

Approved pipeline:

Video Capture

â†“

Camera Calibration and Synchronization

â†“

Multi-Person Pose Estimation

â†“

Tori / Uke Identity

â†“

Occlusion Intelligence

â†“

Multi-View 3D Reconstruction

â†“

OpenSim Musculoskeletal Modeling

â†“

Judo-Specific Biomechanics

â†“

AI Fight Intelligence

â†“

Scientific Quality Validation

---

## OpenSim Integration Foundation

Added:

Dedicated scientific biomechanics environment:

`ai_engine/.biomech_venv`

Installed:

- Python 3.12
- OpenSim 4.6
- NumPy 2.5.1

Validation:

OpenSim successfully initialized.

Verified:

`Judo Mind OpenSim Engine: READY`

OpenSim is approved as the primary musculoskeletal modeling and biomechanical computation engine.

---

## Scientific Analysis Levels

Added:

### Standard Analysis

Single-video analysis with estimated technical, tactical and biomechanical indicators.

### Advanced Biomechanics

Two or more synchronized and calibrated cameras for multi-view 3D reconstruction and model-based biomechanics.

### Research / Validation

Support direction for:

- Marker-based Motion Capture
- Force Plates
- EMG
- IMU
- Laboratory reference systems

---

## Scientific Integrity Rule

Added:

Judo Mind must explicitly distinguish:

- Measured data
- Reconstructed data
- Model-estimated data
- AI-inferred data

Estimated physical quantities must never be presented as directly measured quantities.

Every professional biomechanical result must eventually include:

- Confidence
- Data source
- Analysis method
- Quality classification
- Relevant limitations

---

## Infrastructure Architecture

Current local processing:

CPU-based development and benchmarking.

Production direction:

GPU-backed AI processing.

Computer Vision environment:

`ai_engine/.venv`

Scientific Biomechanics environment:

`ai_engine/.biomech_venv`

The two environments remain isolated to prevent dependency conflicts.

---

## Current Development Direction

Reference Technique:

Uchi Mata

Next scientific implementation target:

Multi-View 3D Motion Reconstruction

Required foundation:

- Camera calibration
- Camera synchronization
- Tori / Uke identity
- Multi-camera landmark matching
- 3D triangulation
- OpenSim-compatible motion data

---

## Repository Development Governance

Date:

2026-08-06

Status:

Completed

### Added

- Added the root `AGENTS.md` repository instruction file.
- Required the five approved project reference documents to be read before future project work.
- Consolidated preservation of existing user work and existing functionality.
- Consolidated mandatory documentation synchronization for feature, architecture, product, and development-process changes.
- Consolidated the scientific distinction between measured, reconstructed, estimated or model-estimated, and AI-inferred data.
- Required explicit user approval before destructive Git operations or Git push.
- Recorded the current Uchi Mata reference stage and Flutter plus Python AI Engine responsibility boundary.
- Preserved the official 17-module product structure.

### Documentation

- Updated `AI_DEVELOPMENT_RULES.md` for the repository-level agent instruction entry point.
- Updated `PROJECT_STATUS.md` to record the completed governance file.
- No new product or architecture decision was introduced.

---

## Stereo Calibration Cycle Closure and Scientific Pipeline Guard

Date:

2026-08-07

Status:

Completed

### Calibration conclusion

- Closed the current approximately 48-hour two-phone stereo test cycle; no further tests are authorized on the two source videos.
- Recorded that the +0.55 s geometric correction did not solve the geometry and worsened stereo RMS from the previously recorded 39.26 px to 48.2750333 px.
- Recorded median epipolar error of 55.4328918 px and final quality `review_required`.
- Preserved the valid intrinsic findings for cameras 101 and 102 and the confirmed camera orientations.
- Scientifically rejected the current stereo extrinsic for 3D reconstruction, biomechanics and OpenSim.
- Recorded stabilization/EIS/OIS virtual-camera change only as an unconfirmed hypothesis.

### Architecture

- Approved JM-DEC-018, separating Single-Camera AI Analysis from Multi-Camera 3D Scientific Analysis.
- Required confidence, limitations and explicit provenance for all analysis outputs.
- Prohibited single-camera or uncertain outputs from being described as measured or reconstructed 3D.
- Defined calibration, synchronization, cross-camera identity, geometry and reconstruction-quality gates before advanced scientific use.

### Safeguard

- Added a centralized fail-closed stereo calibration quality gate.
- Required a sealed validated-calibration context before `MultiViewReconstructor` can run.
- Limited `usable_for_3d_validation` calibration to offline validation.
- Required `good` or `excellent` calibration plus the existing numeric acceptance thresholds for user-facing scientific 3D.
- Kept OpenSim behind additional identity, motion, reconstruction and anatomical-quality gates.
- Added synthetic, video-free regression tests for invalid, missing, validation-only and scientific calibration cases.

### Validation

- Six calibration-gate and reconstruction-guard unit tests passed without processing calibration videos.
- No Flutter source was changed; `flutter analyze` was therefore not required for this change.

---

## Single-Camera Uchi Mata AI Analysis v1 â€” Vertical Slice 1

Date:

2026-08-07

Status:

Implemented, automated-test validated and physical-device end-to-end validated

### Added

- Added the versioned `POST /v1/analysis/single-camera/pose-summary` Python endpoint.
- Added a bounded API response for measured video metadata and model-estimated pose coverage.
- Added explicit capability flags and scientific limitations for unavailable identity, phases, 3D reconstruction, force and torque.
- Added Flutter API configuration through `JUDO_MIND_AI_BASE_URL` and an HTTP multipart implementation.
- Connected the existing Analyze video selection flow to the Python AI Engine.
- Added loading, failure and real diagnostic-result states to the Analyze screen.
- Added a localized Single-Camera Pose Summary card with provenance labels and limitations.
- Added debug-only Android cleartext HTTP support for local AI Engine development.
- Replaced the ambiguous `3D` badge on the educational Biomechanics dashboard card with `Learn`.

### Scientific safeguards

- Pose coverage is labeled `model-estimated` and is not presented as biomechanical confidence.
- Video metadata is labeled `measured`; no landmark is presented as measured or reconstructed 3D.
- Flutter fails closed if the single-camera response claims persistent athlete identity, phase detection, 3D reconstruction, force or torque.
- The current MediaPipe Pose Landmarker Heavy engine is identified as an experimental baseline, not a production Judo biomechanics engine.
- No Tori/Uke identity, Kuzushi/Tsukuri/Kake phase, joint-angle, center-of-mass, force, torque, 3D or OpenSim result is produced by this slice.

### Validation

- Added two synthetic, video-free Python tests for the versioned contract, scientific boundary, temporary-upload cleanup and non-video rejection.
- Added three Flutter tests for JSON/provenance parsing, multipart request wiring and scientific result rendering.
- All new Python and Flutter tests pass.
- `flutter analyze` was run; no diagnostic is attributable to the new vertical-slice code, while 20 existing repository warnings/information diagnostics remain outside this change.
- Completed a real physical-Android end-to-end validation with a new 23.72-second, 640x1136, 25 FPS single-camera Uchi Mata competition clip.
- Confirmed the complete Flutter multipart upload -> FastAPI -> MediaPipe Pose Landmarker Heavy -> versioned `1.0.0` JSON -> Flutter parsing -> Result Card path with final HTTP 200.
- Recorded 297 analyzed frames, 97% model-estimated coverage for at least one pose and 7% for two poses; these values remain diagnostic coverage rather than identity or biomechanics confidence.
- Recorded that the then-current integer-stride sampler analyzed approximately 12.5 FPS for this 25 FPS source despite the requested 10 FPS target; this historical result is preserved, and a later uncommitted timestamp-sampler correction still requires real-video validation.
- Confirmed all five scientific limitations were visible and no affirmative Tori/Uke identity, phase, 3D, force or torque claim was rendered.
- Confirmed the backend temporary upload was removed after processing; local CPU processing took approximately 4 minutes 40 seconds and remains unsuitable for production latency.
- No test was run on the closed Stereo video pair and no calibration or multiview file was changed.
- Manual end-to-end validation with a new single-camera Uchi Mata clip passed on 2026-08-07.

---

## Uchi Mata Scientific Metrics v1 and Fight Intelligence 360 Levels

Date:

2026-08-08

Status:

Scientific/product architecture documented; no analysis implementation added

### Added

- Added `docs/UCHI_MATA_SCIENTIFIC_METRICS_V1.md` as the versioned scientific metric contract.
- Formalized three independent Fight Intelligence 360 levels: Single-Camera AI, Multi-Camera 3D and Professional/Federation/Laboratory.
- Defined metric IDs, required inputs, methods, units, level, provenance, confidence evidence, scientific sources and allowed/prohibited interpretations.
- Defined Level 1 projected timing, angle, displacement, velocity, grip, foot-placement, relative-position, 2D COM-proxy and Uke balance-displacement candidates.
- Defined Level 2 reconstructed 3D skeleton, trajectories, joint geometry, relative positioning, velocity, model-estimated COM and reference-comparison candidates.
- Defined Level 3 measured force/sensor inputs and model-estimated momentum, inverse-dynamics, moment, work and power candidates.
- Recorded the five approved Uchi Mata DOI sources and their methodological limits.
- Recorded source-specific phase/event definitions and prohibited silent mapping to canonical Kuzushi/Tsukuri/Kake labels.
- Defined Interactive 3D/360 as virtual-camera viewing of a validated reconstructed scene.
- Defined AI Sensi, annotated-video, voice-coaching and scientific-report coordination and preserved Blue/Gold/Green overlay semantics.

### Scientific safeguards

- Preserved the JM-DEC-018 fail-closed calibration and OpenSim gates.
- Preserved the rejected `review_required` stereo disposition and the ban on retesting its source videos.
- Prohibited invented normative thresholds and promotion of provenance.
- Required Level 1 Green arrows to be AI-inferred conceptual cues rather than measured force vectors.
- Classified champion-specific and small-sample study findings as reference evidence, not universal ideals.

### Validation

- Documentation-only consistency review completed against AGENTS.md and all mandatory reference documents.
- No Flutter or Python source was changed, so no application test or `flutter analyze` run was required.
- No Stereo/Multiview test was run.

---

## Night Shift 01 â€” Pose Reliability Foundation

Date:

2026-08-08

Status:

Implementation and synthetic validation complete; real-video execution blocked

### Added

- Added a shared deterministic nearest-target-timestamp video sampling plan.
- Added unit coverage for 25 FPS to 10 FPS sampling, the prior 593-frame source
  shape, source-rate capping and invalid sampling inputs.
- Added a non-production pose benchmark harness with the same video/timestamps
  for MediaPipe Heavy, RTMPose-M and RTMO-M.
- Added versioned JSON and human-readable benchmark reporting for pose coverage,
  runtime, effective analyzed FPS, confidence availability and failures.
- Added role-neutral tracking contracts for `Track A`, `Track B` and later
  tracks, plus synthetic continuity evaluation for crossing, occlusion and
  reappearance.
- Added `docs/AI_POSE_ENGINE_AUDIT.md` with the actual current engine/model,
  dependency, keypoint, confidence, CPU, tracking and limitation matrix.

### Corrected

- Replaced the integer-stride behavior that converted a requested 10 FPS on a
  25 FPS source into approximately 12.5 analyzed FPS.
- Recorded that `ai_engine/rtmpose_engine.py` actually initializes RTMO-M, while
  the diagnostic default `Body(...)` path initializes YOLOX-M + RTMPose-M.
- Kept historical real-video results intact and classified the new 238-frame
  value as a sampling-plan calculation rather than a new video result.

### Scientific safeguards

- Pose detections remain `model-estimated`; neutral track association remains
  `AI-inferred`.
- The tracking contract rejects Tori/Uke role labels and makes no real-video
  continuity claim.
- The benchmark produces no phase, measured/reconstructed 3D, force, torque,
  OpenSim or coaching result.
- No old Stereo/Calibration video was processed or modified.

### Validation

- 20 focused Python unit tests pass.
- Added a backend regression test proving temporary upload cleanup when pose
  inference fails with a bounded HTTP 500 response.
- Python syntax compilation and `git diff --check` pass.
- `BLOCKED â€” TEST VIDEO REQUIRED`: no explicit single-camera Uchi Mata video is
  currently available; only excluded closed Stereo/Calibration videos exist.
- No Flutter source changed, so `flutter analyze` was not required.

### Safe fallback audits

- Added `docs/NIGHT_SHIFT_01_AUDIT.md` covering single-camera test gaps, all 20
  pre-existing Dart diagnostics, the 17 official modules and AI technical debt.
- Classified 4 diagnostics as real unused-code maintenance debt, 10 as
  stylistic/cleanup, 0 as generated and 6 as potentially risky compatibility or
  feature-gating debt; no bulk fix was made.
- Recorded that no official Module 18 exists and that the source dashboard has
  unresolved official-module/non-official-tile mismatches.
- Added an offline cache preflight so the benchmark cannot silently download
  missing RTMLib models.

---

## Autonomous Development Shift 01 â€” Reliability Hardening and Module 18

Date:

2026-08-08

Status:

Implementation and offline validation complete; real-video and Flutter-tool
validation blocked

### Added

- Added deterministic sampler coverage for 24/25/30/50/60 FPS, non-integer
  source rates, short clips, end boundaries and integer-millisecond tie cases.
- Added benchmark coverage for no-, one- and two-pose sequences, missing
  dependencies, isolated runner failure, timing derivation and stable JSON
  serialization.
- Added neutral tracking evaluation for detection-order swaps, one-person
  intervals and explicit track termination/reinitialization.
- Added Flutter contract tests for incompatible schema/status, provenance
  promotion, false confidence availability, missing limitations and stale/wrong
  endpoint diagnostics.
- Formalized `AI Training Plan Intelligence` as approved Module 18 in
  architecture, product requirements, project status and JM-DEC-020.

### Corrected

- Replaced bankers rounding for sampling timestamps with deterministic half-up
  millisecond mapping and a strict no-duplicate timestamp invariant.
- Preserved source-relative result timestamps while keeping MediaPipe VIDEO
  timestamps monotonic when a shared landmarker processes more than one video.
- Made failed benchmark runners return the same metric-key schema as successful
  runners without inventing coverage, confidence or timing values.
- Closed upload-stream cleanup gaps for invalid media and empty technique IDs.
- Strengthened Flutter fail-closed parsing to require the `1.0.0` completed
  single-camera contract, measured video metadata, model-estimated pose
  coverage, unavailable confidence, prohibited capabilities and all required
  interpretation limitations.

### Scientific safeguards

- Pose coverage remains `model-estimated`; it is not a confidence score.
- Neutral track association remains `AI-inferred` and never assigns Tori/Uke.
- Module 18 recommendations are specified as evidence-aware `AI-inferred`
  decision support, not medical diagnosis or a universally correct plan.
- No phase, 3D, force, torque, joint moment/power, COM coaching, OpenSim or
  automatic AI Sensi technique claim was introduced.
- No Stereo/Multiview/Calibration video was processed or changed.

### Validation

- 37 focused Python tests pass.
- Dart formatting validation reports zero remaining format changes for the
  changed Dart files.
- Targeted Flutter test and Dart analyzer commands timed out without output in
  the current environment; no running process or system setting was altered.
- `BLOCKED â€” TEST VIDEO REQUIRED`: no explicitly authorized single-camera Uchi
  Mata video is present, so no real benchmark was run and the historical real
  two-person coverage remains approximately 7%.
- All changes remain unstaged and uncommitted; no push was performed.

---

## Single-Camera Pose Benchmark Performance Controls

Date:

2026-08-08

Status:

Diagnosis and lightweight validation complete; FAST SCREENING not run

### Diagnosed

- Confirmed the authorized 110.72-second, 640 x 360, 25 FPS source has 2,768
  native frames and a deterministic 1,108-sample 10 FPS plan.
- Recovered complete MediaPipe Heavy timing of 1,041.077 seconds for
  1,108/1,108 samples and complete RTMPose-M timing of 8,658.745 seconds for
  1,108/1,108 samples.
- Identified RTMPose-M's synchronous YOLOX-M plus RTMPose-M CPU model call as
  the supported dominant bottleneck; initialization was only 2.727 seconds.
- Confirmed both completed engines inferred only the shared sampled frames,
  although OpenCV sequentially decoded the full source stream.
- Confirmed no retry loop, completed RTMPose did not hang, and no CUDA/GPU was
  used. RTMO was cancelled without a recoverable frame count or final artifact.

### Added

- Added per-engine progress with processed/total samples, elapsed time,
  effective FPS and reliability-gated ETA.
- Added cooperative per-engine timeout and graceful cancellation, partial
  observations for interrupted engines, independent failure continuation and
  atomic checkpoint persistence after every engine.
- Added explicit CPU/device/execution-provider fields and stage timing for new
  runs.
- Added FAST SCREENING with a deterministic content-neutral full-span subset of
  at most 100 timestamps shared exactly by all engines.
- Kept screening outputs limited to pose coverage, available confidence,
  failures and runtime, with manual review required before a longer benchmark.
- Required explicit post-review `--engine` selection for longer CLI benchmarks
  instead of accidentally rerunning every available engine.

### Scientific safeguards

- FAST SCREENING produces no Tori/Uke identity, phase, technique,
  measured/reconstructed 3D, force, torque, COM or biomechanics claim.
- Coverage remains model-estimated and is not confidence.
- The 10 FPS benchmark setting remains an engineering/evaluation choice and is
  not the fixed temporal resolution of future scientific biomechanics.
- No Stereo, Calibration or Multiview data was opened or changed.

### Validation

- 50 focused lightweight Python tests pass; benchmark execution paths use fake
  captures/runners and do not open the authorized real video.
- Python syntax compilation passes for the benchmark controls, engines and
  focused tests.
- The authorized real video was not processed during diagnosis or validation.
- FAST SCREENING remains unexecuted pending Mohammad approval.
- No model/dependency download or install, staging, commit or push was performed.

---

## Real Uchi Mata FAST SCREENING Run 01

Date:

2026-08-08

Status:

Completed with optimized artifact reuse

### Executed

- Built the deterministic, content-neutral 100-timestamp subset by even
  full-span selection from the existing 1,108-sample 10 FPS plan.
- Verified that the complete MediaPipe Heavy and RTMPose-M artifacts retain
  exact frame index, timestamp and pose-count observations for every selected
  sample; neither engine was rerun.
- Ran only RTMO-M on the same 100 timestamps with a 20-minute CPU budget.
- RTMO completed 100/100 samples without failure or timeout in 677.966 seconds
  processing and 681.351 seconds including initialization.
- Created ignored RTMO and combined machine-readable JSON/report artifacts in
  `ai_engine/runtime/benchmark_outputs/`.

### Results

| Engine | Source | >=1 person | >=2 persons | Missing |
|---|---|---:|---:|---:|
| MediaPipe Heavy | Reused artifact | 91% | 25% | 0 |
| RTMPose-M | Reused artifact | 95% | 46% | 0 |
| RTMO-M | New inference | 86% | 42% | 0 |

### Scientific safeguards

- Classified coverage as model-estimated detection coverage, not confidence or
  pose accuracy.
- Did not compare raw confidence magnitudes across model families. Reused
  artifacts do not retain subset-specific confidence aggregates.
- Reported keypoint completeness as unavailable because no common comparable
  per-keypoint artifact contract exists.
- Produced no Tori/Uke identity, phase, technique-quality, COM, biomechanics,
  reconstructed 3D, force, torque, power or OpenSim claim.
- No ground-truth annotation was used, so no pose-accuracy conclusion was made.
- No Stereo, Calibration or Multiview file was opened or modified.

### Validation

- Verified all three engine observation sequences exactly equal the same 100
  frame indices and timestamps.
- Parsed and structurally validated the combined JSON artifact, including
  unique timestamps, result sources, processed/missing counts and limitations.
- No model or dependency was downloaded or installed.
- No Git staging, commit or push was performed.

---

## Fight Intelligence 360 Video Analysis Modes

Date:

2026-08-08

Status:

Architecture and product requirement approved; no feature implementation

### Added

- Added JM-DEC-021, defining three independent analysis scopes: Single Attempt
  Technique Analysis, Drill / Repeated Attempts Analysis and Full Match
  Analysis.
- Defined one primary attempt as the mandatory analysis object for Technique
  Analysis, with useful context before and after and no arbitrary universal
  duration threshold.
- Required reliable segmentation and per-attempt results before repeated drill
  executions may be compared or aggregated.
- Defined Full Match Analysis as an event-detection, attack-segmentation,
  per-attempt and separate match-level tactical pipeline.
- Defined plain-language Analyze UX labels for One Attempt, Multiple Repetitions
  and Full Match.
- Preserved AI Sensi, Annotated Video, Voice Coaching, Scientific Report and
  conditional Interactive 3D/360 as the coordinated result architecture.

### Scientific safeguards

- Kept video-analysis mode independent from Level 1/2/3 scientific capability;
  selecting a mode does not promote provenance or bypass a gate.
- Prohibited blending unsegmented repetitions or match attacks into one
  technique/biomechanics result.
- Prohibited unsupported fatigue inference from repetition change.
- Recorded Pose Engine Benchmark as detection/reliability/performance
  evaluation rather than Technique Analysis.
- Restricted the current timestamp-based 10 FPS setting to benchmark
  infrastructure and required validated metric-specific temporal resolution for
  future scientific extraction.
- Preserved the measured, reconstructed, model-estimated and AI-inferred
  boundary and all identity, phase, 3D, kinetics and OpenSim gates.

### Documentation governance

- Updated `AGENTS.md` and the active AI development rule from the superseded
  current 17-module description to the approved current 18-module architecture.
- Preserved historical 17-module records that were correct before JM-DEC-020.
- Updated architecture, product requirements, project status and development
  rules without changing Flutter or Python implementation code.

### Validation

- Documentation terminology and current/historical module-count consistency
  reviewed.
- No benchmark, video inference, Stereo, Calibration or Multiview processing
  was performed.
- No staging, commit or push was performed.

---

## Single-Attempt Uchi Mata V2A Foundation

Date:

2026-08-08

Status:

Implementation foundation complete; real reviewed attempt pending

### Added

- Added JM-DEC-022 and schema `2.0.0` / `single_attempt_v2a` for the first three
  Level 1 Single-Attempt Uchi Mata metrics.
- Added human-gated contracts for attempt boundaries, Tori selection from a
  neutral track, support leg, angle frame/event and camera suitability.
- Implemented reviewed duration, projected trunk inclination and projected
  support-leg knee-angle math with explicit method versions. Normalized pose
  landmarks are converted to source-image pixel coordinates before angle math
  so non-square frame aspect ratio does not distort the result; overlays remain
  normalized for rendering.
- Added reportable/review-required/withheld states, source frame/timestamp,
  unit, provenance, model landmark visibility semantics, limitations and blue
  overlay primitives.
- Added an internal pure V2A metric evaluator, a public reviewed-video multipart
  endpoint and a frame-local MediaPipe pose adapter that does not infer athlete
  roles. Client-supplied pose landmarks are deliberately absent from OpenAPI.
- Added an exact human-selected source-frame plan, source timestamp validation
  for attempt/angle references and early decode stop after the selected frame;
  the benchmark 10 FPS plan is not used.
- Added versioned human annotation and conditional detection evaluation
  contracts.
- Upgraded ground-truth tooling to schema `1.1.0` with screening-artifact and
  source-video SHA-256 provenance, exact timebase/subset gates, overwrite
  protection and a read-only multi-issue readiness command that never defaults
  human labels.
- Bound every review-image path to its exact sample position, source frame and
  source timestamp, preserved those references through finalization and made
  preparation fail if the screening artifact changes during extraction.
- Added dependency-free CSV export/import for human frame labels, with immutable
  evidence columns, explicit blank-versus-empty semantics, validated new-file
  output and overwrite protection.
- Made frame/timestamp/sample/video-dimension/person-count integer evidence
  strict so boolean and floating-point coercions fail validation.
- Prevented Tori/Uke role-token leakage inside longer role-neutral subject IDs.
- Upgraded path-based readiness to schema `1.1.0`; completion now also requires
  every review JPEG to exist, decode and match source-video dimensions. The
  current ignored set passes at 100/100 readable 640x360 assets.
- Required the conditional artifact evaluator to run the same asset preflight,
  closing the direct in-memory finalization bypass.
- Added self-consistency invariants to serialized readiness reports for label
  counts, status/finalization state and review-asset partitions.
- Centralized create-new output safety for annotation manifests, CSV/merged
  drafts, readiness reports and evaluation JSON so existing work is preserved.
- Upgraded conditional detection evaluation to schema `1.2.0`, verifying the
  artifact/video/subset before reporting overall and broad occlusion/crossing
  slices plus four mutually exclusive occlusion-only/crossing-only/both/neither
  strata whose additive counts must partition the all-frame metrics. Coverage
  remains distinct from confidence, pose accuracy and identity accuracy.
- Extended neutral Track A/B observations with timestamps, uncertainty,
  withheld identity association and crossing/occlusion/reappearance events.
- Hardened neutral Track A/B evaluation with source-timestamp consistency,
  finite geometry/score/confidence checks, controlled event tags and explicit
  same-track/same-detection collision reporting.
- Fixed neutral tracking evaluation provenance: reference labels are
  `human-reviewed` and predicted Track A/B associations are `AI-inferred`.
- Added a typed Flutter reviewed-request/HTTP service, strict V2A parser, result
  card and blue projected-geometry painter with localized English/Persian
  labels.
- Bound every accepted Flutter V2A response back to the initiating reviewed
  request, preventing a valid but stale/crossed video, attempt, track,
  detection, support-leg, frame or camera-review result from being rendered.
- Tightened BLUE geometry in Python and Flutter to normalized in-frame points,
  non-blank labels and the exact approved trunk-line or support-leg-polyline
  plus angle-label structure. Extra, reordered or malformed geometry now fails
  closed.
- Added the first-real-run instructions in
  `SINGLE_ATTEMPT_UCHI_MATA_V2A_RUNBOOK.md`.
- Added exact human labelling definitions, completion gates and artifact
  evaluation commands in `UCHI_MATA_HUMAN_ANNOTATION_GUIDE_V1.md`.

### Review Assets

- Reused the exact deterministic 100-timestamp fast-screening subset and
  extracted 100 review frames plus four contact sheets without pose inference.
- Stored the unfilled annotation template under ignored runtime storage with
  status `awaiting_human_annotation`.
- Confirmed through the new readiness tool that 0/100 frames are complete,
  every required human label remains null, and no label was inferred or
  defaulted.
- Confirmed the authorized source file SHA-256 remained unchanged.

### Scientific Safeguards

- Duration retains the measured video timebase and separately records the
  human boundary source.
- Projected angles remain `model-estimated`; model visibility is not described
  as pose accuracy or biomechanics confidence.
- Withheld spatial metrics expose no value or overlay.
- Automatic Tori/Uke identity, automatic phase labels, normative coaching, 3D,
  force, torque, moment, power, load and injury-risk claims remain unavailable.
- The benchmark 10 FPS target was not adopted as scientific metric resolution.

### Validation

- All 118 Python tests passed, including V2A, annotation/evaluation/tracking
  hardening, benchmark-control and existing V1
  endpoint regression coverage.
- 13 focused Flutter parser/widget/service and V1 regression tests passed.
- Targeted Dart static analysis of the V2A slice reported no issues.
- Full-project `flutter analyze --no-pub` timed out after 244.1 seconds without
  emitting a diagnostic and is not recorded as a pass.
- Synthetic tests are recorded only as software/math validation.
- No heavy/full-video pose inference, Stereo, Calibration, Multiview or OpenSim
  processing was performed.
- Flutter source changed during the final contract-integration audit; the prior
  13 focused Flutter pass applies only to the preceding revision.
- A final repeat of those three focused Flutter files emitted no output and
  timed out after 183.2 seconds; it is not recorded as a pass or source failure
  and does not supersede the earlier 13-test success.
- A later V2A-only two-file test command also produced no output before a
  259.3-second timeout. The timeout is not recorded as a pass or source
  failure; focused Python contract/API tests passed after the hardening.
- No Git staging, commit, push, merge, reset or destructive cleanup occurred.

## Three-Camera ChArUco Calibration Validation - 2026-08-08

### Session

- A new independent three-camera ChArUco calibration session was evaluated using:
  - Camera A: `20260808_202340.mp4`
  - Camera B: `IMG_2076.MOV`
  - Camera C: `IMG_6289.MOV`
- This session is independent from the previously evaluated two-camera calibration recordings.
- All three videos passed ChArUco preflight with high usable-view coverage.

### Intrinsic Calibration

- Camera A intrinsic calibration: `excellent`
  - RMS reprojection error: `0.2046 px`
  - Final valid views: `153`
- Camera B intrinsic calibration: `excellent`
  - RMS reprojection error: `0.2782 px`
  - Final valid views: `143`
- Camera C intrinsic calibration: `excellent`
  - RMS reprojection error: `0.3195 px`
  - Final valid views: `143`
- The three intrinsic calibration results are accepted as high-quality single-camera calibration artifacts for this recording configuration.

### Audio Synchronization

- A-B audio synchronization: `good`
  - Intercept: `+0.052679 s`
  - Drift: `+16.048 ppm`
  - Median correlation: `0.589664`
- A-C audio synchronization: `good`
  - Intercept: `-0.000417 s`
  - Drift approximately `0 ppm`
  - Median correlation: `0.520721`
- Direct B-C synchronization was additionally checked as a transitive consistency diagnostic.
- Stable-hold timeline analysis identified mismatched hold detections and demonstrated that audio synchronization alone must not be treated as sufficient evidence of geometric stereo synchronization.

### Extrinsic Calibration

- Initial A-B stereo extrinsic result:
  - Quality: `review_required`
  - RMS reprojection error: `7.2391 px`
  - Valid stereo views: `159`
  - Baseline: `0.284744 m`
- Initial A-C stereo extrinsic result:
  - Quality: `review_required`
  - RMS reprojection error: `10.0703 px`
  - Valid stereo views: `152`
  - Baseline: `0.406299 m`
- The extrinsic calibrator's internal fine-sync refinement was found capable of moving away from the externally supported audio/hold timing.
- A locked-offset calibration variant was therefore tested to prevent internal synchronization refinement.
- Locked A-B calibration remained `review_required`:
  - Locked offset: `+0.004467 s`
  - RMS reprojection error: `7.3447 px`
  - Valid stereo views: `153`
  - Baseline: `0.283276 m`
- Therefore the high stereo reprojection error cannot be accepted as merely an internal fine-sync-selection artifact.

### Independent Geometry Gate

- An independent ChArUco pose-relative geometry diagnostic was run for A-B using six robust timeline-matched stable holds.
- Result: `intrinsics_review_required`
- Valid paired poses: `6`
- Median Camera A single-view reprojection: `1.5177 px`
- Median Camera B single-view reprojection: `1.7922 px`
- Median relative-translation deviation: `0.033559 m` (`33.56 mm`)
- Median relative-rotation deviation: `5.718 deg`
- Median observed baseline: `0.334305 m`
- Observed baseline range: `0.301358-0.545761 m`
- The relative camera geometry is not sufficiently stable across independent paired board poses for scientific stereo reconstruction.

### Scientific Decision

- The 2026-08-08 three-camera session is **NOT approved for scientific 3D reconstruction**.
- No 3D athlete pose, biomechanical 3D metric, force, torque, moment, power or other spatial scientific claim may be derived from these extrinsic results.
- Excellent intrinsic calibration quality does not imply valid stereo extrinsic geometry.
- Good audio synchronization does not imply valid stereo geometry.
- High stereo pair count does not override failed independent geometry consistency.
- The generated `review_required` extrinsic artifacts must not be promoted to production/scientific calibration artifacts.
- The failure is retained as validation evidence rather than hidden or overwritten.
- No previously accepted single-camera analysis capability is downgraded by this three-camera stereo validation failure.

### Validation Status

- Three-camera intrinsic gate: `PASS`
- Audio synchronization gate: `PASS`
- Stereo extrinsic quality gate: `FAIL`
- Independent A-B geometry-consistency gate: `FAIL`
- Scientific 3D readiness: `BLOCKED`
- Single-camera scientific pipeline: unaffected




## JM-DEC-023 ? Attempt-Stable Identity / Event-Scoped Roles

### Architecture

- Separated persistent neutral subject identity from technique-event roles.
- Defined technique actor and target as event-scoped relationships.
- Added architectural support for initial attacks, follow-up attacks,
  combinations and counter-attacks within one attempt.
- Prevented permanent Tori/Uke assignment across a multi-event attempt.
- Prohibited belt/judogi color, image side and detection order as standalone
  identity or role rules.

### Human Ground Truth

- Recorded the human-selected Uchi Mata attempt boundary at `70.000-75.000 s`
  (`frame 1750` to `frame 1875`).
- Recorded human confirmation of the selected event performer.
- Recorded the human-confirmed right support leg.
- Exported the 100-frame annotation CSV for continued human review.
- No missing frame labels were inferred or defaulted.

### Scientific Safeguard

- Automatic attack/counter-attack classification remains unavailable pending
  independent validation.



### Human Annotation Progress ? Samples 000-024

- Completed human review of samples `#000-#024`.
- Ground-truth completion reached `25/100` review frames.
- Recorded visible-person counts, neutral subject references, occlusion and
  crossing labels for the reviewed samples.
- Preserved human-confirmed event performer and right support-leg evidence.
- Preserved role-neutral subject identity under `JM-DEC-023`.
- No unreviewed null value was converted to zero, false or another default.
- Source annotation drafts were preserved; a new create-only annotation
  artifact was written.



### Human Annotation Progress ? Samples 000-049

- Completed human review of samples `#025-#049`.
- Ground-truth completion reached `50/100` review frames.
- Recorded visible-person counts, neutral subject references, occlusion and
  crossing labels for the newly reviewed samples.
- Preserved human-confirmed event performer and right support-leg evidence.
- Preserved role-neutral subject identity under `JM-DEC-023`.
- No unreviewed null value was converted to zero, false or another default.
- Source annotation drafts were preserved; a new create-only annotation
  artifact was written.



### Human Annotation Progress ? Samples 000-074

- Completed human review of samples `#050-#074`.
- Ground-truth completion reached `75/100` review frames.
- Recorded visible-person counts, neutral subject references, occlusion and
  crossing labels for the newly reviewed samples.
- Preserved human-confirmed event performer and right support-leg evidence.
- Preserved role-neutral subject identity under `JM-DEC-023`.
- No unreviewed null value was converted to zero, false or another default.
- Source annotation drafts were preserved; a new create-only annotation
  artifact was written.



### Human Annotation Progress ? Samples 000-099

- Completed human review of samples `#075-#099`.
- Human frame review reached `100/100`.
- All 100 review samples now contain human-confirmed visible-person,
  neutral-subject, occlusion and crossing labels.
- Preserved the human-selected `70.000-75.000 s` reviewed attempt.
- Preserved the human-confirmed event performer and right support leg.
- Preserved the event-scoped role architecture defined by `JM-DEC-023`.
- No missing frame labels were inferred or defaulted.
- Source drafts were preserved through create-new annotation artifacts.
- Formal ground-truth finalization remains pending the readiness/finalizer gate.



### Uchi Mata Ground Truth Run 01 ? Complete

- Completed the first finalized 100-frame human-reviewed Uchi Mata ground-truth set.
- Passed the formal annotation readiness gate with:
  - `100/100` complete frames
  - `100/100` readable review assets
  - no missing human-review fields
  - no final validation errors
  - `labels_inferred_or_defaulted = false`
- Finalized the reviewed attempt `70.000-75.000 s`
  (`frame 1750` to `frame 1875`).
- Preserved the human-confirmed event performer and right support leg.
- Final artifact:
  `ai_engine/runtime/annotation_review/run01/uchi_mata_ground_truth_run01.json`
- Source drafts were preserved.
- `JM-DEC-023` remains the governing identity/event-role architecture.



### RTMPose-M Human Ground-Truth Detection Evaluation ? Run 01

- Evaluated the existing 100-frame RTMPose-M fast-screening observations
  against the finalized human-reviewed Uchi Mata Ground Truth Run 01.
- Reused existing inference; no new RTMPose-M inference was executed.
- Verified exact 100/100 frame/timestamp artifact alignment.
- Measured conditional >=1-person detection coverage of `98.96%`.
- Measured conditional two-person detection coverage of `47.92%`.
- Clear-frame two-person coverage reached `85.71%`.
- Two-person coverage decreased to `37.33%` with occlusion and `29.17%`
  with combined occlusion/crossing.
- Identified multi-person separation during close-contact judo interaction as
  the principal current detection bottleneck.
- Recorded results strictly as detection coverage; pose accuracy, identity
  accuracy and biomechanics accuracy remain unevaluated.



### Three-Engine Human Ground-Truth Detection Comparison ? Run 01

- Compared RTMPose-M, RTMO-M and MediaPipe-Heavy against the same finalized
  100-frame human-reviewed Uchi Mata Ground Truth Run 01.
- Reused existing inference artifacts; no new model inference was performed.
- RTMPose-M produced the highest overall two-person detection coverage
  (`47.92%`).
- RTMPose-M also produced the highest clear-frame two-person coverage
  (`85.71%`).
- During combined occlusion/crossing, RTMPose-M reached `29.17%`, versus
  `8.33%` for RTMO-M and `12.50%` for MediaPipe-Heavy.
- RTMPose-M is retained as the current detection baseline for further
  single-camera development.
- Its six detection-surplus frames remain a known issue requiring later
  false-positive review.
- Detection performance remains separate from pose, identity and biomechanics
  accuracy.



### RTMPose-M Failure-Frame Audit ? Run 01

- Audited all `50` detection-deficit and `6` detection-surplus frames against
  finalized human Ground Truth Run 01.
- Found that `49/50` deficit frames retained one detection while two judoka
  were human-visible.
- Only one deficit frame contained complete detection dropout.
- `47/50` deficits occurred with human-labelled occlusion.
- Identified second-person preservation/separation during close-contact judo
  as the primary current detection investigation target.
- Retained the six detection-surplus frames for explicit false-positive review.
- No new inference was executed.



### JM-DEC-024 ? RTMPose-M Failure Localization Complete

- Rebuilt the close-contact diagnostic against the original benchmark video.
- Reproduced all 12 representative historical RTMPose-M counts exactly.
- Confirmed that most selected two-person deficits already originate with only
  one detector box.
- Confirmed a smaller downstream pose-validity failure mode.
- Confirmed that selected surplus detections also originate with surplus
  detector boxes.
- Retained RTMPose-M as the current pose baseline.
- Localized the next engineering target to close-contact person detection.
- Closed the diagnostic branch to prevent repeated diagnostic cycling.



### Bounded Detector Score-Threshold Experiment ? Run 01

- Tested one pre-registered YOLOX score-threshold change from `0.70` to `0.50`.
- Re-evaluated the same 100 human-ground-truth frames.
- Observed no change in two-person coverage, occlusion/crossing coverage,
  detection deficits or surplus detections.
- Improvement gate failed.
- Closed score-threshold tuning without testing additional threshold values.
- Production configuration remains unchanged.
- RTMPose-M remains the current baseline with known close-contact
  multi-person limitations.



### Multi-Person Evidence Capability Gate

- Added `MultiPersonEvidenceStatus` to the Single Attempt V2A contract.
- Added explicit multi-person evidence capability state.
- Added `multi_person_interaction_metrics_reportable = false`.
- Default multi-person evidence status is `insufficient`.
- Verified the capability contract with direct assertions.
- Existing metric calculations and inference pipeline were not changed.



### Single Attempt V2A Response Multi-Person Gate

- Wired `SingleAttemptCapabilities` explicitly into the real
  `analyze_single_attempt()` response.
- Added API assertions for:
  - `multi_person_evidence_status = insufficient`
  - `multi_person_interaction_metrics_reportable = false`
- Ran the existing Single Attempt V2A API test suite.
- Result: `4/4 PASS`.
- Existing metric behavior and fail-closed scientific boundaries were preserved.
- No model inference or detector changes were performed.



### Boundary-Normalized Landmark Reporting Gate

- Added explicit `boundary_normalized_landmarks` provenance to
  `PoseObservation2D`.
- Added a reporting gate preventing metrics that depend on boundary-normalized
  landmarks from becoming automatically reportable.
- Preserved the metric value for human review rather than silently discarding
  it.
- Re-evaluated the existing V2A artifact without new pose inference.
- Run 01 status:
  - duration: reportable
  - trunk inclination: review_required
  - support-leg knee angle: reportable
- Added and passed a dedicated unittest regression test.



### UM-ANG-003 ? Projected Attacking-Leg Knee Angle

- Added `AttackingLegSelection` to the Single Attempt V2A request/response contract.
- Attacking-leg classification requires `human-confirmed` provenance.
- Added `UM-ANG-003` to the approved V2A metric registry.
- Reused the approved `projected-knee-angle-1.0.0` image-plane method.
- Reused the existing metric-specific boundary-normalization reporting gate.
- Added fail-closed behavior: missing attacking-leg confirmation withholds the metric.
- Run 01 result: `157.99 deg`, `reportable`.
- Added and passed two dedicated unittest regression tests.
- No new pose inference was required for Run 01.



### UM-ANG-004 Method Definition Gate

- Reviewed the existing scientific registry for `UM-ANG-004`.
- Determined that the current specification does not define a sufficiently
  precise versioned image-plane hip-angle method for implementation.
- Deferred implementation rather than inventing a formula.
- No production or inference changes were made.



### V2A Four-Metric Regression Stability

- Updated the existing V2A API regression expectation from three to four metrics.
- Ran the targeted V2A regression suite after `UM-ANG-003` integration.
- Result: `9/9 PASS`.
- Confirmed no regression in:
  - missing-pose fail-closed behavior;
  - API/OpenAPI contract;
  - boundary-normalization reporting gate;
  - human-confirmed attacking-leg validation;
  - `UM-ANG-003` fail-closed behavior.
- No new inference was performed.


### Experimental Neutral Identity Tracker Prototype

- Added a project-owned `ExperimentalRTMLibIoUTracker` implementing the
  existing `NeutralIdentityTracker` Protocol outside the production V2A path.
- Reused RTMLib `0.0.16` `compute_iou` and its default strict
  `IoU > 0.3` baseline without presenting the threshold as scientifically
  validated.
- Kept all identities role-neutral and all association provenance
  `AI-inferred`; no Tori/Uke role is produced.
- Kept `association_confidence=None` and explicitly records
  `association_confidence_unavailable` rather than converting IoU into a
  confidence score.
- Added fail-closed behavior for ambiguous multi-candidate overlap,
  multi-person detection collapse/occlusion risk, disappearance and unverified
  reappearance. Lost identities are not silently restored.
- Added synthetic coverage for neutral track creation, stable continuation,
  detection-order changes, ambiguity, disappearance, occlusion collapse,
  unverified reappearance, reset, one-to-one assignment, unavailable
  confidence and role-label exclusion.
- Existing identity-contract plus prototype tests pass `29/29`; syntax
  compilation passes.
- No model/video inference, V2A production change, scientific-metric change,
  package installation or JM-DEC-024 change was performed.



### Neutral Identity Tracker Human-Mapped Evaluation - Run 01

Date: 2026-08-10

Status: Validated experimental milestone; production approval denied

#### Human Review

- Completed chronological neutral identity review for the bounded
  `41,000-44,000 ms` interval (`frames 1025-1100`).
- Reviewed 31 deterministic nearest-source frames at the existing 10 FPS
  engineering evaluation setting; this is not a scientific FPS claim.
- Finalized all 34 detection rows as `subject-1` (`15`), `subject-2` (`5`) or
  `unassigned` (`14`).
- Preserved human crossing, occlusion and reviewer-note fields; all 34
  detection rows were marked crossing and occlusion for this interval.
- Used belt appearance only as temporary human-review context for this
  recording. No appearance rule, Tori/Uke label or automatic identity inference
  was introduced.
- Human mapping SHA-256:
  `ca13d810259778ed65816dd12efa43d4ed0200606e8f60a0da316a078739ec0a`.

#### Native Evaluation

- Ran the unchanged evaluation-only `ExperimentalRTMLibIoUTracker` solely on
  the stored geometry artifact; no video or model inference was rerun.
- Verified native Python `3.12.10` execution against installed RTMLib `0.0.16`
  and preserved the unvalidated strict `IoU > 0.3` engineering baseline.
- Converted the human-visible subjects into 62 role-neutral
  `AnnotatedTrackAssignment` reference rows and excluded 16
  `review_required` subject decisions from assigned coverage.
- Kept `association_confidence=None`; IoU was not converted into confidence.
- Native output exactly reproduced the provisional tracker, conversion,
  decision, event, assignment, observation and requested-metric results.
- Native result SHA-256:
  `f380e33d61a2b59c21426ff56392bb148fa972b23a8ab7f6adccb8f3ae39a97f`.
- Native result artifact:
  `ai_engine/runtime/identity_evaluation/run01_041000_044000_rtmpose_m/run01_identity_tracker_evaluation_native.json`.

#### Results

| Metric | Result |
|---|---:|
| Assignment coverage | `4/62 = 6.45%` |
| Identity switches | `1` |
| Crossing identity switches | `1` |
| Reappearance preserved | `0` |
| Reappearance changed | `1` |
| Reappearance unverified | `0` |
| Detection-order changes | `0` |
| Detection-order-change identity switches | `0` |
| Track-assignment collisions | `0` |
| Detection-assignment collisions | `0` |
| Confidence coverage | `0.00%` |

#### Production Disposition

- Added JM-DEC-025.
- The current greedy-IoU tracker is not approved for production or V2A
  integration because assignment coverage is inadequate, the scored crossing
  produced an identity switch, the scored reappearance changed identity and no
  association confidence is available.
- No tracking-accuracy claim is made. Zero collisions and zero detection-order
  changes do not offset the low assignment coverage.
- RTMPose-M, JM-DEC-024, the closed detector threshold-tuning branch, the V2A
  production pipeline and the multi-person evidence gate remain unchanged.


### Flutter-to-Python Reviewed V2A Orchestration

- Connected the existing selected Uchi Mata video and camera-view state to a
  bounded manual reviewer/development panel in Analyze while preserving the
  independent V1 pose-summary workflow.
- Added mandatory fail-closed input validation for reviewed attempt
  boundaries, human-confirmed Tori neutral track/detection, support leg,
  attacking leg, angle frame/event and camera-suitability gates.
- Registered and called the existing typed multipart reviewed-video V2A
  service; no new endpoint or scientific request field was introduced.
- Updated the Flutter response boundary to accept exactly `UM-TIM-001`,
  `UM-ANG-001`, `UM-ANG-002` and `UM-ANG-003`, bind attacking-leg selection,
  require insufficient multi-person evidence and reject reportable interaction
  capability.
- Rendered the existing four-metric result card and contract-approved BLUE
  geometry without promoting `review_required` or `withheld` states.
- Added English/Persian reviewed-workflow labels and regenerated localization
  outputs with the official Flutter generator.
- Added synthetic widget coverage proving incomplete review fails before the
  service and complete manual input reaches the typed service.
- Validation: 11 focused Flutter tests pass across parser/card, service and
  review-panel files; 14 targeted Python V2A contract/API tests pass. Direct
  `dart analyze lib` reports no V2A diagnostic and retains 20 unrelated
  pre-existing repository diagnostics.
- No model/video inference, tracker integration, detector tuning,
  metric/formula change, dependency change or Git write was performed.


### Uchi Mata Reference Completion - Block 1: Navigation and Action Integrity

- Audited the complete Uchi Mata path from Home and Techniques entry through
  Technique Detail, all 16 dashboard cards, primary/app-bar controls, section
  bottom sheets, Media, Quiz, Favorite, Progress and Analyze.
- Added a single router-owned availability decision and mirrored it in the
  dashboard and primary-action surfaces.
- Marked Training, Mastery/Progress, Sensi Bot and champion content without a
  verified reference as explicitly unavailable with English/Persian feedback.
- Repaired the dead tap path in Competition Analysis and Top Execution media
  cards. Media without an approved source now fails closed before the video
  player and shows a localized unavailable badge/message.
- Rejected the current YouTube search-result competition URL as a direct media
  destination while retaining the existing competition insight section.
- Preserved the official Uchi Mata image destination and migrated Quiz answer
  selection to the current Flutter `RadioGroup` contract. Submit remains
  disabled until an answer is selected.
- Targeted validation: `8/8` navigation-integrity tests pass. Targeted Flutter
  analysis reports no error or new deprecation; three pre-existing unused
  private `MediaSection` helpers remain reported and were not deleted.
- V1/V2A science, the four approved metrics, identity/tracker research,
  detector thresholds, other product modules and Git history were unchanged.


### Uchi Mata Reference Completion - Block 2: Approved Content Integrity

- Added immutable field-level content resolution from the existing Uchi Mata
  model and approved locale records; no technical Judo content was added.
- Rebuilt Overview and Technical Analysis with shared Design System content
  components. Identity metadata, description, analysis, all five canonical
  execution steps, five key points, five mistakes and four safety items now
  render without generic filler or duplicated steps.
- Removed the false interpretation of a search-result media URL as competition
  insight. Tactical now displays approved key points only and Competition
  displays the four existing combinations and four existing counters; both
  retain explicit incomplete states for their missing dedicated sources.
- Added fail-closed source filtering. The three existing concrete IJF,
  Kodokan and EJU references render; search-result, blank-title and invalid URL
  entries do not.
- Preserved exactly the 10 approved Quiz records and deterministic answer
  behavior. Added an explicit empty state and field-level translation fallback;
  approved Persian question/choice/explanation translations remain absent.
- Localized all Block 2 interface labels and incomplete states in English and
  Persian and regenerated Flutter localization outputs.
- Added an explicit limitation to the existing visual biomechanics prototype:
  it is educational visualization, not measured/reconstructed 3D or real
  force, torque, power or center-of-mass output.
- Validation: `19/19` targeted content/navigation widget tests pass and bounded
  `flutter analyze` of 13 changed implementation/test files reports no issues.
- Media acquisition, Training, Shadow Training, Conditioning, Progress,
  Champions, Sensi Bot, V1/V2A, tracker/detector/AI research, other modules and
  Git history were unchanged.


### Uchi Mata Reference Completion - Block 3: Reusable Technique Template Proof

- Replaced the reviewed V2A ID/name check with an explicit, fail-closed
  `TechniqueModel` capability; only the approved Uchi Mata reference enables
  it, while generic V1 behavior remains unchanged.
- Made the Technique Dashboard Quiz badge derive from the supplied model's
  actual question count instead of the fixed Uchi Mata value `10`.
- Made primary Analyze action text and widget keys technique-neutral while
  preserving Favorite, Training/Progress feedback and destinations.
- Proved reusable Overview, Technical Analysis, combinations/counters, Quiz,
  Sources, variable-length lists and explicit empty states with a neutral
  test-only fixture. No second production technique or Judo content was added.
- Added a source audit proving canonical Uchi Mata educational prose is not
  embedded in the reusable educational widgets.
- Validation: `25/25` targeted Block 1-3 Flutter tests pass; bounded Dart
  analysis of eight implementation/test files reports no issues; format check
  reports zero changes.
- Uchi Mata approved content, Media, visual-learning/Training/Progress work,
  other modules, AI research, scientific contracts and Git history remain
  unchanged.


## 2026-08-12 - Uchi Mata Reference Closure and Local V2A History Foundation

### Uchi Mata Golden/Reference Slice

- Added model-driven visual companions for Kuzushi, Tsukuri and Kake using the
  existing repository-native Uchi Mata painter and approved first three
  execution steps. Phase labels/instructions remain caller-supplied rather
  than embedded in the painter, and reduced-motion users receive a static
  selectable fallback.
- Added an explicit fail-closed renderer identity for custom-painter visual
  sequences so a generic sequence cannot silently inherit Uchi Mata geometry.
- Added bounded educational Practice guidance from the existing approved
  execution steps, key points, mistakes and safety fields. It explicitly does
  not provide Training Center, timers, repetitions, conditioning plans or
  personalized coaching.
- Preserved counts: execution/key points/mistakes/safety/combinations/counters
  `5/5/5/4/4/4`; Quiz remains `10/10`.
- Media, dedicated Tactical/Competition, Progress/Mastery, Champions and Sensi
  Bot remain source-blocked or intentionally unavailable rather than claimed
  complete.
- Gate verdict: `UCHI_MATA_CODE_CLOSURE_PASS`. Targeted Uchi content/navigation
  and V1/V2A validation completed `46/46 PASS` in bounded low-memory batches.

### Local Reviewed V2A Attempt Summaries

- Approved and implemented JM-DEC-026 with immutable record schema `1.0.0`, a
  dedicated SharedPreferences storage key, fail-closed repository,
  ChangeNotifier state and dependency injection.
- Added the explicit localized **Save locally** action after an eligible strict
  V2A result, with saved/already-saved/failure states and on-device disclosure.
- Preserved all four metric identities/status/provenance/limitations and the
  insufficient multi-person/non-reportable-interaction boundary.
- Excluded video/path/filename/overlay/detection-index/score/mastery/trend and
  Profile data. Corrupt storage is not overwritten; stable analysis IDs are
  deduplicated.
- Added targeted contract, JSON, persistence, recreation, corruption,
  deduplication, ordering, Provider and UI tests. No History/Profile/Progress
  screen, package, inference, AI research or Git-history change was added.

## 2026-08-12 — Local Athlete Profile and Reviewed Analysis History

### Added

- Strict `1.0.0` local Athlete Profile data for optional, self-reported display
  name, belt rank, club, country and biography.
- Dedicated SharedPreferences storage, fail-closed repository/provider and
  honest loading, empty and error states.
- A real `/profile` route connected to both existing Profile entry points.
- Chronological V2A History cards preserving original scientific status,
  provenance, method, confidence availability, limitation and withheld reason.
- Targeted contract, persistence, navigation, UI and integration coverage.

### Changed

- Promoted the local attempt-history provider to app scope so explicit V2A save
  and Profile History share one source of truth.
- Regenerated English/Persian localization output.

No automatic identity/rank, mastery, performance, trend or progress claim was
added. No V1/V2A formula/version/provenance, tracker, detector or inference path
changed. The slice remains local/demo-only and governed by `JM-DEC-026`.

## 2026-08-13 — Platform Framework Alignment and Governance Foundation

### Added

- Replaced the hardcoded 16-card catalog with one canonical registry of exactly
  18 official module identities, stable IDs, localization keys, platform
  surfaces, readiness, availability and fail-closed route state.
- Added `JM-DEC-027` for the four coordinated platform surfaces, five Athlete
  Home journeys, shared analysis-capability boundary and product priorities.
- Added an empty-by-default typed `TechniqueModel.trainingContent` contract for
  future Shadow, Strength & Conditioning and Resistance-Band drills. No drill,
  prescription or Uchi Mata exercise content was authored.
- Added the evidence-only icon audit: 51 semantic IDs in seven subsets, all
  Material-temporary; no recoverable exact approximately-120 taxonomy.
- Formalized selected-language completeness and full RTL behavior without
  bulk-translating incomplete content or creating another localization system.

### Changed

- Athlete Home now derives its module cards from the canonical registry and
  shows only its two real module destinations: Techniques and Athlete Profile.
  Home and Settings remain real routes but are not equal-weight module tiles.
- Removed Medical Support and Nutrition from official module identity; their
  former tiles had no approval under the 18-module architecture.
- Recorded Uchi Mata Gold as a target definition spanning approved content,
  distinct visuals, licensed media, technique-specific training/biomechanics,
  V1/V2A, grounded AI Sensei, History/Progress and complete English/Persian.

No Home redesign, new module screen, media acquisition, icon artwork, Uchi Mata
drill content, scientific metric, V1/V2A, tracker/detector, inference, build,
checkpoint or Git-history operation is included.

Validation: registry `5/5`, training contract `5/5`, localization `3/3`,
Home/Profile navigation `3/3` and Uchi Mata navigation integrity `10/10` all
pass; bounded analysis reports no issues, format check reports zero changes and
the mission-scoped diff/whitespace checks are clean.

### Persistent Product Charter

- Added `docs/JUDO_MIND_PRODUCT_FRAMEWORK.md` as the canonical, human-readable
  product-intent charter without changing runtime availability or claiming
  unfinished capabilities as complete.
- Added its mandatory complete review and explicit source-responsibility
  hierarchy to `AGENTS.md`.
- Extended the bounded module-registry test to compare the charter's exact
  ordered 18-module list with the canonical runtime registry, preventing silent
  regression to 16 or 17 modules.
- Targeted module/charter consistency validation: `5/5 PASS`; bounded Dart
  analysis reports no issues and the changed test is formatted.

## 2026-08-13 — Technique-Specific Training Experience Foundation

### Added

- Backward-compatible Shadow, Strength & Conditioning and Resistance-Band
  configuration contracts with selected-language fail-closed resolution.
- Three structurally distinct reusable typed renderers for movement/phase,
  exercise/prescription and band anchor/direction evidence.
- English/Persian labels, unavailable states, safety headings and semantics.
- A pending-only Uchi Mata training approval template for coach, scientific,
  localization, media, safety, source and prescription review.

### Changed

- Shadow, Conditioning and new Resistance-Band dashboard availability now
  derives from approved typed content rather than old visual-learning
  prototypes or technique identity.
- Uchi Mata remains honestly unavailable for all three experiences because its
  production training contract is empty.

No drill, dosage, media, safety advice or scientific claim was authored.
Test-only fixtures do not enter production data. Validation: model/renderers
`11/11 PASS`; navigation/Favorite/Analyze regression `10/10 PASS`; bounded Dart
analysis and localization generation pass.

## 2026-08-13 — Icon System Candidate Batch 01

### Added

- Machine-readable lifecycle manifest for exactly 51 evidenced runtime icon
  IDs and the seven validated subset counts.
- Versioned original-vector design specification and 12 editable candidate
  SVGs with light/dark, size and directional RTL review contact sheet.
- Standard-library validation for runtime/manifest mapping, uniqueness,
  subsets, candidate assets/XML, runtime exclusion, unresolved taxonomy,
  legacy references and RTL metadata.

### Audited

- Refreshed `Icons.*` count: 243 total, 51 central Material mappings and 192
  direct bypasses in 53 files.
- Kept the 69 unresolved approximate-target positions explicit and unnamed.

All candidates remain `candidate_review_required`; no custom icon is
production-approved, packaged or connected to the runtime UI. Validation:
`5/5 PASS`.

## 2026-08-13 — Uchi Mata Gold Learning Experience

### Added

- Five localized technique journeys: Learn, Train, Analyze, Track Progress and
  Connect with Coach.
- A model-driven selectable Technical progression and distinct structured
  renderers for Mistakes & Safety and Combinations & Counters.
- A real Track Progress entry to the existing local analysis History.

### Changed

- Confined the educational Uchi Mata biomechanics painter to the Biomechanics
  destination instead of reusing it as the Technical Analysis experience.
- Kept Coach and technique-specific training visible but explicitly
  unavailable until approved workflows/content exist.
- Preserved Favorite, ten-question Quiz, concrete Sources, V1 and reviewed V2A
  destinations and scientific boundaries.

Validation: content/navigation `34/34 PASS`, module registry `5/5 PASS`,
bounded Dart analysis clean and localization generation successful. No model
inference, new scientific claim, detector/tracker change or production coach
capability is part of this change.

## 2026-08-13 — Grounded Sensei V1

### Added

- Typed `GroundedSenseiRequest`, `GroundedSenseiExplanation` and
  `GroundedSenseiService` contracts.
- A deterministic local implementation that accepts only the exact reviewed
  Uchi Mata four-metric V2A boundary.
- Collapsed/expanded English and Persian result explanation with source
  binding, evidence, statuses, provenance, BLUE references, selected-language
  safety, limitations and explicit unavailable next action.

### Guarded

- Missing/duplicate/unknown metrics and any request/result/locale/scientific
  mismatch fail closed.
- V2A result, BLUE overlay and History behavior survive Sensei failure.
- No prompt, network/API client, model inference, confidence fabrication,
  performance classification, identity/phase inference, drill fabrication,
  multi-person interaction, 3D or kinetics claim was introduced.

Validation: Grounded Sensei integration `15/15 PASS`, related V2A/History
regression `10/10 PASS`, bounded analysis clean and localization generated.

## 2026-08-13 — Icon Candidate Batch 02

### Added

- Twelve editable review-only SVG candidates and one Batch 02 contact sheet,
  while preserving Batch 01 for comparison.
- Manifest lineage from each current Batch 02 candidate to its prior Batch 01
  candidate.

### Refined

- Coherent phase-family geometry for Kuzushi/Tsukuri/Kake.
- Footwork-based Entry, jacket-control Grip, connected joint/angle/vector
  Biomechanics and simplified 16 px Movement Layer/AI Analysis.
- RTL policy so technique Entry, Counter, Transition and Movement Layer never
  auto-mirror solely because the interface is RTL.

All candidates remain `candidate_review_required`; production custom icon
count is `0`, and no candidate is packaged or used at runtime. Validation:
icon lifecycle suite `5/5 PASS`.

## 2026-08-13 — Athlete Home Platform Shell V1

### Added

- A five-journey Athlete Home shell with real Learn, reviewed Uchi Mata Analyze
  and local Profile/History destinations.
- One registry-backed, localized directory for all 18 official modules,
  coordinated platform surfaces and honest readiness/unavailable states.
- Optional Continue entries derived only from real initialized local recent
  technique and saved-analysis data.

### Changed

- Replaced the non-functional Start Training hero action with Explore
  Techniques.
- Removed the synthetic Back action from root Home while preserving explicit
  nested Back behavior.
- Added distinct language, Settings and Profile access and localized the
  Settings title.
- Kept Train and Connect with Coach visible but non-interactive until their
  approved content, product, safety and privacy gates exist.

Validation: targeted Home, 18-module registry, Profile navigation and
English/Persian localization tests `20/20 PASS`; bounded Dart analysis clean;
localization generation successful. V1/V2A, Grounded Sensei, BLUE, scientific
metrics/provenance, detector/tracker/Identity, training prescriptions and the
candidate-icon lifecycle are unchanged.

## 2026-08-13 — Home Navigation De-duplication and IA Correction

### Changed

- Separated the Hero from Learn: it now opens real local History when present
  or the reusable featured reference-technique destination otherwise.
- Scoped Home Analyze visibly to Uchi Mata while preserving the existing
  V1/human-reviewed V2A boundary.
- Routed Track Progress and Technique History to a dedicated presentation of
  the existing local scientific History instead of the Profile editor.
- Kept Header Profile/Settings and their official module-directory entries as
  clear global shortcut/directory pairs.
- Reorganized the registry-backed directory into real destinations first,
  platform-surface filters and one collapsed 14-module unavailable/deferred
  group. Home is marked current and does not navigate to itself.

### Preserved

- Exactly 18 official modules and exactly four real registry destinations.
- Closed Train/Coach and every unavailable/deferred module route.
- English/Persian localization, RTL, V1/V2A science, Grounded Sensei, BLUE,
  Profile/History storage, detector/tracker/Identity rules, media, training
  prescriptions and candidate-icon governance.

Validation: Home IA `13/13 PASS`; targeted existing navigation, content,
registry, localization, V2A and training-boundary regression `58/58 PASS`;
bounded Dart analysis clean; localization generation successful. No Android
build or inference was run.

## 2026-08-14 - App Management & Settings Local MVP

### Added

- Persistent English/Persian selection through the existing local preference
  boundary, with immediate locale application and Persian RTL presentation.
- A structured local-data section showing the real initialized V2A History
  count and an explicit confirm/cancel clear-History action.
- Localized capability transparency backed by the approved V2A metric contract,
  including unchanged `review_required`, insufficient multi-person evidence and
  non-reportable interaction boundaries.

### Guarded

- Clear History targets only the versioned local History envelope; Athlete
  Profile, language preference and unrelated local state survive.
- Corrupt/unsupported History fails closed rather than being overwritten.
- No working-looking notification, cloud, subscription, account, coach/federation
  sync, light-theme or AI-preference control was added.
- No fake runtime version, cloud/encryption claim or scientific formula was
  introduced.

Validation: Settings Local MVP `8/8 PASS`; related History/Profile/Home/registry
regression `31/31 PASS`; bounded analysis clean; localization generation
successful; mission-scoped `git diff --check` clean. No Android build, model/video
inference, package installation or Git-history operation was run.

## 2026-08-14 - Scientific Progress Evidence Foundation

### Added

- A typed fail-closed `ProgressEvidenceSummary` derived only from valid local
  versioned V2A History records.
- A dedicated Progress Overview with exact attempt/status counts, latest saved
  timestamp, technique/method-version context, restrained evidence bars,
  chronological attempt cards and a link to raw Local Analysis History.
- Complete English/Persian presentation and RTL coverage for the new Progress
  destination.

### Changed

- Monitoring / Progress & Mastery now routes to the real evidence foundation
  with `foundationOnly` readiness.
- Canonical identity remains exactly 18 modules; reachable registry destinations
  are now 5, while 13 unavailable/deferred modules remain fail closed.
- Home Track Progress continues to open Local Analysis History and was not
  redirected to the official module destination.

### Guarded

- Invalid or unknown evidence and incompatible method versions fail closed.
- `UM-ANG-001` remains `review_required`; multi-person evidence remains
  insufficient and interaction metrics remain non-reportable.
- No mastery, score, ranking, readiness, proficiency, prediction, trend,
  improvement/degradation, value comparison or invented confidence was added.

Validation: Progress model/UI `13/13 PASS`; targeted Home/registry/Settings,
History and Uchi Mata V1/V2A regression passed after one test-only Scrollable
correction; bounded analysis clean; localization generation successful. No
Android build, inference, package installation or Git-history operation ran.

## 2026-08-14 - Technique Journey Convergence

### Changed

- Assigned Overview, Technical Lesson, Mistakes & Safety and Combinations &
  Counters distinct content ownership without repeated model fields.
- Replaced generic Practice, tactical and competition fallback content with
  concise fail-closed states when no destination-specific source exists.
- Reduced the Uchi Mata hub to one technique-local Single-Attempt entry; removed
  the pre-result Grounded Sensei entry and the media-level coaching action.
- Reorganized the journey directory into compact collapsed groups with
  secondary destinations under More.

Validation: Uchi Mata navigation/content integrity `34/34 PASS`. V1/V2A,
scientific metrics, provenance, History, the 18-module registry and the Home
Analyze shortcut were not changed. No Android build, inference, package
installation or Git-history operation ran.

## 2026-08-15 - Natural Persian UX Convergence

### Added

- A stable Persian UX writing guide for athlete-facing language, Japanese Judo
  terminology, scientific disclosure, errors, RTL and fail-closed content.
- Presentation-only localization adapters for canonical technique taxonomy,
  difficulty, filters and analysis provenance.
- Complete Persian question, option and explanation records for all 10 Uchi
  Mata Quiz items without changing answer indices.

### Changed

- Replaced mixed or developer-facing Persian wording across Home, Techniques,
  Uchi Mata, Analyze, Result, History, Progress and Settings with concise
  generated localization copy.
- Moved reviewed gate coordinates, metric IDs, method versions and detailed
  scientific evidence behind collapsed disclosure controls while preserving
  visible reportable, `review_required`, withheld and insufficient states.
- Localized known History metric names, provenance, limitations, source names,
  video-selection guidance and safe error presentation.
- Made incomplete Persian media fail closed instead of silently presenting the
  English media catalog as localized content.

Validation: mission-targeted Flutter suites `92/92 PASS`; localization
generation successful; bounded `dart analyze lib` found no issue in changed
files and retained 11 unrelated pre-existing warnings. The repository-wide
`flutter analyze --no-pub` attempt reached its seven-minute bound without a
result and was not reported as successful. No Android build, inference,
package installation or Git-history operation ran.

## 2026-08-15 - Full Persian Runtime Localization Closure

### Added

- `docs/PERSIAN_LOCALIZATION_AUDIT_V1.md` with the exact seven-way inventory,
  disposition and counts for the 261-message legacy Persian gap.
- Regression coverage requiring explicit Persian coverage for every English
  runtime-template message.

### Changed

- Replaced the two reachable legacy aliases (`profile`, `retry`) with their
  existing approved localized messages.
- Retired 259 unreachable/deprecated messages from the English template rather
  than fabricating Persian content or creating an invariant allowlist.
- Regenerated all localization Dart files through Flutter `gen-l10n`; English
  and Persian now contain exactly `475` non-metadata messages each, with zero
  Persian template gaps.

Validation: focused localization, RTL, Home and Progress tests `29/29 PASS`;
bounded analysis of the three changed Dart/test files reports `No issues
found`; targeted format check reports `0 changed`. Arabic, German, French,
Japanese and Russian remain deferred and were not claimed complete. No build,
device interaction, inference, package installation or Git-history operation
ran.

## 2026-08-15 - Non-Visual Validation Reliability V1

### Added

- A preserved-history canonical detached runner at
  `D:\projects\judo_mind_checkpoints\run_judo_mind_device_validation_canonical_v3.ps1`.
- Explicit `-SyntaxCheck`, synthetic `-SelfTest` and ADB-free
  `-PreflightOnly` modes, deterministic result categories and exit codes.
- `docs/DEVICE_VALIDATION_RUNBOOK.md` with the single later operator command,
  safe modes, historical defect audit and static-warning disposition.

### Fixed

- Normalized nullable/scalar command and file results before every `.Count`
  access.
- Replaced attempted assignment to PowerShell's read-only `$PID` with
  `$appProcessId`.
- Made native exit code authoritative when stderr contains warnings.
- Added deterministic authorized/unauthorized/offline/missing/wrong-model
  device classification and a hard one-build-attempt guard.
- Corrected 8 of the 11 prior Dart diagnostics through behavior-preserving
  import, comment, collection, `const` and unused-parameter cleanup.

Validation: canonical runner SyntaxCheck and SelfTest both exit `0`; SelfTest
reports zero failures, zero reserved-PID assignments, correct four-state device
classification, passing zero/one/multiple preservation checks, authoritative
warning exit code `0`, passing one-build-attempt enforcement and
`BUILD_ATTEMPTS=0`. Git status remained identical and staging stayed empty.
Bounded analysis of the eight corrected Dart files reports no issues. The
bounded `dart analyze lib --format machine` repeat reports only three preserved
unused private Media prototypes; this is not a clean global
`flutter analyze` claim. No build, Gradle, ADB/device operation, install,
launch, screenshot, inference or Git-history operation ran.

## 2026-08-15 — Device-Evidence Reconciliation V1, Block A

### Fixed

- Replaced the misleading runtime `67`-technique availability claim with exact
  production (`1`), preview/unavailable (`4`) and roadmap (`67`) accounting.
- Closed all incomplete preview technique records and hid their unsupported
  secondary taxonomy from athlete-facing cards.
- Completed current Uchi Mata Persian dynamic learning fields and localized the
  biomechanics visualization title, description and layer labels.
- Removed active play/open affordances and routes from media records without an
  approved payload.
- Labeled IJF, Kodokan and EJU root pages as organization/general references,
  not technique-specific direct evidence.

### Validated

- Reconciled the installed APK through direct ADB launch recovery without a
  rebuild or reinstall; the current baseline SHA-256 is
  `341ba5319701dd09496a471b7a92b711c298850d9333a36b4a6430dbc687b13d`.
- Targeted tests `54/54 PASS`; bounded static analysis of `17` items reports no
  issues; localization generation passed.

No V1/V2A, metric, provenance, detector, tracker, Identity, training, icon,
model-inference or Git-history behavior changed.

## 2026-08-15 — Athlete Information Architecture Convergence V1

### Changed

- Prioritized four real Athlete Home actions and moved unavailable Train and
  Coach journeys into a compact `Coming later` presentation.
- Routed Home Track Progress to Progress Overview and made the empty Progress
  call to action open reviewed Uchi Mata Analyze.
- Consolidated unavailable technique Train / Coach actions under one compact
  fail-closed group while preserving one Analyze action and real History.
- Renamed the secondary registry screen to Platform Overview, retained all 18
  module identities and replaced internal readiness wording with athlete-facing
  availability language.

Validation: current Uchi Mata navigation `12/12 PASS`; the other `48` targeted
checks in the combined run passed; bounded static analysis `8 items / No issues
found`. No build, inference or Git-history operation was performed.

## 2026-08-21 — Club Session Planner V1

### Added

- Upgraded local Club storage to schema `2.0.0` with explicit session types,
  optional coach title/objective and ordered typed session items.
- Added six strict coach-entered dosage modes: duration, repetitions,
  sets × repetitions, rounds × duration, distance and descriptive/custom.
- Added a scroll-safe English/Persian planner with create/edit, item
  add/edit/remove/reorder, explicit empty-plan presentation and preserved
  attendance controls.

### Changed

- Added lossless in-memory migration from valid schema `1.0.0`; historical
  sessions remain `unspecifiedLegacy` and the source payload is not rewritten
  until an intentional save.
- Replaced technical Persian Club copy and ambiguous plus-only actions with
  natural localized text, locale-aware digits/date display and visible save
  feedback. Summary counts now read as non-interactive information.

Validation: targeted Club planner/foundation, registry, Home and Uchi Mata
navigation tests passed after two bounded small-screen/count corrections;
localization generation passed. No Android build, device operation, inference,
package install or Git-history operation ran. Planned items remain
coach-authored data, not completed training or scientific load. The exercise
library, cloud and real multi-athlete workflows remain unavailable.

## 2026-08-21 — Club Session Composer UX V2

### Changed

- Replaced the repeated per-item dialog workflow with one scrollable session
  composer containing metadata, all inline plan sections, a live summary and
  one final save action.
- Added localized accordion headers and in-place mode-specific dosage fields,
  plus expand/collapse, duplicate, delete and explicit move-up/move-down
  actions. “Add next section” creates an expanded stable-ID draft without
  leaving the composer.
- Added localized unsaved-exit confirmation. Draft edits never write partial
  repository state; cancel/discard is non-persistent, while the final save
  returns one complete ordered plan and preserves existing attendance.
- Added honest calculable-time presentation: explicit minutes and
  rounds-by-minutes may be summed, while repetition/set/distance/descriptive
  time remains unknown and is labelled partial or unavailable.
- Allowed the existing `custom_title` field to hold an optional coach title for
  standard categories while retaining required meaningful titles for custom
  categories. Schema remains `2.0.0`; no migration or stored-field change was
  introduced.

Validation: Composer V2 `5/5 PASS`; Club Planner/Foundation, canonical module
registry, Home and Uchi Mata navigation regressions `45/45 PASS`; bounded Dart
analysis reports no issues; localization generation and narrow English/Persian
RTL coverage pass. No Android build, inference, package installation or
Git-history operation ran.
## 2026-08-24 — Strength & Conditioning Exercise Library Foundation V1

- Added a shared training activity contract and a strict versioned local
  Exercise Library model/storage/repository/provider boundary.
- Added fail-closed approved-versus-coach-authored evidence rules, stable IDs,
  revisions, archive/restore, localized search/filtering and honest empty state.
- Added the localized Club Exercise Library destination and coach-authored
  editor without seeding exercises or prescriptions.
- Integrated Exercise Library selection into the existing single-page Session
  Composer while preserving manual entry and coach-entered dosage/rest/notes.
- Added immutable exercise snapshots to Club session items and migrated Club
  schemas 1/2 to schema 3 without eager storage rewrite.
- Added targeted model/provider/repository/widget/migration tests including
  360px English/Persian RTL coverage; Club, registry, Home, Uchi Mata and V2A
  boundary regressions pass.
- Accepted JM-DEC-029, the Evidence-Driven Polyglot and Cross-Platform
  Engineering Policy.

## 2026-08-24 — Exercise Library Bulk Import & Fast Selection V2

### Added

- Added the canonical UTF-8 CSV `1.0.0` template, authoring guide and strict
  parser with quoted/multiline field support, deterministic row diagnostics,
  stable-ID duplicate checks and direct URL/media-declaration validation.
- Added a cross-platform CSV picker adapter behind a testable project
  interface, exact import preview counts and one confirmed atomic import.
- Added persisted favorites and bounded deterministic recent selections.
- Added a searchable Session Composer selector that presents favorites and
  recents first without creating dosage or scientific claims.

### Changed

- Coach-authored entries may contain one authored language; the current app
  language is required during manual creation and missing translations remain
  explicitly unavailable. Approved repository entries still require both
  English and Persian evidence.
- Simplified the primary library surface to search, category, recent,
  favorites and compact results; source/review filters moved under More
  Filters and archive/restore remains available.

Validation: V2 tests `7/7 PASS`; the final bounded Exercise Library, Club,
migration, attendance, localization, Uchi Mata, V1 and V2A batch is
`57/57 PASS`; targeted Dart analysis clean. No Android build, inference,
staging, commit or push was performed.

## 2026-08-24 — Exercise Library V2 Persian Discoverability Closure

### Fixed

- Added deterministic comparison-only normalization for Persian whitespace,
  ZWNJ and Arabic/Persian keyboard letter variants while preserving source and
  display values byte-for-byte.
- Made All, Favorites and Recent filters permanently visible with counts and
  localized empty states; removing the final active favorite safely restores
  the All result view.
- Replaced mechanical Persian CSV import wording with natural `واردکردن`
  language.
- Completed the CSV guide with the exact activity-category, dosage-mode and
  modality values plus one parser-validated documentation-only example.

Validation: corrective tests `10/10 PASS`; the final bounded Exercise Library,
Composer and localization batch is `26/26 PASS`. No Android build, inference,
schema migration or Git-history operation ran.

## 2026-08-28 — JM-S0.1 Live Scientific-Foundation Inventory

### Added

- Added a documentation-only scientific-foundation registry under
  `docs/scientific_foundation/` covering live sources, HPS crosswalks,
  provisional claims, scientific metrics and engineering thresholds,
  dataset/media/model metadata and fail-closed capability states.
- Added the exact eight-class claim taxonomy, stable provisional identifier
  conventions and explicit separation of implementation, evidence,
  scientific approval and production eligibility.
- Added JM-DEC-030 for read-only shared-HPS reuse by exact crosswalk,
  independent Judo applicability review and fail-closed capability governance.

Validation was documentation-only: CSV structure/ID/taxonomy checks,
artifact-tool CSV import, SHA-256 revalidation and Git preservation checks. No
application test, build, inference, benchmark, media decode or Git-history
operation was performed.

### Closed

- JM-S0.1-R1 removed only the extra EOF newline in the Uchi Mata scientific
  metrics document; no text or scientific content changed.
- Whitespace remediation, targeted `git diff --check` and repository-wide
  `git diff --check` passed; staged files remained zero.
- Final JM-S0.1 result is `PASS`. Application code modified: `NO`;
  source/media files moved: `NO`; inference/benchmark run: `NO`; capability
  activated: `NO`; scientific approval created: `NO`.

## 2026-08-28 — JM-S0.2-B/C and JM-S0.3-A Metadata Foundation

### Added

- Added a complete 200-row metadata-only HPS reuse-candidate map with mandatory
  sport-specific review and explicit non-transfer of evidence approval.
- Added a complete 132-row claim-source-link map that distinguishes general
  document references from explicit claim citations and leaves missing links
  fail closed.
- Added bounded shift and validation reports for the source, crosswalk, claim
  and capability audits.

### Changed

- Structured title, author and normalized DOI metadata for the five Uchi Mata
  DOI references using repository text only; no publication year was invented.
- Corrected the Crosswalk denominator to five JM DOI-eligible sources, zero
  exact HPS matches and five genuinely unmatched sources; HPS-SRC-0120 remains
  an excluded HPS-only context lead.
- Extended the registry schema for metadata-only HPS candidates and explicit
  claim-link states without changing JM-DEC-030.

Validation is documentation-only. All 20 capabilities remain fail closed; no
application code, source/media asset, HPS file, inference, benchmark, Evidence
Review, approval, rule, threshold, prescription or production capability
changed.

## 2026-08-29 — JM-S0.3-B Uchi Mata Evidence Review Readiness

### Added

- Added official bibliographic verification and access-state records for the
  five direct Uchi Mata DOI candidates.
- Added a source-level Evidence Review Queue, a fail-closed claim-evidence
  matrix, a complete 29-metric evidence-gap registry and blank human-review
  forms.
- Added bounded JM-S0.3-B execution and validation reports.

### Changed

- Updated only verified bibliographic fields for `JM-SRC-0025` through
  `JM-SRC-0029`, while retaining their exact HPS-unmatched provenance.
- Extended the scientific registry schema to distinguish bibliography,
  abstract/full-text access, content readiness, human sign-off and production
  eligibility.

No scientific approval, threshold, rule, prescription or capability was
created. Two sources remain `FULL_TEXT_REQUIRED`; the claim-level mapping count
is zero because no explicit existing claim citation was verified.

## 2026-08-29 — JM-S0.3-B-H1 Bounded Judo Technical Scope Sign-off

### Added

- Added a five-row human sign-off registry that records Mohammad Javani's
  explicitly confirmed decisions only as `JUDO_TECHNICAL_EXPERT` within
  `JUDO_TECHNICAL_APPLICABILITY_ONLY`.
- Added bounded H1 execution and validation reports.

### Changed

- Updated the Uchi Mata Human Review Pack with three
  `APPROVE_WITH_LIMITATIONS` and two `DEFER_FULL_TEXT_REQUIRED` Judo technical
  decisions while retaining all unanswered scientific and biomechanical
  checkboxes.
- Extended the scientific registry schema to distinguish bounded Judo
  technical applicability from full-text, biomechanical, scientific and
  production approval.

No source became scientifically approved. Full text personally reviewed in
this stage remains `0/5`; biomechanist review remains pending for `5/5`;
threshold/rule eligibility, production eligibility and capability activation
created remain zero. Application code, HPS and scientific metric states were
unchanged, and no inference or benchmark ran.

## 2026-08-29 — JM-S0.3-C0 Biomechanist Review Assignment

### Added

- Added a three-row assignment registry for Dr. Mahdi Baghaiyan as
  `BIOMECHANIST_SPORT_SCIENTIST_REVIEWER` for `JM-SRC-0025` through
  `JM-SRC-0027`.
- Added a blank bilingual English/Persian biomechanist review package with
  source-specific access boundaries and evidence-location requirements.
- Added bounded C0 execution and validation reports.

### Changed

- Extended the scientific registry schema to keep reviewer assignment,
  review activity, completed review, reviewer decision and scientific approval
  separate.

All three assignments remain `ACCEPTED_PENDING_REVIEW`; completed reviews and
reviewer decisions remain zero. `JM-SRC-0028/0029` remain
`DEFER_FULL_TEXT_REQUIRED`. No scientific approval, threshold/rule or
production eligibility, capability activation, application change, HPS
change, inference, benchmark or paper acquisition occurred.

## 2026-08-30 — JM-S0.4-A Official Rules, Authority, and Safety Governance

### Added

- Added a three-row official-authority source registry for the existing
  Kodokan, EJU, and IJF organization roots with explicit document-kind,
  validity, supersession, and claim-use boundaries.
- Added a header-only official-rule claim-link registry because none of the 132
  existing claims contains a qualifying versioned rule and exact clause link.
- Added a 16-row safety-claim source-gap registry preserving every existing
  safety claim verbatim and fail-closed.
- Added a 14-row rule/safety gate registry plus a bilingual English/Persian
  human-review readiness guide.
- Added bounded JM-S0.4-A execution and validation reports.

### Changed

- Extended the scientific registry schema with additive authority classes,
  rule-link states, proposed safety subtypes, and independent fail-closed gate
  definitions.

No existing source or claim classification was overwritten. No scientific,
medical, rule, content, threshold, or production approval was created; no
capability was activated; application code, tests, source/media assets, HPS,
and the pending biomechanist review were unchanged.

## 2026-08-30 — JM-S0.4-B Versioned Official-Document Discovery and Intake Readiness

### Added

- Added an 11-row official-document discovery queue covering exact candidates
  from official IJF, EJU and Kodokan pages without allocating canonical source
  IDs.
- Added a matching version/supersession matrix. No candidate is marked
  `VERIFIED_CURRENT`; unknown effective dates and replacement chains remain
  explicit.
- Added an 11-row lawful acquisition queue with every download unauthorized,
  every acquisition pending and all file hashes blank.
- Added a nine-scope qualified reviewer-role matrix and a blank bilingual
  English/Persian rule-and-safety review template.
- Added bounded JM-S0.4-B execution and validation reports.

### Changed

- Extended the scientific registry schema with candidate-ID, version,
  supersession, acquisition and independent reviewer-role boundaries.

No document was downloaded and no `JM-SRC-*` ID, claim link, reviewer
assignment, human decision, scientific/rule/medical approval, eligibility or
capability activation was created. Application code, tests, source/media files,
HPS and the pending biomechanist review were unchanged.

## 2026-08-31 — JM-SCI-OVERNIGHT-01 Scientific-Foundation Governance Readiness

### Added

- Added controlled official-document intake, duplicate-check, and provenance
  registries; acquired one exact public Kodokan PDF into an isolated external
  intake folder and retained its server filename and SHA-256.
- Added 62-row metadata-completeness and remediation audits plus an additive
  source-identity conflict registry.
- Added 132-row citation remediation, provenance-location, and reviewer-role
  queues with stable wording checksums and locked safety states.
- Added a bounded 40-source HPS review-priority queue, nine-domain coverage
  registry, and duplicate-identity audit without copying files or approvals.
- Added consolidated scientific-foundation controls, gaps, dependencies, a
  bilingual roadmap, and overnight execution/validation reports.

### Changed

- Extended the scientific registry schema and project status with additive
  intake, metadata, citation, HPS-boundary, and control-state definitions.

One direct EJU URL returned HTTP 404 and was left access-blocked; nine landing-
page candidates remained not authorized. No scientific, medical, rule,
threshold, production, or capability approval was created. Application code,
tests, existing source/media files, HPS, claim wording, metrics, and pending
human-review decisions remain unchanged.

## 2026-08-31 — JM-S0.6-A P0/P1 Metadata and High-Risk Citation-Locator Readiness

### Added

- Added a two-row additive P0 identity-conflict resolution registry and a
  three-row P1 official-source metadata verification registry.
- Added acquired Kodokan document identity review and official EJU URL
  remediation registries while preserving candidate and historical values.
- Added a 53-row high-risk claim citation-locator registry covering all safety,
  human-scientific-review, biomechanical hypothesis, video-engineering and AI
  limitation claims.
- Added blank bilingual human-review packs for 16 safety claims and 37 other
  high-risk claims.
- Added bounded JM-S0.6-A execution and validation reports.

### Changed

- Extended the scientific registry schema and project status with additive
  P0/P1 verification, document-identity, URL-remediation and citation-locator
  states.

No canonical source or claim row was overwritten. No scientific, safety,
medical, referee, rule, threshold, production, reviewer-decision or capability
approval was created. Application code, tests, HPS, PDFs/media, metrics and the
pending biomechanist review were unchanged; no inference or download ran.

## 2026-08-31 — JM-S0.7-A HPS Wave-1 Bibliographic and Review Readiness

### Added

- Added 40-row additive bibliographic verification and access/readiness
  registries preserving original `HPS-SRC-*` identifiers and HPS values.
- Added a bounded 12-source Wave-1 selection, transferability-question
  register, blank evidence-extraction queue and nine-domain gap update.
- Added a blank bilingual English/Persian qualified-human evidence-review pack
  and bounded execution/validation reports.

### Changed

- Extended the scientific registry schema and project status with additive
  bibliography, access, transferability, extraction and domain-gap boundaries.

No HPS file was modified, copied or OCR-processed. No `JM-SRC-*` ID, evidence
transfer, scientific/medical approval, claim support, prescription, dosage,
threshold/rule eligibility, production eligibility or capability activation
was created. Application code, tests, source/media, claims, metrics and pending
human-review states remain unchanged; no inference, benchmark or model ran.

## 2026-08-31 — JM-S0.7-A2 Wave-1 Quality Correction and Intake Readiness

### Added

- Added a 12-row Wave-1 quality-disposition registry and a three-record Core V2
  registry while preserving the historical selection.
- Added an exact-source lawful-access audit for `HPS-SRC-0254`; no file was
  downloaded because only an alternate-journal accepted manuscript was found.
- Added an eight-source `HPS-SRC-0265`–`0272` intake-readiness registry, a
  bounded four-source replacement-candidate registry, and final V2 human-review
  readiness states.
- Added JM-S0.7-A2 execution and validation reports.

### Changed

- Extended the scientific registry schema and project status with additive
  quality-disposition, exact-source, identity-conflict, formal-intake and
  fail-closed Core V2 boundaries.

No HPS registry, original Wave-1 record, application code, source/media asset,
scientific metric, reviewer record or Git history changed. No evidence approval,
threshold, rule, prescription, safety approval or capability activation was
created; no inference, benchmark, model, pose, video or download ran.

## 2026-08-31 — JM-S0.7-A3 Replacement Formal Intake and Core-V3 Readiness

### Added

- Added four-row exact bibliographic, lawful-access, intake, provenance and
  duplicate-control registries for replacement candidates `HPS-SRC-0265`,
  `0266`, `0270` and `0271`.
- Added exact lawful scientific-library intake for the `0270` institutional
  post-print and `0271` publisher CC BY 4.0 version of record, with immutable
  file hashes and structural validation.
- Added fail-closed identity-conflict containment for `HPS-SRC-0268` without
  changing HPS.
- Added a seven-row Core V3 readiness registry and a blank bilingual
  qualified-human review packet with a maximum-five future core.
- Added bounded JM-S0.7-A3 execution and validation reports.

### Changed

- Extended the scientific registry schema and project status with additive
  formal-intake, provenance, duplicate, identity-conflict and Core V3 readiness
  boundaries.

No application code, tests, database, configuration, models, existing
source/media, HPS file or historical Wave/Core registry changed. No
`JM-SRC-*` ID, scientific/medical approval, claim support, prescription,
threshold/rule eligibility, safety approval, production eligibility or
capability activation was created; no inference, benchmark, OCR, pose, video,
calibration or OpenSim run occurred.

## 2026-08-31 — JM-S0.7-A4 Full-Text Gap and Reviewer Readiness

### Added

- Added exact-source lawful-access dispositions for `HPS-SRC-0254`, `0265`,
  and `0266`, explicitly separating sibling publications from exact targets.
- Added one exact lawful Deakin institutional-repository PDF for `0265`, with
  source URL, version, size, SHA-256, page count, MIME, text-layer, and visible
  identity provenance.
- Added acquired-document validation for the protected `0270` accepted
  manuscript and `0271` publisher version without scientific extraction.
- Added source-specific reviewer requirements, 13 mandatory and 4 optional
  unassigned vacancies, seven assignment-readiness rows, and four separate
  bilingual blank human-review forms.
- Added JM-S0.7-A4 execution and validation reports.

### Changed

- Extended the scientific registry schema and project status with additive
  exact/full-text/sibling disposition and qualified-human assignment-readiness
  boundaries.

No HPS file, existing PDF, historical Wave/Core registry, application code,
test, database, model, source/media asset, claim, metric, threshold, rule,
safety lock, approval, or capability changed. No person was assigned and no
review decision or scientific content was pre-filled. No inference, benchmark,
OCR, pose, video, staging, commit, push, reset, or clean operation occurred.

## 2026-09-01 — JM-S0.7-A5 Core V4 and Reviewer Nomination Readiness

### Added

- Added the exactly-five Core V4 disposition for `HPS-SRC-0252`, `0253`,
  `0265`, `0270`, and `0271`, with additive blocked reserve/access states for
  `0254` and `0266`.
- Added a user-nominated reviewer-candidate roster with identity provenance,
  declared scopes, explicit role boundaries, and fail-closed acceptance,
  qualification, COI, confidentiality, attestation, and assignment states.
- Added a 15-row mandatory source-role nomination matrix with explicit
  qualified-physician vacancies and independently unconfirmed Methods/Evidence
  candidate slots.
- Added a blank bilingual source-specific review form for `HPS-SRC-0265` and a
  bilingual candidate acceptance, qualification, vacancy, attestation, and
  withdrawal pack.
- Added bounded JM-S0.7-A5 execution and validation reports.

### Changed

- Extended the scientific registry schema and project status with additive
  Core V4 and nomination-only governance boundaries.

No formal assignment or human review was completed. No HPS file, existing PDF,
source/media asset, application code, claim, metric, scientific approval,
threshold/rule eligibility, prescription, production state, or capability was
changed. No inference, benchmark, model, pose, video, download, staging,
commit, push, reset, clean, checkout, or stash operation occurred.

## 2026-09-01 — JM-S1.0-A Scientific Transparency UI

### Added

- Added an immutable fail-closed Scientific Transparency presentation model
  and governed Uchi Mata display adapter.
- Added a bilingual Scientific Status card plus Sources, Review, Capability,
  Limitations, Safety, and Exclusions detail presentation.
- Added focused English, Persian/RTL, navigation, candidate-state,
  no-approval, no-enable, fail-closed, narrow-screen, and text-scale tests.
- Added JM-S1.0-A implementation and validation reports.

### Changed

- Integrated the read-only status card into the existing Uchi Mata detail
  layout and extended localization/architecture/development-rule records for
  the presentation boundary.

No scientific, medical, AI, threshold, rule, approval, production, scoring,
diagnostic, prescription, referee, or video-analysis capability was activated.
No HPS file, protected registry, reviewer decision, source/PDF/video/model/media
asset, claim, metric, or scientific method was modified, and no inference or
benchmark was run.

## 2026-09-01 — JM-S1.0-B1 Real-Device Visibility and Wording Correction

### Fixed

- Corrected the Uchi Mata Scientific Status visibility gate to use the
  canonical Flutter technique ID `001`, not the API/transport ID `uchi-mata`.
- Added real production-route regression coverage so direct component tests
  cannot conceal a catalog-ID integration failure.
- Replaced misleading approval/scientific presentation wording in English and
  Persian with governance-precise descriptions of editorial curation,
  engineering validation, and local validation history.
- Replaced raw user-facing `review_required` with localized qualified
  human-review wording.

### Validation

- Focused Flutter validation passed `45/45`; the complete Flutter suite passed
  `202/202`.
- `flutter analyze --no-pub` found no B1 error and retained only three unrelated
  existing unused-element warnings in the media section.
- The bounded Android ARM64 debug build completed successfully. User-provided
  English and Persian/RTL real-device screenshots then verified the corrected
  Uchi Mata card, Sources and Limitations, and no visible overflow; other
  techniques remained intentionally locked.

No scientific approval, medical/AI capability, threshold, rule, production
permission, prescription, diagnosis, inference, benchmark, HPS file, protected
registry, source/PDF/video/model/media asset, claim, metric, or scientific
method was activated or changed.

## 2026-09-01 — JM-S1.1-A Non-Uchi Read-Only Unlock Readiness Audit

### Added

- Added a 66-row non-Uchi readiness artifact covering four existing runtime
  preview records and 62 explicit unresolved roadmap positions without
  inventing canonical technique identities.
- Added a bounded audit report, validation report, and automated structural,
  fail-closed, catalog, scientific-isolation, and English/Persian preview tests.

### Audit result

- Zero techniques are ready to unlock. IDs `002–005` require content,
  localization, media, route, and analysis-boundary remediation; the other 62
  positions are blocked by the missing canonical identity/model registry.
- The audit found no duplicate among the five runtime IDs. It recorded the
  existing ID `003` category/type inconsistency and the absence of declared
  local images for all four preview records.

No technique route or capability was opened. No scientific approval,
threshold, rule, AI, analysis eligibility, score, mastery, prescription,
diagnosis, production permission, HPS/source/PDF/media/model change, inference,
benchmark, pose, or video processing was created or performed.

## 2026-09-02 — JM-S1.1-B Generic Technique Route/Model Foundation

### Added

- Added an exact-ID, duplicate-safe, fail-closed technique-detail route policy.
- Added a separate generic read-only adapter/screen for future explicitly
  eligible non-Uchi records, with strict selected-language empty states.
- Added synthetic route, identity, EN/FA/RTL, missing-content,
  no-science/no-analysis, navigation and defensive-lock tests.
- Added JM-S1.1-B implementation and validation reports.

### Changed

- Kept Uchi Mata `001` on its existing specialized destination and prevented
  direct non-Uchi callers from inheriting that screen or any Analyze entry.
- Added an explicit empty read-only eligibility set and wired catalog
  navigation through the route decision.
- Updated the existing 66-row readiness CSV in place: four records remain
  content-remediation-required and 62 remain blocked by absent canonical
  records/models.
- Documented the durable routing boundary in Architecture, development rules,
  and JM-DEC-031.

### Validation

- Focused Flutter tests: `36/36 PASS`.
- Complete Flutter suite: `217/217 PASS`.
- Static analysis: no new error; three pre-existing Media warnings only.
- Android ARM64 debug APK build: PASS.
- Protected scientific hashes: `20/20 PASS`.

No technique was unlocked. No fabricated content, scientific approval,
threshold/rule eligibility, AI/video-analysis capability, source/PDF/media,
metric, detector, tracker, identity, inference, benchmark, pose, or video work
was created or performed.

## 2026-09-02 — JM-S1.1-B Technique Explanation Content Standard Addendum

### Added

- Added the canonical bilingual 18-section technique-explanation authoring and
  presentation standard.
- Added a gap-only optional `TechniqueExplanationExtension` with exact-language
  fields, named phases, canonical linked IDs, media-rights/provenance and
  accessibility contracts, six statement classifications and separate
  technical/scientific review metadata.
- Added expandable technique content and zoomable accessible visual wrappers.
- Added exact English/Persian labels and conceptual-diagram disclaimer.
- Added schema compatibility, fail-closed optional content, specialized Uchi
  route, non-Uchi isolation, EN/FA/RTL, wording and copyright/provenance tests.

### Changed

- Updated the generic read-only adapter/screen to expose only complete,
  selected-language governed extension fields while retaining all existing
  educational fields and explicit unavailable states.
- Recorded JM-DEC-032 and synchronized product, architecture, development and
  current-status documentation.

### Validation

- Focused tests: `18/18 PASS`.
- Complete Flutter suite: `226/226 PASS`.
- Static analysis: no new issue; three pre-existing Media warnings only.

No production extension or non-Uchi eligibility was enabled. No external
inspiration asset/text, final media, fabricated content, scientific approval,
source approval, rule/threshold, metric, analysis capability, inference or
benchmark was added.

## 2026-09-02 — JM-S1.1-C Canonical Technique Identity Registry

- Added a 67-row provenance-aware canonical identity registry and its
  content-free typed Dart projection.
- Preserved existing IDs `001–005`; retained one explicit taxonomy conflict;
  marked all 62 new mappings pending qualified human confirmation.
- Added fail-closed identity checks ahead of model/eligibility routing and
  kept every non-Uchi route locked.
- Reassessed the existing readiness CSV in place without promoting any row.
- Added structural, registry/route, Persian-state, scientific-isolation,
  explanation-standard and copyright/provenance regression tests.
- No fabricated technique content or Persian name, external asset reuse,
  scientific approval, threshold/rule eligibility, AI/video-analysis
  capability or production activation was created.
- Validation: focused `43/43 PASS`; full Flutter `245/245 PASS`; no new
  analyze issue; Android ARM64 debug build PASS; protected hash sample
  `20/20 PASS`; repository-wide diff check PASS.
