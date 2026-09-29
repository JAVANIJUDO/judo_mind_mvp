# JM-S1.1-B Validation Report

Date: 2026-09-02

Result: `PASS — FAIL-CLOSED FOUNDATION VALIDATED / ZERO UNLOCKS`

## Preflight

- Repository: `D:/projects/judo_mind`
- Branch: `master`
- HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`
- Starting status records: `398`
- Staged files: `0`
- Tracked deletions: `0`
- Existing modified and untracked work was preserved.

## Structural and route checks

- Non-Uchi readiness CSV rows: `66/66 PASS`.
- ID `001` excluded from the readiness CSV: PASS.
- Unique readiness identifiers: `66/66 PASS`.
- Duplicate current runtime IDs: `0`.
- Current runtime canonical identities: `5`; exact 67-canonical-identity
  completeness remains unavailable and was not fabricated.
- Classification total: `66/66 PASS` (`0 ready`, `0 partial`, `4 content
  remediation`, `62 route/model blocked`, `0 conflicts`).
- `readOnlyEducationalTechniqueIds`: empty.
- Uchi Mata `001` specialized route: PASS.
- Explicitly eligible synthetic non-001 route to generic adapter: PASS; the
  synthetic fixture is test-only and absent from production data/navigation.
- malformed, unknown, duplicate, and non-eligible routes: PASS fail-closed.
- selected-language empty content: PASS explicit unavailable state.
- non-001 science/analysis/metric/capability absence: PASS.
- English and Persian/RTL rendering: PASS.
- push/back navigation: PASS.

## Automated validation

- Focused Flutter validation: `36/36 PASS`.
- Complete Flutter suite: `217/217 PASS`.
- `flutter analyze --no-pub`: no JM-S1.1-B error; exit `1` only for the three
  pre-existing `unused_element` warnings in
  `lib/screens/technique_detail/widgets/media/media_section.dart` at lines
  486, 625, and 722.
- Android ARM64 debug build: PASS, native exit code `0`.
- APK: `D:/projects/judo_mind/build/app/outputs/flutter-apk/app-debug.apk`
- APK timestamp: `2026-09-01T23:39:10.1148416+03:30`
- APK size: `108191264` bytes.
- APK SHA-256:
  `ccf84bd58221c3500430f5fb9bf4103988c5f8e2c11c05f3eb0b9158c8529966`

## Protected-state validation

- Protected scientific hashes: `20/20 PASS`.
- Scientific approvals created: `0`.
- Scientific threshold eligibility created: `0`.
- Scientific rule eligibility created: `0`.
- AI/scientific/video-analysis capabilities activated: `0`.
- Techniques unlocked: `0`.
- Source/PDF/media/model/scientific-registry modifications: `0`.
- Inference, benchmark, detector, tracker, pose, or video runs: `0`.

## Final repository checks

- Repository-wide `git diff --check`: PASS (line-ending notices only).
- Task-created-file trailing-whitespace scan: PASS.
- Final status records: `405` (`90` unstaged modified, `315` untracked).
- Staged files: `0`.
- Tracked deletions: `0`.
- No commit, push, reset, restore, checkout, clean, stash, or branch operation
  was performed.

`PASS — Generic Non-Uchi-Mata Route and Model Foundation / No Fabricated Content, Scientific Approval, AI, Threshold, Rule or Unauthorized Capability Activation`
