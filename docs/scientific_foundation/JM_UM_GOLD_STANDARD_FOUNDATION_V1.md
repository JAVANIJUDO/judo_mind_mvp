# Uchi-mata Gold Standard Scientific Foundation V1

Date: `2026-09-11`

Stage: `JM-UM-GS-0`

Status: `SCHEMA AND GOVERNANCE FOUNDATION ONLY — NO CAPABILITY ACTIVATION`

Contract version: `uchi-mata-gold-foundation-1.0.0`

## Authority and scope

This foundation defines how future Uchi-mata evidence, observable events,
source-specific phase definitions, measurements, validation gaps,
interpretation rules and data rights can be recorded without implying that any
scientific capability has been approved. Product Technique ID `001` and the
scientific slug `uchi-mata` are fixed for this scope. Uchi-mata remains the
first Gold Standard technique, but “Gold Standard” is a development target,
not a scientific-validation label.

The existing registries remain authoritative:

- `JM_SOURCE_INVENTORY.csv` owns source identity (`JM-SRC-*`);
- `JM_METRIC_AND_THRESHOLD_INVENTORY.csv` owns metric identity and the
  scientific/engineering distinction;
- `JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv` owns the current 29-metric gate state;
- `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv` owns current capability state.

The JM-UM-GS-0 files are versioned Uchi-mata profiles and schema contracts over
those sources. They do not supersede, duplicate or silently change existing
IDs, claims, formulas, approval states, thresholds or production permissions.
Rows without a formal `JM-SRC-*` identity remain
`UNASSIGNED_PENDING_FORMAL_INTAKE` and cannot support a claim.

## Governing scientific chain

`Video -> Attempt -> Person/Role -> Pose -> Tracking -> Observable Technique
Events -> Technique Phases -> Measurements -> Tori/Uke Relationships ->
Reference Comparison -> Validated Technical Interpretation -> Coaching
Feedback`

Every arrow is an independent gate. Success at one stage does not validate the
next. AI is decision support only.

- A pose landmark is not a technical judgement.
- A joint angle is not proof of correct technique.
- A successful Ippon or an elite execution is not automatically an ideal
  biomechanical reference.
- Model visibility/confidence is not measurement validity or pose accuracy.
- `FrameCandidate != TemporalTrack != HumanRoleAssignment`.
- Human role confirmation remains mandatory.

## Versioned artifact map

| Artifact | Responsibility |
|---|---|
| `JM_UM_GOLD_EVIDENCE_REGISTRY_V1.csv` | Technique-specific evidence profile; links to canonical source IDs where available and preserves unknowns |
| `JM_UM_GOLD_EVENT_ONTOLOGY_V1.csv` | Observable event vocabulary E0–E7; no detector |
| `JM_UM_GOLD_PHASE_DEFINITIONS_V1.csv` | Source-specific operational phase definitions; no universal remapping |
| `JM_UM_GOLD_MEASUREMENT_PROFILE_V1.csv` | Additional Gold-profile fields for the 15 existing Level-1 metric IDs; no formula or state replacement |
| `JM_UM_GOLD_VALIDATION_GAP_MATRIX_V1.csv` | Evidence, validity, population, interpretation, coaching and rights gaps |
| `JM_UM_GOLD_INTERPRETATION_RULE_REGISTRY_V1.csv` | Intentionally header-only future rule registry |
| `JM_UM_GOLD_RIGHTS_REGISTRY_V1.csv` | Reference/research/training/commercial-use separation |
| `ai_engine/scientific_foundation/uchi_mata_gold_standard.py` | Frozen, extra-forbid typed schema; not imported by production |

## Evidence registry

Each evidence row records:

- evidence and canonical source IDs;
- technique ID/slug and source type;
- title, authors/organization, year and URL/DOI;
- population, sample size, skill level and reported sex composition;
- technique variant/context;
- capture method, camera/mocap configuration and sampling frequency;
- measured variables and event/phase definitions;
- major findings, limitations and Judo Mind applicability;
- evidence-strength and rights states;
- scientific approval and production permission.

Missing information is stored as `UNKNOWN`, `NOT_REPORTED` or an equally
explicit scoped sentinel. It is never inferred from title, prestige, hosting
organization or a model output.

### Seed disposition

The ten requested source groups are represented conservatively:

1. The IJF Uchi-mata page is an official technical reference, not
   biomechanical validation.
2. The 2019 IJF 4DREPLAY page is evidence of a 360-degree display, not a
   validated motion-measurement dataset.
3. The AJJF JUDO x TECHNOLOGY page is a volumetric visual-reference lead, not
   validation of Judo Mind reconstruction.
4. The AJJF Shohei Ono Uchi-mata viewer is an elite visual reference. A single
   champion execution is not a universal ideal.
5. The 2025 lower-limb study reuses canonical `JM-SRC-0026` and remains a
   research reference pending the existing review gates.
6. PMID `40231440` is recorded as a bibliographically verified research lead;
   its abstract-level details cannot authorize product thresholds.
7. The ISBS 2024 preparation-phase title remains an unverified source lead
   until exact bibliographic intake.
8. The Ishii et al. elite case reuses canonical `JM-SRC-0025`; its single-case
   nature and one-page abstract prevent universal interpretation.
9. The University of Tokyo markerless example remains an unverified discovery
   lead because the exact publication was not supplied.
10. OpenCap literature is a measurement-method lead only and is explicitly not
    direct Uchi-mata validation. Exact publications must be registered before
    any claim uses them.

No protected video or dataset was downloaded or copied.

## Event ontology

The ontology records observable candidates, not automated truths:

| ID | Name | Current boundary |
|---|---|---|
| E0 | `ATTEMPT_START` | Human/research boundary; D1 remains authoritative |
| E1 | `ATTACKING_LIMB_INITIAL_MOVEMENT` | Source-specific operational annotation required |
| E2 | `SUPPORT_LIMB_ROTATION_START` | Source-specific operational annotation required |
| E3 | `ATTACKING_LEG_ACTION_START` | Source-specific operational annotation required |
| E4 | `CANDIDATE_PEAK_ATTACK_EVENT` | Provisional/research-level |
| E5 | `CANDIDATE_UKE_PROJECTION_OR_SUPPORT_CHANGE` | Provisional/research-level |
| E6 | `ATTACKING_LEG_ACTION_END` | Source-specific operational annotation required |
| E7 | `ATTEMPT_END` | Human/research boundary; D1 remains authoritative |

Permitted event-source states are `HUMAN_CONFIRMED`, `RESEARCH_ANNOTATED`,
`MODEL_INFERRED_UNVALIDATED` and `MODEL_INFERRED_VALIDATED`.
`MODEL_INFERRED_UNVALIDATED` is never Ground Truth. All eight events remain
`RESEARCH_ONLY`; automatic detection and production-ground-truth flags are
false.

## Source-specific phase model

The 2025 lower-limb study's operationalization is stored separately from Judo
Mind's canonical conceptual sequence:

| Source label | Contextual label used by that source | Interval |
|---|---|---|
| Approach | Tsukuri | E1 -> E2 |
| Turning | Kuzushi | E2 -> E3 |
| Throw | Kake | E3 -> E6 |

These are sourced research definitions. They are not declared universal or the
only valid concepts of Kuzushi, Tsukuri and Kake. No automatic phase output is
activated, and future mappings must retain source, evidence status,
applicability and version.

## Measurement registry profile

The typed contract can represent metric ID, body/relationship target,
event/phase dependency, dimensionality, units, calculation, required
landmarks, roles and tracking continuity, camera/timing requirements,
normalization, provenance, validation/error/reference state, interpretation
and coaching permissions, abstention conditions, evidence links and contract
version.

The V1 CSV profiles the 15 existing Level-1 IDs only. It does not change their
canonical definitions or runtime values. Every row is non-production, every
coaching permission is `LOCKED`, every scientific interpretation remains
research-only, and missing validity/error evidence is explicit.

Allowed dimensionalities are `2D_PROJECTED`, `CALIBRATED_2D`,
`MULTIVIEW_3D`, `MOCAP_3D` and `OTHER`. Allowed provenance remains strictly:

- `measured`;
- `reconstructed`;
- `model-estimated`;
- `AI-inferred`.

JM-UM-GS-0 implements no force, torque, moment, power or injury-risk
measurement. Existing Level-2/Level-3 records remain locked in the canonical
29-metric gap registry and are not activated by the typed schema.

## Capability vocabulary

- `RESEARCH_ONLY`: schema, hypothesis or research artifact with no production
  scientific interpretation.
- `ENGINEERING_VALIDATED`: bounded software/engineering behavior has passed
  its declared tests; this is not scientific validation.
- `PRODUCT_DESCRIPTIVE`: approved descriptive product content only; no metric
  or coaching inference.
- `TECHNICAL_INTERPRETATION_ALLOWED`: may be granted only by explicit,
  evidence-bound governance for an exact scope.
- `COACHING_RECOMMENDATION_ALLOWED`: may be granted only by a separate explicit
  evidence and multidisciplinary approval.
- `LOCKED`: unavailable for activation; missing prerequisites must remain
  visible.

No state advances automatically. JM-UM-GS-0 grants none of the two allowed
interpretation/coaching states.

## Validation-gap status meanings

- `GREEN`: all evidence, method, population, validity, reviewer and rights
  requirements for the exact scoped item are satisfied. It still does not
  automatically enable production.
- `YELLOW`: relevant evidence exists, but bounded review, applicability,
  method, validity or rights work remains.
- `RED`: evidence or method is absent/inadequate for the proposed use; the item
  is not ready for validation or activation.
- `LOCKED`: the item is prohibited from use until named prerequisites and an
  explicit approval gate are completed.

No V1 row is `GREEN`. Publication mention, official hosting, code execution or
an elite outcome cannot make a row green.

## Interpretation-rule foundation

The interpretation registry is intentionally header-only. Future rows require
an exact finding, measurements, events/phases, applicable population, evidence,
measurement validity, uncertainty threshold, allowed interpretation, allowed
coaching implication, abstention conditions, rule version and approval state.

An LLM/Sensei may only translate an already authorized structured finding into
bounded user language:

`AUTHORIZED STRUCTURED FINDING -> user-facing explanation`

The prohibited path is:

`RAW VIDEO -> free-form judgement`

The typed rule contract is extra-forbid, hard-locks approval, requires an
authorized structured finding, disallows raw-video LLM judgement and keeps
production disabled.

## Rights and data governance

Allowed rights states are `REFERENCE_ONLY`,
`RESEARCH_USE_REVIEW_REQUIRED`, `TRAINING_USE_PERMISSION_REQUIRED`,
`LICENSED_FOR_TRAINING` and `UNKNOWN_RIGHTS`.

The rights contract forbids training or commercial-training authorization
unless the exact record is `LICENSED_FOR_TRAINING`. V1 grants no local-copy,
research-processing, training or commercial-training authorization. Linking to
an official or bibliographic page is kept separate from copying its media or
using its data.

## Integration guardian

The foundation can later map without rewriting the validated flow:

- Python backend: validate registry records and approved structured findings
  behind a separate adapter; no current API imports this package.
- Flutter UI: receive only approved, versioned result DTOs; scientific details
  remain optional and localized.
- V2A: retain its current four metrics and provenance. The Gold profile may
  reference those IDs but does not change their formulas or reportability.
- Tracking: use only validated temporal associations; frame candidates and
  human role assignments remain distinct.
- Event annotation: use explicit event-source states and source-specific phase
  mappings.
- Reference comparison: require protocol compatibility, population and rights
  gates; an elite execution is never an automatic ideal.
- Sensei: explain authorized structured findings only and preserve abstention.

## Product presentation requirement

Future primary results may organize a simple localized experience as Analysis
completed, Overall technical summary, Strengths, Needs improvement, Why it
matters, Next training focus and Progress comparison. Engineering/scientific
detail belongs in an optional expanded section. JM-UM-GS-0 does not redesign
or activate this UI.

## D1/D2 protection

The existing D1 human-confirmed attempt boundaries and D2 frame-candidate,
session/token and explicit human Tori-selection gates remain unchanged.
JM-C2.1-D2 has bounded two-candidate implementation evidence, but its
MediaPipe VIDEO-mode lifecycle/reproducibility question still requires the
separately governed positive real-device validation. D2 is not closed and is
not declared resolved by JM-UM-GS-0.

## Current gate

- Scientific approval created: `NO`
- Production capability activated: `NO`
- Automatic phase detection: `NO / LOCKED`
- Automatic Tori/Uke recognition: `NO / LOCKED`
- Tracking approved for production: `NO / LOCKED`
- Technique score or correctness judgement: `NO`
- Coaching rule created: `NO`
- Physical force/torque/power/injury-risk measurement: `NO`
- Ordinary single-camera 3D claim: `NO`
- Protected media copied/downloaded: `NO`

The foundation is complete only as a versioned schema/governance baseline.
Every scientific, interpretation, coaching, rights and production gate remains
fail-closed.

## GS-1 evidence and claim extension

JM-UM-GS-1 extends this same foundation with canonical source intake, a
technique-specific source-bound claim profile, a 22-item evidence/measurement
matrix, per-item camera requirements and a rights-gated acquisition register.
See `JM_UM_GS_1_EVIDENCE_INTAKE_AND_CLAIM_MATRIX.md`.

This extension does not change the contract version or activate a runtime
capability. Its matrix contains zero `GREEN` rows, its interpretation-rule
registry remains empty and every scientific claim remains ineligible as an
athlete threshold and disabled for production. D2 is not closed; the current
MediaPipe VIDEO-mode lifecycle/reproducibility debt remains documented and
requires separate real-device validation.
