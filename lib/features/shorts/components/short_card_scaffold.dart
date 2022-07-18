import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/comments/api/comment_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card.dart';
import 'package:lebenswiki_app/features/comments/helper/get_comments.dart';
import 'package:lebenswiki_app/features/common/components/comment_input.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class ShortCardScaffold extends ConsumerStatefulWidget {
  final Short short;
  final Function reload;
  final CardType cardType;
  const ShortCardScaffold({
    Key? key,
    required this.short,
    required this.reload,
    required this.cardType,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShortCardScaffoldState();
}

class _ShortCardScaffoldState extends ConsumerState<ShortCardScaffold> {
  CommentApi commentApi = CommentApi();
  bool _commentsExpanded = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int userId = ref.watch(userIdProvider).userId;
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
          child: Column(
            children: [
              ShortCard(
                userId: userId,
                short: widget.short,
                reload: widget.reload,
                cardType: widget.cardType,
                commentExpand: _triggerComments,
              ),
              widget.cardType == CardType.shortsByCategory
                  ? Visibility(
                      visible: _commentsExpanded,
                      child: Column(
                        children: [
                          const Divider(),
                          Row(
                            children: [
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: CommentInput(
                                  child: TextField(
                                    maxLines: null,
                                    controller: _commentController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(12.0),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  commentApi
                                      .createCommentShort(
                                          comment: _commentController.text,
                                          id: widget.short.id)
                                      .then((ResultModel result) {
                                    _commentController.text = "";
                                    widget.reload();
                                  });
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: GetContentComments(
                              reload: widget.reload,
                              comments: widget.short.comments,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _triggerComments() {
    setState(() {
      _commentsExpanded ? _commentsExpanded = false : _commentsExpanded = true;
    });
  }
}
