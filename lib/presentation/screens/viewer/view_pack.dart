import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/viewer/view_pack_started.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/sliver_appbar.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';

class ViewPack extends ConsumerStatefulWidget {
  final Pack pack;
  final String heroName;

  const ViewPack({
    super.key,
    required this.pack,
    required this.heroName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewPackState();
}

class _ViewPackState extends ConsumerState<ViewPack> {
  late int fakeReads;
  late User? user;
  PackApi packApi = PackApi();

  @override
  void initState() {
    user = ref.read(userProvider).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                ViewerAppBar(
                  heroName: widget.heroName,
                  titleImage: widget.pack.titleImage ??
                      "assets/images/pack_placeholder_image.jpg",
                  categoryName: widget.pack.categories[0].name,
                  clapCallback:
                      user == null ? _showRegisterRequest : _clapCallback,
                  shareCallback: () {},
                  bookmarkCallback:
                      user == null ? _showRegisterRequest : _bookmarkCallback,
                  clapCount: widget.pack.totalClaps,
                  bookmarkIcon: widget.pack.userHasBookmarked
                      ? const Icon(Icons.bookmark_added, size: 20)
                      : const Icon(Icons.bookmark_add_outlined, size: 20),
                )
              ];
            },
            body: Container(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    widget.pack.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      widget.pack.creator!.avatar != null
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage(widget.pack.creator!.avatar!),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(widget
                                  .pack.creator!.profileImage!
                                  .replaceAll("https", "http")),
                            ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: Theme.of(context).textTheme.displaySmall,
                                children: [
                                  TextSpan(text: widget.pack.creator!.name),
                                  TextSpan(
                                    text: " für ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(text: widget.pack.initiative)
                                ]),
                          ),
                          Text(
                            "${DateFormat.MMMd().format(widget.pack.creationDate!)}, ${DateFormat.y().format(widget.pack.creationDate!)}",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.pack.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: CustomColors.textMediumGrey),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInteractionLabel(
                        label: "Lesezeit",
                        indicator: "${(widget.pack.pages.length / 2)} Min",
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Leser",
                        indicator: widget.pack.totalReads.toString(),
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Claps",
                        indicator: widget.pack.totalClaps.toString(),
                      ),
                      // _buildVerticalDivider(),
                      // _buildInteractionLabel(
                      //   label: "Kommentare",
                      //   indicator: widget.pack.comments.length.toString(),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Divider(
                      color: CustomColors.lightGrey,
                      thickness: 2,
                    ),
                  ),
                  Text(
                    "Über den Autor",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pack.creator!.biography,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 50),
                  LW.buttons.normal(
                    borderRadius: 15.0,
                    color: CustomColors.blue,
                    text: "Pack Starten",
                    action: () async {
                      if (user == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackViewerStarted(
                                packId: widget.pack.id!,
                                heroName: widget.heroName),
                          ),
                        );
                      } else {
                        await PackApi().createRead(widget.pack.id).fold((left) {
                          CustomFlushbar.error(message: left.error)
                              .show(context);
                        }, (right) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackViewerStarted(
                                packId: widget.pack.id!,
                                heroName: widget.heroName,
                              ),
                            ),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionLabel(
          {required String label, required String indicator}) =>
      Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 5),
          Text(
            indicator,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );

  Widget _buildVerticalDivider() => Padding(
        padding: const EdgeInsets.symmetric(),
        child: Container(
          color: CustomColors.lightGrey,
          width: 2,
          height: 40,
        ),
      );

  void _bookmarkCallback() async {
    setState(() async => widget.pack.userHasBookmarked
        ? await packApi.removeBookmarkPack(widget.pack.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            widget.pack.userHasBookmarked = false;
            widget.pack.totalBookmarks -= 1;
          })
        : await packApi.bookmarkPack(widget.pack.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            widget.pack.userHasBookmarked = true;
            widget.pack.totalBookmarks += 1;
          }));
  }

  void _clapCallback() async {
    widget.pack.userHasClapped
        ? CustomFlushbar.error(message: "Du hast schon geklatscht")
            .show(context)
        : await PackApi().clapForPack(widget.pack.id).fold(
            (left) {
              CustomFlushbar.error(message: left.error).show(context);
            },
            (right) {
              CustomFlushbar.success(message: right).show(context);
              setState(() {
                widget.pack.userHasClapped = true;
                widget.pack.totalClaps += 1;
              });
            },
          );
  }

  void _showRegisterRequest() => showDialog(
      context: context,
      builder: (BuildContext context) => RegisterRequestPopup(ref));

  //TODO implement share
  //void _shareCallback() async {}
}
