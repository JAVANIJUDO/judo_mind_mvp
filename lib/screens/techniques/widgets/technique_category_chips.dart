import 'package:flutter/material.dart';


class TechniqueCategoryChips extends StatelessWidget {


  final List<String> categories;

  final String selectedCategory;

  final ValueChanged<String> onChanged;



  const TechniqueCategoryChips({

    super.key,

    required this.categories,

    required this.selectedCategory,

    required this.onChanged,

  });



  @override
  Widget build(BuildContext context) {


    return SizedBox(


      height:45,


      child: ListView.builder(


        scrollDirection:

            Axis.horizontal,


        itemCount:

            categories.length,


        itemBuilder:(context,index){


          final category = categories[index];


          final active =

              selectedCategory == category;



          return GestureDetector(


            onTap:(){

              onChanged(category);

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



              decoration:

                  BoxDecoration(


                color:

                    active

                    ? const Color(0xFFD4AF37)

                    : const Color(0xFF111111),



                borderRadius:

                    BorderRadius.circular(20),


              ),



              child: Text(


                category,


                style:

                    TextStyle(


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


    );


  }


}