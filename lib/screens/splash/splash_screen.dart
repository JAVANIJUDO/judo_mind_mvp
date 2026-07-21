import 'dart:async';

import 'package:flutter/material.dart';

import '../home/home_screen.dart';



class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {

    super.initState();


    Timer(

      const Duration(seconds: 3),

      () {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) => const HomeScreen(),

          ),

        );

      },

    );

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xFF050505),


      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,


          children: [


            const Icon(

              Icons.sports_martial_arts,

              size: 100,

              color: Color(0xFFD4AF37),

            ),



            const SizedBox(height: 30),



            const Text(

              "JUDO MIND",

              style: TextStyle(

                color: Colors.white,

                fontSize: 42,

                fontWeight: FontWeight.bold,

                letterSpacing: 3,

              ),

            ),



            const SizedBox(height: 15),



            const Text(

              "Train Your Body,\nMaster Your Mind",

              textAlign: TextAlign.center,


              style: TextStyle(

                color: Color(0xFF0066FF),

                fontSize: 18,

              ),

            ),

          ],

        ),

      ),

    );

  }

}