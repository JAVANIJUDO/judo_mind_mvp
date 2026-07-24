import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/constants/modules.dart';
import '../../widgets/module_card.dart';



class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});


  int getCrossAxisCount(double width) {

    if (width >= 1200) {
      return 4;
    }

    if (width >= 800) {
      return 3;
    }

    return 2;

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor: AppTheme.background,


      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,


        title: const Text(

          "JUDO MIND",

          style: TextStyle(

            color: Colors.white,

            fontSize: 22,

            fontWeight: FontWeight.bold,

            letterSpacing: 2,

          ),

        ),


        actions: [


          IconButton(

  onPressed: () {

    Navigator.pushNamed(
      context,
      "/settings",
    );

  },

  icon: const Icon(

    Icons.language,

    color: AppTheme.gold,

  ),

),


          IconButton(

            onPressed: () {},

            icon: const Icon(

              Icons.person,

              color: AppTheme.primaryBlue,

            ),

          ),


        ],

      ),



      body: LayoutBuilder(


        builder: (context,constraints) {


          return SingleChildScrollView(


            padding: const EdgeInsets.only(
  top: 30,
  left: 16,
  right: 16,
  bottom: 30,
),


            child: Column(


              crossAxisAlignment:

                  CrossAxisAlignment.start,


              children: [



                Container(


                  width: double.infinity,


                  padding: const EdgeInsets.all(24),


                  decoration: BoxDecoration(


                    borderRadius:

                        BorderRadius.circular(24),



                    gradient:

                        const LinearGradient(


                      begin:

                          Alignment.topLeft,


                      end:

                          Alignment.bottomRight,


                      colors: [


                        Color(0xFF1C1C1C),


                        Color(0xFF080808),


                      ],


                    ),



                    border: Border.all(


                      color: AppTheme.primaryBlue

                          .withOpacity(0.25),


                    ),


                  ),



                  child: Column(


                    crossAxisAlignment:

                        CrossAxisAlignment.start,


                    children: [



                      const Text(


                        "Welcome Judoka",


                        style: TextStyle(


                          color: Colors.white,


                          fontSize: 28,


                          fontWeight:

                              FontWeight.bold,


                        ),


                      ),



                      const SizedBox(height: 12),



                      const Text(


                        "Train Smarter.\nFight Stronger.\nRise Higher.",


                        style: TextStyle(


                          color:

                              AppTheme.primaryBlue,


                          fontSize: 18,


                          height: 1.5,


                        ),


                      ),



                      const SizedBox(height: 20),



                      ElevatedButton(


                        onPressed: () {},


                        style:

                            ElevatedButton.styleFrom(


                          backgroundColor:

                              AppTheme.gold,


                          foregroundColor:

                              Colors.black,


                          shape:

                              RoundedRectangleBorder(


                            borderRadius:

                                BorderRadius.circular(30),


                          ),


                        ),


                        child: const Text(

                          "Start Training",

                        ),


                      ),



                    ],


                  ),


                ),



                const SizedBox(height: 32),



                const Text(


                  "Explore Judo Mind",


                  style: TextStyle(


                    color: Colors.white,


                    fontSize: 24,


                    fontWeight:

                        FontWeight.bold,


                  ),


                ),



                const SizedBox(height: 20),



                GridView.builder(


                  shrinkWrap: true,


                  physics:

                      const NeverScrollableScrollPhysics(),



                  itemCount:

                      JudoMindModules.modules.length,



                  gridDelegate:


                      SliverGridDelegateWithFixedCrossAxisCount(



                    crossAxisCount:

                        getCrossAxisCount(

                            constraints.maxWidth),



                    crossAxisSpacing: 16,


                    mainAxisSpacing: 16,



                    childAspectRatio: 1.35,


                  ),



                  itemBuilder: (context,index) {



                    return ModuleCard(

                      module:

                          JudoMindModules.modules[index],

                    );


                  },


                ),



                const SizedBox(height: 30),



              ],


            ),


          );


        },


      ),


    );


  }


}