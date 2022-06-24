import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/styling/colors.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';

class AuthenticationButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPress;

  const AuthenticationButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}
