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

// class Short {
//   Short({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.creator,
//     this.creatorId,
//     this.published = false,
//     this.requestPublish = false,
//     this.upVote = const [],
//     this.downVote = const [],
//     this.bookmarks = const [],
//     required this.categories,
//     this.comments = const [],
//     this.reportShort = const [],
//     this.reactions = const [],
//     this.lastUpdated,
//     required this.creationDate,
//     this.claps = const [],
//   }) {
//     creatorId = creator.id;
//     lastUpdated = DateTime.now();
//   }

//   int id;
//   String title;
//   String content;
//   User creator;
//   int? creatorId;
//   bool published;
//   bool requestPublish;
//   List<User> upVote;
//   List<User> downVote;
//   List<User> bookmarks;
//   List<Category> categories;
//   List<Comment> comments;
//   List<Report> reportShort;
//   List<Map> reactions;
//   DateTime creationDate;
//   DateTime? lastUpdated;

//   //Properties that aren't extracted from json
//   bool bookmarkedByUser = false;
//   bool upvotedByUser = false;
//   bool downvotedByUser = false;
//   bool reactedByUser = false;
//   int totalVotes = 0;
//   Map reactionMap = {};
//   List<int> claps = [];

//   factory Short.forError() => Short(
//         id: 0,
//         title: "error",
//         content: "error",
//         categories: [],
//         creator: User(name: "error"),
//         creationDate: DateTime.now(),
//       );

//   factory Short.fromJson(Map<String, dynamic> json) => Short(
//       id: json["id"],
//       title: json["title"],
//       content: json["content"],
//       published: json["published"],
//       requestPublish: json["requestPublish"],
//       creationDate: DateTime.parse(json["creationDate"]),
//       lastUpdated: DateTime.parse(json["lastUpdated"]),
//       upVote: List<User>.from(json["upVote"].map((user) => User.forId(user))),
//       downVote:
//           List<User>.from(json["downVote"].map((user) => User.forId(user))),
//       bookmarks:
//           List<User>.from(json["bookmarks"].map((user) => User.forId(user))),
//       comments: List<Comment>.from(
//           json["comments"].map((comment) => Comment.forShort(comment))),
//       reportShort: List<Report>.from(
//           json["reports"].map((report) => Report.forContent(report))),
//       categories: List.from(json["categories"]
//           .map((category) => Category.fromJson(category))),
//       reactions: List.from(json["reactions"]),
//       creator: User.forContent(json["creator"]),
//       claps: List<int>.from(json["shortClaps"].map((user) => user["id"])));

//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "content": content,
//         "creators": creator.toJson(),
//         "creatorId": creatorId,
//         "published": published,
//         "requestPublish": requestPublish,
//         "upVote": List<dynamic>.from(upVote.map((User user) => user.toJson())),
//         "downVote":
//             List<dynamic>.from(downVote.map((User user) => user.toJson())),
//         "bookmarks":
//             List<dynamic>.from(bookmarks.map((User user) => user.toJson())),
//         "categories": List<dynamic>.from(
//             categories.map((Category category) => category.toJson())),
//         "comments":
//             List<Map>.from(comments.map((Comment comment) => comment.toJson())),
//         "reportShort": List<dynamic>.from(
//             reportShort.map((Report report) => report.toJson())),
//         "reactions": reactions,
//       };

//   void initializeDisplayParams(int currentUserId) {
//     _initVotes(currentUserId);
//     _initHasBookmarked(currentUserId);
//     _setTotalVotes(currentUserId);
//     _generateReactionMap();
//     _setReactions(currentUserId);
//   }

//   bool userHasClapped({required int userId}) {
//     return claps.contains(userId) ? true : false;
//   }

//   void _initHasUpvoted(int currentUserId) {
//     upvotedByUser = false;
//     for (User user in upVote) {
//       if (user.id == currentUserId) {
//         upvotedByUser = true;
//       }
//     }
//   }

//   void _initHasDownVoted(int currentUserId) {
//     downvotedByUser = false;
//     for (User user in downVote) {
//       if (user.id == currentUserId) {
//         downvotedByUser = true;
//       }
//     }
//   }

//   void _initHasBookmarked(int currentUserId) {
//     bookmarkedByUser = false;
//     for (User user in bookmarks) {
//       if (user.id == currentUserId) {
//         bookmarkedByUser = true;
//       }
//     }
//   }

//   void _setTotalVotes(int currentUserId) {
//     totalVotes = upVote.length - downVote.length;
//   }

//   VoteType getVoteType({required bool isUpvote}) {
//     if ((isUpvote && downvotedByUser) || (isUpvote && !upvotedByUser)) {
//       return VoteType.upvote;
//     } else if ((!isUpvote && upvotedByUser && !downvotedByUser) ||
//         (!isUpvote && !upvotedByUser && !downvotedByUser)) {
//       return VoteType.downvote;
//     } else {
//       return isUpvote ? VoteType.removeUpvote : VoteType.removeDownvote;
//     }
//   }

//   void updateUpvote(User user) {
//     upVote.add(user);
//     downVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
//     _initVotes(user.id);
//   }

//   void updateDownvote(User user) {
//     downVote.add(user);
//     upVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
//     _initVotes(user.id);
//   }

//   void removeVotes(User user) {
//     upVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
//     downVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
//     _initVotes(user.id);
//   }

//   void _initVotes(int userId) {
//     _initHasUpvoted(userId);
//     _initHasDownVoted(userId);
//     _setTotalVotes(userId);
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
