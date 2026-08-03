import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../models/technique_media_item.dart';

class TopExecutionCard extends StatelessWidget {
  final TechniqueMediaItem item;

  const TopExecutionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: JudoSpacing.md),

      padding: const EdgeInsets.all(JudoSpacing.md),

      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.amber.withValues(alpha: 0.45)),
      ),

      child: Row(
        children: [
          Container(
            width: 48,

            height: 48,

            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(Icons.emoji_events, color: Colors.amber),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item.title,

                  style: const TextStyle(
                    color: Colors.white,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                if (item.athleteName != null)
                  Text(
                    item.athleteName!,

                    style: const TextStyle(color: Colors.white70),
                  ),

                if (item.competitionName != null)
                  Text(
                    item.competitionName!,

                    style: const TextStyle(color: Colors.amber),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
