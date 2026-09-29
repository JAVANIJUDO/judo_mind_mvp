import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/technique_term_localizer.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/technique_model.dart';
import '../../../core/language/language_provider.dart';

class TechniqueCard extends StatelessWidget {
  final TechniqueModel technique;
  final bool isPreview;

  const TechniqueCard({
    super.key,
    required this.technique,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode = Provider.of<LanguageProvider>(context).languageCode;

    final l10n = AppLocalizations.of(context)!;
    final localizedTechnique = technique.getTranslation(languageCode);
    final techniqueName =
        localizedTechnique?.name ??
        (languageCode == 'en' ? technique.nameEn : l10n.unavailableLabel);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: isPreview ? Colors.white24 : const Color(0xFF0066FF),
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.sports_martial_arts,

            color: Color(0xFFD4AF37),

            size: 35,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  techniqueName,

                  style: const TextStyle(
                    color: Colors.white,

                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  isPreview
                      ? TechniqueTermLocalizer.taxonomy(
                          l10n,
                          technique.category,
                        )
                      : '${TechniqueTermLocalizer.taxonomy(l10n, technique.category)} '
                            '• ${TechniqueTermLocalizer.taxonomy(l10n, technique.type)}',

                  style: const TextStyle(color: Colors.white70),
                ),
                if (isPreview) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.techniquePreviewUnavailable,
                    key: ValueKey<String>('technique-preview-${technique.id}'),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
