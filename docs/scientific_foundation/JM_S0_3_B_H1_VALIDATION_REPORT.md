# JM-S0.3-B-H1 Validation Report

Date: `2026-08-29`
Status: `PASS / JUDO TECHNICAL SCOPE ONLY / SCIENTIFIC REVIEW PENDING`

## Registry validation

- All 13 scientific-foundation CSV files parsed through Artifact Tool.
- `JM_UCHI_MATA_HUMAN_SIGNOFF_REGISTRY.csv`: 5 data rows, 20 columns.
- Unique sign-off IDs: `5/5`.
- Exact source IDs `JM-SRC-0025` through `JM-SRC-0029`: `PASS`.
- Allowed decisions: 3 `APPROVE_WITH_LIMITATIONS`; 2
  `DEFER_FULL_TEXT_REQUIRED`.
- Reviewer role `JUDO_TECHNICAL_EXPERT`: `5/5`.
- Decision scope `JUDO_TECHNICAL_APPLICABILITY_ONLY`: `5/5`.
- Full text personally reviewed: `NO`, `5/5`.
- Exact evidence location: `NOT_RECORDED`, `5/5`.
- Biomechanist status: `PENDING`, `5/5`.
- Scientific approval: `NO`, `5/5`.
- Threshold eligible: `NO`, `5/5`.
- Rule eligible: `NO`, `5/5`.
- Production eligible: `NO`, `5/5`.
- Overall states: 3 `PARTIAL_HUMAN_REVIEW`; 2
  `DEFERRED_FULL_TEXT_REQUIRED`.
- Human Review Pack checked scientific/biomechanical boxes: `0`; all five
  Full-text-reviewed checkboxes remain blank.

## Protected scientific-state validation

The preflight and post-edit SHA-256 hashes match for:

- `JM_CLAIM_INVENTORY.csv` — 132 claims unchanged.
- `JM_CLAIM_SOURCE_LINKS.csv` — 132 claim links unchanged.
- `JM_METRIC_AND_THRESHOLD_INVENTORY.csv` — 793 rows unchanged.
- `JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv` — 29 metrics unchanged.
- `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv` — 20 capabilities unchanged.
- `JM_UCHI_MATA_EVIDENCE_REVIEW_QUEUE.csv` — five source-readiness rows
  unchanged.

Metric capability states remain 4 `VALIDATION_ONLY`, 1 `REVIEW_REQUIRED` and
24 `LOCKED`. `UM-ANG-004` remains
`METHOD_BLOCKED; VERSIONED_IMAGE_PLANE_DEFINITION_REQUIRED`. Production-enabled
capabilities remain zero.

## HPS and application preservation

- All four protected HPS registry SHA-256 hashes matched preflight: `PASS`.
- HPS modified: `NO`.
- Application-code manifest: 297 files; SHA-256
  `fd3c407ccded365580cd0c4914503f93095a47a78dbe9a0bb04f3e274e158ff9`
  before and after; `PASS`.
- Application code, tests, models and configuration modified by H1: `NO`.
- Source/media files moved or edited: `NO`.
- Inference or benchmark run: `NO`.

## Git and scope validation

- Repository-wide `git diff --check`: `PASS` (exit 0; line-ending warnings are
  informational).
- Staged files: `0`.
- Commit, push, reset, checkout, clean or stash: `NO`.
- JM-DEC-030 and `docs/DECISION_LOG.md` changed by H1: `NO`.

## Final result

`PASS — Judo Technical Scope Decisions Recorded / Biomechanist and Scientific
Review Still Pending`.
