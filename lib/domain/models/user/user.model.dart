import 'package:json_annotation/json_annotation.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/user/role.model.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';

part 'user.model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(includeFromJson: true, includeToJson: false)
  final int? id;
  String name;
  String? email;
  String? password;
  @JsonKey(includeFromJson: true, includeToJson: true)
  String? avatar;
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? profileImage;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final Role? role;
  String biography;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Pack>? packs;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Short>? shorts;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Pack>? bookmarkedPacks;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Short>? bookmarkedShorts;
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String? oldPassword;
  @JsonKey(includeFromJson: true, includeToJson: false)
  bool? isFirstLogin;

  User({
    this.id,
    required this.name,
    this.email,
    this.password,
    this.avatar,
    this.role,
    required this.biography,
    this.packs,
    this.shorts,
    this.bookmarkedPacks,
    this.bookmarkedShorts,
    this.oldPassword,
    this.isFirstLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
