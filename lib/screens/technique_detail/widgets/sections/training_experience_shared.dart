import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_training_content.dart';

class TrainingExperienceUnavailable extends StatelessWidget {
  const TrainingExperienceUnavailable({super.key, required this.kind});

  final TechniqueTrainingDrillKind kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label:
          '${trainingKindTitle(l10n, kind)}. '
          '${l10n.trainingExperienceUnavailableDescription}',
      child: JudoCard(
        key: ValueKey<String>('training-unavailable-${kind.name}'),
        borderColor: JudoColors.warning.withValues(alpha: 0.42),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_outline_rounded, color: JudoColors.warning),
            const SizedBox(height: JudoSpacing.sm),
            Text(
              l10n.trainingExperienceUnavailable,
              style: JudoTypography.titleMedium,
            ),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              l10n.trainingExperienceUnavailableDescription,
              style: JudoTypography.bodyMedium.copyWith(
                color: JudoColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingDrillHeader extends StatelessWidget {
  const TrainingDrillHeader({
    super.key,
    required this.drill,
    required this.icon,
    required this.accentColor,
  });

  final ResolvedTechniqueTrainingDrill drill;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor),
            const SizedBox(width: JudoSpacing.sm),
            Expanded(
              child: Text(drill.title, style: JudoTypography.headingSmall),
            ),
          ],
        ),
        const SizedBox(height: JudoSpacing.md),
        TrainingEvidenceRow(
          label: l10n.trainingObjectiveLabel,
          value: drill.objective,
        ),
        TrainingEvidenceRow(
          label: l10n.trainingRelatedPhaseLabel,
          value: drill.relatedTechniquePhase,
        ),
        TrainingEvidenceRow(
          label: l10n.trainingAthleteLevelLabel,
          value: drill.athleteLevel,
        ),
      ],
    );
  }
}

class TrainingDrillEvidence extends StatelessWidget {
  const TrainingDrillEvidence({super.key, required this.drill});

  final ResolvedTechniqueTrainingDrill drill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prescription = <String>[
      if (drill.prescription.sets case final value?)
        l10n.trainingSetsValue(value),
      if (drill.prescription.repetitions case final value?)
        l10n.trainingRepetitionsValue(value),
      if (drill.prescription.durationSeconds case final value?)
        l10n.trainingDurationValue(value),
      if (drill.prescription.sessionsPerWeek case final value?)
        l10n.trainingSessionsValue(value),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrainingEvidenceRow(
          label: l10n.trainingEquipmentLabel,
          value: drill.equipment.join(' • '),
        ),
        TrainingEvidenceRow(
          label: l10n.trainingPrescriptionLabel,
          value: prescription.join(' • '),
        ),
        if (drill.prescription.restSeconds case final value?)
          TrainingEvidenceRow(
            label: l10n.trainingRestLabel,
            value: l10n.trainingRestValue(value),
          ),
        TrainingEvidenceRow(
          label: l10n.trainingMediaLabel,
          value: drill.mediaReferenceId,
        ),
        TrainingEvidenceRow(
          label: l10n.trainingSafetyLabel,
          value: drill.safetyGuidance.join(' • '),
          valueColor: JudoColors.warning,
        ),
        TrainingEvidenceRow(
          label: l10n.trainingSourceLabel,
          value: drill.sourceReference,
        ),
        TrainingEvidenceRow(
          label: l10n.trainingProvenanceLabel,
          value: drill.contentProvenance,
        ),
      ],
    );
  }
}

class TrainingEvidenceRow extends StatelessWidget {
  const TrainingEvidenceRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: JudoTypography.labelMedium.copyWith(
              color: JudoColors.textSecondary,
            ),
          ),
          const SizedBox(height: JudoSpacing.xs),
          Text(
            value,
            style: JudoTypography.bodyMedium.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

String trainingKindTitle(
  AppLocalizations l10n,
  TechniqueTrainingDrillKind kind,
) => switch (kind) {
  TechniqueTrainingDrillKind.shadowTraining => l10n.shadowTrainingTitle,
  TechniqueTrainingDrillKind.strengthConditioning =>
    l10n.strengthConditioningTitle,
  TechniqueTrainingDrillKind.resistanceBand => l10n.resistanceBandTrainingTitle,
};
