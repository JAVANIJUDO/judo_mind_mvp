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


const TechniqueModel seoiNage = TechniqueModel(

  id: "002",

  englishName: "Seoi Nage",

  japaneseName: "背負投",


  category: "Te Waza",

  type: "Te Waza",

  beltLevel: "Intermediate",

  difficulty: "Intermediate",


  description:
      "Seoi Nage is a shoulder throw where the judoka loads the opponent onto the back and throws using rotation, lifting action and coordinated pulling.",


  technicalAnalysis:
      "Seoi Nage depends on precise kuzushi, correct entry distance, shoulder placement, hip rotation and explosive finishing. The judoka must combine sleeve control, body rotation and timing instead of relying only on strength.",


  translations: [

    TechniqueTranslation(

      languageCode: "en",

      name: "Seoi Nage",

      description:
          "A shoulder throw where the opponent is loaded onto the back and projected forward.",

      technicalAnalysis:
          "Requires precise kuzushi, correct entry and explosive rotation.",

    ),


    TechniqueTranslation(

      languageCode: "fa",

      name: "سئوی ناگه",

      description:
          "پرتابی از گروه ته‌وازا که با قرار دادن حریف روی پشت و چرخش بدن انجام می‌شود.",

      technicalAnalysis:
          "نیازمند کازوشی دقیق، ورود صحیح، کنترل آستین و چرخش انفجاری است.",

    ),

  ],


  images: [

    "assets/images/techniques/seoi_nage.png",

  ],


  videos: [

    "https://www.youtube.com/results?search_query=IJF+Seoi+Nage+official",

    "https://www.youtube.com/results?search_query=Seoi+Nage+competition",

  ],


  trainingVideo:
      "https://www.youtube.com/results?search_query=Seoi+Nage+training+drills",


  competitionVideo:
      "https://www.youtube.com/results?search_query=Seoi+Nage+competition+analysis",



  executionSteps: [

    "Create kuzushi by pulling the opponent forward.",

    "Enter under the opponent's center of gravity.",

    "Place the shoulder correctly and load the opponent.",

    "Rotate explosively and complete the throw.",

  ],


  keyPoints: [

    "Strong sleeve and lapel control",

    "Low and balanced entry",

    "Correct shoulder placement",

    "Fast body rotation",

  ],


  commonMistakes: [

    "Entering too far away",

    "Using only arm strength",

    "Poor posture during entry",

    "Slow rotation",

  ],


  safetyTips: [

    "Control the opponent during landing",

    "Practice entry movements before full throws",

    "Maintain correct posture",

  ],


  combinations: [

    "Ko Uchi Gari → Seoi Nage",

    "Ouchi Gari → Seoi Nage",

    "Tai Otoshi → Seoi Nage",

  ],


  counters: [

    "Uki Waza",

    "Ura Nage",

    "Side control defense",

  ],


  quiz: [

    QuizModel(

      question:
          "Which category does Seoi Nage belong to?",

      options: [

        "Te Waza",

        "Ashi Waza",

        "Sutemi Waza",

        "Kansetsu Waza",

      ],

      correctAnswerIndex: 0,

      explanation:
          "Seoi Nage is classified as Te Waza because the throwing action is mainly performed through hand and upper body movement.",

    ),


    QuizModel(

      question:
          "What is the Japanese name of Seoi Nage?",

      options: [

        "内股",

        "背負投",

        "大外刈",

        "払腰",

      ],

      correctAnswerIndex: 1,

      explanation:
          "背負投 is the Japanese name of Seoi Nage.",

    ),


    QuizModel(

      question:
          "Which phase creates imbalance before Seoi Nage?",

      options: [

        "Kuzushi",

        "Ukemi",

        "Shime",

        "Newaza",

      ],

      correctAnswerIndex: 0,

      explanation:
          "Kuzushi is the first fundamental phase that breaks the opponent's balance.",

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