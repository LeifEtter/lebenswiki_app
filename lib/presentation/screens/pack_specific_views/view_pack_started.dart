import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/data/pack_conversion.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav_appbar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';

class PackViewerStarted extends ConsumerStatefulWidget {
  final int id;

  const PackViewerStarted({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PackViewerStartedState();
}

class _PackViewerStartedState extends ConsumerState<PackViewerStarted> {
  List<ListView> pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavIOSAppBar(
        title: "Pack Vorschau",
        rightText: "",
        rightAction: () {},
        appBar: AppBar(),
      ),
      body: FutureBuilder(
          future: PackApi().getPackById(id: widget.id),
          builder: (BuildContext context,
              AsyncSnapshot<Either<CustomError, Pack>> snapshot) {
            if (LoadingHelper.isLoading(snapshot)) {
              return LoadingHelper.loadingIndicator();
            }
            return snapshot.data!.fold(
              (left) => const Center(child: Text("Something went wrong")),
              (right) {
                initPages(right);
                return StatefulBuilder(
                  builder: (context, setState) => PageView(children: pages),
                );
              },
            );
          }),
      bottomNavigationBar: SizedBox(
        child: RoundedProgressBar(
          style: RoundedProgressBarStyle(),
          height: 30,
        ),
        height: 100,
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
