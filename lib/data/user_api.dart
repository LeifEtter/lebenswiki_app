import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/data/base_api.dart';
import 'package:lebenswiki_app/data/error_handler.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';

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

  Future<Either<CustomError, User>> authenticate(
      {required String token}) async {
    try {
      Response res = await get(
        Uri.parse("$API_URL/user/checkToken"),
        headers: {
          "Content-type": "application/json",
          "authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);
        User user = User.fromJson(body);
        return Right(user);
      } else {
        return const Left(CustomError(error: "Dein Token ist nicht gültig"));
      }
    } catch (error) {
      throw Error;
    }
  }

  Future<Either<CustomError, String>> deleteAccount() async {
    try {
      Response res = await delete(
        Uri.parse("$serverIp/user/self/delete"),
        headers: await requestHeader(),
      );
      if (res.statusCode == 200) {
        return const Right("Account gelöscht");
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(CustomError(
            error:
                "Account konnte nicht gelöscht werden, bitte kontaktiere uns"));
      }
    } catch (error) {
      log(error.toString());
      throw error;
    }
  }

  Future<Either<CustomError, String>> register(User user) async {
    try {
      Response res = await post(
        Uri.parse("$serverIp/user/register"),
        headers: await requestHeader(),
        body: jsonEncode(user),
      );
      log(res.body);
      if (statusIsSuccess(res.statusCode)) {
        return const Right("Erfolgreich");
      } else {
        apiErrorHandler.handleAndLog(
            responseData: jsonDecode(res.body), trace: StackTrace.current);
        return Left(handleError(res));
      }
    } catch (error) {
      log(error.toString());
      throw error;
    }
  }

  Future<Either<CustomError, UserTokenResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      Response res = await post(
        Uri.parse("$serverIp/user/login"),
        headers: await requestHeader(),
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      if (res.statusCode == 200) {
        User user = User.fromJson(decodedBody);
        String jwtToken =
            res.headers["set-cookie"]!.split("jwt_token=")[1].split(";")[0];
        return Right(UserTokenResponse(token: jwtToken, user: user));
      } else {
        return Left(handleError(res));
      }
    } catch (error) {
      ApiError apiError = ApiError.forUnknown();
      log(error.toString());
      return Left(CustomError(error: apiError.message));
    }
  }

  Future<User> getUserData() async {
    try {
      Response res = await get(
        Uri.parse("$serverIp/user/profile"),
        headers: await requestHeader(),
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);
        User user = User.fromJson(body);
        return user;
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        log(res.body);
        throw "Couldn't fetch user";
      }
    } catch (error) {
      log(error.toString());
      // return Left(CustomError(error: error.toString()));
      throw error;
    }
  }

  Future<Either<CustomError, String>> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    Response res = await patch(Uri.parse("$serverIp/user/update/password"),
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }));
    if (res.statusCode == 200) {
      return Right("Password erfolgreich geändert");
    } else {
      return Left(CustomError(error: ""));
    }
  }

  Future<Either<CustomError, String>> updateProfile({
    required User user,
  }) async {
    try {
      inspect(user);
      Response res = await patch(
        Uri.parse("$serverIp/user/profile/update"),
        headers: await requestHeader(),
        body: jsonEncode(user),
      );
      if (res.statusCode == 200) {
        return const Right("Profil erfolgreich geändert");
      } else {
        //TODO Implement handling return error
        apiErrorHandler.handleAndLog(
            responseData: jsonDecode(res.body), trace: StackTrace.current);
        return const Left(
            CustomError(error: "Profil konnte nicht geändert werden"));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: error.toString()));
    }
  }

  Future<Either<CustomError, String>> createFeedback(
      {required String type, required String content}) async {
    try {
      Response res = await post(
        Uri.parse("$serverIp/feedback/create"),
        headers: await requestHeader(),
        body: jsonEncode({
          "content": content,
        }),
      );
      if (statusIsSuccess(res.statusCode)) {
        return const Right("Feedback erfolgreich verschickt");
      } else {
        return Left(handleError(res));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: ApiError.forUnknown().message));
    }
  }

  Future<Either<CustomError, Map<String, dynamic>>> uploadAvatar(
      {required String pathToImage}) async {
    try {
      MultipartRequest request =
          MultipartRequest("POST", Uri.parse("$serverIp/image/avatar/upload"));
      MultipartFile image = await MultipartFile.fromPath('avatar', pathToImage);
      request.headers["authorization"] = "Bearer ${await TokenHandler().get()}";
      request.files.add(image);
      StreamedResponse stream = await request.send();
      Response res = await Response.fromStream(stream);
      if (res.statusCode == 201) {
        Map<String, dynamic> body = jsonDecode(res.body);

        return Right(body);
      } else {
        log(res.body);
        return const Left(CustomError(error: "Couldn't upload image"));
      }
    } catch (error) {
      log(error.toString());
      throw error;
    }
  }

  Future<Either<CustomError, String>> defaultAvatar() async {
    try {
      Response res = await patch(
        Uri.parse("$serverIp/user/defaultAvatar"),
        headers: await requestHeader(),
      );
      if (res.statusCode == 200) {
        return const Right("Profil erfolgreich geändert");
      } else {
        return const Left(
            CustomError(error: "Default Avatar konnte nicht gesetzt werden"));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: error.toString()));
    }
  }

  Future<Either<CustomError, String>> blockUser(
      int userId, String reason) async {
    try {
      Response res = await post(Uri.parse("$serverIp/user/block/$userId"),
          headers: await requestHeader(),
          body: jsonEncode({
            "reason": reason,
          }));
      if (res.statusCode == 201) {
        return const Right(
            "Nutzer blockiert. Shorts und Packs von diesem Nutzer werden nicht mehr angezeigt.");
      } else {
        log(res.body);
        return const Left(CustomError(
            error:
                "Nutzer konnte nicht blockiert werden. Bitte kontaktiere uns schnellstmöglich"));
      }
    } catch (error) {
      log(error.toString());
      return const Left(CustomError(
          error:
              "Nutzer konnte nicht blockiert werden. Bitte kontaktiere uns schnellstmöglich"));
    }
  }
}
