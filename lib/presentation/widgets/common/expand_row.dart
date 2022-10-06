import 'package:flutter/material.dart';

class ExpandButton extends StatelessWidget {
  final Widget child;

  const ExpandButton({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
      ],
    );
  }
}
