# JM-UM-GS-0 Validation Report

Date: `2026-09-11`

Result: `PASS WITH CONTROLLED DEBT`

Scope: Uchi-mata Gold Standard scientific schema and governance foundation
only. No scientific approval, production activation or analysis behavior.

## Exact files inspected

Mandatory governance:

- `AGENTS.md`
- `docs/JUDO_MIND_PRODUCT_FRAMEWORK.md`
- `docs/AI_DEVELOPMENT_RULES.md`
- `docs/PROJECT_STATUS.md`
- `docs/CHANGELOG.md`
- `docs/ARCHITECTURE.md`
- `docs/DECISION_LOG.md`

Existing scientific sources of truth:

- `docs/UCHI_MATA_SCIENTIFIC_METRICS_V1.md`
- `docs/scientific_foundation/JM_TAXONOMY_AND_REGISTRY_SCHEMA.md`
- `docs/scientific_foundation/JM_SOURCE_INVENTORY.csv`
- `docs/scientific_foundation/JM_METRIC_AND_THRESHOLD_INVENTORY.csv`
- `docs/scientific_foundation/JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv`
- `docs/scientific_foundation/JM_UCHI_MATA_BIBLIOGRAPHIC_VERIFICATION.csv`
- `docs/scientific_foundation/JM_UCHI_MATA_EVIDENCE_REVIEW_QUEUE.csv`
- `docs/scientific_foundation/JM_UCHI_MATA_CLAIM_EVIDENCE_MATRIX.csv`
- `docs/scientific_foundation/JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv`
- `docs/scientific_foundation/JM_SCIENTIFIC_FOUNDATION_CONTROL_MATRIX.csv`
- `docs/scientific_foundation/JM_SCIENTIFIC_FOUNDATION_ROADMAP_V2_EN_FA.md`

Existing runtime boundaries and test conventions:

- `ai_engine/contracts/guided_single_attempt_review.py`
- `ai_engine/contracts/single_attempt_analysis_v2a.py`
- `ai_engine/contracts/single_camera_pose_summary.py`
- `ai_engine/single_attempt/analysis.py`
- `ai_engine/single_attempt/guided_review_session.py`
- `ai_engine/tracking/identity_contract.py`
- `ai_engine/main.py`
- `ai_engine/tests/test_guided_single_attempt_review.py`
- `ai_engine/tests/test_single_attempt_v2a_capabilities.py`

Bounded primary-source verification:

- `https://judo.ijf.org/techniques/Uchi-mata`
- `https://www.ijf.org/news/show/the-future-is-around-judo`
- `https://www.judo.or.jp/volumetric/`
- `https://www.judo.or.jp/volumetric/all-view/oono_uchimata/`
- `https://pmc.ncbi.nlm.nih.gov/articles/PMC12551108/`
- `https://pubmed.ncbi.nlm.nih.gov/40231440/`

The PMC page was not relied on for content because the bounded request returned
a browser verification gate. Existing verified project metadata was preserved.

## Files created

- `ai_engine/scientific_foundation/__init__.py`
- `ai_engine/scientific_foundation/uchi_mata_gold_standard.py`
- `ai_engine/tests/test_uchi_mata_gold_standard_foundation.py`
- `docs/scientific_foundation/JM_UM_GOLD_STANDARD_FOUNDATION_V1.md`
- `docs/scientific_foundation/JM_UM_GOLD_EVIDENCE_REGISTRY_V1.csv`
- `docs/scientific_foundation/JM_UM_GOLD_EVENT_ONTOLOGY_V1.csv`
- `docs/scientific_foundation/JM_UM_GOLD_PHASE_DEFINITIONS_V1.csv`
- `docs/scientific_foundation/JM_UM_GOLD_MEASUREMENT_PROFILE_V1.csv`
- `docs/scientific_foundation/JM_UM_GOLD_VALIDATION_GAP_MATRIX_V1.csv`
- `docs/scientific_foundation/JM_UM_GOLD_INTERPRETATION_RULE_REGISTRY_V1.csv`
- `docs/scientific_foundation/JM_UM_GOLD_RIGHTS_REGISTRY_V1.csv`
- `docs/scientific_foundation/JM_UM_GS_0_VALIDATION_REPORT.md`

## Files modified

- `docs/scientific_foundation/JM_TAXONOMY_AND_REGISTRY_SCHEMA.md`
- `docs/scientific_foundation/JM_SCIENTIFIC_FOUNDATION_CONTROL_MATRIX.csv`
- `docs/PROJECT_STATUS.md`
- `docs/CHANGELOG.md`
- `docs/ARCHITECTURE.md`
- `docs/AI_DEVELOPMENT_RULES.md`
- `docs/DECISION_LOG.md`

## Automated validation

- Python syntax compilation: `PASS`.
- Gold contract/registry unittest: `9/9 PASS`.
- Combined Gold plus Guided D1/D2 regression unittest: `31/31 PASS`
  (`9` Gold plus `22` Guided; the Gold tests are repeated in this combined
  count).
- V2A capability assertions: `2/2 PASS`.
- Registry structural audit:
  - evidence: `10`, unique IDs `10`, scientific approvals `0`, production
    permissions `0`;
  - events: `8`, automatic events `0`, production Ground Truth events `0`;
  - phases: `3`, automatic phases `0`, universal definitions `0`;
  - Level-1 metric profiles: `15`, production-enabled `0`, coaching-unlocked
    `0`;
  - gaps: `12`, green `0`, validated interpretations `0`, validated coaching
    implications `0`;
  - interpretation rules: `0`;
  - rights: `10`, local-copy/research-processing/training/commercial-training
    permissions `0/0/0/0`;
  - canonical production-enabled scientific capabilities: `0`.
- Production dependency audit: no import of the Gold foundation from FastAPI,
  existing contracts, single-attempt analysis or Flutter.

## Checker result

`PASS`

- Seeded statements are bound to an official URL, existing canonical source or
  explicit unverified-lead status.
- Unknown values remain explicit.
- No normative threshold, universal ideal, automatic phase, automatic role,
  physical kinetics, injury prediction or ordinary-video 3D claim exists.
- D1/D2 token, candidate, human-role and fail-closed contracts remain intact.

## Challenger result

`PASS WITH CONTROLLED DEBT`

No hidden scientific overclaim, source-to-claim promotion, model-confidence to
measurement-validity conflation, elite-success to ideal conflation, phase to
universal-doctrine conflation, unsupported normative threshold, rights grant or
Sensei bypass was found.

Controlled debt:

- Eight evidence leads do not yet have a canonical `JM-SRC-*` intake identity.
- The ISBS 2024, University of Tokyo and OpenCap entries need exact source
  identities before any claim use.
- Claim-level full-text review, population transfer, method validity,
  annotation reliability, reference comparability and multidisciplinary human
  approvals remain incomplete.
- No training-data or commercial-use right is established.
- JM-C2.1-D2 remains active; positive real-device lifecycle/reproducibility
  validation remains pending.

## Docker / implementation-guardian result

`PASS`

The foundation has explicit future adapter boundaries for Python, Flutter,
V2A, tracking, event annotation, reference comparison and Sensei. It does not
enter the production dependency graph and does not force a rewrite of the
validated D1/D2/V2A path.

## Final gate status

`PASS WITH CONTROLLED DEBT`

This closes JM-UM-GS-0 only as a schema/governance foundation. Every scientific,
interpretation, coaching, rights, D2 and production gate remains fail-closed.
