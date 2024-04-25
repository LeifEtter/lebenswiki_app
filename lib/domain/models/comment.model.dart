import 'package:json_annotation/json_annotation.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';

part 'comment.model.g.dart';

@JsonSerializable()
class Comment {
  final int id;
  final String content;
  final DateTime creationDate;
  final int usersVote;
  final int voteCount;
  final User creator;

  Comment({
    required this.id,
    required this.content,
    required this.creationDate,
    required this.usersVote,
    required this.voteCount,
    required this.creator,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
