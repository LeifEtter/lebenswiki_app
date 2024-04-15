import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/custom_timer.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_question.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_start.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_handler.dart';

class Quizzer extends StatefulWidget {
  final PackPage packPage;

  const Quizzer({
    super.key,
    required this.packPage,
  });

  @override
  State<Quizzer> createState() => _QuizzerState();
}

class _QuizzerState extends State<Quizzer> {
  GyroDirection direction = GyroDirection.none;
  late CustomTimer customTimer;
  late List<PackPageItem> quizQuestions;
  late GyroHandler gyroHandler;
  late PackPageItem currentQuestion;
  String centerText = "Frage";
  late Map<GyroDirection, PackPageItemContent> directionAnswerMap;
  int currentIndex = 0;
  int timeLeft = 5;

  @override
  void initState() {
    quizQuestions = widget.packPage.items
        .where((item) => item.type == ItemType.question)
        .toList();
    gyroHandler = GyroHandler(
        updateDirectionCallback: (GyroDirection newDirection) {
          setState(() => direction = newDirection);
          answerEvent(newDirection);
        },
        timeBetweenDetections: 2);
    super.initState();
  }

  void changeQuestion(int newIndex) {
    print(newIndex);
    if (newIndex > quizQuestions.length + 1) {
      print("Quiz done");
      return;
    }
    PackPageItem newQuestion = quizQuestions[newIndex];
    setState(() {
      currentIndex = newIndex;
      currentQuestion = newQuestion;
      centerText = newQuestion.headContent.value;
      directionAnswerMap = {
        GyroDirection.top: newQuestion.bodyContent[0],
        GyroDirection.right: newQuestion.bodyContent[1],
        GyroDirection.bottom: newQuestion.bodyContent[2],
        GyroDirection.left: newQuestion.bodyContent[3],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    currentQuestion = quizQuestions[currentIndex];
    return Scaffold(
      body: currentIndex == 0
          ? StartPage(
              nextPage: () => changeQuestion(1),
            )
          : QuizPageNew(
              centerText: centerText,
              direction: direction,
              directionAnswers: directionAnswerMap,
            ),
    );
  }

  void answerEvent(GyroDirection newDirection) async {
    setState(() => direction = newDirection);
    if (newDirection == GyroDirection.none) {
      return;
    }
    if (directionAnswerMap[newDirection]!.isCorrectAnswer != null &&
        directionAnswerMap[newDirection]!.isCorrectAnswer == true) {
      setState(() => centerText = "Bravo!");
      await Future.delayed(const Duration(milliseconds: (2000)));
      changeQuestion(currentIndex += 1);
    } else {
      setState(() {
        centerText = "Versuchs Nochmal";
      });
      await Future.delayed(const Duration(milliseconds: 2000));
      setState(() {
        centerText = currentQuestion.headContent.value;
      });
    }
  }

  // void onCorrectAnswer(int duration) {
  //   pageController.nextPage(
  //       duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  // }

  Widget _buildTimer() => Column(
        children: [
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                value: 100 / 50000 * timeLeft,
                strokeAlign: CircularProgressIndicator.strokeAlignInside,
                backgroundColor: Colors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: TextButton(
              child: const Text("Toggle Timer"),
              onPressed: () {
                // timer =
                //     Timer.periodic(const Duration(milliseconds: 10), (timer) {
                //   if (timeLeft == 0) {
                //     timer.cancel();
                //     return;
                //   }

                //   setState(() {
                //     timeLeft--;
                //     totalTimeSpent += 10;
                //   });
                // });
                // timer =
                //     Timer(Duration(milliseconds: 5000), () => {print("done")});

                print("Toggling timer");
                // quizTimer.isRunning ? quizTimer.stop() : quizTimer.start();
              },
            ),
          ),
        ],
      );
}
