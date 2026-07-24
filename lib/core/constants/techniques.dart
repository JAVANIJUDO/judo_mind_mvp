import '../../models/technique_model.dart';
import '../../models/quiz_model.dart';

class JudoTechniques {
  static const List<TechniqueModel> techniques = [

    TechniqueModel(
      id: "001",

      nameEn: "Uchi Mata",
      nameJp: "内股",

      category: "Nage Waza",
      type: "Ashi Waza",
      beltLevel: "Advanced",

      description:
          "Uchi Mata is an inner thigh throw where the judoka uses the inner thigh to lift and rotate the opponent while maintaining control.",aiTrainingAdvice:
    "Focus on kuzushi timing, sleeve control, hip positioning and repeated technical drills. Practice Uchi Mata after creating forward movement from the opponent.",


      images: [
        "assets/images/techniques/uchi_mata.png",
      ],


      videos: [
  "https://www.youtube.com/results?search_query=IJF+Uchi+Mata+official",
  "https://www.youtube.com/results?search_query=IJF+World+Judo+Tour+Uchi+Mata",
  "https://www.youtube.com/results?search_query=Uchi+Mata+technical+analysis",
],
trainingVideo:

"https://www.youtube.com/results?search_query=Uchi+Mata+training+drills",


competitionVideo:

"https://www.youtube.com/results?search_query=Uchi+Mata+competition+analysis",

      kuzushi:
          "Break the opponent's balance forward and diagonally while controlling the upper body.",


      tsukuri:
          "Enter close to the opponent and position the inner thigh correctly for the lifting action.",


      kake:
          "Lift with the inner thigh and complete the rotation to throw the opponent.",


      combinations: [
        "Ko Uchi Gari → Uchi Mata",
        "Ouchi Gari → Uchi Mata",
        "Uchi Mata → Newaza",
      ],


      commonErrors: [
        "Weak kuzushi",
        "Incorrect hip position",
        "Poor sleeve control",
      ],

famousUsers: [
  "Shohei Ono",
  "Hifumi Abe",
  "Yasuhiro Yamashita",
],


competitionInsights: [
  "Effective when opponent weight shifts forward.",
  "Frequently used after combination attacks.",
  "Requires precise timing and strong upper-body control.",
],

      quiz: [

  QuizModel(
    question: "What category does Uchi Mata belong to?",
    options: [
      "Te Waza",
      "Ashi Waza",
      "Sutemi Waza",
      "Kansetsu Waza",
    ],
    correctAnswerIndex: 1,
    explanation:
        "Uchi Mata is classified as Ashi Waza because the inner thigh is used as the main attacking mechanism.",
    difficulty: "Easy",
    points: 10,
  ),


  QuizModel(
    question: "What is the Japanese name of Uchi Mata?",
    options: [
      "背負投",
      "内股",
      "大外刈",
      "払腰",
    ],
    correctAnswerIndex: 1,
    explanation:
        "Uchi Mata is written as 内股 in Japanese.",
    difficulty: "Easy",
    points: 10,
  ),


  QuizModel(
    question: "Which phase creates the opponent's imbalance before Uchi Mata?",
    options: [
      "Kake",
      "Kuzushi",
      "Ukemi",
      "Shime",
    ],
    correctAnswerIndex: 1,
    explanation:
        "Kuzushi is the balance-breaking phase before execution.",
    difficulty: "Intermediate",
    points: 10,
  ),


  QuizModel(
    question: "What is the main attacking body part in Uchi Mata?",
    options: [
      "Shoulder",
      "Inner thigh",
      "Foot",
      "Arm",
    ],
    correctAnswerIndex: 1,
    explanation:
        "The inner thigh lifts and rotates the opponent.",
    difficulty: "Easy",
    points: 10,
  ),


  QuizModel(
    question: "Which technique is a common combination into Uchi Mata?",
    options: [
      "Ko Uchi Gari",
      "O Soto Gari",
      "Tomoe Nage",
      "Juji Gatame",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Ko Uchi Gari is commonly used to create reaction for Uchi Mata.",
    difficulty: "Intermediate",
    points: 10,
  ),


  QuizModel(
    question: "During Tsukuri, what is the key objective?",
    options: [
      "Escape the opponent",
      "Create correct entry position",
      "Apply submission",
      "Perform ground control",
    ],
    correctAnswerIndex: 1,
    explanation:
        "Tsukuri is the preparation and positioning phase.",
    difficulty: "Intermediate",
    points: 10,
  ),


  QuizModel(
    question: "Uchi Mata belongs primarily to which throwing group?",
    options: [
      "Nage Waza",
      "Katame Waza",
      "Atemi Waza",
      "Kansetsu Waza",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Uchi Mata is a throwing technique within Nage Waza.",
    difficulty: "Easy",
    points: 10,
  ),


  QuizModel(
    question: "What is a common error in Uchi Mata?",
    options: [
      "Strong Kuzushi",
      "Correct hip position",
      "Poor sleeve control",
      "Good timing",
    ],
    correctAnswerIndex: 2,
    explanation:
        "Poor sleeve control reduces control over the opponent.",
    difficulty: "Intermediate",
    points: 10,
  ),


  QuizModel(
    question: "Which skill is critical for successful Uchi Mata?",
    options: [
      "Timing",
      "Strength only",
      "Speed only",
      "Weight advantage",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Timing and reaction reading are essential in elite Uchi Mata.",
    difficulty: "Advanced",
    points: 10,
  ),


  QuizModel(
    question: "Uchi Mata is frequently used by elite competitors because of:",
    options: [
      "Low scoring potential",
      "High throwing effectiveness",
      "No technical requirement",
      "Being a ground technique",
    ],
    correctAnswerIndex: 1,
    explanation:
        "Uchi Mata is one of the most effective competition throws.",
    difficulty: "Advanced",
    points: 10,
  ),
],

sources: [
  "IJF",
  "Kodokan Judo Institute",
  "European Judo Union",
],
),

    TechniqueModel(
  id: "002",

  nameEn: "Seoi Nage",
  nameJp: "背負投",

  category: "Nage Waza",
  type: "Te Waza",
  beltLevel: "Intermediate",

  description:
      "Seoi Nage is a shoulder throw where the judoka loads the opponent onto the back and throws using rotation, lifting action and controlled movement.",


  images: [
    "assets/images/techniques/seoi_nage.png",
  ],


  videos: [
    "IJF Official Tutorial - Seoi Nage",
    "IJF World Judo Tour - Seoi Nage Competition Examples",
    "Seoi Nage Technical Analysis",
  ],


  kuzushi:
      "Break the opponent's balance forward while controlling the sleeve and upper body.",


  tsukuri:
      "Enter under the opponent's center of gravity and position the back correctly for the throw.",


  kake:
      "Lift and rotate the opponent over the shoulder while maintaining control.",


  combinations: [
    "Ko Uchi Gari → Seoi Nage",
    "Ouchi Gari → Seoi Nage",
    "Seoi Nage → Newaza",
  ],


  commonErrors: [
    "Poor entry distance",
    "Incorrect hip and shoulder position",
    "Weak sleeve control",
  ],


  quiz: [

    QuizModel(
      question: "What category does Seoi Nage belong to?",
      options: [
        "Te Waza",
        "Ashi Waza",
        "Sutemi Waza",
        "Kansetsu Waza",
      ],
      correctAnswerIndex: 0,
      explanation:
          "Seoi Nage is classified as Te Waza because the throw is mainly performed using hand and upper body action.",
      difficulty: "Easy",
      points: 10,
    ),


    QuizModel(
      question: "What is the Japanese name of Seoi Nage?",
      options: [
        "内股",
        "背負投",
        "大外刈",
        "払腰",
      ],
      correctAnswerIndex: 1,
      explanation:
          "Seoi Nage is written as 背負投 in Japanese.",
      difficulty: "Easy",
      points: 10,
    ),


    QuizModel(
      question: "Which phase creates the opponent's imbalance before Seoi Nage?",
      options: [
        "Kake",
        "Kuzushi",
        "Ukemi",
        "Shime",
      ],
      correctAnswerIndex: 1,
      explanation:
          "Kuzushi is the balance-breaking phase before execution.",
      difficulty: "Intermediate",
      points: 10,
    ),


    QuizModel(
      question: "Where should the judoka position during Tsukuri?",
      options: [
        "Behind the opponent",
        "Under the opponent's center of gravity",
        "Far away from opponent",
        "On the ground",
      ],
      correctAnswerIndex: 1,
      explanation:
          "Correct entry under the opponent is essential for Seoi Nage.",
      difficulty: "Intermediate",
      points: 10,
    ),


    QuizModel(
      question: "Which grip control is important for Seoi Nage?",
      options: [
        "Sleeve and lapel control",
        "Foot control only",
        "Neck control only",
        "No grip required",
      ],
      correctAnswerIndex: 0,
      explanation:
          "Sleeve and lapel control help create direction and rotation.",
      difficulty: "Easy",
      points: 10,
    ),


    QuizModel(
      question: "Seoi Nage is mainly classified as which throwing technique group?",
      options: [
        "Nage Waza",
        "Katame Waza",
        "Atemi Waza",
        "Shime Waza",
      ],
      correctAnswerIndex: 0,
      explanation:
          "Seoi Nage is a throwing technique in Nage Waza.",
      difficulty: "Easy",
      points: 10,
    ),


    QuizModel(
      question: "What is a common error in Seoi Nage?",
      options: [
        "Correct entry",
        "Good kuzushi",
        "Poor distance control",
        "Strong rotation",
      ],
      correctAnswerIndex: 2,
      explanation:
          "Incorrect distance prevents effective loading of the opponent.",
      difficulty: "Intermediate",
      points: 10,
    ),


    QuizModel(
      question: "Which skill is critical for successful Seoi Nage?",
      options: [
        "Timing and coordination",
        "Only physical strength",
        "Only speed",
        "Weight advantage",
      ],
      correctAnswerIndex: 0,
      explanation:
          "Timing, coordination and technique are key factors.",
      difficulty: "Advanced",
      points: 10,
    ),


    QuizModel(
      question: "Seoi Nage is frequently used in competition because of:",
      options: [
        "Low effectiveness",
        "High scoring potential",
        "Being a ground technique",
        "No technical requirement",
      ],
      correctAnswerIndex: 1,
      explanation:
          "Seoi Nage is one of the most effective competition throws.",
      difficulty: "Advanced",
      points: 10,
    ),


    QuizModel(
      question: "Which technique can be combined with Seoi Nage?",
      options: [
        "Ko Uchi Gari",
        "Juji Gatame",
        "Hadaka Jime",
        "Kesa Gatame",
      ],
      correctAnswerIndex: 0,
      explanation:
          "Ko Uchi Gari is a common combination entry into Seoi Nage.",
      difficulty: "Advanced",
      points: 10,
    ),

  ],


  sources: [
    "IJF",
    "Kodokan Judo Institute",
    "European Judo Union",
  ],
),


        TechniqueModel(
      id: "003",

      nameEn: "O Soto Gari",
      nameJp: "大外刈",

      category: "Nage Waza",
      type: "Ashi Waza",
      beltLevel: "Beginner",

      description:
          "O Soto Gari is a major outer reap technique where the opponent is thrown backward using leg action.",


      images: [
        "assets/images/techniques/o_soto_gari.png",
      ],


      videos: [
  "IJF Official Tutorial - Uchi Mata",
  "IJF World Judo Tour - Uchi Mata Competition Examples",
  "Uchi Mata Slow Motion Technical Analysis",
],


      kuzushi:
          "Break balance backward while controlling the upper body.",


      tsukuri:
          "Position beside the opponent and prepare the sweeping leg.",


      kake:
          "Execute the outer leg reap and complete the throw.",


      combinations: [
        "Ouchi Gari → O Soto Gari",
        "O Soto Gari → Newaza",
      ],


      commonErrors: [
        "Incorrect distance",
        "Weak upper body control",
        "Poor timing of reap",
      ],


      quiz: [

        QuizModel(
          question: "What type of technique is O Soto Gari?",
          options: [
            "Te Waza",
            "Ashi Waza",
            "Sutemi Waza",
            "Kansetsu Waza",
          ],
          correctAnswerIndex: 1,
          explanation:
              "O Soto Gari is an Ashi Waza technique.",
          difficulty: "Easy",
          points: 10,
        ),


        QuizModel(
          question: "Which direction is the opponent thrown in O Soto Gari?",
          options: [
            "Forward",
            "Sideways",
            "Backward",
            "Downward",
          ],
          correctAnswerIndex: 2,
          explanation:
              "The opponent is mainly thrown backward.",
          difficulty: "Medium",
          points: 10,
        ),

      ],


      sources: [
        "IJF",
        "Kodokan Judo Institute",
      ],
    ),

  ];
}