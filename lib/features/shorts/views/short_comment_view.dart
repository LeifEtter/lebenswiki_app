import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/comments/api/comment_api.dart';
import 'package:lebenswiki_app/features/comments/components/comment_card.dart';
import 'package:lebenswiki_app/features/comments/helper/comment_list_helper.dart';
import 'package:lebenswiki_app/features/comments/models/comment_model.dart';
import 'package:lebenswiki_app/features/common/components/custom_card.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

//TODO finish comment view
//TODO filter out comments from blocked users
class ShortCommentView extends ConsumerStatefulWidget {
  final Short short;

  const ShortCommentView({
    Key? key,
    required this.short,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShortCommentViewState();
}

class _ShortCommentViewState extends ConsumerState<ShortCommentView> {
  TextEditingController commentController = TextEditingController();

  late User user;
  late List<int> blockedIdList;
  late CommentListHelper commentListHelper;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider).user;
    blockedIdList = ref.watch(blockedListProvider).blockedIdList;
    commentListHelper = CommentListHelper(
      comments: widget.short.comments,
      currentUserId: user.id,
      blockedList: blockedIdList,
    );
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
                  ...List<Widget>.generate(
                    widget.short.comments.length,
                    (index) {
                      Comment currentComment = widget.short.comments[index];
                      return CommentCard(comment: currentComment);
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
                      Navigator.pop(context);
                      await CommentApi()
                          .createCommentShort(
                        id: widget.short.id,
                        comment: commentController.text.toString(),
                      )
                          .then((ResultModel result) {
                        Comment comment = result.responseItem;
                        commentListHelper.comments.add(comment);
                        setState(() {});
                      });
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
}
