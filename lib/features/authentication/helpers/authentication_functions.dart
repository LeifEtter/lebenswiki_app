import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/token/token_handler.dart';
import 'package:lebenswiki_app/main.dart';

class AuthenticationFunctions {
  static void logout(context) async {
    TokenHandler().delete();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuthWrapper(),
    ));
  }
}
