import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/technique_model.dart';
import '../../../core/language/language_provider.dart';


class TechniqueCard extends StatelessWidget {

  final TechniqueModel technique;


  const TechniqueCard({

    super.key,

    required this.technique,

  });


  @override
  Widget build(BuildContext context) {


    final languageCode =
        Provider.of<LanguageProvider>(context)
            .languageCode;


    final techniqueName =
        technique.translations.isNotEmpty
            ? technique.translations
                .firstWhere(
                  (translation) =>
                      translation.languageCode ==
                      languageCode,

                  orElse: () =>
                      technique.translations.first,
                )
                .name
            : technique.nameEn;



    return Container(

      margin:
          const EdgeInsets.only(
            bottom:15,
          ),

      padding:
          const EdgeInsets.all(18),


      decoration:
          BoxDecoration(

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

        children: [

          const Icon(

            Icons.sports_martial_arts,

            color: Color(0xFFD4AF37),

            size:35,

          ),


          const SizedBox(width:15),


          Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,


            children: [


              Text(

                techniqueName,

                style:
                    const TextStyle(

                  color: Colors.white,

                  fontSize:18,

                  fontWeight: FontWeight.bold,

                ),

              ),



              const SizedBox(height:6),



              Text(

                "${technique.category} • ${technique.type}",

                style:
                    const TextStyle(

                  color: Colors.white70,

                ),

              ),

            ],

          ),

        ],

      ),

    );


  }

}