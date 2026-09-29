import 'package:flutter/material.dart';

import '../../../core/localization/technique_term_localizer.dart';
import '../../../l10n/app_localizations.dart';

class TechniqueFilterSheet extends StatelessWidget {
  const TechniqueFilterSheet({
    super.key,
    required this.categories,
    required this.difficulties,
    required this.selectedCategory,
    required this.selectedDifficulty,
    required this.onCategoryChanged,
    required this.onDifficultyChanged,
  });

  final List<String> categories;
  final List<String> difficulties;
  final String selectedCategory;
  final String selectedDifficulty;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.filtersTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _FilterGroup(
              title: l10n.category,
              items: categories,
              selected: selectedCategory,
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 20),
            _FilterGroup(
              title: l10n.difficulty,
              items: difficulties,
              selected: selectedDifficulty,
              onChanged: onDifficultyChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({
    required this.title,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final List<String> items;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: items
              .map(
                (item) => ChoiceChip(
                  label: Text(TechniqueTermLocalizer.filter(l10n, item)),
                  selected: selected == item,
                  onSelected: (_) => onChanged(item),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}
