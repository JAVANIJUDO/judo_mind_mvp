import 'package:flutter/material.dart';

import '../../core/theme/judo_design_tokens.dart';
import '../../core/theme/judo_typography.dart';
import '../../l10n/app_localizations.dart';
import 'athlete_profile_screen.dart';

/// A dedicated destination for the existing local/demo-only scientific
/// history. It reuses the same provider and fail-closed record presentation as
/// Athlete Profile and does not create progress scores or a second store.
class LocalAnalysisHistoryScreen extends StatelessWidget {
  const LocalAnalysisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: AppBar(title: Text(l10n.localAnalysisHistoryTitle)),
      body: ListView(
        key: const ValueKey('local-analysis-history-screen'),
        padding: const EdgeInsets.all(JudoSpacing.lg),
        children: [
          Text(
            l10n.localAnalysisHistoryDisclosure,
            key: const ValueKey('standalone-history-local-disclosure'),
            style: JudoTypography.bodySmall,
          ),
          const SizedBox(height: JudoSpacing.lg),
          const LocalAnalysisHistorySection(),
        ],
      ),
    );
  }
}
