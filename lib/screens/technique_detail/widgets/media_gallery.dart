import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/technique_media_model.dart';

import '../../../core/widgets/judo_icon.dart';


class MediaGallery extends StatelessWidget {

  final List<TechniqueMediaModel> media;


  const MediaGallery({

    super.key,

    required this.media,

  });


  @override
  Widget build(BuildContext context) {

    final images = media
        .where((item) => item.type == "image")
        .toList();


    final training = media
        .where((item) => item.type == "training_video")
        .toList();


    final competition = media
        .where((item) => item.type == "competition_video")
        .toList();


    final social = media
        .where((item) => item.type == "social")
        .toList();



    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [


        if(images.isNotEmpty)

          _ImageSection(
            images: images,
          ),



        if(training.isNotEmpty)

          _VideoSection(

            title: "Training Videos",

            iconType: "video",

            items: training,

          ),



        if(competition.isNotEmpty)

          _VideoSection(

            title: "Competition Examples",

            iconType: "champion",

            items: competition,

          ),



        if(social.isNotEmpty)

          _VideoSection(

            title: "Coach & Social Analysis",

            iconType: "ai_bot",

            items: social,

          ),


      ],

    );

  }

}




class _ImageSection extends StatelessWidget {


  final List<TechniqueMediaModel> images;


  const _ImageSection({

    required this.images,

  });



  @override
  Widget build(BuildContext context) {


    return Column(
 
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [


        const _SectionTitle(
             title: "Technique Gallery",
            iconType: "technique",
        ),



        const SizedBox(height:15),



        SizedBox(

          height:240,

          child: ListView.builder(

            scrollDirection: Axis.horizontal,

            itemCount: images.length,

            itemBuilder:(context,index){


              return Container(

                width:280,

                margin:
                const EdgeInsets.only(right:15),


                decoration:BoxDecoration(

                  color:
                  const Color(0xff111111),

                  borderRadius:
                  BorderRadius.circular(20),

                  border:Border.all(

                    color:
                    const Color(0xffD4AF37),

                    width:1,

                  ),

                ),



                child:ClipRRect(

                  borderRadius:
                  BorderRadius.circular(20),


                  child:Image.asset(

                    images[index].url,

                    fit:BoxFit.cover,

                  ),

                ),

              );

            },

          ),

        ),


        const SizedBox(height:30),

      ],

    );

  }

}





class _VideoSection extends StatelessWidget {


  final String title;

  final String iconType;

  final List<TechniqueMediaModel> items;



  const _VideoSection({

    required this.title,

    required this.iconType,

    required this.items,

  });



  @override
  Widget build(BuildContext context) {


    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,


      children: [


        _SectionTitle(
  title: title,
  iconType: iconType,
),


        const SizedBox(height:15),



        ...items.map(

          (video)=>_VideoCard(

            media:video,

          ),

        ),


        const SizedBox(height:25),


      ],

    );

  }

}





class _VideoCard extends StatelessWidget {


  final TechniqueMediaModel media;



  const _VideoCard({

    required this.media,

  });



  Future<void> _openVideo() async {


    final Uri url =
    Uri.parse(media.url);


    if(await canLaunchUrl(url)){


      await launchUrl(

        url,

        mode:
        LaunchMode.externalApplication,

      );


    }

  }



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:_openVideo,


      child:Container(

        margin:
        const EdgeInsets.only(bottom:12),


        padding:
        const EdgeInsets.all(16),


        decoration:BoxDecoration(

          color:
          const Color(0xff121212),

          borderRadius:
          BorderRadius.circular(18),

        ),


        child:Row(

          children: [


            const Icon(

              Icons.play_circle_fill,

              color:
              Color(0xffD4AF37),

              size:40,

            ),



            const SizedBox(width:15),



            Expanded(

              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  Text(

                    media.title,

                    style:
                    const TextStyle(

                      color:Colors.white,

                      fontSize:16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  const SizedBox(height:6),



                  Text(

                    "Source: ${media.source}",

                    style:
                    const TextStyle(

                      color:
                      Colors.white70,

                    ),

                  ),


                ],

              ),

            ),


          ],

        ),

      ),

    );

  }

}





class _SectionTitle extends StatelessWidget {

  final String title;

  final String iconType;


  const _SectionTitle({

    required this.title,

    required this.iconType,

  });



  @override
  Widget build(BuildContext context) {


    return Row(

      children: [


        JudoIcon(
  type: iconType,
  size: 28,
),

        const SizedBox(width:10),



        Text(

          title,

          style:
          const TextStyle(

            color:Colors.white,

            fontSize:22,

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ],

    );

  }

}