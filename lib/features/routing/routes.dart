import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/menu/views/your_creator_packs.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_information.dart';
import 'package:lebenswiki_app/features/packs/views/pack_feed.dart';
import 'package:lebenswiki_app/features/shorts/views/short_creation.dart';

class LebenswikiRoutes {
  static Route swipeUpToPackMenu(Function routeCallback) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const PackFeed(),
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

  static Route swipeUpToShortMenu(Function routeCallback) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const PackFeed(),
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

  static Route createPackRoute(Pack pack) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          PackCreatorInformation(pack: pack),
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

  static Route goToYourPacks() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const YourCreatorPacks(),
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

  static Route createShortRoute() {
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

  static Route naivgateToFeed() {
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
