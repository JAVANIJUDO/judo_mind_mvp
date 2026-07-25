import 'package:flutter/material.dart';

import '../../core/constants/techniques.dart';
import '../../models/technique_model.dart';
import '../technique_detail/technique_detail_screen.dart';
import 'package:provider/provider.dart';
import '../../core/language/language_provider.dart';


class TechniquesScreen extends StatefulWidget {

  const TechniquesScreen({super.key});


  @override
  State<TechniquesScreen> createState() =>
      _TechniquesScreenState();

}



class _TechniquesScreenState extends State<TechniquesScreen> {


  String searchText = "";

  String selectedFilter = "All";
String selectedDifficulty = "All Levels";


  final List<String> filters = [

    "All",

    "Nage Waza",

    "Te Waza",

    "Ashi Waza",

    "Koshi Waza",

    "Sutemi Waza",

    "Katame Waza",

    "Osaekomi Waza",

    "Shime Waza",

    "Kansetsu Waza",

    "Ne Waza",

    "Tachi Waza",

  ];
final List<String> difficultyFilters = [

  "All Levels",

  "Beginner",

  "Intermediate",

  "Advanced",

  "Elite",

];

  bool checkFilter(TechniqueModel technique){


    if(selectedFilter == "All"){

      return true;

    }


    return technique.category == selectedFilter ||

        technique.type == selectedFilter;


  }

bool checkDifficulty(TechniqueModel technique){

  if(selectedDifficulty == "All Levels"){

    return true;

  }


  return technique.difficulty == selectedDifficulty;

}





  @override
  Widget build(BuildContext context) {


    final filteredTechniques =

    JudoTechniques.techniques.where((technique){


  final query = searchText
      .toLowerCase()
      .trim();



  final searchMatch =

      query.isEmpty ||

      technique.nameEn
          .toLowerCase()
          .contains(query)

      ||

      technique.nameJp
          .toLowerCase()
          .contains(query)

      ||

      technique.category
          .toLowerCase()
          .contains(query)

      ||

      technique.translations.any(

        (translation) =>

            translation.name
                .toLowerCase()
                .contains(query),

      );



  return searchMatch &&
    checkFilter(technique) &&
    checkDifficulty(technique);


}).toList();





    return Scaffold(



      backgroundColor:

          const Color(0xFF050505),



      appBar: AppBar(



        backgroundColor:

            Colors.transparent,



        elevation:0,



        title:const Text(



          "Techniques",



          style:TextStyle(



            color:Colors.white,

            fontWeight:FontWeight.bold,

          ),



        ),



      ),






      body:Padding(



        padding:

            const EdgeInsets.all(20),



        child:Column(



          crossAxisAlignment:

              CrossAxisAlignment.start,



          children:[




            Text(
  "${JudoTechniques.techniques.length} Official Judo Techniques",



              style:TextStyle(



                color:Colors.white,

                fontSize:26,

                fontWeight:FontWeight.bold,

              ),



            ),




            const SizedBox(height:8),




            const Text(



              "IJF Technique Database",



              style:TextStyle(



                color:Color(0xFF0066FF),

                fontSize:16,

              ),



            ),





            const SizedBox(height:20),





            TextField(



              onChanged:(value){



                setState((){



                  searchText=value;



                });



              },



              style:

                  const TextStyle(

                    color:Colors.white,

                  ),



              decoration:

                  InputDecoration(



                hintText:

                    "Search technique...",



                hintStyle:

                    const TextStyle(

                      color:Colors.grey,

                    ),



                prefixIcon:

                    const Icon(

                      Icons.search,

                      color:Colors.white,

                    ),



                filled:true,



                fillColor:

                    const Color(0xFF111111),



                border:

                    OutlineInputBorder(



                  borderRadius:

                      BorderRadius.circular(15),



                  borderSide:

                      BorderSide.none,



                ),



              ),



            ),






            const SizedBox(height:15),






            SizedBox(



              height:45,



              child:ListView.builder(



                scrollDirection:

                    Axis.horizontal,



                itemCount:

                    filters.length,



                itemBuilder:(context,index){



                  final filter = filters[index];



                  final active =

                      selectedFilter == filter;




                  return GestureDetector(



                    onTap:(){



                      setState((){



                        selectedFilter = filter;



                      });



                    },



                    child:Container(



                      margin:

                          const EdgeInsets.only(

                            right:10,

                          ),



                      padding:

                          const EdgeInsets.symmetric(

                            horizontal:18,

                            vertical:10,

                          ),



                      decoration:

                          BoxDecoration(



                        color:

                            active

                            ? const Color(0xFFD4AF37)

                            : const Color(0xFF111111),



                        borderRadius:

                            BorderRadius.circular(20),



                      ),



                      child:Text(



                        filter,



                        style:TextStyle(



                          color:

                              active

                              ? Colors.black

                              : Colors.white,



                          fontWeight:

                              FontWeight.bold,



                        ),



                      ),



                    ),



                  );



                },



              ),



            ),





            const SizedBox(height:20),






            Expanded(



              child:

                  ListView.builder(



                itemCount:

                    filteredTechniques.length,



                itemBuilder:(context,index){



                  final technique =

                      filteredTechniques[index];




                  return GestureDetector(



                    onTap:(){



                      Navigator.push(



                        context,



                        MaterialPageRoute(



                          builder:(context)=>



                              TechniqueDetailScreen(



                                technique:technique,



                              ),



                        ),



                      );



                    },



                    child:

                        TechniqueCard(

                          technique:technique,

                        ),



                  );



                },



              ),



            ),



          ],



        ),



      ),



    );



  }



}






class TechniqueCard extends StatelessWidget {


  final TechniqueModel technique;



  const TechniqueCard({



    super.key,

    required this.technique,



  });





  @override

  Widget build(BuildContext context){



    return Container(



      margin:

          const EdgeInsets.only(

            bottom:15,

          ),



      padding:

          const EdgeInsets.all(18),



      decoration:

          BoxDecoration(



        color:

            const Color(0xFF111111),



        borderRadius:

            BorderRadius.circular(18),



        border:

            Border.all(



          color:

              const Color(0xFF0066FF),



        ),



      ),





      child:Row(



        children:[



          const Icon(



            Icons.sports_martial_arts,



            color:

                Color(0xFFD4AF37),



            size:35,



          ),





          const SizedBox(width:15),




          Column(



            crossAxisAlignment:

                CrossAxisAlignment.start,



            children:[



              Text(

  technique.translations.isNotEmpty
      ? technique.translations
          .firstWhere(
            (translation) =>
                translation.languageCode ==
                Provider.of<LanguageProvider>(context)
    .languageCode,

            orElse: () =>
                technique.translations.first,
          )
          .name
      : technique.nameEn,

  style:
      const TextStyle(

    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,

  ),

),




              const SizedBox(height:6),





              Text(



                "${technique.category} • ${technique.type}",



                style:

                    const TextStyle(



                  color:Colors.white70,



                ),



              ),




            ],



          ),



        ],



      ),



    );



  }



}