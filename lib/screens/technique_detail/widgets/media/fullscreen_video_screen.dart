import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import 'video_controls.dart';


class FullscreenVideoScreen extends StatefulWidget {
  final VideoPlayerController controller;

  const FullscreenVideoScreen({
    super.key,
    required this.controller,
  });

  @override
  State<FullscreenVideoScreen> createState() =>
      _FullscreenVideoScreenState();
}


class _FullscreenVideoScreenState
    extends State<FullscreenVideoScreen> {


  @override
  void initState() {
    super.initState();

    _setLandscape();
  }


  Future<void> _setLandscape() async {

    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }


  Future<void> _restoreOrientation() async {

    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }


  @override
  void dispose() {

    _restoreOrientation();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,

          children: [

            Center(
              child: AspectRatio(
                aspectRatio:
                    widget.controller.value.aspectRatio,

                child: VideoPlayer(
                  widget.controller,
                ),
              ),
            ),


            Positioned(
              left: JudoSpacing.md,
              right: JudoSpacing.md,
              bottom: JudoSpacing.md,

              child: VideoControls(
  controller: widget.controller,
  parentContext: context,
),
            ),


            Positioned(
              top: JudoSpacing.md,
              left: JudoSpacing.md,

              child: IconButton(
                onPressed: () {

                  Navigator.pop(context);

                },

                icon: const Icon(
                  Icons.close_rounded,

                  color: Colors.white,

                  size: 34,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}