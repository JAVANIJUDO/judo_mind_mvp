import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';


class MediaHeader extends StatelessWidget {

  final String techniqueName;


  const MediaHeader({
    super.key,
    required this.techniqueName,
  });


  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,


      children: [

        Row(

          children: [

            Container(

              width: 5,

              height: 42,


              decoration:
                  BoxDecoration(

                color:
                    Colors.blue,

                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
            ),


            const SizedBox(
              width: 14,
            ),


            const Text(

              'Media Library',

              style:
                  TextStyle(

                color:
                    Colors.white,

                fontSize:
                    24,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),


        const SizedBox(
          height: 14,
        ),


        Text(

          'Official resources • Videos • Competition Analysis • AI Learning',

          style:
              TextStyle(

            color:
                Colors.white70,

            fontSize:
                15,

          ),
        ),
      ],
    );
  }
}