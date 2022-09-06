import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/colors.dart';

class LebenswikiTextStyles {
  static const title = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w600,
  );

  static const logoText = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: -1.0,
  );

  static const packTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: LebenswikiColors.packTitleFont,
  );

  static const packDescription = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: LebenswikiColors.packDescriptionFont,
  );

  static const publisherInfo = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: LebenswikiColors.publisherInfoFont,
  );

  static const packReadTime = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    color: LebenswikiColors.packTitleFont,
  );

  static ShortContent shortContent = ShortContent();
  static MenuBarStyles menuBar = MenuBarStyles();
  static CategoryBar categoryBar = CategoryBar();
  static AuthenticationContent authenticationContent = AuthenticationContent();
}

class ShortContent {
  TextStyle get displayShortTitle => const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
      );

  TextStyle get displayShortDescription => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(100, 100, 100, 1),
      );
}

class MenuBarStyles {
  TextStyle get menuText => const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  TextStyle get menuProfileName => const TextStyle(
        fontSize: 23.0,
        fontWeight: FontWeight.w700,
      );

  TextStyle get menuUserName => const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      );
}

class CategoryBar {
  TextStyle get categoryButtonInactive => const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      );

  TextStyle get categoryButtonActive => const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      );
}

class AuthenticationContent {
  TextStyle get authenticationTitle => const TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: LebenswikiColors.packTitleFont,
      );

  TextStyle get authenticationButton => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(250, 250, 250, 1.0),
      );
}
