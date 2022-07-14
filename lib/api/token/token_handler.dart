import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO enable encrypt android
/*  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );*/

class TokenHandler {
  final storage = const FlutterSecureStorage();

  void set(String token) async {
    await storage.write(key: "token", value: token);
  }

  void setUnsafe(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<String> get() async {
    String token = await storage.read(key: "token") ?? "";
    return token;
  }

  void delete() async {
    await storage.deleteAll();
  }

  void deleteUnsafe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
