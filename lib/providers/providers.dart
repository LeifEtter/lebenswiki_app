import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class TokenNotifier extends ChangeNotifier {
  String? _token;

  String get token => _token ?? "";

  void setToken(newToken) {
    _token = newToken;
  }

  void removeToken() {
    _token = null;
  }
}

final tokenProvider =
    ChangeNotifierProvider<TokenNotifier>(((ref) => TokenNotifier()));

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

class UserIdNotifier extends ChangeNotifier {
  int? _userId;

  int get userId => _userId ?? 0;

  void setUserId(newUserId) {
    _userId = newUserId;
  }

  void removeUserId() {
    _userId = null;
  }
}

final userIdProvider =
    ChangeNotifierProvider<UserIdNotifier>((ref) => UserIdNotifier());

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
