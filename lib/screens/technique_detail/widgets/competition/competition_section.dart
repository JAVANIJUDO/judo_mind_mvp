import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/technique_model.dart';

class CompetitionAnalysisSection extends StatelessWidget {
  final TechniqueModel technique;

  const CompetitionAnalysisSection({
    super.key,
    required this.technique,
  });

  Future<void> _openCompetitionVideo(
    BuildContext context,
  ) async {
    final videoUrl = technique.competitionVideo.trim();
    final uri = Uri.tryParse(videoUrl);

    if (uri == null || videoUrl.isEmpty) {
      _showMessage(
        context,
        'Competition video is not available.',
      );
      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      _showMessage(
        context,
        'Competition video could not be opened.',
      );
    }
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final insights = technique.competitionInsights
        .where((item) => item.trim().isNotEmpty)
        .toList();

    if (insights.isEmpty &&
        technique.competitionVideo.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CompetitionHeader(),

          if (insights.isNotEmpty) ...[
            const SizedBox(height: 15),

            ...insights.map(
              (item) => _CompetitionInsight(
                text: item,
              ),
            ),
          ],

          if (technique.competitionVideo
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () => _openCompetitionVideo(
                  context,
                ),
                icon: const Icon(
                  Icons.play_circle_outline_rounded,
                  size: 21,
                ),
                label: const Text(
                  'Watch Competition Example',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFB020),
                  side: BorderSide(
                    color: const Color(0xFFFF8A00)
                        .withValues(alpha: 0.55),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompetitionHeader extends StatelessWidget {
  const _CompetitionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A00).withValues(
              alpha: 0.14,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.emoji_events_outlined,
            color: Color(0xFFFFB020),
            size: 22,
          ),
        ),

        const SizedBox(width: 11),

        const Expanded(
          child: Text(
            'Competition Analysis',
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

class _CompetitionInsight extends StatelessWidget {
  final String text;

  const _CompetitionInsight({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(text);
    final looksLikeUrl =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.insights_rounded,
            color: Color(0xFFFF8A00),
            size: 18,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              looksLikeUrl
                  ? 'Official competition footage is available.'
                  : text,
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