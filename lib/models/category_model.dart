import 'dart:convert';

import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.id,
    required this.categoryName,
    this.shorts = const [],
    this.packs = const [],
  });

  int id;
  String categoryName;
  List<Short> shorts;
  List<Pack> packs;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["categoryName"],
        shorts: List<Short>.from(
            json["shorts"].map((short) => Short.fromJson(short))),
        packs:
            List<Pack>.from(json["packs"].map((pack) => Pack.fromJson(pack))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        "shorts":
            List<dynamic>.from(shorts.map((Short short) => short.toJson())),
        "packs": List<dynamic>.from(packs.map((Pack pack) => pack.toJson())),
      };
}
