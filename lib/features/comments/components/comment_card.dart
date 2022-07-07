import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/comment_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/vote_button.dart';
import 'package:lebenswiki_app/features/common/components/cards/creator_info.dart';
import 'package:lebenswiki_app/features/common/helpers/reaction_functions.dart';
import 'package:lebenswiki_app/features/common/helpers/vote_functions.dart';
import 'package:lebenswiki_app/models/comment_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class CommentCard extends ConsumerStatefulWidget {
  final Function reloadCallback;
  final Comment comment;
  final CardType cardType;

  const CommentCard({
    Key? key,
    required this.reloadCallback,
    required this.comment,
    required this.cardType,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  CommentApi commentApi = CommentApi();

  late int userId;
  late VoteHelper voteHelper;
  late ReactionHelper reactionHelper;

  @override
  void initState() {
    super.initState();
    userId = ref.watch(userIdProvider).userId ?? 0;
    voteHelper = VoteHelper(
      userId: userId,
      reloadCallBack: widget.reloadCallback,
    );
    reactionHelper = ReactionHelper(
      reactionsResponse: widget.comment.reactions,
      userId: userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        child: Stack(
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 15.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CreatorInfo(
                          user: widget.comment.creator,
                          creationDate: widget.comment.creationDate,
                          isComment: true,
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 270,
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
                              //TODO implement Menu Callback Provider
                              child: reactionHelper.reactionBar(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  _buildRightHandColumn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightHandColumn() => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VoteButtonStack(
              currentVotes: voteHelper.totalVotes,
              changeVote: _voteCallback,
              hasDownvoted: voteHelper.userHasUpVoted,
              hasUpvoted: voteHelper.userHasDownVoted,
            ),
            //TODO implement menu
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_outlined),
              ),
            ),
          ],
        ),
      );

  void _voteCallback(bool isUpvote) {
    VoteType voteType = voteHelper.getVoteType(isUpvote: isUpvote);
    //TODO implement comment voting
    switch (voteType) {
      case VoteType.upvote:
        break;
      case VoteType.downvote:
        break;
      case VoteType.removeUpvote:
        break;
      case VoteType.removeDownvote:
        break;
    }
  }
}
