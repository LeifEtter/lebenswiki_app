import 'dart:convert';

//import 'package:lebenswiki_app/models/pack_model.dart';
//import 'package:lebenswiki_app/models/short_model.dart';

ContentCategory categoryFromJson(String str) =>
    ContentCategory.fromJson(json.decode(str));

String categoryToJson(ContentCategory data) => json.encode(data.toJson());

class ContentCategory {
  ContentCategory({
    required this.id,
    required this.categoryName,
    //this.shorts = const [],
    //this.packs = const [],
  });

  int id;
  String categoryName;
  //List<Short> shorts;
  //List<Pack> packs;

  factory ContentCategory.fromJson(Map<String, dynamic> json) {
    return ContentCategory(
      id: json["id"],
      categoryName: json["categoryName"],
      //shorts: List<Short>.from(
      // json["shorts"].map((short) => Short.fromJson(short))),
      //packs:
      // List<Pack>.from(json["packs"].map((pack) => Pack.fromJson(pack))),
    );
  }

  factory ContentCategory.forContent(Map<String, dynamic> json) {
    return ContentCategory(
      id: json["id"],
      categoryName: json["categoryName"],
      //shorts: List<Short>.from(
      // json["shorts"].map((short) => Short.fromJson(short))),
      //packs:
      // List<Pack>.from(json["packs"].map((pack) => Pack.fromJson(pack))),
    );
  }

  factory ContentCategory.forNew() =>
      ContentCategory(id: 0, categoryName: "Neu");

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        //"shorts":
        //  List<dynamic>.from(shorts.map((Short short) => short.toJson())),
        //"packs": List<dynamic>.from(packs.map((Pack pack) => pack.toJson())),
      };
}
