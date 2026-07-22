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
          "Uchi Mata is an inner thigh throw where the judoka uses the inner thigh to lift and rotate the opponent while maintaining control.",


      images: [
        "assets/images/techniques/uchi_mata.png",
      ],


      videos: [
        "https://www.youtube.com/results?search_query=IJF+Uchi+Mata+Judo",
        "https://www.youtube.com/results?search_query=Uchi+Mata+Competition+Judo",
      ],


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
              "Uchi Mata is classified as Ashi Waza.",
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
          "Seoi Nage is a shoulder throw where the judoka loads the opponent onto the back and projects them forward.",


      images: [
        "assets/images/techniques/seoi_nage.png",
      ],


      videos: [
        "https://www.youtube.com/results?search_query=IJF+Seoi+Nage+Judo",
        "https://www.youtube.com/results?search_query=Seoi+Nage+Competition+Judo",
      ],


      kuzushi:
          "Pull the opponent forward and break their balance.",


      tsukuri:
          "Enter under the opponent's center of gravity and position the back correctly.",


      kake:
          "Rotate the body and extend the legs to complete the throw.",


      combinations: [
        "Ko Uchi Gari → Seoi Nage",
        "Tai Otoshi → Seoi Nage",
      ],


      commonErrors: [
        "Standing too far from opponent",
        "Poor entry timing",
        "Weak pulling action",
      ],


      quiz: [

        QuizModel(
          question: "Which group does Seoi Nage belong to?",
          options: [
            "Ashi Waza",
            "Te Waza",
            "Sutemi Waza",
            "Kansetsu Waza",
          ],
          correctAnswerIndex: 1,
          explanation:
              "Seoi Nage is classified as Te Waza.",
          difficulty: "Easy",
          points: 10,
        ),


        QuizModel(
          question: "What is the main action of Seoi Nage?",
          options: [
            "Foot sweeping",
            "Shoulder projection",
            "Leg reaping",
            "Sacrifice movement",
          ],
          correctAnswerIndex: 1,
          explanation:
              "Seoi Nage is a shoulder throw.",
          difficulty: "Medium",
          points: 10,
        ),

      ],


      sources: [
        "IJF",
        "Kodokan Judo Institute",
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
        "https://www.youtube.com/results?search_query=IJF+O+Soto+Gari+Judo",
        "https://www.youtube.com/results?search_query=O+Soto+Gari+Competition+Judo",
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