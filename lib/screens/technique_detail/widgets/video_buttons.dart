import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations.dart';

class TechniqueVideoButtons extends StatelessWidget {
  final String trainingVideo;
  final String competitionVideo;

  const TechniqueVideoButtons({
    super.key,
    required this.trainingVideo,
    required this.competitionVideo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
  l10n.trainingVideo,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        _VideoButton(
          label: 'Watch Training Video',
          icon: Icons.play_circle_fill,
          enabled: trainingVideo.trim().isNotEmpty,
          onPressed: () {
            _openVideo(
              context: context,
              url: trainingVideo,
              videoName: 'Training video',
            );
          },
        ),
        const SizedBox(height: 12),
        _VideoButton(
          label: 'Watch Competition Analysis',
          icon: Icons.ondemand_video,
          enabled: competitionVideo.trim().isNotEmpty,
          onPressed: () {
            _openVideo(
              context: context,
              url: competitionVideo,
              videoName: 'Competition video',
            );
          },
        ),
      ],
    );
  }

  Future<void> _openVideo({
    required BuildContext context,
    required String url,
    required String videoName,
  }) async {
    final String cleanUrl = url.trim();

    if (cleanUrl.isEmpty) {
      _showMessage(
        context,
        '$videoName has not been added yet.',
        isError: true,
      );
      return;
    }

    final Uri? videoUri = Uri.tryParse(cleanUrl);

    if (videoUri == null ||
        !videoUri.hasScheme ||
        (videoUri.scheme != 'https' && videoUri.scheme != 'http')) {
      _showMessage(
        context,
        '$videoName link is not valid.',
        isError: true,
      );
      return;
    }

    try {
      final bool opened = await launchUrl(
        videoUri,
      );

      if (!opened && context.mounted) {
        _showMessage(
          context,
          'Unable to open $videoName.',
          isError: true,
        );
      }
    } catch (error) {
      if (context.mounted) {
        _showMessage(
          context,
          'An error occurred while opening $videoName.',
          isError: true,
        );
      }
    }
  }

  void _showMessage(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFF8B1E1E)
            : const Color(0xFF0066FF),
      ),
    );
  }
}

class _VideoButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _VideoButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0066FF),
          disabledBackgroundColor: const Color(0xFF222222),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white38,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}