import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class TokenNotifier extends ChangeNotifier {
  String token = "";
}

final tokenProvider =
    ChangeNotifierProvider<TokenNotifier>(((ref) => TokenNotifier()));

class UserNotifier extends ChangeNotifier {
  User? user;
}

final userProvider = ChangeNotifierProvider<UserNotifier>(
  (ref) => UserNotifier(),
);

class UserIdNotifier extends ChangeNotifier {
  int? userId;
}

final userIdProvider =
    ChangeNotifierProvider<UserIdNotifier>((ref) => UserIdNotifier());

class CategoryProvider extends ChangeNotifier {
  List<ContentCategory>? categories;
}

final categoryProvider =
    ChangeNotifierProvider<CategoryProvider>(((ref) => CategoryProvider()));
