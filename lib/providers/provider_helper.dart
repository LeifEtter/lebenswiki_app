import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/misc_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class ProviderHelper {
  //TODO remove token Provider as it is not secure
  static bool areSessionProvidersReset(WidgetRef ref) {
    if (ref.read(tokenProvider).token == "" ||
        ref.read(userIdProvider).userId == 0 ||
        ref.read(userProvider).user.name == "error" ||
        ref.read(categoryProvider).categories == [] ||
        ref.read(blockedListProvider).blockedIdList.first == 99999999) {
      return true;
    } else {
      return false;
    }
  }

  static void resetSessionProviders(WidgetRef ref) {
    ref.read(tokenProvider).removeToken();
    ref.read(userIdProvider).removeUserId();
    ref.read(userProvider).removeUser();
    ref.read(categoryProvider).removeCategories();
    ref.read(blockedListProvider).removeBlockedList();
  }

  static Future<bool> getDataAndSetSessionProviders(WidgetRef ref,
      {required String token}) async {
    if (areSessionProvidersReset(ref)) {
      //Get and save categories
      ResultModel categoriesResult = await MiscApi().getCategories();
      List<ContentCategory> categories =
          List.from(categoriesResult.responseList);

      if (categories == []) {
        return false;
      }

      //Get and save profile
      ResultModel profileResult = await UserApi().getUserData();

      //Get Blocks
      ResultModel blockedResult = await UserApi().getBlockedUsers();

      User user = profileResult.responseItem;
      List<Block> blockedList = List<Block>.from(blockedResult.responseList);

      setSessionProviders(
        ref,
        token: token,
        user: user,
        categories: categories,
        blocks: blockedList,
      );
    }
    return true;
  }

  static setSessionProviders(
    WidgetRef ref, {
    required String token,
    required User user,
    required List<ContentCategory> categories,
    required List<Block> blocks,
  }) {
    ref.read(tokenProvider).setToken(token);
    ref.read(userIdProvider).setUserId(user.id);
    ref.read(userProvider).setUser(user);
    ref.read(categoryProvider).setCategories(categories);
    ref.read(blockedListProvider).setBlockedList(blocks);
  }
}
