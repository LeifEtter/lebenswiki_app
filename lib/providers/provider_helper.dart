import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/misc_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class ProviderHelper {
  //TODO remove token Provider as it is not secure
  static bool areSessionProvidersReset(WidgetRef ref) {
    if (ref.read(tokenProvider).token == "" ||
        ref.read(userIdProvider).userId == 0 ||
        ref.read(userProvider).user.name == "error" ||
        ref.read(categoryProvider).categories == []) {
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
    //TODO implement: ref.read(blockedListProvider).removeBlockedUsers();
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
      User user = profileResult.responseItem;

      setSessionProviders(ref,
          token: token, user: user, categories: categories);
    }
    return true;
  }

  static setSessionProviders(
    WidgetRef ref, {
    required String token,
    required User user,
    required List<ContentCategory> categories,
  }) {
    ref.read(tokenProvider).setToken(token);
    ref.read(userIdProvider).setUserId(user.id);
    ref.read(userProvider).setUser(user);
    ref.read(categoryProvider).setCategories(categories);
  }
}
