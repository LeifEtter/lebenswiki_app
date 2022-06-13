import 'dart:convert';

import 'package:http/http.dart';
import 'package:lebenswiki_app/api/api_models/base_api.dart';
import 'package:lebenswiki_app/api/api_models/error_handler.dart';
import 'package:lebenswiki_app/api/api_models/result_model_api.dart';
import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class UserApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  UserApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> register(User user) async {
    Response res = await post(
      Uri.parse("$serverIp/users/register"),
      headers: requestHeader(),
      body: jsonEncode(user),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Account erfolgreich erstellt",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Dein Account konnte nicht erstellt werden",
      );
    }
  }

  Future<ResultModel> login({
    required String email,
    required String password,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/users/register"),
      headers: requestHeader(),
      body: jsonEncode({
        email: email,
        password: password,
      }),
    );
    Map decodedBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Account erfolgreich erstellt",
        token: decodedBody["token"],
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Dein Account konnte nicht erstellt werden",
      );
    }
  }

  Future<ResultModel> getUserData() async {
    Response res = await get(
      Uri.parse("$serverIp/users/profile"),
      headers: requestHeader(),
    );
    Map decodedBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.user,
        user: User.fromJson(
          decodedBody["body"],
        ),
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Benutzer nicht gefunden",
      );
    }
  }

  Future<ResultModel> updatePassword({
    required String oldpassword,
    required String password,
  }) async {
    Response res = await patch(Uri.parse("$serverIp/users/password/update"),
        headers: requestHeader(),
        body: jsonEncode({
          "oldPassword": oldpassword,
          "newPassword": password,
        }));
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
          type: ResultType.success, message: "Password erfolgreich geändert");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Password konnte nicht geändert werden",
      );
    }
  }

  Future<ResultModel> updateProfile({
    required User user,
  }) async {
    Response res = await patch(
      Uri.parse("$serverIp/users/profile/update"),
      headers: requestHeader(),
      body: user.toJson(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
          type: ResultType.success, message: "Profil erfolgreich geändert");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Profil konnte nicht geändert werden",
      );
    }
  }

  Future<ResultModel> blockUser({
    required int id,
    required String reason,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/blocks/create/$id"),
      headers: requestHeader(),
      body: jsonEncode({
        reason: reason,
      }),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "User erfolgreich geblockt",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "User konnte nicht blockiert werden",
      );
    }
  }

  Future<ResultModel> getBlockedUsers() async {
    Response res = await post(
      Uri.parse("$serverIp/blocks/"),
      headers: requestHeader(),
    );
    List blocks = jsonDecode(res.body)["body"];
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        blocks: blocks.map((e) => Block.fromJson(e)).toList(),
      );
    } else {
      return ResultModel(
        type: ResultType.failure,
        blocks: [],
        message: "Du hast keine User blockiert",
      );
    }
  }

  Future<ResultModel> createFeedback({
    required String feedback,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/feedbacks/create"),
      headers: requestHeader(),
      body: jsonEncode({
        "feedback": feedback,
      }),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Feedback wurde erstellt",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Feedback konnte nicht erstellt werden",
      );
    }
  }
}
