import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar errorSnackbar(
    BuildContext context, {
    required String errorMessage,
  }) =>
      _defaultSnackbar(context, color: Colors.red);

  static SnackBar _defaultSnackbar(
    BuildContext context, {
    required Color color,
  }) {
    return SnackBar(
        content: Row(
      children: const [Text("Test")],
    ));
  }
}
