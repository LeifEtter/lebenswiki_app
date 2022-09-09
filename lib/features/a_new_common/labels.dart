import 'package:flutter/material.dart';

class InfoLabel extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double fontSize;

  const InfoLabel({
    Key? key,
    required this.text,
    required this.backgroundColor,
    this.fontSize = 13,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              letterSpacing: 0.5,
              fontSize: fontSize,
            ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: backgroundColor,
      ),
    );
  }
}
