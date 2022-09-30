import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/repository/backend/base_api.dart';
import 'package:lebenswiki_app/repository/backend/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
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

  Future<Either<CustomError, int>> createPack({required Pack pack}) async {
    Response res = await post(
      Uri.parse("$serverIp/packs/create"),
      headers: await requestHeader(),
      body: jsonEncode(pack.toJson()),
    );

    if (statusIsSuccess(res.statusCode)) {
      int id = jsonDecode(res.body)["pack"]["id"];
      return Right(id);
    } else {
      apiErrorHandler.logRes(res);
      return const Left(
          CustomError(error: "Pack konnte nicht erstellt werden"));
    }
  }

  Future<Either<CustomError, List<Pack>>> getPacksByCategory(
      {required ContentCategory category}) {
    return category.categoryName != "Neu"
        ? getPacks(
            url: "categories/packs/${category.id}",
            errorMessage: "Es wurden keine Lernpacks gefunden")
        : getAllPacks();
  }

  Future<Either<CustomError, List<Pack>>> getOwnPublishedpacks() => getPacks(
      url: "packs/creator",
      errorMessage: "Du hast noch keine packs veröffentlicht");

  Future<Either<CustomError, List<Pack>>> getOwnUnpublishedPacks() => getPacks(
        url: "packs/unpublished",
        errorMessage: "Du hast noch keine Lernpacks entworfen",
      );

  Future<Either<CustomError, List<Pack>>> getOthersPublishedpacks() => getPacks(
      url: "packs/published",
      errorMessage: "Dieser Benutzer hat noch keine packs veröffentlicht");

  Future<Either<CustomError, List<Pack>>> getAllPacks() => getPacks(
      url: "packs/", errorMessage: "Es wurden keine Lernpacks gefunden");

  Future<Either<CustomError, List<Pack>>> getBookmarkedPacks() => getPacks(
      url: "packs/bookmarks",
      errorMessage: "Du hast keine Lernpacks gespeichert");

  Future<Either<CustomError, List<Pack>>> getCreatorsDraftPacks() => getPacks(
      url: "packs/unpublished", errorMessage: "Du hast keine packs entworfen");

  Future<Either<CustomError, List<Pack>>> getPacks({url, errorMessage}) async {
    Response res = await get(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    );

    if (statusIsSuccess(res.statusCode)) {
      List<Pack> packs = List<Pack>.from(jsonDecode(res.body)["packs"]
          .map((pack) => Pack.fromJson(pack))
          .toList());
      return Right(packs);
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Konnte kein Packs finden"));
    }
  }

  Future<Either<CustomError, String>> upvotePack(id) => _interactPack(
      url: "packs/upvote/$id",
      successMessage: "Successfully Upvoted Pack",
      errorMessage: "Couldn't Upvote Pack");

  Future<Either<CustomError, String>> downvotePack(id) => _interactPack(
      url: "packs/downvote/$id",
      successMessage: "Successfully Downvoted Pack",
      errorMessage: "Couldn't Downvote Pack");

  Future<Either<CustomError, String>> removeUpvotePack(id) => _interactPack(
      url: "packs/upvote/remove/$id",
      successMessage: "Successfully Removed Upvote from Pack",
      errorMessage: "Couldn't Remove Upvote Pack");

  Future<Either<CustomError, String>> removeDownvotePack(id) => _interactPack(
      url: "packs/downvote/remove/$id",
      successMessage: "Successfully Removed Downvote Pack",
      errorMessage: "Couldn't Remove Downvote Pack");

  Future<Either<CustomError, String>> bookmarkPack(id) => _interactPack(
      url: "packs/bookmark/$id",
      successMessage: "Pack erfolgreich Gespeichert",
      errorMessage: "Konnte Pack nicht speichern");

  Future<Either<CustomError, String>> unbookmarkPack(id) => _interactPack(
      url: "packs/unbookmark/$id",
      successMessage: "Pack erfolgreich von gespeicherten Packs entfernt",
      errorMessage:
          "Pack konnte nicht von gespeicherten Packs entfernt werden");

  Future<Either<CustomError, String>> deletePack(id) => _interactPackDelete(
      url: "packs/delete/$id",
      successMessage: "Pack successfully deleted",
      errorMessage: "Couldn't delete Pack");

  Future<Either<CustomError, String>> _interactPack({
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

  Future<Either<CustomError, String>> _interactPackDelete({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    Response res = await delete(
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

  Future<Either<CustomError, String>> reactPack(id, reaction) =>
      _updatePackData(
          url: "packs/reaction/$id",
          successMessage: "Successfully added Reaction",
          errorMessage: "Couldn't Add Reaction",
          requestBody: {"reaction": reaction});

  Future<Either<CustomError, String>> unReactPack(id, reaction) =>
      _updatePackData(
          url: "packs/reaction/remove/$id",
          successMessage: "Successfully Removed Reaction",
          errorMessage: "Couldn't Remove Reaction",
          requestBody: {"reaction": reaction});

  Future<Either<CustomError, String>> updatePack(
          {required int id, required Pack pack}) =>
      _updatePackData(
          url: "packs/update/$id",
          successMessage: "Pack updated Successfully",
          errorMessage: "Pack couldn't be updated",
          requestBody: pack.toJson());

  Future<Either<CustomError, String>> _updatePackData({
    required String url,
    required String successMessage,
    required String errorMessage,
    required Map requestBody,
  }) async {
    Response res = await put(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
      body: jsonEncode(requestBody),
    );

    if (statusIsSuccess(res.statusCode)) {
      return const Right("Pack Gespeichert");
    } else {
      apiErrorHandler.logRes(res);
      return const Left(
          CustomError(error: "Pack konnte nicht gespeichert werden."));
    }
  }

  Future<Either<CustomError, String>> publishPack(id) => _interactPackPatch(
      url: "packs/publish/$id",
      successMessage: "Pack Veröffentlicht",
      errorMessage: "Pack konnte nicht veröffentlicht werden");

  Future<Either<CustomError, String>> unpublishPack(id) => _interactPackPatch(
      url: "packs/unpublish/$id",
      successMessage: "Pack Privat gemacht",
      errorMessage: "Pack konnte nicht privat gemacht werden");

  Future<Either<CustomError, String>> _interactPackPatch({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    Response res = await patch(
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

  Future<Either<CustomError, String>> addClap({required int packId}) async {
    Response res = await patch(
      Uri.parse("$serverIp/packs/add-clap/$packId"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Geklatscht!");
    } else {
      apiErrorHandler.logRes(res);
      return const Left(
          CustomError(error: "Ups, du kannst nicht mehr klatschen."));
    }
  }
}
