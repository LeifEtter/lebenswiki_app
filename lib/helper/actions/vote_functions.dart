import 'package:lebenswiki_app/api/api_shorts.dart';

int getVoteCount(upvoteData, downvoteData) {
  int upvotes = upvoteData.length;
  int downvotes = downvoteData.length;
  int totalVotes = upvotes - downvotes;
  return totalVotes;
}

bool hasVoted(userId, voteData) {
  for (var voteObject in voteData) {
    if (voteObject["id"] == userId) return true;
  }
  return false;
}

void vote(isUpvote, userId, reload, packId, upvoteData, downVoteData) async {
  bool hasUpvoted = false, hasDownvoted = false;
  hasUpvoted = hasVoted(userId, upvoteData);
  hasDownvoted = hasVoted(userId, downVoteData);

  if ((isUpvote && hasDownvoted) || (isUpvote && !hasUpvoted)) {
    voteShort(packId, true);
  } else if ((!isUpvote && hasUpvoted && !hasDownvoted) ||
      (!isUpvote && !hasUpvoted && !hasDownvoted)) {
    voteShort(packId, false);
  } else {
    isUpvote ? removeVote(packId, true) : removeVote(packId, false);
  }
  reload();
}
