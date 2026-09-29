"""Versioned, non-production contracts for the Uchi-mata Gold foundation.

These models describe evidence and future validation gates. They deliberately
do not execute analysis, detect events, infer roles, score technique, or grant
scientific/product approval.
"""

from __future__ import annotations

from enum import Enum
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, model_validator


FOUNDATION_CONTRACT_ID = "uchi-mata-gold-foundation-1.0.0"
FOUNDATION_SCHEMA_VERSION = "1.0.0"
TECHNIQUE_ID = "001"
TECHNIQUE_SLUG = "uchi-mata"
PRODUCTION_ENABLED = False

EVIDENCE_TO_COACHING_CHAIN = (
    "EVIDENCE",
    "MEASUREMENT_VALIDATION",
    "REFERENCE_APPLICABILITY",
    "APPROVED_TECHNICAL_INTERPRETATION",
    "COACHING",
)

DETAILED_SCIENTIFIC_CHAIN = (
    "VIDEO",
    "ATTEMPT",
    "PERSON_OR_ROLE",
    "POSE",
    "TRACKING",
    "OBSERVABLE_TECHNIQUE_EVENTS",
    "TECHNIQUE_PHASES",
    "MEASUREMENTS",
    "TORI_UKE_RELATIONSHIPS",
    "REFERENCE_APPLICABILITY",
    "VALIDATED_TECHNICAL_INTERPRETATION",
    "COACHING_FEEDBACK",
)


class _StringEnum(str, Enum):
    pass


class CapabilityState(_StringEnum):
    RESEARCH_ONLY = "RESEARCH_ONLY"
    ENGINEERING_VALIDATED = "ENGINEERING_VALIDATED"
    PRODUCT_DESCRIPTIVE = "PRODUCT_DESCRIPTIVE"
    TECHNICAL_INTERPRETATION_ALLOWED = "TECHNICAL_INTERPRETATION_ALLOWED"
    COACHING_RECOMMENDATION_ALLOWED = "COACHING_RECOMMENDATION_ALLOWED"
    LOCKED = "LOCKED"


class EventSourceState(_StringEnum):
    HUMAN_CONFIRMED = "HUMAN_CONFIRMED"
    RESEARCH_ANNOTATED = "RESEARCH_ANNOTATED"
    MODEL_INFERRED_UNVALIDATED = "MODEL_INFERRED_UNVALIDATED"
    MODEL_INFERRED_VALIDATED = "MODEL_INFERRED_VALIDATED"


class EvidenceSourceType(_StringEnum):
    OFFICIAL_JUDO_SOURCE = "OFFICIAL_JUDO_SOURCE"
    PEER_REVIEWED_BIOMECHANICAL_STUDY = (
        "PEER_REVIEWED_BIOMECHANICAL_STUDY"
    )
    ELITE_REFERENCE_EXECUTION = "ELITE_REFERENCE_EXECUTION"
    MULTI_ANGLE_REFERENCE = "MULTI_ANGLE_REFERENCE"
    VOLUMETRIC_REFERENCE = "VOLUMETRIC_REFERENCE"
    MARKERLESS_OR_MOCAP_VALIDATION = "MARKERLESS_OR_MOCAP_VALIDATION"
    INTERNAL_VALIDATION_EVIDENCE = "INTERNAL_VALIDATION_EVIDENCE"
    MEASUREMENT_METHOD_REFERENCE = "MEASUREMENT_METHOD_REFERENCE"


class EvidenceStrengthStatus(_StringEnum):
    OFFICIAL_REFERENCE_NOT_SCIENTIFIC_VALIDATION = (
        "OFFICIAL_REFERENCE_NOT_SCIENTIFIC_VALIDATION"
    )
    RESEARCH_REFERENCE_PENDING_REVIEW = "RESEARCH_REFERENCE_PENDING_REVIEW"
    METHOD_REFERENCE_NOT_DIRECT_UCHI_VALIDATION = (
        "METHOD_REFERENCE_NOT_DIRECT_UCHI_VALIDATION"
    )
    INTERNAL_VALIDATION_ONLY = "INTERNAL_VALIDATION_ONLY"
    UNVERIFIED_SOURCE_LEAD = "UNVERIFIED_SOURCE_LEAD"


class RightsStatus(_StringEnum):
    REFERENCE_ONLY = "REFERENCE_ONLY"
    RESEARCH_USE_REVIEW_REQUIRED = "RESEARCH_USE_REVIEW_REQUIRED"
    TRAINING_USE_PERMISSION_REQUIRED = "TRAINING_USE_PERMISSION_REQUIRED"
    LICENSED_FOR_TRAINING = "LICENSED_FOR_TRAINING"
    UNKNOWN_RIGHTS = "UNKNOWN_RIGHTS"


class ClaimType(_StringEnum):
    OFFICIAL_TECHNIQUE_DEFINITION = "OFFICIAL_TECHNIQUE_DEFINITION"
    EXPERT_TECHNICAL_OBSERVATION = "EXPERT_TECHNICAL_OBSERVATION"
    KINEMATIC_ASSOCIATION = "KINEMATIC_ASSOCIATION"
    KINEMATIC_GROUP_DIFFERENCE = "KINEMATIC_GROUP_DIFFERENCE"
    TEMPORAL_ASSOCIATION = "TEMPORAL_ASSOCIATION"
    TORI_UKE_RELATIONSHIP = "TORI_UKE_RELATIONSHIP"
    MEASUREMENT_VALIDITY = "MEASUREMENT_VALIDITY"
    MARKERLESS_FEASIBILITY = "MARKERLESS_FEASIBILITY"
    SPATIAL_REFERENCE = "SPATIAL_REFERENCE"
    VOLUMETRIC_REFERENCE = "VOLUMETRIC_REFERENCE"
    CAMERA_METHOD_REFERENCE = "CAMERA_METHOD_REFERENCE"
    DATA_AVAILABILITY = "DATA_AVAILABILITY"
    RIGHTS_INFORMATION = "RIGHTS_INFORMATION"
    LIMITATION = "LIMITATION"


class PermittedUse(_StringEnum):
    REFERENCE_ONLY = "REFERENCE_ONLY"
    RESEARCH_HYPOTHESIS = "RESEARCH_HYPOTHESIS"
    MEASUREMENT_DESIGN_SUPPORT = "MEASUREMENT_DESIGN_SUPPORT"
    VALIDATION_DESIGN_SUPPORT = "VALIDATION_DESIGN_SUPPORT"
    PRODUCT_DESCRIPTIVE_CANDIDATE = "PRODUCT_DESCRIPTIVE_CANDIDATE"
    TECHNICAL_INTERPRETATION_CANDIDATE = (
        "TECHNICAL_INTERPRETATION_CANDIDATE"
    )
    COACHING_RULE_CANDIDATE = "COACHING_RULE_CANDIDATE"
    LOCKED = "LOCKED"


class ExecutionContext(_StringEnum):
    DEMONSTRATION = "DEMONSTRATION"
    UCHIKOMI = "UCHIKOMI"
    NAGEKOMI = "NAGEKOMI"
    RANDORI = "RANDORI"
    SHIAI = "SHIAI"
    LABORATORY_SIMULATION = "LABORATORY_SIMULATION"
    OTHER = "OTHER"
    UNKNOWN = "UNKNOWN"


class CameraMode(_StringEnum):
    CONSUMER_SINGLE_CAMERA = "CONSUMER_SINGLE_CAMERA"
    PRO_MULTI_CAMERA = "PRO_MULTI_CAMERA"
    GOLD_VALIDATION_CAPTURE = "GOLD_VALIDATION_CAPTURE"


class Dimensionality(_StringEnum):
    TWO_D_PROJECTED = "2D_PROJECTED"
    CALIBRATED_2D = "CALIBRATED_2D"
    MULTIVIEW_3D = "MULTIVIEW_3D"
    MOCAP_3D = "MOCAP_3D"
    OTHER = "OTHER"


class Provenance(_StringEnum):
    MEASURED = "measured"
    RECONSTRUCTED = "reconstructed"
    MODEL_ESTIMATED = "model-estimated"
    AI_INFERRED = "AI-inferred"


class GapStatus(_StringEnum):
    GREEN = "GREEN"
    YELLOW = "YELLOW"
    RED = "RED"
    LOCKED = "LOCKED"


class EventAnnotationStatus(_StringEnum):
    PROVISIONAL = "PROVISIONAL"
    SOURCE_DEFINED = "SOURCE_DEFINED"
    ANNOTATION_READY = "ANNOTATION_READY"
    INTER_RATER_VALIDATED = "INTER_RATER_VALIDATED"
    MODEL_VALIDATION_READY = "MODEL_VALIDATION_READY"
    MODEL_VALIDATED = "MODEL_VALIDATED"
    PRODUCTION_ALLOWED = "PRODUCTION_ALLOWED"


class AnnotatorQualification(_StringEnum):
    JUDO_DOMAIN_EXPERT = "JUDO_DOMAIN_EXPERT"
    TRAINED_JUDO_ANNOTATOR = "TRAINED_JUDO_ANNOTATOR"
    BIOMECHANICS_REVIEWER = "BIOMECHANICS_REVIEWER"
    SCIENTIFIC_ADJUDICATOR = "SCIENTIFIC_ADJUDICATOR"


class AnnotationSource(_StringEnum):
    HUMAN_MANUAL = "HUMAN_MANUAL"
    AI_ASSISTED_EXPERIMENTAL = "AI_ASSISTED_EXPERIMENTAL"


class VisibilityState(_StringEnum):
    VISIBLE = "VISIBLE"
    PARTIALLY_VISIBLE = "PARTIALLY_VISIBLE"
    NOT_VISIBLE = "NOT_VISIBLE"
    NOT_ASSESSABLE = "NOT_ASSESSABLE"


class OcclusionState(_StringEnum):
    NONE_OBSERVED = "NONE_OBSERVED"
    PARTIAL = "PARTIAL"
    FULL = "FULL"
    UNKNOWN = "UNKNOWN"


class AdjudicationStatus(_StringEnum):
    AGREED = "AGREED"
    WITHIN_TOLERANCE = "WITHIN_TOLERANCE"
    DISAGREEMENT = "DISAGREEMENT"
    NOT_OBSERVABLE = "NOT_OBSERVABLE"
    ADJUDICATION_REQUIRED = "ADJUDICATION_REQUIRED"
    ADJUDICATED = "ADJUDICATED"
    EXCLUDED = "EXCLUDED"


class ReferenceType(_StringEnum):
    HUMAN_ANNOTATION = "HUMAN_ANNOTATION"
    CONSENSUS_REFERENCE = "CONSENSUS_REFERENCE"
    ADJUDICATED_REFERENCE = "ADJUDICATED_REFERENCE"
    INSTRUMENT_REFERENCE = "INSTRUMENT_REFERENCE"
    MODEL_PREDICTION = "MODEL_PREDICTION"


class ValidationLevel(_StringEnum):
    V0_COMPUTATIONAL_CORRECTNESS = "V0_COMPUTATIONAL_CORRECTNESS"
    V1_REPRODUCIBILITY = "V1_REPRODUCIBILITY"
    V2_INTERNAL_REFERENCE_CONSISTENCY = "V2_INTERNAL_REFERENCE_CONSISTENCY"
    V3_PUBLISHED_REFERENCE_CROSS_VALIDATION = (
        "V3_PUBLISHED_REFERENCE_CROSS_VALIDATION"
    )
    V4_EXTERNAL_DATASET_CRITERION_VALIDATION = (
        "V4_EXTERNAL_DATASET_CRITERION_VALIDATION"
    )
    V5_TARGETED_PROSPECTIVE_VALIDATION = "V5_TARGETED_PROSPECTIVE_VALIDATION"


class CameraSuitabilityState(_StringEnum):
    SUITABLE = "SUITABLE"
    CONDITIONALLY_SUITABLE = "CONDITIONALLY_SUITABLE"
    INSUFFICIENT = "INSUFFICIENT"
    NOT_ASSESSABLE = "NOT_ASSESSABLE"


class DatasetIntakeState(_StringEnum):
    DISCOVERED = "DISCOVERED"
    METADATA_VERIFIED = "METADATA_VERIFIED"
    ACCESS_REQUESTED = "ACCESS_REQUESTED"
    ACCESS_GRANTED = "ACCESS_GRANTED"
    RIGHTS_REVIEW_REQUIRED = "RIGHTS_REVIEW_REQUIRED"
    RESEARCH_APPROVED = "RESEARCH_APPROVED"
    VALIDATION_READY = "VALIDATION_READY"
    REJECTED = "REJECTED"


class AbstentionReason(_StringEnum):
    ROLE_UNCERTAIN = "ROLE_UNCERTAIN"
    TRACK_CONTINUITY_UNCERTAIN = "TRACK_CONTINUITY_UNCERTAIN"
    EVENT_NOT_OBSERVABLE = "EVENT_NOT_OBSERVABLE"
    EVENT_DISAGREEMENT = "EVENT_DISAGREEMENT"
    LANDMARK_OCCLUDED = "LANDMARK_OCCLUDED"
    CAMERA_UNSUITABLE_FOR_METRIC = "CAMERA_UNSUITABLE_FOR_METRIC"
    TIMING_UNCERTAIN = "TIMING_UNCERTAIN"
    REFERENCE_NOT_APPLICABLE = "REFERENCE_NOT_APPLICABLE"
    MEASUREMENT_NOT_VALIDATED = "MEASUREMENT_NOT_VALIDATED"
    OUT_OF_VALIDATED_DOMAIN = "OUT_OF_VALIDATED_DOMAIN"


class _FoundationModel(BaseModel):
    model_config = ConfigDict(extra="forbid", frozen=True)

    @model_validator(mode="before")
    @classmethod
    def normalize_canonical_csv_booleans(cls, value: object) -> object:
        if not isinstance(value, dict):
            return value
        return {
            key: False if item == "FALSE" else True if item == "TRUE" else item
            for key, item in value.items()
        }


class UchiMataEvidenceRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    evidence_id: str = Field(pattern=r"^UM-EV-\d{3}$")
    source_registry_id: str
    technique_id: Literal[TECHNIQUE_ID] = TECHNIQUE_ID
    technique_slug: Literal[TECHNIQUE_SLUG] = TECHNIQUE_SLUG
    source_type: EvidenceSourceType
    title: str = Field(min_length=1)
    authors_or_organization: str = Field(min_length=1)
    year: int | Literal["UNKNOWN", "NOT_REPORTED"]
    source_url_or_doi: str = Field(min_length=1)
    population: str = Field(min_length=1)
    sample_size: int | Literal["UNKNOWN", "NOT_REPORTED", "NOT_APPLICABLE"]
    skill_level: str = Field(min_length=1)
    sex_composition: str = Field(min_length=1)
    technique_variant_or_context: str = Field(min_length=1)
    capture_method: str = Field(min_length=1)
    camera_or_mocap_configuration: str = Field(min_length=1)
    sampling_frequency: str = Field(min_length=1)
    measured_variables: str = Field(min_length=1)
    event_or_phase_definitions: str = Field(min_length=1)
    major_findings: str = Field(min_length=1)
    limitations: str = Field(min_length=1)
    applicability_to_judo_mind: str = Field(min_length=1)
    evidence_strength_status: EvidenceStrengthStatus
    rights_status: RightsStatus
    notes: str = Field(min_length=1)
    scientifically_approved: Literal[False] = False
    production_permission: Literal[False] = False


class UchiMataScientificClaim(_FoundationModel):
    """Source-bound research claim; never an activated athlete rule."""

    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    claim_id: str = Field(pattern=r"^UM-CLM-\d{3}$")
    source_id: str = Field(pattern=r"^JM-SRC-\d{4}$")
    technique_id: Literal[TECHNIQUE_ID] = TECHNIQUE_ID
    claim_type: ClaimType
    claim_text_normalized: str = Field(min_length=1)
    population: str = Field(min_length=1)
    sample_size: int | Literal["UNKNOWN", "NOT_REPORTED", "NOT_APPLICABLE"]
    skill_level: str = Field(min_length=1)
    sex_context: str = Field(min_length=1)
    laterality: str = Field(min_length=1)
    technique_variant: str = Field(min_length=1)
    grip_context: str = Field(min_length=1)
    uke_context: str = Field(min_length=1)
    body_size_or_weight_class_context: str = Field(min_length=1)
    execution_context: ExecutionContext
    resistance_context: str = Field(min_length=1)
    camera_view_context: str = Field(min_length=1)
    capture_method: str = Field(min_length=1)
    camera_configuration: str = Field(min_length=1)
    sampling_frequency: str = Field(min_length=1)
    event_id: str = Field(min_length=1)
    phase_definition_id: str = Field(min_length=1)
    measurement_family: str = Field(min_length=1)
    metric_id: str = Field(min_length=1)
    reported_result: str = Field(min_length=1)
    statistical_context: str = Field(min_length=1)
    effect_direction: str = Field(min_length=1)
    uncertainty: str = Field(min_length=1)
    study_limitation: str = Field(min_length=1)
    external_validity_limitation: str = Field(min_length=1)
    judo_mind_applicability: str = Field(min_length=1)
    permitted_use: PermittedUse
    validation_requirement: str = Field(min_length=1)
    rights_status: RightsStatus
    review_status: str = Field(min_length=1)
    review_notes: str = Field(min_length=1)
    contract_version: str = Field(min_length=1)
    scientifically_approved: Literal[False] = False
    athlete_threshold_eligible: Literal[False] = False
    production_enabled: Literal[False] = False


class EvidenceMeasurementRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    matrix_id: str = Field(pattern=r"^UM-EMM-\d{3}$")
    measurement_name: str = Field(min_length=1)
    scientific_evidence: str = Field(min_length=1)
    judo_specific_evidence: str = Field(min_length=1)
    measurement_method: str = Field(min_length=1)
    single_camera_feasibility: str = Field(min_length=1)
    multi_camera_feasibility: str = Field(min_length=1)
    current_jm_capability: str = Field(min_length=1)
    criterion_validity: str = Field(min_length=1)
    reference_population: str = Field(min_length=1)
    interpretation_support: str = Field(min_length=1)
    coaching_support: Literal["LOCKED"] = "LOCKED"
    camera_dependency: str = Field(min_length=1)
    occlusion_dependency: str = Field(min_length=1)
    current_gap: str = Field(min_length=1)
    status: GapStatus
    next_validation_action: str = Field(min_length=1)
    activation_evidence: str = Field(min_length=1)
    production_enabled: Literal[False] = False


class CameraRequirementRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    camera_requirement_id: str = Field(pattern=r"^UM-CAM-\d{3}$")
    matrix_id: str = Field(pattern=r"^UM-EMM-\d{3}$")
    measurement_name: str = Field(min_length=1)
    minimum_visible_landmarks: str = Field(min_length=1)
    preferred_view: str = Field(min_length=1)
    poor_or_prohibited_view: str = Field(min_length=1)
    occlusion_sensitivity: str = Field(min_length=1)
    minimum_timing_quality: str = Field(min_length=1)
    minimum_resolution: str = Field(min_length=1)
    minimum_frame_rate: str = Field(min_length=1)
    camera_motion_tolerance: str = Field(min_length=1)
    calibration_requirement: str = Field(min_length=1)
    synchronization_requirement: str = Field(min_length=1)
    scale_requirement: str = Field(min_length=1)
    consumer_single_camera_eligibility: str = Field(min_length=1)
    pro_multi_camera_eligibility: str = Field(min_length=1)
    gold_validation_capture_eligibility: str = Field(min_length=1)
    dimensionality_boundary: str = Field(min_length=1)
    evidence_basis: str = Field(min_length=1)
    protocol_status: Literal["FOUNDATION_ONLY_NOT_USER_PROTOCOL"] = (
        "FOUNDATION_ONLY_NOT_USER_PROTOCOL"
    )
    production_enabled: Literal[False] = False


class DataAcquisitionRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    acquisition_id: str = Field(pattern=r"^UM-DAQ-\d{3}$")
    source_id: str = Field(pattern=r"^JM-SRC-\d{4}$")
    raw_video_availability: str = Field(min_length=1)
    raw_marker_trajectories: str = Field(min_length=1)
    processed_trajectories: str = Field(min_length=1)
    event_annotations: str = Field(min_length=1)
    metadata: str = Field(min_length=1)
    supplementary_material: str = Field(min_length=1)
    public_access: str = Field(min_length=1)
    request_from_authors: str = Field(min_length=1)
    license_requirement: str = Field(min_length=1)
    commercial_use_status: str = Field(min_length=1)
    contact_route_if_published: str = Field(min_length=1)
    priority: str = Field(min_length=1)
    expected_validation_value: str = Field(min_length=1)
    acquisition_status: str = Field(min_length=1)
    dataset_intake_state: DatasetIntakeState
    research_approved: Literal[False] = False
    production_enabled: Literal[False] = False


class EventAnnotationDefinition(_FoundationModel):
    """Operational research definition for one observable event."""

    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    event_id: Literal["E0", "E1", "E2", "E3", "E4", "E5", "E6", "E7"]
    canonical_name: str = Field(min_length=1)
    operational_definition: str = Field(min_length=1)
    observable_visual_cue: str = Field(min_length=1)
    required_visible_body_regions: str = Field(min_length=1)
    primary_role: str = Field(min_length=1)
    secondary_role: str = Field(min_length=1)
    temporal_unit: str = Field(min_length=1)
    frame_selection_rule: str = Field(min_length=1)
    ambiguity_conditions: str = Field(min_length=1)
    occlusion_conditions: str = Field(min_length=1)
    not_observable_conditions: str = Field(min_length=1)
    source_references: str = Field(min_length=1)
    source_specific_definition: bool
    annotation_status: EventAnnotationStatus
    annotation_version: str = Field(min_length=1)
    notes: str = Field(min_length=1)
    automatic_detection_enabled: Literal[False] = False
    production_enabled: Literal[False] = False


class AnnotatorProfile(_FoundationModel):
    annotator_code: str = Field(min_length=1)
    qualification_category: AnnotatorQualification
    judo_experience_metadata: str = Field(min_length=1)
    coaching_referee_research_context: str = Field(min_length=1)
    training_protocol_version: str = Field(min_length=1)
    annotation_manual_version: str = Field(min_length=1)
    conflict_of_interest_notes: str = Field(min_length=1)
    unnecessary_personal_data_stored: Literal[False] = False


class AnnotationRecord(_FoundationModel):
    """One immutable human or separated experimental annotation record."""

    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    annotation_id: str = Field(pattern=r"^UM-ANN-[A-Z0-9-]+$")
    video_id: str = Field(min_length=1)
    video_hash: str = Field(pattern=r"^[a-fA-F0-9]{64}$")
    technique_id: Literal[TECHNIQUE_ID] = TECHNIQUE_ID
    attempt_id: str = Field(min_length=1)
    event_id: Literal["E0", "E1", "E2", "E3", "E4", "E5", "E6", "E7"]
    annotator_code: str = Field(min_length=1)
    frame_index: int | None = Field(default=None, ge=0)
    canonical_timestamp_ms: int | None = Field(default=None, ge=0)
    source_timing_mode: str = Field(min_length=1)
    role_context: str = Field(min_length=1)
    visibility_state: VisibilityState
    occlusion_state: OcclusionState
    confidence: float | None = Field(default=None, ge=0.0, le=1.0)
    ambiguity_reason: str | None = None
    annotation_source: AnnotationSource
    annotation_manual_version: str = Field(min_length=1)
    event_definition_version: str = Field(min_length=1)
    created_at: str = Field(min_length=1)
    superseded_by: str | None = None
    adjudication_status: AdjudicationStatus
    reference_type: Literal[ReferenceType.HUMAN_ANNOTATION] = (
        ReferenceType.HUMAN_ANNOTATION
    )
    production_ground_truth: Literal[False] = False

    @model_validator(mode="after")
    def require_position_for_observable_event(self) -> "AnnotationRecord":
        if self.visibility_state is VisibilityState.VISIBLE:
            if self.frame_index is None or self.canonical_timestamp_ms is None:
                raise ValueError(
                    "Visible event annotations require frame and canonical timestamp."
                )
        return self


class AdjudicationRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    adjudication_id: str = Field(pattern=r"^UM-ADJ-[A-Z0-9-]+$")
    event_id: Literal["E0", "E1", "E2", "E3", "E4", "E5", "E6", "E7"]
    original_annotation_ids: tuple[str, ...] = Field(min_length=2)
    disagreement_summary: str = Field(min_length=1)
    status: AdjudicationStatus
    adjudicator_code: str | None = None
    selected_frame_index: int | None = Field(default=None, ge=0)
    selected_timestamp_ms: int | None = Field(default=None, ge=0)
    decision_reason: str = Field(min_length=1)
    adjudication_version: str = Field(min_length=1)
    original_annotations_preserved: Literal[True] = True
    reference_type: Literal[ReferenceType.ADJUDICATED_REFERENCE] = (
        ReferenceType.ADJUDICATED_REFERENCE
    )


class MeasurementValidationRecord(_FoundationModel):
    """Validation design/result record; schema presence grants no activation."""

    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    validation_id: str = Field(pattern=r"^UM-VAL-\d{3}$")
    metric_id: str = Field(min_length=1)
    technique_id: Literal[TECHNIQUE_ID] = TECHNIQUE_ID
    jm_measurement_method: str = Field(min_length=1)
    reference_measurement_method: str = Field(min_length=1)
    reference_instrument: str = Field(min_length=1)
    reference_type: ReferenceType
    validation_level: ValidationLevel
    camera_mode: CameraMode
    view_context: str = Field(min_length=1)
    frame_rate: str = Field(min_length=1)
    resolution: str = Field(min_length=1)
    calibration_state: str = Field(min_length=1)
    synchronization_state: str = Field(min_length=1)
    sample_population: str = Field(min_length=1)
    sample_size: int | Literal["UNKNOWN", "NOT_ESTABLISHED"]
    execution_context: ExecutionContext
    variant_context: str = Field(min_length=1)
    grip_context: str = Field(min_length=1)
    uke_context: str = Field(min_length=1)
    occlusion_context: str = Field(min_length=1)
    error_metric: str = Field(min_length=1)
    error_result: str = Field(min_length=1)
    acceptance_threshold: Literal["NOT_ESTABLISHED"] = "NOT_ESTABLISHED"
    bias: str = Field(min_length=1)
    limits_of_agreement: str = Field(min_length=1)
    repeatability: str = Field(min_length=1)
    reproducibility: str = Field(min_length=1)
    criterion_validity_status: str = Field(min_length=1)
    external_validity_status: str = Field(min_length=1)
    known_failure_modes: str = Field(min_length=1)
    permitted_use_after_validation: str = Field(min_length=1)
    evidence_refs: str = Field(min_length=1)
    validation_version: str = Field(min_length=1)
    protocol_design_only: Literal[True] = True
    scientifically_approved: Literal[False] = False
    production_enabled: Literal[False] = False


class CameraValidationRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    camera_validation_id: str = Field(pattern=r"^UM-CVAL-\d{3}$")
    metric_id: str = Field(min_length=1)
    camera_mode: CameraMode
    camera_azimuth_or_view: str = Field(min_length=1)
    camera_elevation: str = Field(min_length=1)
    camera_distance: str = Field(min_length=1)
    field_of_view: str = Field(min_length=1)
    athlete_full_body_visibility: str = Field(min_length=1)
    tori_uke_visibility: str = Field(min_length=1)
    occlusion: str = Field(min_length=1)
    camera_movement: str = Field(min_length=1)
    zoom: str = Field(min_length=1)
    frame_rate: str = Field(min_length=1)
    resolution: str = Field(min_length=1)
    shutter_or_motion_blur: str = Field(min_length=1)
    lighting: str = Field(min_length=1)
    background_contrast: str = Field(min_length=1)
    judogi_contrast: str = Field(min_length=1)
    calibration: str = Field(min_length=1)
    synchronization: str = Field(min_length=1)
    scale_or_reference_object: str = Field(min_length=1)
    suitability_state: CameraSuitabilityState
    suitability_scope: str = Field(min_length=1)
    evidence_refs: str = Field(min_length=1)
    validation_status: Literal["NOT_ESTABLISHED"] = "NOT_ESTABLISHED"
    production_enabled: Literal[False] = False


class AbstentionRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    abstention_id: str = Field(pattern=r"^UM-ABS-\d{3}$")
    reason: AbstentionReason
    applies_to_layer: str = Field(min_length=1)
    trigger_condition: str = Field(min_length=1)
    downstream_effect: Literal["WITHHOLD"] = "WITHHOLD"
    user_message_semantics: str = Field(min_length=1)
    engineering_code_exposed_in_normal_ui: Literal[False] = False
    production_enabled: Literal[False] = False


class ScientificInterpretationGate(_FoundationModel):
    """Hard dependency lock; not an interpretation or coaching rule."""

    evidence_available: bool
    measurement_validated: bool
    reference_applicability_approved: bool
    approved_interpretation_rule_id: str | None = None
    authorized_structured_finding_id: str | None = None
    approved_coaching_rule_id: str | None = None
    llm_explanation_allowed: bool = False
    production_enabled: Literal[False] = False

    @model_validator(mode="after")
    def enforce_chain_without_bypass(self) -> "ScientificInterpretationGate":
        interpretation_requested = self.approved_interpretation_rule_id is not None
        finding_requested = self.authorized_structured_finding_id is not None
        coaching_requested = self.approved_coaching_rule_id is not None
        if interpretation_requested and not (
            self.evidence_available
            and self.measurement_validated
            and self.reference_applicability_approved
        ):
            raise ValueError("Interpretation cannot bypass upstream validation.")
        if finding_requested and not interpretation_requested:
            raise ValueError("A structured finding requires approved interpretation.")
        if coaching_requested and not finding_requested:
            raise ValueError("Coaching cannot bypass an authorized finding.")
        if self.llm_explanation_allowed and not finding_requested:
            raise ValueError("Sensei requires an authorized structured finding.")
        return self


class UchiMataEventDefinition(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    event_id: Literal["E0", "E1", "E2", "E3", "E4", "E5", "E6", "E7"]
    canonical_name: str = Field(min_length=1)
    definition: str = Field(min_length=1)
    provisional_research_level: bool
    allowed_source_states: tuple[EventSourceState, ...] = Field(min_length=1)
    capability_state: Literal[CapabilityState.RESEARCH_ONLY] = (
        CapabilityState.RESEARCH_ONLY
    )
    automatic_detection_enabled: Literal[False] = False
    production_ground_truth: Literal[False] = False


class UchiMataPhaseDefinition(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    phase_definition_id: str = Field(pattern=r"^UM-PHD-\d{3}$")
    source_evidence_id: str = Field(pattern=r"^UM-EV-\d{3}$")
    source_label: str = Field(min_length=1)
    contextual_judo_label: str = Field(min_length=1)
    start_event_id: str = Field(pattern=r"^E[0-7]$")
    end_event_id: str = Field(pattern=r"^E[0-7]$")
    mapping_status: Literal["SOURCE_OPERATIONAL_DEFINITION"] = (
        "SOURCE_OPERATIONAL_DEFINITION"
    )
    evidence_status: EvidenceStrengthStatus
    universal_definition: Literal[False] = False
    automatic_detection_enabled: Literal[False] = False
    capability_state: Literal[CapabilityState.RESEARCH_ONLY] = (
        CapabilityState.RESEARCH_ONLY
    )


class MeasurementDefinition(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    metric_id: str = Field(pattern=r"^UM-[A-Z0-9]+-\d{3}$")
    technique_id: Literal[TECHNIQUE_ID] = TECHNIQUE_ID
    name: str = Field(min_length=1)
    description: str = Field(min_length=1)
    body_or_relationship_target: str = Field(min_length=1)
    event_or_phase_dependency: str = Field(min_length=1)
    dimensionality: Dimensionality
    units: str = Field(min_length=1)
    calculation_definition: str = Field(min_length=1)
    required_landmarks: str = Field(min_length=1)
    required_roles: str = Field(min_length=1)
    required_tracking_continuity: str = Field(min_length=1)
    camera_requirements: str = Field(min_length=1)
    timing_requirements: str = Field(min_length=1)
    normalization: str = Field(min_length=1)
    provenance: Provenance
    validation_status: str = Field(min_length=1)
    known_error: str = Field(min_length=1)
    reference_availability: str = Field(min_length=1)
    interpretation_permission: CapabilityState
    coaching_permission: CapabilityState
    abstention_conditions: str = Field(min_length=1)
    evidence_links: str = Field(min_length=1)
    contract_version: str = Field(min_length=1)
    production_enabled: Literal[False] = False

    @model_validator(mode="after")
    def prohibit_implicit_permission(self) -> "MeasurementDefinition":
        if self.interpretation_permission is CapabilityState.COACHING_RECOMMENDATION_ALLOWED:
            raise ValueError("Interpretation permission cannot grant coaching permission.")
        if self.coaching_permission is not CapabilityState.LOCKED:
            raise ValueError("Gold foundation coaching permission must remain LOCKED.")
        return self


class ValidationGapRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    gap_id: str = Field(pattern=r"^UM-GAP-\d{3}$")
    governed_item: str = Field(min_length=1)
    scientific_evidence_available: str = Field(min_length=1)
    official_technical_support: str = Field(min_length=1)
    judo_mind_measurable: str = Field(min_length=1)
    measurement_validity_known: str = Field(min_length=1)
    reference_population_available: str = Field(min_length=1)
    interpretation_validated: Literal[False] = False
    coaching_implication_validated: Literal[False] = False
    rights_or_data_availability: str = Field(min_length=1)
    current_status: GapStatus
    missing_evidence: str = Field(min_length=1)
    required_next_validation_action: str = Field(min_length=1)
    production_enabled: Literal[False] = False


class InterpretationRuleDefinition(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    rule_id: str = Field(pattern=r"^UM-RULE-\d{3}$")
    technique_id: Literal[TECHNIQUE_ID] = TECHNIQUE_ID
    finding: str = Field(min_length=1)
    required_measurements: tuple[str, ...] = Field(min_length=1)
    required_events_or_phases: tuple[str, ...] = Field(min_length=1)
    applicable_reference_population: str = Field(min_length=1)
    evidence_references: tuple[str, ...] = Field(min_length=1)
    measurement_validity_requirement: str = Field(min_length=1)
    uncertainty_threshold: str = Field(min_length=1)
    allowed_interpretation: str = Field(min_length=1)
    allowed_coaching_implication: str = Field(min_length=1)
    abstention_conditions: str = Field(min_length=1)
    rule_version: str = Field(min_length=1)
    approval_status: Literal[CapabilityState.LOCKED] = CapabilityState.LOCKED
    authorized_structured_finding_required: Literal[True] = True
    raw_video_llm_judgment_allowed: Literal[False] = False
    production_enabled: Literal[False] = False


class RightsGovernanceRecord(_FoundationModel):
    schema_version: Literal[FOUNDATION_SCHEMA_VERSION] = FOUNDATION_SCHEMA_VERSION
    evidence_id: str = Field(pattern=r"^UM-EV-\d{3}$")
    rights_status: RightsStatus
    reference_linking_allowed: bool
    local_copy_authorized: bool
    research_processing_authorized: bool
    training_use_authorized: bool
    commercial_training_use_authorized: bool
    evidence_basis: str = Field(min_length=1)
    required_next_action: str = Field(min_length=1)

    @model_validator(mode="after")
    def validate_training_rights(self) -> "RightsGovernanceRecord":
        if self.rights_status is not RightsStatus.LICENSED_FOR_TRAINING:
            if self.training_use_authorized or self.commercial_training_use_authorized:
                raise ValueError("Training use requires LICENSED_FOR_TRAINING status.")
        return self
