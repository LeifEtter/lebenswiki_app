import 'package:flutter/material.dart';

Widget customTab(String text) => Tab(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17.0,
        ),
      ),
    );
