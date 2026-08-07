import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/single_camera_pose_summary.dart';

class SingleCameraPoseSummaryCard extends StatelessWidget {
  const SingleCameraPoseSummaryCard({super.key, required this.summary});

  final SingleCameraPoseSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const ValueKey('single-camera-pose-summary'),
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.success.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.accessibility_new_rounded,
                color: JudoColors.success,
              ),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(
                child: Text(
                  l10n.singleCameraPoseSummaryTitle,
                  style: JudoTypography.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: JudoSpacing.sm),
          Text(
            '${summary.engine.displayName} · '
            '${l10n.experimentalPoseBaseline}',
            style: JudoTypography.bodySmall.copyWith(
              color: JudoColors.textSecondary,
            ),
          ),
          const SizedBox(height: JudoSpacing.lg),
          _ProvenanceRow(
            icon: Icons.video_file_outlined,
            label: l10n.measuredVideoMetadataLabel,
            detail:
                '${summary.video.width}×${summary.video.height} · '
                '${summary.video.durationSeconds.toStringAsFixed(1)} s',
          ),
          const SizedBox(height: JudoSpacing.sm),
          _ProvenanceRow(
            icon: Icons.model_training_outlined,
            label: l10n.modelEstimatedPoseCoverageLabel,
            detail:
                '${l10n.analyzedFramesLabel}: '
                '${summary.poseCoverage.analyzedFrameCount}',
          ),
          const SizedBox(height: JudoSpacing.lg),
          _CoverageBar(
            label: l10n.atLeastOnePoseLabel,
            rate: summary.poseCoverage.atLeastOnePoseRate,
          ),
          const SizedBox(height: JudoSpacing.md),
          _CoverageBar(
            label: l10n.twoPosesLabel,
            rate: summary.poseCoverage.twoPoseRate,
          ),
          const SizedBox(height: JudoSpacing.lg),
          Text(
            l10n.scientificConfidenceUnavailable,
            style: JudoTypography.bodySmall.copyWith(
              color: JudoColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: JudoSpacing.lg),
          Text(
            l10n.scientificLimitationsTitle,
            style: JudoTypography.titleSmall,
          ),
          const SizedBox(height: JudoSpacing.sm),
          ...summary.limitations.map(
            (limitation) =>
                _LimitationItem(text: _localizedLimitation(l10n, limitation)),
          ),
        ],
      ),
    );
  }

  String _localizedLimitation(
    AppLocalizations l10n,
    SingleCameraAnalysisLimitation limitation,
  ) {
    return switch (limitation.code) {
      'pose_identity_not_available' => l10n.poseIdentityNotAvailable,
      'phase_detection_not_available' => l10n.phaseDetectionNotAvailable,
      'single_camera_2d_only' => l10n.singleCamera2dOnly,
      'force_torque_not_available' => l10n.forceTorqueNotAvailable,
      'experimental_pose_baseline' => l10n.experimentalPoseLimitation,
      _ => limitation.message,
    };
  }
}

class _ProvenanceRow extends StatelessWidget {
  const _ProvenanceRow({
    required this.icon,
    required this.label,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: JudoColors.primary, size: JudoIconSize.sm),
        const SizedBox(width: JudoSpacing.sm),
        Expanded(
          child: Text('$label\n$detail', style: JudoTypography.bodySmall),
        ),
      ],
    );
  }
}

class _CoverageBar extends StatelessWidget {
  const _CoverageBar({required this.label, required this.rate});

  final String label;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final boundedRate = rate.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: JudoTypography.bodySmall)),
            Text(
              '${(boundedRate * 100).toStringAsFixed(0)}%',
              style: JudoTypography.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: JudoSpacing.xs),
        LinearProgressIndicator(
          value: boundedRate,
          backgroundColor: JudoColors.surfaceVariant,
          color: JudoColors.primary,
        ),
      ],
    );
  }
}

class _LimitationItem extends StatelessWidget {
  const _LimitationItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: JudoColors.warning,
            size: JudoIconSize.sm,
          ),
          const SizedBox(width: JudoSpacing.sm),
          Expanded(child: Text(text, style: JudoTypography.bodySmall)),
        ],
      ),
    );
  }
}
