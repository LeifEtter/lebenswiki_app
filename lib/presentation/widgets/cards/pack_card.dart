import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/report_popup.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:emojis/emoji.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

class PackCard extends ConsumerStatefulWidget {
  final String heroParent;
  final Pack pack;
  final bool isDraftView;
  final String? title;

  const PackCard({
    super.key,
    required this.pack,
    required this.heroParent,
    this.isDraftView = false,
    this.title,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackCardState();
}

class _PackCardState extends ConsumerState<PackCard> {
  final PackApi packApi = PackApi();
  late Pack pack;
  late bool isPublished;
  bool isReading = false;
  late int progressPercentage;
  late User? user;

  int calculateProgressPercentage(double progress, int pageAmount) =>
      pageAmount == 0 ? 100 : ((progress / pageAmount) * 100).round();

  @override
  Widget build(BuildContext context) {
    pack = widget.pack;
    user = ref.read(userProvider).user;
    if (widget.pack.readProgress > 0) isReading = true;
    progressPercentage =
        calculateProgressPercentage(pack.readProgress, pack.pages.length);
    return GestureDetector(
      // onTap: () async {
      //   isReading || widget.isDraftView || pack.readProgress >= 1
      //       ? await Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => PackViewerStarted(
      //                     packId: pack.id!,
      //                     heroName: "${widget.heroParent}-${pack.id}-hero",
      //                   )))
      //       : await Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: ((context) => ViewPack(
      //                     packId: pack.id!,
      //                     heroName: "${widget.heroParent}-${pack.id}-hero",
      //                   ))));
      onTap: () async {
        isReading || widget.isDraftView || pack.readProgress >= 1
            ? context.go("/pack/${pack.id!}")
            : context.go("/pack/overview/${pack.id!}");

        // ref.read(reloadProvider).reload();
      },
      child: Container(
        decoration: BoxDecoration(
          border:
              (pack.published && user != null && pack.creator!.id == user!.id)
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
                        child: pack.titleImage != null
                            ? Image.network(
                                pack.titleImage!.replaceAll('https', 'http'),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/image_placeholder.png",
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
                            text: pack.categories[0].name,
                            backgroundColor: CustomColors.whiteOverlay,
                          ),
                          InfoLabel(
                            icon: const Icon(
                              Icons.schedule,
                              size: 18,
                            ),
                            text: (pack.pages.length).toString(),
                            backgroundColor: CustomColors.whiteOverlay,
                          ),
                          widget.isDraftView
                              ? Container(width: 50)
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  (pack.published &&
                          user != null &&
                          pack.creator!.id == user!.id)
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
              child: Stack(
                children: [
                  SizedBox(
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
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 0, top: 5),
                            child: Text(
                              "von ${pack.creator!.name} ${pack.initiative.isNotEmpty ? "für ${pack.initiative}" : ""}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 11.0, height: 1.1),
                            ),
                          ),
                          Expanded(child: Container()),
                          !isReading
                              ? _buildInfoBar(context, ref)
                              : Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: _buildProgressRow(context),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: widget.isDraftView
                        ? Container()
                        : Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (user == null) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              RegisterRequestPopup(ref));
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => ReportDialog(
                                          resourceName: "Pack",
                                          reportCallback: (bool blockUser,
                                              String reason) async {
                                            Either<CustomError, String>
                                                reportResult =
                                                await PackApi().reportPack(
                                                    widget.pack.id!, reason);
                                            if (reportResult.isRight &&
                                                !blockUser) {
                                              CustomFlushbar.success(
                                                      message:
                                                          "Pack wurde gemeldet. Wir sehen uns deine Meldung an")
                                                  .show(context);

                                              return;
                                            }
                                            if (reportResult.isLeft) {
                                              CustomFlushbar.error(
                                                      message:
                                                          "Pack konnte nicht gemeldet werden")
                                                  .show(context);
                                              return;
                                            }
                                            if (blockUser) {
                                              Either<CustomError, String>
                                                  blockResult =
                                                  await UserApi().blockUser(
                                                      widget.pack.creator!.id!,
                                                      reason);
                                              if (blockResult.isRight) {
                                                CustomFlushbar.success(
                                                        message:
                                                            "Nutzer wurde blockiert. Shorts und Packs des Nutzers werden nicht mehr bei dir auftauchen")
                                                    .show(context);
                                                ref
                                                    .read(reloadProvider)
                                                    .reload();
                                                return;
                                              }
                                              if (blockResult.isLeft) {
                                                CustomFlushbar.error(
                                                        message:
                                                            "Nutzer konnte nicht blockiert werden. Bitte kontaktiere uns. Wir haben jedoch das Pack gemeldet.")
                                                    .show(context);
                                                return;
                                              }
                                            }
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.flag),
                                ),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  iconSize: 25,
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: pack.userHasBookmarked
                                        ? const Icon(Icons.bookmark_added)
                                        : const Icon(
                                            Icons.bookmark_add_outlined,
                                          ),
                                  ),
                                  onPressed: () {
                                    if (user == null) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              RegisterRequestPopup(ref));
                                    } else {
                                      _bookmarkCallback();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBar(context, ref) => SizedBox(
        height: 35,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBar(
              height: 35,
              width: 160,
              items: [
                InfoItem.forText(
                    text: DateFormat.MMMd().format(widget.pack.creationDate!) +
                        ", " +
                        DateFormat.y()
                            .format(widget.pack.creationDate!)
                            .split('20')
                            .last),
                InfoItem.forIconLabel(
                  onPress: () async {
                    if (user == null) {
                      showDialog(
                          context: context,
                          builder: (context) => RegisterRequestPopup(ref));
                    } else {
                      pack.userHasClapped
                          ? CustomFlushbar.error(
                                  message: "Du hast schon geklatscht")
                              .show(context)
                          : (await PackApi().clapForPack(pack.id)).fold(
                              (left) {
                                CustomFlushbar.error(message: left.error)
                                    .show(context);
                              },
                              (right) {
                                CustomFlushbar.success(message: right)
                                    .show(context);
                                setState(() {
                                  pack.userHasClapped = true;
                                  pack.totalClaps += 1;
                                });
                              },
                            );
                    }
                  },
                  emoji: Emoji.byName("clapping hands").toString(),
                  indicator: pack.totalClaps.toString(),
                ),
                // InfoItem.forIconLabel(
                //   onPress: () => {},
                //   //TODO Implement Navigate to comment view
                //   // onPress: () => Navigator.push(
                //   //     context,
                //   //     MaterialPageRoute(
                //   //         builder: (context) =>
                //   //             CommentView(isShort: false, id: pack.id!))),
                //   icon: const Icon(
                //     Icons.mode_comment,
                //     size: 15,
                //   ),
                //   indicator: pack.comments.length.toString(),
                // ),
              ],
            ),
          ],
        ),
      );

  Widget _buildProgressRow(context) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$progressPercentage% fertig",
                style: Theme.of(context).textTheme.blueLabel),
          ],
        ),
      );

  void _bookmarkCallback() async {
    pack.userHasBookmarked
        ? (await packApi.removeBookmarkPack(pack.id)).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            pack.userHasBookmarked = false;
            pack.totalBookmarks -= 1;
            CustomFlushbar.success(message: right).show(context);
          })
        : (await packApi.bookmarkPack(pack.id)).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            pack.userHasBookmarked = true;
            pack.totalBookmarks += 1;
            CustomFlushbar.success(message: right).show(context);
          });
    setState(() {});
  }
}
