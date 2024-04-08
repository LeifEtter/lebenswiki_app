import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';

class LWButtons {
  const LWButtons();

  Widget normal({
    required String text,
    required Function action,
    double verticalPadding = 0.0,
    double fontSize = 15.0,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    Color? textColor,
    double borderRadius = 0,
    Border? border,
  }) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color ?? CustomColors.offBlack,
          border: border,
        ),
        child: TextButton(
          onPressed: () => action(),
          child: Padding(
            padding: EdgeInsets.all(verticalPadding),
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      );
}
