import 'package:lebenswiki_app/domain/models/comment_model.dart';
import 'package:lebenswiki_app/domain/models/report_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'dart:convert';

import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/domain/models/user_feedback_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/repository/constants/image_repo.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id = 0,
    this.email,
    required this.name,
    this.password,
    this.profileImage = ImageRepo.standardProfileImage,
    this.biography = "The user hasn't written his biography yet...",
    this.shortsAsCreator = const [],
    this.packsAsCreator = const [],
    this.upVotedShorts = const [],
    this.downVotedShorts = const [],
    this.bookmarkedShorts = const [],
    this.commentsAsUser = const [],
    this.reports = const [],
    this.blockerUser = const [],
    this.blocked = const [],
    this.feedback = const [],
    this.role = UserRole.user,
  });

  int id;
  String? email;
  String name;
  String profileImage;
  String biography;
  String? password;
  List<Short> shortsAsCreator;
  List<Pack> packsAsCreator;
  List<Short> upVotedShorts;
  List<Short> downVotedShorts;
  List<Short> bookmarkedShorts;
  List<Comment> commentsAsUser;
  List<Report> reports;
  List<dynamic> blockerUser;
  List<dynamic> blocked;
  List<UserFeedback> feedback;
  UserRole role;

  factory User.forProvider(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      profileImage: json["profileImage"],
      role: stringToRole(json["role"]),
      email: json["email"],
      biography: json["biography"]);

  factory User.forContent(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        profileImage: json["profileImage"],
        role: stringToRole(json["role"]),
      );

  factory User.forId(Map<String, dynamic> json) => User(
        id: json["id"],
        name: "Doesnt Matter",
        profileImage: "Doesnt Matter",
        role: stringToRole(json["role"]),
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        profileImage: json["profileImage"],
        biography: json["biography"],
        packsAsCreator: List<Pack>.from(
            json["postsAsCreator"].map((pack) => Pack.fromJson(pack))),
        shortsAsCreator: List<Short>.from(
            json["shortsAsCreator"].map((short) => Short.fromJson(short))),
        upVotedShorts: List<Short>.from(
            json["upVotesForShorts"].map((short) => Short.fromJson(short))),
        downVotedShorts: List<Short>.from(
            json["upVotesForShorts"].map((short) => Short.fromJson(short))),
        bookmarkedShorts: List<Short>.from(
            json["upVotesForShorts"].map((short) => Short.fromJson(short))),
        commentsAsUser: List<Comment>.from(json["commentsAsUser"]
            .map((comment) => Comment.forUniversal(comment))),
        reports: List<Report>.from(
            json["reportUser"].map((report) => Report.fromJson(report))),
        blockerUser:
            List<dynamic>.from(json["blockerUser"].map((x) => x)), //!Todo
        blocked: List<dynamic>.from(json["blocked"].map((x) => x)), //!Todo
        feedback: List<UserFeedback>.from(json["feedbackUser"]
            .map((feedback) => UserFeedback.fromJson(feedback))),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "password": password ?? "",
        "profileImage": profileImage,
        "biography": biography,
      };
}
