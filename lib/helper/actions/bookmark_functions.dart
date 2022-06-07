import 'package:lebenswiki_app/models/enums/enums.dart';

bool isBookmarked(int userId, CardType cardType, bookmarkData) {
  if (cardType == CardType.packBookmarks ||
      cardType == CardType.shortBookmarks) {
    return true;
  }
  if (bookmarkData.length == 0) {
    return false;
  } else {
    for (var bookmarkObject in bookmarkData) {
      if (bookmarkObject["id"] == userId) {
        return true;
      }
    }
  }
  return false;
}
