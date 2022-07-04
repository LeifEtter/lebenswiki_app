import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  final Widget child;

  const CommentInput({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromRGBO(245, 245, 247, 1),
      ),
      child: widget.child,
    );
  }
}
