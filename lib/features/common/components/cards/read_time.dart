import 'package:flutter/material.dart';

Widget readTime(int readTime) => Container(
      child: Text(
        "$readTime MIN LESEZEIT",
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(245, 245, 245, 0.9),
      ),
    );
