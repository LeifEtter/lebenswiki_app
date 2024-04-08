// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack_page.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackPage _$PackPageFromJson(Map<String, dynamic> json) => PackPage(
      id: json['id'] as String,
      pageNumber: json['pageNumber'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => PackPageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PackPageToJson(PackPage instance) => <String, dynamic>{
      'id': instance.id,
      'pageNumber': instance.pageNumber,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

PackPageItem _$PackPageItemFromJson(Map<String, dynamic> json) => PackPageItem(
      id: json['id'] as String,
      type: $enumDecode(_$ItemTypeEnumMap, json['type']),
      headContent: PackPageItemContent.fromJson(
          json['headContent'] as Map<String, dynamic>),
      bodyContent: (json['bodyContent'] as List<dynamic>)
          .map((e) => PackPageItemContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      position: json['position'] as int,
    );

Map<String, dynamic> _$PackPageItemToJson(PackPageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ItemTypeEnumMap[instance.type]!,
      'headContent': instance.headContent.toJson(),
      'bodyContent': instance.bodyContent.map((e) => e.toJson()).toList(),
      'position': instance.position,
    };

const _$ItemTypeEnumMap = {
  ItemType.title: 'ItemType.title',
  ItemType.list: 'ItemType.list',
  ItemType.quiz: 'ItemType.quiz',
  ItemType.image: 'ItemType.image',
  ItemType.text: 'ItemType.text',
};

PackPageItemContent _$PackPageItemContentFromJson(Map<String, dynamic> json) =>
    PackPageItemContent(
      value: json['value'] as String? ?? "",
      id: json['id'] as String,
    );

Map<String, dynamic> _$PackPageItemContentToJson(
        PackPageItemContent instance) =>
    <String, dynamic>{
      'value': instance.value,
      'id': instance.id,
    };
