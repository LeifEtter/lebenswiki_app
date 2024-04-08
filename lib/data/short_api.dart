import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:lebenswiki_app/data/base_api.dart';
import 'package:lebenswiki_app/data/error_handler.dart';
// import 'package:http/http.dart';
// import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
// import 'package:lebenswiki_app/domain/models/category.model.dart';
// import 'package:lebenswiki_app/domain/models/enums.dart';
// import 'package:lebenswiki_app/domain/models/short.model.dart';
// import 'dart:convert';
// import 'package:either_dart/either.dart';
// import 'package:lebenswiki_app/domain/models/error.model.dart';

class ShortApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  ShortApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<Either<CustomError, String>> createShort(Short short) async {
    try {
      Response res = await post(Uri.parse("$serverIp/short/create"),
          headers: await requestHeader(), body: jsonEncode(short));
      print(res.body);
      if (res.statusCode == 201) {
        return const Right("Short Created");
      } else {
        Map<String, dynamic> decodedBody = jsonDecode(res.body);
        return Left(CustomError(error: ApiError.fromJson(decodedBody).message));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: error.toString()));
    }
  }

  Future<Either<CustomError, List<Short>>> getAllShorts() => getShorts(
      endpoint: "/short", error: "Shorts konnten nicht gefunden werden");

  Future<Either<CustomError, List<Short>>> getBookmarkedShorts() => getShorts(
      endpoint: "/short/bookmarked",
      error: "Gespeicherte Shorts konnten nicht gefunden werden");

  Future<Either<CustomError, List<Short>>> getPublishedShorts() => getShorts(
      endpoint: "/short/own/published",
      error: "Deine publizierten Shorts konnten nicht gefunden werden");

  Future<Either<CustomError, List<Short>>> getUnpublishedShorts() => getShorts(
      endpoint: "/short/own/unpublished",
      error: "Deine Shorts Entwürfe konnten nicht gefunden werden");

  Future<Either<CustomError, List<Short>>> getShorts(
      {required String endpoint, required String error}) async {
    Response res = await get(Uri.parse("$serverIp$endpoint"),
        headers: await requestHeader());
    try {
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        List<Short> shorts =
            body.map((short) => Short.fromJson(short)).toList();
        return Right(shorts);
      } else {
        Map<String, dynamic> decodedBody = jsonDecode(res.body);
        return Left(CustomError(error: decodedBody["message"]));
      }
    } catch (error) {
      log("Error during getShorts with uri $endpoint");
      log(error.toString());
      throw Error;
    }
  }

  Future<Either<CustomError, String>> clapForShort(int shortId) =>
      interactShort(
          endpoint: "/short/clap/$shortId", error: "Failed to clap for Short");

  Future<Either<CustomError, String>> publishShort(int shortId) =>
      interactShort(
          endpoint: "/short/publish/$shortId",
          error: "Short konnte nicht veröffentlicht werden");

  Future<Either<CustomError, String>> unpublishShort(int shortId) =>
      interactShort(
          endpoint: "/short/unpublish/$shortId",
          error: "Failed to unpublish Short");

  Future<Either<CustomError, String>> bookmarkShort(int shortId) =>
      interactShort(
          endpoint: "/short/bookmark/$shortId",
          error: "Failed to bookmark Short");

  Future<Either<CustomError, String>> unbookmarkShort(int shortId) =>
      interactShort(
          endpoint: "/short/unbookmark/$shortId",
          error: "Failed to unbookmark Short");

  Future<Either<CustomError, String>> interactShort(
      {required String endpoint, required String error}) async {
    Response res = await patch(Uri.parse("$serverIp$endpoint"),
        headers: await requestHeader());
    if (res.statusCode == 200) {
      return const Right("Success");
    } else {
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      return Left(CustomError(
          error: decodedBody["message"] ?? "Irgendwas ist schiefgelaufen"));
    }
  }

  Future<Either<CustomError, String>> reportShort(
      int shortId, String reason) async {
    Response res = await patch(Uri.parse("$serverIp/short/report/$shortId"),
        headers: await requestHeader(), body: jsonEncode({"reason": reason}));

    if (res.statusCode == 200) {
      return const Right("Short gemeldet");
    } else {
      print(res.body);
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      return Left(CustomError(
          error: decodedBody["message"] ??
              "Der Short konnte nicht gemeldet werden. Bitte wende dich an unseren Support"));
    }
  }

  Future<Either<CustomError, String>> deleteShort(int shortId) async {
    Response res = await delete(Uri.parse("$serverIp/short/delete/$shortId"),
        headers: await requestHeader());
    try {
      if (res.statusCode == 200) {
        return const Right("Success");
      } else {
        Map<String, dynamic> decodedBody = jsonDecode(res.body);
        return Left(CustomError(error: decodedBody["message"]));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: error.toString()));
    }
  }

  // Future<Either<CustomError, Short>> getShortById({required int id}) async {
  //   Response res = await get(
  //     Uri.parse("$serverIp/shorts/$id"),
  //     headers: await requestHeader(),
  //   );
  //   if (statusIsSuccess(res.statusCode)) {
  //     return Right(Short.fromJson(jsonDecode(res.body)["short"]));
  //   } else {
  //     apiErrorHandler.logRes(res, StackTrace.current);
  //     return const Left(CustomError(error: "Short wurde nicht gefunden"));
  //   }
  // }

  // Future<Either<CustomError, List<Short>>> getShortsByCategory(
  //     {required Category category}) {
  //   return category.categoryName != "Neu"
  //       ? _getShorts(
  //           url: "categories/shorts/${category.id}",
  //           errorMessage: "Es wurden keine shorts gefunden")
  //       : getAllShorts();
  // }

  // Future<Either<CustomError, List<Short>>> getOthersPublishedShorts() =>
  //     _getShorts(
  //         url: "shorts/",
  //         errorMessage: "Dieser Benutzer hat noch keine shorts veröffentlicht");

  // Future<Either<CustomError, List<Short>>> getBookmarkedShorts() => _getShorts(
  //     url: "shorts/bookmarks",
  //     errorMessage: "Du hast keine shorts gespeichert");

  // Future<Either<CustomError, List<Short>>> getCreatorsDraftShorts() =>
  //     _getShorts(
  //       url: "shorts/unpublished",
  //       errorMessage: "Du hast keine shorts entworfen",
  //     );

  // Future<Either<CustomError, String>> upvoteShort(id) => _interactShort(
  //     url: "shorts/upvote/$id",
  //     successMessage: "Short Bewertet",
  //     errorMessage: "Short konnte nicht bewertet werden");

  // Future<Either<CustomError, String>> downvoteShort(id) => _interactShort(
  //     url: "shorts/downvote/$id",
  //     successMessage: "Short Bewertet",
  //     errorMessage: "Short konnte nicht bewertet werden");

  // Future<Either<CustomError, String>> removeUpvoteShort(id) => _interactShort(
  //     url: "shorts/upvote/remove/$id",
  //     successMessage: "Bewertung entfernt",
  //     errorMessage: "Bewertung konnte nicht entfernt werden");

  // Future<Either<CustomError, String>> removeDownvoteShort(id) => _interactShort(
  //     url: "shorts/downvote/remove/$id",
  //     successMessage: "Bewertung entfernt",
  //     errorMessage: "Bewertung konnte nicht entfernt werden");

  // Future<Either<CustomError, String>> bookmarkShort(id) => _interactShort(
  //     url: "shorts/bookmark/$id",
  //     successMessage: "Short Gespeichert",
  //     errorMessage: "Short konnte nicht gespeichert werden");

  // Future<Either<CustomError, String>> unbookmarkShort(id) => _interactShort(
  //     url: "shorts/unbookmark/$id",
  //     successMessage: "Short von Gespeicherten Shorts entfernt",
  //     errorMessage:
  //         "Short konnte nicht von gespeicherten Shorts entfernt werden");

  // Future<Either<CustomError, String>> publishShort(id) => _interactShort(
  //     url: "shorts/publish/$id",
  //     successMessage: "Short Veröffentlicht",
  //     errorMessage: "Du kannst diesen Short nicht veröffentlichen");

  // Future<Either<CustomError, String>> unpublishShort(id) => _interactShort(
  //     url: "shorts/unpublish/$id",
  //     successMessage: "Short Privat gestellt",
  //     errorMessage: "Short konnte nicht Privat gestellt werden");

  // Future<Either<CustomError, String>> _interactShort({
  //   required String url,
  //   required String successMessage,
  //   required String errorMessage,
  // }) async {
  //   Response res = await put(
  //     Uri.parse("$serverIp/$url"),
  //     headers: await requestHeader(),
  //   );

  //   if (statusIsSuccess(res.statusCode)) {
  //     return Right(successMessage);
  //   } else {
  //     apiErrorHandler.logRes(res, StackTrace.current);
  //     return Left(CustomError(error: errorMessage));
  //   }
  // }

  // Future<ResultModel> reactShort(id, reaction) => _updateShortData(
  //     url: "shorts/reaction/$id",
  //     successMessage: "Reaktion hinzugefügt",
  //     errorMessage: "Du konntest keine Reaktion hinzufügen",
  //     requestBody: {"reaction": reaction});

  // Future<ResultModel> unReactShort(id, reaction) => _updateShortData(
  //     url: "shorts/reaction/remove/$id",
  //     successMessage: "Reaktion entfernt",
  //     errorMessage: "Reaktion konnte nicht entfernt werden",
  //     requestBody: {"reaction": reaction});

  // Future<ResultModel> _updateShortData({
  //   required String url,
  //   required String successMessage,
  //   required String errorMessage,
  //   required Map requestBody,
  // }) async {
  //   ResultModel result = ResultModel(
  //     type: ResultType.success,
  //   );
  //   await put(
  //     Uri.parse("$serverIp/$url"),
  //     headers: await requestHeader(),
  //     body: jsonEncode(requestBody),
  //   ).then((Response res) {
  //     if (statusIsSuccess(res.statusCode)) {
  //       result = ResultModel(
  //         type: ResultType.success,
  //         message: successMessage,
  //       );
  //     } else {
  //       apiErrorHandler.handleAndLog(
  //           responseData: jsonDecode(res.body), trace: StackTrace.current);
  //     }
  //   }).catchError((error) {
  //     apiErrorHandler.handleAndLog(
  //         responseData: error, trace: StackTrace.current);
  //   });
  //   return result;
  // }

  // Future<Either<CustomError, String>> addClap({required int shortId}) async {
  //   Response res = await put(
  //     Uri.parse("$serverIp/shorts/add-clap/$shortId"),
  //     headers: await requestHeader(),
  //   );
  //   if (statusIsSuccess(res.statusCode)) {
  //     return const Right("Geklatscht!");
  //   } else {
  //     apiErrorHandler.logRes(res, StackTrace.current);
  //     return const Left(
  //         CustomError(error: "Ups, du kannst nicht mehr klatschen."));
  //   }
  // }
}
