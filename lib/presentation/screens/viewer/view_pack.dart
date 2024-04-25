import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/user_provider.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/sliver_appbar.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';

class ViewPack extends ConsumerStatefulWidget {
  // final Pack pack;
  final int packId;
  final String heroName;

  const ViewPack({
    super.key,
    // required this.pack,
    required this.packId,
    required this.heroName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewPackState();
}

class _ViewPackState extends ConsumerState<ViewPack> {
  late int fakeReads;
  late User? user;
  late Pack pack;
  PackApi packApi = PackApi();

  @override
  void initState() {
    user = ref.read(userProvider).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: packApi.getPackById(id: widget.packId),
        builder: (context, AsyncSnapshot<Either<CustomError, Pack>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data!.isLeft) {
            return const Center(
              child: Text("Irgendwas ist schiefgelaufen"),
            );
          }

          Pack pack = snapshot.data!.right;
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
                        titleImage: pack.titleImage ??
                            "assets/images/pack_placeholder_image.jpg",
                        categoryName: pack.categories[0].name,
                        clapCallback:
                            user == null ? _showRegisterRequest : _clapCallback,
                        shareCallback: () {},
                        bookmarkCallback: user == null
                            ? _showRegisterRequest
                            : _bookmarkCallback,
                        clapCount: pack.totalClaps,
                        bookmarkIcon: pack.userHasBookmarked
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
                          pack.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            pack.creator!.avatar != null
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        AssetImage(pack.creator!.avatar!),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(pack
                                        .creator!.profileImage!
                                        .replaceAll("https", "http")),
                                  ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                      children: [
                                        TextSpan(text: pack.creator!.name),
                                        TextSpan(
                                          text: " für ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        TextSpan(text: pack.initiative)
                                      ]),
                                ),
                                Text(
                                  "${DateFormat.MMMd().format(pack.creationDate!)}, ${DateFormat.y().format(pack.creationDate!)}",
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
                          pack.description,
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
                              indicator: "${(pack.pages.length / 2)} Min",
                            ),
                            _buildVerticalDivider(),
                            _buildInteractionLabel(
                              label: "Leser",
                              indicator: pack.totalReads.toString(),
                            ),
                            _buildVerticalDivider(),
                            _buildInteractionLabel(
                              label: "Claps",
                              indicator: pack.totalClaps.toString(),
                            ),
                            // _buildVerticalDivider(),
                            // _buildInteractionLabel(
                            //   label: "Kommentare",
                            //   indicator: pack.comments.length.toString(),
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
                          pack.creator!.biography,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 50),
                        LW.buttons.normal(
                          borderRadius: 15.0,
                          color: CustomColors.blue,
                          text: "Pack Starten",
                          action: () async {
                            if (user == null) {
                              context.go("/pack/${pack.id!}");
                              //TODO Reimplement if hero doesn't work
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PackViewerStarted(
                              //         packId: pack.id!,
                              //         heroName: widget.heroName),
                              //   ),
                              // );
                            } else {
                              await PackApi().createRead(pack.id).fold((left) {
                                CustomFlushbar.error(message: left.error)
                                    .show(context);
                              }, (right) {
                                context.go("/pack/${pack.id!}");
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => PackViewerStarted(
                                //       packId: pack.id!,
                                //       heroName: widget.heroName,
                                //     ),
                                //   ),
                                // );
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
        });
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
    setState(() async => pack.userHasBookmarked
        ? await packApi.removeBookmarkPack(pack.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            pack.userHasBookmarked = false;
            pack.totalBookmarks -= 1;
          })
        : await packApi.bookmarkPack(pack.id).fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            pack.userHasBookmarked = true;
            pack.totalBookmarks += 1;
          }));
  }

  void _clapCallback() async {
    pack.userHasClapped
        ? CustomFlushbar.error(message: "Du hast schon geklatscht")
            .show(context)
        : await PackApi().clapForPack(pack.id).fold(
            (left) {
              CustomFlushbar.error(message: left.error).show(context);
            },
            (right) {
              CustomFlushbar.success(message: right).show(context);
              setState(() {
                pack.userHasClapped = true;
                pack.totalClaps += 1;
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
