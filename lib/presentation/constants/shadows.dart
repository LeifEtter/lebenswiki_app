import 'package:flutter/material.dart';

class LebenswikiShadows {
  static BoxShadow standardBoxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  static BoxShadow fancyShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    spreadRadius: 1,
    blurRadius: 4,
    offset: const Offset(1, 2),
  );

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 3,
    blurRadius: 6,
    offset: const Offset(1, 2),
  );

  static BoxShadow cardShadowSave = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 2,
    blurRadius: 5,
    offset: const Offset(2, 5),
  );

  static BoxShadow commentCardShadow = const BoxShadow(
    color: Color.fromRGBO(99, 99, 99, 0.1),
    blurRadius: 5,
    spreadRadius: 1,
    offset: Offset(0, 2),
  );
}
