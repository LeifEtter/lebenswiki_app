import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/components/buttons/vote_button.dart';
import 'package:lebenswiki_app/components/card_functions/bookmark_functions.dart';
import 'package:lebenswiki_app/components/card_functions/options_functions.dart';
import 'package:lebenswiki_app/components/card_functions/reaction_functions.dart';
import 'package:lebenswiki_app/components/card_functions/report_dialog.dart';
import 'package:lebenswiki_app/components/card_functions/vote_functions.dart';
import 'package:lebenswiki_app/components/cards/creator_info.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/testing/border.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:lebenswiki_app/views/report_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentCard extends StatefulWidget {
  final Map packData;
  final Function voteReload;
  final ContentType contentType;

  const CommentCard({
    Key? key,
    required this.packData,
    required this.voteReload,
    required this.contentType,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  int userId = 0;
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
    return FutureBuilder(
      future: getUserId(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                LebenswikiShadows().cardShadow,
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
                                  packData: widget.packData,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.packData["title"],
                                  style: LebenswikiTextStyles.packTitle,
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: 270,
                                  child: Text(
                                    widget.packData["content"],
                                    style: LebenswikiTextStyles.packDescription,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    IconButton(
                                      constraints: BoxConstraints(),
                                      onPressed: () {},
                                      icon: Icon(Icons.comment_outlined),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 200,
                                      child: reactionBar(
                                        convertReactions(
                                            widget.packData["reactions"]),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: GestureDetector(
                                    child: Image.asset(
                                      isBookmarked(
                                        snapshot.data,
                                        widget.contentType,
                                        widget.packData["bookmarks"],
                                      )
                                          ? "assets/icons/bookmark_filled.png"
                                          : "assets/icons/bookmark.png",
                                      width: 20.0,
                                    ),
                                    onTap: () {
                                      isBookmarked(
                                        snapshot.data,
                                        widget.contentType,
                                        widget.packData["bookmarks"],
                                      )
                                          ? unbookmarkShort(
                                              widget.packData["id"])
                                          : bookmarkShort(
                                              widget.packData["id"]);
                                      widget.voteReload();
                                    },
                                  ),
                                ),
                                VoteButtonStack(
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
                                ),
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
                        snapshot.data,
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
                        snapshot.data,
                        triggerOptionsMenu,
                        showReportDialog,
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
  }

  void updateReaction(userId, reaction) async {
    checkReaction(userId, widget.packData["reactions"])
        ? print("Has already reacted")
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
      userId,
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

  void _routeYourShorts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportView(
          packData: widget.packData,
        ),
      ),
    );
  }
}
