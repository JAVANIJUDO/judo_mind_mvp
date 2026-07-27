import 'package:flutter/material.dart';


class ActiveFilterChips extends StatelessWidget {

  final String selectedCategory;

  final String selectedDifficulty;

  final VoidCallback onCategoryClear;

  final VoidCallback onDifficultyClear;


  const ActiveFilterChips({

    super.key,

    required this.selectedCategory,

    required this.selectedDifficulty,

    required this.onCategoryClear,

    required this.onDifficultyClear,

  });


  bool get hasActiveFilters =>
      selectedCategory != "All" ||
      selectedDifficulty != "All Levels";



  @override
  Widget build(BuildContext context) {


    if (!hasActiveFilters) {

      return const SizedBox();

    }


    return Padding(

      padding:

          const EdgeInsets.only(

            top:10,

            bottom:10,

          ),


      child: Wrap(

        spacing:8,


        children:[


          if (selectedCategory != "All")

            Chip(

              label: Text(selectedCategory),

              onDeleted: onCategoryClear,

            ),



          if (selectedDifficulty != "All Levels")

            Chip(

              label: Text(selectedDifficulty),

              onDeleted: onDifficultyClear,

            ),


        ],

      ),

    );

  }

}