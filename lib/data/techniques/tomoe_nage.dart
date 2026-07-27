/*
====================================================

Judo Mind Super App

Copyright © 2026 Mohammad Javani

All Rights Reserved.

Intellectual Property of Judo Mind.

====================================================
*/

import '../../models/technique_model.dart';
import '../../models/quiz_model.dart';
import '../../models/technique_translation.dart';


const TechniqueModel tomoeNage = TechniqueModel(

  id: "005",

  englishName: "Tomoe Nage",

  japaneseName: "巴投",


  category: "Sutemi Waza",

  type: "Sutemi Waza",

  beltLevel: "Intermediate",

  difficulty: "Advanced",


  description:
      "Tomoe Nage is a sacrifice throw where the judoka falls backward and uses the foot on the opponent's abdomen to throw the opponent over the head.",


  technicalAnalysis:
      "Tomoe Nage requires precise forward kuzushi, correct timing, controlled sacrifice movement and accurate foot placement. The judoka must coordinate pulling action with body rotation while maintaining control throughout the throw.",


  translations: [

    TechniqueTranslation(

      languageCode: "en",

      name: "Tomoe Nage",

      description:
          "A sacrifice throw using backward movement and the foot to project the opponent.",

      technicalAnalysis:
          "Requires forward kuzushi, correct timing and controlled rotation.",

    ),


    TechniqueTranslation(

      languageCode: "fa",

      name: "توموئه ناگه",

      description:
          "پرتابی از گروه سوتِمی‌وازا که با افتادن به عقب و استفاده از پا برای پرتاب حریف انجام می‌شود.",

      technicalAnalysis:
          "نیازمند کازوشی به جلو، زمان‌بندی دقیق، کنترل حرکت فداکاری و جایگیری صحیح پا است.",

    ),

  ],


  images: [

    "assets/images/techniques/tomoe_nage.png",

  ],


  videos: [

    "https://www.youtube.com/results?search_query=IJF+Tomoe+Nage+official",

    "https://www.youtube.com/results?search_query=Tomoe+Nage+competition",

  ],


  trainingVideo:
      "https://www.youtube.com/results?search_query=Tomoe+Nage+training+drills",


  competitionVideo:
      "https://www.youtube.com/results?search_query=Tomoe+Nage+competition+analysis",



  executionSteps: [

    "Create forward kuzushi by pulling the opponent.",

    "Place the foot correctly on the opponent's body.",

    "Fall backward while extending the leg.",

    "Rotate and control the opponent's landing.",

  ],


  keyPoints: [

    "Strong forward kuzushi",

    "Correct foot placement",

    "Controlled sacrifice movement",

    "Continuous pulling action",

  ],


  commonMistakes: [

    "Falling without kuzushi",

    "Incorrect foot position",

    "Poor timing",

    "Losing control during rotation",

  ],


  safetyTips: [

    "Practice with controlled progression",

    "Protect the opponent during landing",

    "Avoid uncontrolled falling",

  ],


  combinations: [

    "Ko Uchi Gari → Tomoe Nage",

    "Ouchi Gari → Tomoe Nage",

    "Sumi Gaeshi → Tomoe Nage",

  ],


  counters: [

    "Side control defense",

    "Blocking the foot placement",

    "Avoiding forward commitment",

  ],


  quiz: [

    QuizModel(

      question:
          "Which category does Tomoe Nage belong to?",

      options: [

        "Te Waza",

        "Ashi Waza",

        "Sutemi Waza",

        "Koshi Waza",

      ],

      correctAnswerIndex: 2,

      explanation:
          "Tomoe Nage is classified as Sutemi Waza because the judoka sacrifices body position during execution.",

    ),


    QuizModel(

      question:
          "What is the Japanese name of Tomoe Nage?",

      options: [

        "巴投",

        "内股",

        "背負投",

        "大外刈",

      ],

      correctAnswerIndex: 0,

      explanation:
          "巴投 is the Japanese name of Tomoe Nage.",

    ),


    QuizModel(

      question:
          "Where is the main foot placement in Tomoe Nage?",

      options: [

        "Opponent's abdomen area",

        "Opponent's ankle",

        "Opponent's shoulder",

        "Opponent's knee",

      ],

      correctAnswerIndex: 0,

      explanation:
          "The foot is placed on the opponent's abdomen area to create the throwing action.",

    ),

  ],


  sources: [

    TechniqueSource(

      title: "International Judo Federation",

      url: "https://www.ijf.org",

    ),


    TechniqueSource(

      title: "Kodokan Judo Institute",

      url: "https://kodokanjudoinstitute.org",

    ),


    TechniqueSource(

      title: "European Judo Union",

      url: "https://www.eju.net",

    ),

  ],

);