import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/data/enums.dart';

class CommunityFunctions {
  late String? userId;
  late String? packData;

  final Map _reactionMap = {
    "happy": 0,
    "catheart": 0,
    "clap": 0,
    "heart": 0,
    "money": 0,
    "laughing": 0,
    "thumbsup": 0,
    "thinking": 0,
  };

  CommunityFunctions({this.userId});

  bool isBookmarked(CardType contentType, bookmarkData) {
    if (contentType == CardType.packBookmarks ||
        contentType == CardType.shortBookmarks) {
      return true;
    }
    if (bookmarkData.length == 0) {
      return false;
    } else {
      for (var bookmarkObject in bookmarkData) {
        if (bookmarkObject["id"] == userId) {
          return true;
        }
      }
    }
    return false;
  }

  Map convertReactions(reactionData) {
    if (reactionData != null) {
      for (var reaction in reactionData) {
        if (reaction.containsKey("reaction")) {
          _reactionMap[reaction["reaction"].toString().toLowerCase()] += 1;
        }
      }
    }
    return _reactionMap;
  }

  Widget reactionBar(Function menuCallback, isComment) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _reactionMap.length + 1,
      itemBuilder: (context, i) {
        if (i == _reactionMap.length) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
            child: GestureDetector(
              child: Image.asset("assets/emojis/add_reaction.png"),
              onTap: () {
                menuCallback(
                  isComment ? MenuType.reactShortComment : MenuType.reactShort,
                  packData,
                );
              },
            ),
          );
        } else {
          String reaction = _reactionMap.keys.elementAt(i);
          int amount = _reactionMap.values.elementAt(i);
          if (amount != 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset("assets/emojis/$reaction.png"),
                  ),
                  Text(amount.toString()),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
      },
    );
  }

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

  void vote(isUpvote, reload, upvoteData, downVoteData) async {
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
}
