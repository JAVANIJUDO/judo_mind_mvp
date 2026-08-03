import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';

enum MediaFilterType {
  all,
  official,
  training,
  competition,
  topExecution,
  aiLab,
}

class MediaFilterBar extends StatelessWidget {
  final MediaFilterType selected;
  final ValueChanged<MediaFilterType> onChanged;

  const MediaFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      (MediaFilterType.all, 'All', Icons.apps_outlined),

      (MediaFilterType.official, 'Official', Icons.verified_outlined),

      (MediaFilterType.training, 'Training', Icons.sports_martial_arts),

      (MediaFilterType.competition, 'Competition', Icons.emoji_events_outlined),

      (
        MediaFilterType.topExecution,
        'Top Execution',
        Icons.workspace_premium_outlined,
      ),

      (MediaFilterType.aiLab, 'AI Lab', Icons.psychology_outlined),
    ];

    return SizedBox(
      height: 44,

     child: ListView.separated(
  scrollDirection: Axis.horizontal,

  padding: const EdgeInsets.symmetric(
    horizontal: JudoSpacing.sm,
  ),

  physics: const BouncingScrollPhysics(),

  itemCount: filters.length,

        separatorBuilder: (_, __) => const SizedBox(width: 10),

        itemBuilder: (context, index) {
          final item = filters[index];

          final isSelected = selected == item.$1;

          return GestureDetector(
            onTap: () {
              onChanged(item.$1);
            },

            child: Container(
padding: const EdgeInsets.symmetric(
  horizontal: JudoSpacing.md,
),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue
                    : Colors.white.withValues(alpha: 0.06),

                borderRadius: BorderRadius.circular(22),

                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.white24,
                ),
              ),

              child: Row(
                children: [
                  Icon(
                    item.$3,

                    size: 18,

                    color: isSelected ? Colors.white : Colors.white70,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    item.$2,

                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
