import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class EditDecoration {
  static Widget page({child}) => Container(
        constraints: const BoxConstraints(minHeight: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          boxShadow: [LebenswikiShadows.fancyShadow],
        ),
        child: child,
      );

  static Widget title({child}) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: child,
      );
}
