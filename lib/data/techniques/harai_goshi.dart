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


const TechniqueModel haraiGoshi = TechniqueModel(

  id: "004",

  englishName: "Harai Goshi",

  japaneseName: "払腰",


  category: "Koshi Waza",

  type: "Koshi Waza",

  beltLevel: "Intermediate",

  difficulty: "Intermediate",


  description:
      "Harai Goshi is a hip throw where the judoka uses hip rotation and sweeping action of the leg to throw the opponent forward.",


  technicalAnalysis:
      "Harai Goshi requires strong kuzushi forward, correct hip placement, close body contact and coordinated sweeping action. The throw depends on timing, rotation and control rather than pure strength.",


  translations: [

    TechniqueTranslation(

      languageCode: "en",

      name: "Harai Goshi",

      description:
          "A hip throw using rotation and sweeping action to project the opponent.",

      technicalAnalysis:
          "Requires precise kuzushi, hip positioning and coordinated rotation.",

    ),


    TechniqueTranslation(

      languageCode: "fa",

      name: "هارای گوشی",

      description:
          "پرتابی از گروه کوشی‌وازا که با چرخش لگن و جارو کردن پای حریف انجام می‌شود.",

      technicalAnalysis:
          "نیازمند کازوشی، جایگیری صحیح لگن، تماس نزدیک و زمان‌بندی دقیق است.",

    ),

  ],


  images: [

    "assets/images/techniques/harai_goshi.png",

  ],


  videos: [

    "https://www.youtube.com/results?search_query=IJF+Harai+Goshi+official",

    "https://www.youtube.com/results?search_query=Harai+Goshi+competition",

  ],


  trainingVideo:
      "https://www.youtube.com/results?search_query=Harai+Goshi+training+drills",


  competitionVideo:
      "https://www.youtube.com/results?search_query=Harai+Goshi+competition+analysis",



  executionSteps: [

    "Create forward kuzushi.",

    "Enter close and place the hip correctly.",

    "Rotate the body while sweeping with the leg.",

    "Complete the throw with controlled landing.",

  ],


  keyPoints: [

    "Correct hip positioning",

    "Strong upper body control",

    "Close contact with opponent",

    "Explosive rotation",

  ],


  commonMistakes: [

    "Hip too far from opponent",

    "Weak kuzushi",

    "Poor timing of sweeping action",

    "Standing too upright",

  ],


  safetyTips: [

    "Control the opponent during landing",

    "Practice hip entry drills first",

    "Avoid uncontrolled rotation",

  ],


  combinations: [

    "Ouchi Gari → Harai Goshi",

    "Ko Uchi Gari → Harai Goshi",

    "Uchi Mata → Harai Goshi",

  ],


  counters: [

    "Uki Waza",

    "Ura Nage",

    "Blocking hip entry",

  ],


  quiz: [

    QuizModel(

      question:
          "Which category does Harai Goshi belong to?",

      options: [

        "Te Waza",

        "Ashi Waza",

        "Koshi Waza",

        "Sutemi Waza",

      ],

      correctAnswerIndex: 2,

      explanation:
          "Harai Goshi is classified as Koshi Waza because the hip is the main throwing element.",

    ),


    QuizModel(

      question:
          "What is the Japanese name of Harai Goshi?",

      options: [

        "払腰",

        "内股",

        "背負投",

        "大外刈",

      ],

      correctAnswerIndex: 0,

      explanation:
          "払腰 is the Japanese name of Harai Goshi.",

    ),


    QuizModel(

      question:
          "Which body part creates the main rotation in Harai Goshi?",

      options: [

        "Shoulder",

        "Hip",

        "Foot",

        "Arm",

      ],

      correctAnswerIndex: 1,

      explanation:
          "The hip rotation creates the main throwing movement.",

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