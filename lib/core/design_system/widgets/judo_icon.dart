import 'package:flutter/material.dart';

import '../icons/judo_icons.dart';

/// =============================================================
/// Judo Mind Design System
/// Standard Icon Widget
///
/// Version: 1.0.0
///
/// Central control point for all icons.
/// Future SVG icons replace the internal implementation only.
/// =============================================================

class JudoIcon extends StatelessWidget {
  final IconData icon;

  final double size;

  final Color? color;

  final String? semanticLabel;

  final bool highlighted;

  const JudoIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.semanticLabel,
    this.highlighted = false,
  });


  /// Convenience constructor for common
  /// Technique Intelligence icons.

  const JudoIcon.technique({
    super.key,
    required this.icon,
    this.size = 28,
    this.color,
    this.semanticLabel,
    this.highlighted = false,
  });


  @override
  Widget build(BuildContext context) {

    return Semantics(
      label: semanticLabel,

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),

        width: size + 12,
        height: size + 12,

        alignment: Alignment.center,

        decoration: BoxDecoration(

          color: highlighted
              ? (color ?? Colors.blue)
                  .withValues(
                    alpha: 0.15,
                  )
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(12),
        ),

        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
    );
  }
}