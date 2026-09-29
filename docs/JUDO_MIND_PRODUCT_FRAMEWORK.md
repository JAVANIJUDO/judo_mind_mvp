# Judo Mind Product Framework

Date: `2026-08-13`

Status: `APPROVED PRODUCT CHARTER`

## Purpose and Authority

This charter preserves the approved long-term product intent for Judo Mind in
one stable, human-readable and searchable place. It defines what the platform
is intended to become and the boundaries that every implementation must
respect. It is not a changelog, runtime availability list or claim that an
unfinished capability is complete.

The responsibility hierarchy is:

1. `docs/JUDO_MIND_PRODUCT_FRAMEWORK.md` governs approved product intent.
2. The canonical code registry in `JudoMindModules.modules` governs runtime
   module identity, destination and availability.
3. `docs/ARCHITECTURE.md` governs technical structure and system boundaries.
4. `docs/AI_DEVELOPMENT_RULES.md` governs implementation and scientific rules.
5. `docs/DECISION_LOG.md` governs accepted decisions and their rationale.
6. `docs/PROJECT_STATUS.md` governs the validated current state.
7. `docs/CHANGELOG.md` records completed changes.

These sources are coordinated, not interchangeable. Product intent does not
activate a route; code existence does not prove validation; and a future target
must never be recorded as a completed current capability.

## Product Position

**Judo Mind is a trusted multilingual Judo Intelligence Platform connecting
structured technique education, scientifically governed video analysis,
athlete development history, AI-guided explanation and coach/federation
workflows.**

Its intended competitive moat is the governed connection of:

- structured knowledge for 67 Judo techniques;
- scientifically bounded video analysis;
- grounded AI Sensei explanations;
- longitudinal athlete development and progress;
- athlete-coach-club-federation workflows;
- multilingual content, evidence and governance.

This position is a product direction. It is not a claim of market leadership,
scientific validation of unfinished analysis or production readiness.

## Canonical 18 Official Modules

The official module count is exactly 18. Module identity is independent of
whether a destination is currently implemented or exposed on Athlete Home.

<!-- OFFICIAL_MODULES_START -->
1. Home
2. Techniques — 67 Techniques
3. Sensi Bot
4. Sensi Bet
5. Monitoring / Progress & Mastery
6. AudioCast
7. Athlete Profile
8. Training Center
9. Champions Hub
10. Competitions & Challenges
11. News
12. Store & Subscriptions
13. Club Administration
14. Coach Forum
15. Online Courses
16. Country Judo History
17. App Management & Settings
18. Training Program Validator
<!-- OFFICIAL_MODULES_END -->

The canonical code registry is the operational source for stable IDs,
localized display keys, owning surfaces, routes, readiness and honest
unavailable/deferred reasons. Registration does not grant availability.
Unfinished modules must fail closed without fake routes, placeholder screens or
misleading actions. The 18 modules must not become 18 equal-weight Home tiles.

## Shared Video-Analysis Modes Are Not Modules

The following are shared analysis capabilities across the platform and do not
increase the official module count:

1. Technique Analysis — One Attempt
2. Training / Drill Analysis — Multiple Repetitions
3. Competition Analysis — Full Match

Each mode requires its own validated input, temporal and identity assumptions.
One mode's validation never automatically validates another.

## Coordinated Platform Surfaces

Judo Mind operates through four coordinated surfaces:

1. **Athlete App** — learning, training, capture, reviewed analysis, history
   and athlete-facing guidance.
2. **Coach Workspace** — reviewed athlete support, technique education and
   future coach-governed interpretation.
3. **Club/Federation Console** — future role-governed club, federation,
   program and administrative workflows.
4. **Judo Intelligence Core** — governed knowledge, AI, computer vision,
   scientific analysis and reusable platform contracts.

The future Athlete Home information architecture is organized around five
primary journeys:

1. Learn
2. Train
3. Analyze
4. Track Progress
5. Connect with Coach

## Uchi Mata Gold Reference

Uchi Mata is the product-critical Gold Reference used to prove a scalable
technique architecture. Its complete target definition includes:

- approved overview and technical content;
- Kuzushi, Tsukuri and Kake;
- execution steps;
- key points, common mistakes and safety;
- combinations and counters;
- licensed and approved video and visual learning;
- technique-specific biomechanics;
- technique-specific Shadow Training;
- technique-specific Strength & Conditioning;
- technique-specific Resistance-Band Training;
- visual or video Quiz;
- V1 and human-reviewed V2A analysis;
- grounded AI Sensei explanation;
- local History and Progress;
- a complete English and Persian experience.

Every educational destination requires a distinct primary visual or video
artifact appropriate to its purpose. Reusing one generic stick-figure
animation under different section names is not sufficient evidence of distinct
learning experiences.

Gold Reference is a completion target, not a blanket statement that every item
above is currently implemented, licensed, approved or scientifically validated.

## Reusable Training Content for 67 Techniques

All future technique-specific training uses the reusable structured contract
attached to the existing `TechniqueModel`; it must not create a parallel
content system. The contract supports:

- Shadow Training drills;
- Strength & Conditioning drills;
- Resistance-Band drills;
- stable drill identity and drill kind;
- localized title, objective and steps;
- related technique phase and required equipment;
- approved prescription or dosage and athlete level;
- approved media and safety guidance;
- source, provenance, availability and approval status.

The contract is reusable across all 67 techniques, but reuse does not authorize
generic filler or automatic bulk population. Empty/unavailable is the default.
No drill becomes active without approved selected-language content, media,
safety, prescription and source/provenance evidence. Exercise dosage must never
be invented.

## English/Persian Localization Contract

- Selecting Persian requires all completed user-facing UI and approved content
  to be Persian; selecting English requires English.
- The contract includes labels, structured technique content, Quiz, Sources,
  validation errors, analysis results, safety messages and grounded AI Sensei
  output.
- Japanese technique names may remain Japanese beside the selected-language
  explanation.
- RTL governs layout, navigation direction, directional icons, charts and
  interaction order, not text alignment alone.
- Silent English fallback inside a completed Persian experience is prohibited.
- Missing or unapproved translation must remain honestly incomplete or
  unavailable instead of being presented as completed localized content.
- The existing ARB/generated-localization system remains the single
  localization architecture.

## Custom Judo Mind Icon-System Charter

The long-term product target is an approximately 120-icon custom Judo Mind
semantic system. The number is a historical approximate target, not a verified
current manifest and not an implementation count.

Current repository evidence, recorded in
`docs/JUDO_MIND_ICON_SYSTEM_AUDIT.md`, proves 51 semantic `JudoIcons` IDs in
seven subsets, all currently backed by temporary Material icons; zero custom
semantic SVG icons; and ten legacy PNG mappings whose assets are missing. The
exact historical approximately-120 taxonomy and remaining count are not
recoverable and must not be invented.

Future icon work requires a reviewed manifest with semantic ID, meaning,
subset, owning module/surface, implementation status, asset/license,
accessibility, RTL policy, visual QA, approval, version and replacement target.
The lifecycle is:

`proposed -> evidence/design review -> approved semantic identity -> asset
implementation -> accessibility/RTL/small-device QA -> approved for use ->
deprecated/replaced`

Custom icons enter through `JudoIcons` and the centralized Design System.
Temporary Material usage must remain explicitly temporary until reviewed
artwork completes the lifecycle.

## Grounded AI Sensei Boundaries

AI Sensei explanations must be grounded in approved Judo content, cited or
governed sources and the actual reportable analysis evidence. They must preserve
the result's provenance, confidence availability, quality status, limitations
and withheld states.

AI Sensei must not:

- invent technique facts, translations, sources or exercise prescriptions;
- promote an unavailable result into a scientific or coaching conclusion;
- diagnose injury or replace qualified medical or coaching judgment;
- infer Tori/Uke, phase quality or technical fault without validated evidence;
- turn model visibility, detector coverage or execution success into pose
  accuracy or biomechanics confidence;
- claim measured 3D, force, torque, moment, power or load from ordinary
  single-camera video.

Where evidence is insufficient, the correct response is a bounded explanation
of what is unavailable and why.

## Scientific Fail-Closed and Provenance Rules

Every scientific result must keep these classifications separate:

- measured;
- reconstructed;
- model-estimated;
- AI-inferred.

Each reportable result must identify its source, method/version, applicable
confidence evidence, quality/status and limitations. Missing inputs, invalid
geometry, unsupported schemas, ambiguous identity or insufficient scientific
evidence must produce `review_required`, `withheld` or an honest unavailable
state—not a fabricated value.

Ordinary single-camera analysis is bounded 2D/model-estimated analysis. It must
not be presented as measured or reconstructed 3D, actual force, torque, moment,
power, precise COM, load or injury risk. Multi-camera scientific analysis
requires synchronized and calibrated cameras, validated geometry,
cross-camera identity, reconstruction and quality gates before biomechanics or
OpenSim use. Calibration with failed/review-required quality must never enter
that pipeline.

Automatic Identity and advanced multi-person association research remain
frozen. Evaluation-only neutral Track A/Track B research is not production
approval, must not infer Tori/Uke and must fail closed on ambiguity, crossing,
occlusion and unverified reappearance. Detector-threshold tuning remains closed
under its governing decision.

## Human-First Analysis Architecture

Judo Mind analysis follows this governed chain:

`Observation -> Evidence -> Human Confirmation -> Analysis -> Coaching Support`

Human confirmation defines athlete role. Model-returned candidates preserve
bounded evidence and never become automatic Tori/Uke identity. The product may
state that a human selected a candidate as Tori; it must never state that AI
detected Tori. Clothing colour may be used only as a visual selection aid, such
as “candidate wearing blue clothing,” and never as identity or role evidence.

The product keeps three layers separate:

1. **Technique Intelligence:** one selected technique and attempt, explicit
   human Tori selection, session-bound evidence, governed analysis and bounded
   technique feedback. Uchi Mata is the current reference implementation.
2. **AI-Assisted Competition Timeline:** a future evidence-organization layer
   for segments and important moments followed by coach review. It is not
   implemented and may not provide tactical judgment or coaching truth.
3. **Coach Analysis Marketplace:** a future human-expert service layer in which
   an athlete may request a coach review. Coach selection, reports, payments
   and revenue sharing are not implemented and require separate product,
   privacy, safety, commercial and legal gates.

Availability in one layer never enables another layer or upgrades engineering
evidence into scientific approval.

## Product Priorities and Deferred Boundaries

The approved order is:

1. Complete and validate Uchi Mata Gold as the reference slice.
2. Prove template reuse with one neutral second technique before expanding all
   67 techniques.
3. Build the core athlete loop: Athlete Profile, Training Center,
   Monitoring/Progress and grounded AI Sensei.
4. Extend the governed loop to Coach/Club workflows and Training Program
   Validator.
5. Advance other modules only through explicit bounded Work Orders and honest
   runtime availability.

Sensi Bet is isolated and deferred pending legal, age, ethical and
federation-brand review. Automatic Identity/advanced multi-person research is
frozen. Media-dependent content remains blocked until licensing and approval
evidence exists.

## Media, Safety, Privacy and Federation Readiness

- Educational media must have documented ownership, license and approval for
  its intended product use.
- Training and analysis experiences must expose appropriate safety guidance and
  must not invent prescriptions or medical conclusions.
- Video, athlete and profile data require explicit purpose, consent, bounded
  retention, access control and special care for minors and sensitive data.
- Coach, club and federation workflows require role/auth authorization,
  privacy boundaries, auditability and federation-brand review.
- Accessibility, localization, performance, security, distribution and
  applicable legal validation are release gates.
- A debug build, successful installation, model execution or local demo is
  evidence of engineering progress, not production or federation readiness.

## Bounded Four-Hour Work Order Method

When a four-hour Judo Mind mission is authorized, plain-language intent is
translated internally into one bounded engineering Work Order containing:

- Objective;
- Current Context;
- Constraints;
- Scientific/Technical Requirements;
- Files Likely Affected;
- Acceptance Criteria;
- Validation/Tests;
- Documentation Requirements;
- Git Safety.

The four hours are a maximum wall-clock boundary, not permission to fill time,
expand scope or weaken safety. Work begins with complete governance review and
working-tree inspection, proceeds through the smallest coherent implementation,
uses only proportionate validation, synchronizes required documentation and
ends at a safe checkpoint/report. Completed work is not repeated. A blocker is
recorded precisely and independent safe work may continue within scope.

Ambiguity is escalated only when it materially affects outcome, safety,
scientific validity, destructive impact or authority. Otherwise the strongest
supported decision is made from repository evidence. No Work Order authorizes
destructive Git, Push, external publication, paid services, credentials,
scientific claims or adjacent development unless the user explicitly grants
that authority.

## ChatGPT/Codex Credit-Management Workflow

Remaining ChatGPT/Codex credit is an execution-budget signal, not a product
capability and not a reason to weaken evidence, safety, localization,
validation or Git preservation. Codex should translate the approved outcome
into the smallest complete Work Order, avoid repeating validated work, make
one coherent implementation pass and use one proportionate targeted
validation batch. When credit is constrained, the priority is a truthful safe
boundary and recoverable state, not a larger partial scope or invented
completion. Questions are reserved for decisions that materially affect
outcome, authority, scientific validity or safety.

## Club Administration Local Foundation Boundary

Club Administration is Module 13 and belongs to the Club/Federation Console
and Judo Intelligence Core surfaces, not the primary Athlete Home journey. Its
current local foundation is limited to one club on one device:

`local club → current local Athlete Profile membership → training group → structured coach-authored session plan → typed attendance`

Membership stores only membership identity, club link, the current-local-
athlete reference, status, join date and optional membership number. It does
not duplicate Profile personal, sport or body data. Additional athletes,
verified identities, cloud sync, multi-user authorization, federation
verification, insurance, consent, tuition, belt authority, competition
registration, medical records, annual planning and scientific load claims
remain outside this foundation.

A structured plan distinguishes group, explicit session type, optional
coach-authored title/objective, schedule, duration and ordered typed items.
Item dosage is entered by the coach and represents a plan only; it does not
claim athlete completion, readiness, workload, improvement or injury risk.
Migrated records whose historical type was absent remain visibly
`unspecifiedLegacy` rather than being assumed to be Judo. Physical preparation
is limited to clearly identified coach-authored custom entries until the
separate Strength & Conditioning Exercise Library Foundation is approved.
## Local Exercise Library Foundation

Club Administration owns a local-first, backend-replaceable Exercise Library
foundation for reusable session planning. Its shared activity-category and
dosage contracts are the same contracts used by Session Composer; it is not a
second training taxonomy. The approved repository is intentionally empty until
each entry has localization, source, provenance and review evidence. Local
coach-authored entries must remain visibly labelled “Coach-authored — not
scientifically reviewed” / «نوشته مربی — از نظر علمی بازبینی نشده» and may be
archived, not destructively deleted. Selecting an entry stores an immutable
identity/revision/display snapshot while dosage, rest and notes remain
session-specific coach input. This foundation does not constitute a scientific
prescription or a populated exercise database.

## Evidence-Driven Technology Policy

Flutter/Dart is the primary shared Android, iOS and Windows client; Python is
appropriate for AI, video analysis and scientific computation. Native or
systems languages may be added only for evidenced platform/performance needs
with measurable benefit, security review, Build/test method and maintenance
ownership. Packages require target-platform audit, OS-specific behavior belongs
behind adapters, and every platform requires independent real Build and QA
evidence. iOS is not validated without macOS/Xcode evidence. Language count is
not a quality measure and an unsupported Flutter rewrite is prohibited
(JM-DEC-029).
