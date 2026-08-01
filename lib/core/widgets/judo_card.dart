import 'package:flutter/material.dart';

import '../theme/judo_design_tokens.dart';

/// ===========================================================
/// Judo Mind Super App
/// Core Component:
/// Judo Card
///
/// Used across all modules
/// ===========================================================

class JudoCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  final Color? borderColor;

  final Color? backgroundColor;

  final double radius;

  final VoidCallback? onTap;

  final bool showShadow;

  const JudoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(
      JudoSpacing.lg,
    ),
    this.margin = EdgeInsets.zero,
    this.borderColor,
    this.backgroundColor,
    this.radius = JudoRadius.lg,
    this.onTap,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding,

      decoration: BoxDecoration(
        color: backgroundColor ??
            JudoColors.surface,

        borderRadius:
            BorderRadius.circular(radius),

        border: Border.all(
          color: borderColor ??
              JudoColors.border,
        ),

        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(
                    0,
                    8,
                  ),
                ),
              ]
            : null,
      ),

      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius:
          BorderRadius.circular(radius),
      onTap: onTap,
      child: card,
    );
  }
}