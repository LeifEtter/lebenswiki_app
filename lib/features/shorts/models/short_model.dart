import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/features/comments/models/comment_model.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class Short {
  Short({
    required this.id,
    required this.title,
    required this.content,
    required this.creator,
    this.creatorId,
    this.published = false,
    this.requestPublish = false,
    this.upVote = const [],
    this.downVote = const [],
    this.bookmarks = const [],
    required this.categories,
    this.comments = const [],
    this.reportShort = const [],
    this.reactions = const [],
    this.lastUpdated,
    required this.creationDate,
  }) {
    creatorId = creator.id;
    lastUpdated = DateTime.now();
  }

  int id;
  String title;
  String content;
  User creator;
  int? creatorId;
  bool published;
  bool requestPublish;
  List<User> upVote;
  List<User> downVote;
  List<User> bookmarks;
  List<ContentCategory> categories;
  List<Comment> comments;
  List<Report> reportShort;
  List<Map> reactions;
  DateTime creationDate;
  DateTime? lastUpdated;

  factory Short.fromJson(Map<String, dynamic> json) => Short(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        published: json["published"],
        requestPublish: json["requestPublish"],
        creationDate: DateTime.parse(json["creationDate"]),
        lastUpdated: DateTime.parse(json["lastUpdated"]),
        upVote: List<User>.from(json["upVote"].map((user) => User.forId(user))),
        downVote:
            List<User>.from(json["downVote"].map((user) => User.forId(user))),
        bookmarks:
            List<User>.from(json["bookmarks"].map((user) => User.forId(user))),
        comments: List<Comment>.from(
            json["comments"].map((comment) => Comment.fromJson(comment))),
        reportShort: List<Report>.from(
            json["reports"].map((report) => Report.forContent(report))),
        categories: List.from(json["categories"]
            .map((category) => ContentCategory.fromJson(category))),
        reactions: List.from(json["reactions"]),
        creator: User.forContent(json["creator"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "creators": creator.toJson(),
        "creatorId": creatorId,
        "published": published,
        "requestPublish": requestPublish,
        "upVote": List<dynamic>.from(upVote.map((User user) => user.toJson())),
        "downVote":
            List<dynamic>.from(downVote.map((User user) => user.toJson())),
        "bookmarks":
            List<dynamic>.from(bookmarks.map((User user) => user.toJson())),
        "categories": List<dynamic>.from(
            categories.map((ContentCategory category) => category.toJson())),
        "comments":
            List<Map>.from(comments.map((Comment comment) => comment.toJson())),
        "reportShort": List<dynamic>.from(
            reportShort.map((Report report) => report.toJson())),
        "reactions": reactions,
      };
}
