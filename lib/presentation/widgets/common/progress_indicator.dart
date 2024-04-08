import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';

class ProgressIndicator extends StatefulWidget {
  final List<String> checkpointTitles;
  final Color color;
  final int currentIndex;

  const ProgressIndicator({
    Key? key,
    required this.checkpointTitles,
    required this.color,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
            child: Container(
              height: 2,
              width: double.infinity,
              color: Colors.blue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
            child: Row(
              children: [
                Container(
                  height: 2,
                  width: 150,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.checkpointTitles.length, (index) {
              return Column(
                children: [
                  index < widget.currentIndex
                      ? circleCompleted(index.toString())
                      : Container(),
                  index == widget.currentIndex
                      ? circleCurrent(index.toString())
                      : Container(),
                  index > widget.currentIndex
                      ? circleFuture(index.toString())
                      : Container(),
                  SizedBox(
                    width: 60,
                    child: Center(child: Text(widget.checkpointTitles[index])),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Container circleCurrent(String number) {
    return Container(
      width: 37,
      height: 37,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: widget.color,
          )),
      child: Center(
          child: Text(
        number,
        style: TextStyle(
          fontSize: 14,
          color: widget.color,
          fontWeight: FontWeight.w500,
        ),
      )),
    );
  }

  Container circleCompleted(String number) {
    return Container(
      width: 37,
      height: 37,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Container circleFuture(String number) {
    return Container(
      width: 37,
      height: 37,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.lightGrey,
        border: Border.all(width: 2, color: CustomColors.mediumDarkGrey),
      ),
      child: const Center(child: Text("3")),
    );
  }
}
