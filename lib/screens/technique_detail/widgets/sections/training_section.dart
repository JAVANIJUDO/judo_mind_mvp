import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';

/// Fail-closed entry for technique-specific training that has no approved
/// drill contract. Learning content remains owned by the learning sections.
class TrainingSection extends StatelessWidget {
  const TrainingSection({super.key, required this.technique});

  final TechniqueModel technique;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TechniqueContentNotice(
      key: const ValueKey<String>('technique-training-unavailable'),
      message: l10n.techniqueTrainingUnavailable,
      icon: Icons.lock_outline_rounded,
      accentColor: JudoColors.warning,
    );
  }
}
