import 'package:flutter/material.dart';

import '../../../../core/localization/analysis_provenance_localizer.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/single_attempt_analysis_v2a.dart';

class SingleAttemptV2AResultCard extends StatelessWidget {
  const SingleAttemptV2AResultCard({super.key, required this.result});

  final SingleAttemptAnalysisV2A result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final overlay = result.metrics
        .expand((metric) => metric.overlay)
        .toList(growable: false);

    return Container(
      key: const ValueKey('single-attempt-v2a-result'),
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.primary.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.analytics_outlined, color: JudoColors.primary),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.singleAttemptV2ATitle,
                      style: JudoTypography.titleLarge,
                    ),
                    const SizedBox(height: JudoSpacing.xs),
                    Text(
                      l10n.singleAttemptProjected2d,
                      style: JudoTypography.bodySmall.copyWith(
                        color: JudoColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: JudoSpacing.md),
          _ReviewedGateSummary(
            result: result,
            label: l10n.singleAttemptHumanReviewed,
          ),
          const SizedBox(height: JudoSpacing.sm),
          Container(
            key: const ValueKey('single-attempt-multi-person-insufficient'),
            width: double.infinity,
            padding: const EdgeInsets.all(JudoSpacing.md),
            decoration: BoxDecoration(
              color: JudoColors.warning.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(JudoRadius.md),
            ),
            child: Text(
              l10n.singleAttemptMultiPersonInsufficient,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.warning,
              ),
            ),
          ),
          const SizedBox(height: JudoSpacing.lg),
          ...result.metrics.map(
            (metric) => Padding(
              padding: const EdgeInsets.only(bottom: JudoSpacing.md),
              child: _MetricTile(metric: metric),
            ),
          ),
          if (overlay.isNotEmpty) ...[
            const SizedBox(height: JudoSpacing.sm),
            Text(l10n.blueOverlayTitle, style: JudoTypography.titleSmall),
            const SizedBox(height: JudoSpacing.sm),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(JudoRadius.md),
                child: CustomPaint(
                  key: const ValueKey('single-attempt-blue-overlay'),
                  painter: _BlueGeometryPainter(overlay),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ],
          const SizedBox(height: JudoSpacing.lg),
          Text(
            l10n.scientificLimitationsTitle,
            style: JudoTypography.titleSmall,
          ),
          const SizedBox(height: JudoSpacing.sm),
          ...result.limitations.map(
            (limitation) => Padding(
              padding: const EdgeInsets.only(bottom: JudoSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: JudoIconSize.sm,
                    color: JudoColors.warning,
                  ),
                  const SizedBox(width: JudoSpacing.sm),
                  Expanded(
                    child: Text(
                      limitation.message,
                      style: JudoTypography.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewedGateSummary extends StatelessWidget {
  const _ReviewedGateSummary({required this.result, required this.label});

  final SingleAttemptAnalysisV2A result;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: JudoColors.primary.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(JudoRadius.md),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: const ValueKey('single-attempt-reviewed-details'),
        initiallyExpanded: false,
        title: Text(l10n.scientificDetailsTitle),
        subtitle: Text(label, style: JudoTypography.bodySmall),
        childrenPadding: const EdgeInsets.fromLTRB(
          JudoSpacing.md,
          0,
          JudoSpacing.md,
          JudoSpacing.md,
        ),
        children: [
          Text(
            l10n.reviewedGateSummary(
              result.subject.neutralTrackId,
              result.subject.selectedDetectionIndex,
              _roleLabel(l10n, result.subject.role),
              _sideLabel(l10n, result.supportLeg.side),
              result.attackingLeg == null
                  ? l10n.metricStatusWithheld
                  : _sideLabel(l10n, result.attackingLeg!.side),
              result.attempt.start.timestampMs,
              result.attempt.end.timestampMs,
            ),
            style: JudoTypography.bodySmall,
          ),
        ],
      ),
    );
  }

  String _sideLabel(AppLocalizations l10n, String side) => switch (side) {
    'left' => l10n.leftSide,
    'right' => l10n.rightSide,
    _ => l10n.unknownLabel,
  };

  String _roleLabel(AppLocalizations l10n, String role) => switch (role) {
    'tori' => l10n.toriRole,
    'uke' => l10n.ukeRole,
    _ => l10n.unassignedRole,
  };
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final SingleAttemptMetricResult metric;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = switch (metric.status) {
      SingleAttemptMetricStatus.reportable => JudoColors.success,
      SingleAttemptMetricStatus.reviewRequired => JudoColors.warning,
      SingleAttemptMetricStatus.withheld => JudoColors.textSecondary,
      SingleAttemptMetricStatus.unknown => JudoColors.danger,
    };
    final statusLabel = switch (metric.status) {
      SingleAttemptMetricStatus.reportable => l10n.metricStatusReportable,
      SingleAttemptMetricStatus.reviewRequired =>
        l10n.metricStatusReviewRequired,
      SingleAttemptMetricStatus.withheld => l10n.metricStatusWithheld,
      SingleAttemptMetricStatus.unknown => l10n.metricStatusWithheld,
    };

    return Container(
      key: ValueKey('single-attempt-metric-${metric.metricId}'),
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.surfaceVariant.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: statusColor.withValues(alpha: 0.40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(metric.name, style: JudoTypography.titleSmall),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: JudoSpacing.sm,
                  vertical: JudoSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(JudoRadius.sm),
                ),
                child: Text(
                  statusLabel,
                  style: JudoTypography.bodySmall.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: JudoSpacing.sm),
          if (metric.value != null)
            Text(
              '${_formatValue(metric)} ${metric.unit}',
              style: JudoTypography.titleLarge.copyWith(
                color: JudoColors.primary,
              ),
            )
          else
            Text(
              metric.withheldReason ?? l10n.metricStatusWithheld,
              style: JudoTypography.bodyMedium.copyWith(
                color: JudoColors.textSecondary,
              ),
            ),
          if (metric.descriptiveText != null) ...[
            const SizedBox(height: JudoSpacing.sm),
            Text(metric.descriptiveText!, style: JudoTypography.bodyMedium),
          ],
          const SizedBox(height: JudoSpacing.xs),
          Material(
            color: Colors.transparent,
            child: ExpansionTile(
              key: ValueKey('metric-scientific-details-${metric.metricId}'),
              initiallyExpanded: false,
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                l10n.scientificDetailsTitle,
                style: JudoTypography.bodySmall,
              ),
              children: [
                Text(
                  '${metric.metricId} · '
                  '${localizeAnalysisProvenance(l10n, metric.provenance)} · '
                  '${metric.methodVersion}',
                  style: JudoTypography.bodySmall.copyWith(
                    color: JudoColors.textSecondary,
                  ),
                ),
                const SizedBox(height: JudoSpacing.xs),
                Text(
                  metric.confidence.available && metric.confidence.value != null
                      ? '${l10n.metricConfidenceLabel}: '
                            '${(metric.confidence.value! * 100).toStringAsFixed(0)}% · '
                            '${metric.confidence.interpretation}'
                      : '${l10n.metricConfidenceUnavailableLabel}: '
                            '${metric.confidence.interpretation}',
                  style: JudoTypography.bodySmall,
                ),
                const SizedBox(height: JudoSpacing.xs),
                Text(
                  metric.limitation,
                  style: JudoTypography.bodySmall.copyWith(
                    color: JudoColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue(SingleAttemptMetricResult metric) {
    if (metric.unit == 'seconds') {
      return metric.value!.toStringAsFixed(3);
    }
    return metric.value!.toStringAsFixed(1);
  }
}

class _BlueGeometryPainter extends CustomPainter {
  const _BlueGeometryPainter(this.primitives);

  final List<OverlayPrimitiveSummary> primitives;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = JudoColors.background);
    final geometryPaint = Paint()
      ..color = JudoColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final primitive in primitives) {
      final offsets = primitive.points
          .map((point) => _offset(point, size))
          .toList();
      if ((primitive.kind == 'line' || primitive.kind == 'polyline') &&
          offsets.length >= 2) {
        final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
        for (final offset in offsets.skip(1)) {
          path.lineTo(offset.dx, offset.dy);
        }
        canvas.drawPath(path, geometryPaint);
        for (final offset in offsets) {
          canvas.drawCircle(
            offset,
            4,
            Paint()
              ..color = JudoColors.primary
              ..style = PaintingStyle.fill,
          );
        }
      }

      if (primitive.kind == 'angle_label' && offsets.isNotEmpty) {
        final painter = TextPainter(
          text: TextSpan(
            text: primitive.label ?? '',
            style: const TextStyle(color: JudoColors.white, fontSize: 11),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: size.width * 0.45);
        final origin = offsets.first + const Offset(6, -18);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              origin.dx - 3,
              origin.dy - 2,
              painter.width + 6,
              painter.height + 4,
            ),
            const Radius.circular(3),
          ),
          Paint()..color = JudoColors.primary.withValues(alpha: 0.85),
        );
        painter.paint(canvas, origin);
      }
    }
  }

  Offset _offset(OverlayPointSummary point, Size size) {
    return Offset(
      point.x.clamp(0.0, 1.0) * size.width,
      point.y.clamp(0.0, 1.0) * size.height,
    );
  }

  @override
  bool shouldRepaint(covariant _BlueGeometryPainter oldDelegate) {
    return oldDelegate.primitives != primitives;
  }
}
