import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/components/buttons/vote_button.dart';
import 'package:lebenswiki_app/helper/actions/bookmark_functions.dart';
import 'package:lebenswiki_app/helper/actions/reaction_functions.dart';
import 'package:lebenswiki_app/helper/actions/vote_functions.dart';
import 'package:lebenswiki_app/components/card_components/creator_info.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortCard extends StatefulWidget {
  final Map packData;
  final Function voteReload;
  final CardType contentType;
  final int userId;
  final Function commentExpand;
  final Function(MenuType, Map) menuCallback;

  const ShortCard({
    Key? key,
    required this.packData,
    required this.voteReload,
    required this.contentType,
    required this.userId,
    required this.commentExpand,
    required this.menuCallback,
  }) : super(key: key);

  @override
  State<ShortCard> createState() => _ShortCardState();
}

class _ShortCardState extends State<ShortCard> {
  bool hasUpvoted = false;
  bool hasDownvoted = false;
  bool reactionMenuOpen = false;
  bool hasReacted = false;
  bool optionsMenuOpen = false;

  bool blockUser = false;

  String? chosenReason = "Illegal unter der NetzDG";

  @override
  Widget build(BuildContext context) {
    convertReactions(widget.packData["reactions"]);
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
          right: 1.0,
          child: Align(
              alignment: Alignment.centerRight,
              child: VoteButtonStack(
                userId: widget.userId,
                currentVotes: getVoteCount(
                  widget.packData["upVote"],
                  widget.packData["downVote"],
                ),
                changeVote: voteCallback,
                id: widget.packData["id"],
                hasDownvoted:
                    hasVoted(widget.userId, widget.packData["downVote"]),
                hasUpvoted: hasVoted(widget.userId, widget.packData["upVote"]),
              )),
        ),
        Positioned.fill(
          right: 15.0,
          top: 5.0,
          child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: GestureDetector(
                  child: Image.asset(
                    isBookmarked(widget.userId, widget.contentType,
                            widget.packData["bookmarks"])
                        ? "assets/icons/bookmark_filled.png"
                        : "assets/icons/bookmark.png",
                    width: 20.0,
                  ),
                  onTap: () {
                    isBookmarked(widget.userId, widget.contentType,
                            widget.packData["bookmarks"])
                        ? unbookmarkShort(widget.packData["id"])
                        : bookmarkShort(widget.packData["id"]);
                    widget.voteReload();
                  },
                ),
              )),
        ),
        Positioned.fill(
          right: 15.0,
          bottom: 5.0,
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                widget.menuCallback(MenuType.moreShort, widget.packData);
              },
              icon: const Icon(Icons.more_horiz_outlined),
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 15.0, bottom: 10.0, right: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CreatorInfo(
                      isComment: false,
                      packData: widget.packData,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: Text(
                        widget.packData["title"],
                        style: LebenswikiTextStyles.packTitle,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: Text(
                        widget.packData["content"],
                        style: LebenswikiTextStyles.packDescription,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            widget.commentExpand();
                          },
                          icon: const Icon(Icons.comment_outlined),
                        ),
                        SizedBox(
                          height: 30,
                          width: 200,
                          child: reactionBar(
                            convertReactions(widget.packData["reactions"]),
                            widget.menuCallback,
                            widget.packData,
                            false,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void voteCallback(isUpvote) {
    vote(
      isUpvote,
      widget.userId,
      widget.voteReload,
      widget.packData["id"],
      widget.packData["upVote"],
      widget.packData["downVote"],
    );
  }

  Future<int?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");
    return userId;
  }
}
