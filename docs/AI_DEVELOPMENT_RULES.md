# Judo Mind AI Development Rules

Version:
2.7

Status:
Active Development Standard

---

# 1. Project Identity

Project Name:

Judo Mind Super App


Platform:

Flutter Mobile Application


Product Type:

Global Digital Judo Ecosystem


Purpose:

A professional digital ecosystem connecting:

- Athletes
- Coaches
- Clubs
- Federations
- Fans
- Administrators


Main Vision:

Train Your Body, Master Your Mind.


---

# 2. Development Philosophy

All development decisions must follow:

- Professional software architecture
- Clean Architecture principles
- Modular development
- Scalability
- Security-first approach
- Localization-first approach
- CMS-first content strategy
- Performance optimization
- Excellent user experience
- Documentation synchronization


Judo Mind must always be developed as a commercial international product.


---

# 3. AI Assistant Role

AI assistant is considered a development partner.

Before generating or modifying code:

Required process:

Analysis

↓

Architecture Check

↓

Dependency Review

↓

Design Decision

↓

Implementation

↓

Testing

↓

Documentation Update

↓

Git Commit


AI must not:

- Guess missing project structure
- Break existing features
- Create duplicate architecture
- Ignore documentation
- Replace approved decisions without review


---

# 4. Coding Rules

Before changing important files:

1. Analyze existing architecture.
2. Check dependencies.
3. Check related documentation.
4. Preserve existing functionality.
5. Avoid unnecessary modifications.


Coding requirements:

- Clean Dart and Flutter standards
- Reusable components
- Modular files
- Meaningful naming
- Readable structure
- Low technical debt
- Testable code


---

# 5. Flutter Architecture Rules

The project must gradually move toward Feature-Based Architecture.


Target:

lib/

core/

features/

shared/


Each module should be:

- Independent
- Expandable
- Testable
- Maintainable


---

# 6. Localization Rules

Internationalization is mandatory.

No user-facing text should be permanently hardcoded.


Wrong:

Text("Training")


Correct:

Text(context.l10n.training)


Supported languages:

- English
- Persian
- Japanese
- French
- German
- Spanish
- Russian
- Arabic


Requirements:

- RTL support
- LTR support
- Runtime language switching
- Localized content
- Localized CMS data


---

# 7. Technique Data Rules

Technique Module is a core competitive advantage.


Each technique should support:


Identity:

- English name
- Japanese name
- Persian translation
- Category
- Difficulty
- Belt level


Technical Layer:

- Kuzushi
- Tsukuri
- Kake
- Execution steps
- Key points
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
- Conditioning
- Mobility


Competition Layer:

- Tactical application
- Combinations
- Counters
- Match analysis


AI Layer:

- Recommendations
- Progress analysis
- Personalized training


Sources:

Official sources must be prioritized.

---

# 8. CMS and Content Management Rules

Application content must not depend on Flutter code changes.


Administrators must be able to manage:

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


All content should be prepared for:

Flutter App

↓

API

↓

Backend

↓

CMS


---

# 9. Design System Rules

All UI development must follow the Judo Mind Design System.


Avoid:

- Random colors
- Random spacing
- Duplicate widgets


Use:

- Theme
- Colors
- Typography
- Spacing
- Radius
- Components


---

# 10. Security Rules

Security must exist from the beginning.


Rules:

- Never store private keys in app code.
- Never expose sensitive data.
- Use secure authentication.
- Protect user information.
- Prepare backend security.
- Validate input.
- Control permissions.


---

# 11. Git Workflow

Before major changes:


1. Test application.
2. Run:

flutter analyze


3. Run:

flutter run


4. Update documentation.
5. Create Git commit.


Commit messages must describe changes.


Example:

Good:

feat(techniques): add dashboard architecture


Bad:

Update


---

# 12. Documentation Rules

No important decision should exist only in conversation.


Required updates:

- ARCHITECTURE.md
- PROJECT_STATUS.md
- CHANGELOG.md
- DECISION_LOG.md
- PRODUCT_REQUIREMENTS.md


Documentation and code must always remain synchronized.


---

# 13. Product Development Rules

Judo Mind is not only software.

Every decision must consider:

- Judo expertise
- Athlete experience
- Coach requirements
- Federation requirements
- Business model
- Competitive advantage
- International scalability


---

# 14. Final Development Rule

Before creating any feature, ask:


1. Is it defined in Product Requirements?

2. Is the architecture location clear?

3. Does it support multilingual users?

4. Can CMS manage it in the future?

5. Is security considered?

6. Is it documented?


Only after these answers:

Development begins.


---

# Final Goal

Build the world's most complete digital Judo ecosystem powered by:

- Judo knowledge
- Sports science
- Artificial intelligence
- Data
- Professional software architecture
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

# Design System Rules

All UI components must use the centralized Design Tokens.

Forbidden:

- Hard-coded colors
- Hard-coded spacing
- Hard-coded radius
- Hard-coded animation duration
- Hard-coded icon sizes

Required:

JudoColors

JudoSpacing

JudoRadius

JudoButtonHeight

JudoAnimation

This guarantees visual consistency across all 18 modules.

## Typography Rules

All application text styles must use:

- JudoTypography
- Theme typography derived from JudoTypography

Forbidden:

- Hard-coded font sizes inside feature widgets
- Hard-coded font weights without design-system approval
- Feature-specific typography systems
- Fixed language-specific fonts inside reusable widgets

Typography must support:

- LTR languages
- RTL languages
- Japanese characters
- Cyrillic characters
- Responsive mobile and tablet layouts

# Reference Technique Development Rules

## 1. Reference Technique

Uchi Mata is the official Reference Technique of Judo Mind.

All future official techniques must follow the approved Uchi Mata:

- Architecture
- Data structure
- Learning flow
- Visual hierarchy
- Media structure
- AI analysis structure
- Dashboard organization
- Localization rules
- CMS compatibility
- Subscription access rules

A new technique may not introduce an independent architecture outside this reference without an approved architectural decision.

---

## 2. Technique Learning Flow

Every official technique must support five learning layers:

1. Watch
2. Understand
3. Practice
4. Analyze
5. Master

### Watch

Must support:

- Official image
- Training video
- Competition video
- Slow-motion media
- Step animation
- Optional 3D demonstration

### Understand

Must support:

- Overview
- Kuzushi
- Tsukuri
- Kake
- Technical key points
- Biomechanics
- Grip requirements
- Body position
- Common mistakes
- Safety guidance

Text-only instruction is not sufficient for major execution phases.

Kuzushi, Tsukuri and Kake must support:

- Text
- Image
- Animation
- Video
- Optional frame-by-frame demonstration

### Practice

Must support:

- Shadow training
- Uchikomi
- Nagekomi
- Partner drills
- Resistance drills
- Tactical drills
- Strength and mobility exercises
- Safety instructions

### Analyze

Must support:

- Video upload
- Technique comparison
- Competition analysis
- Opponent analysis
- AI Fight Intelligence 360
- Coach review
- Analysis history

### Master

Must support:

- Quiz
- Progress tracking
- Mastery score
- Training recommendations
- Prerequisites
- Recommended combinations
- Recommended next technique

---

## 3. Technique Detail Screen Rule

TechniqueDetailScreen must remain an orchestrator.

It may directly display only:

- Judo App Bar
- Technique Hero
- Essential identity information
- Primary official media
- Learning Dashboard
- Primary actions

Long-form content must open through:

- Bottom Sheet
- Full-screen page
- Dedicated feature module

The following content must not be duplicated below the Dashboard:

- Technical Analysis
- Tactical Intelligence
- Competition Analysis
- Champions
- Mistakes and Safety
- Combinations
- Mastery
- Sensi Bot
- Quiz
- Sources

---

## 4. Dashboard Rules

The Technique Dashboard must organize content into approved groups:

### Learn

- Overview
- Videos
- Technical Analysis
- Training

### Performance

- Tactical Intelligence
- Competition
- Combinations
- Mistakes and Safety
- Mastery

### Professional

- Champions
- Sensi Bot
- Quiz
- Official Sources
- AI Fight Analysis

Dashboard cards must use:

- Centralized Design Tokens
- Compact icons
- Compact card height
- Shared color families
- Short titles
- No unnecessary decorative shapes
- RTL and LTR support

---

## 5. AI Video Analysis Availability

Video upload and AI analysis must be available to every subscription level.

Access must not be completely blocked for lower tiers.

Differences between plans must be controlled by:

- Monthly AI credits
- Analysis depth
- Report detail
- Storage duration
- Coach access
- Export capability
- Team-management capability

---

## 6. AI Credit Rules

Every AI analysis request consumes an approved number of credits.

Example analysis costs:

- Basic Technique Check: 1 credit
- Detailed Technique Analysis: 2 credits
- Competition Analysis: 3 credits
- Opponent Analysis: 3 credits
- Fight Intelligence 360: 5 credits
- Licensed Coach Review: additional paid service

Unused credits, renewal behavior and credit purchases must be controlled by backend policy and administration settings.

No credit value may be hard-coded permanently inside feature widgets.

---

## 7. Subscription Access Matrix

### Basic

Must support:

- Video upload
- Limited monthly analyses
- Overall technique score
- Main detected errors
- Basic corrective recommendation

### Pro Athlete

Must support:

- More monthly credits
- Kuzushi analysis
- Tsukuri analysis
- Kake analysis
- Grip analysis
- Balance analysis
- Analysis history
- Official-technique comparison

### Elite Athlete

Must support:

- Higher or unlimited fair-use credits
- Fight Intelligence 360
- Frame-by-frame analysis
- Tactical analysis
- Opponent analysis
- Progress comparison
- PDF reports
- Advanced training prescription

### Coach

Must support:

- Athlete roster
- Team analysis credits
- Coach comments
- Training assignments
- Review workflow
- Athlete reports
- Paid licensed-coach services

### Federation

Must support:

- Large athlete groups
- Team and national dashboards
- Aggregated performance statistics
- Common technical weaknesses
- Competition intelligence
- Role-based access
- Audit records
- Central subscription management

Exact limits and prices must be editable through the Administration Panel without Flutter code changes.

---

## 8. AI Fight Intelligence 360 Rules

Fight Intelligence 360 must analyze both athletes and the interaction between them.

It must not analyze the attacking athlete in isolation.

Required dimensions:

### Athlete Execution

- Kuzushi
- Tsukuri
- Kake
- Foot placement
- Hip position
- Body rotation
- Entry distance
- Attack direction
- Timing
- Completion and control

### Opponent Guard and Grip

- Right or left stance
- Ai-yotsu or Kenka-yotsu relationship
- Dominant grip
- Sleeve control
- Lapel control
- High grip
- Defensive grip
- Grip-breaking opportunities
- Grip dominance changes over time

### Opponent Position

- Position before attack
- Position during attack
- Defensive posture
- Hip distance
- Knee flexion
- Spinal angle
- Foot spacing
- Weight distribution
- Direction of movement

### Balance and Kuzushi

- Push reaction
- Pull reaction
- Weight-transfer direction
- Stable support points
- Weak balance direction
- Head, shoulder, hip and leg alignment
- Center-of-gravity displacement
- Attack window created by movement

### Tactical Intelligence

- Attack timing
- Reaction attacks
- Combination opportunities
- Counterattack risk
- Preferred movement direction
- Weak moment after failed attacks
- Defensive habits
- Attack frequency
- Grip-fighting patterns

### Match Timeline

Must support event-based analysis such as:

- Grip changes
- Attacks
- Counters
- Penalties
- Ground transitions
- Fatigue indicators
- Tactical phases
- Successful and unsuccessful attack windows

---

## 9. AI Output Rules

AI output must distinguish:

- Detected observation
- Calculated score
- AI inference
- Recommendation
- Coach-validated conclusion

The system must never present uncertain AI inference as guaranteed fact.

Every result must include an analysis confidence value when technically available.

---

## 10. AI Safety and Professional Review

AI analysis is a support tool and must not be presented as a replacement for:

- Licensed coaches
- Medical professionals
- Referees
- Federation authorities

High-level paid reviews may be assigned to:

- Approved national coaches
- Licensed coaches
- Approved analysts
- Federation-authorized experts

Reviewer identity, approval status and report changes must be auditable.

---

## 11. CMS and Administration Rules

Administration must be able to manage without Flutter coding:

- Subscription plans
- AI credit limits
- Credit prices
- Analysis types
- Analysis costs
- Coach-review prices
- Approved coaches
- User access
- Technique media
- Animations
- AI prompts and analysis templates
- Reports
- Localized texts
- Feature availability
- Fair-use limits

---

## 12. Privacy Rules for Uploaded Video

Uploaded videos must use:

- Explicit user consent
- Secure upload
- Controlled access
- Retention policy
- Deletion capability
- Role-based permissions
- Audit logging

Athlete videos must not be used for AI training, public examples or marketing without separate explicit consent.

Minors require appropriate guardian and organizational consent.

## Visual and Icon Development Rules

### Centralized Visual Language

AI-generated or manually designed visual components must follow the Judo Mind Design System.

AI must not introduce:

- Random Material icons directly inside feature screens
- Independent card decoration
- Unapproved visual styles
- Decorative shapes without functional meaning
- Inconsistent line weight or icon size

### Icon Selection

Every new feature must first request or define a semantic JMDS icon identifier.

Examples:

- Balance analysis → `JudoIcons.balance`
- Grip analysis → `JudoIcons.grip`
- Fight prediction → `JudoIcons.prediction`
- AI coach → `JudoIcons.aiCoach`

### Illustration Rules

Illustrations must:

- Relate directly to judo or the feature meaning.
- Remain readable at small mobile sizes.
- Use simplified human forms without facial detail.
- Use approved Design Tokens.
- Support dark backgrounds.
- Avoid stock-image appearance.
- Avoid cartoon styling unless explicitly approved.
- Avoid unnecessary visual complexity.

### SVG Migration Rule

Temporary Material icon implementations may be used during development.

Final SVG replacement must occur through the centralized Design System layer and must not require modifications in individual feature screens.

---

# Repository Agent Instruction File

The root `AGENTS.md` file is the repository-level operational entry point for AI-assisted development.

Before project work begins, AI assistants must read:

- `docs/AI_DEVELOPMENT_RULES.md`
- `docs/PROJECT_STATUS.md`
- `docs/CHANGELOG.md`
- `docs/ARCHITECTURE.md`
- `docs/DECISION_LOG.md`

`AGENTS.md` consolidates the stable approved rules in the project documentation. It does not replace the source documents and must not introduce independent product or architecture decisions.

AI assistants must preserve existing user work and existing functionality, follow the documentation-synchronization rules, maintain the approved scientific data classifications, and respect the current Flutter and Python AI Engine architecture.

Explicit user approval is required before destructive Git operations or Git push.

---

## 13. Scientific Video Analysis Gate Rules

The JM-DEC-018 boundary between Single-Camera AI Analysis and Multi-Camera 3D Scientific Analysis is mandatory in code, APIs, models, reports and UI copy.

### Single-Camera Rules

- Treat ordinary single-video analysis as 2D, model-estimated or AI-inferred unless a value is directly measured from the media itself.
- Attach confidence, source, method, quality and limitations to relevant outputs.
- Do not use `reconstructed`, “measured 3D,” “precise biomechanics” or equivalent language for depth or physical quantities not scientifically recovered.
- Do not infer authorization for OpenSim from the availability of a pose sequence.

### Multi-Camera Rules

- Require explicit calibration, synchronization, cross-camera identity, geometry and reconstruction-quality gates.
- Stop the scientific pipeline when any required gate fails.
- Do not silently downgrade a failed multi-camera run to single-camera processing while retaining 3D, biomechanics or OpenSim labels.
- Mark triangulated 3D landmarks as `reconstructed`, not measured.
- Mark OpenSim outputs as `model-estimated` unless the specific value is backed by a qualifying direct measurement source.

### Calibration Safeguard Rules

- `status=completed` alone is never calibration approval.
- Reject `quality=review_required` for every 3D, biomechanics and OpenSim path.
- Reject missing, malformed, non-finite, negative or out-of-threshold calibration evidence.
- Limit `usable_for_3d_validation` to offline development/validation. It must never authorize user-facing scientific 3D or OpenSim.
- Require a validated-calibration context before multi-view reconstruction; raw projection matrices alone are not authorization.
- Treat calibration approval as necessary but insufficient for OpenSim. Identity, temporal, reconstruction, anatomical and motion-quality checks remain mandatory.

### Evidence and Hypothesis Rules

- Preserve failed calibration evidence when requested, but block it from production processing.
- Record stabilization/EIS/OIS virtual-camera change as a hypothesis until independently verified; do not present it as the confirmed cause.
- Do not run further tests on the two videos from the stereo calibration cycle closed on 2026-08-07.
- Any future threshold change requires scientific validation and synchronization of `ARCHITECTURE.md`, `DECISION_LOG.md`, `PROJECT_STATUS.md`, `PRODUCT_REQUIREMENTS.md` and `CHANGELOG.md`.

---

## 14. Intent-to-Metric Scientific Execution Rules

JM-DEC-019 and `docs/UCHI_MATA_SCIENTIFIC_METRICS_V1.md` are mandatory whenever AI designs or implements Fight Intelligence metrics.

### Three-Level Boundary

- Level 1 is Single-Camera AI: measured media metadata, projected/image-plane model estimates and AI inference only.
- Level 2 is Multi-Camera 3D: reconstructed results only after synchronization, calibration, orientation, identity, correspondence, geometry and reconstruction-quality gates pass.
- Level 3 is Professional/Federation/Laboratory: instrumented reference analysis and scientifically supported model-based kinetics.
- A higher product tier or laboratory label must never promote the provenance of an unsupported value.

### Metric Work Order

Before implementation, AI must create or update an internal engineering Work Order that identifies:

- the approved Metric ID and scientific variable;
- athlete role and source/canonical phase schema;
- required landmarks, sensors and camera setup;
- formula, coordinate frame, smoothing and unit;
- valid level and exact provenance;
- confidence components and withholding conditions;
- scientific source and validation dataset;
- allowed and prohibited UI interpretation;
- API, Flutter, test and documentation effects.

The Work Order need not be shown in full unless requested, but implementation must not begin when these fields are unresolved in a way that materially changes scientific meaning.

### Evidence Rules

- Do not invent normative angles, timing, velocities, thresholds or coaching targets from memory.
- Do not convert group means, a single champion, a small sample or an incompatible protocol into a universal ideal.
- Preserve the original phase/event definition from each source. Map it to Preparation/Kuzushi/Tsukuri/Kake/Flight/Landing/Transition only after explicit expert review.
- Treat pose-derived 2D angles and landmarks as `model-estimated`, not measured.
- Treat automated phase labels, error labels and coaching cues as `AI-inferred`.
- Treat triangulated 3D geometry as `reconstructed` and OpenSim/inverse-dynamics output as `model-estimated`.
- Treat force, IMU or EMG signals as `measured` only when suitable calibrated hardware directly captured them.

### UX and Visualization Rules

- Every scientific finding must expose or retain metric, value, unit, role, phase, level, provenance, confidence, limitation, source and method version.
- Blue overlays represent movement, position and joint geometry.
- Gold overlays represent grip, Hikite, Tsurite, pull and upper-body control.
- Green overlays represent balance, COM and mechanical direction. Level 1 Green arrows must be labelled as AI-inferred conceptual cues and must not imitate measured force vectors.
- Interactive 3D/360 is available only from valid reconstruction and must be described as `3D reconstruction + 360 viewing`.

### Validation Rules

- Validate projected Level 1 metrics against expert frame annotations and, where possible, synchronized Level 3 reference capture.
- Validate Level 2 reconstruction against a higher-quality laboratory reference before making production accuracy claims.
- Require metric-specific tests for formula, units, provenance, confidence, invalid input, identity uncertainty, occlusion and UI wording.
- Update the metric registry, API contract, Flutter presentation and all required project documents together.

---

## 15. Video Analysis Mode and Event-Segmentation Rules

JM-DEC-021 defines three product analysis modes. These modes describe the
temporal and user-task scope of an analysis; they do not replace the independent
Level 1/2/3 scientific architecture in JM-DEC-019.

### Single Attempt - Technique Analysis

- One analysis window must represent one primary technique attempt, with only
  useful context before and after the execution.
- Do not invent a universal duration threshold.
- When multiple attempts are present and automatic event segmentation is not
  validated, require the user or reviewer to select or trim one attempt.
- Never average unsegmented executions and label the result as one technique
  analysis.

### Drill / Repeated Attempts Analysis

- Segment every repetition of the same technique into an independent event.
- Analyze and retain every attempt independently before comparison or
  aggregation.
- Aggregate consistency, variability, progression, degradation or repeatability
  only after reliable segmentation and per-attempt analysis.
- Do not infer fatigue from changing repetitions without validated evidence.

### Full Match Analysis

- Treat a complete match as a temporal event stream, not one technique attempt.
- Detect and segment attacks/events before technique classification or
  per-attempt analysis.
- Keep event timeline, individual attack cards, per-attempt findings and
  match-level tactical aggregation as separate output layers.
- Never blend all match attacks into one biomechanics report.

### Benchmark and Temporal-Resolution Boundary

- A pose-engine benchmark evaluates person coverage, engine reliability and
  processing performance. It is not athlete Technique Analysis.
- Benchmark media may contain multiple movements or repetitions without
  authorizing those executions to be combined into one technical result.
- The current timestamp-based 10 FPS target belongs only to pose benchmark and
  engineering evaluation infrastructure.
- Scientific metric extraction must retain source timestamps and use a
  metric-appropriate, validated temporal resolution, potentially including
  native 25/30/50/60 FPS. Do not declare one universal scientific FPS without
  validation.

### Scientific and UX Gates

- Preserve `measured`, `reconstructed`, `model-estimated` and `AI-inferred`
  provenance in every mode.
- Do not claim automatic Tori/Uke identity or Kuzushi/Tsukuri/Kake without
  validated identity and event/phase segmentation.
- Do not claim measured force from ordinary video, torque/moment/power from a
  single camera or true 3D from single-camera input.
- Present the modes in plain language as Technique Analysis - One Attempt,
  Training / Drill Analysis - Multiple Repetitions and Competition Analysis -
  Full Match.
- Preserve the coordinated result architecture: AI Sensi, Annotated Video,
  Voice Coaching, Scientific Report and Interactive 3D/360 only when the
  required scientific evidence permits it.


## JM-DEC-023 ? Subject Identity / Event Role Rule

1. Human subjects must use stable role-neutral references within an attempt.
2. Tori/Uke must not be used as persistent tracking IDs.
3. Technique actor/target roles are event-scoped.
4. One attempt may contain multiple actors when a counter-attack or other
   role-changing event occurs.
5. Belt color, judogi color, left/right image position, detection order and
   track index must never independently determine actor, Tori or Uke.
6. Appearance descriptions may be used only as temporary human-review context
   for one recording.
7. Human-confirmed event roles must retain human provenance.
8. AI-inferred attack, counter-attack or role assignment is prohibited until a
   separately validated role-classification gate exists.
9. Ground-truth labels must never be silently inferred or defaulted from visual
   appearance.



## JM-DEC-024 ? Evidence-First Detector Debugging Rule

1. Historical benchmark behavior must be reproduced before raw diagnostic
   evidence is interpreted.
2. Detector/NMS/threshold changes must not be made from image inspection alone.
3. RTMPose-M remains the current pose baseline until a separately validated
   replacement outperforms it.
4. The next improvement target is second-person detector/proposal recovery in
   close-contact judo.
5. Diagnostic chains must terminate once the responsible pipeline stage is
   sufficiently localized.
6. No repeated V3/V4 diagnostic cycle is permitted without new evidence that
   materially blocks the bounded engineering experiment.



## Multi-Person Evidence Reporting Rule

- Detection coverage is not scientific confidence.
- Failure to reliably detect two judoka does not automatically invalidate
  evidence that genuinely requires only the human-confirmed primary subject.
- Any metric requiring both judoka must be gated by explicit multi-person
  evidence sufficiency.
- When that evidence is insufficient, two-subject metrics must remain
  `review_required` or `withheld`.
- Missing opponent evidence must never be inferred from belt color, judogi
  color, screen position, detection order, or assumed Tori/Uke roles.



## Boundary-Normalized Landmark Rule

- Out-of-range normalized landmark coordinates must not be silently accepted.
- Boundary normalization must be explicitly recorded in pose provenance.
- Boundary clipping is representational normalization only and must never
  increase model confidence or scientific validity.
- Any metric using a boundary-normalized landmark must not be automatically
  `reportable`.
- Unrelated metrics must not be downgraded solely because another landmark in
  the same pose observation required boundary normalization.
- Re-running inference is not required when the raw estimate and normalization
  audit are already preserved.



## UM-ANG-003 Attacking-Leg Rule

- Attacking-leg classification must be explicit and provenance-bearing.
- Current V2A requires human confirmation of the attacking leg.
- The system must not infer the attacking leg simply as the opposite of the
  support leg.
- `UM-ANG-003` must be withheld when attacking-leg classification is absent.
- Boundary-normalized landmarks must use the same metric-specific reporting
  gate as other projected-angle metrics.
- The projected knee angle must not be presented as a true 3D anatomical
  angle or used to infer kinetics or injury risk.



## 16. Neutral Identity Tracker Evaluation Gate

JM-DEC-025 governs any real-video evaluation of an experimental neutral
identity tracker.

### Human Reference Rules

- Complete the chronological human mapping before running or scoring a tracker.
- Use only attempt-local `subject-1`, `subject-2` and `unassigned` references.
- Keep Tori/Uke and technique-event roles outside the identity mapping.
- Appearance cues may support human continuity review for one recording only;
  they must never become automatic identity rules.
- Preserve reviewer-provided crossing, occlusion and notes without inferring
  missing labels.
- Exclude `unassigned` detections from subject-identity scoring rather than
  forcing them onto a human subject.

### Conversion and Scoring Rules

- Convert human-visible subjects into explicit subject-frame reference rows;
  detector rows alone are not the visibility denominator.
- Convert tracker results to `AnnotatedTrackAssignment` before calling
  `evaluate_tracking_assignments()`.
- Count only accepted `associated` decisions as assigned. A
  `review_required` or withheld decision must remain unassigned.
- Keep predicted association provenance `AI-inferred` and human reference
  provenance `human-reviewed`.
- Never derive association confidence from IoU, track age, detection score or
  another unvalidated proxy. Unavailable confidence remains `None`.
- Zero assignment collisions or zero detection-order changes are not success
  evidence when assignment coverage is low.

### Reproduction and Approval Rules

- A version-dependent tracker milestone requires a native run with the exact
  declared dependency version and preserved input/source hashes.
- Provisional and native results must be compared before the milestone is
  recorded as reproducible.
- Report assignment coverage, identity switches, crossing identity switches,
  reappearance outcomes, detection-order-change outcomes, both collision
  counts and confidence coverage together.
- Do not claim tracking accuracy from a bounded evaluation that lacks adequate
  assignment coverage or representative multi-video evidence.
- Do not integrate an experimental tracker into V2A or another production path
  until a separate reviewed approval decision is recorded.
- JM-DEC-024 remains in force: tracker evaluation must not reopen detector
  score-threshold tuning without new evidence.


## 17. Reviewed Single-Attempt V2A Orchestration Rule

- The current Flutter V2A entry is a bounded reviewer/development workflow and
  must be labeled as manual, not automatic analysis.
- Start from the existing selected-video and camera-view state; preserve the
  independent V1 pose-summary flow.
- Require reviewed attempt start/end frame and timestamp, human-confirmed Tori
  neutral track and frame-local detection, independently human-confirmed
  support and attacking legs, reviewed angle frame/event, and reviewed camera
  suitability before submission.
- Do not turn the frame-local detection index into athlete identity. Tori is a
  human-confirmed event role; the retained track label remains role-neutral.
- Submit through the typed reviewed-video V2A service and fail closed unless
  the response matches the initiating video, camera and every reviewed gate.
- Accept exactly `UM-TIM-001`, `UM-ANG-001`, `UM-ANG-002` and `UM-ANG-003`.
  Missing, duplicated or inconsistent metric contracts must not render.
- Preserve a returned `review_required` or `withheld` status. Flutter must not
  promote it based on the presence of a numeric value or BLUE geometry.
- Keep multi-person evidence `insufficient` and interaction metrics
  non-reportable until a separately validated production gate changes that
  contract.
- JM-DEC-025 remains binding: the experimental greedy-IoU tracker is not part
  of this orchestration path.


## 18. Uchi Mata Navigation and Action Integrity Rule

- Every visible Uchi Mata action must either reach its intended existing
  destination or expose an explicit unavailable state with localized feedback.
- The technique section router is the source of truth for section
  availability. Dashboard cards and primary shortcuts must mirror that state;
  they must not advertise a placeholder as a completed capability.
- A disabled-looking card may remain tappable only to explain its unavailable
  state. It must not silently ignore the user.
- A media item without an approved source must remain visible only as an
  explicit unavailable item and must not open the video player. Search-result
  URLs are not direct approved competition-video destinations.
- Quiz submission must remain disabled until an answer is selected; answer,
  next-question and restart behavior must remain deterministic.
- Navigation-integrity work must not change V1/V2A contracts, scientific
  metrics, provenance, detector thresholds or identity/tracker policy.


## 19. Uchi Mata Approved Content Integrity Rule

- The Uchi Mata `TechniqueModel` and its locale-specific translations are the
  source of truth for identity, description, technical analysis, execution
  steps, key points, mistakes, safety guidance, combinations, counters, Quiz
  and references. Widgets must not duplicate or invent technical content.
- Resolve localized content field by field. A non-empty approved translation
  may replace its canonical field; a missing translated field falls back to
  the canonical content and must not be filled with newly invented material.
- The first three approved execution steps may be presented as Kuzushi,
  Tsukuri and Kake. Remaining execution steps must be rendered separately so
  no step is duplicated.
- General key points must not be relabeled as validated grip strategy, body
  position or tactical intelligence. Combinations and counters must not be
  relabeled as dedicated competition analysis. Missing dedicated tactical or
  competition sources require an explicit incomplete state.
- Search-result URLs are neither educational references nor direct media.
  Source rendering must accept only concrete HTTP(S) references with a title
  and host; media acquisition remains a separate approved block.
- Quiz UI must render the structured approved dataset, keep answer selection
  and progression deterministic, and expose an explicit empty state. Missing
  question translations must fall back to approved canonical questions rather
  than generating translations without review.
- Educational visualization must state that it is not measured/reconstructed
  3D biomechanics and does not report real force, torque, power or center of
  mass. It must not be recorded as completed scientific biomechanics.
- Content-integrity work must preserve the router availability boundary,
  Favorite, V1/V2A Analyze, scientific metrics, tracker/detector settings and
  all unavailable product destinations.


## 20. Reusable Technique Template Rule

- Technique Detail educational widgets must render the supplied
  `TechniqueModel`; they must not branch on a technique name or ID or embed
  canonical technique prose.
- Identity/classification, overview, technical analysis, execution steps, key
  points, mistakes, safety, combinations, counters, Quiz and Sources must use
  their structured model fields and support variable-length or empty data.
- Counts shown by the UI, including Quiz badges and progress, must be derived
  from the current model rather than copied from the Uchi Mata reference data.
- Reviewed Single-Attempt V2A support is an explicit model capability. It is
  fail-closed by default and must not be inferred from a label, route, ID or a
  generic read-only educational page. Non-Uchi generic detail exposes no
  analysis workflow.
- A synthetic technique used to prove template reuse must remain test-only,
  use neutral sentinel content and never be added to production data,
  navigation, localization or user-facing screens.
- Template validation must preserve approved technique content and must not
  complete excluded Media, Training, Progress, visual-learning or AI research
  work by implication.


## 21. Local Reviewed-Attempt Persistence Rule

JM-DEC-026 governs the local/demo-only persistence of reviewed Single-Attempt
V2A summaries.

- Persist only an immutable, versioned scientific summary after the user
  explicitly selects **Save locally**. Analysis completion must never trigger
  automatic persistence.
- Preserve the stable analysis ID, source response schema, analysis mode and
  scientific level, reviewed attempt/event binding, human-confirmed neutral
  track and limb selections, all four original metric IDs and their unchanged
  value/unit/status/provenance/method/confidence/limitations, multi-person
  evidence boundary, interaction reportability and local UTC save time.
- Do not persist video bytes, paths, filenames, video IDs, images, overlays,
  frame-local detection indices, aggregate scores, mastery/completion,
  performance trends or Profile data.
- Treat eligibility as contract integrity, not good performance. A valid
  `review_required` or `withheld` result must retain that status unchanged.
- Use a dedicated versioned SharedPreferences key separate from general user
  preferences. Deduplicate only by the existing stable analysis ID and keep
  ordering deterministic.
- Unsupported schema, status or provenance and malformed/corrupt storage must
  fail closed. A corrupt payload must not be silently replaced or destroyed.
- Surface explicit saved, already-saved and failure states. Do not claim
  backend, authentication, account sync, cloud backup, History UI, Profile or
  Progress integration from this local foundation.

## Local Profile and Scientific History Presentation Rule — 2026-08-12

- Profile fields must stay optional, bounded and explicitly self-reported.
- Local Profile must not imply verified identity, official rank, federation
  data or a cloud account.
- V2A History must preserve original status, provenance, method, confidence
  availability, limitations and withheld reason without promotion.
- Corrupt Profile or History storage must fail closed and not be overwritten.
- Only stored-record counts and original metric-status counts are permitted.
  Scores, mastery/completion, trends, averages and cross-attempt comparisons
  require a separate validated decision and are not authorized here.
- Profile History does not authorize Progress Analytics, athlete assessment or
  Training Center integration.

---

## 22. Platform Framework and Canonical Module Registry Rule

JM-DEC-027 governs the platform/module boundary.

`docs/JUDO_MIND_PRODUCT_FRAMEWORK.md` is the mandatory canonical charter for
approved product intent and must be read completely with the other mandatory
governance documents before any Judo Mind task. It does not replace the code
registry, architecture, implementation rules, decisions, validated status or
changelog; each retains the responsibility defined in that charter.

- The product has exactly 18 official modules registered once through the
  canonical project registry. Analysis modes are shared capabilities and do
  not create additional modules.
- The coordinated platform surfaces are Athlete App, Coach Workspace,
  Club/Federation Console and Judo Intelligence Core.
- Registration is not activation. A module without an approved destination
  must retain a null route, explicit unavailable/deferred status and reason.
- Never create a fake route, placeholder screen or working-looking action to
  satisfy the module count.
- The 18 modules must not automatically become 18 equal Athlete Home tiles.
  The future Athlete Home is organized around Learn, Train, Analyze, Track
  Progress and Connect with Coach.
- Uchi Mata Gold remains the product-critical reference slice. Do not expand
  all 67 techniques before a second neutral technique proves reuse.
- Athlete Profile, Training Center, Monitoring/Progress and grounded AI Sensei
  form the next athlete loop. Coach/Club and Training Program Validator follow.
- Sensi Bet remains isolated/deferred pending legal, age, ethical and
  federation-brand review.

## 23. Localization Completion and RTL Contract

- Selecting Persian requires Persian user-facing UI and approved content for a
  completed production surface. Selecting English requires English.
- Japanese technique names may remain Japanese alongside the selected-language
  explanation.
- The contract covers labels, structured technique content, Quiz, Sources,
  validation errors, analysis results, safety and future grounded AI Sensei
  output.
- RTL includes layout, navigation direction, directional icons, charts and
  interaction order, not text alignment alone.
- Silent English fallback may remain a disclosed development fallback for
  incomplete content, but must never be reported as completed Persian content.
- Missing/unapproved translation must fail honestly as incomplete/unavailable;
  AI must not bulk-invent translations to close a product gate.
- Extend the current ARB/generated-localization architecture; do not introduce
  a second localization system.

## 24. Technique-Specific Training Content Activation Rule

- Shadow Training, Strength & Conditioning and Resistance-Band content must be
  structured through the reusable `TechniqueModel` training contract.
- The default contract is empty and unavailable.
- A drill requires stable identity, kind, localized title/objective, related
  phase, structured steps, approved prescription, athlete level, media,
  safety, source/provenance and explicit approval before activation.
- Missing media, safety, source, prescription or selected-language content
  keeps the drill unavailable. Generic filler and invented exercise dosage are
  prohibited.
- A visual-learning prototype does not authorize a drill or prescription.
- Kind-specific evidence is mandatory: Shadow requires an approved movement
  path/presentation contract; Conditioning requires a target movement pattern
  and common-error contract; Resistance-Band requires anchor location/height,
  resistance direction, grip mapping, rotation path, leg roles, safe distance
  and dangerous-error warning. A configuration for one kind cannot activate
  another kind.
- Selected-language resolution covers title, objective, phase, equipment,
  steps, athlete level, safety and all kind-specific explanatory fields. A
  partial Persian record must not reveal English drill content as completed.
- Shadow, Conditioning and Resistance-Band use distinct primary renderers.
  Missing structured visual/media evidence displays no fabricated diagram.
- Repetition tracking and History recording are capability flags, not implied
  production capabilities. Prescription fields render only from approved
  structured values.
- The Uchi Mata authoring gate is recorded in
  `docs/content_authoring/UCHI_MATA_TRAINING_CONTENT_APPROVAL_TEMPLATE.md`;
  every production entry remains unavailable until its review fields pass.

## 25. Icon Evidence and Approval Rule

- `JudoIcons` remains the semantic registry; custom assets enter through the
  Design System renderer rather than feature code.
- Distinguish custom-implemented, Material-temporary, proposed, missing and
  historically referenced icons.
- Do not claim an icon count or taxonomy that repository evidence cannot
  reproduce. The historical approximately-120 target is not an exact manifest.
- Each future manifest row requires semantic ID, subset, owner/surface,
  implementation status, asset/license, accessibility, RTL policy, QA and
  approval/version metadata.
- Direct Material usage must be classified before replacement. Generic
  platform actions and feature-semantic icons are not assumed equivalent.
- `design/icon_system/judo_icon_manifest.v1.json` is the machine-readable
  artwork lifecycle/evidence source. It cannot activate runtime assets or
  override `JudoIcons` mappings.
- Candidate SVGs remain outside runtime asset paths and must retain
  `candidate_review_required` until semantic, Judo, originality/license,
  accessibility, RTL, size and Design System review pass explicitly.
- The unresolved 69 positions between 51 evidenced IDs and the approximate 120
  target remain unnamed. Candidate work may use only evidenced semantic IDs.
- Production-approved custom count remains zero until explicit human approval
  updates both the manifest and runtime implementation through the Design
  System.

## 26. Bounded Four-Hour Work Order Rule

- An authorized four-hour mission is converted into one internal bounded Work
  Order containing Objective, Current Context, Constraints,
  Scientific/Technical Requirements, Files Likely Affected, Acceptance
  Criteria, Validation/Tests, Documentation Requirements and Git Safety.
- Four hours is a maximum wall-clock boundary, not permission to fill time,
  expand scope or weaken product, scientific, security or Git safeguards.
- Begin with complete mandatory-governance review and working-tree inspection;
  implement the smallest coherent scope, validate proportionately, synchronize
  required documentation and stop at a safe report/checkpoint.
- Do not repeat completed work. Record genuine blockers precisely and continue
  only independent safe work within the authorized scope.
- The Work Order never grants destructive Git, Push, external publication,
  credentials, paid services, scientific claims or adjacent development unless
  those actions are explicitly authorized.

## 27. Grounded Sensei V1 Rule

- Grounded Sensei V1 is deterministic and local. It has no free-form prompt,
  external AI provider, network call, API key or model inference.
- It may consume only one exact human-reviewed Uchi Mata V2A request/result
  pair that passes the existing scientific boundary and contains exactly one
  each of `UM-TIM-001`, `UM-ANG-001`, `UM-ANG-002` and `UM-ANG-003`.
- Technique, analysis, video, event boundaries, selected frame, neutral track,
  detection index, support/attacking legs, camera review and locale remain
  bound to their reviewed source. Any mismatch fails closed.
- Preserve source metric values, statuses, provenance, confidence availability
  and method versions. Never upgrade `review_required` or `withheld`, invent a
  confidence score, classify performance or infer identity, phase, leg roles,
  interaction, 3D or kinetics.
- Explanatory copy must be localized through the existing ARB system. Approved
  technique safety may be shown only in the selected language; missing content
  is unavailable, not silently replaced.
- A drill recommendation requires a separately approved metric-to-drill
  mapping. Until one exists, next action remains explicitly unavailable.
- Grounded Sensei failure must not remove or alter the scientific V2A result,
  BLUE geometry or local History behavior.

## 28. Athlete Home Information-Architecture Rule

- Athlete Home has exactly five journeys: Learn, Train, Analyze, Track
  Progress and Connect with Coach. These journeys are navigation concepts, not
  additional official modules.
- Learn opens the Techniques catalog. The current Home Analyze entry is
  explicitly scoped to the featured Uchi Mata reference and opens only its
  existing V1/human-reviewed V2A boundary.
- Track Progress opens the existing local scientific History destination, not
  the Athlete Profile editor. It must not create a score, mastery claim, trend
  or second persistence contract.
- Train and Connect with Coach remain visible and fail closed until their
  approved product, evidence, safety, privacy and authorization gates exist.
- A Hero action must not duplicate Learn. It may use real initialized local
  History; otherwise it opens the featured/reference technique supplied by a
  reusable product source outside Home. Home widgets must not branch on a
  technique name or ID.
- Header Profile and Settings shortcuts retain their semantic destinations.
  A corresponding registry entry may duplicate a persistent header shortcut
  when the roles are clear.
- The module directory renders the canonical 18-module registry, may filter by
  approved platform-surface metadata and presents real destinations before a
  visually separate or collapsed unavailable/deferred group. It must not
  invent routes or repeat one long generic explanation on every closed row.
- Home inside its own directory is the current destination and must not push a
  second Home instance. Root Home has no synthetic Back action; explicit
  nested Home may retain normal Back behavior.

## 29. Local Settings Foundation Rule

- App Management & Settings may expose only preferences and actions backed by
  real local behavior. A working-looking toggle must not be shown for an
  unavailable notification, cloud, account, subscription, synchronization,
  theme or AI-conversation capability.
- English and Persian selection uses the existing locale provider and local
  preferences storage. The selection applies immediately and persists across
  provider/application recreation; Persian Settings is RTL and all Settings
  copy added by this foundation exists in both languages.
- The local-data section may report only the count returned by the initialized
  versioned Analysis History provider. Clearing requires explicit confirmation
  and targets only the History repository; Profile, language and unrelated
  local data remain outside that operation.
- Corrupt or unsupported History payloads fail closed and must not be silently
  overwritten by a clear request. Settings must not claim cloud sync,
  federation sync or encryption that has not been implemented and validated.
- Scientific transparency reuses authoritative capability/analysis contracts;
  it does not reproduce formulas or upgrade statuses. The approved Uchi Mata
  V2A metric set, `review_required`, insufficient multi-person evidence and
  non-reportable interaction boundary remain unchanged.

## 30. Scientific Progress Evidence Foundation Rule

- Progress Overview is a deterministic read-only projection of the existing
  versioned local V2A History. It must not create a second persistence store or
  alter the raw History destination.
- Counts may include only valid stored attempts, supported record statuses and
  the separate `reportable`, `review_required` and `withheld` metric statuses.
  Latest timestamp, technique identity and method versions are evidence context,
  not performance interpretation.
- Missing, malformed, unknown or scientifically inconsistent evidence fails
  closed. Incompatible metric versions must not be combined or compared.
- The foundation must not produce mastery percentage, performance/readiness
  score, ranking, proficiency level, coaching grade, prediction, trend,
  improvement or degradation claim, or invented confidence.
- `UM-ANG-001` remains `review_required`; multi-person evidence remains
  insufficient and interaction metrics remain non-reportable.
- Monitoring / Progress & Mastery may be reachable only as an explicitly
  foundation-only Progress destination. Mastery remains unavailable until a
  separately approved and scientifically validated contract exists.
- Athlete Home Track Progress continues to open Local Analysis History. The
  official Monitoring module route is the separate Progress Overview and must
  not recreate duplicate Home navigation.

## 31. Technique Journey Content-Ownership Rule

- A technique field has one canonical user-facing owner. Overview owns identity,
  classification, concise description and verified metadata; Technical Lesson
  owns Kuzushi/Tsukuri/Kake, execution steps and key points; Mistakes & Safety
  owns mistakes and safety; Combinations & Counters owns those relationships.
- Practice, tactical and competition destinations must not reuse learning fields
  as fallback content. Without an approved destination-specific contract they
  remain concise and explicitly unavailable or incomplete.
- Each technique hub exposes exactly one local Single-Attempt Analyze entry.
  Media, continuation prompts and pre-result coaching must not create parallel
  analysis entrances. Grounded Sensei remains post-result only.
- Technique hubs keep one primary next action, compact journey navigation and
  secondary capabilities behind a collapsed More section. Availability remains
  fail closed and cannot be inferred from placeholder prose.

## 32. Persian UX Writing Rule

- User-facing Persian follows `docs/PERSIAN_UX_WRITING_GUIDE.md`.
- Primary cards use short athlete-facing language. Engineering state, metric
  identifiers and version details belong behind `جزئیات علمی`.
- Dynamic taxonomy, difficulty, availability, status and provenance values must
  be localized before rendering. Missing Persian content fails closed rather
  than silently falling back to English.
- Japanese Judo terms may remain with Persian context. Scientific identifiers
  remain exact and must never be translated or used to imply stronger evidence.

## 33. Persian Runtime Localization Contract

- Every non-metadata message in the English runtime template must have an
  explicit Persian entry. A missing Persian entry may not silently inherit the
  English template value.
- Before adding or retaining a localization message, verify a typed runtime
  consumer. Unreachable legacy aliases must be retired instead of translated
  or allowlisted merely to suppress generator output.
- Approved invariants, scientific identifiers, Japanese Judo terms, URLs,
  sources, brands and proper nouns require an explicit audited classification;
  they are not blanket exceptions to Persian completeness.
- Missing approved educational or capability content remains fail closed. A
  localization closure task must not invent that content.
- `docs/PERSIAN_LOCALIZATION_AUDIT_V1.md` records the validated 261-message
  legacy closure and its exact classifications.

## 34. Detached Device-Validation Runner Rule

- The canonical runner is
  `D:\projects\judo_mind_checkpoints\run_judo_mind_device_validation_canonical_v3.ps1`.
  Historical v1/v2 runners are evidence and must not be silently overwritten.
- Possibly null/scalar command output must be normalized before `.Count`.
  PowerShell's automatic `$PID` is read-only and case-insensitive; application
  process IDs use `$appProcessId`.
- Native exit code is authoritative. Stderr warnings with exit code zero are
  logged and remain successful.
- A device state must distinguish authorized, unauthorized, offline, missing,
  wrong-model and invalid output before any build.
- `-SyntaxCheck`, `-SelfTest` and `-PreflightOnly` are mutually exclusive
  safe modes. Self-test and preflight may not build, install or launch;
  preflight also performs no ADB command.
- Normal execution retains the one-build-attempt limit, two-reading memory
  gate, new-APK timestamp/hash gate, guided non-destructive captures and strict
  before/after Git/source preservation.
- The operator command and result categories are governed by
  `docs/DEVICE_VALIDATION_RUNBOOK.md`.

## Runtime Catalog and Affordance Truthfulness

- Never present the `67`-technique roadmap target as the number of
  production-ready runtime techniques. Report runtime, production, preview and
  roadmap counts separately.
- Incomplete technique records must be excluded or visibly marked preview and
  unavailable. They may not open a production Technique Detail experience.
- Do not display a second taxonomy field when its source is unsupported,
  duplicated or contradictory. Hiding unsupported detail is preferable to
  inventing a correction.
- A media record without an approved payload must have no active play, open,
  analysis or full-screen affordance. Unavailable presentation must be visually
  and semantically disabled.
- Educational movement diagrams must visibly state that they are not
  measurements. Illustrated directions, balance and body-position concepts may
  not be described as measured force, center of mass, torque, power or 3D.
- Organization homepages are general references unless a direct
  technique-specific source is evidenced; do not label root URLs as direct
  technique evidence.

## 35. Athlete Information Architecture Truthfulness

- Preserve the five primary athlete journeys, but give primary navigation
  prominence only to real working destinations.
- Unavailable Train and Coach experiences remain compact, non-interactive and
  explicitly `Coming later`; they may not compete visually with working
  actions.
- Home Track Progress opens the evidence-only Progress Overview. Raw History
  remains a distinct downstream destination, and an empty Progress state must
  not route users into an empty History loop.
- The secondary Platform Overview must derive identities and availability from
  the canonical 18-module registry. Internal engineering-readiness labels are
  not primary athlete-facing copy.

## 36. Credit-Aware Execution and Local Club Administration

- ChatGPT/Codex credit is a bounded execution resource. It must never lower
  scientific, safety, localization, test or Git-preservation standards.
- Prefer one coherent implementation followed by one targeted validation
  batch. Do not repeatedly test after each edit or restart completed work.
- If credit becomes low, finish the smallest truthful acceptance boundary and
  preserve/report exact state; do not label partial work complete.
- Club Administration local storage uses a dedicated versioned repository
  boundary and fails closed on malformed, unexpected or incompatible data.
  Invalid stored data is not silently overwritten.
- The current Profile is one local-athlete slot. Club membership may reference
  that slot only and must not copy Profile personal, sport or body fields.
- Attendance is an explicit typed user record (`present`, `absent`, `excused`).
  It is not inferred and cannot be promoted to performance, readiness, load,
  medical or scientific evidence.
- The local foundation visibly discloses that cloud sync, real multi-user
  authorization and federation verification are unavailable.
- Club session plans use snapshot schema `2.0.0`. A valid `1.0.0` payload is
  migrated in memory without changing its stored source; an intentional later
  write persists the upgraded representation. Unknown or malformed schemas
  continue to fail closed.
- Every new session requires an explicit typed session classification. The
  `unspecifiedLegacy` type exists only to preserve migrated records and must
  not be selectable or accepted for a newly authored session.
- Structured session items and dosage are coach-authored planned data. Numeric
  values must satisfy their selected dosage contract, contradictory fields
  are invalid, and no duration, repetition, set, round, rest, distance,
  intensity or scientific load may be inferred or generated.
- Planned items do not prove completion. Actual execution, athlete-specific
  modification, workload, readiness, injury risk and scientific monitoring
  remain unavailable. Physical-conditioning entries are custom coach content,
  not an approved exercise-library prescription.

## 37. Club Session Composer Draft and Persistence Rule

- A session create/edit flow is one scrollable composer. Session metadata,
  ordered plan sections and the live summary stay in memory until the coach
  invokes the single final save action.
- Adding, editing, duplicating, deleting, expanding or reordering a draft item
  must not write partial state to the repository. Cancel or confirmed discard
  leaves the stored session unchanged.
- Each draft item reserves a stable item ID without persistence. Duplicate
  creates a distinct ID; final order is normalized only in the complete saved
  session. An edit must preserve the session identity, timestamps and existing
  attendance through the provider/repository boundary.
- Accordion dosage fields are mode-specific. Hidden irrelevant fields do not
  enter the saved dosage contract. Standard categories may carry an optional
  coach title; the two custom categories still require meaningful coach text.
- Live time summaries may add only explicit duration values and explicit
  rounds multiplied by minutes per round. Repetitions, sets, distance or
  descriptive dosage have unknown duration unless separately entered through
  an approved future contract; no time may be inferred from them.
- Unsaved exit must fail closed through localized continue-editing/discard
  confirmation. English, Persian and RTL remain complete at narrow mobile
  widths. This UX rule does not create an Exercise Library, prescription,
  completed-training record or scientific load calculation.
## Exercise Library Scientific Boundary

- Reuse the canonical Club activity-category and dosage contracts.
- Approved exercise status fails closed unless English/Persian localization,
  source, provenance, reviewer identity and review time are all present.
- Coach-authored exercises always remain `notScientificallyReviewed`; never
  promote them implicitly or generate prescriptions, loads, RPE/RIR, %1RM or
  safety claims.
- Saved plans retain immutable exercise ID/revision/display evidence; later
  library edits or archive state must not rewrite historical sessions.
- CSV bulk import is an authoring convenience, never an approval or evidence
  pipeline. Ignore/reject any attempt to supply review status, reviewer
  identity, prescription or generated scientific fields; accepted rows remain
  coach-authored and not scientifically reviewed.
- CSV parsing and preview must not write. Import confirmation performs one
  atomic repository transition using stable unique IDs; cancellation,
  duplicate IDs, malformed schemas and unsupported enums fail closed.
- Require the declared `authoring_locale` name and never copy the other
  language as fallback. Approved repository content continues to require the
  complete bilingual evidence contract.
- Favorites and recents are local selection preferences only. They must not
  imply effectiveness, recommendation, adherence, completed training or
  scientific quality, and recency must be updated only after explicit coach
  selection.

## Polyglot and Platform Evidence (JM-DEC-029)

Flutter/Dart remains the shared client default and Python remains the AI and
scientific-computation default. A new native/systems technology requires a
documented need, measurable benefit, security implications, Build/test method
and maintenance owner. Audit package support per target and isolate OS-specific
features behind interfaces/adapters. A successful Build on one OS is not
evidence for another; never claim iOS validation without macOS/Xcode evidence.
Do not rewrite the Flutter client without technical evidence.

## Scientific Transparency UI Rules

- Scientific transparency surfaces are informational and read-only; they must
  never act as an approval, eligibility, activation, prescription, scoring, or
  developer-override surface.
- Map only governed current states. Unknown, missing, malformed, or unsafe data
  must fail closed to locked/not scientifically reviewed.
- Label candidate sources as candidates with review pending. Bibliographic
  presence is not claim support and must never be promoted without an explicit
  reviewed claim-level link.
- Do not expose reviewer personal data, local paths, hashes, internal IDs,
  governance notes, formulas, thresholds, or enable flags in athlete UI.
- Keep English and Persian complete, localize raw states, preserve RTL and
  accessibility, and state single-camera/video limitations without implying
  force, kinetics, definitive 3D biomechanics, diagnosis, prediction, or
  referee decisions.
- User-facing terms such as approved, reviewed, validated, scientific, and
  evidence must identify their exact governance layer. Editorial inclusion,
  software availability, human-checked engineering validation, and saved local
  engineering summaries must not be described as scientific approval or
  scientific-analysis history unless the governing registry explicitly grants
  that classification.

## Generic Non-Uchi Technique Detail Rule

- Canonical identity, route compatibility, product eligibility, content
  readiness and scientific approval are independent gates. Passing one must
  not silently satisfy another.
- Accept only an exact unique canonical catalog ID. Malformed, unknown,
  duplicate and non-eligible identities fail closed.
- ID `001` remains on the specialized Uchi Mata path. A non-001 record may use
  only the generic read-only adapter and only after its explicit readiness row
  and product eligibility entry pass.
- Generic detail renders only fields present in the record and exact
  selected-language content. Missing localized fields remain unavailable;
  never invent content or silently present English fallback as completed
  Persian.
- Generic detail must not expose Uchi scientific status/sources, video
  analysis, metrics, scoring, mastery, diagnosis, prediction, prescription or
  unfinished destination actions.
- A shared route or passing synthetic widget test never unlocks a production
  technique. Synthetic technique fixtures remain test-only.

## Technique Explanation Content Governance Rule

- Keep `TechniqueModel` canonical. Reuse its exact identity, overview,
  technical explanation, general steps, coaching points, mistakes, safety,
  combinations, counters, localization, media, Quiz and sources. Add only
  documented schema-gap fields through the optional
  `TechniqueExplanationExtension`; do not create a parallel technique model.
- Treat route readiness, educational-content readiness, technical review and
  scientific review as independent gates. The explanation extension defaults
  to unavailable and never grants route or analysis capability.
- Resolve generic extension text only for the exact selected language. Missing
  optional content is `Unavailable` / «در دسترس نیست»; never fabricate,
  auto-translate or borrow Uchi Mata content for another technique.
- Keep technical explanation, conceptual mechanical interpretation and
  biomechanical results separate. Classify every relevant statement as
  `CONCEPTUAL`, `OBSERVED`, `MEASURED`, `RECONSTRUCTED`, `MODEL_ESTIMATED` or
  `AI_INFERRED`. Ordinary video cannot provide direct force/kinetic measurement
  or definitive 3D biomechanics.
- Do not use “breaking the opponent’s center of gravity.” Prefer the governed
  centre/center-of-mass projection and base-of-support wording recorded in the
  bilingual standard.
- Show visual/video material only with an allowed rights basis, provenance,
  licence/permission reference and selected-language accessible description.
  Conceptual movement/force arrows must carry the exact bilingual disclaimer.
- Do not copy, trace, download, translate, embed or redistribute an external
  inspiration image/text. It is neither an official nor scientific source.
- Keep Overview, Execution phases and Key coaching points prominent, use
  expandable long sections, retain Persian RTL, and avoid repetitive warning
  cards. Scientific/evidence-sensitive optional sections remain hidden when
  their fail-closed record is incomplete.
- Implementing this standard must not populate all 67 techniques, unlock a
  technique, activate science/AI/video analysis, or create an approval,
  threshold, rule, metric or prescription.

## Canonical Technique Identity Rule

- Use `JM_CANONICAL_TECHNIQUE_IDENTITY_REGISTRY.csv` for official catalog
  identity. Never infer identity from display order, route success, filename,
  alias similarity or model fullness.
- Preserve existing IDs. A normalized mapping marked human-review-pending is
  not a verified project identity and must fail closed in production routing.
- Never collapse identity, classification, Persian-name, model, content,
  technical review, scientific review, media-rights, route or unlock states
  into an `approved` flag.
- A registry row creates no `TechniqueModel`, translation, content, evidence,
  scientific approval, analysis capability or unlock.
- Unknown, duplicate, unresolved, conflicting, pending or model-missing
  identities remain locked. Any future eligibility change requires its own
  bounded content/review milestone.

## Frame-Accurate Attempt Timing Rule

- Guided Single-Attempt boundaries must resolve to server-owned decoded frame
  references bound to an opaque timing manifest and exact video content.
- Decoder-reported and average-FPS-derived timestamps are distinct; derived
  timing must never be called true PTS.
- Users visually inspect and explicitly confirm start/end boundaries. Any
  boundary or review-frame change invalidates that confirmation.
- Editing a prepared attempt must preserve only the source timing/manifest and
  current frame selections needed for correction. It must clear the preview,
  confirmations, prepared session, candidate/Tori review and downstream result
  or explanation; returning to old frame values never restores confirmation.
- Frame-accurate boundaries do not prove single-attempt semantics. Guided
  PREPARE additionally requires a human-confirmed `SINGLE_ATTEMPT` assertion
  bound to the exact video, manifest and interval. Never infer it from the
  existence of boundaries or label it AI/model confirmed.
- `REAL_TIME`, `KNOWN_TIME_SCALE` and `UNKNOWN` are explicit source states;
  never infer real time or slow motion without validated evidence.
- `UM-TIM-001` is selected-window elapsed time, not automatically detected
  Uchi Mata duration. Unknown/unreliable timing withholds physical duration.
- Raw video, previews, pose arrays and tokens stay temporary. History retains
  only minimal canonical frame/timing provenance.
- This rule authorizes no tracking, role inference, phase detection, scoring,
  time-series biomechanics, kinetics or 3D claims.

## Frame-Local Multi-Person Candidate Evidence Rule

- Preserve the invariant `FrameCandidate != TemporalTrack !=
  HumanRoleAssignment`. A candidate returned for one selected frame is neither
  a tracked identity nor a Judo role.
- Define `detected_pose_count` only as the number of model-returned poses in the
  selected frame. Never describe it as people, judoka, tracks or identities.
  Maintain a separate `selectable_candidate_count` for usable frame candidates.
- Require at least two independent selectable pose-available candidates before
  entering the D2 human-selection path. One usable candidate is insufficient;
  it does not prove a single-person scene. Zero usable candidates is explicitly
  non-selectable.
- Enforce candidate-set eligibility in the server-owned session. Flutter
  disabled state is defense in depth and never the sole scientific/safety gate.
- PREPARE must not assign Track A/B, Tori/Uke or any temporal identity.
  Detection order/index is frame-local model output only. A neutral label used
  after explicit human Tori confirmation is analysis-local, not tracking.
- Candidate evidence may report pose availability, model-estimated provenance,
  required-landmark availability and whether model visibility fields exist.
  Never present landmark visibility as accuracy, identity/tracking confidence,
  technique quality or scientific confidence.
- Until approved tracking exists, track status is `unavailable`, neutral track
  ID and association confidence are null, and the reason is
  `frame_local_candidate_only_no_tracking`.
- Preserve V2A 2.0.0, its four metrics and scientific limits. D2 does not enable
  automatic identity, phase/attempt detection, tracking, multi-person
  interaction metrics, 3D, kinetics, scoring or coaching truth.
- MediaPipe VIDEO-mode context for Guided PREPARE may use a bounded,
  frame-rate-aware pre-roll ending at the exact human-selected Review Frame.
  It must never cross the human-confirmed attempt start, and the bound must be
  named and documented as an engineering limit rather than a validated
  scientific, universal or Judo-specific threshold.
- Discard every warm-up output. Only the exact Review Frame may contribute
  candidate evidence. Warm-up frames cannot create a candidate, track, role,
  phase, metric, History record or Sensei evidence.
- Isolate Guided VIDEO-mode context between requests while preserving
  monotonic timestamps and concurrency protection. Temporal context is not
  temporal identity and must never be reported as tracking.

## Human-First Role Assignment Rule

- Preserve the sequence `Observation -> Evidence -> Human Confirmation ->
  Analysis -> Coaching Support`.
- Human confirmation is the only allowed source for Tori role assignment in
  the current Guided Technique Intelligence path. Never emit or accept
  `AI_DETECTION` as a role source.
- Bind the explicit assignment to the opaque candidate token owned by the
  current server review session. Missing, forged, cross-session or
  identity-bearing assignments fail closed.
- Keep candidate selection empty by default. Candidate changes invalidate role
  and all dependent review confirmation. Flutter disabled state is defense in
  depth; the backend remains authoritative.
- Clothing colour may help a human distinguish visible candidates but is not
  identity, tracking, role or scientific evidence.
- Do not modify the V2A schema, metrics or scientific status merely to carry
  the Guided role assignment. Do not implement Competition Timeline or Coach
  Marketplace behavior without a separate approved Work Order.

## JM-UM-GS-0 Uchi-mata Gold Foundation Rules

- Treat `uchi-mata-gold-foundation-1.0.0` as a research/governance schema, not a
  runtime capability. Do not import it into production FastAPI, V2A or Flutter
  without a separately approved implementation gate.
- Keep canonical source identity in `JM_SOURCE_INVENTORY.csv`, metric identity
  in `JM_METRIC_AND_THRESHOLD_INVENTORY.csv`, current Uchi-mata metric state in
  `JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv`, and capability state in
  `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv`. Gold profiles must reference rather
  than supersede those identities.
- Preserve unknown evidence as `UNKNOWN`, `NOT_REPORTED` or a scoped equivalent.
  Do not infer a population, sample, method, result, rights status or
  applicability from title, organization prestige, athlete success or model
  output.
- Keep E0–E7 research-only. E4/E5 are provisional. A source-operational phase
  definition is not a universal Judo doctrine, and no event/phase may become
  automatic Ground Truth without a versioned annotation and validation gate.
- Use only `measured`, `reconstructed`, `model-estimated` and `AI-inferred`
  provenance. Model confidence/visibility is not measurement validity or pose
  accuracy.
- A Gold validation-gap row becomes `GREEN` only when every exact evidence,
  method, population, validity, reviewer and rights requirement is satisfied.
  Green still does not automatically activate production.
- Keep the interpretation-rule registry empty until a separately authorized
  rule has exact evidence, measurement validity, uncertainty, population,
  abstention, technical interpretation, coaching implication and human approval.
  Sensei may translate an authorized structured finding; it may not create one
  from raw video.
- Training or commercial training use requires exact
  `LICENSED_FOR_TRAINING` evidence. Official hosting, open access or reference
  linking does not grant media copying, data processing or model-training rights.
- Do not introduce force, torque, moment, power, injury-risk, universal ideal,
  technique score or correct/incorrect judgement through this foundation.
- JM-C2.1-D2 remains a separate active gate. Do not use Gold foundation work to
  hide or close its MediaPipe VIDEO-mode lifecycle/reproducibility debt.

## JM-UM-GS-1 Evidence-to-Interpretation Rules

- Every scientific claim must resolve to one canonical `JM-SRC-*` identity and
  preserve population, method, context, result, uncertainty, limitation,
  permitted use and rights. Unreported fields remain explicit.
- Never convert an association, group difference, elite case, successful throw
  or expert observation into causation, an individual target, universal ideal,
  threshold, score or coaching rule.
- Keep official identity/terminology, elite visual/volumetric reference,
  scientific-study data and markerless method validation as separate evidence
  roles. In particular, AJJF Ono media and the Ishii/Ono case study are not the
  same dataset without explicit linkage evidence.
- Markerless validation from walking, squat, jump or non-Judo dyadic tasks may
  support validation design only. Its errors, camera angles and feasibility may
  not establish Uchi-mata or current-pipeline validity.
- Camera requirements are per-measurement research inputs, not a final user
  filming protocol. Do not invent minimum Uchi-mata resolution, FPS or camera
  angle where the evidence says `NOT_ESTABLISHED`.
- Data availability and data rights are independent. Public access does not
  grant participant-video, model-training, training-product or commercial-use
  permission.
- Enforce the order `source -> claim -> measurement validation -> reference
  applicability -> approved interpretation -> coaching`. Sensei receives only
  an authorized structured finding and must never generate a finding from raw
  video or raw metrics.
- A claim, matrix, camera or acquisition row is non-production by default.
  Candidate and yellow states do not activate anything. Green requires explicit
  item-specific activation evidence and still needs a separate production gate.
