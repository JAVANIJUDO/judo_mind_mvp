import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/analysis_provenance.dart';
import '../../../../models/grounded_sensei.dart';
import '../../../../models/single_attempt_analysis_v2a.dart';

class GroundedSenseiExplanationCard extends StatelessWidget {
  const GroundedSenseiExplanationCard({super.key, required this.explanation});

  final GroundedSenseiExplanation explanation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedLocale = Localizations.localeOf(context).languageCode;
    if (explanation.locale != selectedLocale ||
        !explanation.isDeterministicLocal ||
        !explanation.hasExactFindingSet ||
        !explanation.binding.humanReviewed ||
        explanation.multiPersonEvidenceStatus != 'insufficient' ||
        explanation.multiPersonInteractionMetricsReportable) {
      return _UnavailableCard(message: l10n.groundedSenseiUnavailable);
    }

    return Material(
      key: const ValueKey('grounded-sensei-explanation'),
      color: JudoColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        side: BorderSide(color: JudoColors.gold.withValues(alpha: 0.55)),
      ),
      child: ExpansionTile(
        key: const ValueKey('grounded-sensei-expansion'),
        initiallyExpanded: false,
        maintainState: true,
        leading: const Icon(
          Icons.psychology_alt_outlined,
          color: JudoColors.gold,
        ),
        title: Text(l10n.groundedSenseiTitle, style: JudoTypography.titleLarge),
        subtitle: Text(
          l10n.groundedSenseiDisclosure,
          style: JudoTypography.bodySmall.copyWith(
            color: JudoColors.textSecondary,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          JudoSpacing.lg,
          0,
          JudoSpacing.lg,
          JudoSpacing.lg,
        ),
        children: [
          const Divider(),
          _LabeledText(
            label: l10n.groundedSenseiBindingLabel,
            value: l10n.groundedSenseiBindingValue(
              explanation.binding.analysisId,
              explanation.sourceSchemaVersion,
              explanation.binding.neutralTrackId,
            ),
          ),
          const SizedBox(height: JudoSpacing.sm),
          _LabeledText(
            label: l10n.groundedSenseiLocalVersionLabel,
            value: explanation.implementationVersion,
          ),
          const SizedBox(height: JudoSpacing.md),
          Container(
            key: const ValueKey('grounded-sensei-multi-person-boundary'),
            width: double.infinity,
            padding: const EdgeInsets.all(JudoSpacing.md),
            decoration: BoxDecoration(
              color: JudoColors.warning.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(JudoRadius.md),
            ),
            child: Text(
              l10n.groundedSenseiMultiPersonBoundary,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.warning,
              ),
            ),
          ),
          const SizedBox(height: JudoSpacing.md),
          ...explanation.findings.map(
            (finding) => Padding(
              padding: const EdgeInsets.only(bottom: JudoSpacing.md),
              child: _FindingCard(finding: finding),
            ),
          ),
          _SectionTitle(text: l10n.groundedSenseiSafetyLabel),
          if (explanation.safetyGuidance.isEmpty)
            Text(
              l10n.groundedSenseiSafetyUnavailable,
              key: const ValueKey('grounded-sensei-safety-unavailable'),
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.warning,
              ),
            )
          else
            ...explanation.safetyGuidance.map(
              (guidance) => _BulletText(text: guidance),
            ),
          const SizedBox(height: JudoSpacing.md),
          _SectionTitle(text: l10n.groundedSenseiLimitationsLabel),
          ...explanation.limitationCodes.map(
            (code) => _BulletText(text: _limitationText(l10n, code)),
          ),
        ],
      ),
    );
  }

  String _limitationText(AppLocalizations l10n, String code) {
    return switch (code) {
      'human_role_confirmation_required' =>
        l10n.groundedSenseiLimitationHumanRole,
      'human_support_leg_confirmation_required' =>
        l10n.groundedSenseiLimitationSupportLeg,
      'automatic_phase_detection_not_available' =>
        l10n.groundedSenseiLimitationPhase,
      'projected_single_camera_geometry' =>
        l10n.groundedSenseiLimitationProjected,
      'camera_perspective_affects_angles' =>
        l10n.groundedSenseiLimitationPerspective,
      'kinetics_not_available' => l10n.groundedSenseiLimitationKinetics,
      'descriptive_only' => l10n.groundedSenseiLimitationDescriptive,
      _ => l10n.groundedSenseiLimitationOther(code),
    };
  }
}

class _FindingCard extends StatelessWidget {
  const _FindingCard({required this.finding});

  final GroundedSenseiFinding finding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      key: ValueKey('grounded-sensei-finding-${finding.metricId}'),
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.surfaceVariant.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabeledText(
            label: l10n.groundedSenseiFindingLabel,
            value: _metricName(l10n),
          ),
          const SizedBox(height: JudoSpacing.sm),
          _LabeledText(
            label: l10n.groundedSenseiEvidenceLabel,
            value: _evidence(l10n),
          ),
          const SizedBox(height: JudoSpacing.sm),
          _LabeledText(label: l10n.groundedSenseiWhyLabel, value: _why(l10n)),
          const SizedBox(height: JudoSpacing.sm),
          _LabeledText(
            label: l10n.groundedSenseiOverlayLabel,
            value: finding.overlayAvailable
                ? l10n.groundedSenseiOverlayAvailable
                : l10n.groundedSenseiOverlayUnavailable,
          ),
          const SizedBox(height: JudoSpacing.sm),
          _LabeledText(
            label: l10n.metricConfidenceAvailabilityLabel,
            value: finding.confidenceAvailable
                ? l10n.groundedSenseiConfidenceAvailable
                : l10n.groundedSenseiConfidenceUnavailable,
          ),
          const SizedBox(height: JudoSpacing.sm),
          _LabeledText(
            label: l10n.metricProvenanceLabel,
            value:
                '${_provenance(l10n)} · ${finding.methodVersion} · ${finding.metricId}',
          ),
          const SizedBox(height: JudoSpacing.sm),
          _LabeledText(
            label: l10n.groundedSenseiNextActionLabel,
            value: l10n.groundedSenseiNoApprovedDrill,
          ),
        ],
      ),
    );
  }

  String _metricName(AppLocalizations l10n) {
    return switch (finding.metricId) {
      'UM-TIM-001' => l10n.groundedSenseiMetricDuration,
      'UM-ANG-001' => l10n.groundedSenseiMetricTrunk,
      'UM-ANG-002' => l10n.groundedSenseiMetricSupportKnee,
      'UM-ANG-003' => l10n.groundedSenseiMetricAttackingKnee,
      _ => finding.metricId,
    };
  }

  String _why(AppLocalizations l10n) {
    return switch (finding.metricId) {
      'UM-TIM-001' => l10n.groundedSenseiWhyDuration,
      'UM-ANG-001' => l10n.groundedSenseiWhyTrunk,
      'UM-ANG-002' => l10n.groundedSenseiWhySupportKnee,
      'UM-ANG-003' => l10n.groundedSenseiWhyAttackingKnee,
      _ => l10n.groundedSenseiLimitationDescriptive,
    };
  }

  String _evidence(AppLocalizations l10n) {
    if (finding.value == null) {
      return l10n.groundedSenseiEvidenceWithheld;
    }
    final value = finding.unit == 'seconds'
        ? finding.value!.toStringAsFixed(3)
        : finding.value!.toStringAsFixed(1);
    final unit = finding.unit == 'seconds'
        ? l10n.groundedSenseiSecondsUnit
        : l10n.groundedSenseiDegreesUnit;
    return l10n.groundedSenseiEvidenceValue(value, unit, _status(l10n));
  }

  String _status(AppLocalizations l10n) {
    return switch (finding.status) {
      SingleAttemptMetricStatus.reportable => l10n.metricStatusReportable,
      SingleAttemptMetricStatus.reviewRequired =>
        l10n.metricStatusReviewRequired,
      SingleAttemptMetricStatus.withheld => l10n.metricStatusWithheld,
      SingleAttemptMetricStatus.unknown => l10n.metricStatusWithheld,
    };
  }

  String _provenance(AppLocalizations l10n) {
    return switch (finding.provenance) {
      AnalysisProvenance.measured => l10n.groundedSenseiProvenanceMeasured,
      AnalysisProvenance.modelEstimated =>
        l10n.groundedSenseiProvenanceModelEstimated,
      _ => finding.provenance.apiValue,
    };
  }
}

class _LabeledText extends StatelessWidget {
  const _LabeledText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: JudoTypography.labelLarge),
        const SizedBox(height: JudoSpacing.xs),
        Text(value, style: JudoTypography.bodySmall),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: Text(text, style: JudoTypography.titleSmall),
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text, style: JudoTypography.bodySmall)),
        ],
      ),
    );
  }
}

class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('grounded-sensei-unavailable'),
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(JudoRadius.md),
      ),
      child: Text(
        message,
        style: JudoTypography.bodySmall.copyWith(color: JudoColors.warning),
      ),
    );
  }
}
