import 'package:flutter/material.dart';


class TechniqueSearchBar extends StatelessWidget {


  final ValueChanged<String> onChanged;


  const TechniqueSearchBar({

    super.key,

    required this.onChanged,

  });



  @override
  Widget build(BuildContext context) {


    return TextField(


      onChanged: onChanged,


      style:

          const TextStyle(

            color: Colors.white,

          ),


      decoration:

          InputDecoration(


        hintText:

            "Search technique...",


        hintStyle:

            const TextStyle(

              color: Colors.grey,

            ),


        prefixIcon:

            const Icon(

              Icons.search,

              color: Colors.white,

            ),


        filled: true,


        fillColor:

            const Color(0xFF111111),


        border:

            OutlineInputBorder(


          borderRadius:

              BorderRadius.circular(15),


          borderSide:

              BorderSide.none,


        ),


      ),


    );


  }


}