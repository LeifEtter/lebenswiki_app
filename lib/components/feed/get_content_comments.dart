import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/cards/comment_card.dart';
import 'package:lebenswiki_app/models/enums.dart';

class GetContentComments extends StatefulWidget {
  final Function reload;
  final List comments;
  final Function menuCallback;

  const GetContentComments({
    Key? key,
    required this.reload,
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
              comment: currentComment,
              voteReload: widget.reload,
              cardType: CardType.shortComments,
              menuCallback: widget.menuCallback,
            ),
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
