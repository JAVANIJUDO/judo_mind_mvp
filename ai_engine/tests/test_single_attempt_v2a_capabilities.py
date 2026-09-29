from ai_engine.contracts.single_attempt_analysis_v2a import (
    MultiPersonEvidenceStatus,
    SingleAttemptCapabilities,
)


def test_single_attempt_capabilities_default_multi_person_gate():
    capabilities = SingleAttemptCapabilities()

    assert (
        capabilities.multi_person_evidence_status
        == MultiPersonEvidenceStatus.INSUFFICIENT
    )
    assert capabilities.multi_person_interaction_metrics_reportable is False

    assert capabilities.human_confirmed_tori is True
    assert capabilities.human_confirmed_support_leg is True

    assert capabilities.automatic_tori_uke_identity is False
    assert capabilities.automatic_phase_detection is False
    assert capabilities.three_dimensional_reconstruction is False
    assert capabilities.force_torque_power is False
    assert capabilities.normative_coaching is False


def test_multi_person_evidence_status_values_are_explicit():
    assert MultiPersonEvidenceStatus.NOT_REQUIRED.value == "not_required"
    assert (
        MultiPersonEvidenceStatus.REVIEW_REQUIRED.value
        == "review_required"
    )
    assert MultiPersonEvidenceStatus.INSUFFICIENT.value == "insufficient"
