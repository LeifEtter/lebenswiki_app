import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/a_new_common/labels.dart';
import 'package:lebenswiki_app/features/a_new_screens/view_pack.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/features/a_new_common/theme.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class NewPackCard extends StatefulWidget {
  final String heroParent;
  final int progressValue;
  final bool isStarted;
  final Pack pack;

  const NewPackCard({
    Key? key,
    required this.progressValue,
    required this.isStarted,
    required this.pack,
    required this.heroParent,
  }) : super(key: key);

  @override
  State<NewPackCard> createState() => _NewPackCardState();
}

class _NewPackCardState extends State<NewPackCard> {
  final AnimateIconController animateIconController = AnimateIconController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => ViewPack(
                    pack: widget.pack,
                    heroName: "${widget.heroParent}-${widget.pack.id}-hero",
                  )))),
      child: Container(
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
                      child: Hero(
                        tag: "${widget.heroParent}-${widget.pack.id}-hero",
                        child: Image.network(
                          widget.pack.titleImage,
                          fit: BoxFit.cover,
                        ),
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
                        spacing: 8,
                        children: [
                          InfoLabel(
                            text: widget.pack.categories[0].categoryName,
                            backgroundColor: CustomColors.whiteOverlay,
                          ),
                          InfoLabel(
                            icon: const Icon(
                              Icons.schedule,
                              size: 18,
                            ),
                            text: "' 5",
                            backgroundColor: CustomColors.whiteOverlay,
                          ),
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
                        widget.pack.title,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        "by ${widget.pack.creator!.name} for ${widget.pack.initiative}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Expanded(child: Container()),
                      !widget.isStarted
                          ? _buildInfoBar(context)
                          : _buildProgressRow(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBar(context) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [LebenswikiShadows.fancyShadow]),
              child: Row(
                children: [
                  Text(DateFormat.MMMd().format(widget.pack.creationDate)),
                  _buildVerticalDivider(horizontalPadding: 8),
                  Text(
                      "${Emoji.byName("clapping hands")} ${widget.pack.claps}"),
                  _buildVerticalDivider(horizontalPadding: 8),
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Icon(Icons.mode_comment, size: 15),
                  ),
                  const SizedBox(width: 5),
                  const Text("10"),
                ],
              ),
            ),
            const Spacer(),
            AnimateIcons(
              size: 32,
              startIconColor: CustomColors.offBlack,
              endIconColor: CustomColors.offBlack,
              startIcon: Icons.bookmark_add_outlined,
              endIcon: Icons.bookmark_added,
              onStartIconPress: () => true,
              onEndIconPress: () => true,
              duration: const Duration(milliseconds: 400),
              controller: animateIconController,
            ),
          ],
        ),
      );

  Widget _buildProgressRow(context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${widget.progressValue}% fertig",
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

  Widget _buildVerticalDivider({required double horizontalPadding}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          color: CustomColors.lightGrey,
          width: 2,
          height: 25,
        ),
      );
}
