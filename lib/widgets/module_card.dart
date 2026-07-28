import 'package:flutter/material.dart';


class ModuleCard extends StatelessWidget {

  final dynamic module;


  const ModuleCard({

    super.key,

    required this.module,

  });


  @override
  Widget build(BuildContext context) {


    return InkWell(

      borderRadius: BorderRadius.circular(18),

      onTap: () {


        if (module.route != null) {


          Navigator.pushNamed(

            context,

            module.route,

          );


        }


      },


      child: Container(

        padding: const EdgeInsets.all(16),


        decoration: BoxDecoration(

          color: const Color(0xFF111111),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(

            color: const Color(0xFF0066FF),

          ),

        ),


        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,


          children: [


            Icon(

              module.icon,

              color: const Color(0xFFD4AF37),

              size: 35,

            ),


            const SizedBox(height: 10),


            Text(

              module.title,

              textAlign: TextAlign.center,


              style: const TextStyle(

                color: Colors.white,

                fontWeight: FontWeight.bold,

              ),

            ),


          ],

        ),

      ),

    );

  }

}