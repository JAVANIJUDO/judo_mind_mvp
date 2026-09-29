import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_badge.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';

class TechniqueSourcesSection extends StatelessWidget {
  final List<TechniqueSource> sources;

  const TechniqueSourcesSection({super.key, required this.sources});

  static bool isConcreteApprovedSource(TechniqueSource source) {
    if (source.title.trim().isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(source.url.trim());
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.trim().isEmpty) {
      return false;
    }

    return !uri.queryParameters.containsKey('search_query') &&
        !uri.pathSegments.contains('results');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visibleSources = sources
        .where(isConcreteApprovedSource)
        .toList(growable: false);

    if (visibleSources.isEmpty) {
      return TechniqueContentNotice(
        key: const ValueKey<String>('approved-sources-empty'),
        message: l10n.noApprovedSources,
        icon: Icons.verified_outlined,
        accentColor: JudoColors.gold,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: JudoSpacing.sm,
          runSpacing: JudoSpacing.sm,
          children: [
            JudoBadge(text: l10n.officialLabel, type: JudoBadgeType.official),
            JudoBadge(text: l10n.verifiedLabel, type: JudoBadgeType.verified),
          ],
        ),
        const SizedBox(height: JudoSpacing.lg),
        TechniqueContentNotice(
          key: const ValueKey<String>('general-reference-disclosure'),
          message: l10n.sourceGeneralReferenceDisclosure,
          icon: Icons.info_outline_rounded,
          accentColor: JudoColors.textSecondary,
        ),
        const SizedBox(height: JudoSpacing.lg),
        ...List.generate(visibleSources.length, (index) {
          final source = visibleSources[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
            child: JudoCard(
              key: ValueKey<String>('approved-source-$index'),
              padding: const EdgeInsets.all(JudoSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: JudoColors.gold,
                    size: JudoIconSize.sm,
                  ),
                  const SizedBox(width: JudoSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _localizedSourceTitle(l10n, source.title),
                          style: JudoTypography.titleSmall,
                        ),
                        const SizedBox(height: JudoSpacing.xs),
                        Text(
                          source.url,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: JudoTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  String _localizedSourceTitle(AppLocalizations l10n, String title) {
    return switch (title.trim()) {
      'International Judo Federation' => l10n.sourceInternationalJudoFederation,
      'Kodokan Judo Institute' => l10n.sourceKodokanJudoInstitute,
      'European Judo Union' => l10n.sourceEuropeanJudoUnion,
      _ => title,
    };
  }
}
