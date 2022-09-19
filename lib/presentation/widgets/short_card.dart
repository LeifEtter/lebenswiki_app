import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/widgets/labels.dart';
import 'package:lebenswiki_app/presentation/widgets/colors.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:intl/intl.dart';
import 'package:emojis/emoji.dart';

class NewShortCard extends ConsumerStatefulWidget {
  final Short short;
  final bool inSlider;

  const NewShortCard({
    Key? key,
    required this.short,
    this.inSlider = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewShortCardState();
}

class _NewShortCardState extends ConsumerState<NewShortCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: CustomColors.lightGrey,
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
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
                  text: DateFormat.MMMd().format(widget.short.creationDate)),
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
    );
  }
}
