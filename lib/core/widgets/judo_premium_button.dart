import 'package:flutter/material.dart';


class JudoPremiumButton extends StatelessWidget {

  final String label;

  final IconData icon;

  final VoidCallback onPressed;

  final Color accentColor;


  const JudoPremiumButton({

    super.key,

    required this.label,

    required this.icon,

    required this.onPressed,

    this.accentColor = const Color(0xFFD4AF37),

  });



  @override
  Widget build(BuildContext context) {


    return SizedBox(

      width: double.infinity,

      child: ElevatedButton.icon(

        onPressed: onPressed,


        icon: Icon(

          icon,

          size: 24,

        ),


        label: Text(

          label,

          style: const TextStyle(

            fontWeight: FontWeight.bold,

            fontSize: 16,

          ),

        ),


        style: ElevatedButton.styleFrom(

          backgroundColor:
              const Color(0xFF111111),


          foregroundColor:
              accentColor,


          padding:
              const EdgeInsets.symmetric(

                vertical: 16,

              ),


          side: BorderSide(

            color: accentColor,

            width: 1.2,

          ),


          shape: RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(16),

          ),


          elevation: 8,

        ),

      ),

    );

  }

}
