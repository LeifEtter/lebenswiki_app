import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_common/other.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/helper/pack_list_helper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/enums.dart';

class PackShortService {
  static Future<Either<CustomError, Map>> getPacksAndShorts({
    required HelperData helperData,
  }) async {
    ResultModel shortsResult = await ShortApi().getAllShorts();
    ResultModel packsResult = await PackApi().getAllPacks();
    if (shortsResult.type != ResultType.failure &&
        packsResult.type != ResultType.failure) {
      return Right({
        "shortHelper": ShortListHelper(
            shorts: List<Short>.from(shortsResult.responseList),
            helperData: helperData),
        "packHelper": PackListHelper(
            packs: List<Pack>.from(packsResult.responseList),
            helperData: helperData),
      });
    } else {
      return const Left(CustomError(error: "Etwas ist schiefgelaufen"));
    }
  }

  static Future<Either<CustomError, Map>> getPacksAndShortsForBookmarks({
    required HelperData helperData,
  }) async {
    ResultModel shortsResult = await ShortApi().getBookmarkedShorts();
    ResultModel packsResult = await PackApi().getBookmarkedPacks();
    if (shortsResult.type != ResultType.failure &&
        packsResult.type != ResultType.failure) {
      return Right({
        "shortHelper": ShortListHelper(
            shorts: List<Short>.from(shortsResult.responseList),
            helperData: helperData),
        "packHelper": PackListHelper(
            packs: List<Pack>.from(packsResult.responseList),
            helperData: helperData),
      });
    } else {
      return const Left(CustomError(error: "Etwas ist schiefgelaufen"));
    }
  }
}
