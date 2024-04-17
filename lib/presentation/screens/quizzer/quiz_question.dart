import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_handler.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_util.dart';

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
              width: MediaQuery.sizeOf(context).width * 0.65,
              child: Text(
                widget.centerText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
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
                      ? const Color.fromRGBO(122, 255, 127, 1.0)
                      : const Color.fromRGBO(250, 112, 112, 1.0))
                  : null,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerBox(
      GyroDirection direction, String answer, Color? backgroundColor) {
    return Align(
      alignment: gyroDirectionToAlignment(direction),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(242, 232, 254, 1.0),
          borderRadius: computeBordeRadius(direction, 20.0),
          boxShadow: [LebenswikiShadows.commentCardShadow],
        ),
        width: gyroDirectionIsHorizontal(direction) ? 50 : 300,
        height: gyroDirectionIsHorizontal(direction) ? 300 : 50,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: computeBordeRadius(direction, 20.0),
              ),
            )),
            Align(
              child: RotatedBox(
                quarterTurns: gyroDirectionIsHorizontal(direction) ? 1 : 0,
                child: Text(
                  answer,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BorderRadius computeBordeRadius(GyroDirection dir, double radAmount) {
    Radius rad = Radius.circular(radAmount);
    if (dir == GyroDirection.top) {
      return BorderRadius.only(bottomLeft: rad, bottomRight: rad);
    } else if (dir == GyroDirection.right) {
      return BorderRadius.only(topLeft: rad, bottomLeft: rad);
    } else if (dir == GyroDirection.bottom) {
      return BorderRadius.only(topLeft: rad, topRight: rad);
    } else {
      return BorderRadius.only(topRight: rad, bottomRight: rad);
    }
  }
}
