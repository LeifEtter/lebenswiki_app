import 'package:flutter/material.dart';

Widget readTime() => Container(
      child: const Text(
        "4 MIN LESEZEIT",
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(245, 245, 245, 0.9),
      ),
    );
