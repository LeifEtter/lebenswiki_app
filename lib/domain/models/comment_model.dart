import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/report_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

class Comment {
  Comment({
    required this.id,
    required this.content,
    required this.creator,
    required this.creatorId,
    required this.parentId,
    this.parentComment,
    this.childComments,
    this.reports,
    this.reactions = const [],
    required this.creationDate,
    this.shortsCommentId,
    this.packAsCommentId,
    this.parentCommentId,
    this.upVote = const [],
    this.downVote = const [],
  });

  int id;
  String content;
  User creator;
  int creatorId;
  int parentId;
  Comment? parentComment;
  List<Comment>? childComments;
  List<Report>? reports;
  List<User> upVote;
  List<User> downVote;
  List<Map> reactions;
  DateTime creationDate;

  //Universal params
  int? shortsCommentId;
  int? packAsCommentId;
  int? parentCommentId;

  //Temp params
  bool upvotedByUser = false;
  bool downvotedByUser = false;
  bool reactedByUser = false;
  int totalVotes = 0;
  Map reactionMap = {};

  factory Comment.forUniversal(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["commentResponse"],
        creator: User.forContent(json["creator"]),
        creatorId: json["creatorId"],
        parentId: 0,
        shortsCommentId: json["shortsCommentId"],
        packAsCommentId: json["packsCommentId"],
        parentCommentId: json["parentCommentId"],
        creationDate: DateTime.parse(json["creationDate"]),
        reactions: List<Map>.from(json["reactions"]),
        reports: List<Report>.from(
            json["reportedComment"].map((report) => Report.forContent(report))),
        upVote: json["upVote"] != null
            ? List<User>.from(json["upVote"].map((user) => User.forId(user)))
            : [],
        downVote: json["downVote"] != null
            ? List<User>.from(json["downVote"].map((user) => User.forId(user)))
            : [],
      );

  factory Comment.forPack(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["commentResponse"],
        creator: json["creator"] != null
            ? User.forContent(json["creator"])
            : User(name: "Placeholder"),
        creatorId: json["creatorId"],
        parentId: json["packAsCommentId"],
        creationDate: DateTime.parse(json["creationDate"]),
        reactions: List<Map>.from(json["reactions"]),
        reports: json["reportedComment"] != null
            ? List<Report>.from(json["reportedComment"]
                .map((report) => Report.forContent(report)))
            : [],
        upVote: json["upVote"] != null
            ? List<User>.from(json["upVote"].map((user) => User.forId(user)))
            : [],
        downVote: json["downVote"] != null
            ? List<User>.from(json["downVote"].map((user) => User.forId(user)))
            : [],
      );

  factory Comment.forShort(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["commentResponse"],
        creator: json["creator"] != null
            ? User.forContent(json["creator"])
            : User(name: "Placeholder"),
        creatorId: json["creatorId"],
        parentId: json["shortsCommentId"],
        creationDate: DateTime.parse(json["creationDate"]),
        reactions: List<Map>.from(json["reactions"]),
        reports: json["reportedComment"] != null
            ? List<Report>.from(json["reportedComment"]
                .map((report) => Report.forContent(report)))
            : [],
        upVote: json["upVote"] != null
            ? List<User>.from(json["upVote"].map((user) => User.forId(user)))
            : [],
        downVote: json["downVote"] != null
            ? List<User>.from(json["downVote"].map((user) => User.forId(user)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "commentResponse": content,
        "creator": creator.toJson(),
        "reactions": reactions,
      };

  void initializeDisplayParams(int currentUserId) {
    _initHasUpvoted(currentUserId);
    _initHasDownVoted(currentUserId);
    _setTotalVotes(currentUserId);
    _generateReactionMap();
    _setReactions(currentUserId);
  }

  void _generateReactionMap() {
    Map result = {};
    for (var value in Reactions.values) {
      result[value.name] = 0;
    }
    reactionMap = result;
  }

  void _setReactions(int currentUserId) {
    for (Map reactionData in reactions) {
      if (reactionData.containsValue(currentUserId)) reactedByUser = true;
      String reactionName = reactionData["reaction"];
      reactionMap[reactionName.toLowerCase()] += 1;
    }
  }

  void react(int currentUserId, String reaction) {
    if (reactedByUser) {
      reactions.removeWhere((Map reaction) => reaction["id"] == currentUserId);
    }
    reactions.add({"id": currentUserId, "reaction": reaction});
    _generateReactionMap();
    _setReactions(currentUserId);
  }

  void _initHasUpvoted(int currentUserId) {
    upvotedByUser = false;
    for (User user in upVote) {
      if (user.id == currentUserId) {
        upvotedByUser = true;
      }
    }
  }

  void _initHasDownVoted(int currentUserId) {
    downvotedByUser = false;
    for (User user in downVote) {
      if (user.id == currentUserId) {
        downvotedByUser = true;
      }
    }
  }

  void _setTotalVotes(int currentUserId) {
    totalVotes = upVote.length - downVote.length;
  }

  VoteType getVoteType({required bool isUpvote}) {
    if ((isUpvote && downvotedByUser) || (isUpvote && !upvotedByUser)) {
      return VoteType.upvote;
    } else if ((!isUpvote && upvotedByUser && !downvotedByUser) ||
        (!isUpvote && !upvotedByUser && !downvotedByUser)) {
      return VoteType.downvote;
    } else {
      return isUpvote ? VoteType.removeUpvote : VoteType.removeDownvote;
    }
  }

  void updateUpvote(User user) {
    upVote.add(user);
    downVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
    reinitVotes(user.id);
  }

  void updateDownvote(User user) {
    downVote.add(user);
    upVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
    reinitVotes(user.id);
  }

  void removeVotes(User user) {
    upVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
    downVote.removeWhere((User iteratedUser) => iteratedUser.id == user.id);
    reinitVotes(user.id);
  }

  void reinitVotes(int userId) {
    _initHasUpvoted(userId);
    _initHasDownVoted(userId);
    _setTotalVotes(userId);
  }
}
