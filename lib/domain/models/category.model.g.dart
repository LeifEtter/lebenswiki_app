// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as int,
      name: json['name'] as String,
      packs: (json['packs'] as List<dynamic>?)
              ?.map((e) => Pack.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shorts: (json['shorts'] as List<dynamic>?)
              ?.map((e) => Short.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
    };
