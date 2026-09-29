# Judo Mind Icon System Evidence Audit

Date: `2026-08-13`

Status: `CANDIDATE BATCH 01 VALIDATED / HUMAN REVIEW REQUIRED`

## Recoverable Repository Evidence

The authoritative semantic registry is
`lib/core/design_system/icons/judo_icons.dart` (`JudoIcons` version `1.1.0`).
It contains exactly `51` semantic identifiers in seven evidenced subsets:

| Evidenced subset | Registry identifiers |
|---|---:|
| Technique Intelligence | 15 |
| Visual Learning | 17 |
| Competition Intelligence | 4 |
| AI Intelligence | 3 |
| Performance | 4 |
| Monitoring | 4 |
| Community | 4 |
| **Total** | **51** |

All 51 registry entries currently resolve to Material `IconData`. They are
temporary implementations behind stable semantic identifiers, not custom Judo
Mind icon artwork.

The repository contains no SVG icon asset. Under `assets/icons/judo/`, the only
file is `placeholder.png`. A separate legacy widget at
`lib/core/widgets/judo_icon.dart` references ten PNG paths (`technique`,
`video`, `quiz`, `source`, `champion`, `ai_bot`, `monitoring`, `kuzushi`,
`tsukuri`, `kake`); none of those ten files exists. That widget is not the
approved `lib/core/design_system/widgets/judo_icon.dart` renderer and must not
be treated as proof of implemented custom icons.

## Status Counts

| Status | Evidenced count | Meaning |
|---|---:|---|
| Custom and implemented semantic icons | 0 | No custom SVG or matching custom registry asset exists. |
| Semantic IDs with temporary Material implementation | 51 | Implemented registry API; custom artwork pending. |
| Explicit legacy PNG mappings with missing assets | 10 | Historical code references only; not approved assets. |
| Designed but not implemented custom icons | Not recoverable | No reviewed design manifest or asset set establishes this count. |
| Missing relative to the historical approximately-120 system | Not recoverable | Exact historical taxonomy and denominator are absent. |

Repository search found no text that records the earlier approximately
120-icon taxonomy, its exact count, or its subset allocation. The number 120
must therefore remain historical/unverified and must not be reconstructed by
subtracting 51 from an approximate target.

CustomPainter illustrations and application launcher icons are separate asset
families and are excluded from the semantic icon count.

## Direct Material-Icon Debt

The refreshed bounded `lib/**/*.dart` audit found exactly `243` `Icons.*`
references: `51` current Material mappings in the central registry and `192`
direct bypasses across `53` files. The increase from the earlier baseline is
explained by the independently validated training-experience foundation; this
icon Block does not broadly replace those usages.

Exact bypass files:

1. `lib/core/widgets/judo_app_bar.dart`
2. `lib/core/widgets/judo_badge.dart`
3. `lib/core/widgets/judo_button.dart`
4. `lib/core/widgets/judo_icon.dart`
5. `lib/screens/home/home_screen.dart`
6. `lib/screens/profile/athlete_profile_screen.dart`
7. `lib/screens/splash/splash_screen.dart`
8. `lib/screens/technique_detail/widgets/actions/technique_primary_actions.dart`
9. `lib/screens/technique_detail/widgets/analyze/analyze_section.dart`
10. `lib/screens/technique_detail/widgets/analyze/single_attempt_v2a_result_card.dart`
11. `lib/screens/technique_detail/widgets/analyze/single_attempt_v2a_review_panel.dart`
12. `lib/screens/technique_detail/widgets/analyze/single_camera_pose_summary_card.dart`
13. `lib/screens/technique_detail/widgets/competition/competition_section.dart`
14. `lib/screens/technique_detail/widgets/content/technique_content_widgets.dart`
15. `lib/screens/technique_detail/widgets/description/description_section.dart`
16. `lib/screens/technique_detail/widgets/hero/hero_section.dart`
17. `lib/screens/technique_detail/widgets/ijf_profile/ijf_profile_section.dart`
18. `lib/screens/technique_detail/widgets/media/analysis_media_card.dart`
19. `lib/screens/technique_detail/widgets/media/competition_analysis_card.dart`
20. `lib/screens/technique_detail/widgets/media/fullscreen_video_screen.dart`
21. `lib/screens/technique_detail/widgets/media/image_media_card.dart`
22. `lib/screens/technique_detail/widgets/media/media_filter_bar.dart`
23. `lib/screens/technique_detail/widgets/media/media_section.dart`
24. `lib/screens/technique_detail/widgets/media/technique_media_preview.dart`
25. `lib/screens/technique_detail/widgets/media/top_execution_card.dart`
26. `lib/screens/technique_detail/widgets/media/video_controls.dart`
27. `lib/screens/technique_detail/widgets/media/video_detail_screen.dart`
28. `lib/screens/technique_detail/widgets/media/video_error_state.dart`
29. `lib/screens/technique_detail/widgets/media/video_media_card.dart`
30. `lib/screens/technique_detail/widgets/media/video_player_placeholder.dart`
31. `lib/screens/technique_detail/widgets/media_card_factory.dart`
32. `lib/screens/technique_detail/widgets/media_gallery.dart`
33. `lib/screens/technique_detail/widgets/sections/biomechanics_section.dart`
34. `lib/screens/technique_detail/widgets/sections/conditioning_section.dart`
35. `lib/screens/technique_detail/widgets/sections/overview_section.dart`
36. `lib/screens/technique_detail/widgets/sections/resistance_band_training_section.dart`
37. `lib/screens/technique_detail/widgets/sections/shadow_training_section.dart`
38. `lib/screens/technique_detail/widgets/sections/sources_section.dart`
39. `lib/screens/technique_detail/widgets/sections/technical_analysis_section.dart`
40. `lib/screens/technique_detail/widgets/sections/technique_section_placeholder.dart`
41. `lib/screens/technique_detail/widgets/sections/technique_section_router.dart`
42. `lib/screens/technique_detail/widgets/sections/training_experience_shared.dart`
43. `lib/screens/technique_detail/widgets/sections/training_section.dart`
44. `lib/screens/technique_detail/widgets/tactical/tactical_intelligence_section.dart`
45. `lib/screens/technique_detail/widgets/technical_analysis.dart`
46. `lib/screens/technique_detail/widgets/technique_bottom_sheet.dart`
47. `lib/screens/technique_detail/widgets/technique_dashboard_item.dart`
48. `lib/screens/technique_detail/widgets/video_buttons.dart`
49. `lib/screens/technique_detail/widgets/visual_learning/technique_phase_visual_guide.dart`
50. `lib/screens/technique_detail/widgets/visual_learning/three_layer_visual_player.dart`
51. `lib/screens/techniques/widgets/technique_card.dart`
52. `lib/screens/techniques/widgets/technique_filter_button.dart`
53. `lib/screens/techniques/widgets/technique_search_bar.dart`

Prioritized future classification groups are: (1) Uchi Mata Gold feature
semantics in dashboard, training, analysis and media; (2) reusable
feature-state semantics such as unavailable, safety and verification; (3)
generic platform actions such as back, close, play and search, which may remain
Material when approved; and (4) the ten missing legacy PNG mappings. No group
is authorized for bulk replacement by this audit.

## Machine-Readable Manifest and Candidate Batch 01

`design/icon_system/judo_icon_manifest.v1.json` contains exactly the 51 runtime
semantic IDs and their mappings, subset, source/status, candidate path,
approval, RTL, accessibility and evidence metadata. It records the approximate
target `120`, evidenced `51`, explicitly unnamed unresolved positions `69`, ten
legacy missing references and production-approved custom count `0`.

Candidate Batch 01 contains 12 original editable SVG sources:

`kuzushi`, `tsukuri`, `kake`, `grip`, `entry`, `biomechanics`, `visualLayers`,
`movementLayer`, `shadowTraining`, `mistakesAndSafety`, `aiCoach`, `aiAnalysis`.

All remain `candidate_review_required`. They live under
`design/icon_candidates/batch_01/`, outside the runtime asset directories and
are not listed in `pubspec.yaml`. No `JudoIcons` mapping or production UI is
changed. The design baseline is
`docs/JUDO_MIND_ICON_DESIGN_SPEC_V1.md`; the self-contained review sheet is
`design/icon_candidates/batch_01/contact_sheet.svg`. A local PNG renderer was
not available, so no PNG derivative was created.

## Required Manifest Fields

A future reviewed icon manifest must contain, at minimum:

- stable semantic icon ID;
- canonical English meaning and localization/accessibility key;
- evidenced subset;
- owning module/capability and intended surfaces;
- current implementation type (`custom`, `material-temporary`, `missing`);
- asset path and renderer when implemented;
- visual status (`proposed`, `reviewed`, `approved`, `deprecated`);
- source/designer and license/ownership status;
- dark/light, selected, disabled and small-size QA state;
- RTL mirroring policy;
- replacement target for any temporary Material icon;
- approval date/reviewer and version.

## Approval Lifecycle

`proposed -> evidence/design review -> approved semantic identity -> asset
implementation -> accessibility/RTL/small-device QA -> approved for use ->
deprecated/replaced`

Only an approved semantic ID may be consumed by a feature. Custom assets must
enter through `JudoIcons` and the Design System renderer so feature screens do
not depend on asset details. Missing or unapproved artwork retains an honest
temporary/missing status; it must not be reported as a completed custom icon.

## Candidate Batch 02 — 2026-08-13

Batch 01 remains unchanged for visual comparison. Batch 02 contains the same
12 evidenced IDs and remains outside runtime assets:

- refined: `visualLayers`, `shadowTraining`, `mistakesAndSafety`, `aiCoach`,
  `aiAnalysis`;
- redesigned: `kuzushi`, `tsukuri`, `kake`, `grip`, `entry`, `biomechanics`,
  `movementLayer`.

Kuzushi/Tsukuri/Kake now share one two-judoka phase family. Entry uses
footwork/pivot geometry instead of a building-exit metaphor; Grip represents
jacket lapel/sleeve control; Biomechanics uses connected joint/angle/vector
geometry; Movement Layer and AI Analysis are simplified for 16 px review.

The manifest preserves both candidate paths. Every Batch 02 item remains
`candidate_review_required`, `productionApproved=false`, is excluded from
`pubspec.yaml`, and leaves `productionApprovedCustomCount=0`. Human semantic,
Judo, originality/license, accessibility, small-size, light/dark and Design
System review remains required.

RTL metadata is corrected: technique Entry, Counter, Transition and Movement
Layer no longer auto-mirror. Technique laterality is independent from reading
direction; only a true navigation/UI-direction semantic may be marked
`directional` in the future.

Validation: manifest/runtime identity, exact subset counts, both batch file
sets, all SVG/XML, candidate status/path lineage, packaging exclusion,
unresolved/legacy evidence and RTL policy `5/5 PASS`.
