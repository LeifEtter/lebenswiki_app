import 'package:flutter/material.dart';
import 'dart:io';

enum Type {
  title,
  list,
  quiz,
  image,
}

class CreatorStyling {
  final int? size;
  final Color? color;
  final FontWeight? weight;

  CreatorStyling({
    this.size,
    this.color,
    this.weight,
  });
}

class CreatorItem {
  final Type type;
  final String headContent;
  final List? bodyContent;
  //final List? styling;

  CreatorItem({
    required this.type,
    required this.headContent,
    this.bodyContent,
    //this.styling,
  });

  CreatorItem.fromSnapshot(AsyncSnapshot snapshot)
      : type = snapshot.data["type"],
        headContent = snapshot.data["headContent"],
        bodyContent = snapshot.data["bodyContent"];
}

class CreatorPage {
  final int pageNumber;
  final List<CreatorItem> items;

  CreatorPage({
    required this.pageNumber,
    required this.items,
  });

  CreatorPage.fromSnapshot(AsyncSnapshot snapshot)
      : pageNumber = snapshot.data["pageNumber"],
        items = snapshot.data["items"];
}

class CreatorPack {
  final String title;
  final String description;
  final List pages;

  CreatorPack({
    required this.title,
    required this.description,
    required this.pages,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'pages': pages,
      };

  CreatorPack.fromSnapshot(AsyncSnapshot snapshot)
      : title = snapshot.data["title"],
        description = snapshot.data["description"],
        pages = snapshot.data["pages"];
}
