import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';


class VideoErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const VideoErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        JudoSpacing.xl,
      ),

      decoration: BoxDecoration(
        color: JudoColors.surface,

        borderRadius: BorderRadius.circular(
          JudoRadius.lg,
        ),

        border: Border.all(
          color: JudoColors.danger.withValues(
            alpha: 0.35,
          ),
        ),
      ),


      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          const Icon(
            Icons.error_outline_rounded,

            color: JudoColors.danger,

            size: 54,
          ),


          const SizedBox(
            height: JudoSpacing.md,
          ),


          Text(
            'Video unavailable',

            textAlign: TextAlign.center,

            style: JudoTypography.titleMedium,
          ),


          const SizedBox(
            height: JudoSpacing.sm,
          ),


          Text(
            message,

            textAlign: TextAlign.center,

            style: JudoTypography.bodySmall.copyWith(
              color: Colors.white70,
            ),
          ),


          if (onRetry != null) ...[

            const SizedBox(
              height: JudoSpacing.lg,
            ),


            ElevatedButton.icon(
              onPressed: onRetry,

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label: const Text(
                'Retry',
              ),
            ),
          ],
        ],
      ),
    );
  }
}