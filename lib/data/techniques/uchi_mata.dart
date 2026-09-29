import 'uchi_mata_visual_learning.dart';
import '../../models/technique_model.dart';
import '../../models/quiz_model.dart';
import '../../models/technique_translation.dart';

const TechniqueModel uchiMata = TechniqueModel(
  id: "001",

  englishName: "Uchi Mata",

  japaneseName: "内股",

  category: "Nage Waza",

  type: "Ashi Waza",

  beltLevel: "Advanced",

  difficulty: "Advanced",

  description:
      "Uchi Mata is one of the most famous Ashi Waza techniques. The judoka lifts and rotates the opponent using the inner thigh while controlling balance.",

  technicalAnalysis:
      "Successful Uchi Mata requires three fundamental phases of Kodokan Judo: Kuzushi, Tsukuri and Kake. Proper distance, sleeve control, timing and rotation are essential.",

  translations: [
    TechniqueTranslation(
      languageCode: "en",

      name: "Uchi Mata",

      description:
          "An inner thigh throw where the attacker lifts and rotates the opponent using the attacking leg.",

      technicalAnalysis:
          "Requires precise kuzushi, correct entry, strong grips and explosive rotation.",

      executionSteps: [
        "Break the opponent's balance forward.",

        "Enter with correct distance and posture.",

        "Lift using the inner thigh.",

        "Rotate and complete the throw.",
      ],

      keyPoints: [
        "Strong sleeve and lapel control",

        "Correct entry angle",

        "Timing before strength",
      ],

      commonMistakes: [
        "Attacking without kuzushi",

        "Entering too far away",

        "Using only leg power",
      ],

      safetyTips: [
        "Control the opponent's landing",

        "Practice progressive drills",
      ],
    ),

    TechniqueTranslation(
      languageCode: "fa",

      name: "اوچی ماتا",

      description:
          "یکی از معروف‌ترین فنون آشی وازا که با استفاده از داخل ران، حریف بلند شده و با چرخش به زمین منتقل می‌شود.",

      technicalAnalysis:
          "اجرای صحیح اوچی ماتا نیازمند کازوشی، ورود مناسب، کنترل گیری و زمان‌بندی دقیق است.",

      executionSteps: [
        "با برهم‌زدن تعادل حریف به جلو، کوزوشی ایجاد کنید",

        "با حالت بدنی و فاصله صحیح، نزدیک وارد شوید",

        "پای حمله‌کننده را در بخش داخلی ران حریف جای دهید",

        "حریف را با حرکتی پیوسته بلند کنید و بچرخانید",

        "پرتاب را با حفظ کنترل کامل کنید",
      ],

      keyPoints: [
        "کنترل قوی آستین و یقه",

        "جای‌گیری صحیح بدن",

        "عمل بلندکردن انفجاری",

        "زمان‌بندی دقیق",

        "چرخش پیوسته",
      ],

      commonMistakes: [
        "تلاش برای پرتاب بدون کوزوشی",

        "ورود از فاصله بیش‌ازحد دور",

        "استفاده صرف از قدرت پا",

        "کنترل ضعیف بالاتنه",

        "توقف زودهنگام چرخش",
      ],

      safetyTips: [
        "کنترل فرود حریف",
        "پرهیز از چرخش کنترل‌نشده",
        "یادگیری حرکت به‌صورت تدریجی",
        "تمرین صحیح اوکمی",
      ],

      combinations: [
        "کو‌اوچی‌گاری → اوچی‌ماتا",
        "او‌اوچی‌گاری → اوچی‌ماتا",
        "ساسائه‌تسوریکومی‌آشی → اوچی‌ماتا",
        "اوچی‌ماتا → نه‌وازا",
      ],

      counters: [
        "اوچی‌ماتا سوکاشی",
        "اوچی‌ماتا گائشی",
        "مهار پای حمله‌کننده",
        "دور کردن لگن از مسیر حمله",
      ],
    ),

    TechniqueTranslation(
      languageCode: "ja",

      name: "内股",

      description: "内股は相手を内腿で持ち上げ、回転させて投げる足技です。",

      technicalAnalysis: "正確な崩し、作り、掛けのタイミングが重要です。",
    ),
  ],

  images: ["assets/images/techniques/uchi_mata.png"],

  videos: [
    "https://www.youtube.com/results?search_query=IJF+Uchi+Mata+official",

    "https://www.youtube.com/results?search_query=Uchi+Mata+World+Judo+Tour",
  ],

  trainingVideo:
      "https://www.youtube.com/results?search_query=Uchi+Mata+training+drills",

  competitionVideo:
      "https://www.youtube.com/results?search_query=Uchi+Mata+competition+analysis",

  visualLearningPlan: uchiMataVisualLearningPlan,

  supportsReviewedSingleAttemptV2A: true,

  supportsEducationalPracticeGuidance: true,

  executionSteps: [
    "Create kuzushi by breaking the opponent's balance forward.",

    "Enter close with correct posture and distance.",

    "Position the attacking leg inside the opponent's thigh.",

    "Lift and rotate the opponent with continuous movement.",

    "Complete the throw while maintaining control.",
  ],

  keyPoints: [
    "Strong sleeve and lapel grip control",

    "Correct body positioning",

    "Explosive lifting action",

    "Precise timing",

    "Continuous rotation",
  ],

  commonMistakes: [
    "Trying to throw without kuzushi",

    "Entering too far from the opponent",

    "Using only leg strength",

    "Poor upper body control",

    "Stopping rotation too early",
  ],

  safetyTips: [
    "Control the opponent during landing",

    "Avoid uncontrolled rotation",

    "Learn the movement progressively",

    "Use proper Ukemi practice",
  ],

  combinations: [
    "Ko Uchi Gari → Uchi Mata",

    "Ouchi Gari → Uchi Mata",

    "Sasae Tsurikomi Ashi → Uchi Mata",

    "Uchi Mata → Newaza",
  ],

  counters: [
    "Uchi Mata Sukashi",

    "Uchi Mata Gaeshi",

    "Blocking the attacking leg",

    "Moving hips away from attack",
  ],

  quiz: [
    QuizModel(
      id: "uchi_mata_q1",

      question: "What category does Uchi Mata belong to?",

      options: ["Te Waza", "Ashi Waza", "Sutemi Waza", "Kansetsu Waza"],

      correctAnswerIndex: 1,

      explanation:
          "Uchi Mata is classified as Ashi Waza (foot/leg techniques).",

      difficulty: "Beginner",

      points: 10,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "اوچی‌ماتا در کدام گروه قرار می‌گیرد؟",
          options: [
            "ته‌وازا (فنون دست)",
            "آشی‌وازا (فنون پا)",
            "سوتمی‌وازا (فنون فداشونده)",
            "کانستسو‌وازا (فنون قفل مفصل)",
          ],
          explanation: "اوچی‌ماتا در گروه آشی‌وازا، یعنی فنون پا، قرار دارد.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q2",

      question: "What is the Japanese name of Uchi Mata?",

      options: ["背負投", "内股", "大外刈", "払腰"],

      correctAnswerIndex: 1,

      explanation: "The Japanese name of Uchi Mata is 内股.",

      difficulty: "Beginner",

      points: 10,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "نام ژاپنی اوچی‌ماتا کدام است؟",
          options: ["背負投", "内股", "大外刈", "払腰"],
          explanation: "نام ژاپنی اوچی‌ماتا 内股 است.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q3",

      question:
          "Which phase creates the opponent's imbalance before the throw?",

      options: ["Kake", "Kuzushi", "Ukemi", "Shime"],

      correctAnswerIndex: 1,

      explanation:
          "Kuzushi is the breaking of balance before executing the throw.",

      difficulty: "Intermediate",

      points: 10,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "کدام مرحله پیش از پرتاب، تعادل حریف را برهم می‌زند؟",
          options: ["کاکه", "کوزوشی", "اوکِمی", "شیمه"],
          explanation: "کوزوشی مرحله برهم‌زدن تعادل پیش از اجرای پرتاب است.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q4",

      question:
          "Which body part performs the main lifting action in Uchi Mata?",

      options: ["Shoulder", "Inner Thigh", "Hand", "Foot Sole"],

      correctAnswerIndex: 1,

      explanation: "The inner thigh performs the main lifting action.",

      difficulty: "Intermediate",

      points: 10,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "در اوچی‌ماتا کدام بخش بدن نقش اصلی را در بلندکردن دارد؟",
          options: ["شانه", "داخل ران", "دست", "کف پا"],
          explanation: "داخل ران، حرکت اصلی بلندکردن را انجام می‌دهد.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q5",

      question: "Which technique is commonly combined with Uchi Mata?",

      options: ["Ko Uchi Gari", "Juji Gatame", "Kesa Gatame", "Tomoe Nage"],

      correctAnswerIndex: 0,

      explanation: "Ko Uchi Gari is a common combination with Uchi Mata.",

      difficulty: "Intermediate",

      points: 10,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "کدام تکنیک معمولاً با اوچی‌ماتا ترکیب می‌شود؟",
          options: ["کوئوچی‌گاری", "جوجی‌گاتامه", "کساگاتامه", "توموئه‌ناگه"],
          explanation: "کوئوچی‌گاری یکی از ترکیب‌های رایج اوچی‌ماتا است.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q6",

      question: "Which element is essential for successful Uchi Mata?",

      options: [
        "Only strength",

        "Timing and kuzushi",

        "Holding breath",

        "Slow movement",
      ],

      correctAnswerIndex: 1,

      explanation: "Timing and kuzushi are fundamental for the technique.",

      difficulty: "Advanced",

      points: 15,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "کدام عامل برای اجرای موفق اوچی‌ماتا ضروری است؟",
          options: ["فقط قدرت", "زمان‌بندی و کوزوشی", "حبس نفس", "حرکت آهسته"],
          explanation: "زمان‌بندی و کوزوشی از پایه‌های اصلی اجرای تکنیک هستند.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q7",

      question: "Uchi Mata belongs to which main Kodokan classification?",

      options: ["Nage Waza", "Katame Waza", "Atemi Waza", "Kappo"],

      correctAnswerIndex: 0,

      explanation: "Uchi Mata is a throwing technique under Nage Waza.",

      difficulty: "Beginner",

      points: 10,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "اوچی‌ماتا در کدام طبقه‌بندی اصلی کودوکان قرار دارد؟",
          options: ["ناگه‌وازا", "کاتامه‌وازا", "آتِمی‌وازا", "کاپّو"],
          explanation: "اوچی‌ماتا یک فن پرتابی در گروه ناگه‌وازا است.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q8",

      question: "What is a common mistake during Uchi Mata?",

      options: [
        "Proper kuzushi",

        "Correct entry distance",

        "Using only leg power",

        "Good grip control",
      ],

      correctAnswerIndex: 2,

      explanation: "Using only strength without timing is a common mistake.",

      difficulty: "Advanced",

      points: 15,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "کدام مورد یک خطای رایج در اوچی‌ماتا است؟",
          options: [
            "کوزوشی درست",
            "فاصله ورود درست",
            "استفاده فقط از نیروی پا",
            "کنترل درست گرفتن",
          ],
          explanation: "تکیه بر قدرت بدون زمان‌بندی، خطایی رایج است.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q9",

      question: "Which technique is a known counter to Uchi Mata?",

      options: ["Uchi Mata Sukashi", "Seoi Nage", "O Soto Gari", "Tai Otoshi"],

      correctAnswerIndex: 0,

      explanation: "Uchi Mata Sukashi is one of the classic counters.",

      difficulty: "Advanced",

      points: 15,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "کدام تکنیک یک ضدحمله شناخته‌شده برای اوچی‌ماتا است؟",
          options: [
            "اوچی‌ماتا سوکاشی",
            "سئوی‌ناگه",
            "اوسوتوگاری",
            "تای‌اوتوشی",
          ],
          explanation: "اوچی‌ماتا سوکاشی یکی از ضدحمله‌های کلاسیک است.",
        ),
      ],
    ),

    QuizModel(
      id: "uchi_mata_q10",

      question: "Which three phases describe classical throwing execution?",

      options: [
        "Grip, Hold, Lock",

        "Kuzushi, Tsukuri, Kake",

        "Run, Jump, Land",

        "Push, Pull, Stop",
      ],

      correctAnswerIndex: 1,

      explanation: "Kuzushi, Tsukuri and Kake are the three classical phases.",

      difficulty: "Elite",

      points: 20,

      translations: [
        QuizTranslation(
          languageCode: "fa",
          question: "سه مرحله کلاسیک اجرای پرتاب کدام‌اند؟",
          options: [
            "گرفتن، نگه‌داشتن، قفل‌کردن",
            "کوزوشی، تسوکوری، کاکه",
            "دویدن، پریدن، فرودآمدن",
            "هل‌دادن، کشیدن، ایستادن",
          ],
          explanation: "کوزوشی، تسوکوری و کاکه سه مرحله کلاسیک هستند.",
        ),
      ],
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

    TechniqueSource(title: "European Judo Union", url: "https://www.eju.net"),
  ],
);
