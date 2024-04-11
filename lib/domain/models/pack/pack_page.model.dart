import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lebenswiki_app/domain/enums/page_type_enum.dart';

part "pack_page.model.g.dart";

@JsonSerializable(explicitToJson: true)
class PackPage {
  final String id;
  int pageNumber;
  List<PackPageItem> items;
  PageType? type;

  PackPage({
    required this.id,
    required this.pageNumber,
    required this.items,
    this.type,
  });

  factory PackPage.fromJson(Map<String, dynamic> json) =>
      _$PackPageFromJson(json);

  Map<String, dynamic> toJson() => _$PackPageToJson(this);

  void initControllers() {
    for (PackPageItem item in items) {
      item.initControllers();
    }
  }

  void orderItems() {
    items.sort((a, b) => a.position.compareTo(b.position));
  }

  void save() {
    for (PackPageItem item in items) {
      item.position = items.indexOf(item);
      item.save();
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  bool isSaved() {
    for (PackPageItem item in items) {
      if (!item.isSaved()) return false;
    }
    return true;
  }
}

enum ItemType {
  @JsonValue("ItemType.title")
  title,
  @JsonValue("ItemType.list")
  list,
  @JsonValue("ItemType.quiz")
  quiz,
  @JsonValue("ItemType.image")
  image,
  @JsonValue("ItemType.text")
  text,
  @JsonValue("ItemType.question")
  question,
}

@JsonSerializable(explicitToJson: true)
class PackPageItem {
  final String id;
  final ItemType type;
  final PackPageItemContent headContent;
  final List<PackPageItemContent> bodyContent;
  int position;

  PackPageItem({
    required this.id,
    required this.type,
    required this.headContent,
    required this.bodyContent,
    required this.position,
  });

  factory PackPageItem.fromJson(Map<String, dynamic> json) =>
      _$PackPageItemFromJson(json);

  Map<String, dynamic> toJson() => _$PackPageItemToJson(this);

  void initControllers() {
    headContent.initController();
    for (PackPageItemContent input in bodyContent) {
      input.initController();
    }
  }

  void save() {
    headContent.save();
    for (PackPageItemContent input in bodyContent) {
      input.save();
    }
  }

  bool isSaved() {
    if (!headContent.isSaved()) return false;
    for (PackPageItemContent input in bodyContent) {
      if (!input.isSaved()) return false;
    }
    return true;
  }
}

@JsonSerializable(explicitToJson: true)
class PackPageItemContent {
  String value;
  final String id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  TextEditingController? controller;

  PackPageItemContent({
    this.value = "",
    required this.id,
    this.controller,
  });

  factory PackPageItemContent.fromJson(Map<String, dynamic> json) =>
      _$PackPageItemContentFromJson(json);

  Map<String, dynamic> toJson() => _$PackPageItemContentToJson(this);

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
