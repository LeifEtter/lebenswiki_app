import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/report_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/alert_dialog/components/report_popup.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/show_bottom_sheet.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/show_reactions_sheet.dart';
import 'package:lebenswiki_app/features/comments/api/comment_api.dart';
import 'package:lebenswiki_app/features/comments/models/comment_model.dart';
import 'package:lebenswiki_app/features/common/components/cards/creator_info.dart';
import 'package:lebenswiki_app/features/common/helpers/reaction_functions.dart';
import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class CommentCard extends ConsumerStatefulWidget {
  final Comment comment;
  final bool inCommentView;

  const CommentCard({
    Key? key,
    required this.comment,
    this.inCommentView = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  final CommentApi commentApi = CommentApi();
  late User user;

  @override
  Widget build(BuildContext context) {
    user = ref.read(userProvider).user;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [LebenswikiShadows.fancyShadow]),
        child: Stack(
          children: [
            /*Positioned.fill(
              right: 1.0,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: VoteButtonStack(
                    currentVotes: widget.comment.totalVotes,
                    changeVote: _voteCallback,
                    hasDownvoted: widget.comment.downvotedByUser,
                    hasUpvoted: widget.comment.upvotedByUser,
                  )),
            ),*/
            Positioned.fill(
              right: 15.0,
              bottom: 5.0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => showActionsMenuForComments(
                    context,
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
                          isComment: true,
                          creationDate: widget.comment.creationDate,
                          user: widget.comment.creator,
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: screenWidth * 0.7,
                          child: Text(
                            widget.comment.content,
                            style: LebenswikiTextStyles.packDescription,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(
                              height: 30,
                              width: 200,
                              child: reactionBar(
                                widget.comment.reactionMap,
                                () => showReactionMenu(
                                  context,
                                  callback: (String reaction) {
                                    commentApi.addCommentReaction(
                                        id: widget.comment.id,
                                        reaction: reaction);
                                    widget.comment.react(
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
    );
  }

  void _reportCallback() => showDialog(
        context: context,
        builder: (context) => ReportDialog(
          reportCallback: (bool blockUser, String reason) {
            Report newReport = Report(
              reportedContentId: widget.comment.id,
              reason: reason,
              creationDate: DateTime.now(),
            );
            ReportApi().reportShort(report: newReport);

            if (blockUser) {
              UserApi().blockUser(
                id: widget.comment.creator.id,
                reason: reason,
              );

              Block newBlock = Block(
                  reason: reason,
                  blocker: user,
                  blockerId: user.id,
                  blocked: widget.comment.creator,
                  blockedId: widget.comment.creator.id,
                  creationDate: DateTime.now());
              ref.read(blockedListProvider).addBlock(newBlock);
            }
            Navigator.pop(context);
          },
        ),
      );

  /*void _voteCallback(bool isUpvote) {
    VoteType voteType = widget.comment.getVoteType(isUpvote: isUpvote);
    switch (voteType) {
      case VoteType.upvote:
        shortApi.upvoteShort(widget.comment.id);
        widget.comment.updateUpvote(user);
        break;
      case VoteType.downvote:
        shortApi.downvoteShort(widget.comment.id);
        widget.comment.updateDownvote(user);
        break;
      case VoteType.removeUpvote:
        shortApi.removeUpvoteShort(widget.comment.id);
        widget.comment.removeVotes(user);
        break;
      case VoteType.removeDownvote:
        shortApi.removeDownvoteShort(widget.comment.id);
        widget.comment.removeVotes(user);
        break;
    }
    setState(() {});
  }*/
}
