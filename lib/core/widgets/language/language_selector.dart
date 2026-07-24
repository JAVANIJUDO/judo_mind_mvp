import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/language_controller.dart';


class LanguageSelector extends StatelessWidget {

  const LanguageSelector({
    super.key,
  });


  @override
  Widget build(BuildContext context) {


    final controller =
        Provider.of<LanguageController>(context);



    return Container(

      padding: const EdgeInsets.all(16),


      decoration: BoxDecoration(

        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(16),

      ),


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [


          const Text(

            "Language",

            style: TextStyle(

              color: Colors.white,

              fontSize: 18,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 15),



          DropdownButton<Locale>(


            value: controller.locale,


            dropdownColor: const Color(0xFF111111),


            iconEnabledColor: Colors.white,


            style: const TextStyle(

              color: Colors.white,

            ),



            items: const [

              DropdownMenuItem(

                value: Locale('en'),

                child: Text("🇬🇧 English"),

              ),


              DropdownMenuItem(

                value: Locale('fa'),

                child: Text("🇮🇷 فارسی"),

              ),


              DropdownMenuItem(

                value: Locale('ar'),

                child: Text("🇸🇦 العربية"),

              ),


              DropdownMenuItem(

                value: Locale('ja'),

                child: Text("🇯🇵 日本語"),

              ),


              DropdownMenuItem(

                value: Locale('fr'),

                child: Text("🇫🇷 Français"),

              ),


              DropdownMenuItem(

                value: Locale('de'),

                child: Text("🇩🇪 Deutsch"),

              ),


              DropdownMenuItem(

                value: Locale('ru'),

                child: Text("🇷🇺 Русский"),

              ),

            ],



            onChanged: (locale) {


              if (locale != null) {

                controller.changeLanguage(
                  locale.languageCode,
                );

              }


            },

          ),

        ],

      ),

    );

  }

}