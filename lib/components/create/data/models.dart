import 'package:flutter/material.dart';

enum ItemType {
  title,
  list,
  quiz,
  image,
  text,
}

/*class CreatorStyling {
  final int? size;
  final Color? color;
  final FontWeight? weight;

  CreatorStyling({
    this.size,
    this.color,
    this.weight,
  });
}*/

class ItemInput {
  String value;
  TextEditingController? controller;

  ItemInput({
    required this.value,
    this.controller,
  });
}

class CreatorItem {
  final ItemType type;
  final ItemInput headContent;
  final List<ItemInput> bodyContent;
  //final List? styling;

  CreatorItem({
    required this.type,
    required this.headContent,
    required this.bodyContent,
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

  CreatorPage.fromJson(Map json)
      : pageNumber = json["pageNumber"],
        items = json["items"];

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "items": items,
      };
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
