# FOUNDER OPERATING SYSTEM

Status: ACTIVE
Effective date: 2026-09-02
Applies to: Product development, technical development, scientific governance,
commercialization, maintenance, support and future expansion.

---

## 1. Purpose

The project shall not be developed through ad-hoc feature work.

Every meaningful development cycle must follow an explicit roadmap, a defined
commercial objective, documented decision ownership and a controlled
Maker -> Checker -> Challenger -> Docker lifecycle.

The objective is not zero defects, because no real software system can
guarantee that condition.

The objective is:

- prevent avoidable technical and architectural mistakes;
- detect defects and regressions before release whenever reasonably possible;
- preserve scientific and governance boundaries;
- minimize unnecessary rework;
- maintain traceable decisions;
- keep released capability supportable and regression-safe;
- continuously improve based on verified bugs, requirements, evidence and
  real market feedback.

---

## 2. Founder role

The Founder is the Product Owner and final owner of product direction,
commercial direction, priorities and project continuation.

The Founder does not claim automatic authority over every specialist domain.

When a qualified specialist has stronger authority in a specific field,
the specialist decision may become the governing project decision.

Examples include:

- medicine;
- psychology;
- biomechanics;
- physiology;
- sports science;
- information security;
- privacy and law;
- software architecture;
- other regulated or specialist areas.

Such decisions must be documented with:

- decision topic;
- responsible role;
- evidence or rationale;
- date;
- applicable scope;
- known limitations.

Authority is competence-based, not title-based.

---

## 3. AI operating roles

The primary AI collaboration model is:

MAKER -> CHECKER -> CHALLENGER -> DOCKER -> GREEN -> NEXT CYCLE

### MAKER

Design and implement the approved solution.

Responsibilities include:

- convert approved requirements into implementation;
- preserve existing project invariants;
- avoid unrelated changes;
- maintain compatibility with approved architecture;
- build the smallest complete and coherent slice required by the roadmap.

### CHECKER

Verify the work independently from the perspective of correctness.

Responsibilities include:

- functional testing;
- regression testing;
- authorization and security boundary testing where relevant;
- data and persistence validation;
- scientific-boundary validation where relevant;
- static validation;
- migration validation;
- UI or device validation where required;
- confirmation that approved requirements were actually implemented.

The Checker must not assume that a Maker output is correct merely because the
same AI produced it.

### CHALLENGER

Actively attempt to disprove the current design.

Questions include:

- Why is this implementation correct?
- What can fail?
- What assumption is unsupported?
- Is there a simpler design?
- Is the capability actually needed now?
- Is the feature being overengineered?
- Could authorization be bypassed?
- Could confidential information become discoverable?
- Is a scientific claim being implied without approval?
- Will this create unnecessary maintenance cost?
- Does this improve product value, commercial value or foundation value?

A material Challenger finding returns the work to MAKER.

### DOCKER

Lock the completed outcome into project memory.

Responsibilities include:

- update project status;
- document important decisions;
- record limitations;
- record test evidence;
- record unresolved technical debt;
- preserve provenance;
- identify next approved milestone;
- prevent previously closed work from being casually redesigned.

Docker does not mean software containers in this governance model.
It means formally docking the completed result into project documentation.

---

## 4. GREEN rule

A development slice becomes GREEN / CLOSED only when:

1. the intended requirement is implemented;
2. relevant automated tests pass;
3. applicable regression tests pass;
4. security/scientific/governance boundaries remain intact;
5. Challenger review reveals no unresolved blocking issue;
6. documentation required for the slice is updated.

GREEN does not mean the software can never contain a bug.

It means the slice has met the currently defined acceptance gates.

---

## 5. Reopening a CLOSED slice

A CLOSED slice must not be reopened merely because a different idea appears.

Valid reopening triggers are:

1. verified bug;
2. approved new requirement;
3. new evidence;
4. security or privacy issue;
5. scientific/governance correction;
6. material production or user feedback.

All reopening must state the trigger.

---

## 6. Feature admission rule

Every significant new feature must be classified against four questions:

### Product Value
Does it materially solve a user problem?

### Commercial Value
Does it improve acquisition, conversion, retention, revenue or institutional value?

### Foundation Value
Is it required for security, integrity, privacy, governance, science or architecture?

### Deferability
Can it safely be implemented after initial market entry?

A feature with weak Product, Commercial and Foundation value and high
Deferability belongs in BACKLOG.

Interesting is not the same as necessary.

---

## 7. Market readiness layers

Each project maintains four separate layers:

### CORE PRODUCT
Capabilities required to solve the primary problem.

### MARKET ENTRY
Capabilities required to make a convincing first presentation.

### REVENUE READINESS
Capabilities required to request money, sell a subscription, run a paid pilot
or sign an institutional agreement.

### EXPANSION ROADMAP
Capabilities that are intentionally postponed until after initial validation
or revenue.

Feature-complete is not required for market entry.

A weak product must not be released merely to meet a date.

---

## 8. Release chronology

The standard commercial sequence is:

AUTHORITY BUILDING
-> CONTROLLED REVEAL
-> DEMO / BETA
-> FIRST PAYMENT / PAID PILOT
-> EVIDENCE
-> EXPANSION
-> SCALE

The market must enter the decision loop before every possible feature is built.

---

## 9. Coming Soon policy

The main product UI should primarily show capabilities that are usable.

Do not fill navigation with inactive modules.

Coming Soon is permitted only when:

- the future capability materially improves purchase confidence;
- its scope is credible;
- it does not falsely imply current availability.

Preferred locations:

- Product Roadmap;
- What's Next;
- Release Notes;
- commercial presentation.

Judo Mind may expose a maximum of a small number of strategically valuable
future teasers.

Institutional systems such as IRAN HPS should generally avoid disabled
Coming Soon navigation in operational dashboards.

---

## 10. Scientific and professional integrity

No AI, developer, Founder, mock data, configuration value or commercial need
may create scientific truth by implication.

Where specialist approval is required, the project must remain explicitly
unapproved until that approval exists.

Commercial pressure must never silently convert a hypothesis into a validated
scientific rule.

---

## 11. Development cadence

Work shall follow the roadmap rather than spontaneous module switching.

Each active project has:

- a current milestone;
- a closure gate;
- a next milestone;
- a commercial objective.

Development may deviate only for:

- blocking bugs;
- security incidents;
- critical infrastructure failure;
- approved market evidence;
- approved Founder reprioritization recorded in project documentation.

---

## 12. Portfolio priority

Current portfolio priority:

1. IRAN HPS — primary active domestic strategic project
2. Judo Mind — active international commercial project
3. Kurash Platform — preserved but development-frozen

New fourth product development is not started while this portfolio rule is active.

Ideas may be documented in backlog without becoming active development.

---

## 13. Support lifecycle

Post-launch support uses the same cycle:

MONITOR
-> ISSUE / FEEDBACK
-> TRIAGE
-> MAKER
-> CHECKER
-> CHALLENGER
-> DOCKER
-> RELEASE
-> MONITOR

The objective is continuous GREEN health, not one-time completion.
