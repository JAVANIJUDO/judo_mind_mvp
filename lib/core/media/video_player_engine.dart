import '../../models/technique_media_item.dart';

/// --------------------------------------------------------------
/// Judo Mind
/// Video Player Engine
/// --------------------------------------------------------------

abstract class VideoPlayerEngine {
  Future<void> initialize(
    TechniqueMediaItem item,
  );

  Future<void> play();

  Future<void> pause();

  Future<void> seek(
    Duration position,
  );

  Future<void> dispose();

  bool get isInitialized;

  bool get isPlaying;

  Duration get duration;

  Duration get position;
}