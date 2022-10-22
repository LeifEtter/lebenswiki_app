import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lebenswiki_app/repository/backend/authentication_api.dart';

class TokenHandler {
  final storage = const FlutterSecureStorage();

  Future set(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> get() async {
    String? token = await storage.read(key: "token");
    return token;
  }

  void delete() async {
    await storage.deleteAll();
  }

  Future<bool> authenticateCurrentToken() async {
    String? token = await get();
    if (token == null) return false;
    return await AuthApi.authenticate(token: token);
  }
}
