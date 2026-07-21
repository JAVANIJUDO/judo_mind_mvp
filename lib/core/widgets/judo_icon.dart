import 'package:flutter/material.dart';


class JudoIcon extends StatelessWidget {


  final String type;

  final double size;

  final Color? color;



  const JudoIcon({

    super.key,

    required this.type,

    this.size = 28,

    this.color,

  });



  String _getIconPath() {


    switch(type){


      case "technique":

        return "assets/icons/judo/technique.png";


      case "video":

        return "assets/icons/judo/video.png";


      case "quiz":

        return "assets/icons/judo/quiz.png";


      case "source":

        return "assets/icons/judo/source.png";


      case "champion":

        return "assets/icons/judo/champion.png";


      case "ai_bot":

        return "assets/icons/judo/ai_bot.png";


      case "monitoring":

        return "assets/icons/judo/monitoring.png";


      case "kuzushi":

        return "assets/icons/judo/kuzushi.png";


      case "tsukuri":

        return "assets/icons/judo/tsukuri.png";


      case "kake":

        return "assets/icons/judo/kake.png";


      default:

        return "assets/icons/judo/technique.png";


    }

  }



  @override
  Widget build(BuildContext context) {


    return Image.asset(

      _getIconPath(),

      width: size,

      height: size,


      errorBuilder:

      (context,error,stackTrace){


        return Icon(

          Icons.sports_martial_arts,

          size:size,

          color:
          color ?? Colors.white,

        );


      },

    );

  }


}