# JM-S1.0-B1 Real-Device Gap Report

Date: 2026-09-01

## Manual evidence and scope

Manual validation on Xiaomi 2201116PG showed that the Settings scientific
boundary was visible while the Uchi Mata Scientific Status card was absent.
The S1.0-A automated tests had exercised the card directly, not the production
Techniques route. This report records the bounded runtime correction; it does
not claim a new real-device PASS.

## Exact root cause

The production Flutter `TechniqueModel` for Uchi Mata has the stable catalog ID
`001`. S1.0-A compared that ID with `uchi-mata`, which is the separate API/V2A
transport identifier. The comparison therefore returned false on the real
Techniques -> Uchi Mata -> Technique Detail path and omitted the card.

The adapter now owns the verified catalog ID `001`, exposes an exact
`isGovernedTechniqueId` check, and maps all other IDs to the existing
locked/not-reviewed fail-closed snapshot. Technique Detail renders the card
only for the exact governed ID. It does not match localized names, substrings,
or the API identifier, and unrelated techniques receive no Uchi Mata source
coverage.

## Automated-test gap and correction

The original tests passed a governed snapshot directly to
`ScientificStatusCard`; they did not select the production Uchi Mata model from
`TechniquesScreen`. The corrected widget test now opens the real Techniques
screen, selects the production record, verifies ID `001`, confirms the card,
opens Sources and Limitations, and observes candidate, validation-only, and
locked states. Separate checks prove that an unrelated model receives no card
or candidate sources and that unknown/malformed identifiers fail closed.

## Wording audit

Settings now describes the four V2A items as engineering metrics limited to
validation and explicitly says they are not scientifically approved for
definitive technique assessment. Raw `review_required` is replaced by a
localized qualified-human-review explanation.

The additional real-device phrases were audited as presentation labels rather
than registry classifications. Ambiguous `approved` and `scientific history`
wording was replaced with exact terms including available technique catalog,
curated educational content, bounded engineering workflow with human-checked
inputs, engineering validation summary, and local validation history. Internal
enums, stored contracts, provenance, capability states, and data were not
renamed or reclassified.

No scientific, medical, metric, threshold, rule, source, reviewer, AI,
video-analysis, or production approval was created. No inference, benchmark,
model, or video processing was run.

## Real-device closure — 2026-09-01

The user-provided English and Persian screenshots verify the corrected
production path on the authorized Android device: the Uchi Mata Scientific
Status card is visible, Sources and Limitations opens, both English and
Persian/RTL displays pass without visible overflow, and other techniques remain
intentionally locked. The locked routes were not treated as evidence of a
non-Uchi Detail negative path.

`PASS — Uchi Mata Scientific Transparency Verified on Real Android Device in English and Persian/RTL / Other Techniques Intentionally Locked / No Scientific or Capability Activation`
