import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_handler.dart';

class QuizPageNew extends StatefulWidget {
  final String centerText;
  final GyroDirection direction;
  final Map<GyroDirection, PackPageItemContent> directionAnswers;

  const QuizPageNew({
    super.key,
    required this.centerText,
    required this.direction,
    required this.directionAnswers,
  });

  @override
  State<QuizPageNew> createState() => _QuizPageNewState();
}

class _QuizPageNewState extends State<QuizPageNew> {
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
                widget.centerText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          ...widget.directionAnswers.keys.map((GyroDirection answerDirection) {
            PackPageItemContent answer =
                widget.directionAnswers[answerDirection]!;
            return _buildAnswerBox(
              answerDirection,
              answer.value,
              widget.direction == answerDirection
                  ? (answer.isCorrectAnswer != null &&
                          answer.isCorrectAnswer == true
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
}
