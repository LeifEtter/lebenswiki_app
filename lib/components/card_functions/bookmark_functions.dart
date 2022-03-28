import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/enums.dart';

bool isBookmarked(int userId, ContentType contentType, bookmarkData) {
  if (contentType == ContentType.packBookmarks ||
      contentType == ContentType.shortBookmarks) {
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
