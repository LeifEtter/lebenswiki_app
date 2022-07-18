import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }

  void removeCategories() {
    _categories = null;
  }
}

final categoryProvider =
    ChangeNotifierProvider<CategoryProvider>(((ref) => CategoryProvider()));

//TODO actually set blocked List
class BlockedListNotifier extends ChangeNotifier {
  List<User> blockedList = [];
}

final blockedListProvider =
    ChangeNotifierProvider(((ref) => BlockedListNotifier()));
