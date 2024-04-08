// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pack _$PackFromJson(Map<String, dynamic> json) => Pack(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      initiative: json['initiative'] as String? ?? "",
      readProgress: (json['readProgress'] as num?)?.toDouble() ?? 0,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      creator: json['creator'] == null
          ? null
          : User.fromJson(json['creator'] as Map<String, dynamic>),
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
      readTime: json['readTime'] as int,
      userHasBookmarked: json['userHasBookmarked'] as bool? ?? false,
      userHasClapped: json['userHasClapped'] as bool? ?? false,
      totalBookmarks: json['totalBookmarks'] as int? ?? 0,
      totalClaps: json['totalClaps'] as int? ?? 0,
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => PackPage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      published: json['published'] as bool? ?? false,
      titleImage: json['titleImage'] as String?,
      totalReads: json['totalReads'] as int? ?? 0,
    );

Map<String, dynamic> _$PackToJson(Pack instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'initiative': instance.initiative,
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'readTime': instance.readTime,
      'pages': instance.pages.map((e) => e.toJson()).toList(),
    };
