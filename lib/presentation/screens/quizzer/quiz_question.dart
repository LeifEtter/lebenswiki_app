import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/quiz.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_handler.dart';


class QuizPage extends StatefulWidget {
  final QuizQuestion quizQuestion;
  final Function correctAnswerCallback;

  const QuizPage({
    super.key,
    required this.quizQuestion,
    required this.correctAnswerCallback,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  GyroDirection direction = GyroDirection.none;
  late CustomTimer quizTimer;
  late GyroHandler gyroHandler;
  Timer? timer;
  String? currentColor;
  late Map<GyroDirection, String> directionAnswers;
  late String centerText;

  int timeLeft = 500;
  int totalTimeSpent = 0;

  @override
  void initState() {
    centerText = widget.quizQuestion.question;
    directionAnswers = {
      GyroDirection.top: widget.quizQuestion.answers[0],
      GyroDirection.right: widget.quizQuestion.answers[1],
      GyroDirection.bottom: widget.quizQuestion.answers[2],
      GyroDirection.left: widget.quizQuestion.answers[3]
    };
    quizTimer = CustomTimer();
    gyroHandler = GyroHandler(
        updateDirectionCallback: answerEvent, timeBetweenDetections: 2);

    super.initState();
  }

  void answerEvent(GyroDirection newDirection) async {
    print(newDirection);
    setState(() => direction = newDirection);
    if (newDirection == GyroDirection.none) {
      return;
    }
    if (widget.quizQuestion.isAnswerCorrect(directionAnswers[newDirection])) {
      print("Doing");
      setState(() => centerText = "Bravo!");
      await Future.delayed(const Duration(milliseconds: (2000)));
      widget.correctAnswerCallback(5);
    } else {
      print("Failed");
      setState(() {
        centerText = "Versuchs Nochmal";
      });
      await Future.delayed(const Duration(milliseconds: 2000));
      setState(() {
        centerText = widget.quizQuestion.question;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: Text(
                centerText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          ...directionAnswers.keys.map((GyroDirection answerDirection) {
            String answer = directionAnswers[answerDirection]!;
            return _buildAnswerBox(
              answerDirection,
              answer,
              direction == answerDirection
                  ? (widget.quizQuestion.isAnswerCorrect(answer)
                      ? Colors.green
                      : Colors.red)
                  : null,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerBox(
      GyroDirection direction, String answer, Color? backgroundColor) {
    AlignmentGeometry alignment;
    if (direction == GyroDirection.top) {
      alignment = Alignment.topCenter;
    } else if (direction == GyroDirection.bottom) {
      alignment = Alignment.bottomCenter;
    } else if (direction == GyroDirection.left) {
      alignment = Alignment.centerLeft;
    } else {
      alignment = Alignment.centerRight;
    }
    return Align(
      alignment: alignment,
      child: Container(
        width:
            direction == GyroDirection.top || direction == GyroDirection.bottom
                ? 400
                : 50,
        height:
            direction == GyroDirection.top || direction == GyroDirection.bottom
                ? 50
                : 400,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(color: backgroundColor),
            )),
            Align(
              child: RotatedBox(
                quarterTurns: direction == GyroDirection.top ||
                        direction == GyroDirection.bottom
                    ? 0
                    : 1,
                child: Text(answer),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
