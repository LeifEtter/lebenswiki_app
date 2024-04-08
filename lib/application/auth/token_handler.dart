import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHandler {
  late FlutterSecureStorage storage;

  TokenHandler() {
    if (Platform.isAndroid) {
      storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true));
    } else {
      storage = const FlutterSecureStorage();
    }
  }

  Future set(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> get() async {
    String? token = await storage.read(key: "token");
    return token;
  }

  Future<void> delete() async {
    await storage.deleteAll();
  }
}
