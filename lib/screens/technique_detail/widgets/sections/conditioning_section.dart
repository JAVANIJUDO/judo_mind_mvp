import 'package:flutter/material.dart';

import '../../../../core/design_system/icons/judo_icons.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_visual_learning_model.dart';

import '../visual_learning/visual_learning_section.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Section: Technique-Specific Conditioning
/// Reference Technique: Uchi Mata
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Visual layers:
///
/// Blue:
/// Exercise movement and range of motion
///
/// Gold:
/// Posture, alignment and joint control
///
/// Green:
/// Active muscles, force and biomechanical purpose
class ConditioningSection extends StatelessWidget {
  final TechniqueModel technique;

  const ConditioningSection({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    return VisualLearningSection(
      technique: technique,
      learningType: TechniqueVisualLearningType.strengthConditioning,
      title: 'Uchi Mata Strength & Conditioning',
      description:
          'Explore technique-specific exercises through movement, posture and muscle-force visualization.',
      emptyIcon: JudoIcons.conditioning,
      accentColor: JudoColors.success,
    );
  }
}
