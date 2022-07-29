import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/comments/components/comment_card.dart';
import 'package:lebenswiki_app/features/comments/models/comment_model.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';

//TODO finish comment view
//TODO filter out comments from blocked users
class ShortCommentView extends StatefulWidget {
  final Short short;

  const ShortCommentView({
    Key? key,
    required this.short,
  }) : super(key: key);

  @override
  State<ShortCommentView> createState() => _ShortCommentViewState();
}

class _ShortCommentViewState extends State<ShortCommentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNav(pageName: "Kommentare", backName: "Shorts"),
            ListView(
              shrinkWrap: true,
              children: [
                ShortCard(
                  short: widget.short,
                  inCommentView: true,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.short.comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment currentComment = widget.short.comments[index];
                    return CommentCard(comment: currentComment);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
