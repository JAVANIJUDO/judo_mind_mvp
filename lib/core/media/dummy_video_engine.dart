import '../../models/technique_media_item.dart';
import 'video_player_engine.dart';

class DummyVideoEngine implements VideoPlayerEngine {
  bool _initialized = false;
  bool _playing = false;

  @override
  Future<void> initialize(
    TechniqueMediaItem item,
  ) async {
    _initialized = true;
  }

  @override
  Future<void> play() async {
    _playing = true;
  }

  @override
  Future<void> pause() async {
    _playing = false;
  }

  @override
  Future<void> seek(
    Duration position,
  ) async {}

  @override
  Future<void> dispose() async {}

  @override
  bool get isInitialized => _initialized;

  @override
  bool get isPlaying => _playing;

  @override
  Duration get duration => Duration.zero;

  @override
  Duration get position => Duration.zero;
}