import 'package:flutter/material.dart';

import '../theme/judo_design_tokens.dart';

/// ===========================================================
/// Judo Mind Super App
/// Core Component:
/// Judo Section
///
/// Standard section container used across modules
/// ===========================================================

class JudoSection extends StatelessWidget {
  final String title;

  final String? subtitle;

  final IconData? icon;

  final Color? accentColor;

  final Widget child;

  final Widget? trailing;

  final EdgeInsetsGeometry padding;

  const JudoSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.accentColor,
    this.trailing,
    this.padding = const EdgeInsets.all(
      JudoSpacing.lg,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final color =
        accentColor ?? JudoColors.primary;

    return Container(
      margin: const EdgeInsets.only(
        bottom: JudoSpacing.xl,
      ),

      padding: padding,

      decoration: BoxDecoration(
        color: JudoColors.surface,

        borderRadius:
            BorderRadius.circular(
          JudoRadius.lg,
        ),

        border: Border.all(
          color: color.withValues(
            alpha: 0.35,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              if (icon != null) ...[

                Container(
                  width: 42,
                  height: 42,

                  decoration:
                      BoxDecoration(
                    color:
                        color.withValues(
                      alpha: 0.15,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      JudoRadius.sm,
                    ),
                  ),

                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),

                const SizedBox(
                  width: JudoSpacing.md,
                ),
              ],


              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style:
                          const TextStyle(
                        color:
                            JudoColors
                                .textPrimary,

                        fontSize: 19,

                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),


                    if (subtitle != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top:
                              JudoSpacing.xs,
                        ),

                        child: Text(
                          subtitle!,

                          style:
                              const TextStyle(
                            color:
                                JudoColors
                                    .textSecondary,

                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),


              if (trailing != null)
                trailing!,
            ],
          ),


          const SizedBox(
            height: JudoSpacing.lg,
          ),


          child,
        ],
      ),
    );
  }
}