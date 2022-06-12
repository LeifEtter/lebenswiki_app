import 'dart:convert';
import 'package:lebenswiki_app/api/api_models/base_api.dart';
import 'package:lebenswiki_app/api/api_models/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/api/api_models/result_model_api.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';

class ShortApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  ShortApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> createShort(
    String title,
    List categories,
    String content,
  ) async {
    Response res = await post(Uri.parse("$serverIp/shorts/create"),
        headers: requestHeader(),
        body: jsonEncode({
          "title": title,
          "categories": categories,
          "content": content,
        }));
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Lernpack erfolgreich erstellt!",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Das Lernpack konnte nicht erstellt werden",
      );
    }
  }

  Future<ResultModel> deleteShort({required int id}) async {
    Response res = await delete(
      Uri.parse("$serverIp/shorts/delete/$id"),
      headers: requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(type: ResultType.success, message: "Short gelöscht");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
          type: ResultType.failure,
          message: "Short konnte nicht gelöscht werden");
    }
  }

  Future<ResultModel> getAllShorts() async {
    Response res = await get(
      Uri.parse("$serverIp/shorts/"),
      headers: requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Short> shorts =
          resBody["shorts"].map((short) => Short.fromJson(short));
      return ResultModel(
        type: ResultType.shortList,
        shorts: shorts,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        shorts: [],
        message: "Es wurden keine shorts gefunden",
      );
    }
  }

  Future<ResultModel> getShortsByCategory(
      {required ContentCategory category}) async {
    Response res = await get(
      Uri.parse("$serverIp/shorts/${category.id}"),
      headers: requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Short> shorts =
          resBody["category"]["shorts"].map((short) => Short.fromJson(short));
      return ResultModel(
        type: ResultType.shortList,
        shorts: shorts,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        shorts: [],
        message: "Es wurden keine shorts gefunden",
      );
    }
  }

  Future<ResultModel> getBookmarkedShorts() async {
    Response res = await get(
      Uri.parse("$serverIp/shorts/bookmarks"),
      headers: requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Short> shorts =
          resBody["body"].map((short) => Short.fromJson(short));
      return ResultModel(
        type: ResultType.shortList,
        shorts: shorts,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        shorts: [],
        message: "Du hast keine Shorts gespeichert",
      );
    }
  }

  Future<ResultModel> getCreatorsDraftShorts() async {
    Response res = await get(
      Uri.parse("$serverIp/shorts/unpublished"),
      headers: requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Short> shorts =
          resBody["body"].map((short) => Short.fromJson(short));
      return ResultModel(
        type: ResultType.shortList,
        shorts: shorts,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        shorts: [],
        message: "Du hast keine Shorts entworfen",
      );
    }
  }

  Future<ResultModel> getOwnPublishedShorts() =>
      getCreatorsPublishedShorts(isOwn: true);
  Future<ResultModel> getOthersPublishedShorts() =>
      getCreatorsPublishedShorts(isOwn: false);

  Future<ResultModel> getCreatorsPublishedShorts({required bool isOwn}) async {
    Response res = await get(
      Uri.parse("$serverIp/shorts/published"),
      headers: requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Short> shorts =
          resBody["body"].map((short) => Short.fromJson(short));
      return ResultModel(
        type: ResultType.shortList,
        shorts: shorts,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        shorts: [],
        message:
            "${isOwn ? "Du hast" : "Dieser Benutzer hat"} noch keine Shorts veröffentlicht",
      );
    }
  }

  Future<ResultModel> upvoteShort(id) => votingShort(isUpvote: true, id: id);
  Future<ResultModel> downvoteShort(id) => votingShort(isUpvote: false, id: id);

  Future<ResultModel> votingShort({
    required bool isUpvote,
    required int id,
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/shorts/${isUpvote ? "upvote" : "downvote"}/$id"),
      headers: requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Succesfully ${isUpvote ? "upvoted" : "downvoted"} Short",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Couldn't ${isUpvote ? "upvote" : "downvote"} Short",
      );
    }
  }

  Future<ResultModel> removeUpvoteShort(id) =>
      removeVotingShort(isUpvote: true, id: id);
  Future<ResultModel> removeDownvoteShort(id) =>
      removeVotingShort(isUpvote: false, id: id);

  Future<ResultModel> removeVotingShort({
    required bool isUpvote,
    required int id,
  }) async {
    Response res = await put(
      Uri.parse(
          "$serverIp/shorts/${isUpvote ? "upvote" : "downvote"}/remove/$id"),
      headers: requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message:
            "Succesfully removed ${isUpvote ? "upvoted" : "downvoted"} for Short",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message:
            "Couldn't remove ${isUpvote ? "upvote" : "downvote"} for Short",
      );
    }
  }

  Future<ResultModel> bookmarkShort(id) =>
      bookmarkingShort(id: id, isUnbookmark: false);
  Future<ResultModel> unbookmarkShort(id) =>
      bookmarkingShort(id: id, isUnbookmark: true);

  Future<ResultModel> bookmarkingShort({
    required int id,
    required bool isUnbookmark,
  }) async {
    Response res = await put(
      Uri.parse(
          "$serverIp/shorts/${isUnbookmark ? "unbookmark" : "bookmark"}/$id"),
      headers: requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message:
            "Short Erfolgreich ${isUnbookmark ? "von gespeicherten Shorts entfernt" : "gespeichert"}",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
          type: ResultType.failure,
          message:
              "Konnte Short nicht ${isUnbookmark ? "von gespeicherten Shorts entfernen" : "speichern"}");
    }
  }

  Future<ResultModel> reactShort(id) => reactingShort(id: id, isRemove: false);
  Future<ResultModel> unreactShort(id) => reactingShort(id: id, isRemove: true);

  Future<ResultModel> reactingShort({
    required int id,
    required bool isRemove,
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/shorts/reaction${isRemove ? "/remove" : ""}/$id"),
      headers: requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Reagiert",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
          type: ResultType.failure, message: "Konnte nicht reagieren");
    }
  }

  Future<ResultModel> publishShort(id) =>
      publishingShort(id: id, isUnpublish: false);
  Future<ResultModel> unpublishShort(id) =>
      publishingShort(id: id, isUnpublish: true);

  Future<ResultModel> publishingShort({
    required int id,
    required bool isUnpublish,
  }) async {
    Response res = await put(
      Uri.parse(
          "$serverIp/shorts/${isUnpublish ? "unpublish" : "publish"}/$id"),
      headers: requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Reagiert",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
          type: ResultType.failure, message: "Konnte nicht reagieren");
    }
  }

  Future<ResultModel> reportShort({
    required Report report,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/reports/create/short/${report.reportedContentId}"),
      headers: requestHeader(),
      body: jsonEncode({
        "reason": report.reason,
      }),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Short wurde erfolgreich gemeldet",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Short konnte nicht gemeldet werden",
      );
    }
  }

  Future<ResultModel> commentShort({
    required int id,
    required String comment,
  }) async {
    Response res = await post(Uri.parse("$serverIp/comments/create/shorts/$id"),
        headers: requestHeader(), body: jsonEncode({"comment": comment}));
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Erfolgreich Kommentiert",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Kommentar konnte nicht erstellt werden",
      );
    }
  }

  Future<ResultModel> addCommentRection() {}
}
