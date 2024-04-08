import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/custom_timer.dart';
import 'package:lebenswiki_app/domain/models/quiz.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_question.dart';

class Quizzer extends StatefulWidget {
  const Quizzer({super.key});

  @override
  State<Quizzer> createState() => _QuizzerState();
}

class _QuizzerState extends State<Quizzer> {
  final PageController pageController = PageController();
  GyroDirection direction = GyroDirection.none;
  late CustomTimer customTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          // StartPage(
          //   nextPage: () => {
          //     pageController.nextPage(
          //         duration: const Duration(milliseconds: 250),
          //         curve: Curves.easeInOut),
          //   },
          // ),
          QuizPage(
            correctAnswerCallback: onCorrectAnswer,
            quizQuestion: QuizQuestion(
              correctAnswer: "Einkommenssteuer",
              wrongAnswers: [
                "Mehrwertsteuer",
                "Abgeltungssteuer",
                "Gewerbesteuer"
              ],
              question: "Welche Steuer ist am wichtigsten für Studenten?",
            ),
          ),
          QuizPage(
            correctAnswerCallback: onCorrectAnswer,
            quizQuestion: QuizQuestion(
              correctAnswer: "Fondue",
              wrongAnswers: ["Pfannkuchen", "Raclette", "Apfel"],
              question: "Was ist mein Lieblingsessen?",
            ),
          ),
        ],
      ),
    );
  }

  void onCorrectAnswer(int duration) {
    pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
