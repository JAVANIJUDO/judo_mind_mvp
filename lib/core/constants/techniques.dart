import '../../models/technique_model.dart';
import '../../models/quiz_model.dart';
import '../../models/technique_media_model.dart';


class JudoTechniques {


  static const List<TechniqueModel> techniques = [



    TechniqueModel(


      id: "001",


      name: "Uchi Mata",


      japaneseName: "内股",


      category: "Nage Waza",


      type: "Ashi Waza",


      beltLevel: "Advanced",



     media: [

  TechniqueMediaModel(
    title: "Uchi Mata Official Image",
    url: "assets/images/techniques/uchi_mata.png",
    type: "image",
    source: "IJF",
  ),


  TechniqueMediaModel(
    title: "Uchi Mata Technical Demonstration",
    url:
        "https://www.youtube.com/results?search_query=IJF+Uchi+Mata+Judo",
    type: "training_video",
    source: "IJF",
  ),


  TechniqueMediaModel(
    title: "Uchi Mata Competition Examples",
    url:
        "https://www.youtube.com/results?search_query=Uchi+Mata+Judo+Competition",
    type: "competition_video",
    source: "IJF / Judo Events",
  ),


  TechniqueMediaModel(
    title: "Uchi Mata Coaching Analysis",
    url:
        "https://www.instagram.com/",
    type: "social",
    source: "Verified Judo Coach",
  ),

],



      description:

          "Uchi Mata is an inner thigh throw where the judoka uses the inner thigh to lift and rotate the opponent while maintaining control.",



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
        "Uchi Mata is classified as Ashi Waza because the main action is performed with the leg.",
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
  ),

  QuizModel(
    question: "Which part creates the main lifting action in Uchi Mata?",
    options: [
      "The hand grip only",
      "The inner thigh",
      "The foot sweep",
      "The shoulder",
    ],
    correctAnswerIndex: 1,
    explanation:
        "The inner thigh creates the lifting and rotating action.",
  ),

  QuizModel(
    question: "What is the purpose of Kuzushi in Uchi Mata?",
    options: [
      "Break the opponent's balance",
      "Lock the opponent's arm",
      "Avoid contact",
      "Move backward",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Kuzushi means breaking the opponent's balance before the throw.",
  ),

  QuizModel(
    question: "What is Tsukuri in Uchi Mata?",
    options: [
      "The final fall",
      "The entry and positioning phase",
      "A defensive action",
      "A ground technique",
    ],
    correctAnswerIndex: 1,
    explanation:
        "Tsukuri is the preparation and correct positioning before execution.",
  ),

  QuizModel(
    question: "What is Kake in Uchi Mata?",
    options: [
      "Grip fighting",
      "The execution of the throw",
      "A warm-up movement",
      "A penalty",
    ],
    correctAnswerIndex: 1,
    explanation:
        "Kake is the final execution phase of the technique.",
  ),

  QuizModel(
    question: "Which technique group does Uchi Mata belong to?",
    options: [
      "Nage Waza",
      "Katame Waza",
      "Atemi Waza",
      "Kihon",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Uchi Mata is a throwing technique in Nage Waza.",
  ),

  QuizModel(
    question: "Which combination is commonly used with Uchi Mata?",
    options: [
      "Ko Uchi Gari → Uchi Mata",
      "Armbar → Uchi Mata",
      "Choke → Uchi Mata",
      "Guard Pull → Uchi Mata",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Ko Uchi Gari is a common setup for Uchi Mata.",
  ),

  QuizModel(
    question: "What is a common mistake in Uchi Mata?",
    options: [
      "Weak Kuzushi",
      "Too much ground fighting",
      "Using only the arms",
      "Avoiding grips",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Weak Kuzushi reduces the effectiveness of the throw.",
  ),

  QuizModel(
    question: "Uchi Mata is mainly considered which type of throwing action?",
    options: [
      "Inner thigh throw",
      "Hand throw",
      "Sacrifice throw",
      "Joint lock",
    ],
    correctAnswerIndex: 0,
    explanation:
        "Uchi Mata is an inner thigh throwing technique.",
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


      name: "Seoi Nage",


      japaneseName: "背負投",


      category: "Nage Waza",


      type: "Te Waza",


      beltLevel: "Intermediate",



      media: [

  TechniqueMediaModel(
    title: "Official Technique Image",
    url: "",
    type: "image",
    source: "IJF",
  ),

  TechniqueMediaModel(
    title: "Training Video",
    url: "",
    type: "training_video",
    source: "IJF",
  ),

  TechniqueMediaModel(
    title: "Competition Video",
    url: "",
    type: "competition_video",
    source: "IJF",
  ),

],



      description:

          "Seoi Nage is a shoulder throw where the judoka loads the opponent onto the back and projects them forward.",



      kuzushi:

          "Pull the opponent forward and break their balance.",



      tsukuri:

          "Enter under the opponent's center of gravity and place the back correctly.",



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
        "Seoi Nage is classified as Te Waza because the hands and upper body create the main throwing action.",
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
        "Seoi Nage is a shoulder throw where the opponent is loaded onto the back.",
  ),

],



      sources: [


        "IJF",


        "Kodokan Judo Institute",


      ],


    ),





    TechniqueModel(


      id: "003",


      name: "O Soto Gari",


      japaneseName: "大外刈",


      category: "Nage Waza",


      type: "Ashi Waza",


      beltLevel: "Beginner",



      media: [

  TechniqueMediaModel(
    title: "Official Technique Image",
    url: "",
    type: "image",
    source: "IJF",
  ),

  TechniqueMediaModel(
    title: "Training Video",
    url: "",
    type: "training_video",
    source: "IJF",
  ),

  TechniqueMediaModel(
    title: "Competition Video",
    url: "",
    type: "competition_video",
    source: "IJF",
  ),

],



      description:

          "O Soto Gari is a major outer reap technique where the opponent is thrown backward using leg action.",



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
        "O Soto Gari is an Ashi Waza technique because the main action is performed with the leg.",
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
        "The opponent is mainly thrown backward using an outer leg reap.",
  ),

],


      sources: [


        "IJF",


        "Kodokan Judo Institute",


      ],


    ),



  ];


}