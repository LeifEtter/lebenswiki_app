import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/helper/date_helper.dart';
import 'package:lebenswiki_app/models/user_model.dart';

UserFeedback userFeedbackFromJson(String str) =>
    UserFeedback.fromJson(json.decode(str));

String userFeedbackToJson(UserFeedback data) => json.encode(data.toJson());

class UserFeedback {
  UserFeedback({
    required this.user,
    this.userId,
    required this.report,
    this.reviewed = false,
    this.creationDate,
  }) {
    userId = user.id;
    creationDate = DateTime.now();
  }

  User user;
  int? userId;
  String report;
  bool reviewed;
  DateTime? creationDate;

  factory UserFeedback.fromJson(Map<String, dynamic> json) => UserFeedback(
        user: User.fromJson(json["user"]),
        userId: json["userId"],
        report: json["report"],
        reviewed: json["reviewed"],
        creationDate: DateTime.parse(json["creationDate"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "userId": userId,
        "report": report,
        "reviewed": reviewed,
        "creationDate": DateHelper().convertToString(creationDate!),
      };
}
