import 'dart:developer';

import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';

//TODO Add Sorting and filtering
class PackListHelper {
  List<Pack> packs = [];
  Map<int, List<Pack>> categorizedPacks = {};

  PackListHelper({
    required this.packs,
    required int currentUserId,
    required List<ContentCategory> categories,
    required List<int> blockedList,
  }) {
    filterShortsForBlocked(blockedList);
    initDisplayParams(currentUserId);
    initCategorizedShorts(categories);
  }

  void initDisplayParams(int currentUserId) {
    for (Pack pack in packs) {
      pack.initializeDisplayParams(currentUserId);
    }
  }

  void filterShortsForBlocked(List<int> blockedList) {
    packs.removeWhere((Pack pack) => blockedList.contains(pack.creatorId));
  }

  void sortPacks() {
    packs.sort((a, b) {
      return b.creationDate.compareTo(a.creationDate);
    });
  }

  void initCategorizedShorts(List<ContentCategory> categories) {
    //Create keys with id for each category
    for (ContentCategory category in categories) {
      categorizedPacks[category.id] = [];
    }

    //Fill in entries with shorts fitting to id
    categorizedPacks[0] = packs;

    for (Pack pack in packs) {
      if (pack.categories.isNotEmpty) {
        categorizedPacks[pack.categories.first.id]!.add(pack);
      }
    }
  }
}
