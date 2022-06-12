import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_access.dart';

Future<String> tokenGetter() async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  return token;
}

Future<Map<String, String>?> headerScaffold() async {
  var token = await tokenGetter();
  return {
    "Content-type": "application/json",
    "authorization": token,
  };
}

Future<String> createShort(
  String title,
  List categories,
  String content,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.post(Uri.parse("$serverIp/shorts/create"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      },
      body: jsonEncode({
        "title": title,
        "categories": categories,
        "content": content,
      }));
  if (res.statusCode == 201) {
    return "Creation Successful";
  } else {
    return "Error Creating Short";
  }
}

Future<List> getAllShorts(String nullSafety) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$serverIp/shorts/"), headers: {
    "authorization": token,
  });
  var responseData = jsonDecode(res.body);
  if (res.statusCode == 200) {
    List shorts = responseData["body"];
    shorts.map((short) => Short.fromJson(short));
    return ["short", shorts];
  } else {
    print(responseData);
    return ["short", []];
  }
}

Future<List> getDraftsShorts(String nullSafety) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$serverIp/shorts/unpublished"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["body"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["draft", posts.toList()];
  } else {
    return ["draft", []];
  }
}

Future<List> getShortsByCategory(categoryId) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http
      .get(Uri.parse("$serverIp/categories/shorts/$categoryId"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["category"]["shorts"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["short", posts.toList()];
  } else {
    return ["short", []];
  }
}

Future<List> getShortsNew(categoryId) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(
      Uri.parse("$serverIp/categories/shorts/${categoryId + 1}"),
      headers: {
        "authorization": token,
      });
  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["category"]["shorts"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["short", posts.toList()];
  } else {
    return ["short", []];
  }
}

Future<String> publishShort(
  int postId,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res =
      await http.put(Uri.parse("$serverIp/shorts/publish/$postId"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  if (res.statusCode == 201) {
    return "Post Publish Success";
  }
  return "Null";
}

Future<String> unpublishShort(
  int postId,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res =
      await http.put(Uri.parse("$serverIp/shorts/unpublish/$postId"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  if (res.statusCode == 201) {
    return "Post Publish Success";
  }
  return "Null";
}

Future<String> voteShort(
  int id,
  bool isUpvote,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.put(
      Uri.parse("$serverIp/shorts/${isUpvote ? "upvote" : "downvote"}/$id"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      });
  if (res.statusCode == 201) {
    return "Short Upvote Success";
  }
  return "Null";
}

Future<List> getBookmarkedShorts(String nullSafety) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$serverIp/shorts/bookmarks"), headers: {
    "authorization": token,
  });

  if (res.statusCode == 201) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["body"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["short", posts.toList()];
  } else {
    return ["short", []];
  }
}

Future<String> bookmarkShort(int id) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res =
      await http.put(Uri.parse("$serverIp/shorts/bookmarks/$id"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    return "Success";
  } else {
    return "Error";
  }
}

Future<String> unbookmarkShort(int id) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res =
      await http.put(Uri.parse("$serverIp/shorts/unbookmarks/$id"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    return "Success";
  } else {
    return "Error";
  }
}

Future<String> removeUpvote(int id) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res =
      await http.get(Uri.parse("$serverIp/shorts/bookmarks/$id"), headers: {
    "authorization": token,
  });
  if (res.statusCode == 200) {
    return "Success";
  } else {
    return "Error";
  }
}

Future<String> removeVote(
  int id,
  bool isUpvote,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.put(
      Uri.parse(
          "$serverIp/shorts/${isUpvote ? "upvote" : "downvote"}/remove/$id"),
      headers: {
        "Content-type": "application/json",
        "authorization": token,
      });
  if (res.statusCode == 201) {
    return "Short Upvote Success";
  }
  return "Null";
}

Future<String> removeShort(
  int id,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res =
      await http.delete(Uri.parse("$serverIp/shorts/delete/$id"), headers: {
    "Content-type": "application/json",
    "authorization": token,
  });
  if (res.statusCode == 201) {
    return "Success";
  }
  return "Null";
}

Future<String> addReaction(
  int id,
  String reaction,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.put(Uri.parse("$serverIp/shorts/reaction/$id"),
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

Future<List> getCreatorShorts(String nullSafety) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.get(Uri.parse("$serverIp/shorts/published"), headers: {
    "authorization": token,
  });

  if (res.statusCode == 200) {
    var responseData = jsonDecode(res.body);
    var posts = responseData["body"];
    var listWithPosts = [];
    posts.forEach((pack) => listWithPosts);
    return ["short", posts.toList()];
  } else {
    return ["short", []];
  }
}

Future<String> reportShort(
  int id,
  String reason,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.post(
    Uri.parse("$serverIp/reports/create/short/$id"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
    body: jsonEncode({
      "reason": reason,
    }),
  );
  if (res.statusCode == 201) {
    return "Report Sucessfull";
  } else {
    return "Error Reporting Short:";
  }
}

Future<String> deleteReaction(
  int id,
) async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  var res = await http.put(
    Uri.parse("$serverIp/shorts/reaction/remove/$id"),
    headers: {
      "Content-type": "application/json",
      "authorization": token,
    },
  );
  if (res.statusCode == 200 || res.statusCode == 201) {
    return "Success";
  } else {
    return "Failed";
  }
}
