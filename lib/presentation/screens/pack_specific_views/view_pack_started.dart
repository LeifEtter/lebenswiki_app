import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/data/pack_conversion.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav_appbar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';

class PackViewerStarted extends ConsumerStatefulWidget {
  final Pack pack;

  const PackViewerStarted({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PackViewerStartedState();
}

class _PackViewerStartedState extends ConsumerState<PackViewerStarted> {
  List<ListView> pages = [];

  @override
  void initState() {
    initPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavIOSAppBar(
        title: "Pack Vorschau",
        rightText: "",
        rightAction: () {},
        appBar: AppBar(),
      ),
      body: PageView(
        children: pages,
      ),
      bottomNavigationBar: Container(
        child: RoundedProgressBar(
          style: RoundedProgressBarStyle(),
          height: 30,
        ),
        height: 100,
      ),
    );
  }

  void initPages() {
    pages = widget.pack.pages
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
