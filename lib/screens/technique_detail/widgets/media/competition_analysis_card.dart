import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../models/technique_media_item.dart';

class CompetitionAnalysisCard extends StatelessWidget {
  final TechniqueMediaItem item;

  const CompetitionAnalysisCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: JudoSpacing.md),

      padding: const EdgeInsets.all(JudoSpacing.md),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.blue.withValues(alpha: 0.35)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_outlined, color: Colors.blue),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  item.title,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (item.athleteName != null)
            _InfoRow(title: 'Athlete', value: item.athleteName!),

          if (item.competitionName != null)
            _InfoRow(title: 'Competition', value: item.competitionName!),

          if (item.competitionYear != null)
            _InfoRow(title: 'Year', value: item.competitionYear.toString()),

          if (item.scoreResult != null)
            _InfoRow(title: 'Result', value: item.scoreResult!),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: const TextStyle(color: Colors.white54)),
          ),

          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
