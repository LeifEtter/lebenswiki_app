import 'dart:convert';

import 'package:lebenswiki_app/helper/date_helper.dart';
import 'package:lebenswiki_app/models/comment_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
    Report({
        required this.reason,
        required this.reporter,
        required this.userId,
        this.reportPost,
        this.reportPostId,
        this.reportShort,
        this.reportShortId,
        this.reportComment,
        this.reportCommentId,
        required this.creationDate,
    });

    String reason;
    User reporter;
    int userId;
    Post? reportPost;
    int? reportPostId;
    Short? reportShort;
    int? reportShortId;
    Comment? reportComment;
    int? reportCommentId;
    DateTime creationDate;

    factory Report.fromJson(Map<String, dynamic> json) => Report(
        reason: json["reason"],
        reporter: User.fromJson(json["reporter"]),
        userId: json["userId"],
        reportPost: Post.fromJson(json["reportPost"]),
        reportPostId: json["reportPostId"],
        reportShort: Short.fromJson(json["reportShort"]),
        reportShortId: json["reportShortId"],
        reportComment: Comment.fromJson(json["reportComment"]),
        reportCommentId: json["reportCommentId"],
        creationDate: DateTime.parse(json["creationDate"]),
    );

    Map<String, dynamic> toJson() => {
        "reason": reason,
        "reporter": reporter.toJson(),
        "userId": userId,
        "reportPost": reportPost.toJson(),
        "reportPostId": reportPostId,
        "reportShort": reportShort!.toJson(),
        "reportShortId": reportShortId,
        "reportComment": reportComment!.toJson(),
        "reportCommentId": reportCommentId,
        "creationDate": DateHelper().convertToString(creationDate),
    };
}