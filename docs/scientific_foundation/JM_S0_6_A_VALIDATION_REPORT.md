# JM-S0.6-A — Validation Report

Date: 2026-08-31

## Registry and count validation

- All scientific-foundation CSV files parse with consistent row widths: `PASS`.
- New registry required columns and allowed enumerations: `PASS`.
- New IDs are unique and all source/claim/candidate foreign keys resolve: `PASS`.
- P0 reconciliation: 2 remediation rows -> 2 resolution rows; one shared conflict candidate; `PASS`.
- P1 reconciliation: 3 remediation rows -> 3 verification rows; `PASS`.
- Canonical source inventory: 62 rows; unchanged.
- Claim inventory: 132 rows; unchanged.
- High-risk locator: 53 unique claim IDs with preserved wording SHA-256 values.
- Safety claims: 16/16 represented exactly once and `LOCKED`.
- Exact claim locations labeled scientifically approved: 0.
- `DIRECT_CANDIDATE_SUPPORT` created: 0.

## Document and URL validation

- Kodokan PDF expected and actual SHA-256: match.
- Kodokan PDF structure: readable, unencrypted, 8 pages; text extraction and rendered-page inspection pass.
- Kodokan final source allocation: none; candidate ID retained.
- EJU historical URL retained exactly.
- EJU replacement URL is on the official EJU domain and originates from the official documents listing.
- EJU download performed: no.

## Scientific and human-review boundaries

- Biomechanist decisions: 0/3 completed; all remain pending.
- Protected reviewer assignment, form, and sign-off hashes: unchanged.
- `JM-SRC-0028` and `JM-SRC-0029`: `ABSTRACT_ONLY / FULL_TEXT_REQUIRED`; unchanged.
- `UM-ANG-004`: `METHOD_BLOCKED; VERSIONED_IMAGE_PLANE_DEFINITION_REQUIRED`; unchanged.
- Scientific approvals: 0.
- Threshold eligibility: 0.
- Rule eligibility: 0.
- Capability activations: 0.
- Safety review decisions: 0; all 16 gates remain locked.

## Preservation validation

- Four protected HPS comparison hashes: unchanged.
- HPS modified: no.
- Existing PDFs/media/source files moved, renamed, or modified: no.
- Application/backend/Flutter/Python/test/database/model/configuration files modified by JM-S0.6-A: no.
- Inference, benchmark, model, pose, video, calibration, or OpenSim run: no.

## Git validation

- Repository-wide `git diff --check`: `PASS`.
- Staged files: 0.
- Tracked deletions: 0.
- Temporary task artifacts remaining after cleanup: 0.
- Commit, push, reset, checkout, clean, stash, merge, rebase, or branch operation: no.

## Final result

`PASS — P0/P1 Metadata and High-Risk Citation-Locator Readiness / No Scientific, Safety, Rule or Production Approval`
