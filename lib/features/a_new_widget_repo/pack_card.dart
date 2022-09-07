import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_common/labels.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/features/a_new_common/theme.dart';
import 'package:intl/intl.dart';

class NewPackCard extends StatelessWidget {
  final int progressValue;
  final bool isStarted;
  final Pack pack;

  const NewPackCard({
    Key? key,
    required this.progressValue,
    required this.isStarted,
    required this.pack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: CustomColors.lightGrey,
      ),
      child: Column(
        children: [
          Flexible(
            flex: 50,
            fit: FlexFit.tight,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: Image.network(
                      pack.titleImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      runSpacing: 5.0,
                      children: [
                        InfoLabel(
                          text: pack.categories[0].categoryName,
                          backgroundColor: CustomColors.whiteOverlay,
                        ),
                        InfoLabel(
                            text: "5 Minute Read",
                            backgroundColor: CustomColors.whiteOverlay),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 50,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 15, right: 5, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pack.title,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      "by ${pack.creator!.name} for ${pack.initiative}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Expanded(child: Container()),
                    !isStarted
                        ? _buildInfoBar(context)
                        : _buildProgressRow(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(context) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "${DateFormat.MMMd().format(pack.creationDate)}  |  ${Emoji.byName("clapping hands")} ${pack.claps}  |  "),
            const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(Icons.mode_comment, size: 15),
            ),
            const Text(" "),
            const Spacer(),
            const Icon(Icons.bookmark_outline, size: 30.0),
          ],
        ),
      );

  Widget _buildProgressRow(context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$progressValue% fertig",
              style: Theme.of(context).textTheme.blueLabel),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_outline,
              size: 30,
            ),
          ),
        ],
      );
}
