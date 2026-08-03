import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'fullscreen_video_screen.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;
final BuildContext parentContext;
  const VideoControls({
  super.key,
  required this.controller,
  required this.parentContext,
});

  @override
  Widget build(BuildContext context) {
    final value = controller.value;

    final duration = value.duration;
    final position = value.position;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JudoSpacing.md,
        vertical: JudoSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.75,
        ),
        borderRadius: BorderRadius.circular(
          JudoRadius.lg,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            children: [

              IconButton(
  onPressed: () {
    Navigator.push(
      parentContext,
      MaterialPageRoute(
        builder: (_) {
          return FullscreenVideoScreen(
            controller: controller,
          );
        },
      ),
    );
  },
  icon: const Icon(
    Icons.fullscreen_rounded,
    color: Colors.white,
    size: 28,
  ),
),

              Expanded(
                child: VideoProgressIndicator(
                  controller,

                  allowScrubbing: true,

                  padding: const EdgeInsets.symmetric(
                    horizontal: JudoSpacing.sm,
                  ),

                  colors: VideoProgressColors(
                    playedColor: JudoColors.primary,

                    bufferedColor:
                        Colors.white38,

                    backgroundColor:
                        Colors.white24,
                  ),
                ),
              ),


              IconButton(
                onPressed: () {
                  
                },

                icon: const Icon(
                  Icons.fullscreen_rounded,

                  color: Colors.white,

                  size: 28,
                ),
              ),
            ],
          ),


          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,

            children: [

              Text(
                '${_formatDuration(position)} / ${_formatDuration(duration)}',

                style: JudoTypography.labelSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String _formatDuration(
    Duration duration,
  ) {

    String twoDigits(
      int n,
    ) =>
        n.toString().padLeft(2, '0');


    final minutes =
        twoDigits(duration.inMinutes.remainder(60));

    final seconds =
        twoDigits(duration.inSeconds.remainder(60));


    return '$minutes:$seconds';
  }
}