import 'package:flutter/material.dart';

import '../theme/judo_design_tokens.dart';
import '../theme/judo_typography.dart';

/// ===========================================================
/// Judo Mind Super App
/// Core UI Component: Judo Action Button
/// Design System Version: 1.0
/// ===========================================================

enum JudoActionButtonVariant {
  primary,
  secondary,
  gold,
  success,
  danger,
  outline,
  ghost,
}

class JudoActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  final IconData? icon;
  final IconData? trailingIcon;

  final JudoActionButtonVariant variant;

  final bool isLoading;
  final bool isExpanded;
  final bool isCompact;

  final String? semanticLabel;

  const JudoActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = JudoActionButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.isCompact = false,
    this.semanticLabel,
  });

  bool get _isEnabled {
    return onPressed != null && !isLoading;
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = isCompact
        ? JudoButtonHeight.compact
        : JudoButtonHeight.normal;

    final foregroundColor = _foregroundColor();
    final backgroundColor = _backgroundColor();
    final borderColor = _borderColor();

    final button = Semantics(
      button: true,
      enabled: _isEnabled,
      label: semanticLabel ?? label,
      child: AnimatedOpacity(
        duration: JudoAnimation.fast,
        opacity: _isEnabled ? 1 : 0.55,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(
              JudoRadius.md,
            ),
            child: AnimatedContainer(
              duration: JudoAnimation.fast,
              height: buttonHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: JudoSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(
                  JudoRadius.md,
                ),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Row(
                mainAxisSize: isExpanded
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: JudoIconSize.sm,
                      height: JudoIconSize.sm,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                          foregroundColor,
                        ),
                      ),
                    )
                  else if (icon != null)
                    Icon(
                      icon,
                      color: foregroundColor,
                      size: JudoIconSize.sm,
                    ),
                  if (isLoading || icon != null)
                    const SizedBox(
                      width: JudoSpacing.sm,
                    ),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: JudoTypography.labelLarge.copyWith(
                        color: foregroundColor,
                      ),
                    ),
                  ),
                  if (!isLoading && trailingIcon != null) ...[
                    const SizedBox(
                      width: JudoSpacing.sm,
                    ),
                    Icon(
                      trailingIcon,
                      color: foregroundColor,
                      size: JudoIconSize.sm,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Color _backgroundColor() {
    switch (variant) {
      case JudoActionButtonVariant.primary:
        return JudoColors.primary;

      case JudoActionButtonVariant.secondary:
        return JudoColors.secondary;

      case JudoActionButtonVariant.gold:
        return JudoColors.gold;

      case JudoActionButtonVariant.success:
        return JudoColors.success;

      case JudoActionButtonVariant.danger:
        return JudoColors.danger;

      case JudoActionButtonVariant.outline:
      case JudoActionButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _foregroundColor() {
    switch (variant) {
      case JudoActionButtonVariant.gold:
        return JudoColors.background;

      case JudoActionButtonVariant.outline:
        return JudoColors.textPrimary;

      case JudoActionButtonVariant.ghost:
        return JudoColors.primary;

      case JudoActionButtonVariant.primary:
      case JudoActionButtonVariant.secondary:
      case JudoActionButtonVariant.success:
      case JudoActionButtonVariant.danger:
        return JudoColors.white;
    }
  }

  Color _borderColor() {
    switch (variant) {
      case JudoActionButtonVariant.primary:
        return JudoColors.primary;

      case JudoActionButtonVariant.secondary:
        return JudoColors.secondary;

      case JudoActionButtonVariant.gold:
        return JudoColors.gold;

      case JudoActionButtonVariant.success:
        return JudoColors.success;

      case JudoActionButtonVariant.danger:
        return JudoColors.danger;

      case JudoActionButtonVariant.outline:
        return JudoColors.border;

      case JudoActionButtonVariant.ghost:
        return Colors.transparent;
    }
  }
}