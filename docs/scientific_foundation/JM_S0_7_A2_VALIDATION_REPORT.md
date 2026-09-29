# JM-S0.7-A2 — Validation Report

Date: `2026-08-31`

## Registry validation

- Original `JM_HPS_WAVE1_SELECTION.csv` SHA-256 unchanged: `PASS`.
- Quality disposition reconciliation: `12/12`, unique disposition IDs and original Wave-1 foreign keys: `PASS`.
- Required quality-disposition enumeration: `PASS`.
- Core V2 starts with exactly `3` records and required gates for `0252/0253/0254`: `PASS`.
- External lead reconciliation: `8/8` (`HPS-SRC-0265` through `HPS-SRC-0272`), all present in HPS Master Registry: `PASS`.
- Replacement candidates: `4 <= 4`; all remain `PENDING_FORMAL_INTAKE_AND_JM_HUMAN_REVIEW`: `PASS`.
- Final core count: `3 <= 5`; supporting count: `5 <= 5`: `PASS`.
- `HPS-SRC-0120` is deferred and not represented as scientific Judo evidence: `PASS`.
- Books/course materials remain supporting or deferred: `PASS`.
- `HPS-SRC-0254` remains `LOCKED_FULL_TEXT_REQUIRED`; exact-source download count `0`: `PASS`.
- `HPS-SRC-0265` through `0272` were not added to or changed in HPS Master Registry: `PASS`.

## CSV and referential validation

- Six A2 CSV files parse with uniform row widths: `PASS`.
- Required columns present: `PASS`.
- Unique IDs, HPS foreign keys, original Wave-1 foreign keys, and allowed enums: `PASS`.
- Public bibliographic values are additive and do not overwrite HPS: `PASS`.
- `HPS-SRC-0268` conflicting metadata is explicitly `IDENTITY_CONFLICT`: `PASS`.
- No scientific extraction, reviewer identity/date/decision, evidence approval, or product rule was prefilled: `PASS`.

The official spreadsheet dependency loader was unavailable on this host. No package was guessed or installed. Plain UTF-8 CSV authoring used the repository patch mechanism, followed by independent parser, header, width, enum, ID, and foreign-key checks.

## Preservation and fail-closed validation

- HPS Master Registry and S3.3 pack preflight/final hashes: unchanged.
- HPS modified: `NO`; HPS files copied: `0`.
- Original Wave-1 registry: unchanged.
- Protected reviewer assignment, blank review form, sign-off, source, claim, metric, and capability inventory hashes: unchanged.
- Application/source/media manifests: unchanged; no application or source/media edit by this stage.
- New `JM-SRC-*` IDs: `0`.
- Scientific approvals, thresholds, rules, prescriptions, safety approvals, and capability activations: `0`.
- Safety claims: `16/16 LOCKED`.
- Biomechanist review: `0/3 pending`.
- `JM-SRC-0028/0029`: `FULL_TEXT_REQUIRED`.
- `UM-ANG-004`: `METHOD_BLOCKED`.
- Inference, benchmark, model, pose, video, calibration and OpenSim runs: `0`.

## Git validation

- Repository-wide `git diff --check`: `PASS`.
- Staged files: `0`.
- Tracked deletions: `0`.
- Temporary task artifacts remaining: `0`.

## Final result

`PASS — Wave-1 Quality Correction and Stronger-Evidence Intake Readiness / No Scientific Approval or Production Enablement`
