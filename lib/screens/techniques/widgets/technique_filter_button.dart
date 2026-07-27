import 'package:flutter/material.dart';


class TechniqueFilterButton extends StatelessWidget {


  final VoidCallback onTap;


  const TechniqueFilterButton({

    super.key,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap: onTap,


      child: Container(


        height:45,


        decoration: BoxDecoration(


          color: const Color(0xFF111111),


          borderRadius:
              BorderRadius.circular(15),


          border: Border.all(

            color:
                const Color(0xFF0066FF),

          ),


        ),



        child: Row(


          mainAxisAlignment:
              MainAxisAlignment.center,


          children: [


            const Icon(

              Icons.filter_alt,

              color:
                  Color(0xFFD4AF37),

            ),



            const SizedBox(width:10),



            const Text(

              "Filters",

              style: TextStyle(

                color: Colors.white,

                fontSize:16,

                fontWeight:
                    FontWeight.bold,

              ),

            ),


          ],


        ),


      ),


    );


  }


}