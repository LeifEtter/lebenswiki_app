import 'package:lebenswiki_app/domain/models/comment.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pack.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Pack {
  @JsonKey(includeFromJson: true, includeToJson: false)
  final int? id;
  final String title;
  final String description;
  final String initiative;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final double readProgress;
  final List<Category> categories;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final User? creator;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final DateTime? creationDate;
  final int readTime;
  @JsonKey(includeFromJson: true, includeToJson: false)
  bool userHasBookmarked;
  @JsonKey(includeFromJson: true, includeToJson: false)
  bool userHasClapped;
  @JsonKey(includeFromJson: true, includeToJson: false)
  int totalBookmarks;
  @JsonKey(includeFromJson: true, includeToJson: false)
  int totalClaps;
  List<PackPage> pages;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<Comment> comments;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final bool published;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? titleImage;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final int totalReads;

  Pack({
    this.id,
    required this.title,
    required this.description,
    this.initiative = "",
    this.readProgress = 0,
    this.categories = const [],
    this.creator,
    this.creationDate,
    required this.readTime,
    this.userHasBookmarked = false,
    this.userHasClapped = false,
    this.totalBookmarks = 0,
    this.totalClaps = 0,
    this.pages = const [],
    this.comments = const [],
    this.published = false,
    this.titleImage,
    this.totalReads = 0,
  });

  factory Pack.fromJson(Map<String, dynamic> json) => _$PackFromJson(json);

  Map<String, dynamic> toJson() => _$PackToJson(this);

  void orderPages() {
    pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
  }

  void orderItems() {
    for (PackPage page in pages) {
      page.orderItems();
    }
  }

  void save() {
    for (PackPage page in pages) {
      page.save();
    }
  }

  void reassignPageNumbers() {
    for (int i = 0; i < pages.length; i++) {
      pages[i].pageNumber = i + 1;
    }
  }
}
