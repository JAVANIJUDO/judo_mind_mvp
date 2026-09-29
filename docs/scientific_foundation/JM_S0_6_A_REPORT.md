# JM-S0.6-A — P0/P1 Metadata Remediation and High-Risk Citation Locator

Date: 2026-08-31

Status: `PASS — P0/P1 METADATA AND HIGH-RISK CITATION-LOCATOR READINESS / NO SCIENTIFIC, SAFETY, RULE OR PRODUCTION APPROVAL`

## Scope and preflight

- Repository branch: `master`.
- Starting HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`.
- Starting Git status records: 331; staged files: 0; tracked deletions: 0.
- Existing remediation scope: 2 P0 queue rows representing one delimiter-normalization conflict candidate, and 3 P1 official-organization source rows.
- Starting source and claim counts: 62 sources and 132 claims.
- Protected reviewer, HPS, application/source/media, and official-document boundaries were retained. No protected mismatch was accepted.

## Block A — P0 identity conflict

`JM-SRC-0009` records the literal development endpoint in Dart configuration. `JM-SRC-0010` records the same endpoint inside Markdown, where the trailing backtick is a formatting delimiter rather than locator content. The two P0 queue rows are resolved additively as `METADATA_FORMAT_DIFFERENCE / RESOLVED_METADATA_ONLY`.

No source was merged or deleted. The historical source inventory was not overwritten, and machine confidence remains explicitly `UNAVAILABLE_NOT_VALIDATED`.

## Block B — P1 metadata verification

All three P1 rows were processed:

- `JM-SRC-0039`: Kodokan organization identity and current official redirect verified.
- `JM-SRC-0041`: European Judo Union organization identity and official documents page verified.
- `JM-SRC-0042`: International Judo Federation organization identity and official documents portal verified.

Verification-state count is `VERIFIED=3`, bounded to organization identity and official-root metadata. Candidate issuing body, organization-root publication type, official URL, and language were recorded separately from existing values. Claim-level applicability, version/effective date, and supersession remain unresolved and require human confirmation for substantive use.

`JM_SOURCE_INVENTORY.csv` was intentionally unchanged because its current schema cannot retain existing and candidate values side by side.

## Block C — Kodokan document identity

The acquired file is readable, contains 8 A4 pages, displays the title `Kodokan Definitions of Judo Techniques` and date `01.10.2022`, and has SHA-256 `7addd37d526323413c7421f7bb1a2b70b3641c889a8e7e204ca1b0476f90721f`, matching the expected acquisition hash.

The filename and official origin are consistent with the document identity. The document is classified only as `OFFICIAL_TECHNICAL_OR_EDUCATIONAL_GUIDANCE`, suitable as a candidate terminology/definition reference after human intake review. It is not biomechanical, scientific, safety, medical, referee-rule, threshold, prescription, or production evidence. Supersession remains unverified, final state is `IDENTITY_VERIFIED_PENDING_HUMAN_INTAKE`, and no final `JM-SRC-*` ID was allocated.

## Block D — EJU URL remediation

The historical URL `https://www.eju.net/download-file?id=185696` and its earlier HTTP 404 observation remain preserved. The current official EJU documents listing links the same titled five-page document to an official storage URL. Title/date and document identity are consistent, so the outcome is `OFFICIAL_REPLACEMENT_FOUND`.

No PDF was downloaded. Current legal validity and supersession remain unverified; neither URL creates rule approval.

## Block E — high-risk claim locators

Exactly 53 unique claims were processed:

- `SAFETY_GUIDANCE`: 16.
- `CLAIM_REQUIRING_HUMAN_SCIENTIFIC_REVIEW`: 22.
- `BIOMECHANICS_OR_MOVEMENT_HYPOTHESIS`: 5.
- `VIDEO_ANALYSIS_ENGINEERING_METRIC`: 2.
- `AI_OR_MODEL_LIMITATION`: 8.

Locator outcomes are `EXACT_LOCATION_FOUND_PENDING_HUMAN_REVIEW=11` and `SOURCE_MAPPING_REQUIRED=42`. Support relationships are `LIMITATION_ONLY=11` and `NO_SUPPORT_LOCATED=42`.

The eleven exact locations are internal governance or engineering limitation provenance only. No topic-level or general document reference was promoted to direct claim support. All 16 safety claims remain `LOCKED`; all scientific approval fields remain `NO`.

## Block F — blank bilingual review readiness

Two bilingual packs were created:

- 16 safety claims with blank human-review fields.
- 37 remaining high-risk claims with blank human-review fields.

No reviewer, date, conflict-of-interest response, decision, notes, attestation, or signature was prefilled or assigned.

## Boundary result

No application/backend/Flutter/Python code, test, database, model, configuration, PDF, media, HPS file, scientific metric, threshold, claim wording, reviewer decision, scientific approval, rule eligibility, production permission, or capability was changed. No inference, model, pose, video, benchmark, download, staging, commit, push, reset, clean, move, rename, or deletion occurred.
