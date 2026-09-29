# JM-S0.7-A2 — Wave-1 Quality Correction and Stronger-Evidence Intake Readiness

Date: `2026-08-31`

Status: `PASS — Wave-1 Quality Correction and Stronger-Evidence Intake Readiness / No Scientific Approval or Production Enablement`

## Scope and preserved baseline

- Branch: `master`; starting HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`.
- Starting worktree: `216` status records (`90` modified, `126` untracked); staged files: `0`; tracked deletions: `0`.
- The historical `JM_HPS_WAVE1_SELECTION.csv` remained unchanged with SHA-256 `0564bb3335f577867badd5c3fd97693e281ffb89df9a1af03c0641210b8e4b75`.
- HPS access remained read-only. The HPS Master Registry and S3.3 external evidence pack were hashed before work; no HPS file was modified or copied.
- No application code, test, database, model, configuration, inference, benchmark, pose, video, calibration, OpenSim, staging, commit, push, reset, clean, or deletion occurred.

## Twelve-source quality disposition

The original twelve records reconcile exactly:

- `KEEP_WAVE1_CORE=2`: `HPS-SRC-0252`, `HPS-SRC-0253`.
- `KEEP_WAVE1_CORE_FULL_TEXT_REQUIRED=1`: `HPS-SRC-0254`.
- `KEEP_WAVE1_SUPPORTING=5`: `HPS-SRC-0026`, `HPS-SRC-0003`, `HPS-SRC-0005`, `HPS-SRC-0006`, `HPS-SRC-0004`.
- `DEFER_IDENTITY_UNVERIFIED=2`: `HPS-SRC-0120`, `HPS-SRC-0031`.
- `DEFER_WEAK_EVIDENCE_CLASS=1`: `HPS-SRC-0028`.
- `REPLACE_WITH_STRONGER_CANDIDATE=1`: `HPS-SRC-0018`.

This is source-selection governance only. It creates no evidence conclusion, claim support, Judo transfer, scientific approval, threshold, rule, prescription, safety approval, or capability activation.

## Wave-1 Core V2 and 0254 access check

Core V2 starts with exactly three records:

- `HPS-SRC-0252`: `REVIEW_REQUIRED`.
- `HPS-SRC-0253`: `REVIEW_REQUIRED`.
- `HPS-SRC-0254`: `LOCKED_FULL_TEXT_REQUIRED`.

For `HPS-SRC-0254`, PubMed confirmed exact title/authors/year/DOI/PMID but did not expose a PMCID or exact-source lawful public full text. Europe PMC did not yield a confirmed exact full-text record during the bounded check, and the exact publisher DOI did not establish public access. Loughborough University provides a lawful CC BY-NC-ND 4.0 accepted manuscript for a same-title European Journal of Sport Science publication with DOI `10.1080/17461391.2012.730061`; because this differs from the HPS source's Medicine & Science in Sports & Exercise DOI `10.1249/MSS.0b013e318279a10a`, it was recorded as a related alternate version and not substituted or downloaded.

Result: exact-source access remains `ABSTRACT_ONLY/PAYWALLED`; downloaded files: `0`.

## HPS-SRC-0265 through HPS-SRC-0272

All eight IDs already exist in the 200-row HPS Master Registry as `CANDIDATE` records. None was added or changed.

- `VERIFIED_EXTERNAL_HPS_LEAD=5`: `0265`, `0269`, `0270`, `0271`, `0272`.
- `FULL_TEXT_REQUIRED=2`: `0266`, `0267`.
- `IDENTITY_CONFLICT=1`: `0268`.

The `0268` PMID resolves to a 2020 Journal of Athletic Training systematic review with DOI `10.4085/1062-6050-0528.19`, whereas HPS records year `2021` and journal `Sports Medicine - Open`. This conflict is additive and fail-closed; HPS metadata was not overwritten.

Potential replacements are limited to four: `0265`, `0266`, `0270`, and `0271`. They were chosen for evidence class and access/readiness, not because their findings were scientifically synthesized or judged applicable to Judo. Every candidate remains `PENDING_FORMAL_INTAKE_AND_JM_HUMAN_REVIEW`.

## Final V2 review roster

- `CORE_READY=2`: `0252`, `0253`.
- `CORE_FULL_TEXT_BLOCKED=1`: `0254`.
- `SUPPORTING_ONLY=5`: `0026`, `0003`, `0005`, `0006`, `0004`.
- `REPLACEMENT_PENDING_INTAKE=4`: `0265`, `0266`, `0270`, `0271`.
- `DEFERRED=4`: `0120`, `0028`, `0031`, `0018`.

The active core remains three records and supporting remains five. Replacement candidates are not promoted into Core V2 until formal intake and source-specific qualified-human review gates are satisfied.

## Scientific and human-review boundaries

- New `JM-SRC-*` IDs: `0`.
- Scientific approvals, claim-source approvals, thresholds, rules, prescriptions, and capability activations: `0`.
- All `16/16` safety claims remain `LOCKED`.
- Biomechanist decisions remain `0/3 pending`; Dr. Mahdi Baghaiyan's existing assignment was not extended.
- `JM-SRC-0028/0029` remain `FULL_TEXT_REQUIRED`.
- `UM-ANG-004` remains `METHOD_BLOCKED` and `NOT_SCIENTIFICALLY_VALIDATED`.
