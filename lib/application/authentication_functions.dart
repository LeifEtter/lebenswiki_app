import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/providers/provider_helper.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/repository/backend/token_handler.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/presentation/providers/auth_providers.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

class Authentication {
  static Future<ResultModel> register(FormNotifier formProvider) async {
    ResultModel result = ResultModel(
      type: ResultType.failure,
      message: "Functions not run",
    );

    User user = formProvider.convertToUser();

    await UserApi().register(user).then((ResultModel registerResult) {
      result = registerResult;
    }).catchError((error) {
      log(error);
      result = ResultModel(
          type: ResultType.failure, message: "Something went wrong");
    });

    return result;
  }

  static Future<ResultModel> login(
      FormNotifier formProvider, WidgetRef ref) async {
    ResultModel result = ResultModel(
      type: ResultType.failure,
      message: "Not run",
    );

    await UserApi()
        .login(
      email: formProvider.email.value ?? "",
      password: formProvider.password.value ?? "",
    )
        .then((ResultModel loginResult) async {
      //In case an error is thrown we set result to error
      if (loginResult.type != ResultType.success) {
        formProvider.handleApiError(loginResult.message!);
        result = ResultModel(
          type: ResultType.failure,
          message: loginResult.message,
        );
      } else {
        String token = loginResult.token!;
        await TokenHandler().set(token);
        await ProviderHelper.getDataAndSetSessionProviders(ref);
        result = ResultModel(
          type: ResultType.success,
        );
      }
    });
    return result;
  }

  static void logout(context, WidgetRef ref) async {
    TokenHandler().delete();
    ProviderHelper.resetSessionProviders(ref);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuthWrapper(),
    ));
  }
}
