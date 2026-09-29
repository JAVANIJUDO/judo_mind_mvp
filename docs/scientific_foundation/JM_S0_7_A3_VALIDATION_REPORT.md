# JM-S0.7-A3 — Validation Report

Date: `2026-08-31`

## Identity, access and intake validation

- Four authorized replacement IDs reconciled exactly: `PASS (4/4)`.
- `HPS-SRC-0268` conflict recorded and excluded from Wave 1/Core V3: `PASS`.
- Every acquired file has exact identity, URL, date, byte size and SHA-256:
  `PASS (2/2)`.
- Acquired files are valid PDFs with readable text layers: `PASS (2/2)`.
- Download count `2 <= 4`: `PASS`.
- Paywalled downloads: `0`; unofficial mirrors: `0`; access-control bypasses:
  `0`: `PASS`.
- Abstract-only records represented as full text: `0`: `PASS`.
- Invalid HTTP response retained: `0`: `PASS`.
- OCR runs: `0`: `PASS`.

## Provenance and duplicate validation

- Intake, provenance and duplicate-control rows reconcile to all four
  replacement IDs: `PASS (4/4 each)`.
- Acquired hashes re-computed and matched recorded values: `PASS (2/2)`.
- Duplicate state: `UNIQUE_HASH=2`;
  `SHA_NOT_AVAILABLE_SOURCE_NOT_ACQUIRED=2`: `PASS`.
- HPS identifiers preserved as foreign keys; new `JM-SRC-*` IDs: `0`: `PASS`.
- No duplicate file deleted, renamed, merged or overwritten: `PASS`.

## Core V3 and blank-review validation

- Readiness rows: `7/7` unique; exact HPS foreign keys: `PASS`.
- Recommended future core count: `5 <= 5`: `PASS`.
- Existing Core V2 candidates remain represented: `3/3`: `PASS`.
- Eligible replacement candidates represented: `4/4`: `PASS`.
- `HPS-SRC-0268` absent from readiness registry: `PASS`.
- Required readiness enumerations: `PASS`.
- No scientific extraction, reviewer identity/date, decision, attestation or
  evidence finding prefilled: `PASS`.
- No source described as scientifically approved: `PASS`.

## CSV and referential validation

- Seven JM-S0.7-A3 CSV files parse as UTF-8 with uniform row widths: `PASS`.
- Required columns: `PASS`.
- Unique record IDs: `PASS`.
- Replacement foreign-key set equals `0265/0266/0270/0271`: `PASS`.
- Allowed bibliography, access, duplicate, conflict and readiness enums:
  `PASS`.
- The official spreadsheet dependency loader was unavailable on this host. No
  package was guessed or installed; plain UTF-8 CSV authoring was followed by
  independent parser, header, width, enum, ID and foreign-key validation.

## Preservation and fail-closed validation

- HPS Master Registry preflight/final SHA-256:
  `6a5b54ca9fff769d1cd7b1d4ae39517b45e2ef4582bb06a5158326ea8347d64a`
  unchanged: `PASS`.
- HPS S3.3 external evidence pack preflight/final SHA-256:
  `22a58c6a05b5a76c4149bbf1117eb2b643a56fc311af4b7dc4828074da04b6e5`
  unchanged: `PASS`.
- Original Wave-1 SHA-256
  `0564bb3335f577867badd5c3fd97693e281ffb89df9a1af03c0641210b8e4b75`
  unchanged: `PASS`.
- Core V2 SHA-256
  `1324601182d109a1822c31f7a251a97e12dbb1a3fe08bbdbd5ebe404554821f5`
  unchanged: `PASS`.
- Reviewer assignment/form/sign-off and source/claim/metric/capability,
  application and media protected hashes unchanged: `PASS`.
- HPS modified: `NO`; HPS files copied: `0`: `PASS`.
- Application code/tests/config/models modified by JM-S0.7-A3: `NO`: `PASS`.
- Existing source/media modified: `NO`; newly authorized scientific intake
  files: `2`: `PASS`.
- Scientific approvals `0`; rule/threshold eligibility `0/0`; capability
  activation `0`: `PASS`.
- Safety claims `16/16 LOCKED`; biomechanist review `0/3 PENDING`;
  `JM-SRC-0028/0029 DEFERRED_FULL_TEXT_REQUIRED`; `UM-ANG-004 METHOD_BLOCKED`:
  `PASS`.
- Temporary task artifacts remaining: `0`: `PASS`.

## Git validation

- Repository-wide `git diff --check`: `PASS`.
- Staged files: `0`.
- Tracked deletions: `0`.

## Final result

`PASS — Replacement Candidate Formal Intake and Core-V3 Review Readiness / No Scientific Approval or Production Enablement`
