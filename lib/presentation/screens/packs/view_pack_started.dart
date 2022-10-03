import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/data/pack_conversion.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/sliver_appbar.dart';
import 'package:lebenswiki_app/repository/backend/read_api.dart';

class PackViewerStarted extends ConsumerStatefulWidget {
  final Read read;
  final String heroName;

  const PackViewerStarted({
    Key? key,
    required this.read,
    required this.heroName,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PackViewerStartedState();
}

class _PackViewerStartedState extends ConsumerState<PackViewerStarted> {
  double barWidth = 0;
  late int progressValue;
  List<ListView> pages = [];
  late int currentIndex;
  late PageController pageController;

  @override
  void initState() {
    progressValue = widget.read.progress;

    initPages(widget.read.pack!);

    if (progressValue == 0) {
      currentIndex = 0;
    } else {
      currentIndex = progressValue - 1;
    }

    pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              ViewerAppBar(
                heroName: widget.heroName,
                titleImage: widget.read.pack!.titleImage,
                categoryName: widget.read.pack!.categories[0].categoryName,
                backFunction: () {
                  if (widget.read.id != 0) {
                    ReadApi().update(
                        id: widget.read.pack!.id!,
                        newProgress: currentIndex + 1);
                  }
                },
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: PageView(
              onPageChanged: (int newIndex) {
                setState(() {
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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                              setState(() {
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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                              setState(() {
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
  }

  void initPages(Pack pack) {
    pages = pack.pages
        .map(
          (PackPage page) => ListView(
            padding: const EdgeInsets.all(15.0),
            children: page.items
                .map((PackPageItem item) =>
                    PackConversion.itemToDisplayWidget(item))
                .toList(),
          ),
        )
        .toList();
  }
}
