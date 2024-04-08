import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  final Function nextPage;

  const StartPage({super.key, required this.nextPage});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int timer = 5;
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
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Quiz Titel"),
                const Text("Deine Bestzeit"),
                TextButton(
                  onPressed: () {
                    print("Starting Timer");
                    countDownTimer();
                  },
                  child: const Text("Starten"),
                ),
              ],
            ),
          )
        : Center(
            child: Text(timer.toString()),
          );
  }
}
