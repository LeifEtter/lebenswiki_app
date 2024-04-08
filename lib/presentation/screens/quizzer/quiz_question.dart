import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/custom_timer.dart';
import 'package:lebenswiki_app/domain/models/quiz.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum GyroDirection { none, top, right, bottom, left }

class GyroHandler {
  final Function(GyroDirection direction) updateDirectionCallback;
  late CustomTimer gyroTimer;
  final timeBetweenDetections;

  GyroHandler({
    required this.updateDirectionCallback,
    required this.timeBetweenDetections,
  }) {
    gyroTimer = CustomTimer();
    gyroscopeEventStream().listen(
      checkGyroForDirection,
      onError: (error) => print(error),
      cancelOnError: true,
    );
  }

  void checkGyroForDirection(GyroscopeEvent event) {
    if (gyroTimer.isRunning) {
      if (gyroTimer.isTimeElapsed(timeBetweenDetections)) {
        gyroTimer.stop();
        updateDirectionCallback(GyroDirection.none);
      } else {
        return;
      }
    }
    GyroDirection newDirection = computeGyroDirection(event.x, event.y);
    if (newDirection != GyroDirection.none) {
      gyroTimer.start();
      updateDirectionCallback(newDirection);
    }
  }

  GyroDirection computeGyroDirection(double x, double y) {
    if (x > 3 && x.abs() > y.abs()) {
      return GyroDirection.bottom;
    }
    if (x < -3 && x.abs() > y.abs()) {
      return GyroDirection.top;
    }
    if (y < -3 && y.abs() > x.abs()) {
      return GyroDirection.left;
    }
    if (y > 3 && y.abs() > x.abs()) {
      return GyroDirection.right;
    }
    return GyroDirection.none;
  }
}

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
