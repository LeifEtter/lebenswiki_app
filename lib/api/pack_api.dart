import 'dart:convert';
import 'package:lebenswiki_app/api/base_api.dart';
import 'package:lebenswiki_app/api/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/api/result_model_api.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/report_model.dart';

class PackApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  PackApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> createPack({required Pack pack}) async {
    Response res = await post(
      Uri.parse("$serverIp/packs/create"),
      headers: await requestHeader(),
      body: jsonEncode(pack.toJson()),
    );
    print(res.body);
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Lernpack erfolgreich erstellt!",
        responseItem: jsonDecode(res.body)["body"]["id"],
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Das Lernpack konnte nicht erstellt werden",
      );
    }
  }

  Future<ResultModel> updateCreatorPack({
    required Pack pack,
    required int id,
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/packs/update/$id"),
      headers: await requestHeader(),
      body: jsonEncode(pack.toJson()),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
          type: ResultType.success, message: "Lernpack Geändert");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
          type: ResultType.failure,
          message: "Lernpack konnte nicht geändert Werden");
    }
  }

  Future<ResultModel> getPacksByCategory({required ContentCategory category}) =>
      getPacks(
          url: "categories/packs/${category.id}",
          errorMessage: "Es wurden keine Lernpacks gefunden");

  Future<ResultModel> getOwnPublishedpacks() => getPacks(
      url: "packs/published",
      errorMessage: "Du hast noch keine packs veröffentlicht");

  Future<ResultModel> getOthersPublishedpacks() => getPacks(
      url: "packs/published",
      errorMessage: "Dieser Benutzer hat noch keine packs veröffentlicht");

  Future<ResultModel> getAllPacks() => getPacks(
      url: "packs/", errorMessage: "Es wurden keine Lernpacks gefunden");

  Future<ResultModel> getBookmarkedPacks() => getPacks(
      url: "packs/bookmarks",
      errorMessage: "Du hast keine Lernpacks gespeichert");

  Future<ResultModel> getCreatorsDraftPacks() => getPacks(
      url: "packs/unpublished", errorMessage: "Du hast keine packs entworfen");

  Future<ResultModel> getPacks({url, errorMessage}) async {
    await get(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    ).then((res) {
      Map body = jsonDecode(res.body);
      if (statusIsSuccess(res)) {
        List<Pack> packs = body["body"].map((pack) => Pack.fromJson(pack));
        return ResultModel(
          type: ResultType.packList,
          responseList: packs,
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: body);
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return ResultModel(
      type: ResultType.failure,
      message: errorMessage,
    );
  }

  Future<ResultModel> upvotePack(id) => interactPack(
      url: "packs/upvote/$id",
      successMessage: "Successfully Upvoted Pack",
      errorMessage: "Couldn't Upvote Pack");

  Future<ResultModel> downvotePack(id) => interactPack(
      url: "packs/downvote/$id",
      successMessage: "Successfully Downvoted Pack",
      errorMessage: "Couldn't Downvote Pack");

  Future<ResultModel> removeUpvotePack(id) => interactPack(
      url: "packs/upvote/remove/$id",
      successMessage: "Successfully Removed Upvote from Pack",
      errorMessage: "Couldn't Remove Upvote Pack");

  Future<ResultModel> removeDownvotePack(id) => interactPack(
      url: "packs/downvote/remove/$id",
      successMessage: "Successfully Removed Downvote Pack",
      errorMessage: "Couldn't Remove Downvote Pack");

  Future<ResultModel> bookmarkPack(id) => interactPack(
      url: "packs/bookmark/$id",
      successMessage: "Successfully Bookmarked Pack",
      errorMessage: "Couldn't bookmark Pack");

  Future<ResultModel> unbookmarkPack(id) => interactPack(
      url: "packs/unbookmark/$id",
      successMessage: "Successfully Removed Pack from Bookmarks",
      errorMessage: "Couldn't remove Pack from bookmarks");

  Future<ResultModel> publishPack(id) => interactPack(
      url: "packs/publish/$id",
      successMessage: "Successfully Published Pack",
      errorMessage: "Coldn't publish Pack");

  Future<ResultModel> unpublishPack(id) => interactPack(
      url: "packs/unpublish/$id",
      successMessage: "Successfully Unpublished Pack",
      errorMessage: "Coldn't Unpublish Pack");

  Future<ResultModel> deletePack(id) => interactPackDelete(
      url: "packs/delete/$id",
      successMessage: "Pack successfully deleted",
      errorMessage: "Couldn't delete Pack");

  Future<ResultModel> interactPack({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    await put(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        return ResultModel(
          type: ResultType.success,
          message: successMessage,
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return ResultModel(
      type: ResultType.failure,
      message: errorMessage,
    );
  }

  Future<ResultModel> interactPackDelete({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    await delete(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        return ResultModel(
          type: ResultType.success,
          message: successMessage,
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return ResultModel(
      type: ResultType.failure,
      message: errorMessage,
    );
  }

  Future<ResultModel> reactPack(id, reaction) =>
      _reactingPack(id: id, isRemove: false, reaction: reaction);
  Future<ResultModel> unreactPack(id) => _reactingPack(id: id, isRemove: true);

  Future<ResultModel> _reactingPack({
    required int id,
    required bool isRemove,
    String reaction = "",
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/packs/reaction${isRemove ? "/remove" : ""}/$id"),
      headers: await requestHeader(),
      body: jsonEncode({"reaction": reaction}),
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

  Future<ResultModel> reportPack({
    required Report report,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/reports/create/pack/${report.reportedContentId}"),
      headers: await requestHeader(),
      body: jsonEncode({
        "reason": report.reason,
      }),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "pack wurde erfolgreich gemeldet",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "pack konnte nicht gemeldet werden",
      );
    }
  }

  Future<ResultModel> commentPack({
    required int id,
    required String comment,
  }) async {
    Response res = await post(Uri.parse("$serverIp/comments/create/packs/$id"),
        headers: await requestHeader(), body: jsonEncode({"comment": comment}));
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

  Future<ResultModel> addCommentReaction({
    required int id,
    required String reaction,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/comments/reaction/$id"),
      headers: await requestHeader(),
      body: jsonEncode({"reaction": reaction}),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Reagiert",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Konnte nicht reagieren",
      );
    }
  }
}
