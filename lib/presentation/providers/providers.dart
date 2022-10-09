import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/block_model.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

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

class UserNotifier extends ChangeNotifier {
  User? _user;

  User get user => _user ?? User(name: "error");

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  void removeUser() {
    _user = null;
  }
}

final userProvider = ChangeNotifierProvider<UserNotifier>(
  (ref) => UserNotifier(),
);

class CategoryProvider extends ChangeNotifier {
  List<ContentCategory>? _categories;

  List<ContentCategory> get categories => _categories ?? [];

  void setCategories(List<ContentCategory> newCategories) {
    _categories = newCategories;
    _categories!.insert(0, ContentCategory.forNew());
  }

  void removeCategories() {
    _categories = null;
  }
}

final categoryProvider =
    ChangeNotifierProvider<CategoryProvider>(((ref) => CategoryProvider()));

class BlockedListNotifier extends ChangeNotifier {
  List<Block>? _blockedList;
  List<int>? _blockedIdList;

  List<Block> get blockedList => _blockedList ?? [];
  List<int> get blockedIdList => _blockedIdList ?? [99999999];

  void setBlockedList(List<Block> newBlocks) {
    _blockedList = newBlocks;
    _setBlockedIdList();
  }

  void _setBlockedIdList() {
    _blockedIdList =
        _blockedList!.map((Block block) => block.blockedId).toList();
  }

  void addBlock(Block block) {
    _blockedList!.add(block);
    _blockedIdList!.add(block.blockedId);
    notifyListeners();
  }

  void removeBlockedList() {
    _blockedList = null;
    _blockedIdList = null;
  }
}

final blockedListProvider =
    ChangeNotifierProvider(((ref) => BlockedListNotifier()));

class ReloadNotifier extends ChangeNotifier {
  void reload() {
    notifyListeners();
  }
}

final reloadProvider = ChangeNotifierProvider((ref) => ReloadNotifier());

enum UserRole {
  loggedOut,
  admin,
  user,
  anonymous,
  creator,
}

class UserRoleNotifier extends ChangeNotifier {
  UserRole? _role;

  UserRole get role => _role ?? UserRole.loggedOut;

  void setRole(UserRole role) {
    _role = role;
  }

  void clearRole(UserRole role) {
    _role = null;
  }
}

final userRoleProvider = ChangeNotifierProvider((ref) => UserRoleNotifier());
