import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {
  static Flushbar error({required String errorMessage}) => _default(
      icon: Icons.info_outline,
      message: errorMessage,
      color: const Color.fromRGBO(225, 85, 76, 1));

  static Flushbar success({required String errorMessage}) => _default(
      icon: Icons.check_circle_outline,
      message: errorMessage,
      color: const Color.fromRGBO(94, 182, 129, 1));

  static Flushbar _default({
    required IconData icon,
    required String message,
    required Color color,
  }) =>
      Flushbar(
        backgroundColor: color,
        icon: Icon(icon, color: Colors.white),
        flushbarStyle: FlushbarStyle.FLOATING,
        isDismissible: true,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        borderRadius: BorderRadius.circular(8),
        message: message,
        duration: const Duration(milliseconds: 3000),
        mainButton: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {},
        ),
      );
}
