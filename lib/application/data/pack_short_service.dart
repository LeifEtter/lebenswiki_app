import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/helper_data_model.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/application/data/pack_list_helper.dart';
import 'package:lebenswiki_app/repository/backend/short_api.dart';
import 'package:lebenswiki_app/application/data/short_list_helper.dart';

class PackShortService {
  static Future<Either<CustomError, Map>> getPacksAndShorts({
    required HelperData helperData,
  }) async {
    ShortListHelper? shortHelper;
    PackListHelper? packHelper;

    await PackApi().getOthersPublishedpacks().fold((left) {}, (right) {
      packHelper = PackListHelper(packs: right, helperData: helperData);
    });
    await ShortApi().getOthersPublishedShorts().fold((left) {}, (right) {
      shortHelper = ShortListHelper(shorts: right, helperData: helperData);
    });

    if (shortHelper == null || packHelper == null) {
      return const Left(CustomError(error: "Something went wrong"));
    } else {
      return Right({
        "shortHelper": shortHelper,
        "packHelper": packHelper,
      });
    }
  }

  static Future<Either<CustomError, Map>> getPacksAndShortsForBookmarks({
    required HelperData helperData,
  }) async {
    ShortListHelper? shortHelper;
    PackListHelper? packHelper;

    await PackApi().getBookmarkedPacks().fold((left) {}, (right) {
      packHelper = PackListHelper(packs: right, helperData: helperData);
    });
    await ShortApi().getBookmarkedShorts().fold((left) {}, (right) {
      shortHelper = ShortListHelper(shorts: right, helperData: helperData);
    });

    if (shortHelper == null || packHelper == null) {
      return const Left(CustomError(error: "Something went wrong"));
    } else {
      return Right({
        "shortHelper": shortHelper,
        "packHelper": packHelper,
      });
    }
  }

  static Future<Either<CustomError, Map>> getPacksAndShortsForCreated({
    required HelperData helperData,
  }) async {
    ShortListHelper? shortHelper;
    PackListHelper? packHelper;

    await PackApi().getCreatorsDraftPacks().fold((left) {}, (right) {
      packHelper = PackListHelper(packs: right, helperData: helperData);
    });
    await ShortApi().getCreatorsDraftShorts().fold((left) {}, (right) {
      shortHelper = ShortListHelper(shorts: right, helperData: helperData);
    });

    if (shortHelper == null || packHelper == null) {
      return const Left(CustomError(error: "Something went wrong"));
    } else {
      return Right({
        "shortHelper": shortHelper,
        "packHelper": packHelper,
      });
    }
  }
}
