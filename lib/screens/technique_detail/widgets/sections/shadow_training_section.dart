import 'package:flutter/material.dart';

import '../../../../core/design_system/icons/judo_icons.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/technique_visual_learning_model.dart';

import '../visual_learning/visual_learning_section.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Section: Shadow Training
/// Reference Technique: Uchi Mata
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Visual layers:
///
/// Blue:
/// Footwork, entry and attacking-leg movement
///
/// Gold:
/// Virtual grip and upper-body control
///
/// Green:
/// Balance, rhythm and center-of-gravity control
class ShadowTrainingSection extends StatelessWidget {
  final TechniqueModel technique;

  const ShadowTrainingSection({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    return VisualLearningSection(
      technique: technique,
      learningType: TechniqueVisualLearningType.shadowTraining,
      title: 'Visual Shadow Training',
      description:
          'Practise Uchi Mata without a partner by activating movement, virtual grip and balance layers individually or together.',
      emptyIcon: JudoIcons.shadowTraining,
      accentColor: JudoColors.primary,
    );
  }
}
