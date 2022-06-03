import 'dart:convert';

import 'package:lebenswiki_app/helper/date_helper.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
    Comment({
        required this.commentReponse,
        required this.creator,
        required this.creatorId,
        this.shortsAsComment,
        this.shortsCommentId,
        this.postAsComment,
        this.postId,
        this.parentComment,
        this.parentCommentId,
        this.childComments,
        this.reportComment,
        this.reactions,
        this.softDelete = false,
        required this.creationDate,
        this.updatedAt,
    });

    String commentReponse;
    User creator;
    int creatorId;
    List<Short>? shortsAsComment;
    int shortsCommentId;
    List<Post>? postAsComment;
    int? postId;
    Comment? parentComment;
    int? parentCommentId;
    List<Comment>? childComments;
    List<Report>? reportComment;
    Map? reactions;
    bool softDelete;
    DateTime creationDate;
    DateTime? updatedAt;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentReponse: json["commentReponse"],
        creator: User.fromJson(json["creator"]),
        creatorId: json["creatorId"],
        shortsAsComment: List<Short>.from(json["shortsAsComment"].map((element) => Short.fromJson(element))),
        shortsCommentId: json["shortsCommentId"],
        postAsComment: List<dynamic>.from(json["postAsComment"].map((post) => post.fromJson(post))),
        postId: json["postId"],
        parentComment: Comment.fromJson(json["parentComment"]),
        parentCommentId: json["parentCommentId"],
        childComments: List<Comment>.from(json["childComments"].map((comment) => Comment.fromJson(comment))),
        reportComment: List<Report>.from(json["reportComment"].map((report) => report.fromJson(report))),
        reactions: json["reactions"],
        softDelete: json["softDelete"],
        creationDate: json["creationDate"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "commentReponse": commentReponse,
        "creator": creator.toJson(),
        "creatorId": creatorId,
        "shortsAsComment": List<dynamic>.from(shortsAsComment!.map((Short short) => short.toJson())),
        "shortsCommentId": shortsCommentId,
        "postAsComment": List<dynamic>.from(postAsComment.map((x) => x)),
        "postId": postId,
        "parentComment": parentComment!.toJson(),
        "parentCommentId": parentCommentId,
        "childComments": List<String>.from(childComments!.map((Comment comment) => comment.toJson())),
        "reportComment": List<String>.from(reportComment!.map((Report report) => report.toJson())),
        "reactions": reactions,
        "softDelete": softDelete,
        "creationDate": DateHelper().convertToString(creationDate),
        "updatedAt": DateHelper().convertToString(updatedAt!),
    };
}