import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_access.dart';

Future<List> getCategories() async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$SERVER_IP/categories"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body.toString());
    return responseData["categories"];
  }
  if (res.statusCode == 401 &&
      jsonDecode(res.body.toString())["message"] == "unothorised access") {
    prefs.clear();
  }
  return [];
}

Future<Map> updateProfile(
  String email,
  String name,
  String biography,
  String profileImage,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.put(
    Uri.parse("$SERVER_IP/users/profile/update"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
    body: jsonEncode({
      "email": email,
      "name": name,
      "biography": biography,
      "profileImage": profileImage,
    }),
  );
  var responseData = jsonDecode(res.body.toString());
  var responseMap = {
    "error": "",
  };

  if (res.statusCode == 200) {
    return responseMap;
  } else {
    responseMap["error"] = responseData["message"];
    return responseMap;
  }
}

Future<Map> updatePassword2(
  String oldpassword,
  String password,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.patch(Uri.parse("$SERVER_IP/users/password/update"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode(<String, String>{
        "oldPassword": oldpassword,
        "newPassword": password,
      }));
  var responseMap = {
    "error": "",
  };
  if (res.statusCode == 200 && res.statusCode == 201) {
    return responseMap;
  }

  return responseMap;
}

Future<Map> updatePassword(
  String oldpassword,
  String password,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.patch(Uri.parse("$SERVER_IP/users/password/update"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode({"oldPassword": oldpassword, "newPassword": password}));
  var responseMap = {
    "error": "",
  };
  if (res.statusCode == 200 && res.statusCode == 201) {
    return responseMap;
  }

  return responseMap;
}

Future<String> blockUserAPI(int id, String reason) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.post(
    Uri.parse("$SERVER_IP/blocks/create/$id"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
    body: jsonEncode({
      "reason": reason,
    }),
  );
  if (res.statusCode == 200 && res.statusCode == 201) {
    var responseData = jsonDecode(res.body);
    return responseData;
  } else {
    return "Unsuccess";
  }
}

Future<List> getBlocked() async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(
    Uri.parse("$SERVER_IP/blocks/"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
  );
  if (res.statusCode == 200 || res.statusCode == 201) {
    var responseData = jsonDecode(res.body);
    return responseData["body"];
  } else {
    return [];
  }
}

Future<String> createFeedback(String feedback) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.post(Uri.parse("$SERVER_IP/feedbacks/create"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode({"feedback": feedback}));
  print(res.body);
  if (res.statusCode == 201) {
    return "Success";
  } else {
    return "Error";
  }
}
