# JM-S0.4-A Official Rules, Source Authority and Safety Governance Report

Date: `2026-08-30`
Status: `GOVERNANCE READINESS ONLY / NO APPROVAL OR ACTIVATION`

## Scope / دامنه

JM-S0.4-A creates an auditable inventory of existing official-organization
roots, rule-claim gaps, safety-claim gaps, and fail-closed gates. It is not
scientific synthesis, legal advice, medical review, rule approval, content
approval, threshold creation, or production readiness.

مرحله JM-S0.4-A فهرستی قابل‌ممیزی از ریشه‌های سازمانی رسمی موجود، شکاف‌های
اتصال ادعاهای قانونی، شکاف‌های ادعاهای ایمنی و gateهای fail-closed ایجاد می‌کند.
این مرحله سنتز علمی، مشاوره حقوقی، بازبینی پزشکی، تأیید قانون یا محتوا، ایجاد
آستانه یا آمادگی تولیدی نیست.

## Preflight / پیش‌پرواز

- Repository: `D:/projects/judo_mind`
- Branch: `master`
- HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`
- Initial working tree: 90 tracked-status paths, 201 untracked files, 0 staged
  files, and 0 tracked deletions.
- Baselines: 62 sources, 132 claims, 16 `SAFETY_GUIDANCE` claims, 793
  metric/threshold records, 362 asset records, and 20 capabilities.
- Scientific approvals, threshold eligibility, rule eligibility, and
  production-enabled scientific capabilities: `0`.
- Dr. Mahdi Baghaiyan review completion: `0/3`; all three decisions pending.

پیش‌پرواز staging و حذف tracked نداشت و تمام hashهای فایل‌های انسانی، کد
برنامه، منابع/رسانه و HPS پیش از ویرایش ثبت شد. تغییرات قبلی کاربر خارج از
دامنه این مرحله حفظ شدند.

## Existing official-source audit / ممیزی منابع رسمی موجود

The 62-source inventory contains three existing organization-root candidates:

| Source | Issuing body | Additive authority class | Result |
|---|---|---|---|
| `JM-SRC-0039` | Kodokan Judo Institute | `OFFICIAL_TECHNICAL_OR_EDUCATIONAL_GUIDANCE` | Organization identity verified; root is not a specific rule or scientific source |
| `JM-SRC-0041` | European Judo Union | `OFFICIAL_ADMINISTRATIVE_INFORMATION` | Continental organization identity verified; root is not a specific regulation |
| `JM-SRC-0042` | International Judo Federation | `OFFICIAL_ADMINISTRATIVE_INFORMATION` | International organization identity verified; root is not a versioned rule document |

Official read-only verification routes were:

- Kodokan organization and legal pages:
  `https://kdkjudo.org/組織情報/` and
  `https://kdkjudo.org/legal-information-and-notices/`
- EJU organization and document pages:
  `https://www.eju.net/eju/` and `https://www.eju.net/eju/documents/`
- IJF documents and rules pages:
  `https://www.ijf.org/ijf/documents/26` and `https://rules.ijf.org/`

The IJF portal publicly identified versioned 2026 SOR/refereeing materials,
but those individual documents are not existing `JM-SRC-*` records. No PDF was
downloaded and no document title, version, clause, or rule was silently attached
to the IJF organization-root source.

در موجودی ۶۲منبعی فقط سه ریشه سازمانی فوق وجود داشت. هویت سازمانی آن‌ها از
صفحات عمومی رسمی بررسی شد، اما صفحه اصلی سازمان به قانون نسخه‌دار یا شاهد
علمی تبدیل نشد. هیچ PDF دریافت نشد و هیچ سند یا بند تازه‌ای به منبع پایه IJF
نسبت داده نشد.

## Official-rule claim mapping / نگاشت ادعاهای قانونی

None of the 132 existing claims is classified as
`OFFICIAL_RULE_OR_REGULATION`, and no exact rule article, clause, page, or
versioned official document is explicitly linked at claim level. The official
rule claim-link registry is therefore valid and header-only with zero rows.

هیچ‌یک از ۱۳۲ ادعای موجود در طبقه `OFFICIAL_RULE_OR_REGULATION` نیست و هیچ
ماده، بند، صفحه یا سند رسمی نسخه‌دار در سطح ادعا به‌صورت صریح متصل نشده است؛
بنابراین رجیستری لینک ادعای قانونی عمداً فقط header و دارای صفر ردیف است.

## Safety-claim gap / شکاف ادعاهای ایمنی

All 16 existing `SAFETY_GUIDANCE` claims were preserved verbatim and recorded
exactly once:

- `TECHNIQUE_EXECUTION_PRECAUTION`: 10
- `GENERAL_EDUCATIONAL_PRECAUTION`: 5
- `TRAINING_ENVIRONMENT_SAFETY`: 1
- Explicit claim-level source: 0
- `NO_EXPLICIT_SOURCE`: 16
- Gate state `LOCKED`: 16

تمام ۱۶ ادعای ایمنی بدون تغییر متن و دقیقاً یک‌بار ثبت شدند. subtypeها صرفاً
پیشنهاد inventory هستند و تأیید ایمنی یا پزشکی ایجاد نمی‌کنند. همه به‌علت نبود
منبع صریح و sign-off مناسب در وضعیت `LOCKED` باقی ماندند.

## Fail-closed gates / gateهای بسته

Fourteen additive gates cover source identity, authority, current version,
supersession, exact clause, translation, jurisdiction, regulatory/educational
separation, safety evidence, medical escalation, reviewer roles, product
wording, historical preservation, and production prohibition.

- `LOCKED`: 8
- `REVIEW_REQUIRED`: 6
- Approval or enablement created: 0

چهارده gate افزوده شد: ۸ مورد `LOCKED` و ۶ مورد `REVIEW_REQUIRED`. هیچ gate
تأیید یا فعال‌سازی تولیدی ایجاد نمی‌کند.

## Protected biomechanist review / بازبینی بیومکانیک محافظت‌شده

`JM-SRC-0025/0026/0027` remain assigned to Dr. Mahdi Baghaiyan with review
completion `0/3` and decisions `PENDING`. `JM-SRC-0028/0029` remain
`DEFER_FULL_TEXT_REQUIRED`. The assignment CSV, blank bilingual form, human
sign-off registry, all 29 metric states, and all scientific capabilities were
not modified. `UM-ANG-004` remains `METHOD_BLOCKED`.

منابع ۰۰۲۵ تا ۰۰۲۷ همچنان به دکتر مهدی بقاییان واگذار شده‌اند و تکمیل بازبینی
۰ از ۳ است. منابع ۰۰۲۸ و ۰۰۲۹ deferred باقی مانده‌اند. فرم، تصمیم انسانی،
metricها و capabilityها تغییر نکردند و `UM-ANG-004` همچنان `METHOD_BLOCKED`
است.

## Stop boundary / مرز توقف

This stage stops before versioned official-document intake, exact clause
mapping, translation sign-off, Judo-rule sign-off, safety sign-off, medical or
scientific review, content approval, rule eligibility, threshold eligibility,
or production activation.

این مرحله پیش از دریافت کنترل‌شده سند رسمی نسخه‌دار، نگاشت بند دقیق، تأیید
ترجمه، تأیید قانون جودو، تأیید ایمنی، بازبینی پزشکی یا علمی، تأیید محتوا و هر
نوع فعال‌سازی متوقف می‌شود.
