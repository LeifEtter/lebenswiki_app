// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar extends StatelessWidget {
  late final Color color;
  late final Icon icon;
  final String message;

  CustomFlushbar({
    required this.message,
    Key? key,
  }) : super(key: key);

  CustomFlushbar.error({
    required this.message,
    Key? key,
  }) : super(key: key) {
    icon = const Icon(
      Icons.info_outline,
      color: Colors.white,
    );
    color = const Color.fromRGBO(225, 85, 76, 1);
  }

  CustomFlushbar.success({
    Key? key,
    required this.message,
  }) : super(key: key) {
    icon = const Icon(
      Icons.check_circle_outline,
      color: Colors.white,
    );
    color = const Color.fromRGBO(94, 182, 129, 1);
  }
  CustomFlushbar.undo({
    Key? key,
    required this.message,
  }) : super(key: key) {
    icon = const Icon(
      Icons.info_outline,
      color: Colors.white,
    );
    color = const Color.fromRGBO(72, 72, 72, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void show(BuildContext context) {
    flush(context).show(context);
  }

  Flushbar flush(context) => Flushbar(
        backgroundColor: color,
        icon: icon,
        flushbarStyle: FlushbarStyle.FLOATING,
        isDismissible: true,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(vertical: 23.0, horizontal: 20.0),
        borderRadius: BorderRadius.circular(8),
        message: message,
        messageSize: 18.0,
        duration: const Duration(milliseconds: 3000),
        mainButton: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      );
}
