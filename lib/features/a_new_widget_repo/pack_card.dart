import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_common/labels.dart';
import 'package:lebenswiki_app/features/a_new_screens/comment_view.dart';
import 'package:lebenswiki_app/features/a_new_screens/view_pack.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/features/a_new_common/theme.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/features/snackbar/components/custom_flushbar.dart';
import 'package:lebenswiki_app/features/testing/components/border.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:emojis/emoji.dart';

class NewPackCard extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPackCardState();
}

class _NewPackCardState extends ConsumerState<NewPackCard> {
  final AnimateIconController animateIconController = AnimateIconController();
  final PackApi packApi = PackApi();
  late User user;

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider).user;
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
            InfoBar(
              items: [
                InfoItem.forText(
                  text: DateFormat.MMMd().format(widget.pack.creationDate),
                ),
                InfoItem.forIconLabel(
                  onPress: () {},
                  emoji: Emoji.byName("clapping hands").toString(),
                  indicator: "0",
                ),
                InfoItem.forIconLabel(
                  onPress: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentView(
                              isShort: false, id: widget.pack.id!))),
                  icon: const Icon(
                    Icons.mode_comment,
                    size: 20,
                  ),
                  indicator: widget.pack.comments.length.toString(),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              iconSize: 30,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.pack.bookmarkedByUser
                    ? const Icon(Icons.bookmark_added)
                    : const Icon(Icons.bookmark_add_outlined),
              ),
              onPressed: () => _bookmarkCallback(),
            ),
            /*AnimateIcons(
              size: 32,
              startIconColor: CustomColors.offBlack,
              endIconColor: CustomColors.offBlack,
              startIcon: widget.pack.bookmarkedByUser
                  ? Icons.bookmark_added
                  : Icons.bookmark_add_outlined,
              endIcon: widget.pack.bookmarkedByUser
                  ? Icons.bookmark_add_outlined
                  : Icons.bookmark_added,
              onStartIconPress: () => true,
              onEndIconPress: () => true,
              duration: const Duration(milliseconds: 200),
              controller: animateIconController,
            ),*/
          ],
        ),
      );

  Widget _buildProgressRow(context) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${widget.progressValue}% fertig",
                style: Theme.of(context).textTheme.blueLabel),
          ],
        ),
      );

  void _bookmarkCallback() async {
    ResultModel bookMarkResult = widget.pack.bookmarkedByUser
        ? await packApi.unbookmarkPack(widget.pack.id)
        : await packApi.bookmarkPack(widget.pack.id);
    if (bookMarkResult.type == ResultType.success) {
      CustomFlushbar.success(
              message: widget.pack.bookmarkedByUser
                  ? "Lernpack von gespeicherten Lernpacks entfernt"
                  : "Lernpack gespeichert")
          .show(context);
      widget.pack.toggleBookmarked(user);
    } else {
      CustomFlushbar.error(
              message: widget.pack.bookmarkedByUser
                  ? "Lernpack konnte nicht von gespeicherten Lernpacks entfernt werden"
                  : "Lernpack konnte nicht gespeichert werden")
          .show(context);
    }
    setState(() {});
  }
}
