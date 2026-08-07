# Judo Mind Product Requirements Document

Version:

1.1


Status:

Active Development


Last Updated:

2026-08-05


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


Judo Mind consists of 17 modules.


---

# Module 1

## Home Dashboard


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

## Techniques


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

## Monitoring


Requirements:

- Sleep tracking
- Fatigue tracking
- Body metrics
- Nutrition tracking
- Performance tests
- Athlete readiness


---

# Module 6

## Judo Cast


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

## Store & Subscription


Requirements:

- Subscription plans
- Premium content
- Digital products
- Payments preparation


---

# Module 13

## Club Management


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

## Administration & System Settings


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
