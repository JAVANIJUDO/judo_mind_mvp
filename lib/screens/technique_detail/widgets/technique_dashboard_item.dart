import 'package:flutter/material.dart';

import '../../../core/design_system/illustrations/judo_illustration.dart';
import '../../../core/design_system/illustrations/judo_illustration_type.dart';
import '../../../core/design_system/widgets/judo_icon.dart';
import '../../../core/theme/judo_design_tokens.dart';
import '../../../core/theme/judo_typography.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Component: Technique Dashboard Item
/// Design System: JMDS 1.0
/// Reference Technique: Uchi Mata
/// Version: 2.0.0
/// ----------------------------------------------------------------
///
/// Supports two approved visual modes:
///
/// 1. Standard JMDS icon
/// 2. Selective custom Judo Mind illustration
///
/// Illustrations are restricted to high-value features to avoid
/// excessive visual density inside the dashboard.
class TechniqueDashboardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;
  final String? badgeText;
  final bool isEnabled;
  final JudoIllustrationType? illustrationType;

  const TechniqueDashboardItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.badgeText,
    this.isEnabled = true,
    this.illustrationType,
  });

  @override
  Widget build(BuildContext context) {
    final canOpen = isEnabled && onTap != null;

    return Semantics(
      button: true,
      enabled: canOpen,
      label: title,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: canOpen ? 1 : 0.45,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canOpen ? onTap : null,
            borderRadius: BorderRadius.circular(JudoRadius.lg),
            child: Ink(
              decoration: BoxDecoration(
                color: JudoColors.surface,
                borderRadius: BorderRadius.circular(JudoRadius.lg),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.34),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(JudoSpacing.md),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DashboardVisual(
                          title: title,
                          icon: icon,
                          accentColor: accentColor,
                          illustrationType: illustrationType,
                        ),

                        const SizedBox(height: JudoSpacing.sm),

                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: JudoTypography.titleSmall.copyWith(
                            color: JudoColors.textPrimary,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),

                        if (subtitle.trim().isNotEmpty) ...[
                          const SizedBox(height: JudoSpacing.xs),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: JudoTypography.bodySmall.copyWith(
                              color: JudoColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),

                    if (badgeText != null && badgeText!.trim().isNotEmpty)
                      PositionedDirectional(
                        top: 0,
                        end: 0,
                        child: _DashboardBadge(
                          text: badgeText!,
                          color: accentColor,
                        ),
                      ),

                    if (!isEnabled)
                      const PositionedDirectional(
                        bottom: 0,
                        end: 0,
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: JudoColors.textSecondary,
                          size: 15,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardVisual extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final JudoIllustrationType? illustrationType;

  const _DashboardVisual({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.illustrationType,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIllustration = illustrationType;

    if (selectedIllustration != null) {
      return JudoIllustration(
        type: selectedIllustration,
        size: 46,
        accentColor: accentColor,
        showBackground: true,
        showBorder: false,
        semanticLabel: title,
      );
    }

    return JudoIcon.technique(
      icon: icon,
      size: 19,
      color: accentColor,
      semanticLabel: title,
      highlighted: true,
    );
  }
}

class _DashboardBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _DashboardBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(JudoRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: JudoTypography.labelSmall.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
