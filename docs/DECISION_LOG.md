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
- `CHANGELOG.md`
- `PRODUCT_REQUIREMENTS.md`
- `AI_DEVELOPMENT_RULES.md`
- `UCHI_MATA_SCIENTIFIC_METRICS_V1.md`
