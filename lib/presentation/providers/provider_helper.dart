import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/repository/backend/misc_api.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/domain/models/block_model.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

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
    Either<CustomError, User> profileResult = await UserApi().getUserData();
    User user = profileResult.right;

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

  static Future getDataAndSessionProvidersForAnonymous(WidgetRef ref) async {
    ResultModel categoriesResult = await MiscApi().getCategories();
    List<ContentCategory> categories =
        List<ContentCategory>.from(categoriesResult.responseList);
    setSessionProvidersForAnonymous(
      ref,
      categories: categories,
    );
  }

  static setSessionProvidersForAnonymous(
    WidgetRef ref, {
    required List<ContentCategory> categories,
  }) {
    ref.read(userRoleProvider).setRole(UserRole.anonymous);
    ref.read(categoryProvider).setCategories(categories);
    ref.read(blockedListProvider).setBlockedList([]);
  }

  static setSessionProviders(
    WidgetRef ref, {
    required User user,
    required List<ContentCategory> categories,
    required List<Block> blocks,
  }) {
    //TODO take use role
    ref.read(userRoleProvider).setRole(UserRole.user);
    ref.read(userProvider).setUser(user);
    ref.read(categoryProvider).setCategories(categories);
    ref.read(blockedListProvider).setBlockedList(blocks);
  }
}
