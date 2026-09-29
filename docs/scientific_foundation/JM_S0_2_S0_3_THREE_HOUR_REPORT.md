# JM-S0.2 / JM-S0.3 Controlled Shift Report

Date: 2026-08-28
Scope: metadata-only source reuse, explicit claim-link mapping and fail-closed capability audit
Scientific status: no evidence review, approval or capability activation

## Preflight

- Repository: `D:\projects\judo_mind`
- Branch: `master`
- HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`
- Baseline working tree: 90 modified, 0 staged and 183 untracked paths.
- The live working tree matched the declared baseline exactly.
- All mandatory governance documents and the complete existing
  `docs/scientific_foundation/` registry set were read before edits.
- The HPS library was accessed read-only. No PDF, media or source content was
  analyzed, copied or moved.

## Block 1 — JM-S0.2-B

The five DOI-eligible Judo Mind references (`JM-SRC-0025` through
`JM-SRC-0029`) now preserve structured normalized DOI, title and author data
from the existing repository text. Publication year remains empty because it
was not explicit in the authorized repository metadata.

Official denominator:

- JM DOI-eligible sources: 5;
- exact HPS matches: 0;
- genuinely unmatched JM sources: 5;
- HPS-only excluded context leads: 1.

Each of the five sources is `NOT_PRESENT_IN_HPS_MASTER`. `HPS-SRC-0120` is
retained as `HPS_ONLY_CONTEXT_LEAD` and
`EXCLUDED_FROM_JM_MATCH_DENOMINATOR`. No HPS approval transferred.

## Block 2 — JM-S0.2-C

`JM_HPS_REUSE_CANDIDATES.csv` preserves all 200 current HPS Master Source
Registry rows. Classification uses only already-recorded title, source type and
reviewed primary-domain metadata.

Candidate relevance:

- `DIRECT_JUDO`: 1;
- `HIGH_TRANSFERABILITY`: 105;
- `SUPPORTING`: 71;
- `LOW_OR_UNCLEAR`: 17;
- `OUTSIDE_CURRENT_SCOPE`: 6.

Candidate domains:

- `JUDO_TECHNIQUE`: 1;
- `STRENGTH_AND_POWER`: 42;
- `BODYWEIGHT_AND_MOBILITY`: 0;
- `CONDITIONING_AND_ENERGY_SYSTEMS`: 12;
- `TRAINING_LOAD_AND_MONITORING`: 13;
- `PERIODIZATION_AND_TAPER`: 28;
- `RECOVERY_AND_SLEEP`: 10;
- `INJURY_SAFETY_AND_RETURN_TO_PLAY`: 19;
- `NUTRITION_AND_WEIGHT_MANAGEMENT`: 10;
- `PSYCHOLOGY_AND_DECISION_SUPPORT`: 6;
- `MEASUREMENT_AND_VALIDATION`: 36;
- `OTHER_OR_UNCLEAR`: 23.

`HPS-SRC-0120` is the only direct-Judo metadata candidate. That classification
means the title identifies Judo; it does not mean the source content, evidence
or applicability has been reviewed.

## Block 3 — JM-S0.3-A

`JM_CLAIM_SOURCE_LINKS.csv` preserves all 132 existing claim IDs and texts by
reference without changing the claim inventory.

- `GENERAL_DOCUMENT_REFERENCE`: 121;
- `NO_EXPLICIT_SOURCE`: 11;
- `EXPLICIT_INLINE_CITATION`: 0;
- `EXPLICIT_SECTION_SOURCE`: 0;
- `SOURCE_LINKED_NOT_REVIEWED`: 0;
- `SOURCE_MAPPING_REQUIRED`: 126;
- `OUT_OF_SCOPE_OR_LOCKED`: 6.

The five Uchi Mata DOIs were not attached to any claim because the current 132
claim rows contain no explicit claim-level DOI citation. General IJF, Kodokan
and EJU source lists remain general references and are not converted into
claim citations.

## Block 4 — Capability audit

All 20 capabilities already failed closed:

- `LOCKED`: 8;
- `REVIEW_REQUIRED`: 2;
- `VALIDATION_ONLY`: 10;
- production enabled: 0;
- rule or threshold eligible: 0;
- scientifically approved: 0.

Automatic Tori/Uke, automatic phase detection, Level 2 scientific 3D,
force/kinetics, OpenSim and training-prescription activation remain locked.
Technique-error diagnosis, technical scoring, injury prediction, referee
decision and production multi-person interaction metrics are not registered as
active capabilities and remain unavailable. No capability row required change.

## Scientific boundary

This shift created metadata candidates and mapping gaps only. It did not review
evidence, validate a source, approve a rule or threshold, prescribe training,
activate AI, or establish production scientific capability. Software status,
engineering evaluation, human ground truth and scientific validation remain
separate.

## Stop boundary

Work stops after JM-S0.2-B, JM-S0.2-C, JM-S0.3-A and their documentation and
validation. Evidence Review, article retrieval, capability activation and
JM-S0.3-B are not started.
