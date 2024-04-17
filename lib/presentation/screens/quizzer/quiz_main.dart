import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_question.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_start.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_handler.dart';
import 'package:lebenswiki_app/presentation/widgets/buttons/buttons.dart';

class Question {
  final String questionText;
  final List<PackPageItemContent> answers;
  late Map<GyroDirection, PackPageItemContent> directionToAnswerMap;

  Question({required this.questionText, required this.answers}) {
    answers.shuffle();
    directionToAnswerMap = {
      GyroDirection.top: answers[0],
      GyroDirection.right: answers[1],
      GyroDirection.bottom: answers[2],
      GyroDirection.left: answers[3],
    };
  }
}

class Quizzer extends StatefulWidget {
  // final PackPage packPage;
  final String quizId;

  const Quizzer({
    super.key,
    // required this.packPage,
    required this.quizId,
  });

  @override
  State<Quizzer> createState() => _QuizzerState();
}

class _QuizzerState extends State<Quizzer> {
  GyroDirection direction = GyroDirection.none;
  int wrongTries = 0;
  // late CustomTimer customTimer;
  GyroHandler? gyroHandler;
  String centerText = "";
  late List<Question> questions;
  int timeLeft = 5;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // gyroHandler = GyroHandler(
    //   updateDirectionCallback: (GyroDirection newDirection) {
    //     setState(() => direction = newDirection);
    //     answerEvent(newDirection);
    //   },
    //   timeBetweenDetections: 2,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: PackApi().getQuiz(widget.quizId),
          builder:
              (context, AsyncSnapshot<Either<CustomError, PackPage>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isLeft) {
              return const Center(
                  child: Text("Quiz konnte nicht gefunden werden"));
            }
            PackPage page = snapshot.data!.right;
            List<PackPageItem> onlyQuestionItems = page.items
                .where((item) => item.type == ItemType.question)
                .toList();
            questions = onlyQuestionItems
                .map((PackPageItem item) => Question(
                      questionText: item.headContent.value,
                      answers: item.bodyContent,
                    ))
                .toList();
            return StatefulBuilder(builder: (context, setInnerState) {
              gyroHandler ??= GyroHandler(
                updateDirectionCallback: (GyroDirection newDirection) {
                  setInnerState(() => direction = newDirection);
                  answerEvent(setInnerState, newDirection);
                },
                timeBetweenDetections: 2,
              );
              return PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  StartPage(
                      title: page.items
                          .where((e) => e.type == ItemType.title)
                          .first
                          .headContent
                          .value,
                      nextPage: () => nextQuestion(setInnerState)),
                  ...questions.map(
                    (Question question) => QuizPageNew(
                      centerText: centerText,
                      direction: direction,
                      directionAnswers: question.directionToAnswerMap,
                    ),
                  ),
                  endPage(),
                ],
              );
            });
          }),
    );
  }

  Widget endPage() => Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            child: SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  starIcon(true, 80.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: starIcon(wrongTries < 5, 100.0),
                  ),
                  starIcon(wrongTries < 2, 80.0)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Klasse!",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 35,
                color: Colors.black87,
              )),
          const SizedBox(height: 50),
          SizedBox(
            width: 500,
            child: Column(
              children: [
                SizedBox(
                  width: 230,
                  child:
                      const LWButtons().purpleButton("Ich will nochmal!", () {
                    setState(() {
                      direction = GyroDirection.none;
                      wrongTries = 0;
                    });
                    _pageController.jumpToPage(0);
                  }),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 230,
                  child: const LWButtons().outlineButton(
                      "Zurück zum Pack", () => Navigator.pop(context)),
                ),
              ],
            ),
          ),
        ],
      );

  Widget starIcon(bool filled, double size) => Icon(
        filled ? Icons.star_rounded : Icons.star_border_rounded,
        size: size,
        color: Colors.yellow,
      );

  void nextQuestion(Function setInnerState) {
    int nextPageIndex = _pageController.page!.toInt() + 1;
    bool endNotReached = nextPageIndex <= questions.length;
    if (endNotReached) {
      setInnerState(() {
        direction = GyroDirection.none;
        centerText = questions[nextPageIndex - 1].questionText;
      });
    }
    _pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void resetQuestion(Function setInnerState) {
    setInnerState(() {
      direction = GyroDirection.none;
      centerText = questions[_pageController.page!.toInt() - 1].questionText;
    });
  }

  void answerEvent(Function setInnerState, GyroDirection newDirection) async {
    setInnerState(() => direction = newDirection);
    if (newDirection == GyroDirection.none) {
      return;
    }
    Question question = questions[_pageController.page!.toInt() - 1];
    if (question.directionToAnswerMap[newDirection]!.isCorrectAnswer == true) {
      setInnerState(() {
        centerText = "Bravo!";
      });
      await Future.delayed(const Duration(milliseconds: (1000)));
      nextQuestion(setInnerState);
    } else {
      setInnerState(() {
        centerText = "Versuchs Nochmal";
        wrongTries++;
      });
      await Future.delayed(const Duration(milliseconds: 1000));
      resetQuestion(setInnerState);
    }
  }

  // Widget _buildTimer() => Column(
  //       children: [
  //         Center(
  //           child: SizedBox(
  //             width: 100,
  //             height: 100,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 5,
  //               value: 100 / 50000 * timeLeft,
  //               strokeAlign: CircularProgressIndicator.strokeAlignInside,
  //               backgroundColor: Colors.purple,
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(top: 50),
  //           child: TextButton(
  //             child: const Text("Toggle Timer"),
  //             onPressed: () {
  //               // timer =
  //               //     Timer.periodic(const Duration(milliseconds: 10), (timer) {
  //               //   if (timeLeft == 0) {
  //               //     timer.cancel();
  //               //     return;
  //               //   }

  //               //   setState(() {
  //               //     timeLeft--;
  //               //     totalTimeSpent += 10;
  //               //   });
  //               // });
  //               // timer =
  //               //     Timer(Duration(milliseconds: 5000), () => {print("done")});

  //               print("Toggling timer");
  //               // quizTimer.isRunning ? quizTimer.stop() : quizTimer.start();
  //             },
  //           ),
  //         ),
  //       ],
  //     );
}
