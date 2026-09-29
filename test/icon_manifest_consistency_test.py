import json
import re
import unittest
import xml.etree.ElementTree as ET
from collections import Counter
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
MANIFEST_PATH = REPOSITORY / "design/icon_system/judo_icon_manifest.v1.json"
REGISTRY_PATH = (
    REPOSITORY / "lib/core/design_system/icons/judo_icons.dart"
)
CANDIDATE_DIRECTORIES = {
    "batch_01": REPOSITORY / "design/icon_candidates/batch_01",
    "batch_02": REPOSITORY / "design/icon_candidates/batch_02",
}


class IconManifestConsistencyTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        cls.registry_source = REGISTRY_PATH.read_text(encoding="utf-8")
        cls.runtime_entries = dict(
            re.findall(
                r"static const IconData (\w+) = Icons\.(\w+);",
                cls.registry_source,
            )
        )
        cls.icons = cls.manifest["icons"]

    def test_runtime_ids_and_mappings_match_exactly(self) -> None:
        manifest_entries = {
            item["id"]: item["runtimeMapping"].removeprefix("Icons.")
            for item in self.icons
        }
        self.assertEqual(51, len(self.runtime_entries))
        self.assertEqual(51, len(manifest_entries))
        self.assertEqual(self.runtime_entries, manifest_entries)

    def test_ids_and_subset_counts_are_evidenced(self) -> None:
        ids = [item["id"] for item in self.icons]
        self.assertEqual(len(ids), len(set(ids)))
        counts = Counter(item["subset"] for item in self.icons)
        self.assertEqual(self.manifest["subsetCounts"], dict(counts))
        self.assertEqual(
            {
                "Technique Intelligence": 15,
                "Visual Learning": 17,
                "Competition Intelligence": 4,
                "AI Intelligence": 3,
                "Performance": 4,
                "Monitoring": 4,
                "Community": 4,
            },
            dict(counts),
        )

    def test_candidate_batch_is_bounded_and_not_production(self) -> None:
        candidates = [
            item
            for item in self.icons
            if item["status"] == "candidate_review_required"
        ]
        self.assertGreaterEqual(len(candidates), 10)
        self.assertLessEqual(len(candidates), 12)
        self.assertEqual(self.manifest["candidateBatch01"]["count"], len(candidates))
        self.assertEqual(self.manifest["candidateBatch02"]["count"], len(candidates))
        self.assertFalse(self.manifest["candidateBatch01"]["includedInRuntimeAssets"])
        self.assertFalse(self.manifest["candidateBatch02"]["includedInRuntimeAssets"])
        self.assertEqual(0, self.manifest["productionApprovedCustomCount"])
        self.assertTrue(all(not item["productionApproved"] for item in self.icons))

        pubspec = (REPOSITORY / "pubspec.yaml").read_text(encoding="utf-8")
        self.assertNotIn("design/icon_candidates", pubspec)

        for item in candidates:
            path = REPOSITORY / item["candidateArtworkPath"]
            previous_path = REPOSITORY / item["previousCandidateArtworkPath"]
            self.assertEqual(item["id"], path.stem)
            self.assertTrue(path.is_file(), item["id"])
            self.assertTrue(previous_path.is_file(), item["id"])
            self.assertIn("batch_02", path.parts)
            self.assertIn("batch_01", previous_path.parts)
            root = ET.parse(path).getroot()
            self.assertTrue(root.tag.endswith("svg"), item["id"])
            self.assertEqual("0 0 24 24", root.attrib.get("viewBox"), item["id"])
            source = path.read_text(encoding="utf-8")
            self.assertIn("currentColor", source, item["id"])
            self.assertIn("<title>", source, item["id"])

        for directory in CANDIDATE_DIRECTORIES.values():
            source_files = {
                path.stem
                for path in directory.glob("*.svg")
                if path.name != "contact_sheet.svg"
            }
            self.assertEqual({item["id"] for item in candidates}, source_files)
            ET.parse(directory / "contact_sheet.svg")

    def test_unresolved_and_legacy_evidence_remain_explicit(self) -> None:
        target = self.manifest["target"]
        self.assertEqual(120, target["count"])
        self.assertEqual("approximate_historical_target", target["kind"])
        self.assertEqual(51, target["evidencedRuntimeIds"])
        self.assertEqual(69, target["unresolvedTargetPositions"])
        self.assertIsNone(target["unresolvedSemanticIds"])
        self.assertEqual(10, len(self.manifest["missingLegacyReferences"]))

    def test_rtl_metadata_is_valid(self) -> None:
        valid = {"none", "directional"}
        self.assertTrue(
            all(item["rtlMirroring"] in valid for item in self.icons)
        )
        directional = {
            item["id"]
            for item in self.icons
            if item["rtlMirroring"] == "directional"
        }
        self.assertEqual(set(), directional)


def direct_material_audit() -> tuple[int, int, int, list[str]]:
    pattern = re.compile(r"(?<![A-Za-z0-9_])Icons\.[A-Za-z0-9_]+")
    registry = 0
    bypass = 0
    bypass_files: list[str] = []
    for path in sorted((REPOSITORY / "lib").rglob("*.dart")):
        count = len(pattern.findall(path.read_text(encoding="utf-8")))
        if path == REGISTRY_PATH:
            registry += count
        elif count:
            bypass += count
            bypass_files.append(path.relative_to(REPOSITORY).as_posix())
    return registry + bypass, registry, bypass, bypass_files


if __name__ == "__main__":
    result = unittest.main(exit=False)
    total, registry, bypass, files = direct_material_audit()
    print(f"DIRECT_MATERIAL_TOTAL={total}")
    print(f"DIRECT_MATERIAL_REGISTRY={registry}")
    print(f"DIRECT_MATERIAL_BYPASS={bypass}")
    print(f"DIRECT_MATERIAL_BYPASS_FILES={len(files)}")
    for path in files:
        print(path)
    raise SystemExit(not result.result.wasSuccessful())
