import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/packs/components/creator_info.dart';
import 'package:lebenswiki_app/features/common/helpers/reaction_functions.dart';
import 'package:lebenswiki_app/features/common/helpers/vote_functions.dart';
import 'package:lebenswiki_app/features/common/components/loading.dart';
import 'package:lebenswiki_app/features/styling/shadows.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';
import 'package:lebenswiki_app/models/comment_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Function voteReload;
  final CardType cardType;
  final Function menuCallback;

  const CommentCard({
    Key? key,
    required this.comment,
    required this.voteReload,
    required this.cardType,
    required this.menuCallback,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  int userId = 0;
  bool hasReacted = false;

  bool blockUser = false;

  String? chosenReason = "Illegal unter der NetzDG";

  late VoteHelper voteHelper;
  late ReactionHelper reactionHelper;

  @override
  void initState() {
    //!TODO Fix vote functionality
    voteHelper = VoteHelper(
      contentId: widget.comment.id,
      upVoteData: const [],
      downVoteData: const [],
    );
    reactionHelper = ReactionHelper(
      reactionsForContent: widget.comment.reactions!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //!TODO Repair Reaction Bar
    //convertReactions(widget.comment.reactions);
    return FutureBuilder(
      future: getUserId(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Loading();
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                LebenswikiShadows().commentCardShadow,
              ]),
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
                                //!TODO Repair Reaction Bar
                                /*Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 200,
                                      child: reactionBar(
                                        convertReactions(
                                          widget.comment.reactions,
                                        ),
                                        widget.menuCallback,
                                        widget.packData,
                                        true,
                                      ),
                                    ),
                                  ],
                                )*/
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*VoteButtonStack(
                                  userId: snapshot.data,
                                  currentVotes: getVoteCount(
                                    widget.packData["upVote"],
                                    widget.packData["downVote"],
                                  ),
                                  changeVote: voteCallback,
                                  id: widget.packData["id"],
                                  hasDownvoted: hasVoted(
                                      snapshot.data, widget.packData["upVote"]),
                                  hasUpvoted: hasVoted(snapshot.data,
                                      widget.packData["downVote"]),
                                ),*/
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
      },
    );
  }

  void voteCallback(isUpvote) {
    voteHelper.vote(isUpvote: isUpvote, reload: widget.voteReload);
  }

  Future<int?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");
    return userId;
  }
}
