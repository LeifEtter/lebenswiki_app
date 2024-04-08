import 'package:json_annotation/json_annotation.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';

part 'category.model.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(includeFromJson: true, includeToJson: true)
  final int id;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String name;
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<Pack> packs;
  @JsonKey(includeFromJson: true, includeToJson: false)
  List<Short> shorts;

  Category({
    required this.id,
    required this.name,
    this.packs = const [],
    this.shorts = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

// Category categoryFromJson(String str) =>
//     Category.fromJson(json.decode(str));

// String categoryToJson(Category data) => json.encode(data.toJson());

// class Category {
//   Category({
//     required this.id,
//     required this.categoryName,
//     //this.shorts = const [],
//     //this.packs = const [],
//   });

//   int id;
//   String categoryName;
//   //List<Short> shorts;
//   //List<Pack> packs;

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json["id"],
//       categoryName: json["categoryName"],
//       //shorts: List<Short>.from(
//       // json["shorts"].map((short) => Short.fromJson(short))),
//       //packs:
//       // List<Pack>.from(json["packs"].map((pack) => Pack.fromJson(pack))),
//     );
//   }

//   factory Category.forContent(Map<String, dynamic> json) {
//     return Category(
//       id: json["id"],
//       categoryName: json["categoryName"],
//       //shorts: List<Short>.from(
//       // json["shorts"].map((short) => Short.fromJson(short))),
//       //packs:
//       // List<Pack>.from(json["packs"].map((pack) => Pack.fromJson(pack))),
//     );
//   }

//   factory Category.forNew() =>
//       Category(id: 0, categoryName: "Neu");

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "categoryName": categoryName,
//         //"shorts":
//         //  List<dynamic>.from(shorts.map((Short short) => short.toJson())),
//         //"packs": List<dynamic>.from(packs.map((Pack pack) => pack.toJson())),
//       };
// }
