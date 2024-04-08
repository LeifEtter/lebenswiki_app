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


// class Pack {
//   int? id;
//   String title;
//   String description;
//   String titleImage;
//   // bool hasBookmarked;
//   bool published;
//   User? creator;
//   int creatorId;
//   List categories = [];
//   List<PackPage> pages = [];
//   List<User> bookmarks = [];
//   List<Map> reactions = [];
//   List<Comment> comments = [];
//   String imageIdentifier;
//   List<int> claps = [];
//   late DateTime creationDate;

//   //New Params
//   String? initiative;
//   int? readTime;

//   Pack({
//     required this.title,
//     required this.description,
//     required this.pages,
//     required this.categories,
//     required this.titleImage,
//     this.published = false,
//     this.creator,
//     required this.creatorId,
//     this.bookmarks = const [],
//     this.reactions = const [],
//     this.initiative,
//     this.readTime,
//     this.claps = const [],
//     this.comments = const [],
//     this.imageIdentifier = "something",
//   }) {
//     creationDate = DateTime.now();
//   }

//   //Properties that aren't extracted from json
//   bool bookmarkedByUser = false;
//   bool reactedByUser = false;
//   Map reactionMap = {};

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'description': description,
//         'initiative': initiative,
//         'titleImage': titleImage,
//         'categories': categories.isNotEmpty ? [categories.first.id] : [],
//         'pages': List<dynamic>.from(
//           pages.map((PackPage page) => page.toJson()),
//         ),
//         'readTime': readTime,
//         'imageIdentifier': imageIdentifier,
//       };

//   Pack.fromJson(Map json)
//       : id = json["id"],
//         title = json["title"],
//         // reactions =
//         //     json["reactions"] != null ? List<Map>.from(json["reactions"]) : [],
//         creator = User.forContent(json["creator"]),
//         creatorId = json["creatorId"],
//         description = json["description"],
//         titleImage = json["titleImage"],
//         categories = List<Category>.from(
//             json["categories"].map((cat) => Category.forContent(cat))),
//         published = json["published"],
//         bookmarks = json["bookmarks"] != null
//             ? List<User>.from(json["bookmarks"].map((user) => User.forId(user)))
//             : [],
//         creationDate = DateTime.parse(json["creationDate"]),
//         initiative = json["initiative"],
//         readTime = json["readTime"],
//         pages = List<PackPage>.from(
//             json["pages"].map((page) => PackPage.fromResponse(page))),
//         comments = List<Comment>.from(
//             json["comments"].map((comment) => Comment.forPack(comment))),
//         claps = List<int>.from(json["claps"].map((user) => user["id"])),
//         imageIdentifier = json["imageIdentifier"];

//   void initControllers() {
//     for (PackPage page in pages) {
//       page.initControllers();
//     }
//   }

//   bool userHasClapped({required int userId}) {
//     return claps.contains(userId) ? true : false;
//   }

//   void save() {
//     for (PackPage page in pages) {
//       page.save();
//     }
//   }

//   void reassignePageNumbers() {
//     for (int i = 0; i < pages.length; i++) {
//       pages[i].pageNumber = i + 1;
//     }
//   }

//   bool isSaved() {
//     for (PackPage page in pages) {
//       if (!page.isSaved()) return false;
//     }
//     return true;
//   }

//   void initializeDisplayParams(int currentUserId) {
//     _initHasBookmarked(currentUserId);
//     _generateReactionMap();
//     _setReactions(currentUserId);
//   }

//   void _initHasBookmarked(int currentUserId) {
//     bookmarkedByUser = false;

//     for (User user in bookmarks) {
//       if (user.id == currentUserId) {
//         bookmarkedByUser = true;
//       }
//     }
//   }

//   void _generateReactionMap() {
//     Map result = {};
//     for (var value in Reactions.values) {
//       result[value.name] = 0;
//     }
//     reactionMap = result;
//   }

//   void _setReactions(int currentUserId) {
//     for (Map reactionData in reactions) {
//       if (reactionData.containsValue(currentUserId)) reactedByUser = true;
//       String reactionName = reactionData["reaction"];
//       reactionMap[reactionName.toLowerCase()] += 1;
//     }
//   }

//   void react(int currentUserId, String reaction) {
//     if (reactedByUser) {
//       reactions.removeWhere((Map reaction) => reaction["id"] == currentUserId);
//     }
//     reactions.add({"id": currentUserId, "reaction": reaction});
//     _generateReactionMap();
//     _setReactions(currentUserId);
//   }

//   void toggleBookmarked(User user) {
//     bookmarkedByUser
//         ? bookmarks
//             .removeWhere((User iteratedUser) => iteratedUser.id == user.id)
//         : bookmarks.add(user);
//     _initHasBookmarked(user.id);
//   }
// }
