import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/report_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/alert_dialog/components/report_popup.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/show_bottom_sheet.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/show_reactions_sheet.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/vote_button.dart';
import 'package:lebenswiki_app/features/common/components/cards/creator_info.dart';
import 'package:lebenswiki_app/features/common/helpers/reaction_functions.dart';
import 'package:lebenswiki_app/features/shorts/views/short_comment_view.dart';
import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

//TODO show am
class ShortCard extends ConsumerStatefulWidget {
  final Short short;
  final bool inCommentView;

  const ShortCard({
    Key? key,
    required this.short,
    this.inCommentView = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortCardState();
}

class _ShortCardState extends ConsumerState<ShortCard> {
  ShortApi shortApi = ShortApi();
  late User user;

  @override
  Widget build(BuildContext context) {
    user = ref.read(userProvider).user;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
      child: GestureDetector(
        onTap: () {
          widget.inCommentView
              ? null
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          ShortCommentView(short: widget.short))));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [LebenswikiShadows.fancyShadow]),
          child: Stack(
            children: [
              Positioned.fill(
                right: 1.0,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: VoteButtonStack(
                      currentVotes: widget.short.totalVotes,
                      changeVote: _voteCallback,
                      hasDownvoted: widget.short.downvotedByUser,
                      hasUpvoted: widget.short.upvotedByUser,
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
                          widget.short.bookmarkedByUser
                              ? "assets/icons/bookmark_filled.png"
                              : "assets/icons/bookmark.png",
                          width: 20.0,
                        ),
                        onTap: () {
                          _bookmarkCallback();
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
                    onPressed: () => showActionsMenuForShorts(
                      context,
                      isBookmarked: widget.short.bookmarkedByUser,
                      bookmarkCallback: () => _bookmarkCallback(),
                      reportCallback: () => _reportCallback(),
                    ),
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
                              widget.inCommentView
                                  ? Container()
                                  : Row(
                                      children: [
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.comment_outlined),
                                        ),
                                        Text(
                                          widget.short.comments.length
                                              .toString(),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                              SizedBox(
                                height: 30,
                                width: 200,
                                child: reactionBar(
                                  widget.short.reactionMap,
                                  () => showReactionMenu(
                                    context,
                                    callback: (String reaction) {
                                      shortApi.reactShort(
                                          widget.short.id, reaction);
                                      widget.short.react(
                                        user.id,
                                        reaction.toLowerCase(),
                                      );
                                      setState(() {});
                                    },
                                  ),
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
          ),
        ),
      ),
    );
  }

  void _bookmarkCallback() {
    widget.short.bookmarkedByUser
        ? shortApi.unbookmarkShort(widget.short.id)
        : shortApi.bookmarkShort(widget.short.id);
    widget.short.toggleBookmarked(user);
    setState(() {});
  }

  void _reportCallback() => showDialog(
        context: context,
        builder: (context) => ReportDialog(
          reportCallback: (bool blockUser, String reason) {
            Report newReport = Report(
              reportedContentId: widget.short.id,
              reason: reason,
              creationDate: DateTime.now(),
            );
            ReportApi().reportShort(report: newReport);

            if (blockUser) {
              UserApi().blockUser(
                id: widget.short.creator.id,
                reason: reason,
              );

              Block newBlock = Block(
                  reason: reason,
                  blocker: user,
                  blockerId: user.id,
                  blocked: widget.short.creator,
                  blockedId: widget.short.creator.id,
                  creationDate: DateTime.now());
              ref.read(blockedListProvider).addBlock(newBlock);
            }
            Navigator.pop(context);
          },
        ),
      );

  void _voteCallback(bool isUpvote) {
    VoteType voteType = widget.short.getVoteType(isUpvote: isUpvote);
    switch (voteType) {
      case VoteType.upvote:
        shortApi.upvoteShort(widget.short.id);
        widget.short.updateUpvote(user);
        break;
      case VoteType.downvote:
        shortApi.downvoteShort(widget.short.id);
        widget.short.updateDownvote(user);
        break;
      case VoteType.removeUpvote:
        shortApi.removeUpvoteShort(widget.short.id);
        widget.short.removeVotes(user);
        break;
      case VoteType.removeDownvote:
        shortApi.removeDownvoteShort(widget.short.id);
        widget.short.removeVotes(user);
        break;
    }
    setState(() {});
  }
}
