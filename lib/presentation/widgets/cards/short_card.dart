import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/report_popup.dart';
import 'package:lebenswiki_app/data/short_api.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:intl/intl.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

class ShortCard extends ConsumerStatefulWidget {
  final Short short;
  final bool inSlider;
  final bool isPublished;
  final bool isDraftView;

  const ShortCard({
    super.key,
    required this.short,
    this.inSlider = false,
    this.isPublished = false,
    this.isDraftView = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortCardState();
}

class _ShortCardState extends ConsumerState<ShortCard> {
  late User? user;
  late String profileImage;

  @override
  void initState() {
    user = ref.read(userProvider).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: CustomColors.lightGrey,
            border: (widget.short.published &&
                    user != null &&
                    widget.short.creator!.id == user!.id)
                ? Border.all(width: 2, color: Colors.green.shade300)
                : null,
          ),
          padding: const EdgeInsets.only(
            top: 15,
            right: 15,
            left: 15,
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //TODO Enable showing animal avatars
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: widget.short.creator!.avatar == null
                        ? NetworkImage(widget.short.creator!.profileImage!
                            .replaceAll("https", "http"))
                        : AssetImage(widget.short.creator!.avatar!)
                            as ImageProvider,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    widget.short.creator!.name.split(' ')[0],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 10),
                  //TODO Show categories again
                  // InfoLabel(
                  //   text: widget.short.categories[0].name,
                  //   backgroundColor: CustomColors.mediumGrey,
                  // ),
                  const Spacer(),
                  widget.isDraftView
                      ? Container()
                      : IconButton(
                          iconSize: 30,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: widget.short.userHasBookmarked
                                ? const Icon(Icons.bookmark_added)
                                : const Icon(Icons.bookmark_add_outlined),
                          ),
                          onPressed: () {
                            if (user == null) {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      RegisterRequestPopup(ref));
                            } else {
                              bookmarkCallback();
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
              Row(
                children: [
                  InfoBar(
                    height: 35,
                    width: 160,
                    items: [
                      InfoItem.forText(
                          text: DateFormat.MMMd()
                                  .format(widget.short.creationDate!) +
                              ", " +
                              DateFormat.y()
                                  .format(widget.short.creationDate!)
                                  .split('20')
                                  .last),
                      //TODO Comments
                      // InfoItem.forIconLabel(
                      //     onPress: () => {},
                      //     //TODO Implement Navigate to comment view
                      //     // onPress: () => Navigator.push(
                      //     //     context,
                      //     //     MaterialPageRoute(
                      //     //         builder: (context) => CommentView(
                      //     //             isShort: true, id: widget.short.id!))),
                      //     icon: const Icon(
                      //       Icons.mode_comment,
                      //       size: 20,
                      //     ),
                      //     //TODO Implement comments
                      //     indicator: "10"
                      //     // indicator: widget.short.comments.length.toString() ,
                      //     ),
                      InfoItem.forIconLabel(
                        onPress: () async {
                          if (user == null) {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    RegisterRequestPopup(ref));
                          } else {
                            widget.short.userHasClapped
                                ? CustomFlushbar.error(
                                        message: "Du hast schon geklatscht")
                                    .show(context)
                                : (await ShortApi()
                                        .clapForShort(widget.short.id!))
                                    .fold(
                                    (left) {
                                      CustomFlushbar.error(message: left.error)
                                          .show(context);
                                    },
                                    (right) {
                                      CustomFlushbar.success(message: right)
                                          .show(context);
                                      setState(() {
                                        widget.short.totalClaps += 1;
                                        widget.short.userHasClapped = true;
                                      });
                                    },
                                  );
                          }
                        },
                        emoji: Emoji.byName("clapping hands").toString(),
                        indicator: widget.short.totalClaps.toString(),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      if (user == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                RegisterRequestPopup(ref));
                      } else {
                        await showDialog(
                          context: context,
                          builder: (context) => ReportDialog(
                            resourceName: "Short",
                            reportCallback:
                                (bool blockUser, String reason) async {
                              Either<CustomError, String> reportResult =
                                  await ShortApi()
                                      .reportShort(widget.short.id!, reason);
                              if (reportResult.isRight && !blockUser) {
                                CustomFlushbar.success(
                                        message:
                                            "Short wurde gemeldet. Wir sehen uns deine Meldung an")
                                    .show(context);

                                return;
                              }
                              if (reportResult.isLeft) {
                                CustomFlushbar.error(
                                        message:
                                            "Short konnte nicht gemeldet werden")
                                    .show(context);
                                return;
                              }
                              if (blockUser) {
                                Either<CustomError, String> blockResult =
                                    await UserApi().blockUser(
                                        widget.short.creator!.id!, reason);
                                if (blockResult.isRight) {
                                  CustomFlushbar.success(
                                          message:
                                              "Nutzer wurde blockiert. Shorts und Packs des Nutzers werden nicht mehr bei dir auftauchen")
                                      .show(context);
                                  ref.read(reloadProvider).reload();
                                  return;
                                }
                                if (blockResult.isLeft) {
                                  CustomFlushbar.error(
                                          message:
                                              "Nutzer konnte nicht blockiert werden. Bitte kontaktiere uns. Wir haben jedoch den Short gemeldet.")
                                      .show(context);
                                  return;
                                }
                              }
                            },
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.flag),
                  )
                ],
              ),
            ],
          ),
        ),
        (widget.short.published &&
                user != null &&
                widget.short.creator!.id == user!.id)
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

  void bookmarkCallback() async {
    widget.short.userHasBookmarked
        ? await ShortApi().unbookmarkShort(widget.short.id!).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            widget.short.userHasBookmarked = false;
            widget.short.bookmarks -= 1;
          })
        : await ShortApi().bookmarkShort(widget.short.id!).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            widget.short.userHasBookmarked = true;
            widget.short.bookmarks += 1;
          });
    setState(() {});
  }
}
