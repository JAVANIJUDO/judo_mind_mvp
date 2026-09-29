# JM-S0.4-B Versioned Official-Document Discovery and Intake-Readiness Report

Date: `2026-08-30`

Status:

`DISCOVERY AND INTAKE READINESS ONLY / NO DOWNLOAD, REVIEW, APPROVAL OR ENABLEMENT`

## Scope / دامنه

JM-S0.4-B identifies exact official-document candidates from the existing IJF,
EJU and Kodokan roots and prepares fail-closed version, acquisition and reviewer
metadata. It does not acquire a file, allocate a canonical `JM-SRC-*` ID,
interpret rule text, map a candidate to a claim, assign a person, or approve any
rule, safety statement, science, threshold or capability.

مرحله JM-S0.4-B نامزدهای دقیق سند رسمی را فقط از ریشه‌های IJF، EJU و Kodokan
شناسایی و metadata لازم برای نسخه، دریافت و نقش بازبین را به‌صورت fail-closed
آماده می‌کند. هیچ فایل دریافت، شناسه منبع تخصیص، قانون تفسیر، claim متصل، شخص
منتسب یا approval ایجاد نشده است.

## Preflight

- Repository: `D:/projects/judo_mind`
- Branch: `master`
- HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`
- Initial working tree: 90 tracked-status paths, 208 untracked files, 0 staged
  files, and 0 tracked deletions.
- Baselines: 62 sources, 132 claims, 16 safety claims, 793 metric/threshold
  records, 362 asset records and 20 scientific capabilities.
- Scientific approvals, rule/threshold eligibility and capability activation:
  `0`.
- Biomechanist review: `0/3`, all decisions pending.

All S0.4-A and protected-review hashes, the 297-file application manifest, the
235-file media/source manifest and four HPS registry hashes were recorded before
authoring.

## Official discovery method

Read-only discovery used only official primary pages:

- IJF documents: `https://www.ijf.org/ijf/documents`
- EJU documents: `https://www.eju.net/eju/documents/`
- Kodokan techniques: `https://kdkjudo.org/techniques/`
- Kodokan technique-name page:
  `https://kdkjudo.org/techniques/judo-techniques/`

No third-party mirror, search-result page, news article or social-media post was
used as authority. Search results were leads only. Direct document URLs were
recorded only when exposed on an official primary host without opening the
file; otherwise the field remains blank.

## Candidate set

Eleven candidates were retained, below the maximum of twelve:

| ID | Issuer | Exact candidate | Authority class | Current-validity state |
|---|---|---|---|---|
| `JM-ODC-0001` | IJF | IJF Sport and Organisation Rules (SOR), Version 14.08.2026, ENG | Official rule/regulation | Possibly current, not confirmed |
| `JM-ODC-0002` | IJF | IJF SOR Refereeing Rules, Version 21.01.2026, ENG | Official rule/regulation | Possibly current, not confirmed |
| `JM-ODC-0003` | IJF | IJF Safeguarding policy, 28.01.2025, ENG | Official administrative information | Possibly current, not confirmed |
| `JM-ODC-0004` | IJF | Guidance for Athletes Returning to Competition After Pregnancy, 20.04.2026 | Official technical/educational guidance | Possibly current, not confirmed |
| `JM-ODC-0005` | EJU | EJU General Handbook, Edition May 2026 | Official administrative information | Possibly current, not confirmed |
| `JM-ODC-0006` | EJU | EJU Regulations for Referees 2026, 2026.01.14 | Official rule/regulation | Possibly current, not confirmed |
| `JM-ODC-0007` | EJU | EJU Adapted Judo Rules 2026 | Official rule/regulation | Possibly current, not confirmed |
| `JM-ODC-0008` | EJU | EJU Ne-Waza Competition Rules | Official rule/regulation | Not verified |
| `JM-ODC-0009` | EJU | Eligibility Criteria for Athletes with Disabilities, Version 11.09.2025 | Official administrative information | Possibly current, not confirmed |
| `JM-ODC-0010` | Kodokan | Kodokan Definitions of Judo Techniques 01.10.2022 | Official technical/educational guidance | Not verified |
| `JM-ODC-0011` | Kodokan | Judo Technique Names List PDF, 2017.04.01 | Official technical/educational guidance | Not verified |

Counts: IJF 4, EJU 5 and Kodokan 2. Authority classes: official
rule/regulation 5, technical/educational guidance 3 and administrative
information 3.

No candidate is marked `VERIFIED_CURRENT`. The latest visible date is not used
as proof of operative legal validity.

## Version and supersession

- `POSSIBLY_CURRENT_NOT_CONFIRMED`: 8
- `NOT_VERIFIED`: 3
- `VERIFIED_CURRENT`: 0
- `SUPERSEDED`: 0
- `CONFLICTING_VERSION_INFORMATION`: 0

The official IJF listing exposes earlier related 2026 SOR and 2024 refereeing
titles, but the exact replacement scope and effective-date chain require human
verification. Absence of a later visible listing is explicitly not proof that a
candidate is current.

## Acquisition readiness

All 11 acquisition records are `QUEUED_NOT_DOWNLOADED` with
`NOT_AUTHORIZED_IN_THIS_STAGE`. `SHA256`, `acquired_on` and `acquired_by` are
blank. No canonical intake path is documented in the current project, so every
target remains `PENDING_CANONICAL_PATH_DECISION`; no directory was created.

Candidate IDs are discovery identifiers only and do not enter the 62-row source
inventory.

## Reviewer-role readiness

Nine role scopes cover official competition/refereeing rules, technical rule
interpretation, technique teaching, technique-execution precautions, training-
environment safety, medical/injury safety, return to play/competition, Persian
translation and canonical English product wording.

The matrix defines roles, minimum evidence and fail-closed outcomes without
assigning any person. Dr. Mahdi Baghaiyan's existing authorization remains
limited to the three assigned biomechanical sources. Mohammad Javani receives
no new scope.

## Existing-claim cross-check

- Existing official-rule claims: `0`.
- Official-rule claim links: `0`.
- Existing safety claims: `16`.
- Explicit claim-level safety sources: `0`.
- Safety claims remaining `LOCKED`: `16`.

Candidate relevance did not become evidence linkage. No existing claim wording,
classification or source mapping changed.

## Stop boundary

The stage stops before download, cryptographic file intake, duplicate checking,
canonical source registration, version/supersession sign-off, exact clause
mapping, translation review, safety or medical review, reviewer assignment,
human decision, rule eligibility, scientific approval or production use.
