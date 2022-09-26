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

  void initController() {
    controller = TextEditingController();
    controller!.text = value;
  }

  void save() {
    if (controller != null) {
      value = controller!.text;
    }
  }

  bool isSaved() {
    if (controller == null) return false;
    if (controller!.text != value) return false;
    return true;
  }
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

  void initControllers() {
    headContent.initController();
    for (PackPageItemInput input in bodyContent) {
      input.initController();
    }
  }

  void save() {
    headContent.save();
    for (PackPageItemInput input in bodyContent) {
      input.save();
    }
  }

  bool isSaved() {
    if (!headContent.isSaved()) return false;
    for (PackPageItemInput input in bodyContent) {
      if (!input.isSaved()) return false;
    }
    return true;
  }
}

class PackPage {
  int pageNumber;
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
  void initControllers() {
    for (PackPageItem item in items) {
      item.initControllers();
    }
  }

  void save() {
    for (PackPageItem item in items) {
      item.save();
    }
  }

  bool isSaved() {
    for (PackPageItem item in items) {
      if (!item.isSaved()) return false;
    }
    return true;
  }
}
