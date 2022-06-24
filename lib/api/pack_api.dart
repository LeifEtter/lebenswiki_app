import 'dart:convert';
import 'package:lebenswiki_app/api/general/base_api.dart';
import 'package:lebenswiki_app/api/general/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';

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
    Pack? pack,
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

  Future<ResultModel> reactPack(id, reaction) => updatePackData(
      url: "packs/reaction/$id",
      successMessage: "Successfully added Reaction",
      errorMessage: "Couldn't Add Reaction",
      requestBody: {"reaction": reaction});

  Future<ResultModel> unReactPack(id, reaction) => updatePackData(
      url: "packs/reaction/remove/$id",
      successMessage: "Successfully Removed Reaction",
      errorMessage: "Couldn't Remove Reaction",
      requestBody: {"reaction": reaction});

  Future<ResultModel> updatePack({required int id, required Pack pack}) =>
      updatePackData(
          url: "packs/update/$id",
          successMessage: "Pack updated Successfully",
          errorMessage: "Pack couldn't be updated",
          requestBody: pack.toJson());

  Future<ResultModel> updatePackData({
    required String url,
    required String successMessage,
    required String errorMessage,
    required Map requestBody,
  }) async {
    await put(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
      body: jsonEncode(requestBody),
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
}
