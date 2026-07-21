import 'package:flutter/material.dart';

import '../theme/judo_colors.dart';



class JudoButton extends StatelessWidget {


  final String text;

  final VoidCallback onPressed;

  final String? iconType;



  const JudoButton({

    super.key,

    required this.text,

    required this.onPressed,

    this.iconType,

  });



  @override
  Widget build(BuildContext context) {


    return SizedBox(

      width: double.infinity,


      height: 52,


      child: ElevatedButton(


        onPressed: onPressed,


        style:

        ElevatedButton.styleFrom(


          backgroundColor:

          JudoColors.electricBlue,


          foregroundColor:

          Colors.white,


          shape:

          RoundedRectangleBorder(


            borderRadius:

            BorderRadius.circular(16),

          ),


          elevation: 0,


        ),



        child:

        Row(

          mainAxisAlignment:

          MainAxisAlignment.center,


          children: [


            if(iconType != null)

              const Icon(

                Icons.play_circle_outline,

                size: 24,

              ),



            if(iconType != null)

              const SizedBox(

                width: 8,

              ),



            Text(

              text,


              style:

              const TextStyle(

                fontSize: 16,

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