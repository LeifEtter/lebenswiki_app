import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_explanation.dart';
import 'package:lebenswiki_app/presentation/widgets/buttons/buttons.dart';
import 'package:share_plus/share_plus.dart';

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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      String shareLink =
                          'http://leifetter.github.io${GoRouter.of(context).routeInformationProvider.value.uri}';
                      Share.share("Lust auf ein Quiz? $shareLink");
                    },
                    icon: const Icon(
                      Icons.file_upload_outlined,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 200,
                    child: Text(
                      "Teile das Quiz mit deinen Freunden!",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
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
