import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/pack_specific_views/creator_information.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/presentation/screens/other/comments.dart';
import 'package:lebenswiki_app/presentation/screens/pack_specific_views/view_pack.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class PackCard extends ConsumerStatefulWidget {
  final String heroParent;
  final int progressValue;
  final bool isStarted;
  final Pack pack;
  final bool isDraftView;
  final Function? navigateEditor;
  final Function? navigateInformation;
  final Function? navigateView;
  final Function? deletePack;

  const PackCard({
    Key? key,
    required this.progressValue,
    required this.isStarted,
    required this.pack,
    required this.heroParent,
    this.isDraftView = false,
    this.navigateEditor,
    this.navigateInformation,
    this.navigateView,
    this.deletePack,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackCardState();
}

class _PackCardState extends ConsumerState<PackCard> {
  final AnimateIconController animateIconController = AnimateIconController();
  final PackApi packApi = PackApi();
  late User user;
  late bool isPublished;

  @override
  void initState() {
    super.initState();
  }

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
          border: (widget.pack.published && widget.pack.creatorId == user.id)
              ? Border.all(width: 3, color: Colors.green.shade200)
              : null,
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
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
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
                          widget.isDraftView
                              ? SpeedDial(
                                  elevation: 10,
                                  direction: SpeedDialDirection.down,
                                  backgroundColor: CustomColors.lightGrey,
                                  buttonSize: const Size(50, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Icon(
                                    Icons.settings,
                                    color: CustomColors.textBlack,
                                    size: 28,
                                  ),
                                  children: [
                                    SpeedDialChild(
                                      onTap: () =>
                                          widget.navigateInformation!(),
                                      child:
                                          const Icon(Icons.edit_note_outlined),
                                      label: "Informationen Bearbeiten",
                                    ),
                                    SpeedDialChild(
                                      onTap: () => widget.navigateEditor!(),
                                      child: const Icon(
                                        Icons.edit_outlined,
                                      ),
                                      label: "Inhalt Bearbeiten",
                                    ),
                                    SpeedDialChild(
                                      child: const Icon(Icons.publish_outlined),
                                      label: "Pack Veröffentlichen",
                                    ),
                                    SpeedDialChild(
                                      onTap: () => widget.deletePack!(),
                                      child: const Icon(Icons.delete_outline),
                                      label: "Pack Löschen",
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  (widget.pack.published && widget.pack.creatorId == user.id)
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                boxShadow: [LebenswikiShadows.fancyShadow]),
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
              ),
            ),
            Flexible(
              flex: 50,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 15, right: 5, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.pack.title,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "by ${widget.pack.creator!.name} for ${widget.pack.initiative}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Expanded(child: Container()),
                      !widget.isStarted
                          ? _buildInfoBar(context)
                          : Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: _buildProgressRow(context),
                            ),
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

  Widget _buildInfoBar(context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InfoBar(
            height: 50,
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
                        builder: (context) =>
                            CommentView(isShort: false, id: widget.pack.id!))),
                icon: const Icon(
                  Icons.mode_comment,
                  size: 15,
                ),
                indicator: widget.pack.comments.length.toString(),
              ),
            ],
          ),
          const Spacer(),
          widget.isDraftView
              ? Container()
              : IconButton(
                  iconSize: 30,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: widget.pack.bookmarkedByUser
                        ? const Icon(Icons.bookmark_added)
                        : const Icon(Icons.bookmark_add_outlined),
                  ),
                  onPressed: () => _bookmarkCallback(),
                ),
        ],
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
