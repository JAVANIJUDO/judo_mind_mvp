# Judo Mind Software Architecture

## Document Information

Project:
Judo Mind Super App

Document:
Software Architecture

Version:
1.7

Status:
Approved Architecture Baseline

Last Updated:
2026-08-13

---

# 1. Project Overview

## Project Name

Judo Mind Super App

## Product Type

Judo Mind is a global digital Judo ecosystem.

It is not limited to a Flutter mobile application.

The complete product ecosystem will include:

- Mobile applications
- Web platforms
- Administration Panel
- Content Management System
- Backend services
- Artificial Intelligence services
- Athlete systems
- Coach systems
- Club systems
- Federation systems
- Educational platforms
- Judo knowledge infrastructure

## Current Implementation Platform

Flutter Mobile Application

## Long-Term Platforms

- Android
- iOS
- Web
- Desktop administration platform
- Federation dashboards
- Club dashboards
- Coach dashboards
- Athlete dashboards

## Goal

Create a professional global Judo ecosystem connecting:

- Athletes
- Coaches
- Clubs
- Federations
- Referees
- Educators
- Fans
- Parents
- Administrators
- Judo organizations

The system must be:

- Scalable
- Secure
- Maintainable
- Multilingual
- Commercially ready
- Enterprise ready
- Investor ready
- Federation ready
- AI ready
- Cloud ready

---

# 2. Final Architecture Vision

Judo Mind is designed as:

A global digital Judo ecosystem powered by Judo knowledge,
sports science, technology, data and artificial intelligence.

The system architecture follows this hierarchy:

Business Vision

↓

Product Architecture

↓

Domain Architecture

↓

Knowledge Architecture

↓

Technical Architecture

↓

Backend and Cloud Infrastructure

↓

Flutter and Web Implementations

---

# 3. Architecture Principles

Judo Mind follows these architectural principles:

- Clean Architecture
- Feature-based development
- Domain-driven organization
- Modular design
- Reusable components
- Separation of concerns
- One Source of Truth
- Documentation-first development
- Security-first development
- Localization-first development
- CMS-first content architecture
- API-first backend preparation
- Scalability-oriented development
- Testable architecture
- Accessibility-aware design
- Enterprise-ready infrastructure
- No unnecessary technical debt

## Main Objectives

- Easy maintenance
- Fast feature development
- Safe refactoring
- Team collaboration
- Independent module development
- Future backend integration
- Future web integration
- Future federation integration
- Clear ownership of data
- Consistent user experience
- Reduced code duplication
- Long-term product scalability

---

# 4. Architectural Layers

Judo Mind consists of several connected architecture layers.

## 4.1 Business Layer

Defines:

- Business model
- Subscription plans
- Federation licensing
- Club licensing
- Advertisements
- Sponsorships
- Premium services
- Marketplace services
- Educational products
- AI services
- Commercial partnerships

## 4.2 Product Layer

Defines:

- Product goals
- User groups
- Product requirements
- Module requirements
- User journeys
- Feature priorities
- Success metrics
- Release roadmap

## 4.3 Domain Layer

Defines major product domains:

- Athlete
- Coach
- Club
- Federation
- Techniques
- Training
- Competition
- Monitoring
- Education
- Artificial Intelligence
- Content
- Administration
- Commerce
- Community

## 4.4 Knowledge Layer

Defines the structured knowledge used throughout the ecosystem.

## 4.5 Application Layer

Contains:

- Use cases
- Business operations
- State coordination
- Validation
- Application services

## 4.6 Data Layer

Contains:

- Repositories
- Data sources
- API clients
- Database access
- Cache access
- Content synchronization
- Media services

## 4.7 Presentation Layer

Contains:

- Screens
- Widgets
- Controllers
- Providers
- View models
- User interactions
- Navigation
- Accessibility behavior

## 4.8 Infrastructure Layer

Contains:

- Backend services
- Cloud infrastructure
- Authentication
- Storage
- Analytics
- Monitoring
- Notifications
- Security
- AI services

---

# 5. Current Flutter Architecture

The current Flutter project uses the following structure:

```text
lib/
├── core/
├── models/
├── screens/
├── widgets/
├── services/
├── routes/
└── main.dart
```
## Core UI Layer

Judo Mind uses a reusable component-based UI architecture.

Location:

lib/core/widgets/

Components:

- JudoCard
- JudoSection
- JudoSectionTitle
- JudoBadge
- JudoButton

Purpose:

Provide consistent visual language across all 18 modules.

## Judo Mind Design System Icon Architecture

Judo Mind uses a centralized icon architecture.

### Registry

Location:

`lib/core/design_system/icons/judo_icons.dart`

Responsibilities:

- Register all temporary and final Judo Mind icons.
- Prevent direct icon selection inside feature screens.
- Provide stable semantic names such as:
  - `JudoIcons.kuzushi`
  - `JudoIcons.balance`
  - `JudoIcons.combination`
  - `JudoIcons.aiCoach`
- Allow future replacement of temporary Material icons without changing feature architecture.

### Standard Widget

Location:

`lib/core/design_system/widgets/judo_icon.dart`

Responsibilities:

- Control icon size.
- Control icon background treatment.
- Apply semantic accessibility labels.
- Provide selected, highlighted and disabled presentation.
- Act as the future rendering layer for SVG icons.

### Feature Rule

Feature screens must not create independent icon styles.

Icons must be accessed through:

1. `JudoIcons`
2. `JudoIcon`
3. Approved JMDS illustration components

Material icons may remain only as temporary registry implementations or generic platform actions.

## Judo Mind Illustration Architecture

Illustrations are rendered through the centralized JMDS layer.

Locations:

- `lib/core/design_system/illustrations/judo_illustration_type.dart`
- `lib/core/design_system/illustrations/judo_illustration.dart`

Feature screens must reference semantic illustration types rather than implement their own drawings.

High-value illustrations are used selectively. Standard dashboard items remain icon-based to prevent excessive visual density.

## Official Product Module Boundary

Judo Mind contains 18 official product modules. JM-DEC-020 adds `AI Training
Plan Intelligence` as Module 18 without changing the ownership of the existing
17 modules.

### Module 18 - AI Training Plan Intelligence

Module 18 accepts a training plan supplied by an athlete or coach and evaluates
it against disclosed context and evidence. Its architecture must remain
separate from the Training Center content experience and the Monitoring data
domain while consuming their approved context through explicit interfaces.

Required context includes:

- Training season or period
- Time remaining to competition
- Athlete context supplied by an authorized user
- Evidence-based strength and conditioning principles
- Physiology, recovery and training-load principles
- Judo-specific performance requirements
- Academic or primary scientific evidence

The analysis contract must distinguish supported elements from questionable,
risky or internally inconsistent elements; explain the reasoning; cite evidence
and provenance; expose uncertainty and limitations; and propose alternatives
only when justified. Recommendations are AI-inferred decision support, not a
medical diagnosis and not proof that one universal training plan is correct.

This decision establishes the architecture and product boundary only. No Module
18 Flutter UI, backend service or automated plan modification is implemented.

---

# 6. AI & Scientific Biomechanics Architecture

## 6.1 Objective

Judo Mind AI must provide scientifically meaningful and practically useful Judo analysis.

Pose-estimation skeletons alone are not considered biomechanical analysis.

The system must evolve from visual pose detection into a complete Judo-specific motion intelligence platform.

Uchi Mata remains the reference technique for development and validation.

---

## 6.2 Biomechanics Architecture

The approved scientific pipeline is:

Video Capture

↓

Camera Calibration and Synchronization

↓

Tori / Uke Detection

↓

Multi-Person 2D Pose Estimation

↓

Identity and Occlusion Intelligence

↓

Multi-View 3D Reconstruction

↓

3D Anatomical Motion Data

↓

OpenSim Musculoskeletal Modeling

↓

Judo-Specific Biomechanical Analysis

↓

Technique Phase Intelligence

↓

Confidence and Scientific Quality Control

↓

Athlete / Coach Report

---

## 6.3 Computer Vision Layer

The Computer Vision layer is responsible for:

- Athlete detection
- Multi-person pose estimation
- Tori / Uke separation
- Joint landmark detection
- Temporal tracking
- Occlusion detection
- Video frame analysis

Current evaluated technologies:

- MediaPipe Pose Landmarker Heavy
- RTMPose-M
- RTMPose PoseTracker
- RTMO-M

### Current Benchmark

All models were evaluated using the same real Judo competition video.

MediaPipe Heavy:

- At least one athlete detected: 99.63%
- Two athletes detected: 31.48%

RTMPose-M:

- At least one athlete detected: 97.04%
- Two athletes detected: 48.33%

RTMPose-M + PoseTracker:

- At least one athlete detected: 96.85%
- Two athletes detected: 46.85%

RTMO-M:

- At least one athlete detected: 40.56%
- Two athletes detected: 8.15%

### Current Baseline Decision

RTMPose-M is the approved current baseline pose-estimation engine.

Pose estimation is an input layer and must not be presented as the complete biomechanics engine.

Generic pose-estimation models will eventually be supplemented by Judo-specific detection, identity and occlusion intelligence.

---

## 6.4 Musculoskeletal Biomechanics Layer

OpenSim 4.6 is the approved primary musculoskeletal modeling engine.

Current development environment:

- Python 3.12
- OpenSim 4.6
- NumPy 2.5.1
- Windows development environment

OpenSim has been installed and successfully initialized inside a dedicated environment:

`ai_engine/.biomech_venv`

The Computer Vision environment remains isolated:

`ai_engine/.venv`

This separation prevents computer-vision dependencies from conflicting with scientific biomechanics dependencies.

### OpenSim Responsibilities

OpenSim will support:

- Musculoskeletal modeling
- Segment orientation
- Joint kinematics
- Joint angles
- Range of motion
- Center-of-mass calculations
- Angular velocity
- Angular acceleration
- Inverse kinematics
- Inverse dynamics when valid external-force data is available
- Joint moments
- Joint powers
- Musculoskeletal simulation

---

## 6.5 Multi-View 3D Architecture

High-quality biomechanical analysis must not rely only on a single uncalibrated 2D video.

The advanced Judo Mind analysis mode will support two or more synchronized cameras or smartphones.

Multi-view processing will include:

- Camera calibration
- Camera synchronization
- 2D landmark detection per camera
- Cross-camera athlete identity matching
- Multi-view triangulation
- 3D anatomical landmark reconstruction
- Temporal filtering
- Quality validation

The resulting 3D motion data will be prepared for OpenSim processing.

---

## 6.6 Judo-Specific Interaction Intelligence

Standard human-motion models are insufficient for Judo because two athletes frequently:

- Touch
- Grip
- Cross limbs
- Rotate together
- Occlude each other
- Enter close body contact
- Change orientation rapidly
- Move through throwing and landing phases

Therefore Judo Mind requires a dedicated interaction layer.

The system must understand:

- Tori
- Uke
- Grip relationship
- Relative stance
- Support base
- Distance
- Kuzushi direction
- Weight transfer
- Tsukuri entry
- Hip position
- Leg position
- Rotation
- Kake
- Throw trajectory
- Counter movement
- Landing

---

## 6.7 Uchi Mata Biomechanical Reference Model

Uchi Mata will be the first complete technique-specific biomechanical model.

The reference system must eventually analyze:

- Initial stance
- Grip configuration
- Kuzushi direction
- Entry angle
- Support-leg position
- Attacking-leg trajectory
- Hip position
- Trunk inclination
- Pelvis rotation
- Knee angles
- Shoulder rotation
- Center-of-mass trajectory
- Tori / Uke relative position
- Tsukuri timing
- Kake timing
- Rotation velocity
- Throw completion
- Landing control

Once scientifically and technically validated, the architecture will be generalized to the remaining 66 official techniques.

---

## 6.8 Analysis Quality Levels

### Standard Video Analysis

Input:

- One training or competition video

Capabilities:

- Technical analysis
- Tactical analysis
- Pose estimation
- Technique recognition
- Phase detection
- Estimated movement metrics

Scientific classification:

Estimated

---

### Advanced Biomechanics

Input:

- Two or more synchronized and calibrated cameras

Capabilities:

- Multi-view 3D reconstruction
- Improved joint kinematics
- Center-of-mass analysis
- Segment orientation
- Tori / Uke interaction
- Technique-specific biomechanics

Scientific classification:

3D Estimated / Model-Based

---

### Research and Validation Mode

Possible inputs:

- Marker-based motion capture
- Force plates
- EMG
- IMU sensors
- Laboratory reference systems

Purpose:

- Validation
- Research collaboration
- Algorithm evaluation
- Accuracy measurement
- Model improvement

---

## 6.9 Scientific Integrity

Judo Mind must distinguish between:

- Measured data
- Reconstructed data
- Model-estimated data
- AI-inferred data

The application must never present estimated values as directly measured physical quantities.

Examples:

Force plate ground reaction force:

Measured

Video-derived ground reaction force:

Estimated

EMG muscle activity:

Measured

OpenSim-derived muscle activation:

Model Estimated

Every professional biomechanical result should eventually include:

- Confidence score
- Data source
- Analysis method
- Quality level
- Relevant limitations

---

## 6.10 Scientific Reference Direction

The Judo Mind biomechanics architecture is informed by established biomechanics workflows including:

- Marker-based motion capture
- Markerless multi-camera motion capture
- OpenCap-style multi-view analysis
- OpenSim musculoskeletal modeling
- Force-plate integration
- EMG integration
- Sports-science validation

OpenCap architecture may be used as an engineering and scientific reference where appropriate.

Judo Mind will not depend on the hosted OpenCap service.

Judo Mind will develop its own Judo-specific multi-person analysis architecture.

---

## 6.11 AI Infrastructure

Local CPU processing is intended for:

- Development
- Benchmarking
- Architecture validation
- Debugging

Production high-accuracy processing will use GPU-backed infrastructure.

AI services must remain separated from the Flutter presentation layer.

Flutter responsibilities:

- Capture
- Upload
- User interaction
- Analysis configuration
- Result visualization

AI backend responsibilities:

- Computer vision
- Pose estimation
- 3D reconstruction
- Biomechanics
- OpenSim processing
- Judo intelligence
- Report generation

---

## 6.12 Scientific Validation Requirement

A biomechanics feature is not considered production-grade only because its code executes successfully.

Validation must include:

- Repeatability testing
- Accuracy testing
- Real Judo footage
- Different camera angles
- Different body sizes
- Different judogi colors
- Left and right stance
- Occlusion
- Competition speed
- Training speed
- Expert Judo review

Where possible, advanced validation should compare Judo Mind results against:

- Laboratory motion capture
- Force plates
- EMG
- Expert technical annotation

Scientific validation is part of the product architecture, not an optional future enhancement.

---

## 6.13 Dual-Level Video Analysis Boundary

JM-DEC-018 makes the analysis level an explicit architectural boundary rather than a presentation label.

### Single-Camera AI Analysis Pipeline

Input:

- One ordinary training or competition video

Pipeline:

1. Ingest and validate media metadata.
2. Estimate 2D pose and confidence.
3. Detect defensible phases, timing and visible movement patterns.
4. Apply Judo-specific technical or tactical inference.
5. Publish only outputs supported by the available view, with confidence and limitations.

Allowed provenance:

- `model-estimated`
- `AI-inferred`
- `measured` only for directly observed media properties such as timestamps or pixel dimensions

Prohibited claims:

- Reconstructed 3D motion
- Directly measured joint kinetics or force
- Precise biomechanics when depth or physical quantities were not scientifically recovered

### Multi-Camera 3D Scientific Analysis Pipeline

Input:

- Two or more synchronized camera streams suitable for cross-camera processing

Required sequence:

1. Media and camera identity validation
2. Intrinsic and extrinsic calibration evidence
3. Fail-closed calibration quality gate
4. Synchronization quality gate
5. Cross-camera Tori/Uke identity and landmark correspondence
6. Geometry and triangulation quality gate
7. Reconstructed 3D motion with confidence and provenance
8. Motion and anatomical suitability gates
9. OpenSim processing when all upstream gates pass
10. Judo-specific biomechanical interpretation and report-quality gate

If any required gate fails, the advanced pipeline stops. It must not silently fall back while retaining a 3D, scientific-biomechanics or OpenSim label. A separately requested Single-Camera AI analysis may still be offered under its own estimated/inferred classification.

### Calibration Quality Profiles

The centralized calibration gate consumes the recorded JSON evidence and requires `status=completed`, an accepted quality label and every required finite, non-negative metric.

Offline 3D validation profile:

- Accepted quality: `usable_for_3d_validation`, `good` or `excellent`
- Minimum valid stereo holds: 8
- Maximum RMS reprojection error: 3.0 px
- Maximum median epipolar error: 2.0 px
- Maximum median absolute sync error: 9.0 ms
- Output is development/validation-only and cannot be exposed as user-facing scientific 3D

Scientific 3D and minimum OpenSim calibration profile:

- Accepted quality: `good` or `excellent`
- Minimum valid stereo holds: 10
- Maximum RMS reprojection error: 2.0 px
- Maximum median epipolar error: 1.25 px
- Maximum median absolute sync error: 8.5 ms

These values preserve the current calibration quality classification. Future threshold changes require scientific validation and a recorded decision.

### Runtime Enforcement

`MultiViewReconstructor` requires a sealed `ValidatedCalibrationContext` created by the centralized gate. Raw projection matrices without approved calibration context are insufficient, and every camera projection must carry the same calibration identity as that context. Each reconstructed point carries `reconstructed` provenance, calibration identity, requested calibration purpose and whether the context permits user-facing scientific 3D.

`quality=review_required`, missing evidence, malformed evidence or any exceeded threshold is rejected by default.

### OpenSim Boundary

An OpenSim-purpose calibration context proves only that the calibration portion of the pipeline passed its minimum profile. It does not prove that the motion is suitable for OpenSim. Cross-camera identity, temporal alignment, reconstruction confidence, marker/anatomical mapping and motion quality require independent approval before musculoskeletal processing.

### Closed 2026-08-07 Calibration Cycle

The current two-phone extrinsic has RMS 48.2750333 px, median epipolar error 55.4328918 px and quality `review_required`. It is blocked from offline 3D validation, user-facing scientific 3D and OpenSim. The current pair is retained as evidence, but its source videos must not be tested again. Stabilization/EIS/OIS virtual-camera change is recorded only as an unconfirmed hypothesis.

---

## 6.14 Three-Level Fight Intelligence 360 Architecture

JM-DEC-019 expands the product-level analysis architecture from the two operational video pipelines in JM-DEC-018 into three explicit scientific levels. It does not weaken or remove the Single-Camera/Multi-Camera boundary or any calibration safeguard.

### Level 1 - Single-Camera AI Analysis

One ordinary video may produce measured media metadata, model-estimated projected 2D kinematics and AI-inferred phases or coaching observations. Spatial results must use `projected` or `image-plane` language. True/reconstructed 3D, true 3D COM, measured force, actual joint moment, torque or power are prohibited.

### Level 2 - Multi-Camera 3D Analysis

The required pipeline is:

`synchronization -> intrinsics -> extrinsics -> orientation -> cross-camera Tori/Uke identity -> correspondence -> triangulation -> 3D reconstruction -> filtering -> confidence/quality gates -> 3D metrics`

Only a run that passes every gate may publish reconstructed 3D landmarks, trajectories, geometric joint angles, relative position, velocity, model-estimated COM or interactive 3D/360 viewing. `review_required` remains rejected. The failed 2026-08-07 dataset is evidence of an invalid capture/calibration cycle, not a reason to remove the Level 2 architecture.

### Level 3 - Professional / Federation / Laboratory Analysis

This level may combine synchronized high-speed cameras, a calibrated capture volume, marker-based or validated markerless capture, optional IMUs, force plates or other external-force instrumentation, EMG where approved, and OpenSim. It supports high-quality 3D kinematics and only supports kinetics/inverse dynamics when valid external-force and model evidence is available.

Level 3 is the reference-validation environment for Levels 1 and 2. Laboratory context alone does not authorize a measured or kinetic claim.

### Metric Registry Boundary

The versioned scientific contract is `docs/UCHI_MATA_SCIENTIFIC_METRICS_V1.md`. Every metric must declare its ID, role, phase/event schema, method, unit, minimum input, valid level, provenance, confidence evidence, source and prohibited interpretation. No threshold or normative target may be introduced without supporting evidence, validation and a recorded decision.

### Interactive 3D / 360

Interactive viewing is a virtual camera over a validated reconstructed scene. It provides Front, Side, Rear, Top and Free 360 views and must be described as `3D reconstruction + 360 viewing`, not 360-camera capture. Athlete-versus-reference comparison may show compatible angle, time and position differences but must not treat a single champion, trial or incompatible phase schema as a universal ideal.

### Result Presentation

Fight Intelligence results coordinate AI Sensi, annotated video, voice coaching, a scientific report and, when Level 2/3 evidence permits, interactive 3D/360. Blue represents movement/position/joint geometry; Gold represents grip/Hikite/Tsurite/upper-body control; Green represents balance/COM/mechanical direction. At Level 1, Green directional arrows are AI-inferred conceptual coaching cues, never measured force vectors.

---

## 6.15 Video Analysis Mode Architecture

JM-DEC-021 defines three analysis modes around user intent and temporal scope.
They are orthogonal to the scientific Levels in section 6.14: an analysis mode
does not promote provenance or bypass the Single-Camera/Multi-Camera gates.

### Mode 1 - Single Attempt Technique Analysis

Purpose:

Deep analysis of one primary execution of a selected technique such as Uchi
Mata.

Input boundary:

- Useful context immediately before the attempt
- One primary technique attempt
- Useful context immediately after completion or landing

One analysis window equals one primary attempt. No universal duration threshold
is approved. If a video contains multiple attempts and automatic event
segmentation is not validated, the user or reviewer must select or trim one
attempt. Unsegmented executions must not be averaged or presented as one
technical result.

Future result composition:

- Annotated Video
- AI Sensi
- Voice Coaching
- Scientific Report
- Interactive 3D/360 only when Level 2/3 scientific gates permit it

### Mode 2 - Drill / Repeated Attempts Analysis

Purpose:

Analyze repeated practice of the same technique without losing the identity of
each repetition.

Pipeline:

`drill video -> attempt/event segmentation -> per-attempt analysis -> reviewed comparison -> permitted aggregate statistics`

Each repetition becomes Attempt 1, Attempt 2, Attempt 3 and so on. The system
may compare validated metrics for consistency, variability, progression,
degradation and repeatability only after reliable segmentation and independent
per-attempt analysis. It must never blend several repetitions into one
execution. Fatigue-related interpretation requires separately validated
evidence and must not be inferred merely from change across attempts.

### Mode 3 - Full Match Analysis

Purpose:

Analyze a complete competition or match independently from Technique Analysis.

Pipeline:

`full match -> temporal event detection -> attack/event segmentation -> technique candidate/classification -> individual attempt analysis -> outcome -> next event -> match-level tactical aggregation`

Output layers remain separate:

1. Event timeline
2. Individual attack cards
3. Per-attempt analysis
4. Match tactical summary
5. AI Sensi competition review

All attacks must not be blended into one biomechanics report. Match-level
tactical metrics and individual technique-analysis results are different data
products with independent methods, confidence and limitations.

### Pose Benchmark Boundary

The Pose Engine Benchmark is engineering/evaluation infrastructure. Its purpose
is person detection coverage, two-person coverage, engine reliability and
processing performance. A benchmark video may contain several movements or
repetitions, but benchmark observations are not athlete Technique Analysis and
do not authorize combined execution findings.

The timestamp-based 10 FPS target belongs to the benchmark infrastructure only.
Future scientific metric extraction must preserve source timestamps and use an
appropriately validated temporal resolution. Depending on the metric and event,
this may require native 25, 30, 50 or 60 FPS. No universal biomechanics FPS is
approved without validation.

### Scientific and Product Gates

Every mode preserves `measured`, `reconstructed`, `model-estimated` and
`AI-inferred` provenance. Validated identity is required before Tori/Uke claims,
and validated event/phase segmentation is required before automatic
Kuzushi/Tsukuri/Kake judgments. Ordinary video cannot produce measured force;
single-camera input cannot produce true 3D or actual torque, moment or power.

The future Analyze experience presents the modes in judoka/coach language:

- Technique Analysis -> One Attempt
- Training / Drill Analysis -> Multiple Repetitions
- Competition Analysis -> Full Match

The coordinated result architecture remains AI Sensi + Annotated Video + Voice
Coaching + Scientific Report + Interactive 3D/360 when scientifically
available.

---

## 6.16 Single-Attempt Uchi Mata V2A Implementation

JM-DEC-022 implements the first bounded Level 1 Single Attempt result without
promoting the unvalidated automatic identity or phase layers.

### Contract Flow

`selected video/camera -> manual reviewed attempt/role/support leg/attacking leg/frame/view -> reviewed-video V2A endpoint -> selected role-neutral 2D pose observation -> versioned metric math -> response/request binding -> Flutter result card and BLUE layer`

The V1 video upload and pose-coverage diagnostic remains independent and
unchanged. V2A is additive. A pure internal Python function evaluates an
already prepared reviewed observation contract but is deliberately not exposed
through OpenAPI because client-supplied landmarks could spoof model provenance.
The public multipart video endpoint verifies the
reviewed start/end/angle frame timestamps against the source timebase, runs
pose inference only on the human-selected source frame and then applies the
same metric contract. It stops decoding after that selected frame and does not
use the benchmark 10 FPS plan. Flutter now connects the existing Uchi Mata
Analyze video/camera state to the typed reviewed-request service through a
bounded reviewer/development panel. The panel is explicitly manual: it does
not claim automatic frame, identity, role, leg or event selection. The V1
pose-summary action remains independent and unchanged.
Source image width/height is mandatory for the pose observation. Normalized
landmarks are converted to image-pixel coordinates for angle math, preventing
frame aspect ratio from distorting projected geometry; overlay coordinates
remain normalized for Flutter rendering.

### Manual Gates

- Attempt start/end use source frame indices and timestamps and a declared
  event-pair schema.
- A reviewer maps a neutral `Track A/B/...` observation to Tori. Detection order
  alone is never identity.
- A reviewer confirms left/right support leg.
- A reviewer independently confirms left/right attacking leg; it is not
  inferred as the complement of the support leg.
- A reviewer selects the angle evaluation frame/event label.
- Projected angles become `reportable` only after near-planar view suitability
  and low camera roll are reviewed. Otherwise usable geometry is
  `review_required`.

### Metric Layer

- `UM-TIM-001`: measured video timebase plus separately retained human boundary
  source; method `reviewed-event-elapsed-time-1.0.0`.
- `UM-ANG-001`: shoulder/hip midpoint axis projected against image vertical;
  source-image pixel geometry; method
  `projected-trunk-inclination-1.0.0`; `model-estimated`.
- `UM-ANG-002`: human-confirmed support-side hip-knee-ankle image-plane angle;
  source-image pixel geometry; method `projected-knee-angle-1.0.0`;
  `model-estimated`.
- `UM-ANG-003`: independently human-confirmed attacking-side hip-knee-ankle
  image-plane angle; source-image pixel geometry; method
  `projected-knee-angle-1.0.0`; `model-estimated`.

Missing landmarks, non-finite coordinates and degenerate geometry fail closed
to `withheld`. A withheld metric contains no value, descriptive finding or
overlay. Model landmark visibility is retained only under its own semantic
label and is not presented as pose accuracy.

The serialized BLUE layer is fail-closed: every coordinate must be finite and
inside normalized image space `[0, 1]`, labels must be non-blank, and each
metric accepts only its exact versioned primitive order and point count. The
Flutter service also binds a validated response back to every reviewed request
gate before presentation, so an internally consistent but stale or crossed
response cannot be rendered for another reviewed attempt.

### Observation and Identity Boundary

Timestamped pose observations remain frame-local and `model-estimated`.
Track association is a separate `AI-inferred` layer with explicit
`associated`, `review_required` and `withheld` states plus crossing, occlusion,
disappearance/reappearance and detection-order-change events. Tori/Uke role
confirmation remains a separate human gate.

### Result Presentation

Flutter validates exactly `UM-TIM-001`, `UM-ANG-001`, `UM-ANG-002` and
`UM-ANG-003` and rejects promoted provenance, automatic identity/phase
capability, 3D, kinetics, interaction metrics or normative coaching. The BLUE
layer contains only the contract-approved trunk/support-leg/attacking-leg
projected geometry and angle labels. The manual panel requires every existing
review field before submission, and the typed service rejects a response that
does not match the initiating video and reviewed selections. This is a bounded
reviewer/development orchestration path, not automatic analysis and not a
production identity or event-selection UX.

### Human Ground Truth

The existing deterministic 100-timestamp fast-screening subset can be decoded
to review frames without pose inference. Human labels and model detection
counts remain separate. The evaluator computes conditional coverage such as
`P(two detected | at least two judoka actually visible)` only after complete
human labels exist. Empty templates are not ground truth.

Annotation schema `1.1.0` binds the draft and completed set to both the source
video SHA-256 and screening-artifact SHA-256. It preserves the selection method,
requires every reviewed frame/boundary to match the source timebase, prevents
preparation from overwriting an existing draft and provides a read-only
multi-issue readiness report without filling null labels. Artifact evaluation
fails closed unless video identity/metadata, both hashes and the exact shared
frame/timestamp subset align. Sample positions and canonical review-image paths
are preserved into the completed set; each path must encode the matching sample,
source frame and source timestamp so swapped review rows fail validation.
An optional dependency-free CSV round trip exposes only per-frame human-label
entry while treating sample/frame/time/image cells as immutable evidence. It
writes a new validated draft, refuses overwrite and preserves blank values as
incomplete rather than negative labels.
Integer evidence fields at this boundary are strict: booleans and floating-point
values cannot be coerced into frame indices, timestamps or person counts.
Path-based readiness schema `1.1.0` additionally requires every review JPEG to
exist, decode successfully and match source-video dimensions before reporting
that a completed draft can be finalized. Conditional artifact evaluation calls
this same path gate before finalization, so an in-memory model cannot bypass
review-asset readiness.
The readiness report validates its own count, status, finalization and asset
partition invariants when serialized or reloaded; a tampered readiness flag is
not trusted.

Detection evaluation schema `1.2.0` retains the overall conditional rates and
the broad occlusion/crossing slices, and adds four mutually exclusive strata:
occlusion only, crossing only, both, and neither. Additive counts in those four
strata must exactly partition the all-frame metrics. It explicitly declares
that coverage is not confidence, pose accuracy or athlete identity evaluation.

Neutral Track A/B evaluation remains timestamped and role-free. Its reference
contract rejects non-finite geometry/confidence, unknown events and conflicting
frame timebases, and reports one-to-one collisions where two human subjects are
assigned the same track or frame-local detection. Switch/collision results are
evaluation diagnostics only and do not authorize automatic Tori/Uke identity.
Evaluation rows and reports explicitly separate `human-reviewed` references
from `AI-inferred` predicted track associations.


## JM-DEC-023 ? Event-Scoped Technique Role Architecture

Video Analysis uses attempt-stable neutral subject identity and event-scoped
technique roles.

Subjects remain role-neutral (`subject-1`, `subject-2`, or validated neutral
tracks). Technique semantics belong to events.

This allows one attempt to represent:

- a single attack,
- repeated/follow-up attacks,
- combinations,
- attack followed by counter-attack,
- different technique actors within the same attempt.

The canonical relationship is:

`event -> actor subject -> target subject -> technique/event role`

rather than:

`subject -> permanent Tori/Uke role`.

Belt color, judogi color, screen side and detection order are not identity
rules.

Automatic event-role inference remains unavailable until separately validated.



## JM-DEC-024 ? Close-Contact Detection Architecture

The current single-camera chain retains RTMPose-M as the pose baseline.

The first optimization target is the upstream person detector/proposal layer
for two-judoka close-contact scenes.

Architecture remains:

`person proposals -> RTMPose-M pose estimation -> validated neutral subjects`

Close-contact detector improvement must not silently alter scientific
provenance or upgrade pose, identity or biomechanics claims.



## Multi-Person Evidence Capability Gate

Single Attempt Video Analysis now explicitly separates:

- single-subject evidence that may remain usable, and
- interaction evidence that requires reliable detection of both judoka.

Multi-person evidence status is represented in the existing V2A capability
contract rather than in a parallel analysis system.

Insufficient multi-person evidence must not silently promote interaction,
opponent-relative, Tori/Uke-relative, grip, distance, counter-attack, or other
two-subject metrics to reportable status.



## Single Attempt V2A Response Multi-Person Gate

The real Single Attempt V2A response now exposes multi-person evidence
sufficiency through the existing capability contract.

This allows clients to distinguish:

- currently available single-subject analysis, from
- two-subject interaction analysis that must remain unavailable or
  review-gated when multi-person evidence is insufficient.

The gate is part of the existing V2A response architecture and does not create
a parallel analysis pipeline.



## Boundary-Normalized Landmark Reporting Gate

Single Attempt V2A now carries explicit provenance when model-estimated
landmarks require clipping to the normalized image boundary.

A projected metric that depends on any boundary-normalized landmark cannot
automatically reach `reportable` status.

The metric may remain available as `review_required` when its geometry and
confidence otherwise exist.

This gate is metric-specific: an affected landmark must not downgrade an
unrelated metric whose required landmarks were not boundary-normalized.



## UM-ANG-003 ? Attacking-Leg Knee Angle

Single Attempt V2A now supports a fourth Level 1 metric:

`UM-ANG-003 ? Projected attacking-leg knee angle`

Architecture:

`human-confirmed attacking leg`
`-> Tori pose observation`
`-> attacking-side hip/knee/ankle`
`-> image-plane knee-angle method`
`-> metric-specific reporting gates`

The attacking leg must not be inferred from support-leg complement, belt color,
judogi color, detection order or screen position.

When attacking-leg classification is unavailable, the metric fails closed as
`withheld`.

The value remains a projected 2D angle and must not be interpreted as a true
3D anatomical knee angle, load, moment or injury-risk measure.



## JM-DEC-025 - Neutral Identity Evaluation and Production Gate

The experimental RTMLib greedy-IoU tracker remains outside the production V2A
pipeline. Its bounded evaluation architecture is:

`stored role-neutral geometry`
`-> chronological human subject mapping`
`-> experimental neutral tracker`
`-> AnnotatedTrackAssignment conversion`
`-> evaluate_tracking_assignments()`
`-> reviewed production disposition`

Human reference identity is attempt-local and limited to `subject-1`,
`subject-2` and `unassigned`. Tori/Uke remains a separate human-confirmed
event-role gate. Detection index, screen position, belt/judogi appearance and
track index are not identity algorithms. Appearance may be used only by the
human reviewer as recording-specific continuity context.

The evaluation denominator is the set of human-visible subject-frame rows, not
the set of successful detections. `unassigned` detections are excluded from
subject scoring, and `review_required` tracker decisions remain unassigned.
Association confidence stays unavailable unless a separately validated method
produces it.

Run 01 used 31 deterministic frames from 41,000-44,000 ms at a 10 FPS
engineering evaluation setting. Human review produced 34 detection mappings
and 62 visible subject-frame references. The native RTMLib 0.0.16 run assigned
4/62 observations (`6.45%`), produced one identity switch during crossing, and
changed identity on the one scored reappearance. Confidence coverage was 0%.
Both collision counts were zero, but this is not success evidence at the low
assignment coverage.

The current greedy-IoU implementation is therefore not production-approved and
must not be integrated into V2A. RTMPose-M remains the pose baseline, the
close-contact second-person detector/proposal bottleneck remains governed by
JM-DEC-024, and multi-person interaction metrics remain non-reportable.


## Uchi Mata Technique-Detail Action Availability Boundary

The reference navigation remains:

`Home -> Techniques -> Uchi Mata -> Technique Detail`
`-> Dashboard / Primary Actions -> Section Bottom Sheet / Analyze`

`TechniqueSectionRouter` is the single availability boundary for technique
sections. `TechniqueDetailScreen` supplies that decision to both the dashboard
and primary-action presentation so a section cannot appear complete in one
surface while remaining a placeholder in another.

For the current Uchi Mata data, Training, Mastery/Progress and Sensi Bot are
explicitly unavailable. Champions is unavailable while no verified champion
reference exists. These controls display an unavailable state and route only
to localized feedback; they do not open placeholder bottom sheets.

Media cards remain routed through the existing media factory. Cards without an
approved `mediaUrl` expose a localized unavailable state and do not enter
`VideoDetailScreen`. Competition search-result URLs are rejected as non-direct
media. The official image, existing content sections, Quiz, Favorite and both
reviewed Analyze paths retain their existing destinations.

This boundary is presentation/navigation architecture only. It does not alter
the V1 or four-metric V2A analysis services, JM-DEC-024, JM-DEC-025, tracker
status, detector settings or scientific result contracts.


## Uchi Mata Approved Content Resolution Boundary

Technique-detail educational content follows one reusable rendering path:

`TechniqueModel canonical fields`
`-> optional approved locale field`
`-> field-level fallback`
`-> ResolvedTechniqueContent`
`-> shared text/list/notice widgets`
`-> section bottom sheet`

The resolver filters blank list entries and returns immutable lists. English
uses the canonical Uchi Mata dataset; another locale uses its approved field
when present and otherwise preserves the canonical value. UI widgets own
localized labels and explicit unavailable notices, but do not own technical
Judo prose.

Overview renders identity metadata, description, technical analysis and key
points. Technical Analysis renders the first three execution steps once as
Kuzushi/Tsukuri/Kake, then renders remaining steps, key points, mistakes and
safety guidance once each. Combinations and Mistakes & Safety use the same
resolved content components.

Tactical remains incomplete because no dedicated tactical scenario source is
present; it exposes only the approved key-point list and an explicit boundary.
Competition remains incomplete because no dedicated competition analysis or
direct approved video is present; it exposes approved combinations/counters
and rejects the legacy search-result URL. Sources accept only concrete titled
HTTP(S) entries and currently render the IJF, Kodokan and EJU roots.

The visual biomechanics destination remains an educational visualization
prototype with an explicit limitation. It is not measured or reconstructed
3D, real force/torque/power/center-of-mass output, or scientific completion.
The content boundary does not change Media acquisition, Training, Shadow
Training, Conditioning, Progress/Mastery, Champions, Sensi Bot, V1/V2A,
tracker/detector research or scientific contracts.


## Uchi Mata Reusable Technique Template Proof

Technique Detail educational rendering now follows this reusable boundary:

`supplied TechniqueModel`
`-> field-level locale resolution`
`-> variable-length shared content widgets`
`-> explicit empty/unavailable state`

Identity and classification use the model metadata. Overview and Technical
Analysis use resolved description, analysis, steps, key points, mistakes and
safety fields. Combinations, counters, Quiz and approved concrete Sources use
their structured collections; displayed Quiz counts come from the collection
length rather than the Uchi Mata reference count.

The Uchi Mata Analyze entry remains unchanged. Analyze availability is the
explicit `supportsReviewedSingleAttemptV2A` model capability, defaults to
`false`, and is enabled for the approved Uchi Mata reference only. Generic
non-Uchi read-only detail exposes no analysis entry (JM-DEC-031). Name, route,
and ID comparisons do not determine analysis availability.

Reuse was proven with a neutral test-only `TechniqueModel` fixture containing
distinct sentinel values, variable list lengths, two Quiz questions and empty
variants. The fixture has no production registration or route and introduces
no Judo fact or second completed technique.

Existing Uchi-specific visual-learning, Shadow Training and Conditioning
prototypes remain outside this proof and are not generalized or completed.
Dedicated tactical/competition content and sources also remain separate known
gaps. No V1/V2A contract, metric, provenance, identity, detector or tracker
architecture changed.


## JM-DEC-026 - Local Reviewed V2A Attempt-Summary Persistence

The local foundation follows this bounded path:

`strict V2A scientific result`
`-> explicit user save action`
`-> immutable local record schema 1.0.0`
`-> fail-closed repository`
`-> dedicated SharedPreferences key`

The saved record retains the response/analysis identifier, V2A schema and
mode, reviewed attempt/event/neutral-track/limb/camera binding, the original
four metric identities and their value, unit, status, provenance, method,
confidence and limitations, the insufficient multi-person evidence boundary,
non-reportable interaction state and `savedAtUtc`.

The persistence schema deliberately has no video ID, path, filename, video
bytes, image, BLUE overlay geometry, frame-local detection index, aggregate
score, mastery, trend or Profile data. `review_required` and `withheld` remain
unchanged. Corrupt or unsupported payloads are not loaded or overwritten;
duplicate analysis IDs are not written twice.

`LocalAttemptHistoryProvider` exposes explicit `saved`, `alreadySaved` and
`failure` states to the existing reviewed V2A panel. This is not a History,
Profile or Progress screen and makes no backend, account, authentication,
cloud-sync or backup claim. V1, V2A metric formulas, BLUE result rendering,
JM-DEC-024 and JM-DEC-025 remain unchanged.

## Local Athlete Profile and Scientific History Presentation — 2026-08-12

The local Profile slice follows:

`SharedPreferences storage → strict repository → ChangeNotifier provider → UI`

`LocalAthleteProfile` is a separate `1.0.0` schema with optional
`self-reported`, `local-device` fields. Its key is separate from general
preferences and V2A History. Parsing rejects unknown schema/provenance/scope,
unexpected fields, invalid types and oversized input; a corrupt payload blocks
write-back.

`LocalAttemptHistoryProvider` is app-scoped so reviewed V2A explicit-save and
Profile read one repository state. Profile preserves reportable,
`review_required` and withheld states, provenance, unavailable confidence,
limitations and withheld reasons.

Athlete Profile remains independent of Training Center. Progress/Mastery,
verified identity, ranking, achievements, performance scoring, comparisons,
backend authentication and cloud sync are not implemented. This implements
`JM-DEC-026`; no new decision is required.

## Platform Framework Alignment — JM-DEC-027

Approved product intent is governed by
`docs/JUDO_MIND_PRODUCT_FRAMEWORK.md`. This architecture document governs the
technical realization of that intent; it does not duplicate runtime
availability or validated project status. `JudoMindModules.modules` remains the
runtime authority for module identity and availability.

### Product Position

Judo Mind is a trusted multilingual Judo Intelligence Platform connecting
structured technique education, scientifically governed video analysis,
athlete development history, AI-guided explanation and
coach/federation workflows. This is positioning, not a market-leadership or
production-readiness claim.

### Coordinated Surfaces and Athlete Journeys

The platform has four coordinated surfaces: Athlete App, Coach Workspace,
Club/Federation Console and Judo Intelligence Core. The canonical modules may
span more than one surface. They are not an instruction to render 18 equal
Athlete Home tiles. The future Athlete Home information architecture
prioritizes Learn, Train, Analyze, Track Progress and Connect with Coach. This
framework does not redesign Home.

Technique Analysis — One Attempt, Training/Drill Analysis — Multiple
Repetitions and Competition Analysis — Full Match are shared analysis
capabilities governed by JM-DEC-021. They are not top-level modules.

### Canonical Registry Boundary

`JudoMindModules.modules` is the authoritative registry. Each row includes a
stable ID, canonical name, localization key, owning surfaces, route reference,
availability, readiness and unavailable reason. The exact registry is:

1. Home
2. Techniques — 67 Techniques
3. Sensi Bot
4. Sensi Bet
5. Monitoring / Progress & Mastery
6. AudioCast
7. Athlete Profile
8. Training Center
9. Champions Hub
10. Competitions & Challenges
11. News
12. Store & Subscriptions
13. Club Administration
14. Coach Forum
15. Online Courses
16. Country Judo History
17. App Management & Settings
18. Training Program Validator

The registry currently has four real destinations: Home, Techniques, the
local/demo Athlete Profile and Settings foundation. Only Techniques and Athlete
Profile are module tiles on the current Athlete Home. The other 14 modules are
unavailable/deferred with null routes; registration does not activate them.

The prior `JudoMindModules.modules` list had 16 cards because it combined 14
official identities with two non-official standalone tiles (`Medical Support`
and `Nutrition`) while omitting Home, Sensi Bet, Settings and Module 18. The
historical 17-module architecture remains recorded in JM-DEC-002; JM-DEC-020
added Module 18, and JM-DEC-027 aligns its canonical name/boundary as Training
Program Validator without adding a nineteenth module.

### Localization Architecture Contract

The existing ARB/generated localization and runtime locale switching remain
the single localization architecture. Completed Persian/English surfaces must
be complete in the selected language. Japanese technique names may remain
Japanese beside selected-language explanation. RTL also governs layout,
navigation direction, directional icons, charts and interaction order.

Existing English fallback may identify incomplete development content, but it
cannot serve as evidence of completed Persian content. Missing translations
remain explicitly incomplete/unavailable.

### Uchi Mata Gold Reference Target

Gold scope includes the approved technical dataset and phases, distinct visual
learning, licensed media, technique-specific biomechanics, technique-specific
Shadow/Strength & Conditioning/Resistance-Band training, visual/video Quiz,
V1 and reviewed V2A, grounded AI Sensei, local History/Progress and complete
English/Persian experiences. Each educational destination needs a distinct
primary visual artifact; one generic stick-figure animation under several
labels is insufficient. This is a target definition, not implementation status.

### Reusable Training Data Boundary

`TechniqueModel.trainingContent` is a backward-compatible empty-by-default
contract for Shadow Training, Strength & Conditioning and Resistance-Band
drills. Approval and complete evidence are separate from object existence.
Selected-language content, structured steps, prescription, athlete level,
media, safety and source/provenance must all exist before resolution. No Uchi
Mata drill is authored by this foundation.

The validated experience layer now resolves these contracts through three
distinct reusable renderers:

- Shadow: phase/movement-path and presentation capabilities;
- Strength & Conditioning: movement-pattern and prescription evidence;
- Resistance-Band: anchor/direction, grip/path, leg-role and safety evidence.

`TechniqueSectionRouter` derives each destination's availability from an
approved drill resolved for the selected language. The older Uchi-specific
visual-learning prototypes do not activate these destinations. Production
Uchi Mata training data remains empty, so all three destinations fail closed.
Test-only fixtures demonstrate layout and are not imported by production data.
The approval schema is maintained at
`docs/content_authoring/UCHI_MATA_TRAINING_CONTENT_APPROVAL_TEMPLATE.md`.

### Icon Governance Boundary

The reproducible icon evidence is documented in
`docs/JUDO_MIND_ICON_SYSTEM_AUDIT.md`: 51 semantic `JudoIcons` IDs across seven
subsets, all backed by temporary Material icons; zero custom semantic SVG icons;
ten legacy PNG mappings whose assets are missing; and no recoverable exact
approximately-120 taxonomy. Future assets follow a reviewed manifest/lifecycle.

The machine-readable lifecycle source is now
`design/icon_system/judo_icon_manifest.v1.json`. It mirrors exactly the 51
runtime IDs but does not replace `JudoIcons`, whose Material mappings remain
the runtime authority. Candidate Batch 01 is stored under
`design/icon_candidates/batch_01/`, outside `pubspec.yaml` runtime assets. Its
12 editable SVGs and contact sheet are review artifacts only; production custom
count remains zero. `docs/JUDO_MIND_ICON_DESIGN_SPEC_V1.md` governs candidate
geometry and approval gates.

### Priority and Release Boundaries

- Uchi Mata Gold remains current priority; the next template proof is one
  neutral technique, not bulk expansion to 67.
- Athlete Profile, Training Center, Monitoring/Progress and grounded AI Sensei
  form the next core athlete loop; Coach/Club and Training Program Validator
  follow.
- Approved/licensed media is an explicit dependency.
- Sensi Bet is isolated/deferred for legal/age/ethical/federation review.
- Automatic identity research remains frozen, detector threshold tuning stays
  closed and no new scientific claim is authorized here.
- A debug APK proves execution only. Release requires security, privacy,
  roles/auth, consent, localization, accessibility, performance and
  distribution validation.

### Technique Learning Journey Composition

`TechniqueDashboardGrid` composes technique-detail capabilities into five
athlete journeys: Learn, Train, Analyze, Track Progress and Connect with Coach.
The grouping is a presentation/navigation layer over existing destinations; it
does not create new official modules or activate unavailable capabilities.

`TechniqueSectionRouter` remains the capability gate. Real destinations open
their existing implementation, while missing coach and approved training
evidence fail closed with localized feedback. Track Progress delegates to the
existing local analysis History route rather than a duplicate history store.

Reusable educational renderers are intentionally distinct:

- Technical Analysis presents selectable structured technique phases without
  importing the biomechanics painter;
- Biomechanics owns the educational pose/geometry painter and its explicit
  non-measurement limitations;
- Mistakes & Safety renders approved mistake and safety records separately;
- Combinations & Counters renders only explicit structured outgoing branches.

All renderers are technique-model driven. Uchi Mata strings, inferred
transitions, fabricated corrections and unavailable training/coach behavior do
not belong in reusable widgets. This composition leaves V1/V2A contracts,
scientific metrics, detector/tracker behavior and provenance unchanged.

### Deterministic Grounded Sensei V1

Grounded Sensei V1 is a Flutter-local explanatory projection over an already
validated human-reviewed V2A result:

- `GroundedSenseiRequest` binds `TechniqueModel`, the exact
  `SingleAttemptV2ARequest`, exact `SingleAttemptAnalysisV2A` and selected
  locale;
- `GroundedSenseiService` defines the typed boundary;
- `LocalGroundedSenseiService` validates the exact four-metric set and all
  reviewed/scientific gates, then preserves source semantics in a versioned
  `GroundedSenseiExplanation`;
- `GroundedSenseiExplanationCard` resolves bounded English/Persian explanatory
  copy and selected-language approved safety through the existing localization
  system.

There is no network/client dependency, free-form prompt, model inference or
new metric calculation. The service treats runtime Technique identity (`001`)
and the versioned scientific-contract identity (`uchi-mata`) as separate
namespaces connected only by the explicit reviewed-V2A capability gate.

The V2A result and BLUE overlay render first and remain usable if Sensei
binding fails. History still stores only the original versioned V2A summary;
the explanation is deterministic and can be regenerated from the same bound
inputs. Missing drill mapping produces an unavailable next action.

### Athlete Home Platform Shell V1

`AthleteHomeCapabilities` is the Home navigation contract for the five
approved athlete journeys. Learn delegates to the canonical Techniques route;
Analyze delegates directly to the existing human-reviewed Uchi Mata
Single-Attempt V1/V2A section; Track Progress delegates to a dedicated route
that renders the existing local/demo versioned History independently from the
Athlete Profile editor. Both Profile and History reuse their existing app-
scoped providers; no second History store or progress score exists. Train and
Connect with Coach have no destination and therefore cannot accidentally
become actionable.

The root `HomeScreen` suppresses the synthetic Back control created by the
initial named-route stack. Nested callers may explicitly request normal Back
behavior. Home language, Settings and Profile actions remain distinct and use
the existing registered routes.

The Hero is distinct from Learn: initialized local History makes `View latest
analysis` available; otherwise the Hero opens the product-owned
`TechniqueFactory.featuredReferenceTechnique`. This keeps Uchi Mata identity
outside the Home widget and creates no fake recent state.

The Home capability directory reads the canonical 18-module registry. It can
filter by the registry's four platform surfaces without duplicating identities.
Real route destinations are presented first. Closed entries remain visible in
one collapsed unavailable/deferred group with a shared explanation and only
module-specific exceptions such as Sensi Bet's reviewed deferral reason. Home
is marked current and has no navigation callback; other cards are interactive
only when the registry supplies a real approved route.

Optional Continue entries are derived only from initialized local recent-
technique and saved-analysis providers. If corresponding local records are
absent, the section is absent; no recent activity, score or progress state is
fabricated. This shell does not change technique science, V1/V2A, Grounded
Sensei, BLUE geometry, detector/tracker behavior or the icon approval
lifecycle.

### App Management & Settings Local MVP

`LanguageProvider` remains the application locale source and now delegates its
English/Persian preference to `UserPreferencesStorage`. Initialization restores
the stored supported locale before normal presentation; a change updates the
provider immediately and persists through the same local boundary.

`SettingsScreen` consumes the existing app-scoped
`LocalAttemptHistoryProvider` rather than opening a second store. The provider
delegates a confirmed clear to `LocalAttemptHistoryRepository.clear()`, whose
fail-closed read-before-write boundary refuses to replace corrupt or unsupported
History. The operation writes only the versioned History envelope and cannot
touch the independent Athlete Profile or language keys.

`CurrentScientificCapabilities` is a small presentation-facing capability
contract backed by the approved V2A metric contract. Settings uses it to expose
the current single-attempt, review-required, multi-person and interaction
boundaries without copying formulas or deriving new scientific state. The
screen contains no account, cloud, subscription, notification, theme or AI
preference implementation.

### Scientific Progress Evidence Foundation

`ProgressEvidenceSummary` is a typed, deterministic projection over the
existing `LocalAttemptHistoryRecord` list. It first verifies the exact V2A
metric identities and method-version context, then requires every record to
retain `hasExpectedBoundary`. Unknown/malformed evidence and cross-record
version incompatibility return explicit fail-closed states with zero partial
counts.

For compatible evidence the contract sorts by UTC save timestamp and derives
only attempt count, completed-record count, latest timestamp, separate metric
status counts, technique IDs and metric method versions. It does not compare
values or expose mastery, performance, ranking, readiness, trend or coaching
fields.

`ProgressOverviewScreen` consumes the existing app-scoped History provider and
renders evidence cards, status-distribution bars, version context, scientific
boundaries and a chronological saved-evidence timeline. It links to the raw
Local Analysis History route but is distinct from both History and Athlete
Profile. Home Track Progress remains bound to Local Analysis History.

The canonical Monitoring / Progress & Mastery registry entry routes to
`/progress-overview` with `foundationOnly` readiness. This activates only the
Progress evidence foundation; Mastery is explicitly unavailable and no second
store, score or scientific method is introduced.

### Technique Journey Ownership and Navigation

`TechniqueDetailScreen` presents a single technique-local Single-Attempt entry
before the compact journey directory. `TechniquePrimaryActions` owns only that
entry; favorites remain in the app bar, History remains in Track Progress,
training remains in Train and Grounded Sensei remains inside post-result V2A.

The journey directory exposes collapsed Learn, Train, Track Progress and
Connect with Coach groups plus a collapsed More group. Overview, Technical
Lesson, Mistakes & Safety and Combinations & Counters render disjoint fields
from `TechniqueModel`. Practice, tactical and competition render fail-closed
states when their own approved content contract is absent; they do not borrow
learning content. Media renders approved media only and has no analysis/coaching
action.

### Natural Persian UX and Scientific Detail Hierarchy

The localization layer separates stable runtime identity from presentation.
Canonical technique taxonomy, difficulty, filter values, metric provenance and
scientific status remain unchanged in models and contracts; presentation-only
localizers map those values to the selected locale. This preserves search and
filter behavior while preventing raw English taxonomy or provenance from
leaking into the Persian experience.

High-traffic Home, Techniques, Uchi Mata, Analyze, Result, History, Progress and
Settings surfaces resolve athlete-facing copy through the generated localization
contract. Uchi Mata Quiz records include explicit Persian question, option and
explanation translations with the same answer indices. Content without a
complete Persian contract, including the current media catalog, fails closed
rather than silently rendering English as completed Persian content.

Metric identifiers, method versions, reviewed gate coordinates and detailed
confidence/limitation evidence remain available but are secondary scientific
details. Result, Progress and Settings place that engineering context behind
collapsed disclosure controls while keeping reportable, `review_required`,
withheld and insufficient-evidence states visible. Profile History localizes
known metric names, provenance and bounded explanations without changing the
stored versioned record.

This presentation architecture changes no V1/V2A formula, method version,
metric status, BLUE geometry, identity, detector, tracker, persistence or
Grounded Sensei evidence boundary.

### Full Persian Runtime Contract Closure

The generated localization architecture now has one explicit Persian value for
every English runtime-template message: `532/532`, including the 57 new Club
Administration messages. The former 261-message gap was not bulk translated.
Runtime-source inspection found two reachable legacy
aliases, `profile` and `retry`; they now use the existing approved messages
`moduleAthleteProfileTitle` and `retryLabel`. The other 259 messages had no
typed project runtime consumer and were retired from the template contract.

The complete classification is preserved in
`docs/PERSIAN_LOCALIZATION_AUDIT_V1.md`. Flutter tooling owns the generated
Dart localization classes. Future runtime messages must be reachable, explicit
in Persian and compatible with the fail-closed content boundary. This cleanup
does not change route availability, the 18-module registry or any scientific
contract.

### Canonical Detached Device-Validation Tooling V3

Device validation remains outside Flutter production runtime. The canonical
PowerShell v3 runner lives in the checkpoint tooling area and treats Git state,
device state, memory, build freshness, install, launch, logcat and guided
evidence as explicit sequential gates.

Its safe `SyntaxCheck`, `SelfTest` and `PreflightOnly` modes do not run a
build. SelfTest uses synthetic input only; Preflight checks the approved
checkpoint and exact current Git/source state without issuing ADB commands.
Normal mode is the only build path and can register exactly one attempt. Native
stderr is evidence rather than failure when the native exit code is zero.

The runner does not close user applications, clear app data, confirm History
deletion, submit V2A or perform inference. It is operational validation tooling
and changes no app architecture, module, scientific contract or product
capability.

## 2026-08-15 — Runtime Truthfulness Boundaries

The technique catalog now exposes four separate quantities instead of using a
roadmap number as runtime availability: bundled records, production-available
experiences, closed previews and the official roadmap target. The existing
`TechniqueFactory` is the product-owned availability gate for the current local
catalog. A preview record may support search/filter visibility, but it cannot
open Technique Detail or expose an unverified secondary taxonomy.

Media availability is also an interaction boundary. A catalog record without a
valid approved payload receives no tap callback, play affordance, open-analysis
control or player route. The record can remain visible as unavailable without
pretending that a destination exists.

The educational biomechanics renderer remains the existing three-layer custom
painter. Presentation localizes its title and labels and calls the green layer
“illustrative direction”; a visible disclosure states that it is not a
measurement. This changes no animation geometry, metric, V1/V2A service or
scientific provenance.

### Athlete Information Architecture Convergence

The five athlete journeys remain the product contract, but unavailable
journeys are not equal navigation destinations. Athlete Home exposes four
primary working actions (Learn, Analyze, Track Progress and Profile) and a
compact fail-closed future area for Train and Coach. Track Progress enters the
evidence-only Progress Overview, which owns the onward route to raw History.

Technique Detail keeps one primary Analyze action, one Learn group, one Track
Progress / History group, one compact future Train / Coach group and one More
group. The secondary Platform Overview derives its exact 18 identities and
routes from the canonical registry and does not expose engineering readiness
labels as the primary athlete-facing status.

### Club Administration Local Foundation

The first Club Administration implementation follows the existing local-data
boundary:

`SharedPreferences payload → strict versioned storage → repository abstraction → app-scoped provider → Club workspace`

`LocalClubAdministrationSnapshot` schema `2.0.0` contains one optional `Club`
and typed `ClubMembership`, `TrainingGroup`, `ClubTrainingSession`,
`TrainingSessionItem`, `TrainingSessionDosage` and `AttendanceRecord`
collections. A session owns an explicit classification, optional coach title
and objective, schedule, optional duration and a contiguous ordered item list.
Each item has a stable identifier, activity category, exactly one validated
dosage mode, optional non-negative rest and optional coach notes.

The repository accepts valid schema `1.0.0` only through an explicit in-memory
migration. Existing identifiers, timestamps, schedule, duration, state and
attendance are preserved; old sessions become `unspecifiedLegacy` with an
empty item list. Loading does not rewrite the source payload. The upgraded
representation is persisted only by a later intentional write. Unknown,
future, corrupt or cross-reference-invalid payloads fail closed and cannot be
silently reset.

The existing `LocalAthleteProfile` remains a single current-local-athlete
record. Membership references the stable local slot
`local-athlete-profile:current`; it stores no Profile display name, belt,
country, biography or body data. The provider persists each coherent state
transition and derives dashboard counts only from recovered records.

`/club-administration` is reachable only from the registry-backed Platform
Overview. Module 13 is `foundationOnly`, is not an Athlete Home primary action
and does not imply cloud, multi-device, verified identity, role authorization
or federation readiness. No V1/V2A, scientific metric, Media, training,
detector, tracker or Identity contract is connected to this storage.

The Club workspace owns a scroll-safe coach-authored planner for create and
edit. It supports explicit session type, date/time, duration and optional
typed items with accessible add/edit/remove/reorder controls. Attendance
remains a separate explicit record and survives plan edits. The plan is not an
execution log, a training prescription or scientific load evidence. The
Strength & Conditioning Exercise Library, completed dosage, cloud and real
multi-athlete identity remain separate unavailable capabilities.

Club Session Composer V2 keeps that schema and repository boundary unchanged.
One dialog owns session metadata plus an in-memory list of stable-ID item
drafts. Accordion panels edit category, optional title, the selected dosage
fields, optional rest and notes inline; add, duplicate, delete and move actions
only mutate this local draft. The caller receives one complete
`SessionPlannerDraft` after final validation and performs one provider save.
Cancel/discard returns no draft, so no repository transition occurs.

The live summary is a presentation projection, not stored evidence. It reports
the explicit scheduled duration and sums only duration dosage or
`rounds × minutes per round`. If any repetition-, set-, distance- or
description-based item has no explicit time, the result is labelled partial or
unavailable. Rest intervals are not multiplied because the schema does not
define how many rest periods occur. Schema `2.0.0`, `1.0.0` migration,
session/item IDs, timestamps and attendance remain intact.
## Strength & Conditioning Exercise Library Foundation V1

The local-first Exercise Library is an independent replaceable repository
boundary inside Club Administration:

`SharedPreferences storage -> strict repository -> ChangeNotifier provider -> Exercise Library / Session Composer`

- `training_activity_contract.dart` is the shared taxonomy owner for existing
  Club activity categories, dosage modes, exercise source/review/modality and
  immutable session reference snapshots.
- `LocalExerciseLibrarySnapshot` schema `1.0.0` is strict, versioned and starts
  with zero approved entries. Duplicate IDs and incomplete approval evidence
  fail closed.
- Club Administration schema `3.0.0` adds nullable `exercise_snapshot` to each
  session item. Exactly one migration target accepts schemas `1.0.0` and
  `2.0.0`, preserves their data in memory, and writes schema 3 only on an
  intentional provider save.
- Session Composer retains its single-page accordion and manual path. Library
  selection copies identity/revision/source/review/localized display/category
  and compatible dosage modes; the coach supplies dosage, rest and notes.
  Library edits and archives cannot mutate a saved session snapshot.

### Exercise Library import and selection V2

Bulk authoring extends the same repository boundary without adding a parallel
source of truth:

`CSV picker adapter -> pure CSV parser/preview -> provider atomic import -> existing strict repository/storage`

The canonical CSV contract is `1.0.0`. Parsing is deterministic and performs
no persistence. Confirmation passes only the immutable valid preview entries
to one provider operation; repository failure retains the previous snapshot.
CSV values cannot set source/review fields: imported entries are always local
coach-authored and not scientifically reviewed.

`LocalExerciseLibraryUsageStorage` separately stores favorite IDs and at most
ten most-recent selection IDs. These are navigation preferences, not exercise
evidence, plan execution or scientific data. Missing/deleted/archived IDs are
filtered when projected into UI. The Session Composer copies the existing
immutable exercise snapshot only after explicit selection and continues to
own all coach-entered dosage.

`ExerciseCsvFileSelector` isolates the one platform plugin from parsing,
validation, persistence and widget tests. The parser remains pure Dart and is
usable with injected bytes on every supported client platform.

### Cross-platform technology boundary

Flutter/Dart is the shared client default, Python owns AI/video/scientific
computation, and platform-native or systems implementations sit behind
interfaces/adapters only when JM-DEC-029 evidence requirements are met. Build
and QA evidence is platform-specific.

## Read-Only Scientific Transparency Presentation

The mobile Scientific Transparency boundary is:

`governed scientific registries -> immutable display adapter -> localized read-only UI`

The adapter is a compile-time presentation projection, not a runtime scientific
registry and not an approval engine. It may expose only safe bibliographic and
status fields. Reviewer identity, filesystem paths, hashes, governance IDs,
formulas, thresholds, enable flags, and internal notes stay outside the mobile
contract. Missing, malformed, unknown, or accidentally promoted input resolves
to locked/not-scientifically-reviewed.

The Uchi Mata detail screen owns the compact status entry point and uses the
existing technique bottom-sheet convention for Sources and Limitations. The
capability list has no commands or toggles. Candidate sources never imply
claim-level support, and this presentation layer cannot activate scientific,
medical, biomechanical, video-analysis, AI, or production behavior.

## Generic Non-Uchi Technique Detail Boundary

Technique-detail routing now separates identity resolution, product
eligibility, and presentation:

`requested ID -> TechniqueDetailRoutePolicy -> explicit route decision`
`-> specialized Uchi Mata or generic read-only destination`

The policy accepts an exact three-digit ID only when exactly one canonical
catalog record exists. ID `001` retains the specialized Uchi Mata Gold path.
A non-001 record can enter `GenericTechniqueDetailScreen` only when its ID is
also present in the explicit read-only eligibility set. Malformed, unknown,
duplicate, and non-eligible decisions are locked. The eligibility set is empty
at JM-S1.1-B closure, so no new runtime destination is active.

`GenericTechniqueDetailAdapter` resolves existing English fields or exact
selected-language fields without silently completing missing localized lists.
The generic screen owns a bounded educational projection only: identity,
metadata, overview, technical explanation, steps, key points, mistakes,
safety, combinations, and counters. It has no Uchi scientific adapter,
Scientific Status, candidate source, media, analysis, metric, score, mastery,
diagnosis, prediction, prescription, or future-action route. Empty fields are
explicitly unavailable.

`TechniqueDetailScreen`, `TechniquePrimaryActions`, and
`TechniqueSectionRouter` retain defensive gates so a direct non-Uchi caller
cannot inherit the Uchi page or any Analyze entry. This architecture changes no
V1/V2A method, scientific contract, provenance, detector, tracker, identity,
BLUE geometry, Grounded Sensei, History, or training prescription.

## Technique Explanation Content Extension Boundary

The existing `TechniqueModel` remains the canonical technique record. Its
identity, classification, description, technical analysis, execution steps,
coaching points, mistakes, safety, combinations, counters, translations,
media, Quiz and sources must be reused where those meanings are exact.

A documented schema gap remains for structured named phases and starting
position, follow-through, variations, canonical linked-technique IDs,
media-rights/provenance and accessibility data, statement-level scientific
classification, and distinct technical/scientific review state. These values
must not be inferred safely from the existing free-text or URL fields.
`TechniqueExplanationExtension` fills only that gap as an optional child of
`TechniqueModel`; its default is empty and unavailable. It is not a second
technique model, does not duplicate canonical identity or existing educational
text, and cannot make a route eligible.

Generic presentation resolves only exact selected-language extension values.
Incomplete optional content stays unavailable. Visual/video material is
displayable only with recorded project ownership, licence or permission plus
provenance and an accessible description. Biomechanical statements are hidden
unless their statement classification, method, limitations, provenance and
review records satisfy the fail-closed display contract. This presentation
gate is not scientific approval and creates no capability, threshold, metric
or analysis route.

The screen uses expandable sections, with Overview, Execution phases and Key
coaching points prominent. Technical explanation, conceptual mechanical
interpretation, measured/reconstructed/model-estimated/AI-inferred results and
evidence/review status remain separate. Any future conceptual diagram is
zoomable, accessible and carries the required no-direct-force-measurement
disclaimer. No external inspiration asset is part of this architecture.

## Canonical Technique Identity Boundary

The authoritative CSV under `docs/technique_registry` is projected into the
content-free `CanonicalTechniqueIdentityRegistry`. A field-for-field test
guards the projection; it does not replace `TechniqueModel`.

Production routing is fail closed:

`ID -> unique verified identity -> verified classification -> model FK`
`-> explicit eligibility -> specialized/read-only destination`

Catalog order, identity verification, model availability, content state,
technical review, scientific review, media rights, route and unlock remain
independent. Pending/conflicting identities stop before model or route
activation. Test-only custom catalogs must explicitly provide an identity
registry when exercising this boundary.

## Human-First Analysis Layer Separation

The analysis architecture is intentionally separated into three layers:

1. `Technique Intelligence`: selected technique and attempt -> frame-local
   evidence -> explicit human role assignment -> session-bound candidate
   resolution -> existing governed V2A -> bounded feedback.
2. `AI-Assisted Competition Timeline`: future AI-assisted event/segment
   organization -> coach review -> human interpretation. No runtime
   implementation or tactical judgment exists in the current milestone.
3. `Coach Analysis Marketplace`: future athlete request -> selected coach ->
   human report -> separately governed commercial settlement. No marketplace,
   payment or report implementation exists in the current milestone.

The Layer 1 Guided confirm transport owns a strict `role_assignment` with
`TORI`, `HUMAN_CONFIRMATION` and one opaque session candidate token. The token
is resolved only in the current server session; it is not an identity or
tracking key and is not persisted in V2A History. The role assignment does not
alter V2A 2.0.0 or its subject provenance projection.

## Guided Selected-Frame Review Boundary

The primary Uchi Mata V2A orchestration is:

`source timing declaration -> server-owned decoded timing manifest`
`-> frame-accurate boundary selection and human confirmation`
`-> PREPARE -> frame-local candidate preview`
`-> explicit human Tori/context confirmation -> CONFIRM/ANALYZE`
`-> existing V2A 2.0.0 core -> result -> Grounded Sensei`

The timing-manifest endpoint decodes timing without pose inference, records a
content hash, total decoded frames, canonical per-frame timestamps, timing
mode and explicit timestamp provenance, then deletes the temporary upload.
OpenCV decoder timestamps are described as decoder-reported timestamps, never
as raw container PTS; average-FPS fallback is marked unknown and cannot support
a physical-duration claim. The manifest is opaque, bounded, expires after ten
minutes and retains no raw video.

A separate no-inference boundary-preview request revalidates the video hash
and returns exact server-decoded start/end images. Only after those images are
shown may the user confirm the boundaries and continue to pose PREPARE.

Boundary confirmation and single-attempt confirmation are separate assertions.
The latter is typed as `SINGLE_ATTEMPT` / `HUMAN_CONFIRMED` under
`single-attempt-human-confirmation-1.0.0`. It is bound to the same video,
manifest and exact frame tuple; any relevant change invalidates it. No attempt
counting or segmentation is inferred.

The prepared candidate stage exposes a localized Edit attempt boundaries
transition. It retains only the loaded video/timing manifest, declared source
timing and current start/end/review frames. Boundary preview and confirmations,
prepared request/session, candidate and every Tori/limb/camera review value,
analysis result and Grounded Sensei explanation are discarded before the
timeline is shown again. Re-entering prior frame values cannot restore the old
confirmation. The server currently has no guided-session cancel endpoint, so
an abandoned in-process session remains bounded by its existing TTL and store
capacity.

PREPARE accepts only confirmed frame indexes bound to that manifest, rechecks
the uploaded video's SHA-256 and rejects stale, cross-video or out-of-range
references. For MediaPipe VIDEO-mode context only, it builds a contiguous plan
ending at the exact Review Frame with at most 500 ms of preceding source frames.
The start is always clamped to the human-confirmed attempt start. This is an
engineering computation bound, not a scientific or Judo-specific threshold.

Each Guided PREPARE uses an isolated MediaPipe context under the existing
analysis lock. Timestamps are strictly increasing within that isolated
instance, so another request's internal VIDEO state is not treated as evidence.
All warm-up pose outputs are discarded. Only the result whose frame index is
exactly the canonical human-selected Review Frame can enter preview generation,
the D2 adapter and the candidate-set gate; warm-up frames cannot affect
candidate identity, metrics, History, Sensei evidence or canonical timing.

PREPARE does not consume the timing manifest: it remains available only until
its existing bounded expiry so a human can edit, preview and reconfirm the
boundaries without decoding a replacement timeline. Every PREPARE creates a
fresh review session, and all manifest video/hash/range validation remains in
force.
Each candidate token is opaque, session-bound,
attempt-local and frame-local; it is never a persistent athlete identity.

D2 formalizes this frame-local boundary as:

`FrameCandidate != TemporalTrack != HumanRoleAssignment`

`detected_pose_count` is exactly the number of poses returned by the model in
the selected frame. It is not the number of people, judoka, tracks or
identities. `selectable_candidate_count` separately counts unique-index
candidates that have a valid preview and the required 2D pose evidence. The
candidate set is `ready_for_human_selection` only with at least two such
candidates; one is `insufficient_candidate_evidence`, while zero is
`no_selectable_candidate`. Duplicate or malformed candidate evidence cannot be
promoted into the two-person path.

PREPARE creates neither Track A/B nor Tori/Uke roles. Each returned candidate
contains only its opaque token, preview, pose availability, model-estimated
provenance, required-landmark counts and model-landmark visibility-field
availability. Track status is explicitly unavailable, neutral track ID and
association confidence are null, and visibility availability is not pose
accuracy, tracking/identity confidence, technique quality or scientific
confidence. The server session stores the candidate-set eligibility and rejects
ANALYZE for insufficient evidence even if a client constructs a request.

After a human selects and explicitly confirms Tori, ANALYZE converts the exact
server-owned frame candidate into the existing V2A observation. Any neutral
label used by that legacy single-subject adapter is analysis-local only and is
not temporal tracking evidence. V2A still reports automatic Tori/Uke identity
as false and multi-person evidence as insufficient.

The in-process session store retains the exact model-estimated 2D pose needed
for confirmation for ten minutes, with at most 32 concurrent sessions per
process. CONFIRM/ANALYZE rejects missing explicit Tori
confirmation, uncertainty, invalid cross-session tokens and expired sessions,
and consumes the stored pose without a second inference or detection-order
assumption. Successful/uncertain sessions are discarded, expired entries are
cleaned opportunistically and process restart invalidates every session.

Temporary upload video is removed after PREPARE. Candidate previews, tokens and
pose observations are not part of the local History contract; only the existing
approved V2A result may be explicitly saved. The raw engineering review panel
remains available in source for diagnostics but is not the normal user path.

`UM-TIM-001` remains the same elapsed-time calculation but is now explicitly
the selected-window elapsed time between exact human-confirmed boundaries. It
is withheld when source timing or the timing evidence is unknown. A known time
scale is applied only when explicitly supplied. This is not automatic phase or
technique-duration detection.

This orchestration changes no angle formula, metric/version, BLUE
geometry, automatic-identity lock, phase capability, multi-person sufficiency,
3D/kinetics boundary or Grounded Sensei grounding contract.

## Uchi-mata Gold Scientific Foundation (JM-UM-GS-0)

JM-UM-GS-0 adds a research-only schema layer under
`ai_engine/scientific_foundation/` and versioned profiles under
`docs/scientific_foundation/`. It is deliberately disconnected from the
production FastAPI, V2A and Flutter dependency graphs.

The responsibility split is:

- canonical source identity: `JM_SOURCE_INVENTORY.csv`;
- canonical metric identity: `JM_METRIC_AND_THRESHOLD_INVENTORY.csv`;
- current Uchi-mata metric state: `JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv`;
- capability state: `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv`;
- Gold evidence/event/phase/measurement/gap/rule/rights profile:
  `JM_UM_GOLD_*_V1.csv`;
- extra-forbid typed validation contracts:
  `ai_engine/scientific_foundation/uchi_mata_gold_standard.py`.

The Gold evidence registry references existing `JM-SRC-*` IDs when available.
Unregistered discovery leads remain `UNASSIGNED_PENDING_FORMAL_INTAKE` and
cannot serve as claim evidence. Gold measurement rows reference existing
metric IDs and add schema fields; they do not redefine formula, implementation
or reportability.

The event layer is independent from phase definitions. E0–E7 are observable
research candidates; E4/E5 are provisional. Phase rows preserve a source's
operational labels and event intervals rather than silently mapping them to a
universal conceptual sequence. Automatic event/phase output is disabled.

Future integration must follow:

`approved registry record -> dedicated backend adapter -> versioned result DTO
-> localized Flutter presentation`

There is no reverse path from Flutter, raw video or an LLM to a new scientific
finding. Sensei may later explain only an authorized structured finding. The
empty V1 rule registry and typed hard locks prevent schema presence from being
mistaken for permission.

Rights are a separate gate from scientific validity. Reference linking does
not grant local-copy, model-processing, training-data or commercial-use rights.
The V1 profile grants none of those uses.

This architecture preserves V2A 2.0.0, its four metrics, D1 human attempt
boundaries, D2 frame-local candidate/session/token/human-role gates, and the
existing single-camera provenance boundary. JM-C2.1-D2 remains active pending
separate positive real-device lifecycle/reproducibility validation.

## Uchi-mata Gold evidence-to-claim layer (JM-UM-GS-1)

GS-1 keeps canonical source identities in `JM_SOURCE_INVENTORY.csv` and adds a
technique-specific scientific-claim profile rather than altering the existing
product-content claim inventory. Each Gold claim binds exactly one canonical
source and carries its own population, method, event/phase, measurement,
result, uncertainty, external-validity, rights and use boundary.

The non-production dependency direction is:

`canonical source -> Gold evidence -> source-bound claim -> measurement/gap`
`-> future reference applicability -> future approved interpretation`
`-> future authorized structured finding -> Sensei wording`

The 22-item measurement matrix and camera-requirement foundation are research
planning artifacts. They do not enter the current FastAPI, V2A or Flutter
dependency graphs. A consumer single camera may support only declared 2D
projection/proxy or human timing scopes; reconstructed 3D requires calibrated,
synchronized multi-view evidence and validation. Kinetics additionally require
validated external-force and inertial inputs.

Data acquisition is a separate rights-gated registry. Public viewing, open
access and source linking do not authorize copying, processing, training or
commercial use. The empty interpretation-rule registry remains the hard stop
between measurements and technical/coaching claims.
