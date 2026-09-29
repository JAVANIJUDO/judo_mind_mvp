import 'package:flutter/material.dart';

import '../../core/theme/judo_design_tokens.dart';
import '../../core/widgets/judo_app_bar.dart';
import '../../l10n/app_localizations.dart';
import 'generic_technique_detail_screen.dart';
import 'technique_detail_route_policy.dart';
import 'technique_detail_screen.dart';
import 'widgets/content/technique_content_widgets.dart';

/// Converts a previously resolved route decision into its one permitted
/// destination. Locked decisions remain visibly fail-closed if a caller tries
/// to render one directly.
class TechniqueDetailRouteDestination extends StatelessWidget {
  const TechniqueDetailRouteDestination({
    super.key,
    required this.decision,
  });

  final TechniqueDetailRouteDecision decision;

  @override
  Widget build(BuildContext context) {
    return switch (decision.kind) {
      TechniqueDetailRouteKind.specializedUchiMata => TechniqueDetailScreen(
        technique: decision.technique!,
      ),
      TechniqueDetailRouteKind.genericReadOnly => GenericTechniqueDetailScreen(
        technique: decision.technique!,
      ),
      TechniqueDetailRouteKind.locked => _LockedTechniqueDetail(
        blockReason: decision.blockReason,
      ),
    };
  }
}

class _LockedTechniqueDetail extends StatelessWidget {
  const _LockedTechniqueDetail({required this.blockReason});

  final TechniqueDetailRouteBlockReason blockReason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      key: ValueKey<String>('technique-detail-locked-${blockReason.name}'),
      backgroundColor: JudoColors.background,
      appBar: const JudoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(JudoSpacing.lg),
        child: TechniqueContentNotice(
          message: l10n.techniqueSectionUnavailable,
          icon: Icons.lock_outline_rounded,
          accentColor: JudoColors.textSecondary,
        ),
      ),
    );
  }
}
