# Judo Mind Decision Log

All important architectural, product and technical decisions are recorded here.

---

# JM-DEC-001

Date:
2026-07-30

Status:
Approved

Category:
Architecture

Title:
Evolution of Judo Mind Architecture


Decision:

Judo Mind will be developed as a digital Judo ecosystem,
not only a mobile application.


Impact:

Future development must consider:

- Athlete system
- Coach system
- Club system
- Federation system
- AI ecosystem
- Knowledge base
- Education platform
- Administration platform


Required Updates:

- ARCHITECTURE.md
- PROJECT_STATUS.md
- TECHNIQUE_SPECIFICATION.md

---

# JM-DEC-002

Date:
2026-07-31

Status:
Approved

Category:
Product Architecture

Title:
17 Module Product Structure


Decision:

Judo Mind officially consists of 17 independent modules.

The 17th module is:

Administration & System Settings


Impact:

The product architecture must support:

1. Home
2. Techniques
3. Sensi Bot
4. Sensi Bet
5. Monitoring
6. Judo Cast
7. Athlete Profile
8. Training Center
9. Champions Hub
10. Competitions & Challenges
11. News
12. Store & Subscription
13. Club Management
14. Coach Forum
15. Online Courses
16. Country Judo History
17. Administration & System Settings


Required Updates:

- PRODUCT_REQUIREMENTS.md
- ARCHITECTURE.md
- PROJECT_STATUS.md
- CHANGELOG.md

---

# JM-DEC-003

Date:
2026-07-31

Status:
Approved

Category:
User Experience

Title:
Technique Detail Dashboard Architecture


Decision:

The Technique Detail page will not use a single long scrolling page.

A dashboard-based navigation system will be used.


Structure:

Technique Header

↓

Technique Dashboard

↓

Individual Section Views


Sections include:

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


Reason:

Improve user experience and reduce unnecessary scrolling.


Impact:

Required components:

- Technique Dashboard Item
- Technique Dashboard Grid
- Technique Bottom Sheet
- Section Components


Required Updates:

- ARCHITECTURE.md
- MODULE_02_TECHNIQUES.md
- CHANGELOG.md

---

# JM-DEC-004

Date:
2026-07-31

Status:
Approved

Category:
Internationalization


Title:
Localization First Strategy


Decision:

Judo Mind must support multilingual architecture from the beginning.

No user-facing text should be permanently hardcoded.


Initial Supported Languages:

- English
- Persian
- Japanese
- French
- German
- Russian
- Spanish
- Arabic


Impact:

The system must support:

- UI translation
- Content translation
- Technique translation
- RTL/LTR layouts
- Language switching without rebuilding application


Required Updates:

- ARCHITECTURE.md
- LOCALIZATION.md
- PRODUCT_REQUIREMENTS.md

---

# JM-DEC-005

Date:
2026-07-31

Status:
Approved

Category:
Content Management


Title:
No-Code Administration System


Decision:

Future Judo Mind administrators must be able to manage application content without Flutter code changes.


Managed Content:

- Text
- Images
- Videos
- Audio
- Techniques
- Quiz
- Courses
- News
- Champions
- Translations
- Advertisements


Architecture:

Flutter Application

↓

API

↓

Backend

↓

CMS


Impact:

A complete Administration Panel and CMS will be developed.


Required Updates:

- ARCHITECTURE.md
- CMS_ARCHITECTURE.md
- PRODUCT_REQUIREMENTS.md

---

# JM-DEC-006

Date:
2026-07-31

Status:
Approved

Category:
Technique Intelligence


Title:
Technique Knowledge Expansion


Decision:

The Technique Module will evolve from a database into an intelligent Judo knowledge system.


Each technique should support:


Technical Layer:

- Kuzushi
- Tsukuri
- Kake
- Execution steps
- Common mistakes


Biomechanics Layer:

- Movement analysis
- Force direction
- Center of gravity
- Muscle activation


Training Layer:

- Shadow training
- Uchikomi
- Nagekomi
- Strength training
- Mobility


Competition Layer:

- Tactical application
- Combination
- Counter
- Match analysis


AI Layer:

- Progress analysis
- Recommendations
- Personalized training


Required Updates:

- TECHNIQUE_SPECIFICATION.md
- ARCHITECTURE.md
- PRODUCT_REQUIREMENTS.md

---

# JM-DEC-007

Date:
2026-07-31

Status:
Approved

Category:
Documentation


Title:
Documentation Synchronization Rule


Decision:

No major feature or architectural decision should exist only inside conversation history.


All major decisions must update:


- PRODUCT_REQUIREMENTS.md
- ARCHITECTURE.md
- PROJECT_STATUS.md
- CHANGELOG.md
- DECISION_LOG.md


Reason:

Maintain project continuity and prevent loss of knowledge.

---

# 11. Continuous Documentation Synchronization

## Purpose

To ensure that the Judo Mind project remains maintainable, scalable, and understandable throughout its lifecycle, all development activities must be synchronized with the project documentation.

---

## Mandatory Rules

Every significant change to the project must update the related documentation before the task is considered complete.

No architecture, feature, module, or technical decision is allowed to exist only in the source code.

Documentation is considered part of the implementation.

---

## Required Documentation Updates

### Feature Development

Update:

- CHANGELOG.md
- PROJECT_STATUS.md

---

### Architecture Changes

Update:

- ARCHITECTURE.md
- DECISION_LOG.md

---

### Product Changes

Update:

- PRODUCT_REQUIREMENTS.md

---

### Development Process Changes

Update:

- AI_DEVELOPMENT_RULES.md

---

## Completion Checklist

A development task is complete only when all of the following are finished:

- Source code implemented
- Flutter Analyze passed
- Documentation updated
- Decision Log updated (if needed)
- Changelog updated
- Project Status updated

---

## Version Control Philosophy

Documentation is treated as a first-class project asset.

The documentation must always represent the latest approved architecture and implementation.

Project knowledge must never depend solely on conversation history.

---

Status:
Approved

Effective From:
2026-07-31

Project:
Judo Mind Super App

## JM-DEC-009

Date:
2026-07-31

Status:
Approved

Title:
Judo Mind Design System 1.0

Decision:

Judo Mind shall use one centralized design system across all 17 modules.

The design system will define:

- Global colors
- Typography
- Spacing
- Border radius
- Button hierarchy
- Card hierarchy
- Icons
- Bottom sheets
- Dialogs
- Loading states
- Empty states
- Error states
- Responsive behavior
- RTL and LTR compatibility

No module may define independent visual standards outside the approved design system.

Impact:

- Consistent user experience
- Faster development
- Easier maintenance
- Better internationalization
- Easier CMS integration
- Professional presentation for investors and federations

## JM-DEC-010

Date:
2026-08-01

Status:
Approved

Title:
Uchi Mata as the Official Reference Technique

Decision:

Uchi Mata is approved as the official reference implementation for all Judo Mind techniques.

Its architecture will define:

- Learning flow
- Dashboard structure
- Media architecture
- AI analysis access
- CMS data requirements
- Localization behavior
- Subscription behavior
- Design System usage

Impact:

All 67 official techniques must use the same scalable architecture.

---

## JM-DEC-011

Date:
2026-08-01

Status:
Approved

Title:
Universal AI Video Analysis Access

Decision:

Video upload and AI analysis will be available at every subscription level.

Plans will differ by:

- Monthly credits
- Analysis depth
- Report capabilities
- Storage
- Coach services
- Team-management access

Impact:

Lower-tier users can experience the core AI value while paid tiers receive greater capacity and professional functionality.

---

## JM-DEC-012

Date:
2026-08-01

Status:
Approved

Title:
Sensi Bot AI Fight Intelligence 360

Decision:

Judo Mind AI analysis must evaluate the complete interaction between athlete and opponent.

Required analysis includes:

- Opponent guard
- Grip configuration
- Attack and defense position
- Push and pull reactions
- Balance weakness
- Weight transfer
- Attack timing
- Counter risks
- Tactical patterns
- Match timeline

Impact:

Sensi Bot evolves from an AI chat assistant into the central intelligence engine of Judo Mind.

## JM-DEC-013

Date: 2026-08-02
Status: Approved

Title: Centralized Judo Mind Icon Architecture

### Decision

All feature icons will use the centralized `JudoIcons` registry and the standard `JudoIcon` component.

Direct feature-level icon styling is no longer permitted except for generic platform actions approved by the Design System.

### Reason

This architecture allows the temporary Material-based icon layer to be replaced by custom SVG assets without rewriting individual screens.

### Impact

- Unified icon language across all 17 modules
- Improved accessibility
- Reduced visual inconsistency
- Easier future SVG migration
- Faster global icon updates

---

## JM-DEC-014

Date: 2026-08-02
Status: Approved

Title: Custom Illustration Layer for High-Value Dashboard Features

### Decision

Selected high-value cards will use custom Judo Mind illustrations in addition to or instead of generic icons.

Initial illustration targets:

- Sensi Bot
- Quiz
- Training
- Competition
- Mastery

### Constraints

Illustrations will not be placed on every card.

They will be used only where they improve meaning, recognition or product identity without increasing visual clutter.

## JM-DEC-015

Date: 2026-08-02
Status: Approved

Title: Selective Illustration Use in Technique Dashboard

### Decision

Custom illustrations will be used selectively for high-value and identity-defining features.

Initial approved cards:

- Training
- Competition
- Mastery
- Sensi Bot
- Quiz

Other Dashboard cards will remain icon-based unless a custom illustration provides a clear usability or recognition benefit.

### Reason

Using illustrations on every card would increase visual noise, page height and cognitive load.

Selective use creates stronger hierarchy while preserving the compact Dashboard architecture.

### Validation Rule

Every illustration integration must be reviewed on a physical mobile device for:

- Legibility
- Card balance
- Text clearance
- Badge overlap
- Visual hierarchy
- RTL compatibility
- Small-screen behavior

## JM-DEC-016

Date: 2026-08-02
Status: Approved

Title: Controlled Media Catalog

### Decision

Judo Mind will use a controlled media catalog.

Public search-result pages must not be used as media destinations.

Each media item must reference one specific selected resource and include:

- Professional title
- Media type
- Source
- Verification status
- Thumbnail
- Direct content URL
- Optional duration and competition metadata

### Source Priority

1. IJF official technique resources
2. IJF or JudoTV competition media
3. Kodokan educational media
4. Licensed partner media
5. Judo Mind original content
6. Curated external media when necessary

Official API integration requires permission or partnership when the source does not provide a public integration API.

---

## JM-DEC-017

Date: 2026-08-05
Status: Approved

Title: Scientific Biomechanics & Multi-View Motion Analysis Architecture

### Decision

Judo Mind biomechanical analysis shall not be based solely on 2D pose estimation or visual skeleton overlays.

The official biomechanics architecture will use a scientific multi-layer motion-analysis pipeline inspired by validated research and professional biomechanics systems.

### Core Architecture

The Judo Mind Biomechanics Engine will include:

1. Multi-person athlete detection
2. Tori / Uke identity tracking
3. 2D anatomical landmark detection
4. Camera calibration
5. Multi-view synchronized capture
6. 3D landmark reconstruction
7. Musculoskeletal modeling
8. OpenSim-based kinematic analysis
9. Judo-specific phase detection
10. Confidence and quality validation

### Official Biomechanics Core

OpenSim 4.6 is approved as the primary musculoskeletal modeling and biomechanical computation engine.

OpenSim will support future calculations including:

- Joint angles
- Segment orientation
- Joint range of motion
- Center-of-mass analysis
- Angular velocity
- Angular acceleration
- Musculoskeletal modeling
- Inverse kinematics
- Inverse dynamics when sufficient external-force data is available
- Joint moments and powers when scientifically supported

### Computer Vision Layer

RTMPose-M is approved as the current baseline computer-vision pose engine.

It is not considered the complete biomechanics engine.

Current benchmark on the same real Judo competition video:

- MediaPipe Heavy two-athlete detection: 31.48%
- RTMPose-M: 48.33%
- RTMPose-M + PoseTracker: 46.85%
- RTMO-M: 8.15%

RTMPose-M therefore remains the current baseline while Judo-specific multi-person and occlusion intelligence is developed.

### Capture Quality Levels

Judo Mind will support multiple scientific analysis levels.

#### Standard Analysis

Input:

- Single uploaded training or competition video

Output:

- Estimated pose and movement analysis
- Technical analysis
- Tactical analysis
- Technique-phase recognition
- Estimated biomechanical indicators

These results must be clearly marked as estimated where measurement certainty is limited.

#### Advanced Biomechanics

Input:

- Two or more synchronized and calibrated cameras or smartphones

Output:

- Multi-view 3D reconstruction
- Improved joint kinematics
- Center-of-mass trajectory
- Body-segment orientation
- Technique-specific biomechanical analysis
- Tori / Uke interaction analysis

#### Research / Validation

Optional synchronized integration with:

- Force plates
- EMG
- IMU sensors
- Laboratory motion capture

This mode will be used for scientific validation and advanced research partnerships.

### Scientific Integrity Rule

Judo Mind must never present an estimated biomechanical quantity as a directly measured quantity.

Examples:

- Ground reaction force from a force plate = Measured
- Ground reaction force inferred from video = Estimated
- EMG signal = Measured muscle activation
- Musculoskeletal-model muscle activation = Estimated

Every biomechanical result must carry appropriate confidence, measurement source and limitation metadata.

### Judo-Specific Intelligence

Generic human pose estimation is not sufficient for final Judo Mind analysis.

The biomechanics system must eventually understand:

- Tori
- Uke
- Grip interaction
- Kuzushi
- Tsukuri
- Kake
- Throw direction
- Hip and leg interaction
- Center-of-mass relationship
- Support base
- Rotation
- Contact and occlusion
- Landing
- Counter movement

Uchi Mata remains the official reference technique for development and validation of this architecture before expansion to the remaining 66 techniques.

### Validation Requirement

Before Judo Mind biomechanical analysis is considered production-grade, representative Judo movements must be validated against higher-quality reference measurements where practical.

Validation targets may include:

- Marker-based motion capture
- Multi-camera laboratory systems
- Force plates
- EMG
- Expert technical annotation

### Infrastructure Decision

Local CPU processing is approved for development and baseline validation only.

Production high-accuracy computer-vision processing will be designed for GPU-backed server infrastructure.

### Product Objective

The AI biomechanics system must become a meaningful competitive advantage of Judo Mind rather than a decorative pose-estimation feature.

The final system must provide scientifically defensible and practically useful feedback for:

- Athletes
- Coaches
- Sports scientists
- Clubs
- Federations
- Researchers

### Required Documentation Updates

- ARCHITECTURE.md
- PROJECT_STATUS.md
- CHANGELOG.md
- PRODUCT_REQUIREMENTS.md
- DECISION_LOG.md

---

## JM-DEC-018

Date:

2026-08-07

Status:

Approved

Category:

Scientific Architecture and Product Integrity

Title:

Dual-Level Video Analysis and Fail-Closed Calibration Gate

### Context

The current two-phone stereo calibration cycle was closed after approximately 48 hours of investigation. A geometric +0.55 s candidate correction did not solve the cross-camera geometry. The stereo RMS worsened from the previously recorded 39.26 px to 48.2750333 px, the median epipolar error was 55.4328918 px, and the final quality remained `review_required`.

Camera 101 and 102 intrinsic calibrations remain strong, and their orientations are confirmed. These findings do not validate the current stereo extrinsic. Stabilization/EIS/OIS changing the effective virtual camera remains a hypothesis and must not be recorded as the confirmed cause.

### Decision

Judo Mind video analysis is divided into two scientifically distinct product and processing levels.

#### Single-Camera AI Analysis

- Accepts an ordinary training or competition video.
- May provide 2D pose, phase and timing analysis, technical or tactical feedback, normalized movement indicators and other defensible single-view estimates.
- Must attach confidence, source, method, quality and limitations.
- Must classify results as `model-estimated` or `AI-inferred` when appropriate.
- Must never describe unmeasured depth, kinematics, kinetics, force or body motion as measured or reconstructed 3D.

#### Multi-Camera 3D Scientific Analysis

- Requires two or more suitable camera streams.
- Requires accepted calibration, synchronization, cross-camera athlete identity, geometry and reconstruction-quality gates before 3D results may be exposed.
- Classifies triangulated landmarks as `reconstructed`.
- Classifies OpenSim outputs as `model-estimated` unless backed by a qualifying direct measurement source.
- May reach OpenSim only after all upstream scientific gates pass.

### Calibration Gate

Calibration acceptance is fail closed:

- `status=completed` alone is insufficient.
- `quality=review_required`, missing metrics, malformed metrics or out-of-threshold metrics are rejected.
- `usable_for_3d_validation` may authorize only offline validation; it must not authorize user-facing scientific 3D or OpenSim.
- User-facing scientific 3D requires `good` or `excellent` plus at least 10 valid stereo holds, RMS reprojection error at or below 2.0 px, median epipolar error at or below 1.25 px and median absolute sync error at or below 8.5 ms.
- OpenSim uses the same minimum calibration profile but also requires independent identity, motion, reconstruction and anatomical-quality approval. Calibration approval is necessary, not sufficient.

### Current Calibration Disposition

The current `stereo_static_hold_extrinsics.json` report is scientifically rejected and must not enter production 3D reconstruction, biomechanics or OpenSim. No further test is to be run on the two videos from this closed cycle.

### Provenance Rule

Every relevant result must remain explicitly classified as one of:

- measured
- reconstructed
- model-estimated
- AI-inferred

Weak, uncertain or estimated output must not be presented to users as “precise biomechanics.”

### Deferred Work

A professional two-phone stereo capture protocol will be designed separately. Stabilization, resolution/FPS, exposure/focus, orientation, synchronization, rig geometry and standardized calibration capture are outside the scope of this decision implementation.

### Required Documentation Updates

- AI_DEVELOPMENT_RULES.md
- ARCHITECTURE.md
- CHANGELOG.md
- PRODUCT_REQUIREMENTS.md
- PROJECT_STATUS.md

---

## JM-DEC-019

Date:

2026-08-08

Status:

Approved

Category:

Scientific Architecture, Product Integrity and Analysis UX

Title:

Three-Level Fight Intelligence 360 and Uchi Mata Scientific Metrics Contract

### Context

JM-DEC-018 established separate Single-Camera AI and Multi-Camera 3D Scientific pipelines and a fail-closed calibration boundary. Judo Mind now requires a formal metric contract and a third professional/laboratory level so that ordinary video, validated 3D reconstruction and instrumented scientific analysis cannot be confused in the product.

The recent failed stereo cycle remains a rejected dataset/capture result. It does not invalidate the Multi-Camera architecture, and its two source videos remain closed to further testing.

### Decision

Fight Intelligence 360 has three independent scientific levels:

1. Level 1 - Single-Camera AI Analysis
2. Level 2 - Multi-Camera 3D Analysis
3. Level 3 - Professional / Federation / Laboratory Analysis

Every published result must be bounded by its level and retain measured, reconstructed, model-estimated or AI-inferred provenance without promotion.

### Level 1 Boundary

- Accept one ordinary video.
- Permit measured media metadata, projected/image-plane model estimates and AI-inferred phases or coaching.
- Require confidence, method, source and visible limitations.
- Prohibit true/reconstructed 3D, true 3D COM, measured force, actual joint moment, power or torque.
- Permit Green balance/mechanical arrows only as conceptual AI-inferred coaching cues.

### Level 2 Boundary

Require this fail-closed sequence before publishing 3D:

`synchronization -> intrinsics -> extrinsics -> orientation -> cross-camera Tori/Uke identity -> correspondence -> triangulation -> reconstruction -> filtering -> confidence/quality gates`

Only after all gates pass may the product expose reconstructed 3D landmarks, trajectories, geometric joint angles, relative position, 3D velocities, model-estimated COM and interactive 3D/360 viewing. `review_required` remains forbidden.

### Level 3 Boundary

Level 3 may use synchronized high-speed cameras, a calibrated capture volume, marker-based or validated markerless capture, optional IMUs, force plates/external-force systems, approved EMG and OpenSim. Measured external forces require valid instrumentation. Inverse-dynamics, joint moment, joint power and momentum remain model-estimated outputs derived under disclosed assumptions.

Level 3 is the reference-validation environment for Level 1 and Level 2 accuracy claims.

### Metric Contract

`docs/UCHI_MATA_SCIENTIFIC_METRICS_V1.md` is the official versioned specification. Each metric must define:

- Metric ID and coaching name
- scientific variable
- Tori/Uke role
- phase/event schema
- required landmarks or sensors
- formula/method and unit
- required camera setup and valid level
- provenance and confidence evidence
- DOI/source
- allowed and prohibited interpretations

No normative threshold may be invented from memory, a single athlete, a small study or an incompatible phase definition.

### Phase Definitions

The canonical Judo Mind sequence remains Preparation, Kuzushi, Tsukuri, Kake, Flight/Throw, Landing and Transition. Source-specific phase/event definitions must be stored and may be mapped only through explicit expert review. DOI `10.3390/jfmk10040378`, for example, uses a noncanonical Approach/Turning/Throw mapping and must not be silently relabelled.

### Interactive 3D / 360

The feature is `3D reconstruction + 360 viewing`: Front, Side, Rear, Top and Free virtual-camera views over valid reconstructed motion. It is not 360-camera capture. Future athlete/reference comparison may show compatible angle, timing and position differences without declaring one champion or trial a universal ideal.

### Result Experience

Fight Intelligence results combine AI Sensi, annotated video, voice coaching, scientific report and conditional 3D/360. Every finding exposes metric, value, phase, provenance, confidence, limitation, scientific source and coaching interpretation. No real narrator or third party may be cloned without permission.

### First Implementation Direction

After persistent Tori identity and a reviewed event-annotation protocol exist, the first recommended metrics are execution duration, projected trunk inclination and projected support-leg knee angle. This decision authorizes specification only; it does not claim implementation or validation.

### Required Documentation Updates

- `ARCHITECTURE.md`
- `DECISION_LOG.md`
- `PROJECT_STATUS.md`

## Implementation Record — Local Athlete Profile and V2A History UI (2026-08-12)

No new Decision ID is required. `JM-DEC-026` already governs the versioned,
explicit-save, local/demo-only scientific-history boundary.

That boundary is now shown through a real Athlete Profile route. Optional
Profile fields are self-reported and stored separately. V2A History preserves
original status, provenance, method, confidence availability, limitations and
withheld reasons. Corrupt storage fails closed. No verified identity, official
rank, score, mastery, trend, cloud, backend or authentication claim is added.

V1/V2A formulas and versions, JM-DEC-024, JM-DEC-025, tracker/detector status,
multi-person evidence and interaction reportability remain unchanged.
- `CHANGELOG.md`
- `PRODUCT_REQUIREMENTS.md`
- `AI_DEVELOPMENT_RULES.md`
- `UCHI_MATA_SCIENTIFIC_METRICS_V1.md`

---

## JM-DEC-020

Date:

2026-08-08

Status:

Approved

Category:

Product Architecture and Evidence-Aware AI

Title:

AI Training Plan Intelligence as Official Module 18

### Context

The original product baseline contained 17 official modules. The user has
approved a separate capability in which an athlete or coach supplies a training
plan and Judo Mind evaluates it against the training period, competition timing,
athlete context, Judo-specific performance requirements and relevant scientific
evidence.

### Decision

`AI Training Plan Intelligence` is established as Judo Mind Module 18. It is a
distinct product boundary that may consume approved context from Training Center
and Monitoring but does not replace or silently change either module.

### Required Behavior

The module must:

- Identify elements supported by the supplied context and evidence.
- Identify questionable, risky or internally inconsistent elements.
- Explain why a finding was produced and expose uncertainty.
- Propose alternatives only when justified.
- Cite evidence and retain provenance.
- Avoid presenting one plan as universally correct.
- Distinguish sport-performance guidance from medical diagnosis.

Training-plan findings and recommendations are `AI-inferred` unless a different
classification is directly supported. Self-reported athlete context must remain
self-reported and must not be promoted to measured physiological data.

### Safety Boundary

This decision does not authorize medical diagnosis, treatment, automatic plan
modification or unsupported safety claims. Future implementation requires a
versioned input/output contract, evidence policy, uncertainty and limitation
handling, privacy review, appropriate validation and explicit acceptance
criteria.

### Current Implementation Status

Documentation only. No Flutter UI or backend service is implemented by this
decision.

### Supersession

JM-DEC-002 remains the historical decision that established the original 17
modules. JM-DEC-020 expands the current official product architecture to 18
modules; it does not rewrite the historical state recorded in earlier entries.

### Required Documentation Updates

- `ARCHITECTURE.md`
- `PRODUCT_REQUIREMENTS.md`
- `PROJECT_STATUS.md`
- `DECISION_LOG.md`

---

## JM-DEC-021

Date:

2026-08-08

Status:

Approved

Category:

Scientific Architecture, Product Analysis Scope and UX

Title:

Three Video Analysis Modes and Attempt-Segmentation Boundary

### Context

JM-DEC-018 separates Single-Camera AI Analysis from Multi-Camera 3D Scientific
Analysis. JM-DEC-019 defines Level 1/2/3 scientific capability and provenance.
The product also requires an independent temporal/task boundary so that one
technique attempt, repeated practice and a full match cannot be processed or
presented as the same analysis object.

The Pose Engine Benchmark evaluates detection coverage, reliability and
performance. Its videos may contain multiple movements, but benchmark results
must not be interpreted as a combined athlete or technique analysis.

### Decision

Fight Intelligence 360 has three video-analysis modes:

1. Single Attempt - Technique Analysis
2. Drill / Repeated Attempts Analysis
3. Full Match Analysis

These modes define analysis scope and product UX. They are orthogonal to the
Level 1/2/3 scientific architecture and cannot promote provenance or bypass any
identity, phase, calibration, reconstruction or OpenSim gate.

### Mode 1 - Single Attempt Technique Analysis

One analysis window equals one primary technique attempt, with useful context
immediately before and after execution, completion or landing. No universal
duration threshold is approved.

When multiple attempts are present and automatic event segmentation is not
validated, one attempt must be selected or trimmed. Unsegmented attempts must
not be averaged or labelled as one technical result.

### Mode 2 - Drill / Repeated Attempts Analysis

Each repetition of the same technique must first become an independent event
and receive per-attempt analysis. Attempt comparison and aggregate consistency,
variability, progression, degradation or repeatability may be produced only
after reliable segmentation and independent analysis. Repetitions must never be
blended into one execution. Fatigue requires validated evidence and cannot be
inferred solely from repetition-to-repetition change.

### Mode 3 - Full Match Analysis

A full match uses this future sequence:

`temporal event detection -> attack/event segmentation -> technique candidate/classification -> individual attempt analysis -> outcome -> next event -> match-level tactical aggregation`

Event timeline, individual attack cards, per-attempt findings, match tactical
summary and AI Sensi competition review remain separate output layers. All
attacks must not be mixed into one biomechanics report.

### Benchmark and Temporal-Resolution Boundary

The timestamp-based 10 FPS target belongs to Pose Engine Benchmark and
engineering evaluation infrastructure. It is not a universal scientific
biomechanics sampling rate. Future metric extraction must retain source
timestamps and use a validated metric-appropriate temporal resolution,
potentially including native 25/30/50/60 FPS. No final FPS requirement is
approved without validation.

### Scientific Gates

Every mode preserves:

- `measured`
- `reconstructed`
- `model-estimated`
- `AI-inferred`

Validated identity is required before automatic Tori/Uke claims. Validated
event/phase segmentation is required before automatic Kuzushi/Tsukuri/Kake
judgment. Ordinary video cannot provide measured force. Single-camera video
cannot provide true 3D or actual torque, moment or power.

### Product UX

The future Analyze experience separates:

- Technique Analysis -> One Attempt
- Training / Drill Analysis -> Multiple Repetitions
- Competition Analysis -> Full Match

The result architecture remains AI Sensi + Annotated Video + Voice Coaching +
Scientific Report + Interactive 3D/360 only when the applicable scientific
gates pass.

### Implementation Status

Architecture and documentation only. No Flutter or Python feature is
implemented by this decision.

### Required Documentation Updates

- `AGENTS.md`
- `AI_DEVELOPMENT_RULES.md`
- `ARCHITECTURE.md`
- `PRODUCT_REQUIREMENTS.md`
- `PROJECT_STATUS.md`
- `CHANGELOG.md`
- `DECISION_LOG.md`

---

## JM-DEC-022

Date:

2026-08-08

Status:

Approved

Category:

Scientific Implementation, API Contract and Result UX

Title:

Single-Attempt Uchi Mata V2A Manual-Gate and Projected-Metric Contract

### Context

JM-DEC-021 defines Single Attempt Technique Analysis as one independent
analysis object. `UCHI_MATA_SCIENTIFIC_METRICS_V1.md` recommends execution
duration, projected trunk inclination and projected support/attacking-leg knee
angles as the current Level 1 metrics. Automatic attempt segmentation, role
identity, phase detection and leg classification are not validated.

### Decision

V2A implements exactly four versioned Level 1 metrics:

- `UM-TIM-001` reviewed execution duration;
- `UM-ANG-001` projected trunk inclination;
- `UM-ANG-002` projected support-leg knee angle;
- `UM-ANG-003` projected attacking-leg knee angle.

The `2.0.0` contract requires human-selected attempt boundaries,
human-confirmed Tori mapped to a role-neutral track, independently
human-confirmed support and attacking legs, a human-selected angle frame/event
label, and human review of near-planar view suitability and low camera roll.
Human review sources remain separate from measured/model-estimated provenance.

### Versioned Methods

- `reviewed-event-elapsed-time-1.0.0`: source timestamp difference in seconds.
- `projected-trunk-inclination-1.0.0`: shoulder/hip midpoints and
  `degrees(atan2(abs(dx), -dy))` relative to image vertical-up after conversion
  from normalized landmarks to source-image pixel coordinates.
- `projected-knee-angle-1.0.0`: image-plane internal hip-knee-ankle angle using
  source-image pixel coordinates, bounded dot product and arccos.

Source width/height is required and invalid dimensions fail closed. This
aspect-ratio correction is part of the approved method implementation; the
normalized blue overlay representation is retained separately for rendering.

The duration timebase is `measured`; the reviewed boundary source is stored
separately. All three projected angles are `model-estimated`. Benchmark 10 FPS
is not a universal scientific resolution.

### Quality and Confidence

Metric state is `reportable`, `review_required` or `withheld`. Missing,
non-finite or degenerate geometry is withheld with no value or overlay. A view
that is not confirmed suitable produces `review_required` when geometry is
otherwise available.

Minimum required model landmark visibility may be preserved under
`minimum_model_landmark_visibility`. It is not pose accuracy, scientific
validity or biomechanics confidence. No invented aggregate is allowed.

### Product Presentation

Flutter may show value/unit, state, provenance, visibility evidence, method,
limitation and descriptive text. BLUE overlay geometry is limited to the trunk
line, support-side and attacking-side hip-knee-ankle polylines and projected
angle labels.
Normative coaching, force vectors, fake COM and single-camera 3D are prohibited.

BLUE coordinates must remain finite and within normalized image space, and
the exact approved primitive order and point count are part of the response
boundary. Flutter must also verify that the accepted response matches all
reviewed selections in the initiating request before it may present the
result. A valid response for a different reviewed attempt fails closed.

### Current Validation Boundary

Synthetic tests establish software, contract and math behavior only. The
deterministic 100-frame review subset is prepared without pose inference and
remains `awaiting_human_annotation`. No real conditional detection coverage or
coach-useful attempt result is approved until reviewed labels/selections exist.

### Implementation Status

- Python contracts, math, pose adapter, internal pure evaluation function and
  public reviewed-video selected-frame endpoint are implemented. Client pose
  observations are not exposed as a public API input.
- Human annotation draft/final schemas and conditional evaluator are
  implemented. Annotation schema `1.1.0` binds source/artifact hashes,
  source-timebase rows and canonical review-image references. Detection
  evaluation schema `1.2.0` adds broad diagnostic slices plus four mutually
  exclusive occlusion/crossing strata that must partition all-frame counts.
- Offline CSV frame-label entry preserves immutable evidence columns and blank
  labels, writes only a new validated draft and refuses overwrite.
- Integer frame/time/count evidence is strict and cannot be supplied through
  boolean or floating-point coercion.
- Path readiness also requires every review JPEG to exist, decode and match the
  source-video dimensions before a completed draft can be finalized; artifact
  evaluation is required to invoke the same gate.
- Annotation manifests, reports, evaluation outputs, CSVs and merged drafts use
  create-new semantics and cannot silently replace existing work.
- Role-neutral Track A/B remains evaluation-only; collision/switch diagnostics
  do not establish tracking accuracy or automatic Tori/Uke identity. Reference
  rows stay `human-reviewed`; predicted associations stay `AI-inferred`.
- Flutter reviewed-request/HTTP service, parser, fail-closed boundary, result
  card and blue overlay are implemented.
- Python and Flutter enforce exact normalized BLUE geometry, and Flutter binds
  the response to the current reviewed request before presentation.
- The existing Uchi Mata Analyze video/camera state now reaches the typed
  reviewed-video service through a bounded manual reviewer/development panel.
  Mandatory human gates are validated before submission, exactly four approved
  metrics are accepted, and the independent V1 path remains unchanged.
- This implementation does not authorize automatic frame, identity, role, leg
  or phase inference. The first reviewed real attempt and a polished review UX
  remain pending.

### Implementation Update - 2026-08-10

This update implements the previously approved JM-DEC-022 product-presentation
path; it does not create a new architecture or scientific decision. Flutter
requires the existing reviewed attempt, human-confirmed Tori neutral
track/detection, support leg, attacking leg, angle frame/event and camera gates,
then sends the selected video to the existing multipart V2A endpoint. The
response must match the initiating video and every reviewed selection before
the four-metric card and BLUE layer can render.

The response boundary continues to require
`multi_person_evidence_status = insufficient` and
`multi_person_interaction_metrics_reportable = false`. Returned
`review_required` and `withheld` states are preserved. JM-DEC-024, JM-DEC-025,
RTMPose-M, detector thresholds, metric formulas/versions and production
provenance are unchanged. No tracker or new inference path is connected.

### Required Documentation Updates

- `ARCHITECTURE.md`
- `PRODUCT_REQUIREMENTS.md`
- `PROJECT_STATUS.md`
- `CHANGELOG.md`
- `UCHI_MATA_SCIENTIFIC_METRICS_V1.md`
- `SINGLE_ATTEMPT_UCHI_MATA_V2A_RUNBOOK.md`
- `UCHI_MATA_HUMAN_ANNOTATION_GUIDE_V1.md`


## JM-DEC-023 ? Attempt-Stable Subject Identity and Event-Scoped Technique Roles

### Decision

Subject identity is stable within a reviewed attempt, while technique roles are
assigned at the event level.

A subject reference such as `subject-1` or `subject-2` identifies the same
human participant throughout the reviewed attempt when human continuity can be
verified.

Technique roles must not be encoded as permanent subject identity.

### Event Model

Each technique event may independently define:

- `actor_subject_reference_id`
- `target_subject_reference_id`
- `event_role`
- `technique_reference`
- human/model provenance as applicable

Supported event roles may include, without implying automatic classification:

- `initial_attack`
- `follow_up_attack`
- `combination_attack`
- `counter_attack`

An attempt may therefore contain more than one technique actor.

Example:

- Event 1: `subject-1` performs the initial attack against `subject-2`.
- Event 2: `subject-2` performs a counter attack against `subject-1`.

The identity references remain stable while actor/target roles change by event.

### Tori / Uke Boundary

`Tori` and `Uke` are contextual technique roles and must not be used as
persistent tracking identities.

For simple reviewed technique demonstrations, a human-confirmed subject may be
presented as Tori for the selected event.

For competition sequences, combinations and counters, the canonical data model
must use event-scoped actor/target relationships rather than one permanent Tori
for the complete attempt.

### Prohibited Identity Heuristics

The following must never establish Tori/Uke or technique actor identity by
themselves:

- belt color
- judogi color
- left/right image position
- detection order
- track index
- body size
- camera-side position

Such visual properties may only be reviewer context for a specific recording
and must never become cross-video identity rules.

### Ground-Truth Consequence

For the current reviewed Uchi Mata attempt:

- attempt boundary: `70.000-75.000 s`
- start: frame `1750`, timestamp `70000 ms`
- end: frame `1875`, timestamp `75000 ms`
- selected event performer was human-confirmed
- support leg was human-confirmed as `right`

The temporary `subject-2` reference belongs only to this annotation set and
must not carry meaning into another video.

### Scientific Boundary

Automatic attack/counter-attack classification is not authorized by this
decision.

This decision defines the data architecture only. Automatic role inference
requires separate validation and provenance gates.



## JM-DEC-024 ? Evidence-First Close-Contact Detection Bottleneck

### Decision

RTMPose-M remains the current single-camera pose baseline.

The primary Run 01 multi-athlete bottleneck is assigned to the upstream
person-detection/proposal stage during close-contact judo, not to RTMPose-M
pose estimation as a whole.

This decision is based on a reproduction-controlled diagnostic using the
original benchmark video, original YOLOX-M + RTMPose-M models, original input
sizes, current benchmark threshold `0.30`, and the benchmark rule requiring
at least 8 qualifying keypoints.

### Reproduction Gate

Representative failure samples reproduced the historical benchmark counts:

- reproduction result: `12/12 PASS`
- production code changed: `NO`

Selected deficit examples showed that most failures already contained only one
YOLOX detector box for two human-visible judoka.

Two selected deficit frames (`#020`, `#049`) contained two detector boxes but
only one benchmark-valid pose, establishing a secondary downstream pose-quality
failure mode.

The complete-dropout example `#039` produced one detector box and zero
benchmark-valid poses.

All selected surplus examples (`#007`, `#031`, `#082`, `#099`) already
contained surplus detector boxes.

### Engineering Boundary

The next intervention must be detector-side and bounded.

RTMPose-M pose estimation is not replaced at this stage.

No claim is made that NMS specifically causes the failure, because pre-NMS
detector proposals have not been evaluated.

No additional diagnostic chain is authorized before the next bounded
detector-side engineering experiment.

### Scientific Boundary

This evidence concerns person detection/proposal and pose-count filtering only.

It does not validate:

- athlete identity
- Tori/Uke inference
- technique recognition
- pose/keypoint accuracy
- biomechanics
- 3D reconstruction
- kinetics



## JM-DEC-025 - Production Non-Approval of the Experimental Greedy-IoU Identity Tracker

Date:

2026-08-10

Status:

Approved

Category:

Scientific Evaluation, Identity Architecture and Production Integrity

### Context

The role-neutral identity contract and evaluation-only RTMLib 0.0.16
greedy-IoU adapter passed 29/29 synthetic/regression tests. Synthetic software
behavior does not establish real-video identity performance. A bounded human
mapping and native evaluation were therefore completed for Run 01 before any
production decision.

The reviewed interval spans 41,000-44,000 ms (`frames 1025-1100`) and contains
31 deterministic evaluation frames. The 10 FPS nearest-source-frame setting is
an engineering evaluation choice, not a scientific sampling-rate claim.

### Decision

The current `ExperimentalRTMLibIoUTracker` is not approved for production and
must not be integrated into Single Attempt V2A.

It may remain available as an evaluation-only baseline. Reconsideration
requires new evidence from a materially improved method and a separately
reviewed production-approval decision.

### Human Reference Gate

- All 34 detections were reviewed chronologically before tracker execution.
- The finalized mapping contains 15 `subject-1`, 5 `subject-2` and 14
  `unassigned` rows.
- Both subjects were human-visible across all 31 reviewed frames, producing 62
  subject-frame reference rows.
- Crossing, occlusion and reviewer notes were preserved.
- Tori/Uke was not used. Belt appearance was human-review context for this
  recording only and is not an identity rule.
- Human mapping SHA-256 is
  `ca13d810259778ed65816dd12efa43d4ed0200606e8f60a0da316a078739ec0a`.

### Reproduction Gate

The unchanged tracker ran only on the stored geometry artifact whose SHA-256
is `43a82584e8323e93c685056eb1edc45f4de008d549bafc367cc3401254d7b92e`.
The native environment used Python 3.12.10 and the installed RTMLib 0.0.16
package. Its result exactly reproduced the provisional tracker, conversion,
decision, event, assignment, observation and requested-metric outputs.

The evaluated tracker source SHA-256 is
`789507429c03530806435ae13c68fe0a50dad63d0144559599e85c59a6ebca2e`,
and the identity-contract source SHA-256 is
`ab091a8f61f9909f4f2c9bfc19be614ad67bc2366e55d00dc658451f32525746`.

The native result SHA-256 is
`f380e33d61a2b59c21426ff56392bb148fa972b23a8ab7f6adccb8f3ae39a97f`.

### Evaluation Result

- Assignment coverage: `4/62 = 6.45%`
- Identity switches: `1`
- Crossing identity switches: `1`
- Reappearance preserved / changed / unverified: `0 / 1 / 0`
- Detection-order changes: `0`
- Detection-order-change identity switches: `0`
- Track-assignment collisions: `0`
- Detection-assignment collisions: `0`
- Confidence coverage: `0.00%`

Sixteen `review_required` subject decisions were excluded from assigned
coverage. Association confidence remained unavailable and was not invented.

### Rationale and Boundary

The 6.45% assignment coverage is inadequate for a production identity layer.
The one scored crossing switched identity, the one scored reappearance changed
identity, and confidence coverage is zero. Zero collisions and zero
detection-order changes cannot be interpreted as success under this coverage.

No tracking-accuracy, Tori/Uke, event-role, technique, phase, biomechanics, 3D
or kinetics claim is authorized. The production V2A pipeline remains unchanged
and multi-person interaction metrics remain non-reportable.

JM-DEC-024 remains governing: RTMPose-M is retained as the pose baseline, the
primary upstream problem remains second-person detector/proposal separation
during close contact, and detector score-threshold tuning remains closed unless
new evidence justifies reopening it.

### Required Documentation Updates

- `AI_DEVELOPMENT_RULES.md`
- `ARCHITECTURE.md`
- `CHANGELOG.md`
- `DECISION_LOG.md`
- `PROJECT_STATUS.md`


## Implementation Record - Uchi Mata Navigation Integrity (2026-08-11)

No new architecture decision ID was required.

Block 1 applies the existing fail-closed product and scientific-integrity
rules to the Uchi Mata technique-detail UI. `TechniqueSectionRouter` now owns
section availability, and Dashboard/Primary Actions mirror it. Unfinished
Training, Mastery/Progress, Sensi Bot and unverified Champions destinations no
longer open placeholder content; localized unavailable feedback is shown.

Media entries without approved sources no longer enter the player, dead media
card taps were repaired, and search-result URLs are not treated as direct
competition media. Existing real destinations, Favorite state, Quiz behavior,
V1 pose summary and reviewed four-metric V2A Analyze remain intact.

This implementation does not revise JM-DEC-024 or JM-DEC-025 and makes no
tracker, detector, identity, inference, metric, provenance or scientific claim
change.


## Implementation Record - Uchi Mata Approved Content Integrity (2026-08-11)

No new architecture decision ID was required.

Block 2 applies existing source-of-truth, localization, Design System and
fail-closed rules to approved Uchi Mata educational content. A field-level
resolver now supplies immutable canonical/localized content to shared section
widgets. Widgets no longer contain generic Overview filler or reinterpret
general key points, search-result URLs, combinations or counters as evidence
for a more specific capability.

Technical Analysis is complete for the currently approved structured dataset.
Tactical and Competition remain explicitly incomplete because dedicated
tactical scenarios, competition analysis and direct approved competition media
are absent. Biomechanics remains an educational visualization prototype and
now states its scientific limitations. The 10 approved Quiz records and three
concrete IJF/Kodokan/EJU references are preserved; missing Persian Quiz content
is not synthesized.

This record does not revise JM-DEC-024, JM-DEC-025 or any V1/V2A metric,
formula, provenance, identity, tracker or detector policy. It does not approve
Media, Training, Shadow Training, Conditioning, Progress/Mastery, Champions or
Sensi Bot, and it does not authorize Block 3.


## Implementation Record - Reusable Technique Template Proof (2026-08-11)

No new architecture decision ID was required.

Block 3 validates the existing model-driven Technique Detail architecture.
Reusable educational widgets consume the supplied model and support variable
or empty structured content. Quiz counts are model-derived, and the primary
Analyze action no longer embeds the Uchi Mata name.

Reviewed Single-Attempt V2A is represented by an explicit model capability
that defaults to unavailable. The approved Uchi Mata reference enables the
capability; a technique name or ID is not an authorization mechanism. The Uchi
Mata analysis entry remains unchanged; generic non-Uchi detail is subsequently
governed by the no-analysis boundary in JM-DEC-031.

A neutral synthetic fixture was used only in targeted tests because no second
dataset was treated as an approved reference for this proof. It was not added
to production content, navigation or localization. Existing Uchi-specific
visual-learning, Shadow Training and Conditioning prototypes remain known
out-of-scope template gaps.

This implementation does not revise JM-DEC-024, JM-DEC-025, the four V2A
metrics, formulas, versions, provenance, multi-person evidence, interaction
reportability, identity/tracker status or detector configuration.


## JM-DEC-026 - Local Reviewed V2A Attempt-Summary Persistence

Date:

2026-08-12

Status:

Approved

Category:

Local Persistence, Scientific Provenance and Product Integrity

### Context

The reviewed Single-Attempt V2A workflow can now produce a scientifically
bounded four-metric result, but the project has no approved History/Profile or
Progress UI. A minimal local foundation is needed to preserve eligible results
without implying athlete scoring, cloud history, identity automation or
scientific promotion.

### Decision

Judo Mind may persist one immutable versioned local summary only after an
explicit user save action. The current local record schema is `1.0.0` and uses
a dedicated SharedPreferences key separate from general user preferences.

The record preserves the stable analysis ID, source response schema, technique
and scientific mode, reviewed attempt/event/camera binding, human-confirmed
neutral-track and limb selections, each of the four metric IDs with its
unchanged value, unit, status, provenance, method version, confidence evidence,
limitation and withheld reason, the multi-person evidence/interaction boundary
and `savedAtUtc`.

The record must not contain video bytes, video IDs, paths, filenames, images,
BLUE overlays, frame-local detection indices, aggregate scores,
mastery/completion, trends or Profile data. Eligibility means V2A contract
integrity, not successful athletic performance; `review_required` and
`withheld` remain unchanged.

Malformed storage and unsupported schema/status/provenance fail closed and are
not silently overwritten. Stable analysis IDs are deduplicated and records use
deterministic ordering. UI state must distinguish saved, already saved and
failure.

### Boundary

This is local/demo-only storage. It does not implement a History screen,
Athlete Profile, Progress/Mastery, backend persistence, authentication, account
sync, cloud backup, aggregate evaluation or coaching trend. V1, V2A scientific
formulas and result card/BLUE overlay, JM-DEC-024, JM-DEC-025, detector/tracker
policy and interaction reportability are unchanged.

### Required Documentation Updates

- `AI_DEVELOPMENT_RULES.md`
- `ARCHITECTURE.md`
- `CHANGELOG.md`
- `DECISION_LOG.md`
- `PROJECT_STATUS.md`

## JM-DEC-027 - Platform Framework, Canonical Modules and Governance Foundation

Date: `2026-08-13`

Status: `Approved`

Category: `Product Architecture, Information Architecture and Governance`

### Decision

Judo Mind is governed as a trusted multilingual Judo Intelligence Platform
across Athlete App, Coach Workspace, Club/Federation Console and Judo
Intelligence Core.

The product has exactly 18 official modules. The authoritative code registry
is `JudoMindModules.modules`; module registration and module availability are
separate. An unfinished/deferred module has no route and must not be activated
by a placeholder screen or misleading action. The current Athlete Home is a
derived registry subset, not an 18-tile catalog.

The canonical product intent and module names are preserved in
`docs/JUDO_MIND_PRODUCT_FRAMEWORK.md`, ending with Module 17 App Management &
Settings and Module 18 Training Program Validator. The canonical code registry
governs runtime identity and availability; `ARCHITECTURE.md` governs technical
structure; `AI_DEVELOPMENT_RULES.md` governs implementation/scientific rules;
`DECISION_LOG.md` governs accepted decisions; `PROJECT_STATUS.md` governs
validated current state; and `CHANGELOG.md` records completed changes.
JM-DEC-002 remains the
historical 17-module baseline. JM-DEC-020 added the eighteenth boundary; this
decision aligns the agreed name and role without creating another module.

Technique Analysis (one attempt), Training/Drill Analysis (multiple
repetitions) and Competition Analysis (full match) remain shared capabilities,
not modules.

### Localization Decision

Completed selected-language experiences must not silently mix English into
Persian or Persian into English. Japanese technique names may accompany the
selected language. RTL includes directional layout/interaction behavior. A
missing translation is an explicit incomplete/unavailable state, not completed
localized content.

### Reference and Foundation Decision

Uchi Mata Gold is the current product-critical reference definition. Future
Shadow, Strength & Conditioning and Resistance-Band content uses one typed,
empty-by-default `TechniqueModel` contract and cannot activate without approved
localized content, media, safety, source and prescription evidence. The
foundation does not author any Uchi Mata drill.

The repository proves 51 semantic icon IDs and no exact approximately-120
taxonomy. The missing historical taxonomy must not be invented. Icon design is
deferred to a separate reviewed mission.

### Validated Training-Foundation Implementation Note — 2026-08-13

The existing typed training decision is implemented through distinct Shadow,
Strength & Conditioning and Resistance-Band renderers. Availability is derived
only from complete approved kind-specific data resolved in the selected
language. Missing movement/media, prescription, safety, anchor or localization
evidence fails closed. Test-only fixtures prove renderer behavior; Uchi Mata
production training content remains empty/unavailable. This note implements
the existing decision and does not create a new product or scientific decision.

### Risk and Priority Boundary

Sensi Bet remains isolated/deferred pending legal, age, ethical and
federation-brand review. Automatic Identity remains frozen and detector
threshold tuning remains closed. No scientific metric, V1/V2A behavior or
provenance is changed. Debug build/install evidence is not release readiness.

### Required Updates

- `AGENTS.md`
- `docs/AI_DEVELOPMENT_RULES.md`
- `docs/ARCHITECTURE.md`
- `docs/PRODUCT_REQUIREMENTS.md`
- `docs/CHANGELOG.md`
- `docs/PROJECT_STATUS.md`
- `docs/JUDO_MIND_ICON_SYSTEM_AUDIT.md`
- `docs/JUDO_MIND_PRODUCT_FRAMEWORK.md`

### Validated Uchi Mata Gold Learning-Experience Implementation Note — 2026-08-13

The existing product framework is now expressed in Technique Detail as the
five journeys Learn, Train, Analyze, Track Progress and Connect with Coach.
Technical progression, Biomechanics, Mistakes & Safety and Combination/Counter
flows use distinct evidence-bound presentation. Track Progress reuses local
analysis History; unavailable Coach and training capabilities fail closed.

This is an implementation record under JM-DEC-027, not a new product or
scientific decision. It does not alter official module identity, V1/V2A,
scientific metrics, production provenance, detector/tracker policy or the
automatic-Identity freeze.

### Validated Home Navigation De-duplication Note — 2026-08-13

The five Athlete Home journeys now have distinct semantic boundaries: Learn
opens Techniques; the explicitly Uchi Mata-scoped Analyze entry opens the
existing reference V1/V2A workflow; Track Progress opens the existing local
scientific History through a destination separate from the Profile editor;
and Train/Coach remain unavailable. Hero uses real local History when present,
otherwise the reusable featured/reference-technique source.

The registry-backed directory keeps all 18 identities, presents the four real
destinations first, groups by approved platform-surface metadata and collapses
the 14 closed entries. Home is current rather than a self-navigation action.
This clarifies and implements JM-DEC-027; it creates no new Decision ID, module,
storage contract, route for an unavailable module or scientific behavior.

## JM-DEC-028 - Deterministic Grounded Sensei V1

Date: `2026-08-13`

Status: `Approved and Validated`

Category: `Explanation Architecture and Scientific Presentation`

### Decision

Grounded Sensei V1 is a deterministic local explanation layer over one exact
human-reviewed Uchi Mata V2A request/result. It is not open generative AI and
does not call a network service, use a prompt or perform model inference.

The typed binding requires the explicit reviewed-V2A technique capability,
scientific contract identity `uchi-mata`, exact reviewed request match,
supported English/Persian locale, insufficient/nonreportable multi-person
evidence and exactly one each of `UM-TIM-001`, `UM-ANG-001`, `UM-ANG-002` and
`UM-ANG-003`. Any mismatch fails closed.

The explanation preserves metric values, statuses, provenance, confidence
availability and method versions. It may localize bounded relevance and
approved selected-language safety, but cannot create performance ratings,
confidence, identity, phase, leg-role, interaction, 3D or kinetics claims. No
metric-to-drill mapping is approved, so next action is unavailable.

### Integration Boundary

The scientific result and BLUE overlay are primary and remain visible on
Sensei failure. Local History continues to store the original V2A summary; no
new persistence schema is introduced. V1, V2A formulas and versions,
JM-DEC-024/JM-DEC-025/JM-DEC-026, detector/tracker behavior and the automatic
Identity freeze remain unchanged.

### Validated App Management & Settings Local MVP Note - 2026-08-14

The existing App Management & Settings identity now exposes only verified
local/demo behavior: persistent English/Persian locale selection, real local
History count, explicitly confirmed History-only deletion and concise
scientific-capability transparency sourced from approved contracts. Profile and
language storage remain independent, and unsupported platform preferences are
not represented as functional controls.

This is an implementation record under the existing product, localization,
local-storage and scientific fail-closed rules. It creates no new Decision ID,
scientific formula, persistence schema, cloud/account capability or module
identity. V1/V2A, Grounded Sensei, detector/tracker/Identity policy and the
canonical 18-module registry remain unchanged.

### Validated Scientific Progress Evidence Foundation Note - 2026-08-14

The existing Monitoring / Progress & Mastery module now exposes a distinct
foundation-only Progress Overview derived from the existing versioned local
V2A History. It reports only exact evidence counts, latest timestamp,
technique/method-version context and chronological stored attempts. Unknown or
invalid evidence and incompatible versions fail closed; values are not compared.

This implements the already approved separation between honest progress
evidence and scientifically unvalidated Mastery, so no new Decision ID is
created. Mastery, scoring, ranking, readiness, proficiency, trends and coaching
claims remain unavailable. Home Track Progress remains the raw Local Analysis
History route. V1/V2A formulas and versions, `UM-ANG-001`, provenance,
multi-person/interaction boundaries and detector/tracker/Identity policy are
unchanged.

### Validated Technique Journey Content-Ownership Note - 2026-08-14

The Uchi Mata reference hub now applies one user-facing owner per approved
content field and one technique-local Single-Attempt Analyze entrance. Overview,
Technical Lesson, Mistakes & Safety and Combinations & Counters are disjoint;
Practice, tactical and competition fail closed rather than borrowing learning
content. Grounded Sensei remains post-result only, and secondary destinations
are collapsed under a More group.

This is an implementation record under the existing product, localization and
scientific fail-closed decisions, so no new Decision ID is created. It does not
change V1/V2A, metrics or versions, provenance, detector/tracker/Identity,
History, Home Analyze or the canonical 18-module registry.

### Validated Natural Persian UX Convergence Note - 2026-08-15

The existing English/Persian localization contract now covers the reachable
Home, Techniques, Uchi Mata, Analyze, Result, History, Progress and Settings
journey with athlete-facing Persian. Canonical taxonomy, filter and provenance
values remain stable in storage and scientific contracts and are localized only
for presentation. The 10 Uchi Mata Quiz items now have explicit Persian records;
incomplete Persian media remains unavailable rather than falling back to
English.

Engineering identifiers, versions and detailed confidence/limitation evidence
remain inspectable behind collapsed scientific-details controls. Visible metric
statuses and fail-closed boundaries are unchanged. This implements the approved
localization and scientific-presentation rules and creates no new Decision ID,
formula, metric version, provenance, identity behavior or product capability.

### Validated Full Persian Runtime Contract Closure Note - 2026-08-15

The English/Persian runtime localization contract now has exact `475/475`
message coverage. Of the previous 261 untranslated messages, only `profile`
and `retry` were reachable legacy aliases; both were remapped to existing
approved Persian messages. The remaining 259 had no typed project runtime
consumer and were retired rather than bulk translated or allowlisted.

The exact inventory and seven-way classification are preserved in
`docs/PERSIAN_LOCALIZATION_AUDIT_V1.md`. This is an implementation record under
JM-DEC-027 and the approved localization rules, not a new Decision ID. It does
not alter the 18-module registry, routes, product availability, V1/V2A,
Grounded Sensei, metrics, provenance, BLUE, detector/tracker/Identity policy or
any scientific claim.

### Validated Non-Visual Device-Validation Reliability Note - 2026-08-15

The canonical detached PowerShell v3 runner replaces no historical artifact;
v1/v2 remain preserved as failure evidence. V3 normalizes scalar results,
avoids assignment to read-only `$PID`, uses native exit codes, classifies ADB
states deterministically, enforces one build attempt and preserves the existing
memory/APK/install/launch/logcat/capture/Git gates.

SyntaxCheck and synthetic SelfTest pass with exit code zero and no Git-state
change. No Android build or device command was executed. This is a validated
implementation/process note under existing release-readiness and preservation
rules; it creates no Decision ID and changes no product, module, scientific,
V1/V2A, detector/tracker/Identity or provenance boundary.

### Validated Runtime Truthfulness Closure Note - 2026-08-15

The current local catalog distinguishes five bundled technique records from one
production-available Uchi Mata Gold experience, four closed incomplete previews
and the separate 67-technique roadmap. Preview records cannot open Technique
Detail and do not display an unsupported secondary taxonomy. Missing media has
no active play/open route; the existing educational biomechanics visualization
is explicitly not a measurement; root organization URLs are presented as
general references.

This is an implementation record under JM-DEC-027 and the existing scientific,
localization and Uchi Mata Gold decisions. It creates no new Decision ID and
does not alter V1/V2A, Grounded Sensei, metric formulas or versions, provenance,
detector, tracker, Identity, training prescriptions, icons or module identity.

### Validated Athlete Information Architecture Convergence Note - 2026-08-15

The five athlete journeys remain unchanged, while the current Athlete Home
prioritizes four real working actions and presents unavailable Train and Coach
compactly as `Coming later`. Progress Overview owns evidence summary and the
onward History route; empty Progress opens the existing reviewed Uchi Mata
Analyze boundary. Technique Detail preserves one Analyze action and consolidates
future actions. Platform Overview remains derived from the exact 18-module
registry and uses athlete-facing availability wording.

This is an implementation record under JM-DEC-027 and existing product/runtime
truthfulness decisions, not a new Decision ID. It changes no scientific metric,
version, provenance, V1/V2A, detector, tracker, Identity, training prescription,
icon system or module identity.
## JM-DEC-029 — Evidence-Driven Polyglot and Cross-Platform Engineering Policy

**Status:** Accepted
**Date:** 2026-08-24

### Decision

- Flutter/Dart remains the primary shared client technology for Android, iOS
  and Windows.
- Python remains appropriate for AI, video analysis and scientific
  computation.
- Kotlin/Java, Swift/Objective-C, C#/WinRT and C++/Rust may be introduced only
  for an evidenced platform or performance requirement.
- More programming languages do not automatically mean higher quality.
- Every new technology requires documented need, measurable benefit, security
  implications, Build/test method and maintenance ownership.
- Packages must be audited for target-platform support, and OS-dependent
  features must sit behind interfaces/adapters.
- Success on one platform does not validate another. Android, iOS and Windows
  require independent real Build and QA evidence; iOS must not be reported
  validated without a real macOS/Xcode Build.
- Rewriting the existing Flutter client without technical evidence is
  prohibited. Current platform validation must always be reported honestly.

### Consequences

The current architecture remains Flutter/Dart plus Python. New technology and
platform claims require an explicit evidence record rather than preference or
language count.

## JM-DEC-030 — Shared HPS Crosswalk and Independent Judo Scientific Gate

**Status:** Accepted
**Date:** 2026-08-28
**Category:** Scientific evidence governance

### Context

Judo Mind may discover a source that is also registered in the read-only Iran
HPS Scientific Library. File presence, identifier overlap or an HPS project
decision cannot by itself establish Judo applicability, a product rule, a
threshold or scientific approval.

### Decision

- Shared HPS sources may be reused only through a read-only crosswalk based on
  an existing SHA-256, verified DOI, PMID, ISBN or sufficiently exact normalized
  title/author/year evidence.
- Existing `HPS-SRC-*` identifiers are preserved. Source files are not copied,
  moved, renamed or modified as part of the crosswalk.
- HPS evidence, rule, threshold or product approval never transfers to Judo
  Mind. Every Judo claim requires independent applicability review by the
  relevant scientific and Judo-domain reviewers.
- Implementation, a passing software test, an engineering evaluation, human-
  reviewed ground truth and scientific validation are separate states. None
  automatically upgrades another.
- Scientific capabilities fail closed. Until their own evidence and review
  gates are satisfied, sensitive capabilities remain `LOCKED`,
  `REVIEW_REQUIRED` or `VALIDATION_ONLY`.
- JM-S0.1 inventories describe current evidence and gaps only. They do not
  approve a source, claim, metric, threshold, rule, prescription or capability,
  and they do not enable production behavior.

### Consequences

Future scientific-foundation work must retain auditable source and claim
provenance, record unmatched or ambiguous crosswalks explicitly, prohibit
approval inheritance and keep production eligibility separate from scientific
review. Unknown or incomplete evidence remains withheld rather than inferred.

## JM-DEC-031 — Specialized Uchi Mata and Fail-Closed Generic Technique Routing

**Status:** Accepted
**Date:** 2026-09-02
**Category:** Product routing and educational-content safety

### Context

The 67-technique roadmap currently has five runtime models, one production-open
Uchi Mata Gold reference, four incomplete previews, and 62 missing canonical
identity/model records. The former shared Detail surface could expose a generic
Analyze entry if a non-Uchi catalog lock were bypassed. A working route alone
cannot establish content readiness or scientific/product approval.

### Decision

- Technique Detail uses an exact-ID, exactly-one-record route decision before
  rendering.
- ID `001` retains the specialized Uchi Mata path and its existing scientific
  transparency and validation-only boundaries.
- Eligible non-001 records use a separate generic read-only educational
  adapter/screen with no science, analysis, metrics, scoring, mastery,
  diagnosis, prediction, prescription, media, or future action.
- Non-001 eligibility is an explicit fail-closed set backed by the readiness
  registry. It cannot be inferred from model fullness, route success, name,
  display order, or a test fixture.
- Missing selected-language fields remain unavailable rather than silently
  completed by another language.
- Malformed, unknown, duplicate, missing-model, and non-eligible identities
  remain locked.

### Consequences

JM-S1.1-B closes the shared route/model defect but unlocks zero techniques.
IDs `002–005` remain content-remediation-required and the other 62 remain
route/model-blocked until an approved canonical registry exists. This decision
creates no scientific approval, rule/threshold eligibility, AI capability,
production permission, or technique content.

## JM-DEC-032 — Bilingual Technique Explanation Content Standard

**Status:** Accepted
**Date:** 2026-09-02
**Category:** Product content architecture and scientific presentation

### Context

The generic route/model foundation reused existing educational fields but had
no governed contract for structured phase/start/follow-through data, canonical
linked IDs, accessible media rights/provenance, statement-level scientific
classification, or distinct technical/scientific review state. Filling those
gaps with inferred free text, copied design material or a second technique
model would violate content, copyright and scientific boundaries.

### Decision

- Adopt the 18-section English/Persian structure in
  `JM_TECHNIQUE_EXPLANATION_CONTENT_STANDARD_EN_FA.md` for future official
  technique authoring.
- Keep `TechniqueModel` canonical and add only an optional gap-only
  `TechniqueExplanationExtension`, defaulting to unavailable.
- Separate route readiness, content readiness, technical review, scientific
  review and analysis capability. None is inferred from another.
- Require explicit `CONCEPTUAL`, `OBSERVED`, `MEASURED`, `RECONSTRUCTED`,
  `MODEL_ESTIMATED` or `AI_INFERRED` classification, plus method/limitations
  and evidence/review provenance before evidence-sensitive display.
- Require original/project-owned, licensed, or permission-recorded visual and
  video material with provenance and accessibility. External inspiration
  image/text is not reused and is not an official/scientific source.
- Use expandable EN/FA/RTL presentation with the exact conceptual-diagram
  disclaimer and hidden/locked unqualified biomechanical sections.

### Consequences

The reusable schema and UI foundation can support future governed content
without duplicating identity or weakening the Uchi Mata specialized boundary.
All production extensions and the non-Uchi eligibility set remain empty. This
decision creates no technique content, route unlock, final media, scientific
approval, rule, threshold, metric, prescription or AI/video-analysis
capability.

## JM-DEC-033 — Content-Free Canonical Technique Identity Registry

**Status:** Accepted
**Date:** 2026-09-02
**Category:** Catalog identity and route safety

### Context

The roadmap count was 67, but only IDs `001–005` had runtime models and the
other 62 positions had no project-owned canonical identity. Inventing full
models or treating list order as identity would create unsafe content and
route activation. Official IJF and Kodokan rosters also expose a bounded
67-versus-68 scope difference around Kani-basami.

### Decision

- Keep one 67-row provenance-aware CSV as the authoritative product identity
  registry and a tested content-free Dart projection for route safety.
- Preserve IDs `001–005`; classify the 62 deterministic mappings as
  `NORMALIZED_PENDING_HUMAN_CONFIRMATION`.
- Preserve the official-source roster conflict explicitly; do not silently
  assign, omit or approve the disputed identity through software.
- Keep identity, classification, Persian name, model availability, content,
  technical/scientific review, media rights, route and unlock independent.
- Require an exact unique resolved identity and existing model before checking
  explicit route eligibility. Every uncertain state fails closed.
- Keep all 67 registry rows `LOCKED`, the non-Uchi eligibility set empty, and
  ID `001` on its specialized path.

### Consequences

The catalog can audit names and foreign keys without fabricating technique
content. Human confirmation and full content review remain prerequisites for
future non-Uchi work. No technique, scientific approval, threshold, rule,
metric, media, AI/video-analysis behavior or production capability is enabled.

## JM-DEC-034 — Frame-Accurate Human Attempt Boundaries

**Status:** Accepted
**Date:** 2026-09-07
**Category:** Single-Attempt timing integrity

### Decision

- Replace millisecond-only Guided boundary submission with an expiring,
  server-owned decoded timing manifest and exact frame-index selection.
- Bind the manifest to `video_id` and SHA-256, preserve timestamp provenance,
  and reject stale, cross-video, tampered and out-of-range references.
- Require explicit human visual boundary confirmation; boundary/review changes
  invalidate confirmation.
- Require a separate versioned `SINGLE_ATTEMPT` assertion whose source is
  `HUMAN_CONFIRMED`; exact boundaries alone cannot establish that the interval
  contains only one continuous attempt.
- Keep `UM-TIM-001` as elapsed time between selected boundaries, but withhold
  physical duration for unknown/unreliable timing and apply a known time scale
  only when explicit.
- Preserve MediaPipe Heavy, all three angle formulas, V2A 2.0.0, identity and
  phase locks, BLUE geometry and the Grounded Sensei evidence boundary.

### Consequences

The selected attempt is auditable by decoded frames without claiming automatic
technique duration. The initial mobile slice supports explicit real-time or
unknown timing; numeric known-time-scale entry and raw container-PTS exposure
remain bounded follow-up debt. No D2-D8 capability is enabled.

P0 amendment: longer source videos remain allowed, but each analysis must bind
one human-confirmed continuous attempt to its exact manifest interval. The
system does not count, segment or automatically confirm attempts.

The prepared mobile review may return explicitly to boundary editing while
retaining the timing manifest and current frame selections. That transition
invalidates the old preview, both confirmations, prepared session, all
candidate/Tori/context review and downstream result/explanation state. It does
not infer a new boundary or create automatic segmentation.

## JM-DEC-035 — Frame-Local Multi-Person Candidate Evidence

**Status:** Accepted
**Date:** 2026-09-10
**Category:** Guided human-review evidence boundary

### Context

Guided PREPARE can receive more than one pose from the selected frame, but a
model-returned pose is not proof of a person, a temporal identity or a Judo
role. Treating detection order or visibility output as identity/confidence would
silently introduce tracking and scientific claims that D2 does not authorize.

### Decision

- Preserve `FrameCandidate != TemporalTrack != HumanRoleAssignment`.
- Record model-returned pose count separately from selectable candidate count.
  The former is not a people, judoka, track or identity count.
- Require at least two independent selectable pose-available frame candidates
  for `ready_for_human_selection`; one is insufficient and zero is explicitly
  non-selectable.
- Store candidate-set eligibility server-side and reject ANALYZE when it is not
  ready, independently of the Flutter state.
- Keep candidate tokens opaque and session-bound. PREPARE assigns no Track A/B,
  Tori/Uke, identity or temporal association.
- Expose only bounded pose/landmark/visibility-field availability with
  model-estimated provenance. Track ID and association confidence remain
  unavailable; visibility is not accuracy or scientific confidence.
- Allow the existing single-subject V2A adapter to use an analysis-local neutral
  label only after explicit human Tori confirmation of the exact stored pose.
  This label is not temporal tracking evidence.
- Preserve V2A 2.0.0, four metrics, formulas, BLUE geometry, timing, confidence
  semantics, automatic-identity lock and insufficient multi-person status.

### Consequences

D2 can present multiple frame candidates for explicit human selection without
claiming or implementing tracking, identity or role inference. Insufficient,
malformed, duplicate or forged evidence fails closed. D2 remains active until
real-device validation; this decision creates no scientific approval, automatic
athlete role, tracking, new metric, 3D/kinetic capability, score or coaching
truth.

## JM-DEC-036 — Human-First Tori Selection

**Status:** Accepted
**Date:** 2026-09-11
**Category:** Guided human-role confirmation

### Context

Frame-local model candidates preserve pose evidence but cannot establish Judo
role or athlete identity. The existing Guided path required a Tori checkbox and
session token but did not carry the human role decision as its own explicit,
auditable transport object.

### Decision

- Represent the Guided role decision as `role_assignment` with the fixed values
  `role=TORI`, `source=HUMAN_CONFIRMATION` and the selected opaque candidate
  token.
- Create no role assignment during PREPARE and select no candidate by default.
- Require explicit candidate selection followed by explicit human Tori
  confirmation; changing candidate invalidates that confirmation and all
  dependent review state.
- Resolve the candidate token only against the current server-owned review
  session. Missing assignments, AI-derived sources, identity fields and
  cross-session substitution fail closed.
- Permit clothing colour only as a visual human-selection aid, never as
  identity, tracking or role evidence.
- Preserve the existing V2A 2.0.0 schema and its human-confirmed subject
  projection; the ephemeral candidate token is not persisted in History.

### Consequences

The current Technique Intelligence path records who supplied the role decision
without claiming that AI detected Tori. This decision adds no automatic role,
identity, tracking, phase, metric, biomechanics, coaching truth or scientific
approval.

## JM-DEC-037 — Separation of Human-First Analysis Product Layers

**Status:** Accepted
**Date:** 2026-09-11
**Category:** Product and analysis architecture

### Context

Technique-specific analysis, competition evidence organization and paid human
coach review have different evidence, authority, privacy and commercial
boundaries. Combining them would allow engineering output to appear as tactical
or coaching truth.

### Decision

- Keep three independent layers: Technique Intelligence, future AI-Assisted
  Competition Timeline and future Coach Analysis Marketplace.
- Implement only the Human-First Technique Intelligence foundation in the
  current gate.
- Limit the future Competition Timeline to evidence organization followed by
  coach review; tactical judgment is not authorized.
- Defer marketplace, coach reports, payment and revenue sharing to separate
  product, privacy, safety, legal and commercial decisions.
- Apply the chain `Observation -> Evidence -> Human Confirmation -> Analysis ->
  Coaching Support` across all future analysis work.

### Consequences

No Layer 2 or Layer 3 runtime capability is created by this decision. Passing a
Layer 1 engineering gate cannot activate another layer or create scientific,
tactical, coaching, payment or federation readiness.

## JM-DEC-038 — Bounded VIDEO-Mode Context for D2 Review Evidence

**Status:** Accepted
**Date:** 2026-09-11
**Category:** Guided pose-engine context integrity

### Context

MediaPipe Pose Landmarker in VIDEO mode can return different pose evidence for
an isolated source frame than for the same frame after continuous preceding
frames. The correct Uchi Mata diagnostic video returned one pose for isolated
Frame 64 but two poses when bounded preceding context was supplied. The
minimum observed successful 15-frame pre-roll belongs to that one video and is
not a universal or scientific threshold.

### Decision

- Guided PREPARE uses an engineering-only maximum of 500 ms of contiguous
  preceding source frames to warm MediaPipe VIDEO mode.
- Clamp the context start to the human-confirmed attempt start and always end
  at the exact canonical Review Frame.
- Isolate the MediaPipe VIDEO context per Guided request while retaining the
  existing analysis lock and monotonic timestamps within that instance.
- Discard every warm-up result. Only the exact Review Frame may create preview
  or candidate evidence.
- Preserve `FrameCandidate != TemporalTrack != HumanRoleAssignment`, the
  two-candidate fail-closed gate, human-only Tori confirmation and all V2A
  scientific limits.

### Consequences

Guided PREPARE can provide the temporal context required by the existing model
without extending the reviewed attempt or converting warm-up frames into
analysis evidence. This decision creates no tracking, identity, phase,
multi-frame metric, scientific approval or universal pre-roll claim. D2 remains
active until positive real-device validation.

## JM-DEC-039 — Versioned Uchi-mata Gold Scientific Foundation

**Status:** Accepted
**Date:** 2026-09-11

### Context

Judo Mind needs a durable Uchi-mata Gold scientific structure before future
event, phase, measurement, reference-comparison or coaching work can proceed.
Existing source, claim, metric, gap and capability registries already own their
respective identities, so a new competing registry would create governance
drift. Schema existence must also never be mistaken for scientific or product
approval.

### Decision

Adopt `uchi-mata-gold-foundation-1.0.0` as an additive, non-production profile
for Product Technique ID `001` / scientific slug `uchi-mata`.

- Canonical source, metric and capability registries retain authority. Gold
  evidence rows link existing IDs or remain pending formal intake; Gold metric
  rows reference existing metric IDs.
- Observable events E0–E7 remain research-only, E4/E5 remain provisional and
  automatic detection is disabled.
- Source-specific phase operationalizations remain separate from universal
  Judo concepts; the seeded 2025 Approach/Turning/Throw mapping is not a
  universal Kuzushi/Tsukuri/Kake definition.
- Validation-gap colors have exact meanings, with no V1 green row and no
  automatic advancement.
- The interpretation-rule registry starts empty. Sensei can never convert raw
  video directly into a finding; future use requires an authorized structured
  finding and explicit evidence/uncertainty/abstention gates.
- Rights status is independent from evidence strength and scientific validity.
  No local copy, processing, training or commercial-training permission is
  granted in this decision.

### Consequences

The foundation can later map to Python, Flutter, V2A, tracking, event
annotation, reference comparison and Sensei without rewriting the validated
flow, but every integration requires a separate approved gate. This decision
creates no event/phase detector, automatic role/identity, tracker approval,
metric/formula change, score, correctness judgement, coaching rule, 3D or
kinetic output, scientific approval, media right or production capability.

D1/D2 fail-closed behavior remains unchanged. The D2 MediaPipe VIDEO-mode
lifecycle/reproducibility question remains visible, active and unresolved until
its separately governed positive real-device validation.

## JM-DEC-040 — Uchi-mata Evidence-to-Interpretation Separation

**Status:** Accepted
**Date:** 2026-09-11
**Category:** Scientific evidence and claim governance

### Context

The Gold foundation needs source-bound claims, applicability context and
measurement-validation planning without allowing official status, an elite
execution or generic markerless validation to become Uchi-mata truth.
JM-DEC-036 already governs human-first Tori selection, so the suggested number
in the GS-1 Work Order cannot be reused.

### Decision

- Require the chain `SOURCE -> CLAIM -> MEASUREMENT VALIDATION -> REFERENCE
  APPLICABILITY -> APPROVED INTERPRETATION -> COACHING`; no layer may be
  bypassed.
- Bind Gold scientific claims to canonical source IDs while retaining the
  existing product-content claim inventory and canonical metric/capability
  registries.
- Preserve complete population, execution, grip/Uke/body, camera/method,
  uncertainty, external-validity, rights and permitted-use context. Unknowns
  remain explicit.
- Treat official/expert/elite/volumetric sources as bounded references, direct
  studies as population- and method-specific evidence, and markerless studies
  as validation-design evidence unless direct Uchi-mata/current-JM validation
  exists.
- Keep the interpretation-rule registry empty and require Sensei to remain
  downstream of authorized structured findings.
- Keep every GS-1 claim, matrix, camera and acquisition row non-production;
  candidate or yellow status is not activation.

### Consequences

JM-UM-GS-1 provides traceable research planning without creating a scientific
approval, athlete threshold, universal ideal, score, automatic phase/role,
tracker, 3D/kinetic/injury output, technical interpretation, coaching rule or
media/data right. V2A, D1 and D2 are unchanged. D2 remains active/not closed
with its MediaPipe VIDEO-mode lifecycle/reproducibility debt visible.
