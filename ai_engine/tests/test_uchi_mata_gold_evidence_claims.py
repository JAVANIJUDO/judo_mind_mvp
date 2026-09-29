from __future__ import annotations

import csv
import unittest
from collections import Counter
from pathlib import Path

from ai_engine.scientific_foundation.uchi_mata_gold_standard import (
    CameraRequirementRecord,
    ClaimType,
    DataAcquisitionRecord,
    EvidenceMeasurementRecord,
    PermittedUse,
    UchiMataScientificClaim,
)


ROOT = Path(__file__).resolve().parents[2]
FOUNDATION = ROOT / "docs" / "scientific_foundation"


def _rows(filename: str) -> list[dict[str, str]]:
    with (FOUNDATION / filename).open(encoding="utf-8", newline="") as handle:
        return [
            {key.lstrip("\ufeff"): value for key, value in row.items()}
            for row in csv.DictReader(handle)
        ]


class UchiMataGoldEvidenceClaimsTest(unittest.TestCase):
    def test_canonical_sources_are_unique_and_formal_intake_is_resolvable(self) -> None:
        sources = _rows("JM_SOURCE_INVENTORY.csv")
        source_ids = [row["source_id"] for row in sources]
        self.assertEqual(len(source_ids), len(set(source_ids)))
        self.assertEqual(72, len(sources))
        self.assertEqual(
            {f"JM-SRC-{index:04d}" for index in range(63, 73)},
            set(source_ids[-10:]),
        )
        self.assertTrue(all(row["production_permission"] == "FALSE" for row in sources))

    def test_every_claim_is_source_bound_typed_and_non_production(self) -> None:
        source_ids = {row["source_id"] for row in _rows("JM_SOURCE_INVENTORY.csv")}
        claims = _rows("JM_UM_GOLD_CLAIM_REGISTRY_V1.csv")
        claim_ids = [row["claim_id"] for row in claims]
        self.assertEqual(22, len(claims))
        self.assertEqual(len(claim_ids), len(set(claim_ids)))
        self.assertTrue(all(row["source_id"] in source_ids for row in claims))
        self.assertTrue(all(row["source_id"] for row in claims))
        self.assertTrue(all(row["rights_status"] for row in claims))
        self.assertTrue(all(row["scientifically_approved"] == "FALSE" for row in claims))
        self.assertTrue(all(row["athlete_threshold_eligible"] == "FALSE" for row in claims))
        self.assertTrue(all(row["production_enabled"] == "FALSE" for row in claims))
        for row in claims:
            UchiMataScientificClaim.model_validate(row)

    def test_claim_contract_supports_all_required_types_and_permitted_uses(self) -> None:
        self.assertEqual(
            {
                "OFFICIAL_TECHNIQUE_DEFINITION",
                "EXPERT_TECHNICAL_OBSERVATION",
                "KINEMATIC_ASSOCIATION",
                "KINEMATIC_GROUP_DIFFERENCE",
                "TEMPORAL_ASSOCIATION",
                "TORI_UKE_RELATIONSHIP",
                "MEASUREMENT_VALIDITY",
                "MARKERLESS_FEASIBILITY",
                "SPATIAL_REFERENCE",
                "VOLUMETRIC_REFERENCE",
                "CAMERA_METHOD_REFERENCE",
                "DATA_AVAILABILITY",
                "RIGHTS_INFORMATION",
                "LIMITATION",
            },
            {item.value for item in ClaimType},
        )
        self.assertEqual(8, len(PermittedUse))

    def test_unknowns_are_explicit_and_accepted_without_fabrication(self) -> None:
        claims = _rows("JM_UM_GOLD_CLAIM_REGISTRY_V1.csv")
        self.assertTrue(any("UNKNOWN" in value for row in claims for value in row.values()))
        sample = dict(claims[0])
        sample["claim_id"] = "UM-CLM-999"
        sample["sample_size"] = "UNKNOWN"
        sample["laterality"] = "UNKNOWN"
        UchiMataScientificClaim.model_validate(sample)

    def test_evidence_measurement_matrix_is_complete_and_has_zero_green(self) -> None:
        rows = _rows("JM_UM_GOLD_EVIDENCE_MEASUREMENT_MATRIX_V1.csv")
        self.assertEqual(22, len(rows))
        self.assertEqual(22, len({row["matrix_id"] for row in rows}))
        self.assertEqual(
            Counter({"YELLOW": 12, "RED": 4, "LOCKED": 6}),
            Counter(row["status"] for row in rows),
        )
        self.assertTrue(all(row["activation_evidence"] == "NOT_AVAILABLE" for row in rows))
        self.assertTrue(all(row["coaching_support"] == "LOCKED" for row in rows))
        self.assertTrue(all(row["production_enabled"] == "FALSE" for row in rows))
        for row in rows:
            EvidenceMeasurementRecord.model_validate(row)

    def test_locked_physical_and_medical_claims_remain_locked(self) -> None:
        rows = {
            row["measurement_name"]: row
            for row in _rows("JM_UM_GOLD_EVIDENCE_MEASUREMENT_MATRIX_V1.csv")
        }
        for name in (
            "True 3D joint kinematics",
            "Force",
            "Torque",
            "Power",
            "Injury prediction",
        ):
            self.assertEqual("LOCKED", rows[name]["status"])

    def test_camera_foundation_covers_every_measurement_without_becoming_protocol(self) -> None:
        measurements = _rows("JM_UM_GOLD_EVIDENCE_MEASUREMENT_MATRIX_V1.csv")
        cameras = _rows("JM_UM_GOLD_CAMERA_REQUIREMENTS_V1.csv")
        self.assertEqual(22, len(cameras))
        self.assertEqual(
            {row["matrix_id"] for row in measurements},
            {row["matrix_id"] for row in cameras},
        )
        self.assertTrue(
            all(row["minimum_resolution"] == "NOT_ESTABLISHED" for row in cameras)
        )
        self.assertTrue(
            all(row["minimum_frame_rate"] == "NOT_ESTABLISHED" for row in cameras)
        )
        self.assertTrue(all(row["production_enabled"] == "FALSE" for row in cameras))
        for row in cameras:
            CameraRequirementRecord.model_validate(row)

    def test_acquisition_register_is_rights_gated_and_non_production(self) -> None:
        rows = _rows("JM_UM_GOLD_DATA_ACQUISITION_REGISTER_V1.csv")
        source_ids = {row["source_id"] for row in _rows("JM_SOURCE_INVENTORY.csv")}
        self.assertEqual(10, len(rows))
        self.assertTrue(all(row["source_id"] in source_ids for row in rows))
        self.assertTrue(all(row["license_requirement"] for row in rows))
        self.assertTrue(all(row["production_enabled"] == "FALSE" for row in rows))
        for row in rows:
            DataAcquisitionRecord.model_validate(row)

    def test_ono_volumetric_and_scientific_case_are_not_laundered_together(self) -> None:
        claims = _rows("JM_UM_GOLD_CLAIM_REGISTRY_V1.csv")
        ono_sources = {
            row["source_id"]
            for row in claims
            if row["claim_id"] in {"UM-CLM-005", "UM-CLM-014"}
        }
        self.assertEqual({"JM-SRC-0025", "JM-SRC-0066"}, ono_sources)
        evidence = {row["source_registry_id"] for row in _rows("JM_UM_GOLD_EVIDENCE_REGISTRY_V1.csv")}
        self.assertTrue({"JM-SRC-0025", "JM-SRC-0066"}.issubset(evidence))

    def test_markerless_evidence_cannot_promote_uchi_mata_measurement_validity(self) -> None:
        claims = _rows("JM_UM_GOLD_CLAIM_REGISTRY_V1.csv")
        markerless = [
            row for row in claims if row["source_id"] in {"JM-SRC-0070", "JM-SRC-0071", "JM-SRC-0072"}
        ]
        self.assertTrue(markerless)
        self.assertTrue(all(row["scientifically_approved"] == "FALSE" for row in markerless))
        self.assertTrue(all(row["athlete_threshold_eligible"] == "FALSE" for row in markerless))
        applicability = " ".join(row["judo_mind_applicability"] for row in markerless).lower()
        self.assertIn("cannot", applicability)

    def test_rules_remain_empty_and_d2_debt_remains_active(self) -> None:
        self.assertEqual([], _rows("JM_UM_GOLD_INTERPRETATION_RULE_REGISTRY_V1.csv"))
        status = (ROOT / "docs" / "PROJECT_STATUS.md").read_text(encoding="utf-8")
        foundation = (FOUNDATION / "JM_UM_GOLD_STANDARD_FOUNDATION_V1.md").read_text(
            encoding="utf-8"
        )
        self.assertIn("Status: `ACTIVE", status.split("## JM-C2.1-D2", 1)[1][:250])
        self.assertIn("MediaPipe VIDEO-mode lifecycle/reproducibility", foundation)
        self.assertIn("D2 is not closed", foundation)


if __name__ == "__main__":
    unittest.main()
