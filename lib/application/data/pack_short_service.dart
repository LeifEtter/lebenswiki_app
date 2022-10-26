import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/helper_data_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/application/data/pack_list_helper.dart';
import 'package:lebenswiki_app/repository/backend/short_api.dart';
import 'package:lebenswiki_app/application/data/short_list_helper.dart';

class PackShortService {
  static Future<Either<CustomError, Map>> getPacksAndShorts({
    required HelperData helperData,
    bool isAnonymous = false,
  }) async {
    ShortListHelper? shortHelper;
    PackListHelper? packHelper;

    if (isAnonymous) {
      await PackApi().getOthersPublishedpacks().fold((left) {}, (right) {
        packHelper = PackListHelper(packs: right, helperData: helperData);
      });
    } else {
      await PackApi().getUnreadPacks().fold((left) {}, (right) {
        packHelper = PackListHelper(packs: right, helperData: helperData);
      });
    }

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

    List<Pack> packs = [];
    List<Short> shorts = [];

    await PackApi().getOwnPublishedpacks().fold((left) {}, (right) {
      packs.addAll(right);
    });
    await ShortApi().getOwnPublishedShorts().fold((left) {}, (right) {
      shorts.addAll(right);
    });
    await PackApi().getOwnUnpublishedPacks().fold((left) {}, (right) {
      packs.addAll(right);
    });
    await ShortApi().getCreatorsDraftShorts().fold((left) {}, (right) {
      shorts.addAll(right);
    });
    packHelper = PackListHelper(packs: packs, helperData: helperData);
    shortHelper = ShortListHelper(shorts: shorts, helperData: helperData);

    return Right({
      "shortHelper": shortHelper,
      "packHelper": packHelper,
    });
  }
}
