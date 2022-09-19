import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {
  static Flushbar error({required String message}) => _default(
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      message: message,
      color: const Color.fromRGBO(225, 85, 76, 1),
      isClose: true);

  static Flushbar success({required String message}) => _default(
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
      message: message,
      color: const Color.fromRGBO(94, 182, 129, 1),
      isClose: true);

  static Flushbar info({required String message}) =>
      _default(message: message, color: Colors.black, isClose: true);

  static Flushbar undo({required String message}) => _default(
      message: message,
      color: const Color.fromRGBO(72, 72, 72, 1),
      isClose: true);

  static Flushbar _default({
    Icon? icon,
    required String message,
    required Color color,
    required bool isClose,
  }) =>
      Flushbar(
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
        mainButton: isClose
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {},
              )
            : TextButton(
                child: const Text(
                  "UNDO",
                  style: TextStyle(
                      fontSize: 16.0, color: Color.fromRGBO(172, 209, 251, 1)),
                ),
                onPressed: () {},
              ),
      );
}
