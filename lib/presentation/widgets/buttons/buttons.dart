import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

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

  Widget purpleButton(String title, void Function() onPressed) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [LebenswikiShadows.fancyShadow],
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: const Color.fromRGBO(119, 140, 249, 1),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget outlineButton(String title, void Function() onPressed) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(
            color: Colors.black,
          )),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget purpleSvgButton(String title, String icon, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [LebenswikiShadows.fancyShadow],
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: const Color.fromRGBO(119, 140, 249, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: Column(
            children: [
              SvgPicture.asset(
                width: 30.0,
                icon,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
