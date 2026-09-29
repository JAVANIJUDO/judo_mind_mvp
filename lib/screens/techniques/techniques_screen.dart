import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/technique_provider.dart';
import '../../data/techniques/technique_factory.dart';
import '../../l10n/app_localizations.dart';
import '../technique_detail/technique_detail_route_destination.dart';
import '../technique_detail/technique_detail_route_policy.dart';
import 'widgets/active_filter_chips.dart';
import 'widgets/technique_card.dart';
import 'widgets/technique_category_chips.dart';
import 'widgets/technique_filter_button.dart';
import 'widgets/technique_filter_sheet.dart';
import 'widgets/technique_search_bar.dart';

class TechniquesScreen extends StatelessWidget {
  const TechniquesScreen({super.key});

  static const List<String> filters = [
    'All',
    'Nage Waza',
    'Te Waza',
    'Ashi Waza',
    'Koshi Waza',
    'Sutemi Waza',
    'Katame Waza',
    'Osaekomi Waza',
    'Shime Waza',
    'Kansetsu Waza',
    'Ne Waza',
    'Tachi Waza',
  ];

  static const List<String> difficultyFilters = [
    'All Levels',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Elite',
  ];

  void _showFilterSheet(BuildContext context) {
    final techniqueProvider = context.read<TechniqueProvider>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TechniqueFilterSheet(
        categories: filters,
        difficulties: difficultyFilters,
        selectedCategory: techniqueProvider.selectedCategory,
        selectedDifficulty: techniqueProvider.selectedDifficulty,
        onCategoryChanged: techniqueProvider.updateCategory,
        onDifficultyChanged: techniqueProvider.updateDifficulty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final techniqueProvider = context.watch<TechniqueProvider>();
    final filteredTechniques = techniqueProvider.techniques;
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.techniques,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.techniqueCatalogAvailabilitySummary(
                TechniqueFactory.navigableTechniques.length,
                TechniqueFactory.officialRoadmapTechniqueCount,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.techniqueCatalogPreviewSummary(
                TechniqueFactory.previewTechniques.length,
              ),
              style: const TextStyle(color: Color(0xFF0066FF), fontSize: 16),
            ),
            const SizedBox(height: 20),
            TechniqueSearchBar(onChanged: techniqueProvider.updateSearch),
            const SizedBox(height: 15),
            TechniqueFilterButton(onTap: () => _showFilterSheet(context)),
            const SizedBox(height: 15),
            ActiveFilterChips(
              selectedCategory: techniqueProvider.selectedCategory,
              selectedDifficulty: techniqueProvider.selectedDifficulty,
              onCategoryClear: () => techniqueProvider.updateCategory('All'),
              onDifficultyClear: () =>
                  techniqueProvider.updateDifficulty('All Levels'),
            ),
            const SizedBox(height: 10),
            TechniqueCategoryChips(
              categories: filters,
              selectedCategory: techniqueProvider.selectedCategory,
              onChanged: techniqueProvider.updateCategory,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredTechniques.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noTechniquesFound,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTechniques.length,
                      itemBuilder: (context, index) {
                        final technique = filteredTechniques[index];
                        final route = TechniqueDetailRoutePolicy.resolve(
                          technique.id,
                        );
                        final isOpenable = route.isOpenable;
                        return Semantics(
                          enabled: isOpenable,
                          button: isOpenable,
                          child: GestureDetector(
                            onTap: isOpenable
                                ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          TechniqueDetailRouteDestination(
                                            decision: route,
                                          ),
                                    ),
                                  )
                                : null,
                            child: TechniqueCard(
                              technique: technique,
                              isPreview: !isOpenable,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
