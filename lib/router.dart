import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/screens/contact.dart';
import 'package:lebenswiki_app/presentation/screens/profile.dart';
import 'package:lebenswiki_app/presentation/screens/saved.dart';
import 'package:lebenswiki_app/presentation/screens/developer_info.dart';
import 'package:lebenswiki_app/repository/constants/routing_constants.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/presentation/screens/authentication_view.dart';

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
    case contactViewRoute:
      return MaterialPageRoute(
        builder: (context) => const ContactView(),
      );
    case developerViewRoute:
      return MaterialPageRoute(
        builder: (context) => const DeveloperInfoView(),
      );
    case profileViewRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileView(),
      );
    case savedViewRoute:
      return MaterialPageRoute(builder: (context) => const SavedView());
    default:
      return MaterialPageRoute(builder: (context) => const AuthWrapper());
  }

  //return MaterialPageRoute(builder: (context) => AuthenticationWrapper());
}
