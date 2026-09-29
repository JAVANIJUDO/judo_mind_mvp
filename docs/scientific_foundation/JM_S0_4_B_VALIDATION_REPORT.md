# JM-S0.4-B Validation Report

Completion date: `2026-08-31`

Final result:

`PASS — Versioned Official-Document Discovery and Intake Readiness / No Download, Approval or Production Enablement`

## Validation boundary

This `PASS` validates only candidate discovery metadata, version/supersession
gaps, acquisition readiness, role requirements and blank human-review
readiness. It is not proof that a candidate is current, downloaded, lawfully
acquired, canonically registered, rule-approved, safety-approved,
scientifically approved, medically approved or production-ready.

این `PASS` فقط metadata کشف نامزد، شکاف نسخه و supersession، آمادگی دریافت،
نیازمندی نقش بازبین و قالب خالی بازبینی انسانی را کنترل می‌کند. این نتیجه نشان
نمی‌دهد سند جاری، دریافت‌شده، ثبت‌شده، تأییدشده یا آماده تولید است.

## CSV and schema checks

- Scientific-foundation CSV files parsed with Artifact Tool: `22/22`.
- Uniform row widths: `PASS` for all 22 files.
- Required new-registry columns:
  - discovery queue: `29/29`;
  - version matrix: `17/17`;
  - acquisition queue: `20/20`;
  - reviewer-role matrix: `13/13`.
- Deterministic IDs:
  - `JM-ODC-*`: `11/11` unique and valid;
  - `JM-ACQ-*`: `11/11` unique and valid;
  - `JM-RSR-*`: `9/9` unique and valid.
- Organizational-root foreign keys: `11/11` resolve to existing
  `JM-SRC-0039`, `JM-SRC-0041` or `JM-SRC-0042`.
- Candidate foreign keys in the version and acquisition registries: `22/22`
  resolve.
- Candidate maximum: `11 <= 12`.

## Candidate identity and URL checks

- Candidate documents: `11`.
- Issuing-body groups: IJF `4`, EJU `5`, Kodokan `2`.
- Authority classes:
  - `OFFICIAL_RULE_OR_REGULATION`: `5`;
  - `OFFICIAL_TECHNICAL_OR_EDUCATIONAL_GUIDANCE`: `3`;
  - `OFFICIAL_ADMINISTRATIVE_INFORMATION`: `3`.
- Candidate landing/direct URL hosts: only `www.ijf.org`, `www.eju.net` and
  `kdkjudo.org`.
- Third-party mirrors used as authority: `0`.
- Search-result or news pages used as authority: `0`.
- Direct-document URL fields without safe official-host evidence remain blank.

No file URL was opened for document acquisition. Official landing-page
metadata was sufficient only for candidate identity discovery.

## Version and supersession checks

- `POSSIBLY_CURRENT_NOT_CONFIRMED`: `8`.
- `NOT_VERIFIED`: `3`.
- `VERIFIED_CURRENT`: `0`.
- `SUPERSEDED`: `0`.
- `CONFLICTING_VERSION_INFORMATION`: `0`.

The matrix does not infer current validity from the newest visible date or from
the absence of a later listing. Unknown effective dates and formal
supersession chains remain unresolved and require qualified human verification.

## Acquisition checks

- Acquisition rows: `11`.
- `NOT_AUTHORIZED_IN_THIS_STAGE`: `11/11`.
- `QUEUED_NOT_DOWNLOADED`: `11/11`.
- `PENDING_CANONICAL_PATH_DECISION`: `11/11`.
- SHA-256 values: `11/11` blank.
- `acquired_on`: `11/11` blank.
- `acquired_by`: `11/11` blank.
- Storage directories created: `0`.
- Documents downloaded: `0`.
- Canonical `JM-SRC-*` identifiers created: `0`.

## Reviewer-readiness checks

- Qualification-based review scopes: `9`.
- Current fail-closed states: `LOCKED=6`, `REVIEW_REQUIRED=3`.
- Real people assigned in the role matrix: `0`.
- Selected decisions in the bilingual review template: `0`.
- Reviewer identity, qualification, conflict, review date and attestation
  fields completed: `0`.

The existing Dr. Mahdi Baghaiyan assignment was not extended or reinterpreted.
Mohammad Javani was not assigned a new review scope.

## Existing scientific and claim-state preservation

- Canonical JM sources: `62`; new source IDs: `0`.
- Existing claims: `132`.
- Existing official-rule claims: `0`.
- Official-rule claim links: `0`.
- Existing safety claims: `16`.
- Safety claims with explicit claim-level sources: `0`.
- Safety claims remaining `LOCKED`: `16`.
- Scientific approvals created: `0`.
- Rule eligibility created: `0`.
- Threshold eligibility created: `0`.
- Capability activation created: `0`.
- Biomechanist review completion: `0/3`; all decisions remain `PENDING`.
- `JM-SRC-0028/0029`: `DEFERRED_FULL_TEXT_REQUIRED`.
- `UM-ANG-004`: `METHOD_BLOCKED; VERSIONED_IMAGE_PLANE_DEFINITION_REQUIRED`.

Candidate relevance was not converted into claim evidence and no claim wording
or classification changed.

## Protected integrity and Git checks

- All seven JM-S0.4-A output hashes matched preflight.
- Biomechanist assignment hash matched preflight.
- Blank bilingual biomechanist review-form hash matched preflight.
- Human sign-off registry hash matched preflight.
- Four HPS registry hashes matched preflight; HPS modified: `NO`.
- Application manifest: `297` files, unchanged.
- Source/media manifest: `235` files and `2,361,888,695` bytes, unchanged.
- Repository-wide `git diff --check`: `PASS`.
- Staged files: `0`.
- Tracked deletions: `0`.
- Temporary validation artifacts remaining: `0`.

No application code, test, database, configuration, PDF, image, video, model,
source/media file or HPS file changed. No inference, pose estimation, video
processing, benchmark, scientific review or human decision ran.

## Conclusion / نتیجه

All applicable structural, referential, authority-domain, uncertainty,
fail-closed, preservation and Git-safety checks passed. No candidate is eligible
for rule review until its version and supersession state satisfy the later
qualified-human gate.

تمام کنترل‌های ساختاری، ارجاعی، دامنه رسمی، uncertainty، fail-closed، حفاظت و
ایمنی Git عبور کردند. هیچ نامزدی تا عبور نسخه و supersession از gate انسانی
واجدصلاحیت، مجاز به ورود به بازبینی قانون نیست.

`PASS — Versioned Official-Document Discovery and Intake Readiness / No Download, Approval or Production Enablement`
