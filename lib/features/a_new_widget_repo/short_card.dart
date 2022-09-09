import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_common/labels.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:intl/intl.dart';
import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';

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
          widget.inSlider ? Spacer() : Container(),
          const SizedBox(height: 10),
          _buildInfoBar(context),
        ],
      ),
    );
  }

  Widget _buildInfoBar(context) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                  text: DateFormat.MMMd().format(widget.short.creationDate)),
              const TextSpan(text: "   |   "),
              WidgetSpan(
                  child: IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: (() {}),
                icon: const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(
                    Icons.comment_rounded,
                    size: 20.0,
                  ),
                ),
              )),
              TextSpan(text: " " + widget.short.comments.length.toString()),
              const TextSpan(text: "   |   "),
              const TextSpan(text: Emojis.moneyMouthFace + "12  "),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Image.asset(
                    "assets/emojis/add_reaction.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        /*child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "${DateFormat.MMMd().format(widget.short.creationDate)}  |  ${}  |  "),
            const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(Icons.mode_comment, size: 15),
            ),
            const Text(" "),
            const Spacer(),
            const Icon(Icons.bookmark_outline, size: 30.0),
          ],
        ),*/
      );
}
