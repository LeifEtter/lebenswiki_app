import 'package:flutter/material.dart';

class LebenswikiBlueButton extends StatelessWidget {
  final String text;
  final Function callback;
  final List categories;

  const LebenswikiBlueButton({
    Key? key,
    required this.text,
    required this.callback,
    this.categories = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(115, 148, 192, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextButton(
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
        ),
        onPressed: () {
          categories.isNotEmpty ? callback(categories) : callback();
        },
      ),
    );
  }
}

class LebenswikiBlueButtonInverted extends StatelessWidget {
  final String text;
  final Function callback;

  const LebenswikiBlueButtonInverted({
    Key? key,
    required this.text,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextButton(
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(115, 148, 192, 1),
              fontSize: 14),
        ),
        onPressed: () => callback(),
      ),
    );
  }
}
