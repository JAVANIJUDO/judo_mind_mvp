import 'package:flutter/material.dart';

import '../../../core/localization/technique_term_localizer.dart';
import '../../../l10n/app_localizations.dart';

class TechniqueCategoryChips extends StatelessWidget {
  const TechniqueCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final active = selectedCategory == category;
          return ChoiceChip(
            label: Text(TechniqueTermLocalizer.filter(l10n, category)),
            selected: active,
            onSelected: (_) => onChanged(category),
          );
        },
      ),
    );
  }
}
