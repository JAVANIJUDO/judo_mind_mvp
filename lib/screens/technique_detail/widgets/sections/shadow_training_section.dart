import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_training_content.dart';
import 'training_experience_shared.dart';

class ShadowTrainingSection extends StatelessWidget {
  const ShadowTrainingSection({super.key, required this.technique});

  final TechniqueModel technique;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final drills = technique.trainingContent.availableDrillsFor(
      TechniqueTrainingDrillKind.shadowTraining,
      languageCode,
    );
    if (drills.isEmpty) {
      return const TrainingExperienceUnavailable(
        kind: TechniqueTrainingDrillKind.shadowTraining,
      );
    }
    return Column(
      children: [
        for (final drill in drills) ...[
          ShadowTrainingDrillRenderer(drill: drill),
          const SizedBox(height: JudoSpacing.lg),
        ],
      ],
    );
  }
}

class ShadowTrainingDrillRenderer extends StatelessWidget {
  const ShadowTrainingDrillRenderer({super.key, required this.drill});

  final ResolvedTechniqueTrainingDrill drill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final configuration = drill.shadowConfiguration;
    if (configuration == null) {
      return const TrainingExperienceUnavailable(
        kind: TechniqueTrainingDrillKind.shadowTraining,
      );
    }
    return Semantics(
      label: '${l10n.shadowTrainingTitle}: ${drill.title}',
      child: JudoCard(
        key: const ValueKey<String>('shadow-training-primary-renderer'),
        borderColor: JudoColors.primary.withValues(alpha: 0.45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrainingDrillHeader(
              drill: drill,
              icon: Icons.directions_walk_rounded,
              accentColor: JudoColors.primary,
            ),
            const SizedBox(height: JudoSpacing.sm),
            Text(
              l10n.shadowPhaseSequenceLabel,
              style: JudoTypography.labelLarge,
            ),
            const SizedBox(height: JudoSpacing.sm),
            Wrap(
              spacing: JudoSpacing.sm,
              runSpacing: JudoSpacing.sm,
              children: configuration.phaseSequence
                  .map(
                    (phase) => Chip(
                      avatar: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: Text(phase),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: JudoSpacing.md),
            Container(
              key: const ValueKey<String>('shadow-movement-path-presentation'),
              width: double.infinity,
              padding: const EdgeInsets.all(JudoSpacing.md),
              decoration: BoxDecoration(
                color: JudoColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(JudoRadius.md),
              ),
              child: TrainingEvidenceRow(
                label: l10n.shadowMovementPathLabel,
                value: configuration.movementPathCues.join(' → '),
              ),
            ),
            TrainingEvidenceRow(
              label: l10n.shadowFrontSideLabel,
              value: [
                configuration.frontPresentationReferenceId,
                configuration.sidePresentationReferenceId,
              ].where((item) => item.isNotEmpty).join(' • '),
            ),
            TrainingEvidenceRow(
              label: l10n.shadowPaceLabel,
              value: configuration.paceModes.join(' • '),
            ),
            TrainingEvidenceRow(
              label: l10n.shadowMirrorGhostLabel,
              value: _capability(
                l10n,
                configuration.mirrorGhostPresentationAvailable,
              ),
            ),
            TrainingEvidenceRow(
              label: l10n.shadowRepetitionTrackingLabel,
              value: _capability(
                l10n,
                configuration.repetitionTrackingAvailable,
              ),
            ),
            TrainingEvidenceRow(
              label: l10n.shadowHistoryBoundaryLabel,
              value: _capability(l10n, configuration.historyRecordingAvailable),
            ),
            TrainingDrillEvidence(drill: drill),
          ],
        ),
      ),
    );
  }

  String _capability(AppLocalizations l10n, bool enabled) => enabled
      ? l10n.trainingCapabilityEnabled
      : l10n.trainingCapabilityDisabled;
}
