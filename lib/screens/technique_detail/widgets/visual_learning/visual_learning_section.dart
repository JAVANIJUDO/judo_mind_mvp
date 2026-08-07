import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_visual_learning_model.dart';

import 'three_layer_visual_player.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Reusable Visual Learning Section
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Used by:
/// - Technical execution
/// - Biomechanics
/// - Shadow training
/// - Strength and conditioning
/// - Mobility
class VisualLearningSection extends StatelessWidget {
  final TechniqueModel technique;

  final TechniqueVisualLearningType learningType;

  final String title;
  final String description;

  final IconData emptyIcon;
  final Color accentColor;

  const VisualLearningSection({
    super.key,
    required this.technique,
    required this.learningType,
    required this.title,
    required this.description,
    required this.emptyIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final sequences = technique.visualSequencesByType(learningType);

    if (sequences.isEmpty) {
      return _VisualLearningEmptyState(
        title: title,
        icon: emptyIcon,
        accentColor: accentColor,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: JudoTypography.headingSmall.copyWith(color: accentColor),
        ),
        const SizedBox(height: JudoSpacing.sm),
        Text(
          description,
          style: JudoTypography.bodyMedium.copyWith(
            color: JudoColors.textSecondary,
          ),
        ),
        const SizedBox(height: JudoSpacing.lg),
        const _VisualLayerSummary(),
        const SizedBox(height: JudoSpacing.xl),
        ...sequences.map(
          (sequence) => Padding(
            padding: const EdgeInsets.only(bottom: JudoSpacing.xl),
            child: ThreeLayerVisualPlayer(sequence: sequence),
          ),
        ),
      ],
    );
  }
}

class _VisualLayerSummary extends StatelessWidget {
  const _VisualLayerSummary();

  @override
  Widget build(BuildContext context) {
    return const JudoCard(
      padding: EdgeInsets.all(JudoSpacing.md),
      child: Wrap(
        spacing: JudoSpacing.lg,
        runSpacing: JudoSpacing.md,
        children: [
          _VisualLayerLabel(color: JudoColors.primary, label: 'Movement'),
          _VisualLayerLabel(color: JudoColors.gold, label: 'Control'),
          _VisualLayerLabel(color: JudoColors.success, label: 'Force'),
        ],
      ),
    );
  }
}

class _VisualLayerLabel extends StatelessWidget {
  final Color color;
  final String label;

  const _VisualLayerLabel({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: JudoSpacing.sm),
        Text(
          label,
          style: JudoTypography.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _VisualLearningEmptyState extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;

  const _VisualLearningEmptyState({
    required this.title,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return JudoCard(
      padding: const EdgeInsets.all(JudoSpacing.xl),
      child: Column(
        children: [
          Icon(icon, color: accentColor, size: JudoIconSize.xl),
          const SizedBox(height: JudoSpacing.md),
          Text(
            '$title is being prepared for this technique.',
            textAlign: TextAlign.center,
            style: JudoTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
