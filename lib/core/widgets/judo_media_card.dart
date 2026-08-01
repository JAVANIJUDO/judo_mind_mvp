import 'package:flutter/material.dart';

import '../theme/judo_design_tokens.dart';
import '../theme/judo_typography.dart';

enum JudoMediaType {
  image,
  trainingVideo,
  competitionVideo,
  animation,
  aiAnalysis,
}


class JudoMediaCard extends StatelessWidget {

  final String title;

  final String? subtitle;

  final String? imageUrl;

  final IconData icon;

  final JudoMediaType type;

  final VoidCallback? onTap;


  const JudoMediaCard({
    super.key,
    required this.title,
    required this.icon,
    required this.type,
    this.subtitle,
    this.imageUrl,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {

    final style = _style();


    return InkWell(

      borderRadius:
          BorderRadius.circular(
            JudoRadius.lg,
          ),

      onTap: onTap,

      child: Container(

        decoration: BoxDecoration(

          color:
              JudoColors.surface,

          borderRadius:
              BorderRadius.circular(
                JudoRadius.lg,
              ),

          border: Border.all(
            color:
                style.color.withValues(
                  alpha: 0.4,
                ),
          ),

        ),


        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [


            AspectRatio(

              aspectRatio: 16 / 9,

              child: Container(

                decoration:
                    BoxDecoration(

                  color:
                      Colors.black,

                  borderRadius:
                      const BorderRadius.vertical(
                    top:
                        Radius.circular(18),
                  ),

                  image:
                      imageUrl != null
                          ? DecorationImage(
                              image:
                                  NetworkImage(
                                    imageUrl!,
                                  ),
                              fit:
                                  BoxFit.cover,
                            )
                          : null,
                ),


                child:
                    imageUrl == null
                        ? Center(
                            child:
                                Icon(
                                  icon,
                                  size:
                                      48,
                                  color:
                                      style.color,
                                ),
                          )
                        : null,
              ),
            ),


            Padding(

              padding:
                  const EdgeInsets.all(
                    JudoSpacing.md,
                  ),

              child:
                  Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style:
                        JudoTypography
                            .titleSmall
                            .copyWith(
                      color:
                          JudoColors
                              .textPrimary,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),


                  if (subtitle != null)

                    const SizedBox(
                      height:
                          6,
                    ),


                  if (subtitle != null)

                    Text(

                      subtitle!,

                      style:
                          JudoTypography
                              .bodySmall
                              .copyWith(
                        color:
                            JudoColors
                                .textSecondary,
                      ),
                    ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }



  _MediaStyle _style() {

    switch(type) {

      case JudoMediaType.image:
        return const _MediaStyle(
          Colors.blue,
        );

      case JudoMediaType.trainingVideo:
        return const _MediaStyle(
          Colors.green,
        );

      case JudoMediaType.competitionVideo:
        return const _MediaStyle(
          Colors.orange,
        );

      case JudoMediaType.animation:
        return const _MediaStyle(
          Colors.purple,
        );

      case JudoMediaType.aiAnalysis:
        return const _MediaStyle(
          Colors.cyan,
        );
    }
  }

}



class _MediaStyle {

  final Color color;

  const _MediaStyle(
    this.color,
  );

}