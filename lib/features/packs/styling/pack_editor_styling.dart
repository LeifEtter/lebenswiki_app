import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class PackEditorStyling {
  static BoxDecoration standardInput() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [LebenswikiShadows().fancyShadow],
      color: Colors.white,
    );
  }

  static InputDecoration standardDecoration(placeholder) {
    return InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(10.0),
      hintText: placeholder,
    );
  }
}
