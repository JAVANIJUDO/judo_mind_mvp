# JUDO MIND — BIOMECHANICAL & TECHNIQUE INTELLIGENCE GOVERNANCE
## JM-BTIG-01 — Mandatory Project Rule

Status: ACTIVE
Authority: Project Architecture / Scientific & Technical Governance
Scope: Judo Mind
Rule Type: MANDATORY
Fail Mode: FAIL-CLOSED

---

## 1. VIDEO IS NOT ANALYSIS

Extracting skeletons, keypoints or joint angles alone does not constitute
Technique Analysis.

Official Judo Mind chain:

Video
→ Person/Role Identification
→ Pose Estimation
→ Tracking
→ Movement Segmentation
→ Technique Phase Detection
→ Biomechanical Variables
→ Technique-Specific Relationships
→ Validated Interpretation
→ Coaching Insight

---

## 2. TECHNIQUE CONTEXT IS MANDATORY

No joint angle or movement variable may be interpreted outside the context
of the technique.

Where relevant, interpretation must account for:

- Tori / Uke
- Left / Right execution
- Support leg
- Attack leg
- Grip
- Direction
- Technique
- Technique phase
- Body orientation
- Opponent interaction

---

## 3. PHASE-AWARE ANALYSIS

The same angle may have different meanings in different phases.

Technical metrics should therefore be phase-aware wherever applicable.

Potential throw phases include:

- Preparation
- Kuzushi
- Tsukuri
- Entry
- Loading / Positioning
- Kake
- Projection
- Landing / Transition

These phases must not be reduced to one overall score without validation.

---

## 4. MEASUREMENT CLASSIFICATION

Every analytical output must declare its measurement class:

- Observed
- Computer-Vision Measured
- Derived
- Estimated
- Modeled
- AI-Inferred
- Coach Entered

AI-Inferred information must never be presented as Ground Truth.

---

## 5. BIOMECHANICAL MODEL BEFORE AI JUDGMENT

AI must not generate judgments such as:

- Excellent technique
- Incorrect Kuzushi
- Poor balance
- Perfect Uchi Mata

unless the judgment is traceable to an appropriate metric, rule or
validated model.

An LLM must not replace the Biomechanical Engine.

---

## 6. TECHNIQUE-SPECIFIC MODELING

A model validated for one technique is not automatically valid for another.

Uchi Mata Model
≠ Seoi Nage Model
≠ O Soto Gari Model

Each technique requires an independent Metric Registry and validation,
or explicit evidence supporting shared metrics.

---

## 7. RELATIONAL ANALYSIS

Judo Mind must not reduce biomechanical intelligence to isolated values such as:

Hip = X°
Knee = Y°
Ankle = Z°

The target is analysis of relationships among:

Joint configuration
+
Timing
+
Direction
+
Velocity
+
Relative Tori/Uke position
+
Support
+
Technique phase

Meaning must be derived from relationships rather than isolated numbers.

---

## 8. REFERENCE ≠ UNIVERSAL IDEAL

A champion or reference execution must not be treated as a universal perfect
technique without supporting evidence.

Model design must consider, where relevant:

- Anthropometry
- Height
- Limb length
- Weight category
- Laterality
- Opponent morphology
- Grip
- Tactical situation
- Individual style

---

## 9. VALIDATION LADDER

Every metric or technique model must have a traceable validation state:

JM-V0 — Hypothesis
JM-V1 — Literature Supported
JM-V2 — Computationally Verified
JM-V3 — Expert Reviewed
JM-V4 — Controlled Video Validated
JM-V5 — Multi-Athlete Validated
JM-V6 — Competition / Field Validated

Validation level must be explicitly recorded and traceable.

---

## 10. COMPUTER VISION CONFIDENCE

The system must account for uncertainty caused by:

- Occlusion
- Camera angle
- Motion blur
- Low resolution
- Tori/Uke overlap
- Keypoint uncertainty

When reliability is insufficient, confidence must be reduced or analysis
must abstain.

"No reliable measurement"

is preferable to false precision.

---

## 11. 2D / 3D LIMITATION

Angles or positions derived from 2D video must not be represented as equivalent
to 3D motion-capture measurements without validation.

Camera perspective and out-of-plane motion must be treated as model limitations.

---

## 12. COACHING INSIGHT GATE

Approved conceptual path:

Measurement
→ Metric
→ Relationship
→ Validation
→ Interpretation
→ Coaching Feedback

Prohibited shortcut:

Video
→ LLM
→ Coaching Advice

---

## 13. SAFETY

Uncertain analysis must not generate recommendations that could increase
athlete injury risk.

Under high uncertainty:

ANALYSIS ABSTENTION

takes priority over false confidence.

---

## 14. SENSEI BOT GROUNDING

When Sensei Bot uses athlete analysis for technical responses, it must be
grounded, as applicable, in:

Validated Technique Knowledge
+
Approved Judo Knowledge Base
+
Validated Video Metrics
+
Known Athlete Context

Sensei Bot must never invent measurements or biomechanical facts.

---

## 15. MAKER / CHECKER / CHALLENGER / DOCKER GATE

Before PASS/CLOSED for any Video/Biomechanics capability:

### MAKER

Design and implement the model and data pipeline.

### CHECKER

Verify:

- Metric
- Formula
- Unit
- Pose mapping
- Phase
- Tests

### CHALLENGER

Challenge:

- Camera bias
- Anthropometric bias
- Occlusion
- False precision
- Technique variability
- AI hallucination

### DOCKER

Record:

- Ground Truth
- Evidence
- Validation Level
- Model Version
- Limitations

Failure of any required component means:

BIOMECHANICAL INTELLIGENCE GATE = FAIL

---

# OFFICIAL JUDO MIND PIPELINE

Human Judo Movement
→ Video / Sensor Input
→ Reliable Pose / Tracking
→ Technique Context
→ Phase Segmentation
→ Biomechanical Variables
→ Mathematical / Relational Model
→ Validation
→ Interpretation
→ Coaching Insight
→ Expert Feedback
→ Model Improvement

---

## GOVERNANCE EFFECT

JM-BTIG-01 is part of the architectural Ground Truth of Judo Mind.

Any present or future capability involving:

- Video Analysis
- Computer Vision
- Pose Estimation
- Technique Analysis
- Biomechanics
- AI Coaching
- Sensei Bot
- Technique Scoring
- Movement Comparison
- Technical Feedback

must comply with this governance.

Existing implementation is not automatically considered compliant merely
because it predates this rule.

Compliance must be demonstrated at the applicable development/review gate.

No scientific approval, validation level, metric validity or production
eligibility may be inferred merely from creation of this governance document.
