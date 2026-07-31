import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/technique_model.dart';
import '../video_buttons.dart';

class MediaSection extends StatelessWidget {
  final TechniqueModel technique;

  const MediaSection({
    super.key,
    required this.technique,
  });

  Future<void> _openVideo(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      _showMessage(
        context,
        'Invalid video address.',
      );
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      _showMessage(
        context,
        'The video could not be opened.',
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.officialMedia,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        if (technique.images.isNotEmpty)
          _TechniqueImage(
            imagePath: technique.images.first,
          )
        else
          const _MediaUnavailableCard(
            icon: Icons.image_not_supported_outlined,
            message: 'Technique image is not available.',
          ),

        const SizedBox(height: 18),

        Text(
          l10n.videoLibrary,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        if (technique.videos.isEmpty)
          const _MediaUnavailableCard(
            icon: Icons.video_library_outlined,
            message: 'No videos are currently available.',
          )
        else
          ...List.generate(
            technique.videos.length,
            (index) {
              final video = technique.videos[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _VideoCard(
                  title: 'Official Video ${index + 1}',
                  subtitle: _createVideoSubtitle(video),
                  onTap: () => _openVideo(
                    context,
                    video,
                  ),
                ),
              );
            },
          ),

        const SizedBox(height: 8),

        TechniqueVideoButtons(
          trainingVideo: technique.trainingVideo,
          competitionVideo: technique.competitionVideo,
        ),
      ],
    );
  }

  String _createVideoSubtitle(String videoUrl) {
    final uri = Uri.tryParse(videoUrl);

    if (uri == null || uri.host.isEmpty) {
      return 'External educational video';
    }

    return uri.host.replaceFirst('www.', '');
  }
}

class _TechniqueImage extends StatelessWidget {
  final String imagePath;

  const _TechniqueImage({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return const _MediaUnavailableCard(
                icon: Icons.broken_image_outlined,
                message: 'Technique image could not be loaded.',
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _VideoCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF111111),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 64,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFD4AF37,
                  ).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFD4AF37),
                  size: 28,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.open_in_new_rounded,
                color: Colors.white38,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaUnavailableCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _MediaUnavailableCard({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 110,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white38,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}