import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/comments/components/comment_card.dart';
import 'package:lebenswiki_app/features/comments/helper/comment_list_helper.dart';
import 'package:lebenswiki_app/features/comments/models/comment_model.dart';
import 'package:lebenswiki_app/features/common/components/custom_card.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class ShortCommentView extends ConsumerStatefulWidget {
  final Short short;
  final CommentListHelper commentListHelper;

  const ShortCommentView({
    Key? key,
    required this.short,
    required this.commentListHelper,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShortCommentViewState();
}

class _ShortCommentViewState extends ConsumerState<ShortCommentView> {
  TextEditingController commentController = TextEditingController();

  late User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider).user;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNav(pageName: "Kommentare", backName: "Shorts"),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ShortCard(
                    short: widget.short,
                    inCommentView: true,
                  ),
                  LebenswikiCards.standardButton(
                    icon: Icons.add,
                    text: "Kommentieren",
                    horizontalPadding: 20,
                    topPadding: 10,
                    innerPadding: 10,
                    onPressed: () => _openCommentField(),
                    backgroundColor: Colors.blueAccent,
                    itemColors: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Sortieren nach"),
                        const SizedBox(width: 10),
                        _buildSortingButtonRow(),
                      ],
                    ),
                  ),
                  ...List<Widget>.generate(
                    widget.commentListHelper.comments.length,
                    (index) {
                      Comment currentComment =
                          widget.commentListHelper.comments[index];
                      return CommentCard(
                        comment: currentComment,
                        deleteSelf: _commentDeleteSelfCallback,
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingButtonRow() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.blueAccent),
            color: widget.commentListHelper.isSortedByDate
                ? Colors.blueAccent
                : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          child: IconButton(
            constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
            iconSize: 17,
            color: widget.commentListHelper.isSortedByDate
                ? Colors.white
                : Colors.blueAccent,
            onPressed: () {
              widget.commentListHelper.sortByDate();
              setState(() {});
            },
            icon: const Icon(
              Icons.calendar_month,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.blueAccent),
            color: widget.commentListHelper.isSortedByVotes
                ? Colors.blueAccent
                : Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
          child: IconButton(
            constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
            iconSize: 17,
            color: widget.commentListHelper.isSortedByVotes
                ? Colors.white
                : Colors.blueAccent,
            onPressed: () {
              widget.commentListHelper.sortByVote();
              setState(() {});
            },
            icon: const Icon(
              Icons.thumb_up_sharp,
            ),
          ),
        ),
      ],
    );
  }

  void _openCommentField() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 15.0,
                left: 20.0,
                right: 20.0,
                top: 10.0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(user.profileImage),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: true,
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Kommentar hier schreiben",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      /*Navigator.pop(context);
                      await CommentApi()
                          .createCommentShort(
                        id: widget.short.id,
                        comment: commentController.text.toString(),
                      )
                          .then((ResultModel result) {
                        Comment comment = result.responseItem;
                        comment.creator = user;
                        widget.commentListHelper.comments.add(comment);
                        setState(() {});
                      });*/
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _commentDeleteSelfCallback(int id) async {
    /*ResultModel result = await CommentApi().deleteComment(id: id);
    if (result.type == ResultType.success) {
      widget.short.comments.removeWhere((Comment comment) => comment.id == id);
      widget.commentListHelper.comments
          .removeWhere((Comment comment) => comment.id == id);
      CustomFlushbar.success(message: "Kommentar wurde gelöscht").show(context);
    } else {
      CustomFlushbar.error(message: "Kommentar konnte nicht gelöscht werden")
          .show(context);
    }
    setState(() {});*/
  }
}
