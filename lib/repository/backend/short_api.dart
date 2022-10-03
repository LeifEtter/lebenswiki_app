import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/repository/backend/base_api.dart';
import 'package:lebenswiki_app/repository/backend/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';

class ShortApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  ShortApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<Either<CustomError, String>> createShort(
      {required Short short}) async {
    Response res = await post(Uri.parse("$serverIp/shorts/create"),
        headers: await requestHeader(),
        body: jsonEncode({
          "title": short.title,
          "categories": [short.categories.first.id],
          "content": short.content,
        }));

    if (statusIsSuccess(res.statusCode)) {
      return const Right("Short wurde Erstellt");
    } else {
      apiErrorHandler.logRes(res);
      return const Left(
          CustomError(error: "Short konnten nicht Erstellt werden"));
    }
  }

  Future<Either<CustomError, String>> deleteShort({required int id}) async {
    Response res = await delete(
      Uri.parse("$serverIp/shorts/delete/$id"),
      headers: await requestHeader(),
    );

    if (statusIsSuccess(res.statusCode)) {
      return const Right("Short wurde gelöscht");
    } else {
      return const Left(
          CustomError(error: "Short konnte nicht gelöscht werden"));
    }
  }

  Future<Either<CustomError, Short>> getShortById({required int id}) async {
    Response res = await get(
      Uri.parse("$serverIp/shorts"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return Right(Short.fromJson(jsonDecode(res.body)["short"]));
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Short wurde nicht gefunden"));
    }
  }

  Future<Either<CustomError, List<Short>>> getShortsByCategory(
      {required ContentCategory category}) {
    return category.categoryName != "Neu"
        ? _getShorts(
            url: "categories/shorts/${category.id}",
            errorMessage: "Es wurden keine shorts gefunden")
        : getAllShorts();
  }

  Future<Either<CustomError, List<Short>>> getAllShorts() => _getShorts(
      url: "shorts/", errorMessage: "Es wurden keine shorts gefunden");

  Future<Either<CustomError, List<Short>>> getOwnPublishedShorts() =>
      _getShorts(
          url: "shorts/published",
          errorMessage: "Du hast noch keine shorts veröffentlicht");

  //TODO implement correct root
  Future<Either<CustomError, List<Short>>> getOthersPublishedShorts() =>
      _getShorts(
          url: "shorts/published",
          errorMessage: "Dieser Benutzer hat noch keine shorts veröffentlicht");

  Future<Either<CustomError, List<Short>>> getBookmarkedShorts() => _getShorts(
      url: "shorts/bookmarks",
      errorMessage: "Du hast keine shorts gespeichert");

  Future<Either<CustomError, List<Short>>> getCreatorsDraftShorts() =>
      _getShorts(
        url: "shorts/unpublished",
        errorMessage: "Du hast keine shorts entworfen",
      );

  Future<Either<CustomError, List<Short>>> _getShorts(
      {url, errorMessage}) async {
    Response res = await get(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      List<Short> shorts = List<Short>.from(jsonDecode(res.body)["shorts"]
          .map((short) => Short.fromJson(short))
          .toList());
      return Right(shorts);
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Keine Shorts gefunden"));
    }
  }

  Future<Either<CustomError, String>> upvoteShort(id) => _interactShort(
      url: "shorts/upvote/$id",
      successMessage: "Successfully Upvoted Short",
      errorMessage: "Couldn't Upvote Short");

  Future<Either<CustomError, String>> downvoteShort(id) => _interactShort(
      url: "shorts/downvote/$id",
      successMessage: "Successfully Downvoted Short",
      errorMessage: "Couldn't Downvote Short");

  Future<Either<CustomError, String>> removeUpvoteShort(id) => _interactShort(
      url: "shorts/upvote/remove/$id",
      successMessage: "Successfully Removed Upvote from Short",
      errorMessage: "Couldn't Remove Upvote Short");

  Future<Either<CustomError, String>> removeDownvoteShort(id) => _interactShort(
      url: "shorts/downvote/remove/$id",
      successMessage: "Successfully Removed Downvote Short",
      errorMessage: "Couldn't Remove Downvote Short");

  Future<Either<CustomError, String>> bookmarkShort(id) => _interactShort(
      url: "shorts/bookmark/$id",
      successMessage: "Successfully Bookmarked Short",
      errorMessage: "Couldn't bookmark Short");

  Future<Either<CustomError, String>> unbookmarkShort(id) => _interactShort(
      url: "shorts/unbookmark/$id",
      successMessage: "Successfully Removed Short from Bookmarks",
      errorMessage: "Couldn't remove Short from bookmarks");

  Future<Either<CustomError, String>> publishShort(id) => _interactShort(
      url: "shorts/publish/$id",
      successMessage: "Successfully Published Short",
      errorMessage: "Coldn't publish Short");

  Future<Either<CustomError, String>> unpublishShort(id) => _interactShort(
      url: "shorts/unpublish/$id",
      successMessage: "Successfully Unpublished Short",
      errorMessage: "Coldn't Unpublish Short");

  Future<Either<CustomError, String>> _interactShort({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    );

    if (statusIsSuccess(res.statusCode)) {
      return Right(successMessage);
    } else {
      apiErrorHandler.logRes(res);
      return Left(CustomError(error: errorMessage));
    }
  }

  Future<ResultModel> reactShort(id, reaction) => _updateShortData(
      url: "shorts/reaction/$id",
      successMessage: "Successfully added Reaction",
      errorMessage: "Couldn't Add Reaction",
      requestBody: {"reaction": reaction});

  Future<ResultModel> unReactShort(id, reaction) => _updateShortData(
      url: "shorts/reaction/remove/$id",
      successMessage: "Successfully Removed Reaction",
      errorMessage: "Couldn't Remove Reaction",
      requestBody: {"reaction": reaction});

  Future<ResultModel> _updateShortData({
    required String url,
    required String successMessage,
    required String errorMessage,
    required Map requestBody,
  }) async {
    ResultModel result = ResultModel(
      type: ResultType.success,
    );
    await put(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
      body: jsonEncode(requestBody),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        result = ResultModel(
          type: ResultType.success,
          message: successMessage,
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return result;
  }
}
