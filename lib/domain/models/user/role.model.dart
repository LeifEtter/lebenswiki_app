import 'package:json_annotation/json_annotation.dart';

part 'role.model.g.dart';

@JsonSerializable()
class Role {
  final int id;
  final String name;
  final int level;

  const Role({required this.id, required this.name, required this.level});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}


