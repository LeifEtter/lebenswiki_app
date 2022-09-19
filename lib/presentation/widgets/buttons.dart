import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lebenswiki_app/presentation/widgets/colors.dart';

class LWButtons {
  const LWButtons();

  Widget normal({
    required String text,
    required Function action,
    double verticalPadding = 0.0,
    double fontSize = 15.0,
    FontWeight fontWeight = FontWeight.w500,
    HexColor? color,
    HexColor? textColor,
    double borderRadius = 0,
  }) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color ?? CustomColors.offBlack,
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
