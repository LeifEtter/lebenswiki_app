import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';

class PackPageItemInput {
  String value;
  TextEditingController? controller;

  PackPageItemInput({
    required this.value,
    this.controller,
  });

  PackPageItemInput.fromResponse(Map json) : value = json["value"];

  Map<String, dynamic> toJson() => {"value": value};
}

class PackPageItem {
  final ItemType type;
  final PackPageItemInput headContent;
  final List<PackPageItemInput> bodyContent;
  //final List? styling;

  PackPageItem({
    required this.type,
    required this.headContent,
    required this.bodyContent,
    //this.styling,
  });

  Map<String, dynamic> toJson() => {
        "type": type.toString(),
        "headContent": headContent.toJson(),
        "bodyContent": List<dynamic>.from(
            bodyContent.map((PackPageItemInput input) => input.toJson()))
      };

  PackPageItem.fromResponse(Map json)
      : type = ItemType.values.firstWhere((e) => e.toString() == json["type"]),
        headContent = PackPageItemInput(value: json["headContent"]["value"]),
        bodyContent = List<PackPageItemInput>.from(json["bodyContent"]
            .map((input) => PackPageItemInput.fromResponse(input)));
}

class PackPage {
  final int pageNumber;
  final List<PackPageItem> items;

  PackPage({
    required this.pageNumber,
    required this.items,
  });

  PackPage.fromResponse(Map json)
      : pageNumber = json["pageNumber"],
        items = List<PackPageItem>.from(json["items"].map((item) {
          return PackPageItem.fromResponse(item);
        }));

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "items":
            List<dynamic>.from(items.map((PackPageItem item) => item.toJson())),
      };
}
