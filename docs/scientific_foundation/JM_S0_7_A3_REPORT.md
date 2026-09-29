# JM-S0.7-A3 — Replacement Candidate Formal Intake and Core-V3 Review Readiness

Date: `2026-08-31`

Status: `PASS — Replacement Candidate Formal Intake and Core-V3 Review Readiness / No Scientific Approval or Production Enablement`

## Scope and preserved baseline

- Repository branch: `master`; starting HEAD:
  `5ffca92a62d84b044e93716a073ef3413df0070d`.
- Starting worktree: `216` status records (`90` modified, `126` untracked);
  staged files: `0`; tracked deletions: `0`.
- The HPS library was read-only. HPS Master Registry and S3.3 external evidence
  pack were hashed before work and were not modified or copied.
- The original Wave-1 selection, Core V2, reviewer records, scientific
  inventories, application manifest and media inventory were protected by
  preflight hashes.
- No application code, test, database, configuration, model, inference,
  benchmark, OCR, pose, video, calibration, OpenSim, staging, commit, push,
  reset, clean or deletion occurred.

## Exact bibliographic verification

All four authorized replacement IDs reconcile to exact peer-reviewed records:

- `HPS-SRC-0265`: `VERIFIED_EXACT_MATCH`; systematic review; British Journal
  of Sports Medicine 2016;50(5):281–291; DOI
  `10.1136/bjsports-2015-094758`; PMID `26423706`; PMCID `PMC4789708`.
- `HPS-SRC-0266`: `VERIFIED_EXACT_MATCH`; systematic review; International
  Journal of Sports Physiology and Performance 2020;15(9):1203–1215; DOI
  `10.1123/ijspp.2020-0386`; PMID `32957081`.
- `HPS-SRC-0270`: `VERIFIED_EXACT_MATCH`; meta-analysis; Sports Medicine
  2018;48(3):641–658; DOI `10.1007/s40279-017-0830-z`; PMID `29288436`.
- `HPS-SRC-0271`: `VERIFIED_EXACT_MATCH`; systematic review and
  meta-analysis; Sports Medicine - Open 2022;8(1):35; DOI
  `10.1186/s40798-022-00420-3`; PMID `35244801`; PMCID `PMC8897524`.

The bounded official-record check did not identify a clearly recorded
correction or retraction for `0265`, `0266`, or `0270`. Crossmark recorded the
`0271` document as current. This is not represented as a comprehensive
retraction audit and creates no evidence approval.

## Lawful full-text access and acquisition

- `0265`: exact publisher full-text endpoint and PMCID confirmed, but the
  bounded download returned HTTP 429. The 17-byte non-PDF response was rejected
  and removed; no file entered the library. State:
  `PUBLISHER_FULL_TEXT_PUBLIC / NOT_ACQUIRED_ACCESS_BLOCKED_HTTP_429`.
- `0266`: publisher/DOI access remained paywalled or authentication-protected;
  PubMed supplied abstract metadata only. No file was downloaded. State:
  `PAYWALLED / NOT_ACQUIRED_PAYWALLED`.
- `0270`: exact public post-print acquired from Nottingham Trent University's
  institutional repository as `14394_Spears.pdf` (3,174,736 bytes; 64 pages;
  usable text layer; SHA-256
  `4fa42024e1ab79e910f62cbf14374ca13a26c0edf6de046124255383c95248f5`).
  No broader reuse license is inferred from public download availability.
- `0271`: exact publisher version of record acquired as
  `s40798-022-00420-3.pdf` (5,473,098 bytes; 32 pages; usable text layer;
  SHA-256
  `0f48b25f5bc845e3cd1f8684d5a7746ef80f600d87be6c1d47f08c7b96c01025`);
  publisher access states CC BY 4.0.

Acquired file count: `2 <= 4`. No paywalled file, unofficial mirror,
authentication-protected file, abstract-only substitute, or invalid response
was retained. OCR was unnecessary and was not run.

## Provenance and duplicate control

Both acquired files have exact source URL, source version, acquisition date,
byte size, SHA-256, PDF validity, page count and text-layer state recorded.
The original `HPS-SRC-*` IDs remain the only source foreign keys; new
`JM-SRC-*` IDs: `0`.

Exact hashes were checked against existing Judo Mind scientific registry
hashes, 74 pre-existing scientific-library files, official-document intake and
HPS SHA helper registries. Both acquired files are `UNIQUE_HASH`. No duplicate
was deleted, merged or overwritten.

## HPS-SRC-0268 identity-conflict containment

The HPS title and PMID identify the same study as the authoritative PubMed
record, but HPS records year `2021`, journal `Sports Medicine - Open`, a blank
DOI and blank authors. The authoritative record is Duignan, Doherty, Caulfield
and Blake, 2020, Journal of Athletic Training, DOI
`10.4085/1062-6050-0528.19`, PMID `32991706`.

Outcome: `SAME_SOURCE_METADATA_CONFLICT`, confidence `HIGH`. Required action is
versioned HPS human data-steward review. Judo Mind did not overwrite HPS, and
`0268` is excluded from Wave 1 and Core V3 readiness.

## Core V3 readiness

The seven-row additive readiness registry preserves all historical candidates.
Recommended maximum-five roster, ranked for future qualified-human review:

1. `HPS-SRC-0252` — `CORE_READY_FOR_HUMAN_REVIEW`.
2. `HPS-SRC-0253` — `CORE_READY_FOR_HUMAN_REVIEW`.
3. `HPS-SRC-0271` — `REPLACEMENT_READY_FOR_HUMAN_REVIEW`.
4. `HPS-SRC-0270` — `REPLACEMENT_READY_FOR_HUMAN_REVIEW`.
5. `HPS-SRC-0254` — `CORE_FULL_TEXT_REQUIRED`.

`HPS-SRC-0265` and `HPS-SRC-0266` remain ranked but outside the recommended
maximum-five as `REPLACEMENT_FULL_TEXT_REQUIRED`. No historical candidate was
silently removed. Readiness is only readiness for qualified-human review; no
source becomes scientifically approved or production eligible.

## Blank human-review packet and protected scientific state

The bilingual English/Persian Core V3 packet contains candidate labels plus
blank fields for exact-version confirmation, design, population, measurement,
findings, uncertainty, limitations, Judo transferability, permitted/prohibited
use, reviewer roles, COI, identity/date, decision and attestation. No actual
person, finding, reviewer decision or scientific extraction was populated.

- Scientific approvals: `0`.
- Rule/threshold eligibility: `0/0`.
- Capability activation: `0`.
- Safety claims: `16/16 LOCKED`.
- Biomechanist review: `0/3 PENDING`.
- `JM-SRC-0028/0029`: `DEFERRED_FULL_TEXT_REQUIRED`.
- `UM-ANG-004`: `METHOD_BLOCKED` and not scientifically validated.
