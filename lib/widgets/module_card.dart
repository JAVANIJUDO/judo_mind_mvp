import 'package:flutter/material.dart';

import '../models/module_model.dart';



class ModuleCard extends StatelessWidget {


  final ModuleModel module;



  const ModuleCard({

    super.key,

    required this.module,

  });



  @override
  Widget build(BuildContext context) {


    return InkWell(


      borderRadius: BorderRadius.circular(22),



      onTap: () {


        Navigator.pushNamed(

          context,

          module.route,

        );


      },



      child: Container(


        decoration: BoxDecoration(


          color: const Color(0xFF111111),


          borderRadius:

              BorderRadius.circular(22),



          border: Border.all(

            color:

                module.color.withOpacity(0.35),

          ),


        ),



        child: Column(


          mainAxisAlignment:

              MainAxisAlignment.center,



          children: [



            Container(


              padding:

                  const EdgeInsets.all(14),



              decoration: BoxDecoration(


                shape:

                    BoxShape.circle,


                color:

                    module.color.withOpacity(0.15),


              ),



              child: Icon(


                module.icon,


                size: 34,


                color: module.color,


              ),


            ),



            const SizedBox(height: 12),



            Text(


              module.title,


              textAlign:

                  TextAlign.center,



              style: const TextStyle(


                color: Colors.white,


                fontSize: 14,


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