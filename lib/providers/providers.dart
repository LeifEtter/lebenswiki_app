import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class UserNotifier extends ChangeNotifier {
  User user = User(name: "");

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}

final userProvider = ChangeNotifierProvider<UserNotifier>(
  (ref) => UserNotifier(),
);
