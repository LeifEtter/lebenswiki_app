import 'dart:convert';

import 'package:lebenswiki_app/application/date_helper.dart';
import 'package:lebenswiki_app/domain/models/comment_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  Report({
    required this.reason,
    this.reporter,
    this.userId,
    this.reportedContentId,
    this.reportedShort,
    this.reportedPack,
    this.reportedComment,
    required this.creationDate,
  }) {
    userId = reporter?.id;
  }

  String reason;
  User? reporter;
  int? userId;
  int? reportedContentId;
  Short? reportedShort;
  Pack? reportedPack;
  Comment? reportedComment;
  DateTime creationDate;

  factory Report.forContent(Map<String, dynamic> json) => Report(
        reason: json["reason"],
        userId: json["userId"],
        reporter: User.forContent(json["reporter"]),
        creationDate: DateTime.parse(json["creationDate"]),
      );

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        reason: json["reason"],
        reporter: User.fromJson(json["reporter"]),
        userId: json["userId"],
        reportedContentId: json["reportedContentId"],
        reportedShort:
            json["reportedShort"] ?? Short.fromJson(json["reportedShort"]),
        reportedPack:
            json["reportedPack"] ?? Pack.fromJson(json["reportedPack"]),
        reportedComment: json["reportedComment"] ??
            Comment.forUniversal(json["reportedComment"]),
        creationDate: DateTime.parse(json["creationDate"]),
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "userId": userId,
        "reportedContentId": reportedContentId,
        "reportedShort": reportedShort ?? reportedShort!.toJson(),
        "reportedPack": reportedPack ?? reportedPack!.toJson(),
        "reportedComment": reportedComment ?? reportedComment!.toJson(),
        "creationDate": DateHelper().convertToString(creationDate),
      };
}
