import 'quiz_model.dart';

class TechniqueModel {
  final String id;

  // Basic information
  final String nameEn;
  final String nameJp;
  final String category;
  final String type;
  final String beltLevel;
  final String description;

  // Media
  final List<String> images;
  final List<String> videos;

  // Technical analysis
  final String kuzushi;
  final String tsukuri;
  final String kake;

  // Training information
  final List<String> combinations;
  final List<String> commonErrors;

  // Education
  final List<QuizModel> quiz;

  // Sources
  final List<String> sources;


  const TechniqueModel({

    required this.id,

    required this.nameEn,
    required this.nameJp,
    required this.category,
    required this.type,
    required this.beltLevel,
    required this.description,

    required this.images,
    required this.videos,

    required this.kuzushi,
    required this.tsukuri,
    required this.kake,

    required this.combinations,
    required this.commonErrors,

    required this.quiz,

    required this.sources,

  });
}