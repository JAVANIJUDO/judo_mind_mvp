import 'video_error_state.dart';
import 'video_controls.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/media/flutter_video_engine.dart';
import '../../../../models/technique_media_item.dart';

class VideoPlayerWidget extends StatefulWidget {
  final TechniqueMediaItem item;

  const VideoPlayerWidget({
    super.key,
    required this.item,
  });

  @override
  State<VideoPlayerWidget> createState() =>
      _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState
    extends State<VideoPlayerWidget> {

  late final FlutterVideoEngine engine;

  bool loading = true;

  String? error;

  @override
  void initState() {
    super.initState();

    engine = FlutterVideoEngine();

    _initialize();
  }

  Future<void> _initialize() async {
  setState(() {
    loading = true;
    error = null;
  });

  try {
    final mediaUrl = widget.item.mediaUrl.trim();

    if (mediaUrl.isEmpty) {
      throw Exception(
        'An approved video link has not been added yet.',
      );
    }

    final uri = Uri.tryParse(mediaUrl);

    final isValidNetworkUrl =
        uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'https' || uri.scheme == 'http');

    if (!isValidNetworkUrl) {
      throw Exception(
        'The video address is invalid or unsupported.',
      );
    }

    await engine.initialize(
      widget.item,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
      error = null;
    });
  } catch (exception) {
    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
      error = _readableErrorMessage(exception);
    });
  }
}
String _readableErrorMessage(
  Object exception,
) {
  final rawMessage = exception.toString().toLowerCase();

  if (rawMessage.contains('approved video link')) {
    return 'An approved video has not been added for this media item yet.';
  }

  if (rawMessage.contains('invalid') ||
      rawMessage.contains('unsupported')) {
    return 'This video address is invalid or is not supported by the internal player.';
  }

  if (rawMessage.contains('network') ||
      rawMessage.contains('socket') ||
      rawMessage.contains('connection') ||
      rawMessage.contains('internet')) {
    return 'The video could not be loaded. Check your internet connection and try again.';
  }

  if (rawMessage.contains('source error') ||
      rawMessage.contains('format') ||
      rawMessage.contains('decoder')) {
    return 'This video format or source cannot be played on this device.';
  }

  return 'The video could not be prepared for playback. Please try again.';
}
  @override
  void dispose() {

    engine.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
  return const AspectRatio(
    aspectRatio: 16 / 9,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

    if (error != null) {
  return AspectRatio(
    aspectRatio: 16 / 9,
    child: VideoErrorState(
      message: error!,
      onRetry: _initialize,
    ),
  );
}

    final controller =
        engine.controller!;

    return AspectRatio(
  aspectRatio:
      controller.value.aspectRatio,

  child: Stack(
    fit: StackFit.expand,

    children: [

      VideoPlayer(
        controller,
      ),


      Positioned(
        left: JudoSpacing.md,
        right: JudoSpacing.md,
        bottom: JudoSpacing.md,

        child: VideoControls(
  controller: controller,
  parentContext: context,
),
      ),
    ],
  ),
);
  }
}