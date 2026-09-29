# Judo Mind Persian UX Writing Guide

Status: Approved writing baseline

Scope: User-facing Persian in the Athlete App, Coach Workspace,
Club/Federation Console and Judo Intelligence Core

This guide governs presentation language. It does not change scientific
contracts, metric identifiers, provenance, source data or approved Judo terms.

## Voice

- Write short, direct and respectful sentences.
- Tell the athlete what is available, what action is possible and what remains
  unavailable.
- Prefer everyday Persian over internal product, engineering or research terms.
- Do not translate English grammar word for word.
- Do not describe unfinished work with developer-facing language such as
  `foundation`, `partial`, `slice`, `pipeline`, `contract` or `readiness` on a
  primary card.

## Primary-card pattern

A primary card should normally contain:

1. a clear title;
2. one short sentence;
3. one honest action or unavailable state.

Scientific limitations must remain accessible but should not overwhelm Home or
the first level of a journey. Metric IDs, schema versions, method versions and
review bindings belong under the collapsed label `جزئیات علمی`.

## Approved terminology

| Product meaning | Persian presentation |
| --- | --- |
| Analyze Uchi Mata | تحلیل اجرای اوچی‌ماتا |
| Track Progress | مرور تحلیل‌ها |
| Local Analysis History | تحلیل‌های ذخیره‌شده |
| review required | نیازمند بازبینی |
| Unavailable | هنوز در دسترس نیست |
| Foundation / partial | در حال تکمیل |
| Explore all capabilities | مشاهده همه بخش‌ها |
| Scientific & capability transparency | اعتبار علمی و محدودیت‌ها |
| Local data & privacy | داده‌های روی دستگاه و حریم خصوصی |
| Advanced | پیشرفته |
| Start Training | شروع تمرین |
| Champions | قهرمانان |

## Judo and Japanese terms

Japanese technique and taxonomy names may remain when they are the recognized
Judo term, but the first user-facing occurrence should include Persian context.
Examples:

- ناگه‌وازا (فنون پرتابی)
- آشی‌وازا (فنون پا)
- کوزوشی (برهم‌زدن تعادل)

Do not translate or alter a technique identity in storage, routing or scientific
contracts merely to improve presentation.

## Scientific integrity

- Preserve the distinction between measured, reconstructed, model-estimated and
  AI-inferred data.
- Never replace `نیازمند بازبینی` with language that implies approval.
- Never describe single-camera output as measured/reconstructed 3D, real force,
  torque, power or laboratory biomechanics.
- Keep scientific IDs and version details exact when shown under `جزئیات علمی`.
- Translate explanatory text; do not translate identifiers such as
  `UM-ANG-001`.
- A missing Persian translation fails closed as unavailable. It must not silently
  fall back to English on a completed Persian journey.

## Availability and errors

Use concise, actionable wording:

- `تمرین‌های اختصاصی اوچی‌ماتا هنوز آماده انتشار نیستند.`
- `ارتباط امن با مربی هنوز فعال نشده است.`
- `ویدیو انتخاب نشد.`
- `تحلیل وضعیت بدن به‌صورت ایمن متوقف شد. دوباره تلاش کنید.`

Do not expose raw exceptions, backend status tokens or internal readiness enums
to the athlete.

## RTL and mixed content

- Persian layout, navigation order, directional icons, charts and interaction
  order must follow RTL, not text alignment alone.
- Japanese terms, URLs, metric IDs and file names may remain LTR inside Persian
  context.
- Dynamic taxonomy, difficulty, status and provenance values must pass through
  the localization layer before rendering.

## Review checklist

- No unintended English remains on the reachable Persian path.
- Home cards use short athlete-facing language.
- Technique taxonomy and difficulty are localized.
- Quiz questions, options and explanations are Persian without changing answer
  indices.
- Analysis errors and dynamic statuses are localized.
- Scientific IDs and versions are behind `جزئیات علمی`.
- English mode remains complete and unchanged in meaning.
- Tests cover the reachable Persian path and RTL direction.
