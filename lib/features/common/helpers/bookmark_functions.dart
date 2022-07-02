import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class BookmarkHelper {
  int contentId;
  List<User> bookmarkedBy;
  CardType cardType;

  bool userHasBookmarked = false;
  late int? userId;
  final ShortApi shortApi = ShortApi();

  BookmarkHelper({
    required this.contentId,
    required this.bookmarkedBy,
    required this.cardType,
  }) {
    _setUserHasBookmarked();
  }

  void _setUserHasBookmarked() {
    if (cardType == CardType.packBookmarks ||
        cardType == CardType.shortBookmarks) {
      userHasBookmarked = true;
    }
    if (bookmarkedBy.isEmpty) {
      userHasBookmarked = false;
    } else {
      for (User bookmarker in bookmarkedBy) {
        bookmarker.id == userId ? userHasBookmarked == true : null;
      }
    }
  }

  void toggleBookmarkShort({
    required Function bookmarkCallback,
    required Function unbookmarkCallback,
  }) {
    if (userHasBookmarked) {
      //shortApi.unbookmarkShort(contentId);
      bookmarkCallback();
      userHasBookmarked = false;
    } else {
      //shortApi.bookmarkShort(contentId);
      unbookmarkCallback();
      userHasBookmarked = true;
    }
  }
}
