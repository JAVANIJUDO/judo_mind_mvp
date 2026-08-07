import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_visual_learning_model.dart';

import '../visual_learning/three_layer_visual_player.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Section: Technique Biomechanics
/// Reference Technique: Uchi Mata
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Displays biomechanics through synchronized visual layers:
///
/// Blue:
/// Footwork and body movement
///
/// Gold:
/// Grip and kinetic-chain control
///
/// Green:
/// Force direction, balance and center of gravity
class BiomechanicsSection extends StatelessWidget {
  final TechniqueModel technique;

  const BiomechanicsSection({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    final sequences = technique.visualSequencesByType(
      TechniqueVisualLearningType.biomechanics,
    );

    if (sequences.isEmpty) {
      return const _BiomechanicsEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visual Biomechanics',
          style: JudoTypography.headingSmall.copyWith(
            color: JudoColors.success,
          ),
        ),
        const SizedBox(height: JudoSpacing.sm),
        Text(
          'Activate or deactivate each animated layer to understand how movement, control and force work together.',
          style: JudoTypography.bodyMedium.copyWith(
            color: JudoColors.textSecondary,
          ),
        ),
        const SizedBox(height: JudoSpacing.lg),

        const _LayerGuide(),

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

class _LayerGuide extends StatelessWidget {
  const _LayerGuide();

  @override
  Widget build(BuildContext context) {
    return const JudoCard(
      padding: EdgeInsets.all(JudoSpacing.md),
      child: Column(
        children: [
          _LayerGuideItem(
            color: JudoColors.primary,
            title: 'Blue Layer',
            description: 'Footwork, entry and body movement',
          ),
          SizedBox(height: JudoSpacing.md),
          _LayerGuideItem(
            color: JudoColors.gold,
            title: 'Gold Layer',
            description: 'Grip, pulling action and kinetic-chain control',
          ),
          SizedBox(height: JudoSpacing.md),
          _LayerGuideItem(
            color: JudoColors.success,
            title: 'Green Layer',
            description: 'Force direction, balance and center of gravity',
          ),
        ],
      ),
    );
  }
}

class _LayerGuideItem extends StatelessWidget {
  final Color color;
  final String title;
  final String description;

  const _LayerGuideItem({
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(width: JudoSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: JudoTypography.titleSmall.copyWith(color: color),
              ),
              const SizedBox(height: JudoSpacing.xs),
              Text(
                description,
                style: JudoTypography.bodySmall.copyWith(
                  color: JudoColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BiomechanicsEmptyState extends StatelessWidget {
  const _BiomechanicsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const JudoCard(
      padding: EdgeInsets.all(JudoSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.animation_rounded,
            color: JudoColors.success,
            size: JudoIconSize.xl,
          ),
          SizedBox(height: JudoSpacing.md),
          Text(
            'Visual biomechanics is being prepared for this technique.',
            textAlign: TextAlign.center,
            style: JudoTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
