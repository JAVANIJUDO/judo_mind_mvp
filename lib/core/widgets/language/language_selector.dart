import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language/app_language.dart';
import '../../language/language_provider.dart';
class LanguageSelector extends StatelessWidget {

  const LanguageSelector({
    super.key,
  });


  @override
  Widget build(BuildContext context) {


    final controller =
        Provider.of<LanguageProvider>(context);



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


            value: Locale(controller.languageCode),


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

  if (locale == null) return;


  switch (locale.languageCode) {

    case "en":
      controller.changeLanguage(
        AppLanguage.english,
      );
      break;


    case "fa":
      controller.changeLanguage(
        AppLanguage.persian,
      );
      break;


    case "ar":
      controller.changeLanguage(
        AppLanguage.arabic,
      );
      break;


    case "ja":
      controller.changeLanguage(
        AppLanguage.japanese,
      );
      break;


    case "fr":
      controller.changeLanguage(
        AppLanguage.french,
      );
      break;


    case "de":
      controller.changeLanguage(
        AppLanguage.german,
      );
      break;


    case "ru":
      controller.changeLanguage(
        AppLanguage.russian,
      );
      break;

  }

},

          ),

        ],

      ),

    );

  }

}