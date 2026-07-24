import 'package:flutter/material.dart';

import '../../core/widgets/language/language_selector.dart';


class SettingsScreen extends StatelessWidget {

  const SettingsScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xFF050505),


      appBar: AppBar(

        backgroundColor: const Color(0xFF050505),

        title: const Text(
          "Settings",
        ),

      ),


      body: Padding(

        padding: const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,


          children: [


            const LanguageSelector(),


          ],

        ),

      ),

    );

  }

}