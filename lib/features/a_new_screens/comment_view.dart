import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_common/other.dart';
import 'package:lebenswiki_app/features/a_new_common/top_nav.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/bottom_menu.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/comments/api/comment_api.dart';
import 'package:lebenswiki_app/features/comments/models/comment_model.dart';
import 'package:lebenswiki_app/features/common/components/custom_card.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/snackbar/components/custom_flushbar.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class CommentView extends ConsumerStatefulWidget {
  final int id;
  final bool isShort;

  const CommentView({
    required this.isShort,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentViewState();
}

class _CommentViewState extends ConsumerState<CommentView> {
  late User user;
  TextEditingController commentController = TextEditingController();
  List<Comment> exampleComments = [
    Comment(
      id: 0,
      content: "Lorem iaklmdaldkmalkdm, alkdmal sadllka.",
      creator: User(name: ""),
      creatorId: 0,
      parentId: 0,
      creationDate: DateTime.now(),
    ),
    Comment(
      id: 0,
      content: "Lorem iaklmdaldkmalkdm, alkdmal sadllka.",
      creator: User(name: ""),
      creatorId: 0,
      parentId: 0,
      creationDate: DateTime.now(),
    ),
    Comment(
      id: 0,
      content: "Lorem iaklmdaldkmalkdm, alkdmal sadllka.",
      creator: User(name: ""),
      creatorId: 0,
      parentId: 0,
      creationDate: DateTime.now(),
    ),
    Comment(
      id: 0,
      content: "Lorem iaklmdaldkmalkdm, alkdmal sadllka.",
      creator: User(name: ""),
      creatorId: 0,
      parentId: 0,
      creationDate: DateTime.now(),
    ),
    Comment(
      id: 0,
      content: "Lorem iaklmdaldkmalkdm, alkdmal sadllka.",
      creator: User(name: ""),
      creatorId: 0,
      parentId: 0,
      creationDate: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    user = ref.read(userProvider).user;

    return Scaffold(
      body: FutureBuilder(
        future: widget.isShort
            ? PackApi().getPackById(id: widget.id)
            : PackApi().getPackById(id: widget.id),
        builder: (BuildContext context,
            AsyncSnapshot<Either<CustomError, dynamic>> snapshot) {
          if (LoadingHelper.isLoading(snapshot)) {
            return LoadingHelper.loadingIndicator();
          }
          return snapshot.data!.fold(
            (CustomError left) => const Text("not found"),
            (right) {
              Pack pack = right;
              return Stack(
                children: [
                  ListView(
                    children: [
                      TopNavIOS(title: "Comments (${pack.comments.length})"),
                      ...pack.comments.map<Widget>(
                          (Comment comment) => _buildCommentCard(comment)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LebenswikiCards.standardButton(
                        icon: Icons.add,
                        text: "Kommentieren",
                        horizontalPadding: 20,
                        topPadding: 15,
                        innerPadding: 15,
                        onPressed: () => _openCommentField(),
                        backgroundColor: Colors.blueAccent,
                        itemColors: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundAvatar(image: comment.creator.profileImage, size: 55),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.creator.name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        comment.content,
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildIconActionButton(
                              icon: Icons.comment_outlined,
                              onPress: () {},
                            ),
                            _buildIconActionButton(
                              icon: Icons.thumb_up_alt_outlined,
                              onPress: () {},
                            ),
                            _buildIconActionButton(
                              icon: Icons.thumb_down_alt_outlined,
                              onPress: () {},
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => showBottomMenuForCommentActions(
                    context,
                    ownComment: comment.creator.id == user.id,
                    comment: comment,
                  ),
                  icon: const Icon(Icons.more_horiz_outlined),
                ),
              ],
            ),
          ),
          Container(
            height: 3,
            color: CustomColors.lightGrey,
            width: double.infinity,
          ),
        ],
      );

  Widget _buildIconActionButton({
    required IconData icon,
    required Function onPress,
  }) =>
      IconButton(
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        icon: Icon(icon),
        iconSize: 23,
        onPressed: () => onPress(),
        color: CustomColors.textMediumGrey,
      );

  void _openCommentField() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contextOfSheet) => SingleChildScrollView(
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
                  RoundAvatar(image: user.profileImage, size: 40),
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
                      Either<CustomError, String> commentResult =
                          await CommentApi().createCommentPack(
                              id: widget.id, comment: commentController.text);
                      commentResult.fold((left) {
                        CustomFlushbar.error(message: left.error).show(context);
                      }, (right) {
                        Navigator.pop(context);
                        CustomFlushbar.success(message: right).show(context);
                        commentController.text = "";
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

  void showBottomMenuForCommentActions(BuildContext context,
          {bool ownComment = false, required Comment comment}) =>
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 400,
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              ownComment
                  ? buildMenuTile(
                      text: "Kommentar Löschen",
                      icon: Icons.delete,
                      onPress: () async {
                        await CommentApi().deleteComment(id: comment.id).fold(
                          (left) {
                            Navigator.pop(context);
                            CustomFlushbar.error(message: left.error)
                                .show(context);
                          },
                          (right) {
                            Navigator.pop(context);
                            CustomFlushbar.success(message: right)
                                .show(context);
                          },
                        );
                        setState(() {});
                      },
                    )
                  : buildMenuTile(
                      text: "Kommentar Melden",
                      icon: Icons.flag,
                      onPress: () {},
                    ),
              buildMenuTile(
                text: "Kommentieren",
                icon: Icons.comment_outlined,
                onPress: () {
                  //TODO kommentieren auf kommentar implementieren
                },
              ),
            ],
          ),
        ),
      );
}
