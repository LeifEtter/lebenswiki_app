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
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage("http://source.unsplash.com/3JmfENcL24M"),
              ),
              Text("Clara Brauer"),
              InfoLabel(
                text: "Finanzen",
                backgroundColor: CustomColors.mediumGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
