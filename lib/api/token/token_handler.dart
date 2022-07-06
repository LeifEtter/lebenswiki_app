import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//TODO enable encrypt android
/*  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );*/

class TokenHandler {
  final storage = const FlutterSecureStorage();

  void set(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String> get() async {
    String token = await storage.read(key: "token") ?? "asda";
    return token;
  }

  void delete() async {
    await storage.deleteAll();
  }
}
