import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../content/technique_content_widgets.dart';

class CompetitionAnalysisSection extends StatelessWidget {
  final TechniqueModel technique;

  const CompetitionAnalysisSection({super.key, required this.technique});

  Future<void> _openCompetitionVideo(BuildContext context) async {
    final uri = Uri.tryParse(technique.competitionVideo.trim());
    final l10n = AppLocalizations.of(context)!;

    if (!_isDirectHttpMedia(uri)) {
      _showMessage(
        context,
        l10n.techniqueCompetitionVideoUnavailable,
        key: const ValueKey<String>('competition-video-unavailable'),
      );
      return;
    }

    final opened = await launchUrl(uri!, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showMessage(
        context,
        l10n.techniqueCompetitionVideoOpenFailed,
        key: const ValueKey<String>('competition-video-open-failed'),
      );
    }
  }

  bool _isDirectHttpMedia(Uri? uri) {
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.trim().isEmpty) {
      return false;
    }

    return !uri.queryParameters.containsKey('search_query') &&
        !uri.pathSegments.contains('results');
  }

  void _showMessage(BuildContext context, String message, {Key? key}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message, key: key)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasDirectVideo = _isDirectHttpMedia(
      Uri.tryParse(technique.competitionVideo.trim()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TechniqueContentNotice(
          key: const ValueKey<String>('competition-content-incomplete'),
          message: l10n.competitionContentIncomplete,
          icon: Icons.info_outline_rounded,
          accentColor: JudoColors.warning,
        ),
        if (hasDirectVideo) ...[
          const SizedBox(height: JudoSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openCompetitionVideo(context),
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: Text(l10n.watchCompetitionExample),
            ),
          ),
        ],
      ],
    );
  }
}
