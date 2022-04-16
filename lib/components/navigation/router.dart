import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/navigation/routing_constants.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/views/authentication/authentication_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthenticationWrapperRoute:
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthenticationWrapper(),
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
    case AuthenticationViewRoute:
      return MaterialPageRoute(builder: (context) => AuthenticationView());
    default:
      return MaterialPageRoute(builder: (context) => AuthenticationWrapper());
  }

  //return MaterialPageRoute(builder: (context) => AuthenticationWrapper());
}
