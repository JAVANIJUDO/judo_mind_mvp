import 'package:flutter/material.dart';

import '../../../core/localization/technique_term_localizer.dart';
import '../../../l10n/app_localizations.dart';

class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({
    super.key,
    required this.selectedCategory,
    required this.selectedDifficulty,
    required this.onCategoryClear,
    required this.onDifficultyClear,
  });

  final String selectedCategory;
  final String selectedDifficulty;
  final VoidCallback onCategoryClear;
  final VoidCallback onDifficultyClear;

  bool get hasActiveFilters =>
      selectedCategory != 'All' || selectedDifficulty != 'All Levels';

  @override
  Widget build(BuildContext context) {
    if (!hasActiveFilters) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 8,
        children: [
          if (selectedCategory != 'All')
            Chip(
              label: Text(
                TechniqueTermLocalizer.filter(l10n, selectedCategory),
              ),
              onDeleted: onCategoryClear,
            ),
          if (selectedDifficulty != 'All Levels')
            Chip(
              label: Text(
                TechniqueTermLocalizer.filter(l10n, selectedDifficulty),
              ),
              onDeleted: onDifficultyClear,
            ),
        ],
      ),
    );
  }
}
