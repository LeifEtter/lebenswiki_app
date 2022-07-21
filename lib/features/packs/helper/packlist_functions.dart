import 'package:lebenswiki_app/features/packs/models/pack_model.dart';

class PackListFunctions {
  //Sorts Packs by Creation Date, newest is first element in list, oldest is last
  static List<Pack> sortPacks(List<Pack> packs) {
    packs.sort((a, b) {
      return b.creationDate.compareTo(a.creationDate);
    });
    return packs;
  }

  //Filters out content from blocked users
  static List<Pack> filterBlocked(List<Pack> packs, List<int> blockedIdList) {
    List<Pack> filteredPackList = [];

    for (Pack pack in packs) {
      if (!blockedIdList.contains(pack.creatorId)) {
        filteredPackList.add(pack);
      }
    }
    return filteredPackList;
  }
}
