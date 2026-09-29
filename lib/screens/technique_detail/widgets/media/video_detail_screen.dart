import 'video_player_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/media/media_label_resolver.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../models/technique_media_item.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Screen: Video Detail
/// Module: Technique Media Library
/// Version: 2.0.0
/// ----------------------------------------------------------------

class VideoDetailScreen extends StatelessWidget {
  final TechniqueMediaItem item;

  const VideoDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final displayTitle = MediaLabelResolver.title(item);
    final displaySource = MediaLabelResolver.source(item);
    final category = MediaLabelResolver.category(item);

    return Scaffold(
      backgroundColor: JudoColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: JudoColors.background,
        foregroundColor: Colors.white,
        title: Text('Video Detail', style: JudoTypography.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            JudoSpacing.md,
            JudoSpacing.sm,
            JudoSpacing.md,
            JudoSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoPlayerWidget(item: item),
              const SizedBox(height: JudoSpacing.lg),

              Text(displayTitle, style: JudoTypography.titleLarge),

              const SizedBox(height: JudoSpacing.sm),

              Wrap(
                spacing: JudoSpacing.sm,
                runSpacing: JudoSpacing.sm,
                children: [
                  _InfoBadge(
                    icon: Icons.video_library_outlined,
                    label: category,
                    color: JudoColors.primary,
                  ),

                  if (item.isVerified)
                    const _InfoBadge(
                      icon: Icons.verified_rounded,
                      label: 'Verified',
                      color: JudoColors.success,
                    ),

                  if (item.level.trim().isNotEmpty)
                    _InfoBadge(
                      icon: Icons.signal_cellular_alt_rounded,
                      label: item.level,
                      color: JudoColors.gold,
                    ),

                  if (item.formattedDuration.isNotEmpty)
                    _InfoBadge(
                      icon: Icons.schedule_rounded,
                      label: item.formattedDuration,
                      color: JudoColors.primary,
                    ),
                ],
              ),

              const SizedBox(height: JudoSpacing.xl),

              _SectionCard(
                title: 'Source',
                icon: Icons.account_balance_outlined,
                child: Text(
                  displaySource,
                  style: JudoTypography.bodyMedium.copyWith(
                    color: JudoColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: JudoSpacing.md),

              _SectionCard(
                title: 'Description',
                icon: Icons.description_outlined,
                child: Text(
                  item.description.trim().isEmpty
                      ? 'Technical video reference for studying this judo technique.'
                      : item.description.trim(),
                  style: JudoTypography.bodyMedium,
                ),
              ),

              if (_hasCompetitionInformation(item)) ...[
                const SizedBox(height: JudoSpacing.md),

                _SectionCard(
                  title: 'Competition Information',
                  icon: Icons.emoji_events_outlined,
                  child: Column(
                    children: [
                      if (item.athleteName?.trim().isNotEmpty ?? false)
                        _DetailRow(
                          label: 'Athlete',
                          value: item.athleteName!.trim(),
                        ),

                      if (item.opponentName?.trim().isNotEmpty ?? false)
                        _DetailRow(
                          label: 'Opponent',
                          value: item.opponentName!.trim(),
                        ),

                      if (item.competitionName?.trim().isNotEmpty ?? false)
                        _DetailRow(
                          label: 'Competition',
                          value: item.competitionName!.trim(),
                        ),

                      if (item.competitionYear != null)
                        _DetailRow(
                          label: 'Year',
                          value: item.competitionYear.toString(),
                        ),

                      if (item.scoreResult?.trim().isNotEmpty ?? false)
                        _DetailRow(
                          label: 'Result',
                          value: item.scoreResult!.trim(),
                          isLast: true,
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: JudoSpacing.xl),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    _showPlayerMessage(context);
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Play Video'),
                  style: FilledButton.styleFrom(
                    backgroundColor: JudoColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: JudoSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(JudoRadius.md),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasCompetitionInformation(TechniqueMediaItem mediaItem) {
    return (mediaItem.athleteName?.trim().isNotEmpty ?? false) ||
        (mediaItem.opponentName?.trim().isNotEmpty ?? false) ||
        (mediaItem.competitionName?.trim().isNotEmpty ?? false) ||
        mediaItem.competitionYear != null ||
        (mediaItem.scoreResult?.trim().isNotEmpty ?? false);
  }

  void _showPlayerMessage(BuildContext context) {
    final hasMedia = item.mediaUrl.trim().isNotEmpty;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            hasMedia
                ? 'The internal video player will be connected in the next step.'
                : 'An approved video file has not been added yet.',
          ),
        ),
      );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JudoSpacing.sm,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: JudoTypography.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: JudoColors.primary),
              const SizedBox(width: JudoSpacing.sm),
              Text(title, style: JudoTypography.titleSmall),
            ],
          ),
          const SizedBox(height: JudoSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : JudoSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: JudoTypography.bodySmall.copyWith(color: Colors.white60),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: JudoTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
