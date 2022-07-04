import 'package:flutter/material.dart';

Widget lebenswikiBlueButtonNormal({
  required String text,
  required Function callback,
  List categories = const [],
}) {
  return lebenswikiBlueButton(
    backgroundColor: const Color.fromRGBO(115, 148, 192, 1),
    textColor: Colors.white,
    text: text,
    callback: callback,
    categories: categories,
  );
}

Widget lebenswikiBlueButtonInverted({
  required String text,
  required Function callback,
  List categories = const [],
}) {
  return lebenswikiBlueButton(
    backgroundColor: Colors.transparent,
    textColor: const Color.fromRGBO(115, 148, 192, 1),
    text: text,
    callback: callback,
    categories: categories,
  );
}

Widget lebenswikiBlueButton({
  required Color backgroundColor,
  required Color textColor,
  required String text,
  required Function callback,
  List categories = const [],
}) {
  return Container(
    height: 43,
    decoration: BoxDecoration(
      color: backgroundColor, //Color.fromRGBO(115, 148, 192, 1),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 14,
            ), //Colors.white
          ),
          onPressed: () {
            categories.isNotEmpty ? callback(categories) : callback();
          },
        ),
      ],
    ),
  );
}
