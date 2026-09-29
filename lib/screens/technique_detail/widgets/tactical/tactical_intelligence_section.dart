import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';

/// Renders only approved, role-neutral educational content.
///
/// Dedicated tactical inference is deliberately withheld until a concrete
/// project source is approved.
class TacticalIntelligenceSection extends StatelessWidget {
  final TechniqueModel technique;

  const TacticalIntelligenceSection({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TechniqueContentNotice(
      key: const ValueKey<String>('tactical-content-incomplete'),
      message: l10n.tacticalContentIncomplete,
      icon: Icons.info_outline_rounded,
      accentColor: JudoColors.warning,
    );
  }
}
