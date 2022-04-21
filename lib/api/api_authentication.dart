import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_access.dart';

Future<Map> register(String email, String password, String name,
    String biography, String profileImage, bool isAdmin) async {
  var responseMap = {
    "error": "",
    "message": "",
  };
  var res = await http.post(Uri.parse("$serverIp/users/register/"),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
        "name": name,
        "biography": biography,
        "profileImage": profileImage,
      }));
  var responseData = jsonDecode(res.body.toString());
  if (res.statusCode == 201) {
    responseMap["message"] = responseData["message"];
    return responseMap;
  } else {
    responseMap["error"] = responseData["message"];
    return responseMap;
  }
}

Future<Map> login(String email, String password) async {
  var responseMap = {
    "error": "",
    "token": "",
    "userId": 0,
  };

  var res = await http.post(Uri.parse("$serverIp/users/login"),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }));

  var responseData = jsonDecode(res.body.toString());
  final prefs = await SharedPreferences.getInstance();

  if (res.statusCode == 200) {
    var responseToken = responseData["token"];
    prefs.setString("token", responseToken);
    prefs.setInt("userId", responseData["id"]);
    responseMap["token"] = responseToken;
    responseMap["userId"] = responseData["id"];
    return responseMap;
  } else {
    responseMap["error"] = responseData["message"];
    return responseMap;
  }
}

Future<Map> getUserData() async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$serverIp/users/profile"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    Map userMap = jsonDecode(res.body)["body"];
    return userMap;
  }
  return {"error": "not found"};
}
