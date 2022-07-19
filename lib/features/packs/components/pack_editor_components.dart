import 'package:flutter/material.dart';

class PackEditorComponents {
  static Widget iconButton({
    required IconData icon,
    required Function callback,
    required String label,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )),
        icon: Icon(icon),
        onPressed: () => callback(),
        label: Text(label,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            )),
      );
}
