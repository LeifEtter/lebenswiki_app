import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:intl/intl.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class ShortCard extends ConsumerStatefulWidget {
  final Short short;
  final bool inSlider;
  final bool isPublished;

  const ShortCard({
    Key? key,
    required this.short,
    this.inSlider = false,
    this.isPublished = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortCardState();
}

class _ShortCardState extends ConsumerState<ShortCard> {
  late int userId;
  late String profileImage;

  @override
  Widget build(BuildContext context) {
    profileImage = widget.short.creator.profileImage;
    userId = ref.read(userProvider).user.id;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: CustomColors.lightGrey,
            border: (widget.short.published && widget.short.creatorId == userId)
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
                          backgroundImage:
                              AssetImage(widget.short.creator.profileImage),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.short.creator.profileImage),
                        ),
                  const SizedBox(width: 10),
                  Text(
                    widget.short.creator.name.split(' ')[0],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 10),
                  InfoLabel(
                    text: "Finanzen",
                    backgroundColor: CustomColors.mediumGrey,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.bookmark_outline_rounded,
                    size: 30,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5),
                child: Text(widget.short.content),
              ),
              widget.inSlider ? const Spacer() : Container(),
              const SizedBox(height: 10),
              InfoBar(
                items: [
                  InfoItem.forText(
                      text:
                          DateFormat.MMMd().format(widget.short.creationDate)),
                  InfoItem.forIconLabel(
                    onPress: () {},
                    icon: const Icon(
                      Icons.mode_comment,
                      size: 20,
                    ),
                    indicator: widget.short.comments.length.toString(),
                  ),
                  InfoItem.forIconLabel(
                    onPress: () {},
                    emoji: Emoji.byName("clapping hands").toString(),
                    indicator: "10",
                  ),
                ],
              ),
            ],
          ),
        ),
        (widget.short.published && widget.short.creatorId == userId)
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
}
