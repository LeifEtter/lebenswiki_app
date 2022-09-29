import 'package:animate_icons/animate_icons.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/packs/view_pack_started.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/presentation/screens/other/comments.dart';
import 'package:lebenswiki_app/presentation/screens/packs/view_pack.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class PackCard extends ConsumerStatefulWidget {
  final String heroParent;
  final Pack? pack;
  final Read? read;
  final bool isDraftView;

  const PackCard({
    Key? key,
    this.pack,
    this.read,
    required this.heroParent,
    this.isDraftView = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackCardState();
}

class _PackCardState extends ConsumerState<PackCard> {
  final AnimateIconController animateIconController = AnimateIconController();
  final PackApi packApi = PackApi();
  late Pack pack;
  late User user;
  late bool isPublished;
  bool isReading = false;
  late int progressPercentage;

  @override
  void initState() {
    pack = widget.pack ?? widget.read!.pack;
    if (widget.read != null) isReading = true;
    if (widget.read != null) {
      progressPercentage =
          ((widget.read!.progress / pack.pages.length) * 100).round();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider).user;
    return GestureDetector(
      onTap: () async {
        isReading
            ? await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PackViewerStarted(
                          read: widget.read!,
                          heroName: "",
                        )))
            : await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => ViewPack(
                          pack: pack,
                          heroName: "${widget.heroParent}-${pack.id}-hero",
                        ))));

        ref.read(reloadProvider).reload();
      },
      child: Container(
        decoration: BoxDecoration(
          border: (pack.published && pack.creatorId == user.id)
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
                        tag: "${widget.heroParent}-${pack.id}-hero",
                        child: Image.network(
                          pack.titleImage,
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
                            text: pack.categories[0].categoryName,
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
                              ? Container(width: 50)
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  (pack.published && pack.creatorId == user.id)
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
                          pack.title,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "by ${pack.creator!.name} for ${pack.initiative}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Expanded(child: Container()),
                      !isReading
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
                text: DateFormat.MMMd().format(pack.creationDate),
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
                            CommentView(isShort: false, id: pack.id!))),
                icon: const Icon(
                  Icons.mode_comment,
                  size: 15,
                ),
                indicator: pack.comments.length.toString(),
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
                    child: pack.bookmarkedByUser
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
            Text("${progressPercentage}% fertig",
                style: Theme.of(context).textTheme.blueLabel),
          ],
        ),
      );

  void _bookmarkCallback() async {
    pack.bookmarkedByUser
        ? await packApi.unbookmarkPack(pack.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            pack.toggleBookmarked(user);
          })
        : await packApi.bookmarkPack(pack.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            pack.toggleBookmarked(user);
          });
    setState(() {});
  }
}
