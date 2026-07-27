import 'package:flutter/material.dart';


class ModuleCard extends StatelessWidget {

  final String title;
  final IconData icon;


  const ModuleCard({

    super.key,

    required this.title,

    required this.icon,

  });


  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(18),

      ),


      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(

            icon,

            color: const Color(0xFFD4AF37),

            size: 35,

          ),


          const SizedBox(height:10),


          Text(

            title,

            style: const TextStyle(

              color: Colors.white,

              fontWeight: FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }

}