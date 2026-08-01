import 'package:flutter/material.dart';

import '../theme/judo_design_tokens.dart';
import '../theme/judo_typography.dart';

/// ===========================================================
/// Judo Mind Super App
/// Core Component:
/// Judo App Bar
///
/// Used for:
/// - Technique Detail
/// - Champion Profile
/// - Courses
/// - Media Viewer
/// ===========================================================

class JudoAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String? title;

  final String? subtitle;

  final VoidCallback? onBack;

  final VoidCallback? onFavorite;

  final bool isFavorite;

  final List<Widget>? actions;

  final bool transparent;


  const JudoAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.onBack,
    this.onFavorite,
    this.isFavorite = false,
    this.actions,
    this.transparent = true,
  });


  @override
  Widget build(BuildContext context) {

    return AppBar(

      backgroundColor:
          transparent
              ? Colors.transparent
              : JudoColors.background,

      elevation: 0,

      centerTitle: false,

      automaticallyImplyLeading: false,


      leading: IconButton(

        icon: const Icon(
          Icons.arrow_back_ios_new,
        ),

        color:
            JudoColors.textPrimary,

        onPressed:
            onBack ??
            () => Navigator.pop(context),
      ),



      title: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          if (title != null)

            Text(
              title!,

              style:
                  JudoTypography.titleMedium
                      .copyWith(
                color:
                    JudoColors.textPrimary,
                fontWeight:
                    FontWeight.w800,
              ),
            ),


          if (subtitle != null)

            Text(
              subtitle!,

              style:
                  JudoTypography.bodySmall
                      .copyWith(
                color:
                    JudoColors.textSecondary,
              ),
            ),

        ],
      ),



      actions: [

        if (onFavorite != null)

          IconButton(

            icon: Icon(

              isFavorite
                  ? Icons.bookmark
                  : Icons.bookmark_border,

            ),

            color:
                isFavorite
                    ? JudoColors.gold
                    : JudoColors.textPrimary,

            onPressed:
                onFavorite,
          ),


        if (actions != null)

          ...actions!,
      ],

    );
  }



  @override
  Size get preferredSize =>
      const Size.fromHeight(64);

}