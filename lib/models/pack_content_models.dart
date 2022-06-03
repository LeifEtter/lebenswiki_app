import 'package:flutter/material.dart';
import 'package:lebenswiki_app/models/enums/enums.dart';

class ItemInput {
  String value;
  TextEditingController? controller;

  ItemInput({
    required this.value,
    this.controller,
  });

  ItemInput.fromResponse(Map json) : value = json["value"];

  Map<String, dynamic> toJson() => {"value": value};
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
        items = List<CreatorItem>.from(json["items"].map((item) {
          return CreatorItem.fromResponse(item);
        }));

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "items":
            List<dynamic>.from(items.map((CreatorItem item) => item.toJson())),
      };
}
