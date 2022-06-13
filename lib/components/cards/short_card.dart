import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_models/short_api.dart';
import 'package:lebenswiki_app/components/buttons/vote_button.dart';
import 'package:lebenswiki_app/helper/actions/bookmark_functions.dart';
import 'package:lebenswiki_app/helper/actions/reaction_functions.dart';
import 'package:lebenswiki_app/helper/actions/vote_functions.dart';
import 'package:lebenswiki_app/components/card_components/creator_info.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/short_model.dart';

class ShortCard extends StatefulWidget {
  final Short short;
  final Function voteReload;
  final CardType cardType;
  final int userId;
  final Function commentExpand;
  final Function menuCallback;

  const ShortCard({
    Key? key,
    required this.short,
    required this.voteReload,
    required this.cardType,
    required this.userId,
    required this.commentExpand,
    required this.menuCallback,
  }) : super(key: key);

  @override
  State<ShortCard> createState() => _ShortCardState();
}

class _ShortCardState extends State<ShortCard> {
  bool reactionMenuOpen = false;
  bool hasReacted = false;
  bool optionsMenuOpen = false;
  bool blockUser = false;
  ShortApi shortApi = ShortApi();

  late VoteHelper voteHelper;
  late BookmarkHelper bookmarkHelper;
  late ReactionHelper reactionHelper;

  String? chosenReason = "Illegal unter der NetzDG";

  @override
  void initState() {
    voteHelper = VoteHelper(
      contentId: widget.short.id,
      upVoteData: widget.short.upVote,
      downVoteData: widget.short.downVote,
    );
    bookmarkHelper = BookmarkHelper(
      contentId: widget.short.id,
      bookmarkedBy: widget.short.bookmarks,
      cardType: widget.cardType,
    );
    reactionHelper =
        ReactionHelper(reactionsForContent: widget.short.reactions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //!TODO Repair Reaction Bar
    //convertReactions(widget.short.reactions);
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
          right: 1.0,
          child: Align(
              alignment: Alignment.centerRight,
              child: VoteButtonStack(
                currentVotes: voteHelper.totalVotes,
                changeVote: voteCallback,
                hasDownvoted: voteHelper.userHasDownVoted,
                hasUpvoted: voteHelper.userHasUpVoted,
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
                    bookmarkHelper.userHasBookmarked
                        ? "assets/icons/bookmark_filled.png"
                        : "assets/icons/bookmark.png",
                    width: 20.0,
                  ),
                  onTap: () {
                    bookmarkHelper.toggleBookmarkShort();
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
                widget.menuCallback(MenuType.moreShort, widget.short);
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
                      creationDate: widget.short.creationDate,
                      user: widget.short.creator,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: Text(
                        widget.short.title,
                        style: LebenswikiTextStyles.packTitle,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: Text(
                        widget.short.content,
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
                        //!TODO Repair Reaction Bar
                        /*
                        SizedBox(
                          height: 30,
                          width: 200,
                          child: reactionBar(
                            convertReactions(widget.short.reactions),
                            widget.menuCallback,
                            widget.packData,
                            false,
                          ),
                        ),*/
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
    voteHelper.vote(isUpvote: isUpvote, reload: widget.voteReload);
  }
}
