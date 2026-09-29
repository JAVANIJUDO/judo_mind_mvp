import unittest

from pydantic import ValidationError

from ai_engine.contracts.single_attempt_analysis_v2a import (
    AttackingLegSelection,
    SupportLegSide,
)


class AttackingLegSelectionTest(unittest.TestCase):

    def test_human_confirmed_left_attacking_leg_is_valid(self) -> None:
        selection = AttackingLegSelection(
            side=SupportLegSide.LEFT,
            confirmation_source="human-confirmed",
            reviewer_notes="Human-confirmed attacking leg for Run 01.",
        )

        self.assertEqual(selection.side.value, "left")
        self.assertEqual(
            selection.confirmation_source,
            "human-confirmed",
        )

    def test_automatic_attacking_leg_confirmation_is_rejected(self) -> None:
        with self.assertRaises(ValidationError):
            AttackingLegSelection.model_validate(
                {
                    "side": "left",
                    "confirmation_source": "automatic",
                }
            )


if __name__ == "__main__":
    unittest.main()
