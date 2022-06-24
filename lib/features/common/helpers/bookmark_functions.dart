import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _initializeUserId();
    _setUserHasBookmarked();
  }

  Future<void> _initializeUserId() async {
    var prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId");
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

  void toggleBookmarkShort() {
    if (userHasBookmarked) {
      shortApi.unbookmarkShort(contentId);
      userHasBookmarked = false;
    } else {
      shortApi.bookmarkShort(contentId);
      userHasBookmarked = true;
    }
  }
}
