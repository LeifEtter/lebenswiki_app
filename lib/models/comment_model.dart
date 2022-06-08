import 'dart:convert';

import 'package:lebenswiki_app/helper/date_helper.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    this.id = 0,
    required this.content,
    required this.creator,
    this.creatorId,
    required this.parentId,
    this.parentShort,
    this.parentPack,
    this.parentComment,
    this.childComments,
    this.reports,
    this.reactions,
    this.softDelete = false,
    required this.creationDate,
    this.updatedAt,
  }) {
    creatorId = creator.id;
  }

  int id;
  String content;
  User creator;
  int? creatorId;
  int parentId;
  Short? parentShort;
  Pack? parentPack;
  Comment? parentComment;
  List<Comment>? childComments;
  List<Report>? reports;
  Map? reactions;
  bool softDelete;
  DateTime creationDate;
  DateTime? updatedAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["commentReponse"],
        creator: User.fromJson(json["creator"]),
        creatorId: json["creatorId"],
        parentId: json["parentId"],
        parentShort: json["parentShort"] ?? json["parentShort"],
        parentPack: json["parentPack"] ?? json["parentPack"],
        parentComment: json["parentComment"] ?? json["parentComment"],
        childComments: json["childComments"] ??
            List<Comment>.from(json["childComments"]
                .map((comment) => Comment.fromJson(comment))),
        reports: json["reports"] ??
            List<Report>.from(
                json["reportComment"].map((report) => report.fromJson(report))),
        reactions: json["reactions"],
        softDelete: json["softDelete"],
        creationDate: DateTime.parse(json["creationDate"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "commentReponse": content,
        "creator": creator.toJson(),
        "creatorId": creatorId,
        "parentId": parentId,
        "parentShort": parentShort ?? parentShort!.toJson(),
        "parentPack": parentPack ?? parentPack!.toJson(),
        "parentComment": parentComment ?? parentComment!.toJson(),
        "childComments": childComments ??
            childComments!.map((Comment comment) => comment.toJson()),
        "reactions": reactions,
        "softDelete": softDelete,
        "creationDate": DateHelper().convertToString(creationDate),
        "updatedAt": DateHelper().convertToString(updatedAt!),
      };
}
