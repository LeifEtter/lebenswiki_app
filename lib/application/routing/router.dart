import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/screens/main_views/short_creation.dart';
import 'package:lebenswiki_app/presentation/screens/menu_views/about_us.dart';
import 'package:lebenswiki_app/presentation/screens/menu_views/contact.dart';
import 'package:lebenswiki_app/presentation/screens/menu_views/created.dart';
import 'package:lebenswiki_app/presentation/screens/menu_views/profile.dart';
import 'package:lebenswiki_app/presentation/screens/menu_views/saved.dart';
import 'package:lebenswiki_app/repository/constants/routing_constants.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/presentation/screens/other/authentication.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case authenticationWrapperRoute:
      return PageRouteBuilder(
        settings: settings,
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
        settings: settings,
        builder: (context) => const AuthenticationView(),
      );
    case contactViewRoute:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ContactView(),
      );
    case developerViewRoute:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AboutUsView(),
      );
    case profileViewRoute:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ProfileView(),
      );
    case savedViewRoute:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const SavedView(),
      );
    case createdViewRoute:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const CreatedView(),
      );
    case createShort:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ShortCreationView(),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AuthWrapper(),
      );
  }
}
