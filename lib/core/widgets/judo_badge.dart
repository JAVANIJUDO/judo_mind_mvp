import 'package:flutter/material.dart';

import '../theme/judo_design_tokens.dart';
import '../theme/judo_typography.dart';

/// ===========================================================
/// Judo Mind Super App
/// Core UI Component:
/// Judo Badge
///
/// Used for:
/// - IJF Verified
/// - Premium Content
/// - AI Analysis
/// - Official Sources
/// - Locked Features
/// ===========================================================

enum JudoBadgeType {
  official,
  premium,
  ai,
  locked,
  advanced,
  beginner,
  verified,
  success,
}

class JudoBadge extends StatelessWidget {
  final String text;

  final JudoBadgeType type;

  final IconData? icon;

  final bool showIcon;

  const JudoBadge({
    super.key,
    required this.text,
    required this.type,
    this.icon,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final style = _badgeStyle();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JudoSpacing.sm,
        vertical: JudoSpacing.xs,
      ),

      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(
          JudoRadius.sm,
        ),

        border: Border.all(
          color: style.borderColor,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          if (showIcon)
            Icon(
              icon ?? style.icon,
              size: JudoIconSize.xs,
              color: style.color,
            ),

          if (showIcon)
            const SizedBox(
              width: JudoSpacing.xs,
            ),

          Text(
            text,
            style: JudoTypography.labelSmall.copyWith(
              color: style.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }


  _BadgeStyle _badgeStyle() {

    switch (type) {

      case JudoBadgeType.official:
        return const _BadgeStyle(
          color: Color(0xFF56CCF2),
          backgroundColor:
              Color(0x2056CCF2),
          borderColor:
              Color(0x5556CCF2),
          icon:
              Icons.verified_outlined,
        );


      case JudoBadgeType.verified:
        return const _BadgeStyle(
          color: Color(0xFF00C853),
          backgroundColor:
              Color(0x2000C853),
          borderColor:
              Color(0x5500C853),
          icon:
              Icons.check_circle_outline,
        );


      case JudoBadgeType.premium:
        return const _BadgeStyle(
          color: Color(0xFFD4AF37),
          backgroundColor:
              Color(0x20D4AF37),
          borderColor:
              Color(0x55D4AF37),
          icon:
              Icons.workspace_premium_outlined,
        );


      case JudoBadgeType.ai:
        return const _BadgeStyle(
          color: Color(0xFF00D1C1),
          backgroundColor:
              Color(0x2000D1C1),
          borderColor:
              Color(0x5500D1C1),
          icon:
              Icons.smart_toy_outlined,
        );


      case JudoBadgeType.locked:
        return const _BadgeStyle(
          color: Color(0xFFFF5A5F),
          backgroundColor:
              Color(0x20FF5A5F),
          borderColor:
              Color(0x55FF5A5F),
          icon:
              Icons.lock_outline,
        );


      case JudoBadgeType.advanced:
        return const _BadgeStyle(
          color: Color(0xFF9B51E0),
          backgroundColor:
              Color(0x209B51E0),
          borderColor:
              Color(0x559B51E0),
          icon:
              Icons.military_tech_outlined,
        );


      case JudoBadgeType.beginner:
        return const _BadgeStyle(
          color: Color(0xFF00B894),
          backgroundColor:
              Color(0x2000B894),
          borderColor:
              Color(0x5500B894),
          icon:
              Icons.school_outlined,
        );


      case JudoBadgeType.success:
        return const _BadgeStyle(
          color: Color(0xFF6FCF97),
          backgroundColor:
              Color(0x206FCF97),
          borderColor:
              Color(0x556FCF97),
          icon:
              Icons.check_circle_outline,
        );
    }
  }
}


class _BadgeStyle {

  final Color color;

  final Color backgroundColor;

  final Color borderColor;

  final IconData icon;


  const _BadgeStyle({
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
  });

}