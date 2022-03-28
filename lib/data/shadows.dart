import 'package:flutter/material.dart';

class LebenswikiShadows {
  final BoxShadow standardBoxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 3),
  );

  final BoxShadow fancyShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    spreadRadius: 1,
    blurRadius: 4,
    offset: Offset(1, 2),
  );

  final BoxShadow cardShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 2,
    blurRadius: 5,
    offset: Offset(2, 5),
  );
}
