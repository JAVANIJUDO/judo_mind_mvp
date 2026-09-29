# JM-S1.1-A Non-Uchi-Mata Technique Library Unlock Readiness Report

Date: 2026-09-01

Scope: read-only repository audit only

Outcome: `FAIL-CLOSED — CANONICAL 67-TECHNIQUE REGISTRY IS NOT PRESENT`

## Non-activation boundary

This report does not unlock a technique. It creates no scientific approval,
analysis eligibility, AI capability, score, mastery state, prescription,
safety diagnosis, threshold, rule, production permission, or route. It does
not treat roadmap intent as runtime availability.

## JM-S1.0-B1 closure evidence

The user-provided real-device English and Persian screenshots close the bounded
B1 presentation check as:

`PASS — Uchi Mata Scientific Transparency Verified on Real Android Device in English and Persian/RTL / Other Techniques Intentionally Locked / No Scientific or Capability Activation`

The evidence shows the Uchi Mata Scientific Status card, the open Sources and
Limitations presentation, English and Persian/RTL display without visible
overflow, and the intentional lock on other technique routes. Because those
routes are locked, the screenshots do not establish a negative-path Detail
result for any non-Uchi technique.

## Catalog and identity finding

The approved roadmap count is `67`, but the canonical runtime registry contains
only five unique `TechniqueModel` records:

| ID | English identity | Runtime state |
|---|---|---|
| 001 | Uchi Mata | production reference; excluded from this audit |
| 002 | Seoi Nage | non-interactive preview |
| 003 | O Soto Gari | non-interactive preview |
| 004 | Harai Goshi | non-interactive preview |
| 005 | Tomoe Nage | non-interactive preview |

No project-owned canonical name/ID registry exists for the other 62 roadmap
positions. `TechniqueFactory.officialRoadmapTechniqueCount == 67` is a count,
not a registry. `all_techniques.dart` and `ijf_techniques.dart` repeat the same
five records. Therefore no name, Japanese identity, Persian identity, category,
belt, difficulty, content, media, or route can be truthfully attributed to
roadmap positions `006–067`.

The readiness CSV contains 66 audit rows as required: four real runtime IDs and
62 explicit `UNRESOLVED-*` audit-local placeholders. Those placeholders are
not canonical technique IDs and must never be imported into the runtime
registry. Their purpose is to make the missing scope countable without
inventing identities.

## Classification summary

| Readiness state | Count | Meaning in this audit |
|---|---:|---|
| `READ_ONLY_EDUCATIONAL_READY` | 0 | No technique meets the future-open gate. |
| `READ_ONLY_PARTIAL_CONTENT` | 0 | No incomplete page is approved to open. |
| `CONTENT_REMEDIATION_REQUIRED` | 4 | IDs 002–005 exist but require governed remediation. |
| `ROUTE_OR_MODEL_BLOCKED` | 62 | Canonical registry/model/route identity is absent. |
| `DUPLICATE_OR_IDENTITY_CONFLICT` | 0 | No duplicate among the five runtime IDs; missing identity is not fabricated as a conflict. |

## Existing preview-record audit

All four records have unique IDs, stable English names, Japanese names, basic
English educational fields, three quiz items, general organization links, and
Persian name/description/technical-analysis fields. None has completed
technique-specific editorial, safety, source, localization, media, or
scientific review for future opening.

Common blockers for IDs `002`, `004`, and `005`:

- Persian list fields are absent, so steps, key points, mistakes, safety tips,
  combinations, and counters silently fall back to English.
- Declared local image assets do not exist.
- video fields are YouTube search-result queries rather than curated media.
- general IJF/Kodokan/EJU home pages are organization references, not evidence
  that each technique field was reviewed.
- the generic Detail renderer would show a V1 video-analysis entry if a caller
  bypassed the intentionally locked catalog route; only reviewed V2A is gated
  by `supportsReviewedSingleAttemptV2A`.
- no non-Uchi record is allowed to inherit the Uchi Mata Scientific Status
  snapshot; the exact-ID adapter correctly returns the locked fail-closed state.

ID `003` additionally has a taxonomy inconsistency: `category == Ashi Waza`
while `type == Koshi Waza`. The preview card currently hides the unsupported
secondary taxonomy, but that does not remediate the underlying data conflict.

## Route and rendering finding

The production Techniques screen enables navigation only when
`TechniqueFactory.availabilityOf` returns `production`; only ID `001` is in
`productionTechniqueIds`. IDs `002–005` are therefore safely non-interactive
today. Unknown records have no model or route.

The shared Detail architecture can render model-driven sections and explicit
empty states, but it is not yet a safe future-open boundary for these records:

- the primary Analyze card is unconditional;
- the generic V1 Analyze section is considered available for an unsupported
  technique;
- some educational sections render English fallback inside Persian;
- media and taxonomy issues remain unresolved.

This audit does not change that architecture. It records these issues as gates
for a later bounded remediation milestone.

## Future read-only eligibility gate

A later technique may be considered only after all of the following are true:

1. a project-approved canonical ID and stable English identity exist;
2. identity, taxonomy, belt, difficulty, and content fields are internally
   consistent;
3. technique-specific educational and safety content has governed review;
4. English renders completely and Persian/RTL renders only reviewed localized
   fields without silent completion claims;
5. missing sections visibly remain unavailable;
6. media is curated, licensed, present, and route-safe;
7. the Uchi Mata Scientific Status card is absent;
8. all video analysis, metrics, diagnosis, prediction, prescription, scoring,
   mastery, and locked destinations remain unreachable;
9. malformed and unknown IDs fail closed;
10. focused catalog-to-detail tests pass before a route is enabled.

## Exact bounded next milestone

`JM-S1.1-B — Canonical Technique Identity Registry and One Neutral Read-Only Technique Remediation`

That milestone should first establish the approved 67-identity registry without
opening routes, then select exactly one neutral non-Uchi technique from IDs
`002–005` for content/localization/media/route remediation. It must separately
remove non-Uchi analysis exposure and retain all scientific fail-closed gates.
Bulk unlocking is not authorized.

## Final disposition

The audit itself is complete and preserves the current safe lock. Unlock
readiness is not established: zero non-Uchi techniques are eligible to open.

`FAIL — Non-Uchi-Mata Technique Read-Only Unlock Readiness Audit / No Technique Unlock, Scientific Approval, AI, Threshold, Rule or Production Activation`
