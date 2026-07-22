import 'package:flutter/material.dart';

import '../../core/constants/techniques.dart';
import '../../models/technique_model.dart';
import '../technique_detail/technique_detail_screen.dart';


class TechniquesScreen extends StatefulWidget {

  const TechniquesScreen({super.key});


  @override
  State<TechniquesScreen> createState() =>
      _TechniquesScreenState();

}



class _TechniquesScreenState extends State<TechniquesScreen> {


  String searchText = "";

  String selectedFilter = "All";



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



  bool checkFilter(TechniqueModel technique) {


    if(selectedFilter == "All") {

      return true;

    }


    return technique.category == selectedFilter ||
        technique.type == selectedFilter;

  }




  @override
  Widget build(BuildContext context) {


    final filteredTechniques =
        JudoTechniques.techniques.where((technique) {


      final search = searchText.toLowerCase();



      final searchMatch =

          technique.nameEn
              .toLowerCase()
              .contains(search) ||

          technique.nameJp
              .toLowerCase()
              .contains(search);



      return searchMatch &&
          checkFilter(technique);



    }).toList();




    return Scaffold(


      backgroundColor:
          const Color(0xFF050505),



      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        elevation: 0,


        title: const Text(

          "Techniques",

          style: TextStyle(

            color: Colors.white,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),




      body: Padding(

        padding: const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,


          children: [



            const Text(

              "67 Official Judo Techniques",

              style: TextStyle(

                color: Colors.white,

                fontSize: 26,

                fontWeight: FontWeight.bold,

              ),

            ),



            const SizedBox(height:8),



            const Text(

              "IJF Technique Database",

              style: TextStyle(

                color: Color(0xFF0066FF),

                fontSize:16,

              ),

            ),



            const SizedBox(height:20),




            TextField(


              onChanged:(value){


                setState((){

                  searchText = value;

                });


              },


              style: const TextStyle(

                color: Colors.white,

              ),



              decoration: InputDecoration(


                hintText:

                    "Search technique...",


                hintStyle:

                    const TextStyle(

                      color: Colors.grey,

                    ),


                prefixIcon:

                    const Icon(

                      Icons.search,

                      color: Colors.white,

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


              child: ListView.builder(


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



                    child: Container(


                      margin:

                          const EdgeInsets.only(

                            right:10,

                          ),


                      padding:

                          const EdgeInsets.symmetric(

                            horizontal:18,

                            vertical:10,

                          ),


                      decoration: BoxDecoration(


                        color:

                            active

                            ? const Color(0xFFD4AF37)

                            : const Color(0xFF111111),


                        borderRadius:

                            BorderRadius.circular(20),


                      ),


                      child: Text(

                        filter,


                        style: TextStyle(

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

              child: ListView.builder(

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

                                technique: technique,

                              ),


                        ),

                      );


                    },



                    child: TechniqueCard(

                      technique: technique,

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



      decoration: BoxDecoration(


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



      child: Row(


        children:[



          Container(

            width:55,

            height:55,


            decoration: BoxDecoration(

              color:
                  const Color(0xFF080808),

              borderRadius:
                  BorderRadius.circular(12),

            ),


            child: technique.images.isNotEmpty

                ? ClipRRect(

                    borderRadius:
                        BorderRadius.circular(12),

                    child: Image.asset(

                      technique.images.first,

                      fit: BoxFit.cover,


                      errorBuilder:
                          (context,error,stack){

                        return const Icon(

                          Icons.sports_martial_arts,

                          color:
                              Color(0xFFD4AF37),

                          size:35,

                        );

                      },

                    ),

                  )

                : const Icon(

                    Icons.sports_martial_arts,

                    color:
                        Color(0xFFD4AF37),

                    size:35,

                  ),

          ),



          const SizedBox(width:15),



          Expanded(


            child: Column(


              crossAxisAlignment:

                  CrossAxisAlignment.start,


              children:[



                Text(


                  technique.nameEn,


                  style:

                      const TextStyle(


                    color:Colors.white,


                    fontSize:18,


                    fontWeight:

                        FontWeight.bold,


                  ),


                ),



                const SizedBox(height:6),



                Text(


                  technique.nameJp,


                  style:

                      const TextStyle(


                    color:

                        Color(0xFFD4AF37),


                    fontSize:15,


                  ),


                ),



                const SizedBox(height:6),



                Text(


                  "${technique.category} • ${technique.type}",


                  style:

                      const TextStyle(


                    color:

                        Colors.white70,


                  ),


                ),



              ],


            ),


          ),



          const Icon(

            Icons.arrow_forward_ios,

            color:

                Colors.white54,

            size:18,

          ),



        ],


      ),


    );


  }


}           