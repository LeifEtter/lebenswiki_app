import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/repository/backend/base_api.dart';
import 'package:lebenswiki_app/repository/backend/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/presentation/widgets/common/other.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';

class PackApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  PackApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<Either<CustomError, Pack>> getPackById({required int id}) async {
    Response res = await get(
      Uri.parse("$serverIp/packs/pack/$id"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      Pack pack = Pack.fromJson(jsonDecode(res.body)["pack"]);
      return Right(pack);
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
    }
  }

  Future<ResultModel> createPack({required Pack pack}) async {
    Response res = await post(
      Uri.parse("$serverIp/packs/create"),
      headers: await requestHeader(),
      body: jsonEncode(pack.toJson()),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Lernpack erfolgreich erstellt!",
        responseItem: jsonDecode(res.body)["pack"]["id"],
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Das Lernpack konnte nicht erstellt werden",
      );
    }
  }

  Future<ResultModel> getPacksByCategory({required ContentCategory category}) {
    return category.categoryName != "Neu"
        ? getPacks(
            url: "categories/packs/${category.id}",
            errorMessage: "Es wurden keine Lernpacks gefunden")
        : getAllPacks();
  }

  Future<ResultModel> getOwnPublishedpacks() => getPacks(
      url: "packs/published",
      errorMessage: "Du hast noch keine packs veröffentlicht");

  Future<ResultModel> getOwnUnpublishedPacks() => getPacks(
        url: "packs/unpublished",
        errorMessage: "Du hast noch keine Lernpacks entworfen",
      );

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
    ResultModel result = ResultModel(
        type: ResultType.failure, message: errorMessage, responseList: []);
    await get(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    ).then((res) {
      Map body = jsonDecode(res.body);
      if (statusIsSuccess(res.statusCode)) {
        List<Pack> packs = List<Pack>.from(
            body["packs"].map((pack) => Pack.fromJson(pack)).toList());
        result = ResultModel(
          type: ResultType.shortList,
          responseList: packs,
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

  Future<ResultModel> upvotePack(id) => _interactPack(
      url: "packs/upvote/$id",
      successMessage: "Successfully Upvoted Pack",
      errorMessage: "Couldn't Upvote Pack");

  Future<ResultModel> downvotePack(id) => _interactPack(
      url: "packs/downvote/$id",
      successMessage: "Successfully Downvoted Pack",
      errorMessage: "Couldn't Downvote Pack");

  Future<ResultModel> removeUpvotePack(id) => _interactPack(
      url: "packs/upvote/remove/$id",
      successMessage: "Successfully Removed Upvote from Pack",
      errorMessage: "Couldn't Remove Upvote Pack");

  Future<ResultModel> removeDownvotePack(id) => _interactPack(
      url: "packs/downvote/remove/$id",
      successMessage: "Successfully Removed Downvote Pack",
      errorMessage: "Couldn't Remove Downvote Pack");

  Future<ResultModel> bookmarkPack(id) => _interactPack(
      url: "packs/bookmark/$id",
      successMessage: "Successfully Bookmarked Pack",
      errorMessage: "Couldn't bookmark Pack");

  Future<ResultModel> unbookmarkPack(id) => _interactPack(
      url: "packs/unbookmark/$id",
      successMessage: "Successfully Removed Pack from Bookmarks",
      errorMessage: "Couldn't remove Pack from bookmarks");

  Future<ResultModel> deletePack(id) => _interactPackDelete(
      url: "packs/delete/$id",
      successMessage: "Pack successfully deleted",
      errorMessage: "Couldn't delete Pack");

  Future<ResultModel> _interactPack({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    ResultModel result = ResultModel(
        type: ResultType.failure, message: errorMessage, responseList: []);
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

  Future<ResultModel> _interactPackDelete({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    ResultModel result = ResultModel(
        type: ResultType.failure, message: errorMessage, responseList: []);
    await delete(
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

  Future<ResultModel> reactPack(id, reaction) => _updatePackData(
      url: "packs/reaction/$id",
      successMessage: "Successfully added Reaction",
      errorMessage: "Couldn't Add Reaction",
      requestBody: {"reaction": reaction});

  Future<ResultModel> unReactPack(id, reaction) => _updatePackData(
      url: "packs/reaction/remove/$id",
      successMessage: "Successfully Removed Reaction",
      errorMessage: "Couldn't Remove Reaction",
      requestBody: {"reaction": reaction});

  Future<ResultModel> updatePack({required int id, required Pack pack}) =>
      _updatePackData(
          url: "packs/update/$id",
          successMessage: "Pack updated Successfully",
          errorMessage: "Pack couldn't be updated",
          requestBody: pack.toJson());

  Future<ResultModel> _updatePackData({
    required String url,
    required String successMessage,
    required String errorMessage,
    required Map requestBody,
  }) async {
    ResultModel result = ResultModel(
        type: ResultType.failure, message: errorMessage, responseList: []);
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

  Future<ResultModel> publishPack(id) => _interactPackPatch(
      url: "packs/publish/$id",
      successMessage: "Successfully Published Pack",
      errorMessage: "Coldn't publish Pack");

  Future<ResultModel> unpublishPack(id) => _interactPackPatch(
      url: "packs/unpublish/$id",
      successMessage: "Successfully Unpublished Pack",
      errorMessage: "Coldn't Unpublish Pack");

  Future<ResultModel> _interactPackPatch({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    ResultModel result = ResultModel(
        type: ResultType.failure, message: errorMessage, responseList: []);
    await patch(
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
}
