// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      content: json['content'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      usersVote: json['usersVote'] as int,
      voteCount: json['voteCount'] as int,
      creator: User.fromJson(json['creator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'creationDate': instance.creationDate.toIso8601String(),
      'usersVote': instance.usersVote,
      'voteCount': instance.voteCount,
      'creator': instance.creator,
    };
