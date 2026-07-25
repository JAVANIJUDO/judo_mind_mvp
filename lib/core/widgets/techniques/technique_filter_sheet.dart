import 'package:flutter/material.dart';


class TechniqueFilterSheet extends StatelessWidget {


  final List<String> categories;

  final List<String> difficulties;


  final String selectedCategory;

  final String selectedDifficulty;


  final Function(String) onCategoryChanged;

  final Function(String) onDifficultyChanged;



  const TechniqueFilterSheet({

    super.key,

    required this.categories,

    required this.difficulties,

    required this.selectedCategory,

    required this.selectedDifficulty,

    required this.onCategoryChanged,

    required this.onDifficultyChanged,

  });



  @override
  Widget build(BuildContext context) {


    return Container(

      padding: const EdgeInsets.all(20),

      decoration: const BoxDecoration(

        color: Color(0xFF111111),

        borderRadius: BorderRadius.vertical(

          top: Radius.circular(25),

        ),

      ),


      child: SingleChildScrollView(


  child: Column(

    children: [



          const Text(

            "Filters",

            style: TextStyle(

              color: Colors.white,

              fontSize: 24,

              fontWeight: FontWeight.bold,

            ),

          ),



          const SizedBox(height:20),



          const Text(

            "Category",

            style: TextStyle(

              color: Color(0xFFD4AF37),

              fontSize:18,

            ),

          ),



          Wrap(

            spacing:8,

            children: categories.map((item){

              return ChoiceChip(

                label: Text(item),

                selected: selectedCategory == item,

                onSelected:(_){

                  onCategoryChanged(item);

                },

              );

            }).toList(),

          ),



          const SizedBox(height:20),



          const Text(

            "Difficulty",

            style: TextStyle(

              color: Color(0xFFD4AF37),

              fontSize:18,

            ),

          ),



          Wrap(

            spacing:8,

            children: difficulties.map((item){


              return ChoiceChip(

                label: Text(item),


                selected:
                    selectedDifficulty == item,


                onSelected:(_){

                  onDifficultyChanged(item);

                },

              );


            }).toList(),

          ),



          const SizedBox(height:20),


                        ],

        ),

      ),

    );

  }

}