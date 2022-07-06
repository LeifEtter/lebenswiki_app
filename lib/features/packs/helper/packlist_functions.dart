import 'package:lebenswiki_app/models/pack_model.dart';

class PackListFunctions {
  //Sorts Packs by Creation Date, newest is first element in list, oldest is last
  static List<Pack> sortPacks(List<Pack> packs) {
    packs.sort((a, b) {
      return b.creationDate.compareTo(a.creationDate);
    });
    return packs;
  }

  //Filters out content from blocked users
  static List filterBlocked(List<Pack> packs, List blockedUsers) {
    List filteredPackList = [];
    bool canAdd = true;

    for (Pack pack in packs) {
      canAdd = true;
      for (Map report in blockedUsers) {
        for (Map blocked in report["blocked"]) {
          if (blocked["id"] == pack.creatorId) {
            canAdd = false;
            break;
          }
        }
      }
      canAdd ? filteredPackList.add(pack) : null;
    }
    return filteredPackList;
  }
}
