// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      id: json['id'] as int,
      name: json['name'] as String,
      level: json['level'] as int,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'level': instance.level,
    };
