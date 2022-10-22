import 'package:lebenswiki_app/repository/backend/token_handler.dart';

class BaseApi {
  final serverIp = 'https://api.lebenswiki.com/api/v1';

  BaseApi();

  Future<Map<String, String>> requestHeader() async {
    return {
      "Content-type": "application/json",
      "authorization": await TokenHandler().get() ?? "",
    };
  }

  bool statusIsSuccess(int statusCode) {
    if (statusCode >= 200 && statusCode <= 202) {
      return true;
    } else {
      return false;
    }
  }
}
