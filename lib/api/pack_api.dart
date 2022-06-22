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
      body: pack.toJson(),
    );
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

  Future<ResultModel> deletePack({required int id}) async {
    Response res = await delete(
      Uri.parse("$serverIp/packs/delete/$id"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
          type: ResultType.success, message: "Lernpack gelöscht");
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
          type: ResultType.failure,
          message: "Lernpack konnte nicht gelöscht werden");
    }
  }

  Future<ResultModel> getAllPacks({category}) async {
    Response res = await get(
      Uri.parse("$serverIp/packs/"),
      headers: await requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List packsJson = resBody["packs"];
      return ResultModel(
        type: ResultType.packList,
        responseList: packsJson.map((pack) => Pack.fromJson(pack)).toList(),
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        responseList: [],
        message: "Es wurden keine packs gefunden",
      );
    }
  }

  Future<ResultModel> getPacksByCategory(
      {required ContentCategory category}) async {
    Response res = await get(
      Uri.parse("$serverIp/categories/packs/${category.id}"),
      headers: await requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Pack> packs = resBody["packsByCategory"]
          .map((pack) => Pack.fromJson(pack))
          .toList();
      return ResultModel(
        type: ResultType.packList,
        responseList: packs,
      );
    } else {
      print("Error");
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        responseList: [],
        message: "Es wurden keine Lernpacks gefunden",
      );
    }
  }

  Future<ResultModel> getBookmarkedPacks() async {
    Response res = await get(
      Uri.parse("$serverIp/packs/bookmarks"),
      headers: await requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Pack> packs = resBody["body"].map((pack) => Pack.fromJson(pack));
      return ResultModel(
        type: ResultType.packList,
        responseList: packs,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        responseList: [],
        message: "Du hast keine Lernpacks gespeichert",
      );
    }
  }

  Future<ResultModel> getCreatorsDraftPacks() async {
    Response res = await get(
      Uri.parse("$serverIp/packs/unpublished"),
      headers: await requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Pack> packs = resBody["body"].map((pack) => Pack.fromJson(pack));
      return ResultModel(
        type: ResultType.packList,
        responseList: packs,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        responseList: [],
        message: "Du hast keine packs entworfen",
      );
    }
  }

  Future<ResultModel> getOwnPublishedpacks() =>
      _getCreatorsPublishedPacks(isOwn: true);
  Future<ResultModel> getOthersPublishedpacks() =>
      _getCreatorsPublishedPacks(isOwn: false);

  Future<ResultModel> _getCreatorsPublishedPacks({required bool isOwn}) async {
    Response res = await get(
      Uri.parse("$serverIp/packs/published"),
      headers: await requestHeader(),
    );
    Map resBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<Pack> packs = resBody["body"].map((pack) => pack.fromJson(pack));
      return ResultModel(
        type: ResultType.packList,
        responseList: packs,
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.success,
        responseList: [],
        message:
            "${isOwn ? "Du hast" : "Dieser Benutzer hat"} noch keine packs veröffentlicht",
      );
    }
  }

  Future<ResultModel> upvotePack(id) => _votingPack(isUpvote: true, id: id);
  Future<ResultModel> downvotePack(id) => _votingPack(isUpvote: false, id: id);

  Future<ResultModel> _votingPack({
    required bool isUpvote,
    required int id,
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/packs/${isUpvote ? "upvote" : "downvote"}/$id"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Succesfully ${isUpvote ? "upvoted" : "downvoted"} pack",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Couldn't ${isUpvote ? "upvote" : "downvote"} pack",
      );
    }
  }

  Future<ResultModel> removeUpvotePack(id) =>
      _removeVotingPack(isUpvote: true, id: id);
  Future<ResultModel> removeDownvotePack(id) =>
      _removeVotingPack(isUpvote: false, id: id);

  Future<ResultModel> _removeVotingPack({
    required bool isUpvote,
    required int id,
  }) async {
    Response res = await put(
      Uri.parse(
          "$serverIp/packs/${isUpvote ? "upvote" : "downvote"}/remove/$id"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message:
            "Succesfully removed ${isUpvote ? "upvoted" : "downvoted"} for pack",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Couldn't remove ${isUpvote ? "upvote" : "downvote"} for pack",
      );
    }
  }

  Future<ResultModel> bookmarkPack(id) =>
      _bookmarkingPack(id: id, isUnbookmark: false);
  Future<ResultModel> unbookmarkPack(id) =>
      _bookmarkingPack(id: id, isUnbookmark: true);

  Future<ResultModel> _bookmarkingPack({
    required int id,
    required bool isUnbookmark,
  }) async {
    Response res = await put(
      Uri.parse(
          "$serverIp/packs/${isUnbookmark ? "unbookmark" : "bookmark"}/$id"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message:
            "pack Erfolgreich ${isUnbookmark ? "von gespeicherten packs entfernt" : "gespeichert"}",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
          type: ResultType.failure,
          message:
              "Konnte pack nicht ${isUnbookmark ? "von gespeicherten packs entfernen" : "speichern"}");
    }
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

  Future<ResultModel> publishPack(id) =>
      _publishingPack(id: id, isUnpublish: false);
  Future<ResultModel> unpublishPack(id) =>
      _publishingPack(id: id, isUnpublish: true);

  Future<ResultModel> _publishingPack({
    required int id,
    required bool isUnpublish,
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/packs/${isUnpublish ? "unpublish" : "publish"}/$id"),
      headers: await requestHeader(),
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
