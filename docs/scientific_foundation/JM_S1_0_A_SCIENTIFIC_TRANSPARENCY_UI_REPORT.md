# JM-S1.0-A Scientific Transparency UI Report

Date: 2026-09-01
Scope: Read-only mobile presentation for the current Uchi Mata scientific state

## Outcome

Judo Mind now exposes a compact Scientific Status card on the Uchi Mata detail
screen and a localized Sources and Limitations bottom sheet. The feature is
informational and read-only. It does not approve a source, claim, metric,
medical statement, capability, threshold, rule, prescription, analysis method,
or production path.

The presentation contract defaults to `LOCKED` and
`NOT_SCIENTIFICALLY_REVIEWED` when data is missing or unrecognized. Candidate
sources remain explicitly labelled `Candidate source`, `Review pending`, and
`Not yet approved for a Judo Mind claim`.

## Governed presentation mapping

The immutable Uchi Mata display adapter is derived from these current project
records:

- `JM_HPS_CORE_V4_DISPOSITION.csv` for the exactly-five candidate-source set;
- `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv` for capability state;
- `JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv` for the method/evidence boundary;
- `JM_S0_7_A5_VALIDATION_REPORT.md` for the latest validated review state.

The requested `JM_CAPABILITY_GATE_REGISTRY.csv` does not exist in the current
repository. The existing canonical capability inventory was used instead; no
duplicate registry or runtime CSV parser was created. The Flutter adapter
contains only safe display fields: title, year, source type, access state, and
review state. It contains no source ID, reviewer identity, local path, hash,
formula, threshold, enable flag, or mutation action.

## Mobile surface

The Uchi Mata card shows scientific status, pending human review, absence of
scientific approval, validation-only video analysis, and locked sensitive
capabilities. Its action opens sections for current status, candidate source
coverage, human-review status, capability state, video-analysis limitations,
safety boundary, and excluded functions.

The capability panel is non-interactive and limits display states to locked,
review required, and validation only. It adds no toggle, developer override,
score, diagnosis, prediction, prescription, referee decision, or production
activation.

English and Persian strings use the existing localization system. Persian is
complete for this surface and inherits RTL layout. The card and sheet use the
existing design system, semantic labels, wrapping, and responsive content for
narrow screens and enlarged text.

## Scientific boundary

The UI explicitly states that pose output is an engineering observation only;
it does not directly measure force or kinetics, establish definitive 3D
biomechanics, diagnose technique or injury, predict injury, or make referee
decisions. Association is not presented as causation, risk is not presented as
a certain prediction, and missing evidence keeps sensitive functions locked.

No HPS file, scientific source, PDF, video, model, media, protected registry,
reviewer decision, scientific claim, threshold/rule eligibility, approval, or
capability state was modified. No inference, benchmark, model, pose, or video
processing was run.
