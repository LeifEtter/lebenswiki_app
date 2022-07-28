import 'package:http/http.dart';

class AuthApi {
  static Future<bool> authenticate({required String token}) async {
    Response res = await get(
      Uri.parse("https://api.lebenswiki.com/api/v1/users/authentication"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
