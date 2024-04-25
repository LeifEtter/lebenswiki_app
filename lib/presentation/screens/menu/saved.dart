import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:lebenswiki_app/presentation/providers/category_provider.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:lebenswiki_app/data/short_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
// import 'package:lebenswiki_app/application/data/pack_list_helper.dart';
// import 'package:lebenswiki_app/application/data/short_list_helper.dart';
// import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
// import 'package:lebenswiki_app/application/data/pack_short_service.dart';

class PacksAndShorts {
  final List<Pack> packs;
  final List<Short> shorts;

  const PacksAndShorts({required this.packs, required this.shorts});
}

class SavedView extends ConsumerStatefulWidget {
  const SavedView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedViewState();
}

class _SavedViewState extends ConsumerState<SavedView> {
  late List<Category> categories;

  @override
  void initState() {
    categories = ref.read(categoryProvider).categories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TopNavIOS(title: "Gespeichert"),
              SizedBox(
                height: 50,
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text("Packs",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    Tab(
                      child: Text("Shorts",
                          style: Theme.of(context).textTheme.labelLarge),
                    )
                  ],
                  isScrollable: true,
                  indicatorWeight: 4.0,
                  indicatorColor: CustomColors.blue,
                  labelColor: CustomColors.offBlack,
                  unselectedLabelColor: CustomColors.darkGrey,
                ),
              ),
              FutureBuilder(
                future: getPacksAndShorts(),
                builder: (BuildContext context,
                    AsyncSnapshot<Either<CustomError, PacksAndShorts>>
                        snapshot) {
                  if (LoadingHelper.isLoading(snapshot)) {
                    return LoadingHelper.loadingIndicator();
                  }
                  if (snapshot.data == null || snapshot.data!.isLeft) {
                    return const Text("Something went wrong");
                  }
                  PacksAndShorts packsAndShorts = snapshot.data!.right;
                  return Expanded(
                      child: TabBarView(children: [
                    packsAndShorts.packs.isEmpty
                        ? buildEmptyText("packs")
                        : ListView.builder(
                            padding: const EdgeInsets.all(20.0),
                            shrinkWrap: true,
                            itemCount: packsAndShorts.packs.length,
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: SizedBox(
                                height: 280,
                                child: PackCard(
                                  pack: packsAndShorts.packs[index],
                                  heroParent: "saved-packs",
                                ),
                              ),
                            ),
                          ),
                    packsAndShorts.shorts.isEmpty
                        ? buildEmptyText("shorts")
                        : ListView.builder(
                            padding: const EdgeInsets.all(20.0),
                            shrinkWrap: true,
                            itemCount: packsAndShorts.shorts.length,
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ShortCard(
                                short: packsAndShorts.shorts[index],
                              ),
                            ),
                          )
                  ]));
                },
              ),
            ],
            // ),
          ),
        ),
      ),
    );
  }

  Future<Either<CustomError, PacksAndShorts>> getPacksAndShorts() async {
    Either<CustomError, List<Pack>> packs =
        await PackApi().getBookmarkedPacks();
    Either<CustomError, List<Short>> shorts =
        await ShortApi().getBookmarkedShorts();

    if (packs.isLeft || shorts.isLeft) {
      return const Left(CustomError(
          error:
              "Irgendwas ist bei der Abfrage deiner gespeicherten Packs und Shorts schiefgelaufen"));
    } else {
      return Right(PacksAndShorts(packs: packs.right, shorts: shorts.right));
    }
  }

  Widget buildEmptyText(String text) => Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      style: const TextStyle(color: Colors.black),
                      text:
                          "Du hast noch keine $text gespeichert. Klick auf dieses Icon "),
                  const WidgetSpan(
                    child: Icon(
                      Icons.bookmark_add_outlined,
                      color: Colors.black87,
                      size: 20.0,
                    ),
                  ),
                  TextSpan(
                      style: const TextStyle(color: Colors.black),
                      text: " um $text zu speichern.")
                ],
              ),
            ),
          ],
        ),
      );
}
