import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/testing/border.dart';

/*class MainButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Function onPress;

  const MainButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: color,
      ),
      child: TextButton(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 5.0, right: 5.0, top: 8, bottom: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10.0),
              Text(
                text,
                style: LebenswikiTextStyles.createPackButton,
              ),
            ],
          ),
        ),
        onPressed: () => onPress(),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPress;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: color,
        border: Border.all(
          color: LebenswikiColors.profileButton,
          width: 1.0,
        ),
      ),
      child: TextButton(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11.0,
            color: Colors.black45,
            fontWeight: FontWeight.w300,
          ),
        ),
        onPressed: () => onPress(),
      ),
    );
  }
}*/

class LebenswikiBlueButton extends StatelessWidget {
  final String text;
  final Function callback;
  final List categories;

  const LebenswikiBlueButton({
    Key? key,
    required this.text,
    required this.callback,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(115, 148, 192, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextButton(
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
        ),
        onPressed: () {
          categories.isNotEmpty ? callback(categories) : callback();
        },
      ),
    );
  }
}

class LebenswikiBlueButtonInverted extends StatelessWidget {
  final String text;
  final Function callback;

  const LebenswikiBlueButtonInverted({
    Key? key,
    required this.text,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextButton(
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(115, 148, 192, 1),
              fontSize: 14),
        ),
        onPressed: () => callback(),
      ),
    );
  }
}
