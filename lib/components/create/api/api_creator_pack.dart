import 'dart:convert';

import 'package:lebenswiki_app/components/create/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const serverIp = 'https://api.lebenswiki.com/api/v1';

Future<Map> getCreatorPacks() async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  var response = await http.get(Uri.parse("$serverIp/packs/"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  Map responseBody = jsonDecode(response.body);
  if (response.statusCode == 201) {
    print(responseBody);
    return responseBody;
  } else {
    print("Error: $responseBody");
    return {"Error": "Error"};
  }
}

Future<Map> getYourCreatorPacks() async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  var response = await http.get(Uri.parse("$serverIp/packs/creator"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  Map responseBody = jsonDecode(response.body);
  if (response.statusCode == 201) {
    print(responseBody);
    return responseBody;
  } else {
    print("Error: $responseBody");
    return {"Error": "Error"};
  }
}

Future<Map> createCreatorPack({
  required CreatorPack pack,
}) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  http.Response response = await http.post(
    Uri.parse("$serverIp/packs/create"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
    body: pack.toJson(),
  );
  Map responseBody = jsonDecode(response.body);
  if (response.statusCode == 201) {
    print(responseBody);
    return responseBody;
  } else {
    print("Error $responseBody");
    return {"error": "error"};
  }
}
