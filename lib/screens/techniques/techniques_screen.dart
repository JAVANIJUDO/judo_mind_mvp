import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/techniques.dart';
import '../technique_detail/technique_detail_screen.dart';
import 'widgets/active_filter_chips.dart';
import 'widgets/technique_card.dart';
import 'widgets/technique_category_chips.dart';
import 'widgets/technique_filter_button.dart';
import 'widgets/technique_filter_sheet.dart';
import 'widgets/technique_search_bar.dart';
import '../../core/providers/technique_provider.dart';

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

  void showFilterSheet(BuildContext context) {
final techniqueProvider =
    context.read<TechniqueProvider>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return TechniqueFilterSheet(
          categories: filters,
          difficulties: difficultyFilters,
          selectedCategory:
    techniqueProvider.selectedCategory,

selectedDifficulty:
    techniqueProvider.selectedDifficulty,
          onCategoryChanged: (value) {
            context.read<TechniqueProvider>().updateCategory(value);
          },
          onDifficultyChanged: (value) {
            context.read<TechniqueProvider>().updateDifficulty(value);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
final techniqueProvider =
    context.watch<TechniqueProvider>();
final filteredTechniques =
    techniqueProvider.techniques;
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Techniques',
          style: TextStyle(
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
              '${JudoTechniques.techniques.length} Official Judo Techniques',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'IJF Technique Database',
              style: TextStyle(
                color: Color(0xFF0066FF),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            TechniqueSearchBar(
              onChanged: (value) {
                context.read<TechniqueProvider>().updateSearch(value);
              },
            ),

            const SizedBox(height: 15),

            TechniqueFilterButton(
              onTap: () {
                showFilterSheet(context);
              },
            ),

            const SizedBox(height: 15),

            ActiveFilterChips(
              selectedCategory: techniqueProvider.selectedCategory,
              selectedDifficulty: techniqueProvider.selectedDifficulty,
              onCategoryClear: () {
                context.read<TechniqueProvider>()
                    .updateCategory('All');
              },
              onDifficultyClear: () {
                context.read<TechniqueProvider>()
                    .updateDifficulty('All Levels');
              },
            ),

            const SizedBox(height: 10),

            TechniqueCategoryChips(
              categories: filters,
              selectedCategory: techniqueProvider.selectedCategory,
              onChanged: (value) {
                context.read<TechniqueProvider>().updateCategory(value);
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredTechniques.isEmpty
                  ? const Center(
                      child: Text(
                        'No techniques found',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTechniques.length,
                      itemBuilder: (context, index) {
                        final technique = filteredTechniques[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    TechniqueDetailScreen(
                                  technique: technique,
                                ),
                              ),
                            );
                          },
                          child: TechniqueCard(
                            technique: technique,
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