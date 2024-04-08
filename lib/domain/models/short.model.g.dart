// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Short _$ShortFromJson(Map<String, dynamic> json) => Short(
      id: json['id'] as int?,
      title: json['title'] as String,
      content: json['content'] as String,
      bookmarks: json['bookmarks'] as int? ?? 0,
      userHasBookmarked: json['userHasBookmarked'] as bool? ?? false,
      totalClaps: json['totalClaps'] as int? ?? 0,
      userHasClapped: json['userHasClapped'] as bool? ?? false,
      votes: json['votes'] as int? ?? 0,
      creator: json['creator'] == null
          ? null
          : User.fromJson(json['creator'] as Map<String, dynamic>),
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
      published: json['published'] as bool? ?? false,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ShortToJson(Short instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'userHasClapped': instance.userHasClapped,
      'categories': instance.categories,
    };
