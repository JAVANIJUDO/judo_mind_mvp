"""Research-only scientific-foundation contracts.

Nothing in this package is imported by the production analysis pipeline.
"""

from .uchi_mata_gold_standard import (
    CameraMode,
    CameraRequirementRecord,
    CapabilityState,
    ClaimType,
    DataAcquisitionRecord,
    Dimensionality,
    EvidenceMeasurementRecord,
    EventSourceState,
    EvidenceStrengthStatus,
    EvidenceSourceType,
    GapStatus,
    InterpretationRuleDefinition,
    MeasurementDefinition,
    PermittedUse,
    Provenance,
    RightsGovernanceRecord,
    RightsStatus,
    UchiMataEventDefinition,
    UchiMataEvidenceRecord,
    UchiMataScientificClaim,
    UchiMataPhaseDefinition,
    ValidationGapRecord,
)

__all__ = [
    "CameraMode",
    "CameraRequirementRecord",
    "CapabilityState",
    "ClaimType",
    "DataAcquisitionRecord",
    "Dimensionality",
    "EvidenceMeasurementRecord",
    "EventSourceState",
    "EvidenceStrengthStatus",
    "EvidenceSourceType",
    "GapStatus",
    "InterpretationRuleDefinition",
    "MeasurementDefinition",
    "PermittedUse",
    "Provenance",
    "RightsGovernanceRecord",
    "RightsStatus",
    "UchiMataEventDefinition",
    "UchiMataEvidenceRecord",
    "UchiMataScientificClaim",
    "UchiMataPhaseDefinition",
    "ValidationGapRecord",
]
