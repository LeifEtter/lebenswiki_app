import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQueryNotifier extends ChangeNotifier {
  SearchQueryNotifier({this.query = ""});
  String query;

  void setQuery(String newQuery) {
    query = newQuery;
    notifyListeners();
  }
}

final queryProvider = ChangeNotifierProvider((ref) => SearchQueryNotifier());

class SearchStateNotifier extends ChangeNotifier {
  SearchStateNotifier({this.isSearching = false});

  bool isSearching;

  void checkChange({required String text}) {
    bool newSearchState = false;
    if (text != "") newSearchState = true;
    if (newSearchState != isSearching) {
      isSearching = newSearchState;
      notifyListeners();
    }
  }
}

final searchStateProvider =
    ChangeNotifierProvider((ref) => SearchStateNotifier());
