import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class VoteHelper {
  int userId;
  List<User> upVoteData;
  List<User> downVoteData;
  Function reloadCallBack;

  bool userHasUpVoted = false;
  bool userHasDownVoted = false;
  late int totalVotes;

  VoteHelper({
    required this.userId,
    this.upVoteData = const [],
    this.downVoteData = const [],
    required this.reloadCallBack,
  }) {
    _setTotalVotes();
    _setHasUpvoted();
    _setHasDownvoted();
  }

  void _setTotalVotes() {
    totalVotes = upVoteData.length - downVoteData.length;
  }

  void _setHasUpvoted() => _setHasVoted(true);
  void _setHasDownvoted() => _setHasVoted(false);
  void _setHasVoted(bool isUpvote) {
    for (User voter in isUpvote ? upVoteData : downVoteData) {
      if (voter.id == userId) {
        isUpvote ? userHasUpVoted = true : userHasDownVoted = true;
        break;
      }
    }
  }

  VoteType getVoteType({required bool isUpvote}) {
    if ((isUpvote && userHasDownVoted) || (isUpvote && !userHasUpVoted)) {
      return VoteType.upvote;
    } else if ((!isUpvote && userHasUpVoted && !userHasDownVoted) ||
        (!isUpvote && !userHasUpVoted && !userHasDownVoted)) {
      return VoteType.downvote;
    } else {
      return isUpvote ? VoteType.removeUpvote : VoteType.removeDownvote;
    }
  }
}
