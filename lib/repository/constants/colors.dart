import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class CustomColors {
  //General Colors
  static HexColor get offBlack => HexColor("#1E1E1E");
  static HexColor get mediumGrey => HexColor("#D7D7D7");
  static HexColor get darkGrey => HexColor("#9B9B9B");
  static HexColor get veryDarkGrey => HexColor("#333333");
  static HexColor get blue => HexColor("#90B1D8");
  static HexColor get darkBlue => HexColor("#88ABD5");
  static HexColor get whiteOverlay => HexColor("#F5F5F5");
  static HexColor get mediumDarkGrey => HexColor("##DFDFDF");

  //Background Colors
  static HexColor get lightGrey => HexColor("#F1F1F1");
  //static LinearGradient? get blueGradientCombined => LinearGradient.lerp(blueGradient, blueGradient, blueGradient);
  static LinearGradient get blueGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(130, 165, 207, 1.0),
          Color.fromRGBO(136, 171, 213, 0.65),
          Colors.white,
        ],
      );

  static LinearGradient get blueGradientSliver => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HexColor("#84B2ED"),
            HexColor("#ABC1DD"),
            HexColor("#bad4f5"),
            //Color.fromRGBO(130, 165, 207, 1.0),
          ]);

  /*background: linear-gradient(204.48deg, rgba(129, 186, 252, 0.54) 12.89%, rgba(172, 209, 251, 0) 42.43%),
  linear-gradient(158.07deg, #88ABD5 7.05%, rgba(136, 171, 213, 0) 70.95%),
  linear-gradient(0deg, #B7CDE7, #B7CDE7),
  linear-gradient(348deg, rgba(255, 255, 255, 0.88) 0.01%, rgba(255, 255, 255, 0) 50.16%);*/

  //Text Colors
  static HexColor get textBlack => HexColor("#272833");
  static HexColor get textGrey => HexColor("#646464");
  static HexColor get blueText => HexColor("#577EAC");
  static HexColor get textMediumGrey => HexColor("#777777");
}
