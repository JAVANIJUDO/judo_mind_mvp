import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_training_content.dart';
import 'training_experience_shared.dart';

class ConditioningSection extends StatelessWidget {
  const ConditioningSection({super.key, required this.technique});

  final TechniqueModel technique;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final drills = technique.trainingContent.availableDrillsFor(
      TechniqueTrainingDrillKind.strengthConditioning,
      languageCode,
    );
    if (drills.isEmpty) {
      return const TrainingExperienceUnavailable(
        kind: TechniqueTrainingDrillKind.strengthConditioning,
      );
    }
    return Column(
      children: [
        for (final drill in drills) ...[
          ConditioningDrillRenderer(drill: drill),
          const SizedBox(height: JudoSpacing.lg),
        ],
      ],
    );
  }
}

class ConditioningDrillRenderer extends StatelessWidget {
  const ConditioningDrillRenderer({super.key, required this.drill});

  final ResolvedTechniqueTrainingDrill drill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final configuration = drill.conditioningConfiguration;
    if (configuration == null) {
      return const TrainingExperienceUnavailable(
        kind: TechniqueTrainingDrillKind.strengthConditioning,
      );
    }
    return Semantics(
      label: '${l10n.strengthConditioningTitle}: ${drill.title}',
      child: JudoCard(
        key: const ValueKey<String>('conditioning-primary-renderer'),
        borderColor: JudoColors.success.withValues(alpha: 0.45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrainingDrillHeader(
              drill: drill,
              icon: Icons.fitness_center_rounded,
              accentColor: JudoColors.success,
            ),
            const SizedBox(height: JudoSpacing.sm),
            Container(
              key: const ValueKey<String>(
                'conditioning-movement-prescription-presentation',
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(JudoSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                  color: JudoColors.success.withValues(alpha: 0.38),
                ),
                borderRadius: BorderRadius.circular(JudoRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrainingEvidenceRow(
                    label: l10n.conditioningMovementPatternLabel,
                    value: configuration.targetMovementPattern,
                  ),
                  TrainingEvidenceRow(
                    label: l10n.conditioningCommonErrorLabel,
                    value: configuration.commonExecutionError,
                    valueColor: JudoColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: JudoSpacing.md),
            TrainingDrillEvidence(drill: drill),
          ],
        ),
      ),
    );
  }
}
