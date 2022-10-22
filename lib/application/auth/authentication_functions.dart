import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/presentation/providers/provider_helper.dart';
import 'package:lebenswiki_app/repository/backend/token_handler.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/presentation/providers/auth_providers.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static Future<Either<CustomError, User>> login(
      FormNotifier formProvider, WidgetRef ref) async {
    await UserApi().login(
        email: formProvider.email.value ?? "",
        password: formProvider.password.value ?? "");

    Either<CustomError, UserTokenResponse> res = await UserApi().login(
      email: formProvider.email.value ?? "",
      password: formProvider.password.value ?? "",
    );

    if (res.isLeft) {
      formProvider.handleApiError(res.left.error);
      return Left(res.left);
    } else {
      await TokenHandler().set(res.right.token);
      await ProviderHelper.getDataAndSetSessionProviders(ref);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("authType", "user");
      return Right(res.right.user);
    }
  }

  static void logout(context, WidgetRef ref) async {
    TokenHandler().delete();
    ProviderHelper.resetSessionProviders(ref);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("authType", "loggedOut");
    Navigator.of(context).push(_logoutRoute());
  }

  static Route _logoutRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AuthWrapper(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
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
  }
}
