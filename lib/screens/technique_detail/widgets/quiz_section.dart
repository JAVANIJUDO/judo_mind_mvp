import 'package:flutter/material.dart';
import '../../../models/quiz_model.dart';


class QuizSection extends StatefulWidget {

  final List<QuizModel> quizzes;


  const QuizSection({
    super.key,
    required this.quizzes,
  });


  @override
  State<QuizSection> createState() => _QuizSectionState();

}


class _QuizSectionState extends State<QuizSection> {


  int currentQuestion = 0;

  int? selectedAnswer;

  int score = 0;

  bool answered = false;

  bool finished = false;



  void checkAnswer() {

    if (selectedAnswer == null) return;


    setState(() {

      answered = true;

      if (selectedAnswer ==
          widget.quizzes[currentQuestion].correctAnswerIndex) {

        score++;

      }

    });

  }



  void nextQuestion() {


    if (currentQuestion <
        widget.quizzes.length - 1) {


      setState(() {

        currentQuestion++;

        selectedAnswer = null;

        answered = false;

      });


    } else {


      setState(() {

        finished = true;

      });


    }

  }



  void restartQuiz() {

    setState(() {

      currentQuestion = 0;

      selectedAnswer = null;

      score = 0;

      answered = false;

      finished = false;

    });

  }




  @override
  Widget build(BuildContext context) {


    if (widget.quizzes.isEmpty) {

      return const SizedBox();

    }



    if (finished) {

      return _ResultCard(
        score: score,
        total: widget.quizzes.length,
        onRestart: restartQuiz,
      );

    }



    final quiz = widget.quizzes[currentQuestion];



    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [


        const Text(

          "Technique Quiz",

          style: TextStyle(

            color: Colors.white,

            fontSize: 24,

            fontWeight: FontWeight.bold,

          ),

        ),


        const SizedBox(height: 15),



        Text(

          "Question ${currentQuestion + 1}/${widget.quizzes.length}",

          style: const TextStyle(

            color: Color(0xFF0066FF),

            fontWeight: FontWeight.bold,

          ),

        ),



        const SizedBox(height: 15),



        Container(

          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(

            color: const Color(0xFF111111),

            borderRadius: BorderRadius.circular(18),

          ),


          child: Text(

            quiz.question,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 17,

              height: 1.4,

            ),

          ),

        ),



        const SizedBox(height: 15),



        ...List.generate(

          quiz.options.length,

          (index) {


            final bool isCorrect =
                index == quiz.correctAnswerIndex;


            final bool isSelected =
                selectedAnswer == index;



            Color? tileColor;


            if (answered && isCorrect) {

              tileColor = Colors.green.withOpacity(0.25);

            }


            if (answered &&
                isSelected &&
                !isCorrect) {

              tileColor = Colors.red.withOpacity(0.25);

            }



            return Container(

              margin: const EdgeInsets.only(bottom: 8),

              decoration: BoxDecoration(

                color: tileColor ??
                    const Color(0xFF111111),

                borderRadius:
                    BorderRadius.circular(14),

              ),


              child: RadioListTile<int>(

                value: index,

                groupValue: selectedAnswer,

                activeColor:
                    const Color(0xFF0066FF),


                onChanged: answered

                    ? null

                    : (value) {

                        setState(() {

                          selectedAnswer = value;

                        });

                      },


                title: Text(

                  quiz.options[index],

                  style: const TextStyle(

                    color: Colors.white70,

                  ),

                ),

              ),

            );

          },

        ),



        if (answered)

          Container(

            margin:
                const EdgeInsets.only(top: 10),

            padding:
                const EdgeInsets.all(15),

            decoration: BoxDecoration(

              color:
                  const Color(0xFF111111),

              borderRadius:
                  BorderRadius.circular(15),

            ),


            child: Text(

              quiz.explanation,

              style: const TextStyle(

                color: Colors.white70,

                height: 1.5,

              ),

            ),

          ),



        const SizedBox(height: 15),



        SizedBox(

          width: double.infinity,

          child: ElevatedButton(

            onPressed:

                answered

                    ? nextQuestion

                    : checkAnswer,


            child: Text(

              answered

                  ? "Next Question"

                  : "Submit Answer",

            ),

          ),

        ),



        const SizedBox(height: 15),



        Text(

          "Score: $score",

          style: const TextStyle(

            color: Color(0xFFD4AF37),

            fontSize: 16,

            fontWeight: FontWeight.bold,

          ),

        ),


      ],

    );

  }

}





class _ResultCard extends StatelessWidget {


  final int score;

  final int total;

  final VoidCallback onRestart;



  const _ResultCard({

    required this.score,

    required this.total,

    required this.onRestart,

  });



  @override

  Widget build(BuildContext context) {


    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(

        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(

          color: const Color(0xFFD4AF37),

        ),

      ),


      child: Column(

        children: [


          const Text(

            "Quiz Completed",

            style: TextStyle(

              color: Colors.white,

              fontSize: 25,

              fontWeight: FontWeight.bold,

            ),

          ),



          const SizedBox(height: 15),



          Text(

            "$score / $total",

            style: const TextStyle(

              color: Color(0xFFD4AF37),

              fontSize: 32,

              fontWeight: FontWeight.bold,

            ),

          ),



          const SizedBox(height: 20),



          ElevatedButton(

            onPressed: onRestart,

            child: const Text(

              "Restart Quiz",

            ),

          ),

        ],

      ),

    );

  }

}