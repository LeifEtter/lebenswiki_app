import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/views/shorts/create_short.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      onPressed: () => Navigator.of(context).push(_createShortRoute()),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          boxShadow: [
            LebenswikiShadows().fancyShadow,
          ],
          borderRadius: BorderRadius.circular(10.0),
          gradient: LebenswikiColors.blueGradient,
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 52.0,
        ),
      ),
    );
  }

  Route _createShortRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CreateShort(),
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
