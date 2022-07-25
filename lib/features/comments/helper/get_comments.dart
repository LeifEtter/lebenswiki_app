//import 'package:flutter/material.dart';
//TODO fix comments

/*class GetContentComments extends StatefulWidget {
  final List comments;

  const GetContentComments({
    Key? key,
    required this.comments,
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
            /*CommentCard(
              comment: currentComment,
              reloadCallback: widget.reload,
              cardType: CardType.shortComments,
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
}*/
