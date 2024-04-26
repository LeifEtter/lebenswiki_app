import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_handler.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_util.dart';
import 'package:lebenswiki_app/presentation/widgets/buttons/buttons.dart';

class QuizExplanation extends StatefulWidget {
  const QuizExplanation({super.key});

  @override
  State<QuizExplanation> createState() => _QuizExplanationState();
}

class _QuizExplanationState extends State<QuizExplanation> {
  late GyroHandler gyroHandler;
  GyroDirection currentDirection = GyroDirection.none;
  Color barColor = Colors.black12;
  String centerText = "";
  final PageController _pageController = PageController(initialPage: 0);

  Map<int, (GyroDirection, String)> pageDirections = {
    0: (GyroDirection.none, ""),
    1: (
      GyroDirection.right,
      "Rotiere dein Handy schnell nach Rechts \nund dann zurück"
    ),
    2: (GyroDirection.left, "Jetzt nach Links"),
    3: (GyroDirection.top, "Nach oben"),
    4: (GyroDirection.bottom, "Nach unten"),
    5: (GyroDirection.none, ""),
  };

  @override
  void initState() {
    GyroHandler(
        updateDirectionCallback: (GyroDirection newDirection) {
          setState(() => currentDirection = newDirection);
          print(newDirection);
          answerEvent(newDirection);
        },
        timeBetweenDetections: 1);
    super.initState();
  }

  void resetPage() {
    setState(() {
      currentDirection = GyroDirection.none;
      barColor = Colors.black12;
      centerText = pageDirections[_pageController.page!]!.$2;
    });
  }

  void nextPage() {
    (GyroDirection, String) pageData =
        pageDirections[_pageController.page! + 1]!;
    resetPage();
    setState(() {
      centerText = pageData.$2;
    });
    _pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void answerEvent(GyroDirection newDirection) async {
    if (newDirection != pageDirections[_pageController.page]!.$1) {
      setState(() {
        centerText = "Falsche Richtung.\nVersuchs nochmal";
      });
      await Future.delayed(const Duration(seconds: 1));
      resetPage();
      return;
    }
    setState(() {
      barColor = const Color.fromRGBO(122, 255, 127, 1.0);
      centerText = "Super Gemacht!";
    });
    await Future.delayed(const Duration(seconds: 2));
    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _startPage(),
          ...pageDirections.values.toList().getRange(1, 5).map(
                ((GyroDirection, String) e) => _tiltPage(
                  alignment: gyroDirectionToAlignment(e.$1),
                  color: barColor,
                  centerText: centerText,
                ),
              ),
          _endPage(),
        ],
      ),
    );
  }

  Widget _startPage() => Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
          child: Column(
            children: [
              const Text(
                "Einweisung",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 230,
                child: const LWButtons()
                    .purpleButton("Wie Funktionierts?", nextPage),
              ),
            ],
          ),
        ),
      );

  Widget _endPage() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Bereit for the real deal?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 230,
            child:
                const LWButtons().purpleButton("Zum Quiz", () => context.pop()),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 230,
            child: const LWButtons().outlineButton(
              "Erklär's mir nochmal",
              () {
                resetPage();
                _pageController.jumpToPage(0);
              },
            ),
          ),
        ],
      );

  Widget _tiltPage({
    required Alignment alignment,
    required Color color,
    required String centerText,
  }) =>
      Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 250,
                  child: Center(
                      child: Text(
                    centerText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  )))),
          Align(
            alignment: alignment,
            child: _tiltGoalBar(alignment, color),
          ),
        ],
      );

  Widget _tiltGoalBar(Alignment alignment, Color color) => SizedBox(
        width: alignmentIsHorizontal(alignment) ? 50 : 400,
        height: alignmentIsHorizontal(alignment) ? 400 : 50,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(color: color),
            )),
            Align(
              child: RotatedBox(
                quarterTurns: alignmentIsHorizontal(alignment) ? 0 : 1,
              ),
            ),
          ],
        ),
      );
}
