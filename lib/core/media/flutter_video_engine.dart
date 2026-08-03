import 'package:video_player/video_player.dart';

import '../../models/technique_media_item.dart';
import 'video_player_engine.dart';

class FlutterVideoEngine implements VideoPlayerEngine {
  VideoPlayerController? _controller;

  @override
  Future<void> initialize(
    TechniqueMediaItem item,
  ) async {
    final url = item.mediaUrl.trim();

    if (url.isEmpty) {
      throw Exception(
        'Video URL is empty',
      );
    }

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );

    await _controller!.initialize();
  }

  @override
  Future<void> play() async {
    await _controller?.play();
  }

  @override
  Future<void> pause() async {
    await _controller?.pause();
  }

  @override
  Future<void> seek(
    Duration position,
  ) async {
    await _controller?.seekTo(position);
  }

  @override
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  @override
  bool get isInitialized {
    return _controller?.value.isInitialized ?? false;
  }

  @override
  bool get isPlaying {
    return _controller?.value.isPlaying ?? false;
  }

  @override
  Duration get duration {
    return _controller?.value.duration ??
        Duration.zero;
  }

  @override
  Duration get position {
    return _controller?.value.position ??
        Duration.zero;
  }

  VideoPlayerController? get controller {
    return _controller;
  }
}