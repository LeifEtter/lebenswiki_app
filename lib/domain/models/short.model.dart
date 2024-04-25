import 'package:json_annotation/json_annotation.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
// import 'package:lebenswiki_app/domain/models/category.model.dart';
// import 'package:lebenswiki_app/domain/models/comment.model.dart';
// import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';

part 'short.model.g.dart';

@JsonSerializable()
class Short {
  @JsonKey(includeFromJson: true, includeToJson: false)
  int? id;
  String title;
  String content;
  @JsonKey(includeFromJson: true, includeToJson: false)
  DateTime? creationDate;
  @JsonKey(includeFromJson: true, includeToJson: false)
  User? creator;
  @JsonKey(includeFromJson: true, includeToJson: false)
  int votes;
  @JsonKey(includeFromJson: true, includeToJson: false)
  int bookmarks;
  @JsonKey(includeFromJson: true, includeToJson: false)
  bool userHasBookmarked;
  @JsonKey(includeFromJson: true, includeToJson: false)
  bool published;
  @JsonKey(includeFromJson: true, includeToJson: false)
  int totalClaps;
  bool userHasClapped;
  List<Category> categories;

  Short({
    this.id,
    required this.title,
    required this.content,
    this.bookmarks = 0,
    this.userHasBookmarked = false,
    this.totalClaps = 0,
    this.userHasClapped = false,
    this.votes = 0,
    this.creator,
    this.creationDate,
    this.published = false,
    this.categories = const [],
  });

  factory Short.fromJson(Map<String, dynamic> json) => _$ShortFromJson(json);

  Map<String, dynamic> toJson() => _$ShortToJson(this);
}
