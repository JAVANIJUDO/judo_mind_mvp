# JM-S1.0-A Validation Report

Date: 2026-09-01
Result: `PASS — Read-Only Scientific Transparency Visible on Mobile / No Scientific, Medical, AI, Threshold, Rule or Production Activation`

## Preflight

- Project: `D:/projects/judo_mind`
- Branch: `master`
- HEAD: `5ffca92a62d84b044e93716a073ef3413df0070d`
- Starting working tree: 90 modified, 295 untracked, 0 staged, 0 tracked deletions
- Existing user work was preserved; no staging or Git-history operation was
  performed.

## Acceptance validation

- Scientific Status card appears only on the Uchi Mata detail surface.
- The bilingual details sheet contains all six required information sections
  plus the read-only capability panel.
- Missing or unrecognized presentation data renders locked/not reviewed.
- Candidate data cannot render an approved state or an enable action.
- English and Persian/RTL widget coverage passed at narrow width and 2x text
  scale.
- Focused Scientific Transparency tests: `7/7 PASS`.
- Relevant Uchi Mata navigation/content/Persian regression tests: `44/44 PASS`.
- Combined focused/relevant validation: `51/51 PASS`.
- Complete Flutter suite: `195 PASS, 1 FAIL`. The single failure is the existing
  `technique_training_experience_test.dart` expectation for the Persian string
  `تمرین تخصصی تأییدشده این تکنیک در دسترس نیست`; the current pre-existing
  `trainingExperienceUnavailable` ARB value is
  `تمرین اختصاصی این تکنیک هنوز در دسترس نیست`. Scientific Transparency added
  only new localization keys and did not change that key, its widget, or the
  test. The unrelated mismatch was therefore preserved and not hidden or
  rewritten.
- `flutter analyze --no-pub`: no errors in JM-S1.0-A files; three existing
  `unused_element` warnings remain in
  `lib/screens/technique_detail/widgets/media/media_section.dart` at lines 486,
  625, and 722.

## Protected-state validation

- Scientific approvals created: 0.
- Threshold eligibility created: 0.
- Rule eligibility created: 0.
- Production-enabled capabilities created: 0.
- All 16 safety claims remain locked.
- `UM-ANG-004` remains method blocked.
- `JM-SRC-0028` and `JM-SRC-0029` remain full-text-required/deferred.
- Biomechanist review remains incomplete/pending (`0/3` completed).
- Core V4 and reviewer nomination state remain unchanged.
- HPS, source/PDF/video/model/media, protected registry, and manifest hashes
  remain unchanged.
- Inference, benchmark, model, pose, and video processing runs: 0.

## Final repository checks

- Protected before/after hash sample: `15/15 PASS`, including capability,
  claim, source, metric-gap, Core V4, reviewer, nomination, safety,
  biomechanist, media, HPS Master/S3.3, and the protected 0265/0270/0271 PDFs.
- Repository-wide `git diff --check`: `PASS` (line-ending notices only).
- New-file trailing-whitespace scan: `PASS`.
- Staged files: 0.
- Tracked deletions: 0.
- Task-created temporary artifacts: 0.
