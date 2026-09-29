# JM-S1.0-B1 Validation Report

Date: 2026-09-01
Result: `PASS — Uchi Mata Scientific Transparency Verified on Real Android Device in English and Persian/RTL / Other Techniques Intentionally Locked / No Scientific or Capability Activation`

## Software validation

- Production catalog identity: Uchi Mata `TechniqueModel.id == 001`.
- Incorrect S1.0-A condition: catalog ID compared with API identifier
  `uchi-mata`.
- Corrected mapping: exact catalog ID `001`; no name/substrings; every unknown
  identifier maps to locked/not-reviewed with zero candidate sources.
- Production-path widget test: PASS.
- Unrelated-technique isolation: PASS.
- English and Persian Settings wording: PASS.
- Misleading phrase and raw-enum source audit: PASS.
- Focused transparency, wording, Settings, localization, Progress, and Uchi
  Mata navigation tests: `45/45 PASS`.
- Full Flutter suite after expectation synchronization: `202/202 PASS`.
- `flutter analyze --no-pub`: no B1 errors; three pre-existing unused-element
  warnings remain in `media_section.dart` at lines 486, 625, and 722.
- Android ARM64 debug build: PASS.
- APK: `D:/projects/judo_mind/build/app/outputs/flutter-apk/app-debug.apk`
- APK timestamp: `2026-09-01T11:39:17.7425581+03:30`
- APK size: `108182494` bytes.
- APK SHA-256:
  `e5215b9f547c932ed904a7e2b2476706c82de620797dacf9eee38376100fc552`.

## Governance preservation

- Scientific approvals created: 0.
- Metric approvals created: 0.
- Threshold/rule eligibility created: 0/0.
- Production capability activation: 0.
- HPS/source/PDF/media/model modification: none.
- Reviewer decisions modified: none.
- Inference/benchmark/model/video processing: none.

## Manual real-device closure

The user-provided English and Persian screenshots from the authorized Android
device verify that the Uchi Mata Scientific Status card is visible, Sources and
Limitations opens, English and Persian/RTL presentation pass without visible
overflow, and other techniques remain intentionally locked. The locked routes
mean a non-Uchi Detail negative path was not manually exercised; no inference
about an unavailable screen is made.

Final closure:

`PASS — Uchi Mata Scientific Transparency Verified on Real Android Device in English and Persian/RTL / Other Techniques Intentionally Locked / No Scientific or Capability Activation`
