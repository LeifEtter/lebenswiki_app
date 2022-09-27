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
      return Right(res.right.user);
    }
  }

  static void logout(context, WidgetRef ref) async {
    TokenHandler().delete();
    ProviderHelper.resetSessionProviders(ref);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuthWrapper(),
    ));
  }
}
