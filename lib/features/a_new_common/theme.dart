import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';

ThemeData buildTheme(brightness) => ThemeData(
      fontFamily: "Outfit",
      brightness: brightness,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: CustomColors.textBlack,
        ),
        labelLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: CustomColors.offBlack,
        ),
        labelMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: CustomColors.offBlack,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: CustomColors.textGrey,
        ),
        bodySmall: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

extension CustomStyles on TextTheme {
  TextStyle get blueLabel => TextStyle(
        color: CustomColors.blueText,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );
}
