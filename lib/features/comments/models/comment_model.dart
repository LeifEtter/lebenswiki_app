import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

//TODO Repair Comments
class Comment {
  Comment({
    required this.id,
    required this.content,
    required this.creator,
    required this.creatorId,
    required this.parentId,
    this.parentComment,
    this.childComments,
    this.reports,
    this.reactions = const [],
    required this.creationDate,
    this.shortsCommentId,
    this.packAsCommentId,
    this.parentCommentId,
  });

  int id;
  String content;
  User creator;
  int creatorId;
  int parentId;
  Comment? parentComment;
  List<Comment>? childComments;
  List<Report>? reports;
  List<Map> reactions;
  DateTime creationDate;

  //Universal params
  int? shortsCommentId;
  int? packAsCommentId;
  int? parentCommentId;

  factory Comment.forUniversal(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["commentResponse"],
        creator: User.forContent(json["creator"]),
        creatorId: json["creatorId"],
        parentId: 0,
        shortsCommentId: json["shortsCommentId"],
        packAsCommentId: json["packsCommentId"],
        parentCommentId: json["parentCommentId"],
        creationDate: DateTime.parse(json["creationDate"]),
        reactions: List<Map>.from(json["reactions"]),
        reports: List<Report>.from(
            json["reportedComment"].map((report) => Report.forContent(report))),
      );

  factory Comment.forPack(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["commentResponse"],
        creator: User.forContent(json["creator"]),
        creatorId: json["creatorId"],
        parentId: json["packsCommentId"],
        creationDate: DateTime.parse(json["creationDate"]),
        reactions: List<Map>.from(json["reactions"]),
        reports: List<Report>.from(
            json["reportedComment"].map((report) => Report.forContent(report))),
      );

  factory Comment.forShort(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["commentResponse"],
        creator: User.forContent(json["creator"]),
        creatorId: json["creatorId"],
        parentId: json["shortsCommentId"],
        creationDate: DateTime.parse(json["creationDate"]),
        reactions: List<Map>.from(json["reactions"]),
        reports: List<Report>.from(
            json["reportedComment"].map((report) => Report.forContent(report))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "commentResponse": content,
        "creator": creator.toJson(),
        "reactions": reactions,
      };
}
