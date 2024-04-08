import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/data/base_api.dart';
import 'package:lebenswiki_app/data/error_handler.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';

class PackApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  PackApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<Either<CustomError, Pack>> getPackById({required int id}) async {
    try {
      Response res = await get(
        Uri.parse("$serverIp/pack/view/$id"),
        headers: await requestHeader(),
      );
      if (statusIsSuccess(res.statusCode)) {
        Map<String, dynamic> body = jsonDecode(res.body);
        Pack pack = Pack.fromJson(body);
        return Right(pack);
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: error.toString()));
    }
  }

  Future<Either<CustomError, String>> deletePack(int id) async {
    try {
      Response res = await delete(
        Uri.parse("$serverIp/pack/own/delete/$id"),
        headers: await requestHeader(),
      );
      if (res.statusCode == 200) {
        return const Right("Pack gelöscht");
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
      }
    } catch (error) {
      log("Error while deleting pack");
      log(error.toString());
      throw StackTrace;
    }
  }

  Future<Either<CustomError, Pack>> createPack(Pack pack) async {
    try {
      Response res = await post(Uri.parse("$serverIp/pack/create"),
          headers: await requestHeader(), body: jsonEncode(pack));
      log(res.body);
      if (res.statusCode == 201) {
        log("Saved");
        Pack pack = Pack.fromJson(await jsonDecode(res.body));
        return Right(pack);
      } else {
        return Left(handleError(res));
      }
    } catch (error) {
      return Left(CustomError(error: ApiError.forUnknown().message));
    }
  }

  Future<Either<CustomError, Pack>> updatePack(Pack pack, int packId) async {
    try {
      Response res = await put(Uri.parse("$serverIp/pack/update/$packId"),
          headers: await requestHeader(), body: jsonEncode(pack));
      if (res.statusCode == 200) {
        inspect(jsonDecode(res.body));
        Pack pack = Pack.fromJson(await jsonDecode(res.body));
        return Right(pack);
      } else {
        return Left(handleError(res));
      }
    } catch (error) {
      print(error);
      return Left(CustomError(error: ApiError.forUnknown().message));
    }
  }

  Future<Either<CustomError, String>> updatePages(
      List<PackPage> pages, int packId) async {
    try {
      Response res = await put(Uri.parse("$serverIp/pack/$packId/pages/save"),
          headers: await requestHeader(), body: jsonEncode(pages));
      if (res.statusCode == 200) {
        return const Right("Seiten ge-updated");
      } else {
        return Left(handleError(res));
      }
    } catch (error) {
      return Left(CustomError(error: ApiError.forUnknown().message));
    }
  }

  Future<Either<CustomError, List<Pack>>> getOwnPublishedPacks() => getPacks(
      url: "pack/own/published",
      errorMessage: "Du hast noch keine packs veröffentlicht");

  Future<Either<CustomError, List<Pack>>> getOwnUnpublishedPacks() => getPacks(
        url: "pack/own/unpublished",
        errorMessage: "Du hast noch keine Lernpacks entworfen",
      );

  Future<Either<CustomError, List<Pack>>> getUnreadPacks() => getPacks(
        url: "pack/unreads",
        errorMessage: "Es gibt keine ungelesenen Packs mehr",
      );

  Future<Either<CustomError, List<Pack>>> getReadPacks() => getPacks(
        url: "pack/reads",
        errorMessage: "Du hast noch keine Packs gelesen",
      );

  Future<Either<CustomError, List<Pack>>> getAllPacks() => getPacks(
      url: "pack/", errorMessage: "Es wurden keine Lernpacks gefunden");

  Future<Either<CustomError, List<Pack>>> getBookmarkedPacks() => getPacks(
      url: "pack/bookmark/",
      errorMessage: "Du hast keine Lernpacks gespeichert");

  Future<Either<CustomError, List<Pack>>> getPacks({url, errorMessage}) async {
    try {
      Response res = await get(
        Uri.parse("$serverIp/$url"),
        headers: await requestHeader(),
      );
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        List<Pack> packs = body.map((e) => Pack.fromJson(e)).toList();
        return Right(packs);
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(CustomError(error: "Konnte keine Packs finden"));
      }
    } catch (error) {
      log("Error at $url");
      log(error.toString());
      return const Left(CustomError(error: ""));
    }
  }

  Future<Either<CustomError, List<Category>>> getCategorizedPacks() async {
    try {
      Response res = await get(
        Uri.parse("$serverIp/pack/categorized"),
        headers: await requestHeader(),
      );

      if (res.statusCode == 200) {
        List<dynamic> body = await jsonDecode(res.body);
        List<Category> categories =
            body.map((e) => Category.fromJson(e)).toList();
        return Right(categories);
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(CustomError(error: "Konnte keine Packs finden"));
      }
    } catch (error) {
      log("Get Categorized Packs:");
      log(error.toString());
      return const Left(CustomError(error: "Something went wrong"));
    }
  }

  Future<Either<CustomError, String>> createRead(id) async {
    try {
      Response res = await post(Uri.parse("$serverIp/pack/read/create/$id"),
          headers: await requestHeader());

      if (res.statusCode == 201) {
        return Right("Pack Angefangen");
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(
            CustomError(error: "Pack konnte nicht gelesen werden"));
      }
    } catch (error) {
      log(error.toString());
      return const Left(CustomError(error: "Something went wrong"));
    }
  }

  Future<Either<CustomError, String>> bookmarkPack(id) => _interactPackPatch(
      url: "pack/bookmark/create/$id",
      successMessage: "Pack Gespeichert",
      errorMessage: "Pack konnte nicht gespeichert werden");

  Future<Either<CustomError, String>> removeBookmarkPack(id) =>
      _interactPackPatch(
          url: "pack/bookmark/remove/$id",
          successMessage: "Pack von Gespeicherten Packs entfernt",
          errorMessage:
              "Pack konnte nicht von gespeicherten Packs entfernt werden");

  Future<Either<CustomError, String>> publishPack(id) => _interactPackPatch(
      url: "pack/own/publish/$id",
      successMessage: "Pack Veröffentlicht",
      errorMessage: "Pack konnte nicht veröffentlicht werden");

  Future<Either<CustomError, String>> unpublishPack(id) => _interactPackPatch(
      url: "pack/own/unpublish/$id",
      successMessage: "Pack Privat gemacht",
      errorMessage: "Pack konnte nicht privat gemacht werden");

  Future<Either<CustomError, String>> clapForPack(id) => _interactPackPatch(
      url: "pack/clap/$id",
      successMessage: "Für Pack Geklatscht",
      errorMessage: "Du konntest nicht für dieses Pack klatschen");

  Future<Either<CustomError, String>> _interactPackPatch({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    try {
      print(url);
      Response res = await patch(
        Uri.parse("$serverIp/$url"),
        headers: await requestHeader(),
      );
      if (res.statusCode == 200) {
        return Right(successMessage);
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return Left(CustomError(error: errorMessage));
      }
    } catch (error) {
      log("Error while querying $url");
      log(error.toString());
      return Left(CustomError(error: ""));
    }
  }

  Future<Either<CustomError, String>> updateRead(
      {required int progress, required int packId}) async {
    try {
      Response res = await patch(
          Uri.parse("$serverIp/pack/read/update/$packId"),
          headers: await requestHeader(),
          body: jsonEncode({"progress": progress}));
      if (res.statusCode == 200) {
        return const Right("Fortschritt Gespeichert");
      } else {
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(
            CustomError(error: "Fortschritt konnte nicht gespeichert werden"));
      }
    } catch (error) {
      log("update read error");
      log(error.toString());
      return const Left(CustomError(error: ""));
    }
  }

  Future<Either<CustomError, String>> uploadCoverImage({
    required String pathToImage,
    required int packId,
  }) async {
    try {
      MultipartRequest request = MultipartRequest(
          "POST", Uri.parse("$serverIp/pack/cover/upload/$packId"));
      MultipartFile image = await MultipartFile.fromPath('image', pathToImage);
      request.headers["authorization"] = "Bearer ${await TokenHandler().get()}";
      request.files.add(image);
      StreamedResponse stream = await request.send();
      Response res = await Response.fromStream(stream);
      if (res.statusCode == 201) {
        String url = res.body;
        return Right(url);
      } else {
        return const Left(CustomError(error: "Couldn't upload image"));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: ApiError.forUnknown().message));
    }
  }

  Future<Either<CustomError, String>> uploadItemImage({
    required String pathToImage,
    required int packId,
    required String itemId,
  }) async {
    try {
      MultipartRequest request = MultipartRequest("POST",
          Uri.parse("$serverIp/pack/$packId/pages/item/$itemId/uploadImage"));
      MultipartFile image = await MultipartFile.fromPath('image', pathToImage);
      request.headers["authorization"] = "Bearer ${await TokenHandler().get()}";
      request.files.add(image);
      StreamedResponse stream = await request.send();
      Response res = await Response.fromStream(stream);
      if (res.statusCode == 201) {
        String url = res.body;
        return Right(url);
      } else {
        return const Left(CustomError(error: "Couldn't upload image"));
      }
    } catch (error) {
      log(error.toString());
      return Left(CustomError(error: ApiError.forUnknown().message));
    }
  }

  Future<Either<CustomError, String>> reportPack(
      int packId, String reason) async {
    Response res = await post(Uri.parse("$serverIp/pack/report/create/$packId"),
        headers: await requestHeader(), body: jsonEncode({"reason": reason}));

    if (res.statusCode == 201) {
      return const Right("Pack gemeldet");
    } else {
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      return Left(CustomError(
          error: decodedBody["message"] ??
              "Das Pack konnte nicht gemeldet werden. Bitte wende dich an unseren Support"));
    }
  }
}
