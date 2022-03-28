import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_access.dart';

Future<String> createPost(
  String title,
  var content,
  List categories,
  String titleImage,
  String? description,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.post(Uri.parse("$SERVER_IP/posts/create"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode({
        "title": title,
        "content": content,
        "categories": categories,
        "description": description,
        "titleImage": titleImage,
      }));
  if (res.statusCode == 201) {
    return "Success";
  }
  return "Null";
}

Future<String> updatePost(
  String title,
  var content,
  List categories,
  String postId,
  String imageUrl,
  String description,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.put(Uri.parse("$SERVER_IP/posts/update/$postId"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode({
        "title": title,
        "content": content,
        "categories": categories,
        "description": description,
        "titleImage": imageUrl,
      }));
  if (res.statusCode == 201) {
    return "Success";
  }
  return "Null";
}

Future<List> getPosts() async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$SERVER_IP/users/profile"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["body"]["postsAsCreator"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["post", posts.toList()];
  } else {
    return ["post", []];
  }
}

Future<List> getAllPosts(var nullsafety) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$SERVER_IP/posts/unpublished"), headers: {
    "authorization": token,
  });

  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["body"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["post", posts.toList()];
  } else {
    return ["post", []];
  }
}

Future<List> getPostsByCategory(categoryId) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res =
      await http.get(Uri.parse("$SERVER_IP/categories/$categoryId"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["category"]["posts"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["post", posts.toList()];
  } else {
    return ["post", []];
  }
}

Future<String> publishPost(
  int postId,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.patch(
    Uri.parse("$SERVER_IP/posts/publish/$postId"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
  );
  if (res.statusCode == 201) {
    print("Success Publish");
    return "Post Publish Success";
  }
  return "Null";
}
