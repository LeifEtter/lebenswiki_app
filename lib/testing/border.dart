import 'package:flutter/material.dart';

class GiveBorder extends StatelessWidget {
  final Color color;
  final Widget child;

  const GiveBorder({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.0),
      ),
      child: child,
    );
  }
}
