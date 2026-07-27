import 'package:flutter/material.dart';
import '../../core/constants/techniques.dart';
import '../../models/technique_model.dart';
import '../technique_detail/technique_detail_screen.dart';
import '../../core/widgets/techniques/technique_filter_sheet.dart';
import 'package:judo_mind/screens/techniques/widgets/technique_card.dart';
import 'widgets/technique_search_bar.dart';
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

void showFilterSheet(){

  showModalBottomSheet(

    context: context,
    isScrollControlled: true,

    backgroundColor: Colors.transparent,

    builder: (context){

      return TechniqueFilterSheet(

        categories: filters,

        difficulties: difficultyFilters,

        selectedCategory: selectedFilter,

        selectedDifficulty: selectedDifficulty,


        onCategoryChanged: (value){

          setState((){

            selectedFilter = value;

          });

        },


        onDifficultyChanged: (value){

          setState((){

            selectedDifficulty = value;

          });

        },


      );

    },

  );

}

bool hasActiveFilters(){

  return selectedFilter != "All" ||
      selectedDifficulty != "All Levels";

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





            TechniqueSearchBar(

  onChanged:(value){

    setState((){

      searchText = value;

    });

  },

),



            const SizedBox(height:15),



            GestureDetector(

              onTap: (){

                showFilterSheet();

              },


              child: Container(

                width: double.infinity,

                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),


                decoration: BoxDecoration(

                  color: const Color(0xFF111111),

                  borderRadius: BorderRadius.circular(15),

                  border: Border.all(

                    color: const Color(0xFF0066FF),

                  ),

                ),


                child: const Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    Icon(

                      Icons.filter_alt,

                      color: Color(0xFFD4AF37),

                    ),


                    SizedBox(width: 10),


                    Text(

                      "Filters",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 16,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ],

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






