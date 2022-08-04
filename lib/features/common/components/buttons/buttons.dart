import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/colors.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class LebenswikiButtons {
  static LebenswikiTextButton textButton = LebenswikiTextButton();
  static LebenswikiIconButton iconButton = LebenswikiIconButton();
  static LebenswikiTextIconButton textIconButton = LebenswikiTextIconButton();
}

class LebenswikiTextButton {
  Widget authenticationButton({
    required String text,
    required Color color,
    required Function onPress,
  }) =>
      Container(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LebenswikiColors.blueGradient,
        ),
        child: TextButton(
          child: Text(
            text,
            style:
                LebenswikiTextStyles.authenticationContent.authenticationButton,
          ),
          onPressed: () => onPress(),
        ),
      );

  Widget blueButtonNormal({
    required String text,
    required Function callback,
  }) {
    return blueButton(
      backgroundColor: const Color.fromRGBO(115, 148, 192, 1),
      textColor: Colors.white,
      text: text,
      callback: callback,
    );
  }

  Widget blueButtonInverted({
    required String text,
    required Function callback,
  }) {
    return blueButton(
      backgroundColor: Colors.transparent,
      textColor: const Color.fromRGBO(115, 148, 192, 1),
      text: text,
      callback: callback,
    );
  }

  Widget blueButton({
    required Color backgroundColor,
    required Color textColor,
    required String text,
    required Function callback,
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
              callback();
            },
          ),
        ],
      ),
    );
  }
}

class LebenswikiIconButton {
  Widget roundEdgesWhite({
    required Function callback,
    required Icon icon,
  }) =>
      roundEdges(callback: callback, icon: icon, backgroundColor: Colors.white);

  Widget roundEdges({
    required Function callback,
    required Icon icon,
    required Color backgroundColor,
    Color iconColor = Colors.black,
  }) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [LebenswikiShadows.fancyShadow],
          color: backgroundColor,
        ),
        child: IconButton(
          onPressed: () => callback(),
          icon: icon,
          color: iconColor,
        ),
      );
}

class LebenswikiTextIconButton {}
