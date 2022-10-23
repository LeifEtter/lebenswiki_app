import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/other/comments.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/repository/backend/short_api.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:intl/intl.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class ShortCard extends ConsumerStatefulWidget {
  final Short short;
  final bool inSlider;
  final bool isPublished;
  final bool isDraftView;

  const ShortCard({
    Key? key,
    required this.short,
    this.inSlider = false,
    this.isPublished = false,
    this.isDraftView = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortCardState();
}

class _ShortCardState extends ConsumerState<ShortCard> {
  late User user;
  late UserRole userRole;
  late String profileImage;

  @override
  Widget build(BuildContext context) {
    profileImage = widget.short.creator.profileImage;
    user = ref.read(userProvider).user;
    userRole = ref.read(userRoleProvider).role;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: CustomColors.lightGrey,
            border:
                (widget.short.published && widget.short.creatorId == user.id)
                    ? Border.all(width: 2, color: Colors.green.shade300)
                    : null,
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  profileImage.startsWith("assets/")
                      ? CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              AssetImage(widget.short.creator.profileImage),
                        )
                      : CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              NetworkImage(widget.short.creator.profileImage),
                        ),
                  const SizedBox(width: 7),
                  Text(
                    widget.short.creator.name.split(' ')[0],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 10),
                  InfoLabel(
                    text: widget.short.categories[0].categoryName,
                    backgroundColor: CustomColors.mediumGrey,
                  ),
                  const Spacer(),
                  widget.isDraftView
                      ? Container()
                      : IconButton(
                          iconSize: 30,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: widget.short.bookmarkedByUser
                                ? const Icon(Icons.bookmark_added)
                                : const Icon(Icons.bookmark_add_outlined),
                          ),
                          onPressed: () {
                            if (userRole == UserRole.anonymous) {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      RegisterRequestPopup(ref));
                            } else {
                              _bookmarkCallback();
                            }
                          },
                        ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 2),
                child: Text(
                  widget.short.title,
                  style: TextStyle(
                    color: CustomColors.offBlack,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Text(widget.short.content),
              ),
              widget.inSlider ? const Spacer() : Container(),
              const SizedBox(height: 10),
              InfoBar(
                width: 200,
                items: [
                  InfoItem.forText(
                      text:
                          DateFormat.MMMd().format(widget.short.creationDate)),
                  InfoItem.forIconLabel(
                    onPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentView(
                                isShort: true, id: widget.short.id))),
                    icon: const Icon(
                      Icons.mode_comment,
                      size: 20,
                    ),
                    indicator: widget.short.comments.length.toString(),
                  ),
                  InfoItem.forIconLabel(
                    onPress: () {},
                    emoji: Emoji.byName("clapping hands").toString(),
                    indicator: "0",
                  ),
                ],
              ),
            ],
          ),
        ),
        (widget.short.published && widget.short.creatorId == user.id)
            ? Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 40,
                  decoration:
                      BoxDecoration(boxShadow: [LebenswikiShadows.fancyShadow]),
                  child: InfoLabel(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: CustomColors.offBlack,
                      ),
                      borderRadius: 10.0,
                      text: "VERÖFFENTLICHT",
                      backgroundColor: Colors.green.shade200),
                ),
              )
            : Container(),
      ],
    );
  }

  void _bookmarkCallback() async {
    widget.short.bookmarkedByUser
        ? await ShortApi().unbookmarkShort(widget.short.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            widget.short.toggleBookmarked(user);
          })
        : await ShortApi().bookmarkShort(widget.short.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            widget.short.toggleBookmarked(user);
          });
    setState(() {});
  }
}
