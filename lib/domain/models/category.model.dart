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
