# Judo Mind Icon Design Specification

Version: `1.0.0`

Status: `CANDIDATE DESIGN BASELINE / HUMAN REVIEW REQUIRED`

## Responsibility Boundary

- `JudoIcons` governs runtime semantic IDs and current mappings.
- `design/icon_system/judo_icon_manifest.v1.json` governs evidence, candidate
  paths and artwork approval lifecycle.
- `docs/JUDO_MIND_PRODUCT_FRAMEWORK.md` governs the approximate 120-icon
  product target.
- Candidate artwork is not a runtime asset and does not increase the production
  custom-icon count.

## Vector Baseline

- Editable SVG with a `24 24` viewBox.
- Consistent optical margin; essential strokes stay inside the viewBox.
- Primary stroke approximately 2 px at 24 px.
- Rounded line caps and joins.
- Monochrome `currentColor` compatibility; Design System tokens apply only at
  rendering time.
- Legible and distinguishable at 16, 20, 24 and 32 px.
- Meaning must not rely on color alone.
- Each source includes an accessible title; runtime semantics require a
  localized label key from the manifest.
- Original Judo Mind geometry only. Material paths and third-party copyrighted
  artwork must not be copied.

## RTL and Directionality

Mirror only when the semantic meaning is a true navigation/UI-direction action
and its manifest metadata explicitly says `directional`. Technique entry,
counter, transition and movement-path semantics do not auto-mirror: technique
laterality is independent from reading direction. Do not automatically mirror
technique rotation, Japanese text, belts, badges, medals, grips or anatomical
sides.

## Candidate Review Gates

1. Semantic fit and collision review against all evidenced IDs.
2. Judo/coach review for technique meaning.
3. Accessibility, light/dark and 16/20/24/32 px visual QA.
4. RTL behavior review where metadata is directional.
5. Originality/license/ownership confirmation.
6. Design System implementation review.
7. Explicit human approval and manifest status change.

Until all gates pass, status remains `candidate_review_required`, runtime
Material mappings remain unchanged, and `productionApprovedCustomCount` stays
zero.
