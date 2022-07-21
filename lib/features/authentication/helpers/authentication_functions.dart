import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/token/token_handler.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/authentication/providers/auth_providers.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/provider_helper.dart';

class Authentication {
  static Future<ResultModel> register(FormNotifier formProvider) async {
    ResultModel result = ResultModel(
      type: ResultType.failure,
      message: "Functoins not run",
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
      }
      String token = loginResult.token ?? "";

      TokenHandler().set(token);
      await ProviderHelper.getDataAndSetSessionProviders(ref, token: token);

      result = ResultModel(
        type: ResultType.success,
      );
    });

    return result;
  }

  static void logout(context, WidgetRef ref) async {
    TokenHandler().delete();

    ProviderHelper.resetSessionProviders(ref);
    //TODO ref.watch(blockedListProvider).removeBlockedList;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuthWrapper(),
    ));
  }
}
