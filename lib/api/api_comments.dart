import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_access.dart';

Future<String> createComment(
  String comment,
  int id,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.post(Uri.parse("$SERVER_IP/comments/create/shorts/$id"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode({"comment": comment}));
  if (res.statusCode == 200) {
    return "Creation Successful";
  } else {
    return "Error Creating Comment";
  }
}

Future<String> addCommentReaction(
  int id,
  String reaction,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.put(Uri.parse("$SERVER_IP/comments/reaction/$id"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode({"reaction": reaction}));
  if (res.statusCode == 201) {
    return "Short Upvote Success";
  }
  return "Null";
}
