import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/common/extensions.dart';
import 'package:lebenswiki_app/application/pack_list_helper.dart';

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
    return ListView(
      children: [
        packSection(
          heroParent: "home-continue",
          title: "Continue Reading",
          packs: widget.packHelper.startedPacks,
          isReading: true,
        ),
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
