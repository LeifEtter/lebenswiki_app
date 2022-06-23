import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  final serverIp = 'https://api.lebenswiki.com/api/v1';

  BaseApi();

  Future<Map<String, String>> requestHeader() async {
    return {
      "Content-type": "application/json",
      "authorization": await getToken(),
    };
  }

  bool statusIsSuccess(statusCode) {
    if (statusCode >= 200 && statusCode <= 202) {
      return true;
    } else {
      return false;
    }
  }
}

Future<String> getToken() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString("token") ?? "";
}

Future<int> getUserId() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt("userId") ?? 0;
}
