import 'dart:convert';
import 'package:lebenswiki_app/api/general/base_api.dart';
import 'package:lebenswiki_app/api/general/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';

//TODO Implement extracting error message with "error" property
//TODO fix api results and add error messages
class ShortApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  ShortApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> createShort({required Short short}) async {
    ResultModel result = ResultModel(
      type: ResultType.failure,
    );
    await post(
      Uri.parse("$serverIp/shorts/create"),
      headers: await requestHeader(),
      body: jsonEncode({
        "title": short.title,
        "categories": [short.categories.first.id],
        "content": short.content,
      }),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        result = ResultModel(
          type: ResultType.success,
          message: "Short Erfolgreich Erstellt",
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    });
    return result;
  }

  Future<ResultModel> deleteShort({required int id}) async {
    ResultModel result = ResultModel(
      type: ResultType.success,
    );
    await delete(
      Uri.parse("$serverIp/shorts/delete/$id"),
      headers: await requestHeader(),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        result = ResultModel(
          type: ResultType.success,
          message: "Short Erfolgreich Gelöscht",
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return result;
  }

  Future<ResultModel> getShortsByCategory({required ContentCategory category}) {
    return category.categoryName != "Neu"
        ? _getShorts(
            url: "categories/shorts/${category.id}",
            errorMessage: "Es wurden keine shorts gefunden")
        : getAllShorts();
  }

  Future<ResultModel> getAllShorts() => _getShorts(
      url: "shorts/", errorMessage: "Es wurden keine shorts gefunden");

  Future<ResultModel> getOwnPublishedShorts() => _getShorts(
      url: "shorts/published",
      errorMessage: "Du hast noch keine shorts veröffentlicht");

  //TODO implement correct root
  Future<ResultModel> getOthersPublishedShorts() => _getShorts(
      url: "shorts/published",
      errorMessage: "Dieser Benutzer hat noch keine shorts veröffentlicht");

  Future<ResultModel> getBookmarkedShorts() => _getShorts(
      url: "shorts/bookmarks",
      errorMessage: "Du hast keine shorts gespeichert");

  Future<ResultModel> getCreatorsDraftShorts() => _getShorts(
        url: "shorts/unpublished",
        errorMessage: "Du hast keine shorts entworfen",
      );

  Future<ResultModel> _getShorts({url, errorMessage}) async {
    ResultModel result = ResultModel(
        type: ResultType.failure, message: errorMessage, responseList: []);
    await get(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    ).then((res) {
      Map body = jsonDecode(res.body);
      if (statusIsSuccess(res.statusCode)) {
        List<Short> shorts = List<Short>.from(
            body["shorts"].map((short) => Short.fromJson(short)).toList());
        result = ResultModel(
          type: ResultType.shortList,
          responseList: shorts,
          message: errorMessage,
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: body);
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return result;
  }

  Future<ResultModel> upvoteShort(id) => _interactShort(
      url: "shorts/upvote/$id",
      successMessage: "Successfully Upvoted Short",
      errorMessage: "Couldn't Upvote Short");

  Future<ResultModel> downvoteShort(id) => _interactShort(
      url: "shorts/downvote/$id",
      successMessage: "Successfully Downvoted Short",
      errorMessage: "Couldn't Downvote Short");

  Future<ResultModel> removeUpvoteShort(id) => _interactShort(
      url: "shorts/upvote/remove/$id",
      successMessage: "Successfully Removed Upvote from Short",
      errorMessage: "Couldn't Remove Upvote Short");

  Future<ResultModel> removeDownvoteShort(id) => _interactShort(
      url: "shorts/downvote/remove/$id",
      successMessage: "Successfully Removed Downvote Short",
      errorMessage: "Couldn't Remove Downvote Short");

  Future<ResultModel> bookmarkShort(id) => _interactShort(
      url: "shorts/bookmark/$id",
      successMessage: "Successfully Bookmarked Short",
      errorMessage: "Couldn't bookmark Short");

  Future<ResultModel> unbookmarkShort(id) => _interactShort(
      url: "shorts/unbookmark/$id",
      successMessage: "Successfully Removed Short from Bookmarks",
      errorMessage: "Couldn't remove Short from bookmarks");

  Future<ResultModel> publishShort(id) => _interactShort(
      url: "shorts/publish/$id",
      successMessage: "Successfully Published Short",
      errorMessage: "Coldn't publish Short");

  Future<ResultModel> unpublishShort(id) => _interactShort(
      url: "shorts/unpublish/$id",
      successMessage: "Successfully Unpublished Short",
      errorMessage: "Coldn't Unpublish Short");

  Future<ResultModel> _interactShort({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    ResultModel result = ResultModel(type: ResultType.failure);
    await put(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
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

  //TODO Implement Update Short
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
