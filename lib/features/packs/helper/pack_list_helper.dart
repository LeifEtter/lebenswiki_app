import 'package:lebenswiki_app/features/a_new_common/other.dart';
import 'package:lebenswiki_app/features/a_new_wrappers/main_wrapper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';

class PackListHelper {
  List<Pack> packs = [];
  List<Pack> queriedPacks = [];
  Map<int, List<Pack>> categorizedPacks = {};
  List<Pack> startedPacks = [];
  List<Pack> recommendedPacks = [];
  List<Pack> newArticles = [];

  PackListHelper({
    required this.packs,
    required HelperData helperData,
  }) {
    filterShortsForBlocked(helperData.blockedIdList);
    initDisplayParams(helperData.currentUserId);
    initCategorizedShorts(helperData.categories);
    initRecommendedPacks();
    initStartedPacks();
    initNewArticles();
    queriedPacks = packs;
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

  void initStartedPacks() {
    startedPacks = packs;
  }

  void initRecommendedPacks() {
    recommendedPacks = packs;
  }

  void initNewArticles() {
    newArticles = packs;
  }

  void queryShorts(String query) {
    String queryNormalized = query.toUpperCase();
    queriedPacks = packs
        .where((Pack pack) =>
            pack.title.toUpperCase().contains(queryNormalized) ||
            pack.description.toUpperCase().contains(queryNormalized) ||
            pack.creator!.name.toUpperCase().contains(queryNormalized))
        .toList();
  }
}
