import 'package:flutter/material.dart';


class User {
  String name;

  User({
    required this.name,
  })
}


class Short {
  int id;
  User user;
  String title;
  String description;
  String content;
  User creator;
  bool published;
  List upVote;
  List downVote;
  int creatorId;
  List categories;
  List bookmarks;
  List comments;
  List reportShort;
  Map reactions;

  Short({
    this.id = 0,
    this.downVote = const [],
    this.upVote = const [],
    this.bookmarks = const [],
    this.comments = const [],
    this.reportShort = const [],
    this.reactions = const {},
    this.published = false,
    required this.title,
    required this.content,
    required this.description,
    required this.creatorId,
    required this.categories,
  });

  Short.fromJson(Map json) 
    : title = json["title"],
      id = json["id"],
      creator = json["creator"],
      
      
  
}
