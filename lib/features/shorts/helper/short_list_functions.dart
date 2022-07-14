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
  static List<Short> filterBlocked(List<Short> shorts, List blockedUsers) {
    List<Short> filteredShortList = [];
    bool canAdd = true;

    for (Short short in shorts) {
      canAdd = true;
      for (Map report in blockedUsers) {
        for (Map blocked in report["blocked"]) {
          if (blocked["id"] == short.creatorId) {
            canAdd = false;
            break;
          }
        }
      }
      canAdd ? filteredShortList.add(short) : null;
    }
    return filteredShortList;
  }
}
