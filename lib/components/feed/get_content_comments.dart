import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/cards/comment_card.dart';
import 'package:lebenswiki_app/components/cards/short_card.dart';
import 'package:lebenswiki_app/data/enums.dart';

class GetContentComments extends StatefulWidget {
  final Function reload;
  final int userId;
  final List comments;
  final Function(MenuType, Map) menuCallback;

  const GetContentComments({
    Key? key,
    required this.reload,
    required this.userId,
    required this.comments,
    required this.menuCallback,
  }) : super(key: key);

  @override
  _GetContentCommentsState createState() => _GetContentCommentsState();
}

class _GetContentCommentsState extends State<GetContentComments> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        var currentComment = widget.comments[index];
        return Column(
          children: [
            CommentCard(
              packData: currentComment,
              voteReload: widget.reload,
              contentType: ContentType.comments,
              menuCallback: widget.menuCallback,
            ),
            /*ShortCard(
              packData: currentComment,
              voteReload: widget.reload,
              contentType: ContentType.comments,
              commentExpand: () {},
              userId: widget.userId,
              menuCallback: widget.menuCallback,
            ),*/
            const Padding(
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: Divider(),
            ),
          ],
        );
      },
    );
  }
}
