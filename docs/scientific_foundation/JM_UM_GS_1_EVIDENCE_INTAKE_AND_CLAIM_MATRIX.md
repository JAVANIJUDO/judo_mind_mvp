# JM-UM-GS-1 — Uchi-mata Evidence Intake and Claim Matrix

Status: `PASS WITH CONTROLLED DEBT — EVIDENCE/CLAIM KNOWLEDGE LAYER ONLY`

Contract: `uchi-mata-gold-foundation-1.0.0`

Technique: Product ID `001`; scientific slug `uchi-mata`; classification
`ASHI_WAZA`.

## Scope and non-activation statement

This gate turns the GS-0 schema into a source-bound research knowledge layer.
It does not activate a scientific measurement, reference ideal, technical
judgement, coaching recommendation, event detector, athlete identity, tracker,
score, 3D reconstruction, kinetics or injury prediction. All new claims are
`scientifically_approved=FALSE`, `athlete_threshold_eligible=FALSE` and
`production_enabled=FALSE`.

The required chain is:

`SOURCE -> CLAIM -> MEASUREMENT VALIDATION -> REFERENCE APPLICABILITY ->`
`APPROVED INTERPRETATION -> COACHING`

No layer may be bypassed. In particular:

- reference is not an ideal;
- a research association is not an athlete threshold;
- markerless feasibility is not Uchi-mata measurement validity;
- pose confidence is not measurement accuracy;
- successful or elite execution is not biomechanical perfection;
- `FrameCandidate != TemporalTrack != HumanRoleAssignment`;
- an observable event is not an automatically validated phase;
- measurement is not interpretation; and
- interpretation is not coaching.

## Registry ownership

The existing canonical registries retain authority:

- source identity: `JM_SOURCE_INVENTORY.csv`;
- product-content claim identity: `JM_CLAIM_INVENTORY.csv`;
- metric identity: `JM_METRIC_AND_THRESHOLD_INVENTORY.csv`;
- current metric gaps: `JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv`;
- capability status: `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv`.

`JM_UM_GOLD_CLAIM_REGISTRY_V1.csv` is the technique-specific scientific-claim
profile of the Gold foundation. It links canonical `JM-SRC-*` identities and
does not replace or renumber the product-content claim inventory.

## Formal source intake

Ten exact source identities were appended to the canonical source inventory:

| ID | Source | Restricted scientific role |
|---|---|---|
| `JM-SRC-0063` | IJF Uchi-mata library | technique identity and terminology |
| `JM-SRC-0064` | IJF 2019 4DREPLAY article | multi-view technology reference |
| `JM-SRC-0065` | AJJF volumetric page | volumetric/spatial reference |
| `JM-SRC-0066` | AJJF Ono Uchi-mata viewer | elite visual reference only |
| `JM-SRC-0067` | IJF Neil Adams 2018 analysis | official expert observation |
| `JM-SRC-0068` | Hamaguchi et al. 2025; PMID 40231440 | abstract-bound direct-Judo research |
| `JM-SRC-0069` | Hamaguchi et al. ISBS 2024 | abstract-bound preparation-phase research |
| `JM-SRC-0070` | Uhlrich et al. OpenCap 2023 | non-Judo measurement-method validation |
| `JM-SRC-0071` | Cabuk et al. OpenCap review/meta-analysis | non-Judo method synthesis |
| `JM-SRC-0072` | Oonk et al. dyadic markerless validation | non-Judo dyadic method reference |

Existing IDs `JM-SRC-0025` through `JM-SRC-0029` remain the canonical records
for the Ono case, 2025 forty-athlete lower-limb study and historical/proficiency
studies. PMID `41133568` was added to `JM-SRC-0026`; its PMCID is retained in
the source limitations. No source file, video or dataset was acquired.

## Sources still pending

- The University of Tokyo Uchi-mata markerless/video lead remains
  `UNASSIGNED_PENDING_FORMAL_INTAKE` because an exact publication identity was
  not established.
- Exact full text and claim-level method extraction remain required for
  `JM-SRC-0068`, `JM-SRC-0069` and `JM-SRC-0072`.
- `JM-SRC-0028` is still abstract-only. `JM-SRC-0029` remains abstract-only
  with a bibliographic journal-title conflict.
- Dataset availability for the direct 2025 Uchi-mata studies was not inferred.
  The exact publication statement must be reviewed before recording public or
  request-only access.

## Claim model

The 22 seeded claims record source, technique, claim type, normalized claim,
population, sample, skill, sex, laterality, variant, grip, Uke, body-size,
execution/resistance/camera context, method, capture configuration, sampling,
event, source-phase mapping, measurement family, metric link, result,
statistics, direction, uncertainty, study/external-validity limits, JM use,
permitted use, validation requirement, rights and review status.

Supported claim types are:

`OFFICIAL_TECHNIQUE_DEFINITION`, `EXPERT_TECHNICAL_OBSERVATION`,
`KINEMATIC_ASSOCIATION`, `KINEMATIC_GROUP_DIFFERENCE`,
`TEMPORAL_ASSOCIATION`, `TORI_UKE_RELATIONSHIP`, `MEASUREMENT_VALIDITY`,
`MARKERLESS_FEASIBILITY`, `SPATIAL_REFERENCE`, `VOLUMETRIC_REFERENCE`,
`CAMERA_METHOD_REFERENCE`, `DATA_AVAILABILITY`, `RIGHTS_INFORMATION` and
`LIMITATION`.

Allowed use states include candidate states, but candidate never means
activated. The current rows use only reference, research-hypothesis,
measurement-design, validation-design, descriptive-candidate or locked
boundaries. No row is eligible as an athlete threshold.

## Reference-context protection

Every future reference comparison must resolve laterality, technique variant,
grip/Kumi-kata, Uke context, skill, sex, body-size/weight class, execution
context (`DEMONSTRATION`, `UCHIKOMI`, `NAGEKOMI`, `RANDORI`, `SHIAI` or exact
laboratory context), resistance and camera/view context. An unknown field stays
unknown. Ono's AJJF visual execution (`JM-SRC-0066`) and the Ishii/Ono
scientific case (`JM-SRC-0025`) are separate records with no asserted dataset
linkage.

## Event and phase evidence

E0–E7 remain the research ontology. The B1 source supports source-specific
Approach, Turning and Throw operational intervals and can inform human
annotation design. It does not establish a universal Kuzushi/Tsukuri/Kake
definition. E4 and E5 remain provisional. B2 and B3 require complete method
review before mapping their phase language to exact E0–E7 boundaries.
Automatic event and phase detection remains disabled.

## Evidence × Measurement matrix

`JM_UM_GOLD_EVIDENCE_MEASUREMENT_MATRIX_V1.csv` evaluates 22 required items.
The result is:

- `GREEN`: 0;
- `YELLOW`: 12;
- `RED`: 4;
- `LOCKED`: 6.

Yellow means relevant evidence or engineering feasibility exists while exact
validity, applicability or repeatability remains absent. It is not production
permission. Hip/shoulder angular velocity, COM/proxy and internal/external
rotation remain red because the current method cannot support the scientific
meaning sought. Uke angular momentum, true 3D, force, torque, power and injury
prediction are locked. The current stereo extrinsics remain scientifically
rejected.

## Camera-protocol foundation

`JM_UM_GOLD_CAMERA_REQUIREMENTS_V1.csv` records requirements for every matrix
item across `CONSUMER_SINGLE_CAMERA`, `PRO_MULTI_CAMERA` and
`GOLD_VALIDATION_CAPTURE`. It is not a published filming protocol.

- Consumer single-camera eligibility is limited to elapsed timing, human
  annotation and explicitly projected/model-estimated proxies where the
  relevant visibility and camera-stability gates pass.
- Pro multi-camera remains conditional on calibration, synchronization,
  identity continuity, scale and criterion validation.
- Gold validation capture requires a declared criterion comparator and the
  complete source-specific method.

Exact Uchi-mata minimum resolution, FPS and camera angles are all
`NOT_ESTABLISHED`. OpenCap's non-Judo setup may guide experiment design but its
angles, distances and errors are not a validated Uchi-mata protocol.

## Data acquisition

`JM_UM_GOLD_DATA_ACQUISITION_REGISTER_V1.csv` prioritizes the forty-athlete
Vicon study, the Mac3D skill-comparison study, the Ono case, AJJF volumetric
reference and historical DLT/Kumi-kata sources. It tracks raw video, marker and
processed trajectories, event annotations, metadata, supplementary material,
public access, author contact, licensing and expected validation value.

OpenCap reports public laboratory/field data and some consented identifiable
video, but every asset still requires consent/license/scope review. Public
access does not grant model-training or commercial-product permission. No
direct-Judo dataset is recorded as public without its exact data-availability
statement.

## Rights

The 16-row rights profile grants no local copy, research processing, training
or commercial-training use. Official or public access permits reference
linking only where explicitly recorded. AJJF materials remain reference-only
and All Rights Reserved. Open-access article licensing is separate from
participant video, dataset and model-training permission.

## Interpretation and Sensei

`JM_UM_GOLD_INTERPRETATION_RULE_REGISTRY_V1.csv` remains header-only. Rule and
coaching counts are zero. The only future allowed path is:

`validated measurement + applicable reference + approved interpretation rule`
`+ uncertainty gate -> authorized structured finding -> Sensei wording`

The path `raw video or raw metric -> LLM -> technical judgement` is forbidden.

## D1/D2 and production protection

No production module imports this scientific-foundation package. V2A 2.0.0,
its four existing metrics and provenance are unchanged. D1 human attempt
boundaries and D2 frame-candidate/session/token/human-role gates remain intact.
JM-C2.1-D2 remains `ACTIVE / NOT CLOSED`; its MediaPipe VIDEO-mode
lifecycle/reproducibility debt and positive real-device validation remain
separate requirements.

## Next gate

The recommended next gate is a bounded full-text and data-availability review
for `JM-SRC-0026`, `JM-SRC-0068`, `JM-SRC-0069` and `JM-SRC-0072`, followed by
a human-reviewed Uchi-mata event-annotation and criterion-validation protocol.
It must not activate metrics, thresholds, automatic phases, reference ideals or
coaching rules.
