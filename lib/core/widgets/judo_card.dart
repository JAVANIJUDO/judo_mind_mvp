import 'package:flutter/material.dart';

import '../theme/judo_colors.dart';



class JudoCard extends StatelessWidget {


  final Widget child;

  final EdgeInsetsGeometry padding;

  final VoidCallback? onTap;



  const JudoCard({

    super.key,

    required this.child,

    this.padding =
        const EdgeInsets.all(16),

    this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap: onTap,


      child: Container(

        padding: padding,


        decoration: BoxDecoration(


          color: JudoColors.card,


          borderRadius:

              BorderRadius.circular(20),



          border: Border.all(

            color:

                JudoColors.surface,

            width: 1,

          ),



          boxShadow: const [

            BoxShadow(

              color:

                  Colors.black45,

              blurRadius: 10,

              offset:

                  Offset(0, 5),

            ),

          ],

        ),


        child: child,


      ),

    );


  }


}