import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/data/pack_conversion.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/application/routing/router.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/sliver_appbar.dart';
import 'package:lebenswiki_app/data/pack_api.dart';

class PackViewerStarted extends ConsumerStatefulWidget {
  final int packId;
  final String heroName;

  const PackViewerStarted({
    super.key,
    required this.packId,
    required this.heroName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PackViewerStartedState();
}

class _PackViewerStartedState extends ConsumerState<PackViewerStarted> {
  double barWidth = 0;
  List<ListView> pages = [];
  // late int currentIndex;
  late PageController pageController;
  final PackApi packApi = PackApi();
  late User? user;

  late int currentIndex;

  @override
  void initState() {
    user = ref.read(userProvider).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackApi().getPackById(id: widget.packId),
      builder: (BuildContext context,
          AsyncSnapshot<Either<CustomError, Pack>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingHelper.loadingIndicator();
        }
        if (snapshot.data == null || snapshot.data!.isLeft) {
          return const Text("Something went wrong");
        }
        Pack pack = snapshot.data!.right;
        pack.orderItems();
        pack.orderPages();
        initPages(pack);
        int currentIndex = pack.readProgress.toInt() - 1;
        return StatefulBuilder(builder: ((context, setInnerState) {
          pageController = PageController(initialPage: currentIndex);
          return Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    ViewerAppBar(
                      heroName: widget.heroName,
                      titleImage: pack.titleImage!,
                      categoryName: pack.categories[0].name,
                      backFunction: () async {
                        if (user != null && !(pack.creator!.id == user!.id)) {
                          await PackApi()
                              .updateRead(
                                  packId: pack.id!, progress: currentIndex + 1)
                              .fold((left) {
                            Navigator.popUntil(context,
                                (route) => route.settings.name == homeRoute);
                            CustomFlushbar.error(message: left.error)
                                .show(context);
                          }, (right) {
                            Navigator.popUntil(context,
                                (route) => route.settings.name == homeRoute);
                            CustomFlushbar.success(
                                    message: "Fortschritt gespeichert")
                                .show(context);
                          });
                        } else {
                          Navigator.popUntil(context,
                              (route) => route.settings.name == homeRoute);
                        }
                      },
                      //TODO implement Callbacks
                      clapCallback: () => user == null
                          ? _showRegisterRequest
                          : _clapCallback(pack),
                      shareCallback: () {},
                      bookmarkCallback: () => user == null
                          ? _showRegisterRequest
                          : _bookmarkCallback(pack),
                      clapCount: pack.totalClaps,
                      bookmarkIcon: pack.userHasBookmarked
                          ? const Icon(Icons.bookmark_added, size: 20)
                          : const Icon(Icons.bookmark_add_outlined, size: 20),
                    )
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: PageView(
                    onPageChanged: (int newIndex) {
                      setInnerState(() {
                        currentIndex = newIndex;
                      });
                    },
                    controller: pageController,
                    children: pages,
                  ),
                )),
            bottomNavigationBar: SizedBox(
              height: 80,
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            disabledColor: Colors.black12,
                            onPressed: currentIndex == 0
                                ? null
                                : () {
                                    pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                    setInnerState(() {
                                      currentIndex -= 1;
                                    });
                                  },
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 30,
                            ),
                          ),
                          Text("${currentIndex + 1} / ${pages.length}"),
                          IconButton(
                            disabledColor: Colors.black12,
                            onPressed: currentIndex == pages.length - 1
                                ? null
                                : () {
                                    pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                    setInnerState(() {
                                      currentIndex += 1;
                                    });
                                  },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
      },
    );
  }

  void initPages(Pack pack) {
    pages = pack.pages
        .map(
          (PackPage page) => ListView(
            padding: const EdgeInsets.all(15.0),
            children: page.items
                .map((PackPageItem item) => PackConversion.toViewableItem(item))
                .toList(),
          ),
        )
        .toList();
  }

  void _bookmarkCallback(Pack pack) async {
    pack.userHasBookmarked
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
          });
    setState(() {});
  }

  void _clapCallback(Pack pack) async {
    pack.userHasClapped
        ? CustomFlushbar.error(message: "Du hast schon geklatscht")
            .show(context)
        : await PackApi().clapForPack(pack.id).fold(
            (left) {
              CustomFlushbar.error(message: left.error).show(context);
            },
            (right) {
              CustomFlushbar.success(message: right).show(context);
              pack.userHasClapped = true;
              pack.totalClaps += 1;
              setState(() {});
            },
          );
  }

  void _showRegisterRequest() => showDialog(
      context: context,
      builder: (BuildContext context) => RegisterRequestPopup(ref));
}
