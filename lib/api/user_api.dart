import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:lebenswiki_app/api/general/base_api.dart';
import 'package:lebenswiki_app/api/general/error_handler.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
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
      headers: await requestHeader(),
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
      Uri.parse("$serverIp/users/login"),
      headers: await requestHeader(),
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    Map decodedBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        token: decodedBody["token"],
        responseItem: User.forContent(decodedBody["user"]),
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: decodedBody["error"]["errorMessage"],
      );
    }
  }

  Future<ResultModel> getUserData() async {
    Response res = await get(
      Uri.parse("$serverIp/users/profile"),
      headers: await requestHeader(),
    );
    Map decodedBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.user,
        responseItem: User.forProvider(
          decodedBody["user"],
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
        headers: await requestHeader(),
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
    Response res = await put(
      Uri.parse("$serverIp/users/profile/update"),
      headers: await requestHeader(),
      body: jsonEncode({
        "email": user.email,
        "name": user.name,
        "biography": user.biography,
        "profileImage": user.profileImage
      }),
    );
    log(res.body);
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
      headers: await requestHeader(),
      body: jsonEncode({
        "reason": reason,
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
    Response res = await get(
      Uri.parse("$serverIp/blocks/"),
      headers: await requestHeader(),
    );
    List blocks = jsonDecode(res.body)["blockedUsers"];
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        responseList: blocks.map((block) => Block.fromJson(block)).toList(),
      );
    } else {
      return ResultModel(
        type: ResultType.failure,
        responseList: [],
        message: "Du hast keine User blockiert",
      );
    }
  }

  Future<ResultModel> createFeedback({
    required String feedback,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/feedbacks/create"),
      headers: await requestHeader(),
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
