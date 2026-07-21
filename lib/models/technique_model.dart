import 'quiz_model.dart';
import 'technique_media_model.dart';

class TechniqueModel {


  final String id;

  final String name;

  final String japaneseName;

  final String category;

  final String type;

  final String beltLevel;



  final List<TechniqueMediaModel> media;



  final String description;



  final String kuzushi;

  final String tsukuri;

  final String kake;



  final List<String> combinations;

  final List<String> commonErrors;

  final List<QuizModel> quiz;

  final List<String> sources;




  const TechniqueModel({


    required this.id,


    required this.name,


    required this.japaneseName,


    required this.category,


    required this.type,


    required this.beltLevel,



    required this.media,



    required this.description,



    required this.kuzushi,


    required this.tsukuri,


    required this.kake,



    required this.combinations,


    required this.commonErrors,


    required this.quiz,


    required this.sources,


  });


}