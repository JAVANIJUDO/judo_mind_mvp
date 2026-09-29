# Device-Evidence Reconciliation and Athlete Experience Convergence V1

Date: 2026-08-15

This is a bounded validation record, not a product charter or capability
registry. Canonical product, runtime, architecture, scientific, decision and
status authority remains with the documents named in `AGENTS.md`.

## Installed-APK recovery baseline

- Original v4 artifact preserved unchanged:
  `canonical_v4_device_validation_20260815_114557_274`
- APK timestamp: `2026-08-15T11:49:07.1968775+03:30`
- APK size: `103726146` bytes
- APK SHA-256:
  `341ba5319701dd09496a471b7a92b711c298850d9333a36b4a6430dbc687b13d`
- Direct ADB recovery artifact:
  `build/device_validation/installed_apk_launch_recovery_20260815_121026_797`
- Recovery result: `LAUNCH_RECOVERY_GATE_PASS`
- Evidence: launch exit `0`, PID `2551` alive after the bounded wait,
  `MainActivity` foreground/resumed and no immediate app-specific fatal crash.

No rebuild, reinstall, app-data clear or inference was performed by the
recovery validation.

## Block A — Runtime truthfulness closure

| Feature | Entry point | Visible result | Evidence | Status |
| --- | --- | --- | --- | --- |
| Contextual Analyze | Athlete Home | One Uchi Mata-scoped Analyze action | Existing Home navigation contract and reviewed V2A route audit | Preserved |
| Technique Analyze | Uchi Mata Detail | Exactly one technique-local Single-Attempt action | `uchi_mata_navigation_integrity_test.dart` | PASS |
| Media Library | Uchi Mata > More > Media | Missing media remains visible as unavailable without play/open affordance or route | Media-card synthetic widget test | PASS |
| Grounded Sensei | Reviewed result only | No pre-result or Media coaching action | Source-route audit and prior validated Grounded Sensei suite | Preserved |
| Persian dynamic content | Uchi Mata learning surfaces | Complete Persian execution, key points, mistakes, safety, combinations and counters | Dynamic-model English/Persian widget tests | PASS |
| Technique catalog | Learn > Techniques | `1` production technique, `4` closed previews, `67` roadmap target | Catalog contract and tests | PASS |
| Taxonomy | Technique cards | Uchi Mata shows approved two-level taxonomy; previews hide unsupported secondary taxonomy | Catalog widget tests | PASS |
| Educational biomechanics | Uchi Mata > Biomechanics | Localized “educational visualization—not a measurement” disclosure and illustrative-direction labeling | English/Persian biomechanics widget tests | PASS |
| Sources | Uchi Mata > Sources | IJF/Kodokan/EJU roots labeled as organization/general references, not technique-specific direct evidence | Sources widget test | PASS |
| Module availability | Platform directory | Unavailable modules remain closed | Existing canonical 18-module registry tests | Preserved |

Catalog accounting is deliberately non-overlapping:

- runtime records: `5`
- production available: `1` (`Uchi Mata`)
- incomplete preview/unavailable: `4`
- roadmap target: `67`
- roadmap techniques not represented by a runtime record: `62`

Block A validation:

- targeted Flutter tests: `54/54 PASS`
- bounded static analysis: `17 items`, `No issues found`
- localization generation: PASS for the English/Persian changes
- scientific formulas, V1/V2A versions, provenance, detector, tracker and
  Identity behavior: unchanged

## Block B — Athlete information architecture

Status: `VALIDATED`

- Athlete Home preserves the five-journey governance contract while giving
  equal primary prominence only to four real actions: Learn, Analyze Uchi
  Mata, Track Progress and Athlete Profile. Train and Connect with Coach are
  non-interactive compact `Coming later` items.
- Home Track Progress opens the evidence-only Progress Overview. A ready
  Progress Overview can open raw Local Analysis History; its no-evidence
  primary action opens the reviewed Uchi Mata Analyze boundary instead of an
  empty History screen.
- Technique Detail retains one primary Analyze action, Learn, Track Progress /
  History and one More group. Unavailable Train and Coach actions share one
  compact fail-closed group rather than competing with working actions.
- The registry-backed secondary catalog is presented as `Platform overview`.
  It still contains exactly `18` official modules; working destinations are
  labeled for athletes and the unavailable set remains collapsed under
  `Coming later`, without exposing internal engineering-readiness labels as
  primary UI.
- Settings ownership remains limited to language, local-data transparency,
  real History count/deletion and existing scientific disclosures.

Block B validation:

- Home, Progress, module-registry, Settings, Persian/localization and initial
  navigation run: `48 PASS`; three navigation expectations exposed the new
  collapsed grouping and were corrected.
- current Uchi Mata navigation retest: `12/12 PASS`
- bounded static analysis: `8 items`, `No issues found`
- targeted diff check: clean (line-ending warnings only)

No Android build, reinstall, inference, Git-history operation, scientific
formula/version, provenance, detector, tracker, Identity, training
prescription or module identity changed in Block B.
