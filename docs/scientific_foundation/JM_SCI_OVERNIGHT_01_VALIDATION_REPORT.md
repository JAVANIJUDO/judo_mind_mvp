# JM-SCI-OVERNIGHT-01 — Consolidated Validation Report

Date: 2026-08-31

## Registry validation

- Newly created CSV registries: **15**.
- Row-width and required-column validation: **PASS**.
- Unique primary IDs: **PASS**.
- Foreign keys across acquisition, source, claim, HPS, and control registries: **PASS**.
- Allowed enums for intake, remediation priority, citation state, JM-specific HPS state, and control status: **PASS**.

## Preservation validation

- Protected human-review files: hash match.
- HPS master/helper registries: hash match; HPS modified **NO**.
- Application/source manifest: unchanged.
- Existing media manifest: unchanged; the only new external-library media is the explicitly authorized official Kodokan PDF.
- Existing PDFs/source files moved or modified: **NO**.
- Claim wording altered: **NO**.

## Fail-closed validation

- Scientific approvals: **0**.
- Medical approvals: **0**.
- Rule eligibility: **0**.
- Threshold eligibility: **0**.
- Capability activation: **0**.
- Biomechanist decisions: **0/3 pending**.
- JM-SRC-0028/0029: `DEFER_FULL_TEXT_REQUIRED`.
- UM-ANG-004: `METHOD_BLOCKED`.

## Final repository validation

- Branch: `master`.
- HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`.
- Initial/final tracked status records: `90 / 90`.
- Initial/final untracked file counts: `215 / 241`; delta `+26`, exactly the
  15 CSV and 11 Markdown artifacts created by this run.
- Initial/final staged files: `0 / 0`.
- Initial/final tracked deletions: `0 / 0`.
- Repository-wide `git diff --check`: **PASS** (exit 0; line-ending warnings
  are informational).
- Temporary validation artifacts remaining: **0**.

Result: **PASS — structural governance/readiness validation only**.
