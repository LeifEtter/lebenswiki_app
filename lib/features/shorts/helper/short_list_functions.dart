import 'package:lebenswiki_app/features/shorts/models/short_model.dart';

class ShortListFunctions {
  //Sorts Packs by Creation Date, newest is first element in list, oldest is last
  static List<Short> sortPacks(List<Short> shorts) {
    shorts.sort((a, b) {
      return b.creationDate.compareTo(a.creationDate);
    });
    return shorts;
  }

  //Filters out content from blocked users
  static List<Short> filterBlocked(
      List<Short> shorts, List<int> blockedIdList) {
    List<Short> filteredShortList = [];

    for (Short short in shorts) {
      if (!blockedIdList.contains(short.creatorId)) {
        filteredShortList.add(short);
      }
    }
    return filteredShortList;
  }
}
