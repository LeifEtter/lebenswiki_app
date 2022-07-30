import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/misc_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class ProviderHelper {
  static void resetSessionProviders(WidgetRef ref) {
    ref.read(userProvider).removeUser();
    ref.read(categoryProvider).removeCategories();
    ref.read(blockedListProvider).removeBlockedList();
  }

  static Future getDataAndSetSessionProviders(
    WidgetRef ref,
  ) async {
    //Get and save categories
    ResultModel categoriesResult = await MiscApi().getCategories();
    List<ContentCategory> categories =
        List<ContentCategory>.from(categoriesResult.responseList);

    //Get and save profile
    ResultModel profileResult = await UserApi().getUserData();
    User user = profileResult.responseItem;

    //Get Blocks
    ResultModel blockedResult = await UserApi().getBlockedUsers();
    List<Block> blockedList = List<Block>.from(blockedResult.responseList);

    setSessionProviders(
      ref,
      user: user,
      categories: categories,
      blocks: blockedList,
    );
  }

  static setSessionProviders(
    WidgetRef ref, {
    required User user,
    required List<ContentCategory> categories,
    required List<Block> blocks,
  }) {
    ref.read(userProvider).setUser(user);
    ref.read(categoryProvider).setCategories(categories);
    ref.read(blockedListProvider).setBlockedList(blocks);
  }
}
