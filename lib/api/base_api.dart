import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  final serverIp = 'https://api.lebenswiki.com/api/v1';
  late int userId;
  late String token;

  BaseApi() {
    _initializeData();
  }

  Map<String, String> requestHeader() {
    return {
      "Content-type": "application/json",
      "authorization": token,
    };
  }

  bool statusIsSuccess(statusCode) {
    if (statusCode >= 200 && statusCode <= 202) {
      return true;
    } else {
      return false;
    }
  }

  void _initializeData() async {
    var prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
    userId = prefs.getInt("userId") ?? 0;
  }
}
