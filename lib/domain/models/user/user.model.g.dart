// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String?,
      password: json['password'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
      biography: json['biography'] as String,
      packs: (json['packs'] as List<dynamic>?)
          ?.map((e) => Pack.fromJson(e as Map<String, dynamic>))
          .toList(),
      shorts: (json['shorts'] as List<dynamic>?)
          ?.map((e) => Short.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookmarkedPacks: (json['bookmarkedPacks'] as List<dynamic>?)
          ?.map((e) => Pack.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookmarkedShorts: (json['bookmarkedShorts'] as List<dynamic>?)
          ?.map((e) => Short.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFirstLogin: json['isFirstLogin'] as bool?,
    )..profileImage = json['profileImage'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'avatar': instance.avatar,
      'biography': instance.biography,
      'oldPassword': instance.oldPassword,
    };
