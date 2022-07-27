import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';

class ShortListHelper {
  List<Short> shorts = [];
  Map<int, List<Short>> categorizedShorts = {};

  ShortListHelper({
    required this.shorts,
    required int currentUserId,
    required List<ContentCategory> categories,
    required List<int> blockedList,
  }) {
    filterShortsForBlocked(blockedList);
    initDisplayParams(currentUserId);
    initCategorizedShorts(categories);
  }

  void initDisplayParams(int currentUserId) {
    for (Short short in shorts) {
      short.initializeDisplayParams(currentUserId);
    }
  }

  void filterShortsForBlocked(List<int> blockedList) {
    shorts.removeWhere((Short short) => blockedList.contains(short.creator.id));
  }

  void sortPacks() {
    shorts.sort((a, b) {
      return b.creationDate.compareTo(a.creationDate);
    });
  }

  void initCategorizedShorts(List<ContentCategory> categories) {
    //Create keys with id for each category
    for (ContentCategory category in categories) {
      categorizedShorts[category.id] = [];
    }

    //Fill in entries with shorts fitting to id
    categorizedShorts[0] = shorts;
    for (Short short in shorts) {
      categorizedShorts[short.categories.first.id]!.add(short);
    }
  }
}
