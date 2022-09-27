import 'package:carousel_slider/carousel_slider.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/common/extensions.dart';
import 'package:lebenswiki_app/application/data/pack_list_helper.dart';
import 'package:lebenswiki_app/repository/backend/read_api.dart';

class HomeView extends ConsumerStatefulWidget {
  final PackListHelper packHelper;

  const HomeView({
    Key? key,
    required this.packHelper,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ReadApi().getAll(),
        builder: (BuildContext context,
            AsyncSnapshot<Either<CustomError, List<Read>>> snapshot) {
          if (LoadingHelper.isLoading(snapshot)) {
            return LoadingHelper.loadingIndicator();
          }
          if (snapshot.data!.isLeft) {
            return const Center(child: Text("Something went wrong"));
          }

          List<Read> reads = snapshot.data!.right;
          List<Pack> startedPacks =
              reads.map((Read read) => read.pack).toList();

          return ListView(
            children: [
              startedPacks.isNotEmpty
                  ? packSection(
                      heroParent: "home-continue",
                      title: "Continue Reading",
                      packs: startedPacks,
                      isReading: true,
                    )
                  : Container(),
              const SizedBox(height: 10),
              packSection(
                heroParent: "home-recommended",
                title: "Recommended For You",
                packs: widget.packHelper.recommendedPacks,
                isReading: false,
              ),
              const SizedBox(height: 10),
              packSection(
                heroParent: "home-new",
                title: "New Articles",
                packs: widget.packHelper.newArticles,
                isReading: false,
              ),
              const SizedBox(height: 50),
            ],
          );
        });
  }

  CarouselOptions standardOptions({required double height}) => CarouselOptions(
        enableInfiniteScroll: false,
        padEnds: false,
        height: height,
        viewportFraction: 0.75,
      );

  Widget packSection({
    required String heroParent,
    required String title,
    required List packs,
    required bool isReading,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ).addPadding(),
          CarouselSlider(
            options: standardOptions(height: isReading ? 200 : 250),
            items: List.generate(
                packs.length,
                (index) => Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 20 : 10,
                          right: index == packs.length + 1 ? 20 : 10),
                      child: PackCard(
                        heroParent: heroParent,
                        progressValue: 0,
                        isStarted: isReading,
                        pack: packs[index],
                      ),
                    )),
          ),
        ],
      );
}
