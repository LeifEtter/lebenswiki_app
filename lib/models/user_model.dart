import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id = 0,
    required this.email,
    required this.name,
    this.profileImage =
        "https://t3.ftcdn.net/jpg/01/18/01/98/360_F_118019822_6CKXP6rXmVhDOzbXZlLqEM2ya4HhYzSV.jpg",
    this.biography = "",
    this.postsAsCreator = const [],
    this.shortsAsCreator = const [],
    this.packsAsCreator = const [],
    this.upVotesForShorts = const [],
    this.downVotesForShorts = const [],
    this.bookmarkForShorts = const [],
    this.commentsAsUser = const [],
    this.reportUser = const [],
    this.blockerUser = const [],
    this.blocked = const [],
    this.feedbackUser = const [],
  });

  int id;
  String email;
  String name;
  String profileImage;
  String biography;
  List<dynamic> postsAsCreator;
  List<dynamic> shortsAsCreator;
  List<dynamic> packsAsCreator;
  List<dynamic> upVotesForShorts;
  List<dynamic> downVotesForShorts;
  List<dynamic> bookmarkForShorts;
  List<dynamic> commentsAsUser;
  List<dynamic> reportUser;
  List<dynamic> blockerUser;
  List<dynamic> blocked;
  List<dynamic> feedbackUser;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        profileImage: json["profileImage"],
        biography: json["biography"],
        postsAsCreator:
            List<dynamic>.from(json["postsAsCreator"].map((x) => x)),
        shortsAsCreator:
            List<dynamic>.from(json["shortsAsCreator"].map((x) => x)),
        packsAsCreator:
            List<dynamic>.from(json["packsAsCreator"].map((x) => x)),
        upVotesForShorts:
            List<dynamic>.from(json["upVotesForShorts"].map((x) => x)),
        downVotesForShorts:
            List<dynamic>.from(json["downVotesForShorts"].map((x) => x)),
        bookmarkForShorts:
            List<dynamic>.from(json["bookmarkForShorts"].map((x) => x)),
        commentsAsUser:
            List<dynamic>.from(json["commentsAsUser"].map((x) => x)),
        reportUser: List<dynamic>.from(json["reportUser"].map((x) => x)),
        blockerUser: List<dynamic>.from(json["blockerUser"].map((x) => x)),
        blocked: List<dynamic>.from(json["blocked"].map((x) => x)),
        feedbackUser: List<dynamic>.from(json["feedbackUser"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "profileImage": profileImage,
        "biography": biography,
        "postsAsCreator": List<dynamic>.from(postsAsCreator.map((x) => x)),
        "shortsAsCreator": List<dynamic>.from(shortsAsCreator.map((x) => x)),
        "packsAsCreator": List<dynamic>.from(packsAsCreator.map((x) => x)),
        "upVotesForShorts": List<dynamic>.from(upVotesForShorts.map((x) => x)),
        "downVotesForShorts":
            List<dynamic>.from(downVotesForShorts.map((x) => x)),
        "bookmarkForShorts":
            List<dynamic>.from(bookmarkForShorts.map((x) => x)),
        "commentsAsUser": List<dynamic>.from(commentsAsUser.map((x) => x)),
        "reportUser": List<dynamic>.from(reportUser.map((x) => x)),
        "blockerUser": List<dynamic>.from(blockerUser.map((x) => x)),
        "blocked": List<dynamic>.from(blocked.map((x) => x)),
        "feedbackUser": List<dynamic>.from(feedbackUser.map((x) => x)),
      };
}
