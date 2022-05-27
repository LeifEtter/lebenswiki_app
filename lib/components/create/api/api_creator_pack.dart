import 'dart:convert';

import 'package:lebenswiki_app/components/create/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const serverIp = 'https://api.lebenswiki.com/api/v1';

Future<List> getCreatorPacks(nullsafety) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  var response = await http.get(Uri.parse("$serverIp/packs/"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  Map responseBody = jsonDecode(response.body);
  if (response.statusCode == 201 || response.statusCode == 200) {
    return ["", responseBody["packs"]];
  } else {
    print("Error: $responseBody");
    return [];
  }
}

Future<List> getYourCreatorPacks(nullsafety) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  var response =
      await http.get(Uri.parse("$serverIp/packs/unpublished"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  Map responseBody = jsonDecode(response.body);
  if (response.statusCode == 201 || response.statusCode == 200) {
    print(responseBody);
    return ["", responseBody["packs"]];
  } else {
    print("Error: $responseBody");
    return [];
  }
}

Future<List> getYourCreatorPacksPublished(nullsafety) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  var response = await http.get(Uri.parse("$serverIp/packs/creator"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  Map responseBody = jsonDecode(response.body);
  if (response.statusCode == 201 || response.statusCode == 200) {
    print(responseBody);
    return ["", responseBody["packs"]];
  } else {
    print("Error: $responseBody");
    return [];
  }
}

Future<int> createCreatorPack({
  required CreatorPack pack,
}) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  var response = await http.post(
    Uri.parse("$serverIp/packs/create"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
    body: jsonEncode(pack.toJson()),
  );
  Map body = jsonDecode(response.body);
  if (response.statusCode == 201) {
    return body["body"]["id"];
  } else {
    print("Error $body");
    return 0;
  }
}

Future<Map> updateCreatorPack({
  required CreatorPack pack,
  required int id,
}) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  await http
      .put(
    Uri.parse("$serverIp/packs/update/$id"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
    body: jsonEncode(pack.toJson()),
  )
      .then((response) {
    print(jsonDecode(response.body));

    return {"result": response.body};
  });
  return {};
}

Future<Map> publishPack({id}) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  await http.patch(
    Uri.parse("$serverIp/packs/publish/$id"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
  ).then((response) {
    print(response);
  });
  return {};
}

Future<Map> deletePack({id}) async {
  String token = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "error");
  await http.delete(
    Uri.parse("$serverIp/packs/delete/$id"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
  ).then((response) {
    print(response.body);
  });
  return {};
}
