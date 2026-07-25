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


const TechniqueModel oSotoGari = TechniqueModel(

  id: "003",

  englishName: "O Soto Gari",

  japaneseName: "大外刈",


  category: "Ashi Waza",

  beltLevel: "Beginner",

  difficulty: "Intermediate",


  description:
      "O Soto Gari is a major outer reap technique where the judoka breaks the opponent's balance backward and reaps the outside leg to complete the throw.",


  technicalAnalysis:
      "O Soto Gari requires strong kuzushi backward, correct body positioning, dominant sleeve and lapel control, and precise timing. The attacker uses the supporting leg, hip position and sweeping action to remove the opponent's balance.",


  translations: [

    TechniqueTranslation(

      languageCode: "en",

      name: "O Soto Gari",

      description:
          "A major outer leg reap technique using balance breaking and sweeping action.",

      technicalAnalysis:
          "Requires backward kuzushi, correct posture and accurate sweeping timing.",

    ),


    TechniqueTranslation(

      languageCode: "fa",

      name: "او سوتو گاری",

      description:
          "یکی از معروف‌ترین تکنیک‌های آشی‌وازا که با برهم زدن تعادل حریف به عقب و جارو کردن پای خارجی انجام می‌شود.",

      technicalAnalysis:
          "نیازمند کازوشی قوی، وضعیت صحیح بدن، کنترل دست‌ها و زمان‌بندی دقیق است.",

    ),

  ],


  images: [

    "assets/images/techniques/o_soto_gari.png",

  ],


  videos: [

    "https://www.youtube.com/results?search_query=IJF+O+Soto+Gari+official",

    "https://www.youtube.com/results?search_query=O+Soto+Gari+competition",

  ],


  trainingVideo:
      "https://www.youtube.com/results?search_query=O+Soto+Gari+training+drills",


  competitionVideo:
      "https://www.youtube.com/results?search_query=O+Soto+Gari+competition+analysis",



  executionSteps: [

    "Break the opponent's balance backward.",

    "Step close while maintaining strong posture.",

    "Reap the opponent's outside leg with control.",

    "Complete the throw while maintaining balance.",

  ],


  keyPoints: [

    "Strong backward kuzushi",

    "Correct upper body control",

    "Powerful sweeping action",

    "Stable supporting leg",

  ],


  commonMistakes: [

    "Weak balance breaking",

    "Attacking from too far distance",

    "Poor posture",

    "Using only leg strength",

  ],


  safetyTips: [

    "Control the opponent during landing",

    "Avoid uncontrolled sweeping",

    "Practice movement drills before full execution",

  ],


  combinations: [

    "Ko Uchi Gari → O Soto Gari",

    "Ouchi Gari → O Soto Gari",

    "O Soto Gari → Newaza",

  ],


  counters: [

    "O Soto Gaeshi",

    "Uchi Mata",

    "Blocking the sweeping leg",

  ],


  quiz: [

    QuizModel(

      question:
          "Which category does O Soto Gari belong to?",

      options: [

        "Te Waza",

        "Ashi Waza",

        "Sutemi Waza",

        "Kansetsu Waza",

      ],

      correctAnswerIndex: 1,

      explanation:
          "O Soto Gari is classified as Ashi Waza because the main action is performed with the leg.",

    ),


    QuizModel(

      question:
          "What is the Japanese name of O Soto Gari?",

      options: [

        "大外刈",

        "内股",

        "背負投",

        "払腰",

      ],

      correctAnswerIndex: 0,

      explanation:
          "大外刈 is the Japanese name of O Soto Gari.",

    ),


    QuizModel(

      question:
          "Which direction is the opponent's balance broken in O Soto Gari?",

      options: [

        "Forward",

        "Backward",

        "Sideways",

        "Downward",

      ],

      correctAnswerIndex: 1,

      explanation:
          "O Soto Gari uses backward kuzushi before the reap.",

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