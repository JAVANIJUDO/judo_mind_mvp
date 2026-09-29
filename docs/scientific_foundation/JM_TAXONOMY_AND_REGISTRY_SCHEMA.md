# Judo Mind Scientific Foundation Taxonomy and Registry Schema

Date: 2026-08-28
Stage: JM-S0.1 through JM-S0.3-C0
Status: Governance schema only; no scientific approval

## Authority

These inventories describe the live repository. They do not replace the product charter, code registry, architecture, AI development rules, decision log, project status or changelog. Empty, unknown and review-required fields are intentional fail-closed states.

## Exact claim taxonomy

- `OFFICIAL_RULE_OR_REGULATION`: a rule/regulation claim only when its official source and version are identifiable; source presence alone is not approval.
- `EDUCATIONAL_TECHNICAL_CONTENT`: technique/coaching education that is not automatically a scientific or normative statement.
- `BIOMECHANICS_OR_MOVEMENT_HYPOTHESIS`: a movement/mechanics interpretation requiring scientific and Judo-domain review.
- `VIDEO_ANALYSIS_ENGINEERING_METRIC`: implementation, coverage, runtime, threshold or evaluation evidence; never pose/biomechanics accuracy without ground truth.
- `SAFETY_GUIDANCE`: safety content requiring appropriate human review; not a diagnosis or medical instruction.
- `AI_OR_MODEL_LIMITATION`: a declared model, inference, provenance or reportability boundary.
- `CLAIM_REQUIRING_HUMAN_SCIENTIFIC_REVIEW`: a claim that must remain withheld/review-required until qualified review is recorded.
- `OUT_OF_SCOPE_OR_UNVERIFIED`: material discovered without enough evidence or outside the current approved scope.

## Registry relationships

- `JM_SOURCE_INVENTORY.csv` assigns provisional `JM-SRC-*` identifiers to local documents and external reference leads.
- `JM_HPS_SOURCE_CROSSWALK.csv` links only exact identifiers or sufficiently exact bibliographic evidence while preserving `HPS-SRC-*` identifiers. It never transfers product approval.
- `JM_CLAIM_INVENTORY.csv` assigns `JM-CLM-*` identifiers and requires exact taxonomy, source location, decision state and prohibited interpretation.
- `JM_METRIC_AND_THRESHOLD_INVENTORY.csv` keeps scientific metrics separate from engineering parameters and historical results.
- `JM_DATASET_MEDIA_INVENTORY.csv` records metadata/hash/purpose/right status without decoding or executing content.
- `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv` is fail-closed: sensitive capabilities are only `LOCKED`, `REVIEW_REQUIRED` or `VALIDATION_ONLY`.
- `JM_HPS_REUSE_CANDIDATES.csv` preserves every current HPS Master Source row
  as a metadata-only Judo Mind reuse candidate. Candidate relevance is not
  evidence review, applicability approval or production permission.
- `JM_CLAIM_SOURCE_LINKS.csv` maps every existing claim to an explicit citation
  state without changing claim text. General document references are not
  claim-level citations, and missing links remain `SOURCE_MAPPING_REQUIRED` or
  `OUT_OF_SCOPE_OR_LOCKED`.
- `JM_UCHI_MATA_BIBLIOGRAPHIC_VERIFICATION.csv` records official bibliographic
  verification, access level and correction/retraction visibility for the five
  bounded Uchi Mata DOI candidates.
- `JM_UCHI_MATA_EVIDENCE_REVIEW_QUEUE.csv` records source-level extraction
  readiness without converting abstract-only access into full-text review.
- `JM_UCHI_MATA_CLAIM_EVIDENCE_MATRIX.csv` accepts only an existing claim ID
  with a directly verifiable evidence location. A header-only matrix is the
  correct fail-closed result when no explicit claim-level link exists.
- `JM_UCHI_MATA_METRIC_EVIDENCE_GAP.csv` preserves the 29-metric boundary and
  keeps bibliographic verification, content review, method definition,
  scientific validation, human sign-off and capability state separate.
- `JM_UCHI_MATA_HUMAN_SIGNOFF_REGISTRY.csv` records auditable reviewer-scoped
  decisions without promoting them beyond their declared scope. A Judo
  technical applicability decision is not full-text review, biomechanical or
  scientific approval, threshold/rule eligibility or production permission.
- `JM_UCHI_MATA_BIOMECHANIST_REVIEW_ASSIGNMENT.csv` records accepted reviewer
  assignments separately from review activity and reviewer decisions.
  Assignment acceptance never establishes that a document was opened,
  reviewed or approved.
- `JM_UM_GOLD_STANDARD_FOUNDATION_V1.md` and its versioned `JM_UM_GOLD_*_V1.csv`
  profiles add the Uchi-mata Gold evidence, event, source-phase, measurement,
  validation-gap, interpretation-rule and rights schemas. Canonical source
  identity remains in `JM_SOURCE_INVENTORY.csv`, canonical metric identity
  remains in `JM_METRIC_AND_THRESHOLD_INVENTORY.csv`, and capability state
  remains in `JM_SCIENTIFIC_CAPABILITY_INVENTORY.csv`; the Gold profiles do not
  supersede or activate any of them.

## JM-UM-GS-0 Uchi-mata Gold schema boundary

JM-UM-GS-0 fixes Product Technique ID `001`, scientific slug `uchi-mata` and
contract version `uchi-mata-gold-foundation-1.0.0`. Unknown source, population,
method, finding and rights fields remain explicit. Evidence rows without an
existing `JM-SRC-*` record use `UNASSIGNED_PENDING_FORMAL_INTAKE` and cannot be
claim evidence.

The event ontology is research-only. E4 and E5 are provisional; no event or
phase is automatically detected. Source operational phase definitions remain
separate from the canonical conceptual phase sequence. The interpretation-rule
registry is intentionally header-only. No validation-gap row is `GREEN`, no
training-use right is granted, and no scientific or production capability is
activated.

## Crosswalk denominator

The JM-S0.2-B denominator includes only Judo Mind sources with an exact eligible
identifier. Current denominator: five DOI-eligible JM sources, zero exact HPS
matches and five genuinely unmatched JM sources. `HPS-SRC-0120` is an HPS-only
context lead and is `EXCLUDED_FROM_JM_MATCH_DENOMINATOR`.

Crosswalk matching remains ordered: exact SHA-256, exact normalized DOI, exact
PMID/ISBN, then exact normalized title plus author plus year. Fuzzy similarity
may create a candidate only and can never set `MATCHED`.

## HPS metadata-only reuse states

Allowed relevance states are `DIRECT_JUDO`, `HIGH_TRANSFERABILITY`,
`SUPPORTING`, `LOW_OR_UNCLEAR` and `OUTSIDE_CURRENT_SCOPE`. Every row must keep
`sport_specific_review_required=YES`, `evidence_reviewed=NO`,
`approval_transferred=NO` and
`candidate_status=METADATA_ONLY_CANDIDATE` until a separately authorized stage.

## Claim-source link states

Allowed link types are `EXPLICIT_INLINE_CITATION`,
`EXPLICIT_SECTION_SOURCE`, `GENERAL_DOCUMENT_REFERENCE` and
`NO_EXPLICIT_SOURCE`. Allowed decisions are `SOURCE_LINKED_NOT_REVIEWED`,
`SOURCE_MAPPING_REQUIRED` and `OUT_OF_SCOPE_OR_LOCKED`. Text proximity,
topic similarity and a general bibliography do not create an explicit claim
link.

## Stable provisional identifiers

Identifiers are stable within this snapshot but provisional until a later approved registry migration. Rows must not be renumbered casually. Future merges should preserve old IDs and record supersession explicitly.

## Evidence and approval gates

`implementation_status`, `verification_status`, `scientific_approval_status`, `production_enabled`, `evidence_approved`, `rule_or_threshold_eligible` and `current_state` are independent. A test PASS or implemented formula cannot set scientific approval. Unknown evidence and missing human sign-off fail closed.

## Provenance

Use only `measured`, `reconstructed`, `model-estimated`, `AI-inferred`, or an explicit engineering/content descriptor when no scientific quantity is being represented. Never relabel estimated output as measured.

## Localization

English is canonical. Existing Persian is recorded only where it can be mapped without invention. Missing Persian remains blank with a note; it is not silently treated as complete.

## JM-S0.3-B review-readiness boundary

JM-S0.3-B verifies bibliography, records official access level, prepares
source/metric evidence gaps and creates blank human-review forms. Full-text
inspection in this stage is readiness extraction only. It does not constitute
human scientific sign-off, approve a claim, define a normative threshold,
activate a rule or capability, or grant production eligibility. Abstract-only
records remain `FULL_TEXT_REQUIRED`.

The next stage requires separate authorization and qualified human reviewers.
It may not infer decisions from this registry or silently promote
`PENDING_HUMAN_REVIEW`.

## JM-S0.3-B-H1 bounded Judo technical sign-off boundary

H1 may record an explicitly confirmed decision only with reviewer identity,
role, decision scope, basis, provenance and timestamp. For the five bounded
Uchi Mata records, the allowed H1 decisions are
`APPROVE_WITH_LIMITATIONS` and `DEFER_FULL_TEXT_REQUIRED`.

`JUDO_TECHNICAL_APPLICABILITY_ONLY` never implies that the reviewer personally
reviewed full text, reproduced the method, approved the biomechanics, approved
an evidence claim, authorized a metric or threshold, or granted production
eligibility. Missing biomechanist review remains `PENDING`; unknown exact
evidence location remains `NOT_RECORDED`; every scientific, threshold, rule
and production gate remains `NO`.

## JM-S0.3-C0 biomechanist assignment boundary

C0 may record a user-confirmed reviewer assignment and prepare blank bilingual
review forms. It must keep assignment, review activity, completed review,
reviewer decision and scientific approval as separate states.

An `ACCEPTED_PENDING_REVIEW` assignment requires reviewer identity, declared
expertise, affiliation, role, scope, source-access status and provenance. It
does not populate conflict-of-interest or confidentiality declarations, review
dates, evidence locations, answers, attestation or a reviewer decision. Those
fields remain blank or explicitly pending reviewer completion.

`JM-SRC-0025` is a one-page conference abstract and cannot be represented as a
full-length article. `JM-SRC-0026` and `JM-SRC-0027` have full text available,
but availability does not establish personal review. `JM-SRC-0028` and
`JM-SRC-0029` remain outside the C0 substantive assignment and retain
`DEFER_FULL_TEXT_REQUIRED`.

## JM-S0.4-A official-authority, rule, and safety governance

JM-S0.4-A adds four registries without changing historical source or claim
classifications:

- `JM_OFFICIAL_AUTHORITY_SOURCE_REGISTRY.csv` records official-organization
  identity, document kind, jurisdiction, version/supersession metadata, and a
  bounded claim-use boundary.
- `JM_OFFICIAL_RULE_CLAIM_LINKS.csv` records only existing claims with an
  auditable official-rule link; a header-only registry is required when no
  existing claim qualifies.
- `JM_SAFETY_CLAIM_SOURCE_GAP.csv` preserves every existing safety claim and
  records its source, authority, evidence, reviewer, and gate gaps.
- `JM_RULE_AND_SAFETY_GATE_REGISTRY.csv` defines additive fail-closed gates; it
  never grants approval or production enablement.

### Additive authority crosswalk

The official-authority registry may use these additive authority classes:

- `OFFICIAL_RULE_OR_REGULATION`
- `OFFICIAL_TECHNICAL_OR_EDUCATIONAL_GUIDANCE`
- `OFFICIAL_ADMINISTRATIVE_INFORMATION`
- `PEER_REVIEWED_SCIENTIFIC_SOURCE`
- `COACHING_OR_EDUCATIONAL_REFERENCE`
- `INTERNAL_PROJECT_DOCUMENT`
- `ENGINEERING_OR_VALIDATION_ARTIFACT`
- `UNVERIFIED_OR_UNRESOLVED`

These values refine authority for JM-S0.4-A without overwriting the historical
`JM_SOURCE_INVENTORY.csv` authority class. An official-organization root is not
automatically a rule or regulation.

### Rule-link states

Allowed rule-link states are `EXPLICIT_VERIFIED`,
`EXPLICIT_SOURCE_VERSION_UNVERIFIED`, `GENERAL_DOCUMENT_REFERENCE`,
`SOURCE_MAPPING_REQUIRED`, `NO_EXPLICIT_SOURCE`, and
`OUT_OF_SCOPE_OR_LOCKED`. Current gate states are limited to `LOCKED` and
`REVIEW_REQUIRED`.

### Proposed safety subtypes

Allowed proposed safety subtypes are `COMPETITION_RULE_SAFETY`,
`TECHNIQUE_EXECUTION_PRECAUTION`, `TRAINING_ENVIRONMENT_SAFETY`,
`INJURY_OR_MEDICAL_SAFETY`, `RETURN_TO_TRAINING_OR_PLAY`,
`GENERAL_EDUCATIONAL_PRECAUTION`, and `UNRESOLVED_SAFETY_TYPE`.

A proposed subtype is an inventory label only. It cannot transform a coaching
precaution into injury prediction, an observation into diagnosis, a warning
into medical advice, or a rule prohibition into a biomechanical conclusion.

### Independent gate boundary

Official-source identity, issuing authority, version/effective date,
supersession, exact clause, translation, jurisdiction, educational/regulatory
separation, safety evidence, medical escalation, reviewer roles, product
wording, historical preservation, and production authorization are independent
gates. Missing or unverified inputs fail closed. Engineering validation,
organization authority, one human role, or a passing gate cannot create
cross-domain scientific approval, threshold/rule eligibility, or production
enablement.

## JM-S0.4-B official-document discovery and intake readiness

JM-S0.4-B adds four candidate-level registries without changing the canonical
62-row source inventory:

- `JM_OFFICIAL_DOCUMENT_DISCOVERY_QUEUE.csv` uses deterministic `JM-ODC-*`
  candidate IDs for exact official-document identities found on primary IJF,
  EJU or Kodokan pages. A candidate ID is never a `JM-SRC-*` source ID.
- `JM_OFFICIAL_DOCUMENT_VERSION_MATRIX.csv` separates a visible version/date
  from effective date, supersession evidence and verified current validity.
- `JM_OFFICIAL_DOCUMENT_ACQUISITION_QUEUE.csv` records lawful future-intake
  readiness. In S0.4-B every row is `NOT_AUTHORIZED_IN_THIS_STAGE` and
  `QUEUED_NOT_DOWNLOADED`; acquisition fields and SHA-256 remain blank.
- `JM_RULE_SAFETY_REVIEW_ROLE_MATRIX.csv` defines qualification requirements by
  content type without assigning a person or inheriting an existing reviewer's
  authority.

### Candidate authority classes

Candidate authority class is limited to:

- `OFFICIAL_RULE_OR_REGULATION`
- `OFFICIAL_TECHNICAL_OR_EDUCATIONAL_GUIDANCE`
- `OFFICIAL_ADMINISTRATIVE_INFORMATION`

Official hosting proves neither regulatory status nor scientific validity.
Document kind, issuing body and stated scope must support the selected class.

### Version and supersession states

Allowed `supersession_check_status` values are:

- `VERIFIED_CURRENT`
- `POSSIBLY_CURRENT_NOT_CONFIRMED`
- `SUPERSEDED`
- `CONFLICTING_VERSION_INFORMATION`
- `NOT_VERIFIED`

Only `VERIFIED_CURRENT` may later enter a rule-review queue, and it still does
not create rule approval, eligibility or production use. A newest visible date,
missing later listing or official organization root is insufficient.

### Acquisition and review boundaries

An acquisition row cannot receive SHA-256, acquisition identity, canonical
storage or source registration before an authorized acquisition actually
occurs. Candidate relevance cannot become claim evidence unless the existing
claim already explicitly names the exact document and location.

Reviewer-role scopes remain independent. Rule, Judo technical, biomechanical,
medical, safeguarding, translation and product-content roles cannot approve one
another's domains. Allowed future readiness decisions are
`ACCEPT_IDENTITY_ONLY`, `ACCEPT_FOR_RULE_REVIEW`,
`ACCEPT_FOR_EDUCATIONAL_REFERENCE`, `ACCEPT_WITH_SCOPE_LIMITATIONS`,
`REQUEST_REVISION`, `DEFER_VERSION_UNVERIFIED`,
`DEFER_SUPERSESSION_UNVERIFIED`, and
`REJECT_WRONG_OR_UNOFFICIAL_DOCUMENT`. None means production, scientific,
medical, rule or threshold approval.

## JM-SCI-OVERNIGHT-01 additive governance registries

The overnight readiness stage adds five registry groups without changing any
existing source, claim, approval, eligibility, metric, or capability record:

- Official intake: `JM_OFFICIAL_DOCUMENT_INTAKE_MANIFEST.csv`,
  `JM_OFFICIAL_DOCUMENT_DUPLICATE_CHECK.csv`, and
  `JM_OFFICIAL_DOCUMENT_PROVENANCE.csv`.
- Source metadata: `JM_SOURCE_METADATA_COMPLETENESS.csv`,
  `JM_SOURCE_METADATA_REMEDIATION_QUEUE.csv`, and
  `JM_SOURCE_IDENTITY_CONFLICTS.csv`.
- Claim citation: `JM_CLAIM_CITATION_REMEDIATION_QUEUE.csv`,
  `JM_CLAIM_PROVENANCE_LOCATION_AUDIT.csv`, and
  `JM_CLAIM_HUMAN_REVIEW_ROLE_QUEUE.csv`.
- HPS reuse: `JM_HPS_REUSE_PRIORITY_QUEUE.csv`,
  `JM_HPS_REUSE_DOMAIN_COVERAGE.csv`, and
  `JM_HPS_REUSE_DUPLICATE_IDENTITY_AUDIT.csv`.
- Consolidated governance: `JM_SCIENTIFIC_FOUNDATION_CONTROL_MATRIX.csv`,
  `JM_SCIENTIFIC_FOUNDATION_OPEN_GAPS.csv`, and
  `JM_SCIENTIFIC_FOUNDATION_DEPENDENCY_MAP.csv`.

Allowed intake states are `ACQUIRED_PENDING_IDENTITY_REVIEW`,
`ACQUIRED_PENDING_VERSION_REVIEW`, `ACQUIRED_DUPLICATE_HASH_REVIEW`,
`QUARANTINED_IDENTITY_MISMATCH`, `QUARANTINED_VERSION_UNVERIFIED`,
`NOT_ACQUIRED_ACCESS_BLOCKED`, `NOT_ACQUIRED_NOT_AUTHORIZED`, and
`SKIPPED_DEPENDENCY_BLOCKED`. Acquisition never allocates a final `JM-SRC-*`
identifier or creates authority, validity, rule, scientific, or production
approval.

Metadata remediation priority is limited to `P0_IDENTITY_CONFLICT`,
`P1_OFFICIAL_OR_SAFETY_SOURCE`, `P2_DIRECT_JUDO_SOURCE`,
`P3_TRANSFERABLE_SPORT_SCIENCE`, `P4_GENERAL_REFERENCE`, and `OUT_OF_SCOPE`.
Candidate verified values are additive and cannot overwrite observed uncertain
values.

Citation state is limited to `EXACT_CLAIM_LEVEL_SOURCE`,
`GENERAL_DOCUMENT_REFERENCE`, `SOURCE_MAPPING_REQUIRED`,
`NO_EXPLICIT_SOURCE`, `SOURCE_IDENTITY_UNVERIFIED`, and
`OUT_OF_SCOPE_OR_LOCKED`. General-document references cannot be promoted to
exact claim evidence without an exact source location and required human
review.

HPS candidates retain original `HPS-SRC-*` IDs and one of
`DIRECT_JUDO_REVIEW_CANDIDATE`, `HIGH_TRANSFERABILITY_REVIEW_CANDIDATE`,
`SUPPORTING_REVIEW_CANDIDATE`, `LOW_OR_UNCLEAR`, or
`OUTSIDE_CURRENT_SCOPE`. Every selected row remains
`PENDING_JM_SPECIFIC_HUMAN_EVIDENCE_REVIEW`; HPS approval is never JM approval.

Consolidated controls use only `PASS`, `PARTIAL`, `NOT_STARTED`,
`BLOCKED_HUMAN_REVIEW`, `BLOCKED_FULL_TEXT`, `BLOCKED_METHOD`, and
`NOT_APPLICABLE`. A control-matrix PASS is structural governance evidence, not
scientific validation of a claim, rule, threshold, prescription, or capability.

## JM-S0.6-A metadata resolution and citation-locator readiness

JM-S0.6-A adds five additive registries without changing canonical source or
claim records:

- `JM_P0_IDENTITY_CONFLICT_RESOLUTION.csv` retains every observed value and
  records delimiter/identity resolution without source merge or deletion.
- `JM_P1_METADATA_VERIFICATION.csv` separates existing metadata from verified
  candidates, provenance, unresolved fields and human-confirmation needs.
- `JM_KODOKAN_DOCUMENT_IDENTITY_REVIEW.csv` verifies acquired-file identity
  while retaining candidate status, supersession uncertainty and human intake.
- `JM_EJU_OFFICIAL_URL_REMEDIATION.csv` preserves historical and replacement
  URLs together and does not silently replace provenance.
- `JM_HIGH_RISK_CLAIM_CITATION_LOCATOR.csv` records exact candidate locations,
  support relationship, limitations, reviewer roles and fail-closed gates.

Allowed P0 resolution classes are `TRUE_IDENTITY_CONFLICT`,
`METADATA_FORMAT_DIFFERENCE`, `TITLE_VARIANT`, `AUTHOR_VARIANT`,
`YEAR_VARIANT`, `DUPLICATE_CANDIDATE`, `FALSE_POSITIVE`, and `UNRESOLVED`.
Allowed final states are `RESOLVED_METADATA_ONLY`,
`RESOLVED_FALSE_POSITIVE`, `PENDING_HUMAN_CONFIRMATION`, and
`BLOCKED_INSUFFICIENT_PROVENANCE`.

Allowed P1 verification states are `VERIFIED`, `PARTIALLY_VERIFIED`,
`CONFLICT_FOUND`, `NOT_FOUND`, `ACCESS_BLOCKED`, and
`HUMAN_CONFIRMATION_REQUIRED`. Verification of an organization root does not
verify a versioned document, exact clause, scientific claim or current rule.

Allowed citation support relationships are `DIRECT_CANDIDATE_SUPPORT`,
`PARTIAL_CANDIDATE_SUPPORT`, `CONTEXT_ONLY`, `LIMITATION_ONLY`,
`CONTRADICTORY_CANDIDATE`, `NO_SUPPORT_LOCATED`, and `SOURCE_UNAVAILABLE`.
Allowed locator states are `EXACT_LOCATION_FOUND_PENDING_HUMAN_REVIEW`,
`DOCUMENT_LEVEL_ONLY`, `SOURCE_MAPPING_REQUIRED`, `FULL_TEXT_REQUIRED`,
`METHOD_BLOCKED`, and `OUT_OF_SCOPE_OR_LOCKED`.

Exact location, official hosting, source identity, or a blank human-review pack
cannot create scientific, safety, medical, referee, rule, threshold,
prescription, production, or capability approval. Topic similarity is never
support. Safety claims remain locked until all applicable evidence and human
review gates pass independently.

## JM-S0.7-A HPS Wave-1 bibliographic and review-readiness registries

JM-S0.7-A adds six additive registries while preserving every `HPS-SRC-*`
foreign key and all existing HPS values:

- `JM_HPS_40_BIBLIOGRAPHIC_VERIFICATION.csv` separates existing HPS metadata
  from candidate verified values and public bibliographic provenance.
- `JM_HPS_40_ACCESS_AND_REVIEW_READINESS.csv` records access, existing hashes,
  existing page/text-layer metadata, OCR/translation readiness and exact use
  limitations without copying or OCR-processing HPS files.
- `JM_HPS_WAVE1_SELECTION.csv` limits Wave 1 to 12 records and retains
  `PENDING_JM_SPECIFIC_HUMAN_EVIDENCE_REVIEW` for every row.
- `JM_HPS_WAVE1_TRANSFERABILITY_REGISTER.csv` records bounded questions and
  external-validity gaps; transferability is never treated as established.
- `JM_HPS_WAVE1_EVIDENCE_EXTRACTION_QUEUE.csv` is a blank qualified-human
  extraction queue. Scientific, applicability, reviewer, date and decision
  fields remain empty until actual review.
- `JM_HPS_WAVE1_DOMAIN_GAP_UPDATE.csv` records candidate/review readiness only.

Allowed bibliographic states are `VERIFIED`, `PARTIALLY_VERIFIED`,
`IDENTITY_CONFLICT`, `NOT_FOUND`, `ACCESS_BLOCKED`,
`RETRACTION_OR_CORRECTION_CHECK_REQUIRED`, and
`HUMAN_CONFIRMATION_REQUIRED`. Existing values are immutable observations;
candidate values are additive.

Allowed access states are `FULL_TEXT_LOCAL_HPS`, `FULL_TEXT_PUBLIC`,
`ABSTRACT_ONLY`, `METADATA_ONLY`, `ACCESS_BLOCKED`, and
`FILE_IDENTITY_UNVERIFIED`. Access never establishes source identity, evidence
quality, Judo applicability, claim support or review completion.

Allowed transfer directness is `DIRECT_JUDO`, `JUDO_ADJACENT`,
`GENERAL_COMBAT_SPORT`, `GENERAL_ATHLETE`, `GENERAL_POPULATION`, or `UNCLEAR`.
Transfer gates are only `LOCKED` or `REVIEW_REQUIRED`.

Domain coverage terms are limited to `CANDIDATE_COVERAGE_ONLY`,
`PARTIAL_REVIEW_READINESS`, `DIRECT_JUDO_GAP`, `EVIDENCE_CLASS_GAP`,
`FULL_TEXT_GAP`, and `HUMAN_REVIEW_GAP`. They cannot mean evidence sufficiency
or approval. Selection, bibliography, public access and blank forms do not
create evidence transfer, scientific/medical approval, prescription, dosage,
threshold/rule eligibility, production eligibility or capability activation.

## JM-S0.7-A2 Wave-1 quality and stronger-evidence intake registries

JM-S0.7-A2 preserves the historical Wave-1 selection and adds six versioned,
additive registries:

- `JM_HPS_WAVE1_QUALITY_DISPOSITION.csv` reconciles all 12 historical rows to
  the authorized keep, supporting, defer, or replace governance states.
- `JM_HPS_WAVE1_CORE_V2.csv` starts with exactly three core records and uses
  only `REVIEW_REQUIRED` or `LOCKED_FULL_TEXT_REQUIRED` gates.
- `JM_HPS_0254_FULL_TEXT_ACCESS_CHECK.csv` separates the exact DOI/PMID access
  result from related alternate-journal manuscripts; an alternate version
  cannot silently satisfy an exact-source full-text gate.
- `JM_HPS_EXTERNAL_0265_0272_INTAKE_READINESS.csv` records additive public
  bibliography, access, HPS membership, identity conflicts, transfer limits,
  and reviewer-role requirements without modifying HPS.
- `JM_HPS_WAVE1_REPLACEMENT_CANDIDATES.csv` limits potential replacements to
  four and requires `PENDING_FORMAL_INTAKE_AND_JM_HUMAN_REVIEW` for every row.
- `JM_HPS_WAVE1_V2_HUMAN_REVIEW_READINESS.csv` separates `CORE_READY`,
  `CORE_FULL_TEXT_BLOCKED`, `SUPPORTING_ONLY`,
  `REPLACEMENT_PENDING_INTAKE`, and `DEFERRED` states.

Quality disposition and review readiness are governance states, not evidence
quality conclusions or scientific approval. Core V2 is limited to five records
and supporting is limited to five. Identity conflict, missing exact full text,
incomplete HPS provenance, or incomplete formal intake must fail closed.

## JM-S0.7-A3 replacement formal-intake and Core V3 readiness registries

JM-S0.7-A3 adds seven provenance-preserving CSV registries and one blank
bilingual human-review packet:

- `JM_HPS_REPLACEMENT_BIBLIOGRAPHIC_VERIFICATION.csv` records additive exact
  bibliographic verification without overwriting HPS values.
- `JM_HPS_REPLACEMENT_FULL_TEXT_ACCESS.csv` separates public, paywalled and
  blocked access from actual acquisition.
- `JM_HPS_REPLACEMENT_INTAKE_MANIFEST.csv`,
  `JM_HPS_REPLACEMENT_PROVENANCE.csv` and
  `JM_HPS_REPLACEMENT_DUPLICATE_CHECK.csv` bind acquired exact files to source
  URL, version, size, SHA-256 and duplicate-control evidence.
- `JM_HPS_0268_IDENTITY_CONFLICT_REPORT.csv` contains the HPS metadata conflict
  without changing HPS or admitting the source to Wave 1.
- `JM_HPS_WAVE1_CORE_V3_READINESS.csv` preserves existing and replacement
  candidates while enforcing a future maximum-five core.

Allowed bibliographic states are `VERIFIED_EXACT_MATCH`,
`PARTIALLY_VERIFIED`, `IDENTITY_CONFLICT`,
`CORRECTION_OR_RETRACTION_REVIEW_REQUIRED`, `NOT_FOUND`, and
`ACCESS_BLOCKED`.

Allowed full-text access outcomes are `PUBLISHER_FULL_TEXT_PUBLIC`,
`PMC_FULL_TEXT_PUBLIC`, `INSTITUTIONAL_REPOSITORY_PUBLIC`,
`AUTHOR_ACCEPTED_MANUSCRIPT_PUBLIC`, `ABSTRACT_ONLY`, `PAYWALLED`,
`ACCESS_BLOCKED`, and `IDENTITY_MISMATCH`. Public access does not by itself
grant a reuse license; license and version evidence must be recorded
separately. A failed or non-PDF response cannot become an intake file.

Allowed duplicate states are `UNIQUE_HASH`, `EXACT_HPS_DUPLICATE`,
`EXACT_JM_DUPLICATE`, `DUPLICATE_HASH_REVIEW_REQUIRED`, and
`SHA_NOT_AVAILABLE_SOURCE_NOT_ACQUIRED`.

Allowed HPS conflict outcomes are `SAME_SOURCE_METADATA_CONFLICT`,
`DIFFERENT_SOURCE_FALSE_MATCH`, `IDENTIFIER_CONFLICT`,
`TITLE_OR_AUTHOR_CONFLICT`, and `UNRESOLVED_HUMAN_REVIEW_REQUIRED`. A conflict
record requires HPS human remediation and cannot authorize a Judo Mind
overwrite.

Allowed Core V3 readiness states are `CORE_READY_FOR_HUMAN_REVIEW`,
`CORE_FULL_TEXT_REQUIRED`, `REPLACEMENT_READY_FOR_HUMAN_REVIEW`,
`REPLACEMENT_FULL_TEXT_REQUIRED`, and `REPLACEMENT_IDENTITY_BLOCKED`.
Readiness, ranking, lawful access, provenance and a blank human-review form do
not create source approval, evidence transfer, scientific or medical approval,
Judo applicability, prescription, threshold/rule eligibility, production
eligibility or capability activation.

## JM-S0.7-A4 full-text disposition and reviewer-assignment readiness

JM-S0.7-A4 adds five additive registries without modifying the historical
Wave-1, Core V2, Core V3 readiness, HPS, or existing reviewer records:

- `JM_HPS_CORE_V3_FULL_TEXT_GAP_DISPOSITION.csv` distinguishes an exact public
  document, accepted manuscript, sibling publication, abstract-only record,
  paywall, rate limit, access block, or identity mismatch. A sibling DOI cannot
  satisfy an exact-source gate.
- `JM_HPS_CORE_V3_ACQUIRED_DOCUMENT_VALIDATION.csv` records document identity,
  version, SHA-256, structural readability, text-layer availability, and
  corruption checks without extracting scientific findings.
- `JM_HPS_CORE_V3_REVIEWER_REQUIREMENTS.csv` declares source-specific required
  reviewer-role combinations and prohibited decisions.
- `JM_HPS_CORE_V3_REVIEWER_VACANCIES.csv` contains one unassigned slot per
  required or optional role. Until explicit nomination, every slot is
  `UNASSIGNED_PENDING_USER_NOMINATION` and all personal, COI, assignment-date,
  and review-status fields remain blank.
- `JM_HPS_CORE_V3_ASSIGNMENT_READINESS.csv` uses only
  `READY_PENDING_REVIEWER_NOMINATION`, `FULL_TEXT_GAP`,
  `MEDICAL_REVIEWER_GAP`, `METHODS_REVIEWER_GAP`,
  `JUDO_TRANSFERABILITY_REVIEWER_GAP`, or `ACCESS_BLOCKED`.

Separate source-specific bilingual forms may pre-record verified bibliographic
identity and a candidate access/version for orientation. The actually reviewed
version, all scientific content, reviewer identity, COI, date, decision, and
attestation must remain blank until a qualified human completes the review.
Review-form decisions are evidence-synthesis dispositions only and never equal
scientific, medical, safety, rule, threshold, production, or capability
approval.

## JM-S0.7-A5 Core V4 disposition and reviewer-nomination readiness

JM-S0.7-A5 adds three governance registries without replacing the historical
Wave-1, Core V2, Core V3, A4, HPS, or reviewer records:

- `JM_HPS_CORE_V4_DISPOSITION.csv` is the authoritative additive membership
  layer for the exactly-five active Core V4 roster. It preserves the preceding
  state of all seven adjudicated sources and records blocked reserve/access
  states without deleting history.
- `JM_QUALIFIED_REVIEWER_CANDIDATE_ROSTER.csv` records people and declared
  candidate roles. `reviewer_candidate_id` identifies a person and may repeat
  across additive role rows; the pair `(reviewer_candidate_id,
  candidate_role)` must be unique. Public-profile provenance is not independent
  credential verification.
- `JM_HPS_CORE_V4_REVIEWER_NOMINATION_MATRIX.csv` records one row per mandatory
  source-role slot. `nomination_record_id` is unique, source IDs resolve to the
  HPS Master Source Registry, and nonblank reviewer candidate IDs resolve to
  the candidate roster.

Allowed Core V4 membership is `YES` or `NO`. Exactly five rows may be `YES`.
Membership state `ACTIVE_CORE_V4_PENDING_QUALIFIED_HUMAN_REVIEW` means review
readiness only. Nonmember fail-closed states include
`BLOCKED_RESERVE_FULL_TEXT_REQUIRED` and
`ACCESS_BLOCKED_FULL_TEXT_REQUIRED_OUTSIDE_CORE_V4`.

Nomination must remain
`NOMINATED_PENDING_ACCEPTANCE_QUALIFICATION_COI_AND_ATTESTATION` until the
candidate personally accepts, role-specific qualification is independently
confirmed, COI and confidentiality declarations are completed, and a
source-specific attestation is signed. A nomination is never a formal
assignment. `SPORTS_MEDICINE_PHYSICIAN` must remain
`VACANT_QUALIFIED_PHYSICIAN_REQUIRED` unless a qualified physician is
independently confirmed. `METHODS_OR_EVIDENCE_REVIEWER` remains
`VACANT_OR_CANDIDATE_PENDING_SPECIFIC_QUALIFICATION_CONFIRMATION` while only a
profile-based candidate exists.

Core membership, nomination, identity matching, acceptance, qualification,
attestation, a completed review, or an evidence-synthesis disposition cannot
by itself create scientific/medical approval, Judo transferability, a
monitoring rule, threshold, prescription, production enablement, or capability
activation.

## Technique identity registry boundary (JM-DEC-033)

`docs/technique_registry/JM_CANONICAL_TECHNIQUE_IDENTITY_REGISTRY.csv` is the
authoritative 67-row product identity roster. Its required 23 columns are
defined by JM-S1.1-C and validated against the read-only Dart projection.

Allowed identity states are `VERIFIED_EXISTING_PROJECT_RECORD`,
`VERIFIED_OFFICIAL_SOURCE`, `NORMALIZED_PENDING_HUMAN_CONFIRMATION`,
`IDENTITY_CONFLICT`, and `UNRESOLVED`. Persian-name states are
`EXISTING_REVIEWED`, `EXISTING_UNREVIEWED`,
`TRANSLITERATION_PENDING_REVIEW`, and `NOT_AVAILABLE`.

This product roster is not a scientific source registry. Identity, display
order, classification, model, content, technical/scientific review,
media-rights, route and unlock states remain separate. Default unlock is
`LOCKED`; registry membership grants no capability or approval.

## JM-UM-GS-1 Uchi-mata Gold evidence/claim profiles

The canonical source inventory remains authoritative. The additive
`JM_UM_GOLD_CLAIM_REGISTRY_V1.csv` is a technique-specific scientific-claim
profile and does not replace `JM_CLAIM_INVENTORY.csv`, whose scope is existing
product-content claims.

Gold claim IDs use `UM-CLM-NNN`; each row resolves one `JM-SRC-NNNN` identity
and records population, reference context, method, event/phase, measurement,
result, uncertainty, external validity, permitted use, rights and review state.
All rows must remain scientifically unapproved, athlete-threshold-ineligible
and production-disabled until a separate exact gate.

`JM_UM_GOLD_EVIDENCE_MEASUREMENT_MATRIX_V1.csv`,
`JM_UM_GOLD_CAMERA_REQUIREMENTS_V1.csv` and
`JM_UM_GOLD_DATA_ACQUISITION_REGISTER_V1.csv` govern validation planning only.
They do not redefine canonical metrics, publish a user camera protocol, grant
data rights or activate capabilities. The interpretation-rule registry remains
the only future Gold rule profile and is intentionally empty.
