import 'package:flutter/material.dart';

import '../../../../models/technique_model.dart';

class TechnicalAnalysisSection extends StatelessWidget {
  final TechniqueModel technique;

  const TechnicalAnalysisSection({
    super.key,
    required this.technique,
  });

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _bulletList(List<String> items) {
    if (items.isEmpty) {
      return const Text(
        "No data available.",
        style: TextStyle(color: Colors.white70),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "• ",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _sectionTitle("Technical Analysis"),

        Text(
          technique.technicalAnalysis,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
          ),
        ),

        _sectionTitle("Execution Steps"),

        _bulletList(technique.executionSteps),

        _sectionTitle("Key Points"),

        _bulletList(technique.keyPoints),

        _sectionTitle("Common Mistakes"),

        _bulletList(technique.commonMistakes),

        _sectionTitle("Safety Tips"),

        _bulletList(technique.safetyTips),

        const SizedBox(height: 24),
      ],
    );
  }
}