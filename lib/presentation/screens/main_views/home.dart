import 'package:carousel_slider/carousel_slider.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/main_views/see_all.dart';
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
  late List<ContentCategory> categories;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserRole userRole = ref.read(userRoleProvider).role;
    categories = ref.read(categoryProvider).categories;
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(reloadProvider).reload();
      },
      child: FutureBuilder(
          future: ReadApi().getAll(userRole),
          builder: (BuildContext context,
              AsyncSnapshot<Either<CustomError, List<Read>>> snapshot) {
            if (LoadingHelper.isLoading(snapshot)) {
              return LoadingHelper.loadingIndicator();
            }

            if (snapshot.data!.isLeft) {
              return const Center(child: Text("Something went wrong"));
            }

            List<Read> reads = snapshot.data!.right;

            return ListView(
              children: [
                reads.isNotEmpty
                    ? readSection(
                        heroParent: "home-continue",
                        title: "Weiterlesen",
                        reads: reads,
                        isReading: true,
                      )
                    : Container(),
                const SizedBox(height: 10),
                packSection(
                  heroParent: "home-recommended",
                  title: "Für Dich Empfohlen",
                  packs: widget.packHelper.recommendedPacks,
                  isReading: false,
                ),
                const SizedBox(height: 10),
                packSection(
                  heroParent: "home-new",
                  title: "Neue Packs",
                  packs: widget.packHelper.newArticles,
                  isReading: false,
                ),
                const SizedBox(height: 50),
              ],
            );
          }),
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
    required List<Pack> packs,
    required bool isReading,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              ).addPadding(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeeAllView(
                                    title: title,
                                    packs: packs,
                                    categories: categories,
                                  )));
                    },
                    child: const Text(
                      "Alle Packs",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.0),
                    )),
              ),
            ],
          ),
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
                        pack: packs[index],
                      ),
                    )),
          ),
        ],
      );

  Widget readSection({
    required String heroParent,
    required String title,
    required List<Read> reads,
    required bool isReading,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              ).addPadding(),
              Container(),
            ],
          ),
          CarouselSlider(
            options: standardOptions(height: isReading ? 200 : 250),
            items: List.generate(
                reads.length,
                (index) => Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 20 : 10,
                          right: index == reads.length + 1 ? 20 : 10),
                      child: PackCard(
                        heroParent: heroParent,
                        read: reads[index],
                      ),
                    )),
          ),
        ],
      );
}
