import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/views/create_short.dart';
import 'package:lebenswiki_app/views/display_pack.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createShortRoute());
      },
      child: Container(
        width: 55,
        height: 55,
        child: const Icon(
          Icons.add_rounded,
          size: 52.0,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            LebenswikiShadows().fancyShadow,
          ],
          borderRadius: BorderRadius.circular(10.0),
          gradient: LebenswikiColors.blueGradient,
        ),
      ),
    );
  }

  Route _createShortRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CreateShort(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
