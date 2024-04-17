import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_explanation.dart';
import 'package:lebenswiki_app/presentation/widgets/buttons/buttons.dart';

class StartPage extends StatefulWidget {
  final String title;
  final Function nextPage;

  const StartPage({super.key, required this.title, required this.nextPage});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int timer = 3;
  bool countingDown = false;

  void countDownTimer() async {
    setState(() => countingDown = true);
    while (timer > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => timer = timer - 1);
    }
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return !countingDown
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(height: 50),
              SizedBox(
                width: 230,
                child:
                    const LWButtons().purpleButton("Starten", countDownTimer),
              ),
              Container(height: 20),
              SizedBox(
                width: 230,
                child: const LWButtons().purpleButton(
                    "Wie Funktionierts?",
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuizExplanation()),
                        )),
              ),
            ],
          )
        : Center(
            child: Text(timer.toString(),
                style: const TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                )),
          );
  }
}
