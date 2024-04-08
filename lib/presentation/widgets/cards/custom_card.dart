import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

class LebenswikiCards {
  static standardButton({
    required IconData icon,
    required String text,
    Color itemColors = Colors.black,
    double iconSize = 20,
    double fontSize = 17,
    double horizontalPadding = 0,
    double topPadding = 0,
    double bottomPadding = 0,
    double innerPadding = 0,
    Function? onPressed,
    Color? backgroundColor,
  }) =>
      standardCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: itemColors,
              size: iconSize,
            ),
            Text(
              text,
              style: TextStyle(
                color: itemColors,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
        horizontalPadding: horizontalPadding,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        innerPadding: innerPadding,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
      );

  static standardCard({
    required Widget child,
    bool isOwn = false,
    double horizontalPadding = 0,
    double topPadding = 0,
    double bottomPadding = 0,
    double innerPadding = 0,
    Function? onPressed,
    Color? backgroundColor,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding,
          left: horizontalPadding / 2,
          right: horizontalPadding / 2,
        ),
        child: InkWell(
          onTap: () {
            if (onPressed != null) onPressed();
          },
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              boxShadow: [
                isOwn
                    ? const BoxShadow(
                        color: Colors.blueAccent,
                        spreadRadius: 1,
                        blurRadius: 2,
                      )
                    : LebenswikiShadows.fancyShadow
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(innerPadding),
              child: child,
            ),
          ),
        ),
      );
}
