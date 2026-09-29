import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_training_content.dart';
import 'training_experience_shared.dart';

class ResistanceBandTrainingSection extends StatelessWidget {
  const ResistanceBandTrainingSection({super.key, required this.technique});

  final TechniqueModel technique;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final drills = technique.trainingContent.availableDrillsFor(
      TechniqueTrainingDrillKind.resistanceBand,
      languageCode,
    );
    if (drills.isEmpty) {
      return const TrainingExperienceUnavailable(
        kind: TechniqueTrainingDrillKind.resistanceBand,
      );
    }
    return Column(
      children: [
        for (final drill in drills) ...[
          ResistanceBandDrillRenderer(drill: drill),
          const SizedBox(height: JudoSpacing.lg),
        ],
      ],
    );
  }
}

class ResistanceBandDrillRenderer extends StatelessWidget {
  const ResistanceBandDrillRenderer({super.key, required this.drill});

  final ResolvedTechniqueTrainingDrill drill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final configuration = drill.resistanceBandConfiguration;
    if (configuration == null) {
      return const TrainingExperienceUnavailable(
        kind: TechniqueTrainingDrillKind.resistanceBand,
      );
    }
    return Semantics(
      label: '${l10n.resistanceBandTrainingTitle}: ${drill.title}',
      child: JudoCard(
        key: const ValueKey<String>('resistance-band-primary-renderer'),
        borderColor: JudoColors.gold.withValues(alpha: 0.52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrainingDrillHeader(
              drill: drill,
              icon: Icons.linear_scale_rounded,
              accentColor: JudoColors.gold,
            ),
            const SizedBox(height: JudoSpacing.sm),
            Container(
              key: const ValueKey<String>('band-anchor-direction-presentation'),
              padding: const EdgeInsets.all(JudoSpacing.md),
              decoration: BoxDecoration(
                color: JudoColors.gold.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(JudoRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    children: [
                      Icon(Icons.anchor_rounded, color: JudoColors.gold),
                      SizedBox(height: JudoSpacing.sm),
                      Icon(Icons.trending_flat_rounded, color: JudoColors.gold),
                    ],
                  ),
                  const SizedBox(width: JudoSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TrainingEvidenceRow(
                          label: l10n.bandAnchorLabel,
                          value:
                              '${configuration.anchorLocation} • '
                              '${configuration.anchorHeight}',
                        ),
                        TrainingEvidenceRow(
                          label: l10n.bandDirectionLabel,
                          value: configuration.resistanceDirection,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: JudoSpacing.md),
            TrainingEvidenceRow(
              label: l10n.bandGripMappingLabel,
              value: configuration.gripMapping,
            ),
            TrainingEvidenceRow(
              label: l10n.bandRotationPathLabel,
              value: configuration.entryRotationPath,
            ),
            TrainingEvidenceRow(
              label: l10n.bandLegRolesLabel,
              value:
                  '${configuration.supportLegRole} • '
                  '${configuration.attackingLegRole}',
            ),
            TrainingEvidenceRow(
              label: l10n.bandSafeDistanceLabel,
              value: configuration.safeDistanceGuidance,
              valueColor: JudoColors.warning,
            ),
            if (configuration.resistanceLevel.isNotEmpty)
              TrainingEvidenceRow(
                label: l10n.bandResistanceLevelLabel,
                value: configuration.resistanceLevel,
              ),
            TrainingEvidenceRow(
              label: l10n.bandDangerWarningLabel,
              value: configuration.dangerousErrorWarning,
              valueColor: JudoColors.danger,
            ),
            TrainingDrillEvidence(drill: drill),
          ],
        ),
      ),
    );
  }
}
