import 'package:flutter/material.dart';


class TechnicalAnalysis extends StatelessWidget {
  final String kuzushi;
  final String tsukuri;
  final String kake;

  const TechnicalAnalysis({
    super.key,
    required this.kuzushi,
    required this.tsukuri,
    required this.kake,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technical Analysis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        _AnalysisCard(
          title: 'Kuzushi',
          subtitle: 'Balance Breaking',
          description: kuzushi,
          icon: Icons.balance,
        ),
        const SizedBox(height: 12),
        _AnalysisCard(
          title: 'Tsukuri',
          subtitle: 'Entry and Positioning',
          description: tsukuri,
          icon: Icons.directions_run,
        ),
        const SizedBox(height: 12),
        _AnalysisCard(
          title: 'Kake',
          subtitle: 'Execution',
          description: kake,
          icon: Icons.sports_martial_arts,
        ),
      ],
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  const _AnalysisCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0066FF).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF0066FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
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