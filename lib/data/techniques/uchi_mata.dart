import '../../models/technique_model.dart';
import '../../models/quiz_model.dart';
import '../../models/technique_translation.dart';


const TechniqueModel uchiMata = TechniqueModel(

      id: "001",

      englishName: "Uchi Mata",

      japaneseName: "内股",


      category: "Nage Waza",

      beltLevel: "Advanced",

      difficulty: "Advanced",


      description:
          "Uchi Mata is an inner thigh throw where the judoka uses the inner thigh to lift and rotate the opponent while maintaining control.",


      technicalAnalysis:
          "Uchi Mata requires precise kuzushi, correct entry distance, strong sleeve and lapel control, and accurate timing. The throw is completed by lifting the opponent with the inner thigh while rotating the body.",

      translations: [

        TechniqueTranslation(

          languageCode: "en",

          name: "Uchi Mata",

          description:
              "Uchi Mata is an inner thigh throw using the attacking leg to lift and rotate the opponent.",

          technicalAnalysis:
              "Requires precise kuzushi, correct entry position and accurate timing.",

        ),


        TechniqueTranslation(

          languageCode: "fa",

          name: "اوچی ماتا",

          description:
              "پرتابی با استفاده از داخل ران که حریف را بلند کرده و با چرخش به زمین می‌زند.",

          technicalAnalysis:
              "نیازمند کازوشی دقیق، ورود صحیح، کنترل دست و زمان‌بندی مناسب است.",

        ),


        TechniqueTranslation(

          languageCode: "ar",

          name: "أوتشي ماتا",

          description:
              "رمي باستخدام الفخذ الداخلي لرفع الخصم وتدويره.",

          technicalAnalysis:
              "يتطلب كسر التوازن الصحيح والدخول المناسب والتوقيت الدقيق.",

        ),

      ],

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


      executionSteps: [

        "Create kuzushi by breaking the opponent's balance forward.",

        "Enter close and position the inner thigh correctly.",

        "Lift and rotate the opponent using the attacking leg.",

        "Complete the throw while maintaining control.",

      ],


      keyPoints: [

        "Strong sleeve control",

        "Correct hip positioning",

        "Explosive lifting action",

        "Precise timing",

      ],


      commonMistakes: [

        "Weak kuzushi",

        "Incorrect entry distance",

        "Poor sleeve control",

        "Using strength without timing",

      ],


      safetyTips: [

        "Control the opponent during landing.",

        "Avoid uncontrolled rotation.",

        "Practice progression drills before full throws.",

      ],


      combinations: [

        "Ko Uchi Gari → Uchi Mata",

        "Ouchi Gari → Uchi Mata",

        "Uchi Mata → Newaza",

      ],


      counters: [

        "Uchi Mata Sukashi",

        "Uchi Mata Gaeshi",

        "Blocking the attacking leg",

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
          explanation: "",

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
          explanation: "",

        ),

        QuizModel(

          question: "Which phase creates the opponent's imbalance before the throw?",

          options: [
            "Kake",
            "Kuzushi",
            "Ukemi",
            "Shime",
          ],

          correctAnswerIndex: 1,
          explanation: "",

        ),

        QuizModel(

          question: "Which body part performs the main lifting action?",

          options: [
            "Shoulder",
            "Inner Thigh",
            "Foot",
            "Arm",
          ],

          correctAnswerIndex: 1,
          explanation: "",

        ),

        QuizModel(

          question: "Which technique is commonly combined with Uchi Mata?",

          options: [
            "Ko Uchi Gari",
            "Tomoe Nage",
            "Juji Gatame",
            "Kesa Gatame",
          ],

          correctAnswerIndex: 0,
          explanation: "",

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

  