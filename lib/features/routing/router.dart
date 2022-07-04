import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/routing/routing_constants.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/features/authentication/views/authentication_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case authenticationWrapperRoute:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthWrapper(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    case authenticationViewRoute:
      return MaterialPageRoute(
          builder: (context) => const AuthenticationView());
    default:
      return MaterialPageRoute(builder: (context) => const AuthWrapper());
  }

  //return MaterialPageRoute(builder: (context) => AuthenticationWrapper());
}
