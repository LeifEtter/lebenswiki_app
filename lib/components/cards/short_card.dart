import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_comments.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/api/api_universal.dart';
import 'package:lebenswiki_app/components/buttons/vote_button.dart';
import 'package:lebenswiki_app/components/card_functions/bookmark_functions.dart';
import 'package:lebenswiki_app/components/card_functions/options_functions.dart';
import 'package:lebenswiki_app/components/card_functions/reaction_functions.dart';
import 'package:lebenswiki_app/components/card_functions/report_dialog.dart';
import 'package:lebenswiki_app/components/card_functions/vote_functions.dart';
import 'package:lebenswiki_app/components/cards/creator_info.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/testing/border.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortCard extends StatefulWidget {
  final Map packData;
  final Function voteReload;
  final ContentType contentType;
  final int userId;
  final Function commentExpand;

  const ShortCard({
    Key? key,
    required this.packData,
    required this.voteReload,
    required this.contentType,
    required this.userId,
    required this.commentExpand,
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
    return Stack(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !(widget.contentType == ContentType.comments)
                        ? CreatorInfo(
                            packData: widget.packData,
                          )
                        : Container(),
                    !(widget.contentType == ContentType.comments)
                        ? SizedBox(height: 5)
                        : Container(),
                    !(widget.contentType == ContentType.comments)
                        ? Text(
                            widget.packData["title"],
                            style: LebenswikiTextStyles.packTitle,
                          )
                        : Container(),
                    SizedBox(
                        height: !(widget.contentType == ContentType.comments)
                            ? 5
                            : 0),
                    Container(
                      width: 270,
                      child: Text(
                        widget.packData[
                            !(widget.contentType == ContentType.comments)
                                ? "content"
                                : "commentResponse"],
                        style: LebenswikiTextStyles.packDescription,
                      ),
                    ),
                    SizedBox(
                      height:
                          widget.contentType == ContentType.comments ? 10 : 20,
                    ),
                    Row(
                      children: [
                        IconButton(
                          constraints: BoxConstraints(),
                          onPressed: () {
                            widget.commentExpand();
                          },
                          icon: Icon(Icons.comment_outlined),
                        ),
                        Container(
                          height: 30,
                          width: 200,
                          child: reactionBar(
                            convertReactions(widget.packData["reactions"]),
                            triggerReactionMenu,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !(widget.contentType == ContentType.comments)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: GestureDetector(
                              child: Image.asset(
                                isBookmarked(
                                  widget.userId,
                                  widget.contentType,
                                  widget.packData["bookmarks"],
                                )
                                    ? "assets/icons/bookmark_filled.png"
                                    : "assets/icons/bookmark.png",
                                width: 20.0,
                              ),
                              onTap: () {
                                isBookmarked(
                                  widget.userId,
                                  widget.contentType,
                                  widget.packData["bookmarks"],
                                )
                                    ? unbookmarkShort(widget.packData["id"])
                                    : bookmarkShort(widget.packData["id"]);
                                widget.voteReload();
                              },
                            ),
                          )
                        : Container(),
                    !(widget.contentType == ContentType.comments)
                        ? VoteButtonStack(
                            userId: widget.userId,
                            currentVotes: getVoteCount(
                              widget.packData["upVote"],
                              widget.packData["downVote"],
                            ),
                            changeVote: voteCallback,
                            id: widget.packData["id"],
                            hasDownvoted: hasVoted(
                                widget.userId, widget.packData["downVote"]),
                            hasUpvoted: hasVoted(
                                widget.userId, widget.packData["upVote"]),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          print("open options Menu");
                          setState(() {
                            optionsMenuOpen = true;
                          });
                        },
                        icon: const Icon(Icons.more_horiz_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: reactionMenuOpen,
          child: buildReactionMenu(
            widget.userId,
            widget.packData["id"],
            allReactions,
            updateReaction,
            triggerReactionMenu,
            widget.voteReload,
          ),
        ),
        Visibility(
          visible: optionsMenuOpen,
          child: buildOptionsMenu(
            widget.userId,
            triggerOptionsMenu,
            showReportDialog,
          ),
        ),
      ],
    );
  }

  void showReportDialog() {
    _reportDialog();
  }

  Future<void> _reportDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 160),
          child: ReportDialog(
            reportCallback: _reportCallback,
            chosenReason: chosenReason,
          ),
        );
      },
    );
  }

  void _reportCallback(String reason, bool blockUser) {
    //print("Reporting short: ${reason}, and blockuser: ${blockUser}");
    blockUser ? blockUserAPI(widget.packData["creator"]["id"], reason) : null;
    reportShort(widget.packData["id"], reason).whenComplete(() {
      setState(() {
        optionsMenuOpen = false;
      });
      widget.voteReload();
      Navigator.pop(context);
    });
  }

  void updateReaction(userId, reaction) async {
    /*checkReaction(userId, widget.packData["reactions"])
        ? print("Has already reacted")
        :*/

    widget.contentType == ContentType.comments
        ? await addCommentReaction(widget.packData["id"], reaction)
        : await addReaction(widget.packData["id"], reaction);
    reactionMenuOpen = false;
    widget.voteReload();
  }

  void triggerReactionMenu() {
    setState(() {
      reactionMenuOpen ? reactionMenuOpen = false : reactionMenuOpen = true;
    });
  }

  void triggerOptionsMenu() {
    setState(() {
      optionsMenuOpen ? optionsMenuOpen = false : optionsMenuOpen = true;
    });
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
