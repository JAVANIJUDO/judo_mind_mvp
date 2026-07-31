import 'package:flutter/material.dart';

import '../../../../models/technique_model.dart';

class TacticalIntelligenceSection extends StatelessWidget {
  final TechniqueModel technique;

  const TacticalIntelligenceSection({
    super.key,
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    final tacticalNotes = technique.tacticalNotes
        .where((item) => item.trim().isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFB020).withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(),

          const SizedBox(height: 16),

          _TacticalMetric(
            title: 'Grip Strategy',
            value: technique.gripStrategy,
            icon: Icons.front_hand_outlined,
          ),

          const SizedBox(height: 10),

          _TacticalMetric(
            title: 'Body Position',
            value: technique.bodyPosition,
            icon: Icons.accessibility_new_rounded,
          ),

          if (tacticalNotes.isNotEmpty) ...[
            const SizedBox(height: 16),

            const Text(
              'Tactical Notes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 9),

            ...tacticalNotes.map(
              (note) => _TacticalNote(
                text: note,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFFFB020).withValues(
              alpha: 0.14,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.psychology_alt_outlined,
            color: Color(0xFFFFB020),
            size: 22,
          ),
        ),

        const SizedBox(width: 11),

        const Expanded(
          child: Text(
            'Tactical Intelligence',
            style: TextStyle(
              color: Color(0xFFFFB020),
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _TacticalMetric extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _TacticalMetric({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedValue = value.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF080808),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFFFB020),
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  normalizedValue.isEmpty
                      ? 'Not available'
                      : normalizedValue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TacticalNote extends StatelessWidget {
  final String text;

  const _TacticalNote({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(
              top: 7,
              right: 9,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFFB020),
              shape: BoxShape.circle,
            ),
          ),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}