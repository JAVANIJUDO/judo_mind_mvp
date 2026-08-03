import 'media_repository.dart';
import 'local_media_repository.dart';

abstract final class MediaRepositoryProvider {
  const MediaRepositoryProvider._();

  static final MediaRepository instance =
      const LocalMediaRepository();
}