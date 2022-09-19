import 'package:lebenswiki_app/domain/models/helper_data_model.dart';
import 'package:lebenswiki_app/presentation/widgets/common/other.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';

class ShortListHelper {
  List<Short> shorts = [];
  List<Short> queriedShorts = [];
  Map<int, List<Short>> categorizedShorts = {};

  ShortListHelper({
    required this.shorts,
    required HelperData helperData,
  }) {
    filterShortsForBlocked(helperData.blockedIdList);
    initDisplayParams(helperData.currentUserId);
    initCategorizedShorts(helperData.categories);
    queriedShorts = shorts;
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

  void queryPacks(String query) {
    String queryNormalized = query.toUpperCase();
    queriedShorts = shorts
        .where((Short short) =>
            short.title.toUpperCase().contains(queryNormalized) ||
            short.content.toUpperCase().contains(queryNormalized) ||
            short.creator.name.toUpperCase().contains(queryNormalized))
        .toList();
  }
}
