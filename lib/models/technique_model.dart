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


  // Advanced IJF Information
  final String ijfClassification;
  final String difficulty;
  final String competitionUsage;


  // Media
  final List<String> images;
  final List<String> videos;
final String trainingVideo;

final String competitionVideo;

  // Technical analysis
  final String kuzushi;
  final String tsukuri;
  final String kake;


  // Advanced Technical Data
  final String gripStrategy;
  final String bodyPosition;
  final List<String> tacticalNotes;


  // Training information
  final List<String> combinations;
  final List<String> commonErrors;


  // Champions / Competition
  final List<String> famousUsers;

  final List<String> competitionInsights;


  // Education
  final List<QuizModel> quiz;

  final String aiTrainingAdvice;

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


    this.ijfClassification = "IJF Classification",
    this.difficulty = "Intermediate",
    this.competitionUsage =
        "Used in Judo competition",



    required this.images,
    required this.videos,
this.trainingVideo = '',

this.competitionVideo = '',

    required this.kuzushi,
    required this.tsukuri,
    required this.kake,


    this.gripStrategy =
        "Standard Judo Grip",

    this.bodyPosition =
        "Standard Position",


    this.tacticalNotes = const [],



    required this.combinations,
    required this.commonErrors,


    this.famousUsers = const [],

    this.competitionInsights = const [],



    required this.quiz,

    this.aiTrainingAdvice = "",

    required this.sources,

  });


}