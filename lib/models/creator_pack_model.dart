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

  ItemInput.fromResponse(Map json) : value = json["value"];

  Map<String, dynamic> toJson() => {
        "value": value,
      };
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

  Map<String, dynamic> toJson() => {
        "type": type.toString(),
        "headContent": headContent.toJson(),
        "bodyContent": List<dynamic>.from(
            bodyContent.map((ItemInput input) => input.toJson()))
      };

  CreatorItem.fromResponse(Map json)
      : type = ItemType.values.firstWhere((e) => e.toString() == json["type"]),
        headContent = ItemInput(value: json["headContent"]["value"]),
        bodyContent = List<ItemInput>.from(
            json["bodyContent"].map((input) => ItemInput.fromResponse(input)));
}

class CreatorPage {
  final int pageNumber;
  final List<CreatorItem> items;

  CreatorPage({
    required this.pageNumber,
    required this.items,
  });

  CreatorPage.fromResponse(Map json)
      : pageNumber = json["pageNumber"],
        /*items = List<CreatorItem>.from(
            json["items"].map((item) => CreatorItem.fromResponse(item)));*/
        items = List<CreatorItem>.from(json["items"].map((item) {
          return CreatorItem.fromResponse(item);
        }));

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "items":
            List<dynamic>.from(items.map((CreatorItem item) => item.toJson())),
      };
}

class CreatorPack {
  int id;
  String title;
  String description;
  String titleImage;
  bool published;
  Map creator;
  final List<int> categories;
  final List<CreatorPage> pages;

  CreatorPack({
    this.id = 0,
    this.creator = const {},
    required this.title,
    required this.description,
    required this.pages,
    required this.categories,
    required this.titleImage,
    required this.published,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'titleImage': titleImage,
        'published': published,
        'categories': [1],
        'pages':
            List<dynamic>.from(pages.map((CreatorPage page) => page.toJson()))
      };

  CreatorPack.fromJson(Map json)
      : title = json["title"],
        creator = json["creatorPack"],
        id = json["id"],
        description = json["description"],
        titleImage = json["titleImage"],
        categories = [1],
        published = json["published"],
        pages = List<CreatorPage>.from(
            json["pages"].map((page) => CreatorPage.fromResponse(page)));
}
