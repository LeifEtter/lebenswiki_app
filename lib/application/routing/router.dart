import 'package:flutter/material.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/presentation/screens/main/short_creation.dart';
import 'package:lebenswiki_app/presentation/screens/menu/about_us.dart';
import 'package:lebenswiki_app/presentation/screens/menu/contact.dart';
import 'package:lebenswiki_app/presentation/screens/menu/created.dart';
import 'package:lebenswiki_app/presentation/screens/menu/profile.dart';
import 'package:lebenswiki_app/presentation/screens/menu/saved.dart';
import 'package:lebenswiki_app/presentation/screens/main/authentication.dart';
import 'package:lebenswiki_app/presentation/screens/other/avatar_screen.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_main.dart';

const String homeRoute = '/home';
const String authRoute = '/authentication';
const String authRouteRegister = '/authenticationRegister';
const String profileViewRoute = '/profile';
const String developerViewRoute = '/developer';
const String savedViewRoute = '/saved';
const String createdViewRoute = '/created';
const String createdViewRouteShorts = '/createdShorts';
const String contactViewRoute = '/contact';
const String createShort = '/createShort';
const String tokenCheck = '/tokenCheck';
const String avatarScreen = '/avatar';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case tokenCheck:
    //   return MaterialPageRoute(
    //     settings: settings,
    //     builder: (context) => const AuthWrapper(),
    //   );
    case homeRoute:
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NavBarWrapper(),
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
    case "quizzer":
      return MaterialPageRoute(builder: (context) => const Quizzer());
    case authRoute:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AuthenticationView(),
      );
    case authRouteRegister:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AuthenticationView(startWithRegister: true),
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
    case createdViewRouteShorts:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const CreatedView(startWithShorts: true),
      );
    case createShort:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ShortCreationView(),
      );
    case avatarScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AvatarScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const NavBarWrapper(),
      );
  }
}
