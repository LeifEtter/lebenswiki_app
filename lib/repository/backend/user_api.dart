import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/repository/backend/base_api.dart';
import 'package:lebenswiki_app/repository/backend/error_handler.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/domain/models/block_model.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

class UserTokenResponse {
  final String token;
  final User user;

  UserTokenResponse({required this.token, required this.user});
}

class UserApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  UserApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<bool> authenticate() async {
    Response res = await get(
      Uri.parse("$serverIp/users/authentication"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return true;
    } else {
      return false;
    }
  }

  Future<Either<CustomError, String>> register(User user) async {
    Response res = await post(
      Uri.parse("$serverIp/users/register"),
      headers: await requestHeader(),
      body: jsonEncode(user),
    );
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Erfolgreich");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return const Left(
          CustomError(error: "User acount konnte nicht erstellt werden"));
    }
  }

  Future<Either<CustomError, UserTokenResponse>> login({
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
      Map decoded = jsonDecode(res.body);
      return Right(UserTokenResponse(
        token: decoded["token"],
        user: User.forContent(decoded["user"]),
      ));
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return Left(CustomError(error: decodedBody["error"]["errorMessage"]));
    }
  }

  Future<Either<CustomError, String>> loginAnonymously() async {
    Response res = await post(
      Uri.parse("$serverIp/users/anonymous-login"),
      headers: await requestHeader(),
    );
    Map decodedBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      Map decoded = jsonDecode(res.body);
      return Right(decoded["token"]);
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return const Left(CustomError(error: "Login Fehlgeschlagen"));
    }
  }

  Future<Either<CustomError, User>> getUserData() async {
    Response res = await get(
      Uri.parse("$serverIp/users/profile"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      User user = User.forProvider(jsonDecode(res.body)["user"]);
      return Right(user);
    } else {
      apiErrorHandler.logRes(res);
      return const Left(
        CustomError(error: "Konnte benutzer daten nicht abfragen"),
      );
    }
  }

  Future<ResultModel> updatePassword({
    required String oldpassword,
    required String newpassword,
  }) async {
    Response res = await patch(Uri.parse("$serverIp/users/password/update"),
        headers: await requestHeader(),
        body: jsonEncode({
          "oldPassword": oldpassword,
          "newPassword": newpassword,
        }));
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
          type: ResultType.success, message: "Password erfolgreich geändert");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      String errorMessage = jsonDecode(res.body)["error"]["errorMessage"];
      return ResultModel(
        type: ResultType.failure,
        message: errorMessage,
      );
    }
  }

  Future<Either<CustomError, String>> updateProfile({
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
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Profil erfolgreich geändert");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return const Left(
          CustomError(error: "Profil konnte nicht geändert werden"));
    }
  }

  Future<Either<CustomError, String>> updateProfileImage(
      {required String profileImage}) async {
    Response res = await put(
      Uri.parse("$serverIp/users/profile/update/image"),
      headers: await requestHeader(),
      body: jsonEncode({
        "profileImage": profileImage,
      }),
    );
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Erfolgreich");
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
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
    if (statusIsSuccess(res.statusCode)) {
      List blocks = jsonDecode(res.body)["blockedUsers"];
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
