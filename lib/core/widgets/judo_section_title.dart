import 'package:flutter/material.dart';

import '../theme/judo_colors.dart';
import 'judo_icon.dart';



class JudoSectionTitle extends StatelessWidget {


  final String title;

  final String iconType;



  const JudoSectionTitle({

    super.key,

    required this.title,

    required this.iconType,

  });



  @override
  Widget build(BuildContext context) {


    return Row(

      children: [


        JudoIcon(

          type: iconType,

          size: 28,

        ),



        const SizedBox(

          width: 12,

        ),



        Text(

          title,

          style:

          const TextStyle(

            color:

            JudoColors.textPrimary,


            fontSize:

            22,


            fontWeight:

            FontWeight.bold,

          ),

        ),


      ],

    );

  }

}