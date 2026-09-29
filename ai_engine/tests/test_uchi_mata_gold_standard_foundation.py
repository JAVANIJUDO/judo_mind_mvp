from __future__ import annotations

import csv
import unittest
from pathlib import Path

from ai_engine.scientific_foundation.uchi_mata_gold_standard import (
    CapabilityState,
    EventSourceState,
    InterpretationRuleDefinition,
    MeasurementDefinition,
    RightsGovernanceRecord,
    RightsStatus,
    UchiMataEventDefinition,
    UchiMataEvidenceRecord,
    UchiMataPhaseDefinition,
    ValidationGapRecord,
)


ROOT = Path(__file__).resolve().parents[2]
FOUNDATION = ROOT / "docs" / "scientific_foundation"


def _rows(filename: str) -> list[dict[str, str]]:
    with (FOUNDATION / filename).open(encoding="utf-8", newline="") as handle:
        return [
            {key.lstrip("\ufeff"): value for key, value in row.items()}
            for row in csv.DictReader(handle)
        ]


class UchiMataGoldStandardFoundationTest(unittest.TestCase):
    def test_evidence_registry_is_versioned_complete_and_non_production(self) -> None:
        rows = _rows("JM_UM_GOLD_EVIDENCE_REGISTRY_V1.csv")
        self.assertEqual(16, len(rows))
        self.assertEqual({"001"}, {row["technique_id"] for row in rows})
        self.assertEqual({"uchi-mata"}, {row["technique_slug"] for row in rows})
        self.assertTrue(all(row["schema_version"] == "1.0.0" for row in rows))
        self.assertTrue(all(row["scientifically_approved"] == "FALSE" for row in rows))
        self.assertTrue(all(row["production_permission"] == "FALSE" for row in rows))
        required = {
            "evidence_id", "source_type", "title", "authors_or_organization",
            "year", "source_url_or_doi", "population", "sample_size",
            "skill_level", "sex_composition", "technique_variant_or_context",
            "capture_method", "camera_or_mocap_configuration",
            "sampling_frequency", "measured_variables",
            "event_or_phase_definitions", "major_findings", "limitations",
            "applicability_to_judo_mind", "evidence_strength_status",
            "rights_status", "notes",
        }
        self.assertTrue(all(all(row[field] for field in required) for row in rows))

    def test_event_ontology_is_exact_and_never_automatic_ground_truth(self) -> None:
        rows = _rows("JM_UM_GOLD_EVENT_ONTOLOGY_V1.csv")
        self.assertEqual([f"E{i}" for i in range(8)], [row["event_id"] for row in rows])
        provisional = {row["event_id"] for row in rows if row["provisional_research_level"] == "TRUE"}
        self.assertEqual({"E4", "E5"}, provisional)
        self.assertTrue(all(row["automatic_detection_enabled"] == "FALSE" for row in rows))
        self.assertTrue(all(row["production_ground_truth"] == "FALSE" for row in rows))
        allowed = set(rows[0]["allowed_source_states"].split(";"))
        self.assertEqual({state.value for state in EventSourceState}, allowed)

    def test_phase_definitions_are_sourced_and_not_universal(self) -> None:
        rows = _rows("JM_UM_GOLD_PHASE_DEFINITIONS_V1.csv")
        self.assertEqual(3, len(rows))
        self.assertEqual(
            {("E1", "E2"), ("E2", "E3"), ("E3", "E6")},
            {(row["start_event_id"], row["end_event_id"]) for row in rows},
        )
        self.assertTrue(all(row["universal_definition"] == "FALSE" for row in rows))
        self.assertTrue(all(row["automatic_detection_enabled"] == "FALSE" for row in rows))

    def test_measurement_profile_extends_existing_metric_ids_fail_closed(self) -> None:
        rows = _rows("JM_UM_GOLD_MEASUREMENT_PROFILE_V1.csv")
        canonical = _rows("JM_METRIC_AND_THRESHOLD_INVENTORY.csv")
        canonical_ids = {row["metric_or_threshold_id"] for row in canonical}
        self.assertEqual(15, len(rows))
        self.assertTrue({row["metric_id"] for row in rows}.issubset(canonical_ids))
        self.assertTrue(all(row["production_enabled"] == "FALSE" for row in rows))
        self.assertTrue(all(row["coaching_permission"] == "LOCKED" for row in rows))
        names = " ".join(row["name"] for row in rows).lower()
        self.assertNotIn("force", names)
        self.assertNotIn("torque", names)
        self.assertNotIn("power", names)

    def test_gap_matrix_has_no_green_or_activation(self) -> None:
        rows = _rows("JM_UM_GOLD_VALIDATION_GAP_MATRIX_V1.csv")
        self.assertGreaterEqual(len(rows), 10)
        self.assertNotIn("GREEN", {row["current_status"] for row in rows})
        self.assertTrue(all(row["interpretation_validated"] == "FALSE" for row in rows))
        self.assertTrue(all(row["coaching_implication_validated"] == "FALSE" for row in rows))
        self.assertTrue(all(row["production_enabled"] == "FALSE" for row in rows))

    def test_interpretation_rule_registry_is_intentionally_empty(self) -> None:
        self.assertEqual([], _rows("JM_UM_GOLD_INTERPRETATION_RULE_REGISTRY_V1.csv"))
        with self.assertRaises(ValueError):
            InterpretationRuleDefinition(
                rule_id="UM-RULE-001",
                finding="test only",
                required_measurements=("UM-ANG-001",),
                required_events_or_phases=("E4",),
                applicable_reference_population="NOT_REPORTED",
                evidence_references=("UM-EV-005",),
                measurement_validity_requirement="required",
                uncertainty_threshold="NOT_VALIDATED",
                allowed_interpretation="none",
                allowed_coaching_implication="none",
                abstention_conditions="always",
                rule_version="1.0.0",
                approval_status=CapabilityState.TECHNICAL_INTERPRETATION_ALLOWED,
            )

    def test_rights_registry_grants_no_training_use(self) -> None:
        rows = _rows("JM_UM_GOLD_RIGHTS_REGISTRY_V1.csv")
        self.assertEqual(16, len(rows))
        self.assertTrue(all(row["training_use_authorized"] == "FALSE" for row in rows))
        self.assertTrue(
            all(row["commercial_training_use_authorized"] == "FALSE" for row in rows)
        )
        with self.assertRaises(ValueError):
            RightsGovernanceRecord(
                evidence_id="UM-EV-001",
                rights_status=RightsStatus.REFERENCE_ONLY,
                reference_linking_allowed=True,
                local_copy_authorized=False,
                research_processing_authorized=False,
                training_use_authorized=True,
                commercial_training_use_authorized=False,
                evidence_basis="test",
                required_next_action="permission",
            )

    def test_every_seeded_row_validates_against_the_typed_contract(self) -> None:
        for row in _rows("JM_UM_GOLD_EVIDENCE_REGISTRY_V1.csv"):
            UchiMataEvidenceRecord.model_validate(row)
        for row in _rows("JM_UM_GOLD_EVENT_ONTOLOGY_V1.csv"):
            row["allowed_source_states"] = row["allowed_source_states"].split(";")
            row.pop("notes")
            UchiMataEventDefinition.model_validate(row)
        for row in _rows("JM_UM_GOLD_PHASE_DEFINITIONS_V1.csv"):
            row.pop("notes")
            UchiMataPhaseDefinition.model_validate(row)
        for row in _rows("JM_UM_GOLD_MEASUREMENT_PROFILE_V1.csv"):
            MeasurementDefinition.model_validate(row)
        for row in _rows("JM_UM_GOLD_VALIDATION_GAP_MATRIX_V1.csv"):
            ValidationGapRecord.model_validate(row)
        for row in _rows("JM_UM_GOLD_RIGHTS_REGISTRY_V1.csv"):
            RightsGovernanceRecord.model_validate(row)

    def test_d2_remains_active_and_unresolved(self) -> None:
        status = (ROOT / "docs" / "PROJECT_STATUS.md").read_text(encoding="utf-8")
        foundation = (FOUNDATION / "JM_UM_GOLD_STANDARD_FOUNDATION_V1.md").read_text(
            encoding="utf-8"
        )
        self.assertIn("D2 is not closed", foundation)
        self.assertIn("ACTIVE", status.split("## JM-C2.1-D2", 1)[1][:250])


if __name__ == "__main__":
    unittest.main()
