import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_common/labels.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';

class NewShortCard extends ConsumerStatefulWidget {
  final Short short;

  const NewShortCard({
    Key? key,
    required this.short,
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
        ],
      ),
    );
  }
}
