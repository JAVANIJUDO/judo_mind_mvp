# Judo Mind Software Architecture

## Document Information

Project:
Judo Mind Super App

Document:
Software Architecture

Version:
1.1

Status:
Approved Architecture Baseline

Last Updated:
2026-08-05

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

Provide consistent visual language across all 17 modules.

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
