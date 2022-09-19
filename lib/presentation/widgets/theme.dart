import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/widgets/colors.dart';

ThemeData buildTheme(brightness) => ThemeData(
      fontFamily: "Outfit",
      brightness: brightness,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 22.0,
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
        labelSmall: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: CustomColors.offBlack,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w300,
          color: CustomColors.offBlack,
        ),
        bodySmall: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CustomColors.offBlack,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: CustomColors.offBlack,
        ),
        titleMedium: TextStyle(
          color: CustomColors.offBlack,
          fontWeight: FontWeight.w500,
          fontSize: 18,
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
