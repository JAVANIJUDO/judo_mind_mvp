class TechniqueMediaModel {
  final List<String> images;

  final List<String> trainingVideos;

  final List<String> competitionVideos;

  final List<String> animations;

  final List<String> officialSources;

  final String? thumbnail;

  final String? previewVideo;

  const TechniqueMediaModel({
    required this.images,
    required this.trainingVideos,
    required this.competitionVideos,
    required this.animations,
    required this.officialSources,
    this.thumbnail,
    this.previewVideo,
  });
}