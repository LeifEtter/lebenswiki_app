import 'package:carousel_slider/carousel_slider.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/common/extensions.dart';
import 'package:lebenswiki_app/data/pack_api.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late User? user;
  late List<Category> categories;

  late List<Pack> unreadPacks;
  late List<Pack>? readPacks;

  @override
  void initState() {
    user = ref.read(userProvider).user;
    categories = ref.read(categoryProvider).categories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(reloadProvider).reload();
      },
      child: FutureBuilder(
          future: PackApi().getUnreadPacks(),
          builder: (BuildContext context,
              AsyncSnapshot<Either<CustomError, List<Pack>>> snapshot) {
            if (LoadingHelper.isLoading(snapshot)) {
              return LoadingHelper.loadingIndicator();
            }

            if (snapshot.data == null || snapshot.data!.isLeft) {
              return const Center(child: Text("Something went wrong"));
            }
            unreadPacks = snapshot.data!.right;

            return ListView(
              children: [
                user != null
                    ? FutureBuilder(
                        future: PackApi().getReadPacks(),
                        builder: (context, snapshot) {
                          if (LoadingHelper.isLoading(snapshot)) {
                            return LoadingHelper.loadingIndicator();
                          }

                          if (snapshot.data == null || snapshot.data!.isLeft) {
                            return const Center(
                                child: Text("Something went wrong"));
                          }
                          readPacks = snapshot.data!.right;

                          return readPacks!.isNotEmpty
                              ? readSection(
                                  heroParent: "home-continue",
                                  title: "Weiterlesen",
                                  packs: readPacks!,
                                  isReading: true,
                                )
                              : Container();
                        })
                    : Container(),
                const SizedBox(height: 10),
                // packSection(
                //   heroParent: "home-recommended",
                //   title: "Für Dich Empfohlen",
                //   packs: widget.packHelper.recommendedPacks,
                //   isReading: false,
                // ),
                // const SizedBox(height: 10),
                packSection(
                  heroParent: "home-new",
                  title: "Neue Packs",
                  packs: unreadPacks,
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
              //TODO Implement all packs screen
              // Padding(
              //   padding: const EdgeInsets.only(right: 10),
              //   child: TextButton(
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => SeeAllView(
              //                       title: title,
              //                       packs: packs,
              //                     )));
              //       },
              //       child: const Text(
              //         "Alle Packs",
              //         style: TextStyle(
              //             fontWeight: FontWeight.w500, fontSize: 15.0),
              //       )),
              // ),
            ],
          ),
          CarouselSlider(
            options: standardOptions(height: 270),
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
              Container(),
            ],
          ),
          CarouselSlider(
            options: standardOptions(height: isReading ? 265 : 265),
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
}
