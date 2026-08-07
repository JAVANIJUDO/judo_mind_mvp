# Judo Mind AI Development Rules

Version:
2.1

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

This guarantees visual consistency across all 17 modules.

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
