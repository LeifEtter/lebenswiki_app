import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoteHelper {
  int contentId;
  List<User> upVoteData;
  List<User> downVoteData;
  late int? _userId;

  late int totalVotes;
  bool userHasUpVoted = false;
  bool userHasDownVoted = false;
  final ShortApi shortApi = ShortApi();

  VoteHelper({
    required this.contentId,
    required this.upVoteData,
    required this.downVoteData,
  }) {
    _initializeUserId();
    _setTotalVotes();
    _hasVoted(true);
    _hasVoted(false);
  }

  Future<void> _initializeUserId() async {
    var prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt("userId");
  }

  void _setTotalVotes() {
    totalVotes = upVoteData.length - downVoteData.length;
  }

  bool hasVoted(userId, voteData) {
    for (var voteObject in voteData) {
      if (voteObject["id"] == userId) return true;
    }
    return false;
  }

  void _hasVoted(bool isUpvote) {
    for (User voter in isUpvote ? upVoteData : downVoteData) {
      voter.id == _userId
          ? {isUpvote ? userHasUpVoted = true : userHasDownVoted = true}
          : null;
    }
  }

  void vote({
    required isUpvote,
    required reload,
  }) async {
    if ((isUpvote && userHasDownVoted) || (isUpvote && !userHasUpVoted)) {
      shortApi.upvoteShort(contentId);
    } else if ((!isUpvote && userHasUpVoted && !userHasDownVoted) ||
        (!isUpvote && !userHasUpVoted && !userHasDownVoted)) {
      shortApi.downvoteShort(contentId);
    } else {
      isUpvote
          ? shortApi.removeUpvoteShort(contentId)
          : shortApi.removeDownvoteShort(contentId);
    }
    reload();
  }
}
