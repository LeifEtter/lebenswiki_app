import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/vote_button.dart';
import 'package:lebenswiki_app/features/packs/components/creator_info.dart';
import 'package:lebenswiki_app/features/common/helpers/bookmark_functions.dart';
import 'package:lebenswiki_app/features/common/helpers/reaction_functions.dart';
import 'package:lebenswiki_app/features/common/helpers/vote_functions.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class ShortCard extends ConsumerStatefulWidget {
  final Short short;
  final Function reload;
  final CardType cardType;
  final int userId;
  final Function commentExpand;
  final Function menuCallback;

  const ShortCard({
    Key? key,
    required this.short,
    required this.reload,
    required this.cardType,
    required this.userId,
    required this.commentExpand,
    required this.menuCallback,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortCardState();
}

class _ShortCardState extends ConsumerState<ShortCard> {
  bool reactionMenuOpen = false;
  bool hasReacted = false;
  bool optionsMenuOpen = false;
  bool blockUser = false;
  ShortApi shortApi = ShortApi();

  late int userId;
  late VoteHelper voteHelper;
  late BookmarkHelper bookmarkHelper;
  late ReactionHelper reactionHelper;

  String? chosenReason = "Illegal unter der NetzDG";

  @override
  void initState() {
    userId = ref.watch(userIdProvider).userId ?? 0;
    voteHelper = VoteHelper(
      upVoteData: widget.short.upVote,
      downVoteData: widget.short.downVote,
      reloadCallBack: widget.reload,
      userId: userId,
    );
    bookmarkHelper = BookmarkHelper(
      contentId: widget.short.id,
      bookmarkedBy: widget.short.bookmarks,
      cardType: widget.cardType,
    );
    reactionHelper = ReactionHelper(
      reactionsResponse: widget.short.reactions,
      userId: userId,
    );
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
                changeVote: _voteCallback,
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
                    bookmarkHelper.toggleBookmarkShort(
                      bookmarkCallback: () =>
                          shortApi.bookmarkShort(widget.short.id),
                      unbookmarkCallback: () =>
                          shortApi.unbookmarkShort(widget.short.id),
                    );
                    widget.reload();
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
                        //TODO implement menu callback
                        SizedBox(
                          height: 30,
                          width: 200,
                          child: reactionHelper.reactionBar(
                              menuCallback: widget.menuCallback),
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

  void _voteCallback(bool isUpvote) {
    VoteType voteType = voteHelper.getVoteType(isUpvote: isUpvote);
    switch (voteType) {
      case VoteType.upvote:
        shortApi.upvoteShort(widget.short.id);
        break;
      case VoteType.downvote:
        shortApi.downvoteShort(widget.short.id);
        break;
      case VoteType.removeUpvote:
        shortApi.removeUpvoteShort(widget.short.id);
        break;
      case VoteType.removeDownvote:
        shortApi.removeDownvoteShort(widget.short.id);
        break;
    }
  }
}
