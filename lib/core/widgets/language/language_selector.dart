import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../language/app_language.dart';
import '../../language/language_provider.dart';
import '../../theme/judo_design_tokens.dart';
import '../../theme/judo_typography.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<LanguageProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.settingsLanguageDescription, style: JudoTypography.bodySmall),
        const SizedBox(height: JudoSpacing.md),
        RadioGroup<AppLanguage>(
          groupValue: provider.currentLanguage,
          onChanged: (language) async {
            if (language != null) {
              await context.read<LanguageProvider>().changeLanguage(language);
            }
          },
          child: Column(
            children: [
              _LanguageOption(
                key: const ValueKey('settings-language-en'),
                value: AppLanguage.english,
                label: l10n.settingsLanguageEnglish,
              ),
              const SizedBox(height: JudoSpacing.sm),
              _LanguageOption(
                key: const ValueKey('settings-language-fa'),
                value: AppLanguage.persian,
                label: l10n.settingsLanguagePersian,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({super.key, required this.value, required this.label});

  final AppLanguage value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JudoColors.surfaceVariant,
      borderRadius: BorderRadius.circular(JudoRadius.sm),
      child: RadioListTile<AppLanguage>(
        value: value,
        title: Text(label, style: JudoTypography.bodyMedium),
        activeColor: JudoColors.gold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(JudoRadius.sm),
        ),
      ),
    );
  }
}
