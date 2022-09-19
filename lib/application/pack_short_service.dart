import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/helper_data_model.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/presentation/widgets/common/other.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/application/pack_list_helper.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/repository/backend/short_api.dart';
import 'package:lebenswiki_app/application/short_list_helper.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';

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
