# Judo Mind Product Requirements Document

Version:

1.3


Status:

Active Development


Last Updated:

2026-08-13


---

# 1. Product Identity


## Product Name

Judo Mind Super App


## Product Type

Global Digital Judo Ecosystem


## Vision

Train Your Body, Master Your Mind.


## Mission

Create the most complete digital platform for Judo athletes,
coaches, clubs and federations by combining:

- Judo knowledge
- Sports science
- Artificial intelligence
- Athlete development
- Coaching tools
- Federation services


---

# 2. Product Goals


Judo Mind aims to:


- Digitize Judo knowledge.
- Improve athlete development.
- Support coaches with intelligent tools.
- Connect Judo communities globally.
- Provide federation-level digital services.
- Create a professional Judo learning ecosystem.


---

# 3. Target Users


## Athlete

Needs:

- Technique education
- Training plans
- Progress tracking
- Competition preparation
- Performance improvement


## Coach

Needs:

- Athlete management
- Training tools
- Technical resources
- Analysis tools


## Club

Needs:

- Member management
- Training organization
- Communication tools


## Federation

Needs:

- National systems
- Athlete databases
- Education platforms
- Analytics


## Fan

Needs:

- News
- Champions
- Competition information
- Judo content


## Administrator

Needs:

- Content management
- User management
- System control


---

# 4. Product Modules


Judo Mind consists of 18 modules.


---

# Module 1

## Home


Purpose:

Main user control center.


Requirements:

- Personalized dashboard
- Quick access cards
- News
- Recommendations
- Progress summary
- Subscription information


---

# Module 2

## Techniques — 67 Techniques


Purpose:

Create the world's most complete digital Judo technique database.


Requirements:


Each technique must include:


Identity:

- English name
- Japanese name
- Persian translation
- Classification
- Difficulty
- Belt level


Technical Content:

- Description
- Kuzushi
- Tsukuri
- Kake
- Execution steps
- Key points
- Common mistakes


Scientific Content:

- Biomechanics
- Movement analysis
- Force direction
- Muscle activation


Training Content:

- Shadow training
- Uchikomi
- Nagekomi
- Conditioning
- Mobility


Competition Content:

- Match examples
- Tactical application
- Combination
- Counter


Learning:

- Quiz
- Progress tracking


AI:

- Recommendations
- Personalized feedback


---

# Module 3

## Sensi Bot


Purpose:

AI Judo assistant.


Requirements:

- Technique questions
- Training suggestions
- Athlete feedback
- Personalized recommendations
- Knowledge assistance


---

# Module 4

## Sensi Bet


Requirements:

- Virtual competitions
- Predictions
- Challenges
- Engagement system


---

# Module 5

## Monitoring / Progress & Mastery


Requirements:

- Sleep tracking
- Fatigue tracking
- Body metrics
- Nutrition tracking
- Performance tests
- Athlete readiness


---

# Module 6

## AudioCast


Requirements:

- Podcasts
- Interviews
- Audio lessons
- Competition analysis


---

# Module 7

## Athlete Profile


Requirements:

- Athlete identity
- Biography
- Achievements
- Competition history
- Training timeline
- Statistics


---

# Module 8

## Training Center


Requirements:

- Technical education
- Physical preparation
- Mental preparation
- Tactical training
- Learning paths


---

# Module 9

## Champions Hub


Requirements:

- Champion profiles
- Career history
- Achievements
- Technical analysis


---

# Module 10

## Competitions & Challenges


Requirements:

- Competition information
- Online challenges
- Rankings
- Results


---

# Module 11

## News


Requirements:

- IJF news
- Federation news
- Athlete news
- Competition news


---

# Module 12

## Store & Subscriptions


Requirements:

- Subscription plans
- Premium content
- Digital products
- Payments preparation


---

# Module 13

## Club Administration


Requirements:

- Club profile
- Athlete management
- Coach management
- Attendance
- Reports


---

# Module 14

## Coach Forum


Requirements:

- Professional discussion
- Knowledge sharing
- Coach networking


---

# Module 15

## Online Courses


Requirements:

- Technical courses
- Coaching courses
- Refereeing courses
- Certificates


---

# Module 16

## Country Judo History


Requirements:

- National history
- Champions
- Federations
- Historical records


---

# Module 17

## App Management & Settings


Purpose:

Complete management system.


Requirements:


CMS:

- Content management
- Media management
- Translation management


User Management:

- Users
- Roles
- Permissions


System:

- Analytics
- Backup
- Logs
- Settings


---

# Module 18

## Training Program Validator

Purpose:

Evaluate an athlete- or coach-provided training plan as evidence-aware decision
support for Judo performance planning.

Required context:

- Training season or period
- Time remaining to competition
- Athlete context and declared constraints
- Evidence-based strength and conditioning
- Physiology
- Recovery and training-load principles
- Judo-specific requirements
- Academic or primary scientific evidence

Required analysis behavior:

- Identify elements supported by the available context and evidence.
- Identify questionable, risky or internally inconsistent elements.
- Explain the reasoning and relevant uncertainty.
- Propose alternatives only when justified.
- Cite evidence and preserve the provenance of each conclusion.
- Avoid claiming that one training plan is universally correct.
- Distinguish sport-performance guidance from medical diagnosis.
- Refer medical symptoms, diagnosis and treatment decisions to qualified health
  professionals rather than inferring them from a training plan.

Scientific and product boundary:

- Plan-review findings and recommendations are `AI-inferred` unless a specific
  result has a different defensible source classification.
- Athlete-reported context is self-reported input and must not be relabelled as
  a direct physiological measurement.
- The module must show limitations and must not automatically alter or prescribe
  a plan without an explicit future product decision and appropriate safeguards.
- This requirement formalizes the module only; Flutter UI and backend
  implementation are not part of the current milestone.

---

# Platform Framework and Product Position

The canonical long-term product charter is
`docs/JUDO_MIND_PRODUCT_FRAMEWORK.md`. This requirements document may refine
bounded product requirements but must not create a conflicting module list,
platform boundary or completion claim. Runtime availability belongs to the
canonical code registry and validated current capability belongs to
`docs/PROJECT_STATUS.md`.

Judo Mind is a trusted multilingual Judo Intelligence Platform connecting
structured technique education, scientifically governed video analysis,
athlete development history, AI-guided explanation and
coach/federation workflows.

The platform coordinates four surfaces:

1. Athlete App
2. Coach Workspace
3. Club/Federation Console
4. Judo Intelligence Core

The 18 official modules are distributed across these surfaces and must not be
represented as 18 equal-weight Athlete Home tiles. The future Athlete Home
information architecture prioritizes five journeys: Learn, Train, Analyze,
Track Progress and Connect with Coach.

Technique Analysis (one attempt), Training/Drill Analysis (multiple
repetitions) and Competition Analysis (full match) are cross-module analysis
capabilities. They do not increase the official module count.

The competitive moat is the governed connection of structured 67-technique
knowledge, scientifically bounded video analysis, grounded AI Sensei
explanations, longitudinal athlete progress, athlete-coach-club-federation
workflows and multilingual content/governance. This positioning is a product
direction, not a claim of market leadership or production readiness.

Sensi Bet remains isolated and deferred pending legal, age, ethical and
federation-brand review.

# Localization Completion Contract

- Selecting Persian requires Persian user-facing UI and approved content for a
  completed production experience; selecting English requires English.
- Japanese technique names may remain Japanese alongside the selected-language
  explanation.
- The contract covers UI labels, structured technique content, Quiz, Sources,
  validation errors, analysis results, safety messages and future grounded AI
  Sensei output.
- RTL covers layout, navigation direction, directional icons, charts and
  interaction order, not text alignment alone.
- Silent English fallback must not be presented as completed Persian content.
  Missing or untranslated material remains explicitly incomplete or
  unavailable until approved.

# Uchi Mata Gold Reference Definition

The complete Gold Reference target includes approved overview/technical
content; Kuzushi/Tsukuri/Kake; execution steps; key points, mistakes and
safety; combinations/counters; licensed media and visual learning;
technique-specific biomechanics; Shadow Training; Strength & Conditioning;
Resistance-Band Training; visual/video Quiz; V1 and reviewed V2A; grounded AI
Sensei explanation; local History and Progress; and complete English/Persian
experiences.

Every educational destination requires a distinct primary visual artifact.
Renaming or reusing one generic stick-figure animation across destinations is
not completion evidence. The target definition does not mark missing media,
training, Progress, AI Sensei or Persian content as implemented.

# 5. Global Product Requirements


## Multi Language

The product must support:

- English
- Persian
- Japanese
- French
- German
- Spanish
- Russian
- Arabic


## Content Management

All major content must be editable without code:


- Text
- Images
- Videos
- Audio
- Courses
- Techniques
- News


## Security

Requirements:

- Secure authentication
- User privacy
- Permission management
- Protected data


## Scalability

The product must support:

- Athletes
- Coaches
- Clubs
- Federations
- Global expansion


---

# 6. Business Requirements


Future business models:


- Subscription
- Club licenses
- Federation licenses
- Premium education
- Sponsorship
- Advertising


---

# 7. Success Criteria


Examples:


- Global athlete adoption
- Federation partnerships
- Professional coach usage
- High quality Judo knowledge base
- Sustainable business model


---

# 8. Product Development Rule


No major feature should start development unless:


- Product requirement is defined.
- Architecture location is clear.
- User value is understood.
- Documentation is updated.

# Reference Technique Product Requirement

## Product Reference

Technique:
Uchi Mata

Role:
Official reference implementation for all 67 techniques.

## Completion Criteria

Uchi Mata is considered complete only when the following are implemented:

### Identity

- Localized name
- Japanese name
- Official classification
- Type
- Belt level
- Difficulty
- Official verification status

### Watch

- Official image
- Training video
- Competition video
- Animation placeholder architecture
- Slow-motion placeholder architecture

### Understand

- Overview
- Kuzushi
- Tsukuri
- Kake
- Key points
- Biomechanics
- Grip strategy
- Body positioning
- Visual learning support

### Practice

- Shadow drills
- Uchikomi
- Nagekomi
- Partner drills
- Resistance drills
- Strength and mobility
- Safety instructions

### Analyze

- Video-upload entry point
- Subscription and credit display
- Basic analysis flow
- Fight Intelligence 360 architecture
- Opponent and grip analysis
- Analysis-history architecture

### Master

- Ten-question quiz
- Progress display
- Mastery display
- Prerequisites
- Combinations
- Recommended next technique
- Sensi Bot recommendation

### UX

- No duplicate title
- Single Favorite action
- Compact Dashboard
- No duplicated long sections
- All Dashboard buttons functional
- Responsive mobile and tablet support
- RTL and LTR support


---

# 9. Scientific AI & Biomechanics Requirements

## Product Objective

Judo Mind must provide biomechanical analysis that is scientifically defensible, practically useful and clearly differentiated from simple pose-estimation applications.

Displaying a skeleton over a video is not considered a completed biomechanics feature.

The system must convert video and sensor information into meaningful Judo-specific feedback.

---

# 9.1 Reference Technique

Uchi Mata is the official reference technique for development and validation of the complete biomechanics pipeline.

The Uchi Mata reference must be completed before the architecture is generalized to the remaining 66 official techniques.

---

# 9.2 Analysis Architecture

The product must support the following processing architecture:

- Video capture
- Camera-quality validation
- Camera calibration
- Camera synchronization
- Multi-person detection
- Tori / Uke identification
- Pose estimation
- Occlusion handling
- Multi-view 3D reconstruction
- Musculoskeletal modeling
- OpenSim processing
- Judo-specific phase recognition
- Biomechanical interpretation
- Confidence analysis
- Athlete / Coach reporting

---

# 9.3 Standard Video Analysis

Users must be able to upload a normal training or competition video.

Standard analysis should provide, where technically supported:

- Athlete detection
- Opponent detection
- Technique recognition
- Grip analysis
- Stance analysis
- Attack direction
- Kuzushi estimation
- Tsukuri estimation
- Kake estimation
- Landing analysis
- Joint-angle estimation
- Body-position analysis
- Relative Tori / Uke position
- Timing analysis
- Tactical observations
- Technical errors
- Safety observations
- Corrective coaching recommendations

Single-camera physical measurements must be classified as estimated when direct measurement is unavailable.

---

# 9.4 Advanced Multi-View Biomechanics

Judo Mind must support an advanced capture workflow using two or more synchronized cameras or smartphones.

Requirements:

- Guided camera placement
- Camera calibration
- Camera synchronization
- Multi-view recording
- Athlete identity matching across cameras
- 2D landmark extraction
- 3D triangulation
- 3D anatomical landmark reconstruction
- Temporal filtering
- Confidence validation

Advanced output should support:

- 3D joint kinematics
- Joint angles
- Segment orientation
- Center-of-mass trajectory
- Trunk inclination
- Pelvis rotation
- Support-leg mechanics
- Attacking-leg trajectory
- Relative Tori / Uke geometry
- Movement velocity
- Angular velocity
- Technique-phase timing

---

# 9.5 OpenSim Requirement

OpenSim is the approved primary musculoskeletal modeling engine.

Judo Mind must prepare compatible 3D motion data for OpenSim.

OpenSim-based analysis may include:

- Musculoskeletal model scaling
- Inverse kinematics
- Joint-angle calculation
- Center-of-mass analysis
- Segment motion
- Joint moments when scientifically supported
- Joint power when scientifically supported
- Muscle and joint modeling
- Future dynamic simulation

---

# 9.6 Uchi Mata Biomechanics Requirements

The Uchi Mata reference analysis should eventually evaluate:

### Preparation

- Initial posture
- Tori stance
- Uke stance
- Grip configuration
- Relative distance

### Kuzushi

- Balance-breaking direction
- Upper-body pull
- Uke center-of-mass displacement
- Support-base change
- Timing

### Tsukuri

- Entry angle
- Support-foot placement
- Hip position
- Pelvis rotation
- Trunk angle
- Shoulder rotation
- Tori / Uke distance

### Kake

- Attacking-leg trajectory
- Inner-thigh interaction
- Support-leg stability
- Rotation velocity
- Uke elevation
- Center-of-mass relationship
- Throw direction

### Completion

- Throw trajectory
- Rotation completion
- Tori control
- Uke landing
- Safety indicators

---

# 9.7 Technique Phase Intelligence

The AI system must recognize the temporal structure of a Judo technique.

Reference phases:

1. Preparation
2. Kuzushi
3. Tsukuri
4. Kake
5. Flight / Throw
6. Landing
7. Transition

Each phase should support:

- Start time
- End time
- Confidence
- Relevant biomechanical metrics
- Technical observations
- Detected errors

---

# 9.8 Tori / Uke Intelligence

Judo Mind must not assume that pose-estimation output order represents athlete identity.

The system requires persistent identity logic for:

- Tori
- Uke

Identity must be maintained during:

- Grip exchanges
- Limb crossing
- Rotation
- Close contact
- Partial occlusion
- Full-body overlap
- Throw execution
- Landing

Identity uncertainty must be reported rather than silently assigned.

---

# 9.9 Scientific Confidence System

Every professional analysis result must eventually include:

- Confidence score
- Data source
- Analysis method
- Capture-quality information
- Measurement classification
- Relevant limitation

Low-confidence results must not be presented as high-confidence coaching conclusions.

---

# 9.10 Measurement Classification

Judo Mind must distinguish four data classes:

### Measured

Directly measured by appropriate hardware.

Examples:

- Force Plate
- EMG
- IMU

### Reconstructed

Calculated from calibrated multi-view observations.

Example:

- 3D landmark position

### Model Estimated

Calculated using biomechanical or musculoskeletal models.

Examples:

- OpenSim-derived quantities
- Estimated joint loading
- Estimated muscle activation

### AI Inferred

Predicted or interpreted by an AI model.

Examples:

- Technique phase
- Tactical pattern
- Technical error classification

---

# 9.11 Scientific Integrity Requirement

The application must never present estimated quantities as directly measured physical values.

Examples:

Force Plate Ground Reaction Force:

Measured

Video-derived Ground Reaction Force:

Estimated

EMG Muscle Activity:

Measured

OpenSim-derived Muscle Activation:

Model Estimated

Scientific limitations must be visible to professional users.

---

# 9.12 Research Validation Requirements

Before the biomechanics system is classified as production-grade, it must be evaluated using representative Judo movements.

Validation must include:

- Different athletes
- Different body sizes
- Left-handed and right-handed techniques
- Different judogi colors
- Different lighting
- Different camera positions
- Training videos
- Competition videos
- High-speed execution
- Athlete overlap
- Limb crossing
- Occlusion
- Throwing
- Landing

Where practical, validation should include comparison against:

- Marker-based Motion Capture
- Force Plates
- EMG
- IMU
- Expert Judo annotation

---

# 9.13 Performance Infrastructure

Local CPU processing is acceptable for:

- Development
- Benchmarking
- Debugging

Production AI analysis must be designed for GPU-backed processing.

Long-running scientific analyses must support:

- Upload progress
- Processing progress
- Background jobs
- Analysis status
- Failure recovery
- Result persistence

---

# 9.14 AI Analysis User Experience

The user must receive more than raw numerical data.

Analysis results should provide:

- Visual overlay
- Phase timeline
- Joint and body-position visualization
- Technique comparison
- Detected strengths
- Detected weaknesses
- Corrective recommendations
- Training recommendations
- Confidence indicators
- Scientific limitations

The final output must be understandable by athletes while preserving advanced information for coaches and sports scientists.

---

# 9.15 Product Differentiation Requirement

Judo Mind biomechanics must become a core competitive advantage of the platform.

The system must combine:

- Computer Vision
- Judo technical knowledge
- 3D motion analysis
- Musculoskeletal biomechanics
- Artificial Intelligence
- Coaching intelligence
- Tactical analysis
- Scientific validation

The product must not be marketed as advanced biomechanics until the relevant outputs have been validated to an appropriate scientific standard.

---

# 9.16 Dual-Level Video Analysis Product Requirement

Video Analysis must expose two distinct products with different scientific promises.

## Single-Camera AI Analysis

The product may accept a normal single training or competition video and provide:

- 2D pose and visible movement analysis
- Technique-phase and timing estimates
- Technical and tactical feedback
- Normalized or model-estimated movement indicators
- Confidence and visible limitations

The result experience must not label unmeasured depth, joint kinetics, force or body motion as measured or reconstructed 3D. The words “precise biomechanics,” “measured 3D” or equivalent claims are prohibited unless the underlying scientific pipeline actually supports them.

## Multi-Camera 3D Scientific Analysis

The product may expose reconstructed 3D and later OpenSim-derived results only after calibration, synchronization, cross-camera athlete identity, geometry, reconstruction and downstream quality gates pass.

If a required gate fails:

- The advanced analysis must stop.
- No 3D, scientific-biomechanics or OpenSim result may be published from that run.
- The user may be offered a separate Single-Camera AI analysis with its estimated/inferred limitations clearly shown.
- The interface must explain that scientific-quality requirements were not met without converting the failed result into a stronger claim.

Every result must show or retain:

- Provenance: measured, reconstructed, model-estimated or AI-inferred
- Confidence
- Input/source type
- Analysis method
- Quality classification
- Relevant limitations

# 9.17 Calibration and OpenSim Product Gate

`status=completed` does not make calibration usable. Reports with `review_required`, missing evidence, malformed metrics or metrics outside the approved profile must fail closed.

`usable_for_3d_validation` is a development-only classification. It must not enable user-facing scientific 3D, “precise biomechanics” or OpenSim.

User-facing scientific 3D requires at least the approved `good` calibration profile. OpenSim additionally requires independent approval of cross-camera identity, temporal alignment, reconstructed motion quality and anatomical mapping. Passing calibration is necessary but never sufficient for an OpenSim result.

The stereo extrinsic from the calibration cycle closed on 2026-08-07 is rejected for product use. Its `review_required` status, 48.2750333 px RMS and 55.4328918 px median epipolar error must keep it blocked from 3D, biomechanics and OpenSim.

# 9.18 Three-Level Fight Intelligence 360 Product Requirement

Fight Intelligence 360 must present three scientific levels with independent promises and availability:

## Level 1 - Single-Camera AI Analysis

- Accept an ordinary training or competition video.
- Provide measured media metadata, projected 2D pose/movement metrics and AI-inferred technical coaching where reportable.
- Label projected angles, displacement, velocity, 2D COM proxy and balance cues with confidence and limitations.
- Never present true/reconstructed 3D, measured force, true 3D COM, actual joint moment, power or torque.

## Level 2 - Multi-Camera 3D Analysis

- Require synchronized cameras, accepted intrinsics/extrinsics/orientation, persistent cross-camera Tori/Uke identity, landmark correspondence, triangulation and reconstruction-quality gates.
- Permit reconstructed 3D skeleton, trajectories, joint geometry, relative position and 3D velocity only after all gates pass.
- Permit model-estimated COM and later OpenSim only after their additional gates pass.
- Keep every `review_required` calibration and the rejected 2026-08-07 stereo extrinsic blocked.

## Level 3 - Professional / Federation / Laboratory Analysis

- Support future synchronized high-speed cameras, calibrated volumes, marker-based or validated markerless systems, optional IMUs, force plates/external-force systems, approved EMG and OpenSim.
- Permit measured force only from valid instrumentation.
- Permit inverse dynamics, joint moment, power, work and momentum only as model-estimated results with disclosed assumptions and quality evidence.
- Provide the reference environment for validation of lower product levels.

## Metric and Report Requirements

The official Uchi Mata metric registry is `docs/UCHI_MATA_SCIENTIFIC_METRICS_V1.md`. Every finding must retain:

- Metric ID, name, value and unit
- athlete role and phase/event schema
- analysis level and provenance
- confidence components and quality state
- method/model version
- limitation and scientific source
- coaching interpretation and prohibited interpretation

The product must not invent normative targets. Source-specific phases must not be silently mapped to canonical Kuzushi/Tsukuri/Kake.

## Interactive 3D / 360

After valid Level 2/3 reconstruction, the user may view Front, Side, Rear, Top and Free 360 virtual-camera perspectives. Product copy must say `3D reconstruction + 360 viewing`; it must not imply 360-camera capture.

## Result Experience

The result must connect:

- AI Sensi
- annotated video
- voice coaching
- scientific report
- interactive 3D/360 when evidence permits

Blue overlays show movement/position/joint geometry. Gold overlays show grip/Hikite/Tsurite/upper-body control. Green overlays show balance/COM/mechanical direction; at Level 1, directional cues are conceptual `AI-inferred` coaching cues and never measured force vectors.

AI Sensi must remain independent Judo Mind intellectual property. It may be inspired by Mohammad Javani's visual identity without copying his full face. No real narrator or third-party voice may be cloned without permission.

---

# 9.19 Three Video Analysis Mode Product Requirement

Fight Intelligence 360 must separate three user-facing analysis modes. The
mode describes what portion of activity is being analyzed; the Level 1/2/3
classification independently describes what scientific evidence is available.

## Technique Analysis - One Attempt

The user selects one primary technique execution, with useful context
immediately before and after it. One analysis window must equal one primary
attempt. The product must not impose an arbitrary universal duration limit.

If multiple attempts are present before automatic segmentation is validated,
the Analyze flow must require selection or trimming of one attempt. It must not
average unsegmented attempts or present them as one execution.

Future result experience:

- Annotated Video
- AI Sensi
- Voice Coaching
- Scientific Report
- Interactive 3D/360 only when the scientific analysis level permits it

## Training / Drill Analysis - Multiple Repetitions

This mode analyzes repeated practice of the same technique. Every repetition
must first become a separate event and receive its own Attempt 1, Attempt 2,
Attempt 3 and subsequent per-attempt result.

Only after reliable segmentation and per-attempt analysis may the product
report comparison, consistency, variability, progression, degradation or
repeatability of validated metrics. It must not blend repetitions into one
execution. A fatigue finding requires validated evidence and must not be
inferred merely from changing repetitions.

## Competition Analysis - Full Match

This mode analyzes an entire match as an event timeline. It must support the
future sequence:

`temporal event detection -> attack/event segmentation -> technique candidate/classification -> individual attempt analysis -> outcome -> match-level tactical aggregation`

Required future result layers:

- Event timeline
- Individual attack cards
- Per-attempt analysis
- Match tactical summary
- AI Sensi competition review

The product must not combine all attacks into one biomechanics report.
Match-level tactical findings and per-attempt technique findings must retain
separate methods, confidence, provenance and limitations.

## Benchmark and Sampling Boundary

Pose Engine Benchmark results evaluate detection coverage, reliability and
processing performance; they are not Technique Analysis. Multiple movements in
a benchmark video do not authorize one combined athlete or technique result.

The current timestamp-based 10 FPS target is a benchmark/evaluation setting.
Scientific metric extraction must retain source timestamps and use a validated,
metric-appropriate temporal resolution, potentially including native
25/30/50/60 FPS. No universal biomechanics sampling rate is approved.

## Scientific Requirements

All three modes must:

- Preserve measured, reconstructed, model-estimated and AI-inferred provenance.
- Withhold Tori/Uke claims when identity is not validated.
- Withhold Kuzushi/Tsukuri/Kake judgments when event/phase segmentation is not
  validated.
- Prohibit measured-force claims from ordinary video.
- Prohibit true 3D and actual torque, moment or power claims from single-camera
  video.
- Present confidence, method, quality and limitations appropriate to each
  result.

This section formalizes the three-mode architecture. Automatic segmentation,
classification, Drill/Match analysis and the general mode-selection UX remain
unimplemented. The bounded Single-Attempt V2A foundation described in section
9.20 is now implemented separately.

---

# 9.20 Single-Attempt Uchi Mata V2A Product Requirement

The first bounded implementation of Technique Analysis - One Attempt must
produce exactly:

1. reviewed execution duration (`UM-TIM-001`);
2. projected trunk inclination (`UM-ANG-001`);
3. projected support-leg knee angle (`UM-ANG-002`);
4. projected attacking-leg knee angle (`UM-ANG-003`).

## Required Review Inputs

Until each automatic capability is scientifically validated, the product must
require a human-selected start/end event pair, human-confirmed Tori mapped to a
neutral track, human-confirmed support leg and a reviewed angle frame/event.
Projected angle reportability also requires reviewed near-planar view
suitability and low roll.

The user must not need to understand internal landmark indices. The eventual
selection UX should present video frames and neutral persons/tracks, then store
the reviewed decision in the versioned contract.

## Result Requirements

Each metric must show:

- value and unit when available;
- `reportable`, `review_required` or `withheld` state;
- measured or model-estimated provenance;
- frame/timestamp or start/end interval;
- method version;
- meaningful confidence evidence when available;
- an explicit limitation and withheld reason when applicable.

The result may draw a blue trunk line, blue support-side hip-knee-ankle
polyline and blue projected-angle labels. It must not draw force vectors, fake
COM, reconstructed 3D or normative target geometry.

AI Sensi copy is descriptive only, for example: `Projected trunk inclination
is X degrees at timestamp Y.` It must not call an angle wrong, claim poor phase
execution or prescribe an ideal until validated coaching-reference rules exist.

## Fail-Closed Acceptance

- Missing/invalid/degenerate angle geometry is withheld with no value or
  overlay.
- Unreviewed camera suitability results in `review_required`, not an approved
  projected angle.
- Frame-local pose order cannot establish Tori/Uke identity.
- Model landmark visibility cannot be labelled pose accuracy or biomechanics
  confidence.
- The benchmark 10 FPS setting cannot become the product's fixed scientific
  temporal resolution.
- Ordinary single-camera video cannot yield true 3D, measured force, actual
  torque, moment, power, load or injury risk.

Current delivery includes the versioned Python evaluation contract, metric
math, human annotation/evaluation schema, a multipart reviewed-video endpoint
that infers only the selected source frame, a typed Flutter HTTP service,
result parser/card, blue geometry layer and the explicit user-facing
review/selection workflow. The first reviewed real attempt remains pending.

## 9.21 Grounded Sensei V1 Product Requirement

The first Grounded Sensei is a deterministic, local explanation layer bound to
one exact human-reviewed Uchi Mata V2A request/result pair. It is not open
generative AI, a chatbot prompt surface, a new analysis engine or a source of
new scientific values.

It accepts only the exact four approved V2A metrics and must preserve their
value, status, provenance, confidence availability and method version. Missing,
duplicate or unknown metrics, technique/request/result mismatches, unsupported
locale, invalid scientific boundaries or reportable multi-person interaction
must fail closed without hiding the underlying V2A result.

The explanation presents finding, evidence, bounded relevance, BLUE overlay
availability, next action, approved selected-language safety, limitations and
versioned provenance. No performance classification, automatic identity,
phase, leg-role inference, confidence fabrication, 3D, kinetics or interaction
claim is permitted. Without an explicitly approved metric-to-drill mapping,
the next action is honestly unavailable rather than fabricated.

## 9.22 Reusable Technique Explanation Content Standard

All official technique explanations use the 18-section bilingual structure in
`scientific_foundation/JM_TECHNIQUE_EXPLANATION_CONTENT_STANDARD_EN_FA.md`:
identity, overview, grip/start, Kuzushi, Tsukuri, Kake, relevant
Makikomi/follow-through, coaching points, mistakes, safety, variations,
canonical combinations, canonical counters, visual explanation, video
explanation, technical interpretation, optional biomechanical interpretation,
and evidence/review status.

Overview, execution phases and coaching points remain prominent; longer
material is expandable. Visuals are zoomable and accessible. English and
Persian values are independently governed, with full RTL behavior in Persian.
Missing content is unavailable rather than generated or silently translated.

Technical educational review and scientific review are distinct. Optional
biomechanical material stays hidden/locked unless statement classification,
method, limitations, provenance and review data are complete. Conceptual
arrows carry the exact no-direct-force-measurement disclaimer. Media must be
project-owned, licensed or backed by recorded permission/provenance. The
external design example is not a product asset or content/scientific source.

The standard alone does not populate any technique, make a route ready,
create scientific approval, enable analysis, or alter a scientific rule,
threshold, metric or capability.

## 9.23 Canonical Technique Identity Registry

The official 67-technique roadmap has one provenance-aware, content-free
identity registry. Canonical ID, display order, model availability,
identity/classification verification, Persian-name state and unlock state are
independent. Existing IDs `001–005` are preserved; the other normalized
mappings require qualified human confirmation. Registry membership never
creates a model, translation, educational content, scientific approval or
unlock.

Unknown, duplicate, unresolved, conflicting, human-review-pending or
model-missing identities fail closed. Uchi Mata `001` remains specialized and
no non-Uchi technique is unlocked by the registry foundation.

## 9.24 Human-First Analysis Role Contract

Technique Intelligence must require an explicit human role assignment after
the user selects a frame-local candidate. The governed assignment is:

```text
role: TORI
source: HUMAN_CONFIRMATION
candidate_token: selected session candidate
```

No candidate is selected by default. Confirmation is a separate human action,
changing the candidate invalidates it, and analysis remains disabled until all
required review fields are complete. The server independently verifies that
the candidate token belongs to the current review session and rejects missing,
AI-derived, identity-bearing or cross-session assignments.

Clothing colour is permitted only as a visual helper and is not identity,
tracking or role evidence. V2A scientific outputs and contracts remain
unchanged. AI-Assisted Competition Timeline and Coach Analysis Marketplace are
future separate product layers; this requirement does not implement either.

## 9.25 D2 Review-Frame Temporal Context

Guided PREPARE may supply MediaPipe VIDEO mode with a bounded contiguous
pre-roll ending at the human-selected Review Frame. The context must remain
inside the human-confirmed attempt and is an internal engineering aid only.
Only the exact Review Frame may create candidate evidence; every preceding
output is discarded. Temporal context does not create a track, identity, Judo
role, phase, metric or coaching interpretation.

The current 500 ms maximum is a computational engineering bound. The observed
15-frame success in one 30 FPS Uchi Mata diagnostic video does not establish a
universal, scientific or Judo-specific threshold. Insufficient Review Frame
evidence continues to fail closed, and D2 remains incomplete until positive
real-device validation.

## JM-COMP-01 — Global Judo AI Competitive Benchmark Governance

Future comparative review may consider Judo AI: Training Coach, BukatsuLog,
Onform, Dartfish, Hudl and CoachNow across Product/UX, Video Intelligence, Judo
Intelligence, Coaching/Progress and Scientific/Governance axes. Findings must
be classified `ADOPT`, `ADAPT` or `REJECT` only after documented review.

Candidate ideas for later evaluation include Waza Maps/Combination Flow,
Analysis-to-Training Action, Coach/Athlete collaboration and Progress
workflows. Advertising, UI visibility or a competitor claim is not evidence of
a validated capability. No idea may enter Judo Mind without scientific,
engineering, UX, privacy and JM-BTIG-01 compatibility review. JM-COMP-01 records
benchmark governance only and activates no competitor-derived feature.
