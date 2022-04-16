import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_comments.dart';
import 'package:lebenswiki_app/components/cards/short_card.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/feed/get_content_comments.dart';
import 'package:lebenswiki_app/components/input/comment_input.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/testing/border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lebenswiki_app/data/enums.dart';

class ShortCardScaffold extends StatefulWidget {
  final Map packData;
  final Function voteReload;
  final ContentType contentType;
  final Function(MenuType, Map) menuCallback;

  const ShortCardScaffold({
    Key? key,
    required this.packData,
    required this.voteReload,
    required this.contentType,
    required this.menuCallback,
  }) : super(key: key);

  @override
  _ShortCardScaffoldState createState() => _ShortCardScaffoldState();
}

class _ShortCardScaffoldState extends State<ShortCardScaffold>
    with AutomaticKeepAliveClientMixin {
  bool _commentsExpanded = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserId(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData ||
            snapshot.data == null ||
            widget.packData["bookmarks"] == null) {
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
                child: Column(
                  children: [
                    ShortCard(
                      packData: widget.packData,
                      voteReload: widget.voteReload,
                      contentType: widget.contentType,
                      userId: snapshot.data,
                      commentExpand: _triggerComments,
                      menuCallback: widget.menuCallback,
                    ),
                    widget.contentType == ContentType.shortsByCategory
                        ? Visibility(
                            visible: _commentsExpanded,
                            child: Column(
                              children: [
                                Divider(),
                                Row(
                                  children: [
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: CommentInput(
                                        child: TextField(
                                          maxLines: null,
                                          controller: _commentController,
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.all(12.0),
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
                                        createComment(
                                          _commentController.text.toString(),
                                          widget.packData["id"],
                                        ).whenComplete(
                                            () => widget.voteReload());
                                        _commentController.text = "";
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: GetContentComments(
                                    reload: widget.voteReload,
                                    userId: snapshot.data,
                                    comments: widget.packData["comments"],
                                    menuCallback: widget.menuCallback,
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
      },
    );
  }

  Future<int?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");
    return userId;
  }

  void _triggerComments() {
    setState(() {
      _commentsExpanded ? _commentsExpanded = false : _commentsExpanded = true;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
