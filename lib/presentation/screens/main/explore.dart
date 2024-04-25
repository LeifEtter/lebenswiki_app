import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:lebenswiki_app/presentation/providers/category_provider.dart';
import 'package:lebenswiki_app/presentation/providers/reload_provider.dart';
import 'package:lebenswiki_app/presentation/providers/search_providers.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/presentation/widgets/common/extensions.dart';

class ExploreView extends ConsumerStatefulWidget {
  final List<Category> categoriesWithPacks;
  final bool isSearching;
  final String? query;

  const ExploreView({
    required this.categoriesWithPacks,
    required this.isSearching,
    this.query,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  late List<Category> categoriesWithPacks;
  late Category selectedCategory;
  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    categoriesWithPacks = widget.categoriesWithPacks;
    selectedCategory = categoriesWithPacks[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSearching) {
      return SearchScreen(
        categoriesWithPacks: categoriesWithPacks,
        categories: ref.read(categoryProvider).categories,
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          ref.read(reloadProvider).reload();
        },
        child: ListView(
          children: [
            Text(
              "Erkunden",
              style: Theme.of(context).textTheme.headlineLarge,
            ).addPadding(),
            DefaultTabController(
              length: categoriesWithPacks.length,
              initialIndex: 0,
              child: Column(
                children: [
                  TabBar(
                    padding: const EdgeInsets.only(left: 50),
                    isScrollable: true,
                    indicatorWeight: 4.0,
                    indicatorColor: CustomColors.blue,
                    labelColor: CustomColors.offBlack,
                    unselectedLabelColor: CustomColors.darkGrey,
                    tabs: categoriesWithPacks
                        .map((Category cat) => Tab(
                            child: Text(cat.name,
                                style: Theme.of(context).textTheme.labelLarge)))
                        .toList(),
                    onTap: (int index) {
                      setState(
                        () => selectedCategory = categoriesWithPacks[index],
                      );
                      carouselController.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                  ),
                ],
              ),
            ),
            Text(
              "Packs",
              style: Theme.of(context).textTheme.headlineLarge,
            ).addPadding(),
            CarouselSlider(
              carouselController: carouselController,
              items: List<Widget>.from(
                selectedCategory.packs.map(
                  (Pack pack) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: PackCard(
                      heroParent: "explore-categories",
                      pack: pack,
                    ),
                  ),
                ),
              ),
              options: CarouselOptions(
                height: 260,
                enableInfiniteScroll: false,
              ),
            ),
            const SizedBox(height: 20),
            //TODO Implement Shorts here
            Text(
              "Shorts",
              style: Theme.of(context).textTheme.headlineLarge,
            ).addPadding(),
            CarouselSlider(
              items: List<Widget>.from(selectedCategory.shorts.map(
                (Short short) => Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ShortCard(
                    short: short,
                    inSlider: true,
                  ),
                ),
              )),
              options: CarouselOptions(
                height: 270,
                enableInfiniteScroll: false,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class SearchScreen extends StatefulWidget {
  final List<Category> categoriesWithPacks;
  final List<Category> categories;
  final String? query;

  const SearchScreen({
    Key? key,
    required this.categoriesWithPacks,
    required this.categories,
    this.query,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with RestorationMixin {
  late List<bool> selectedCategories;
  late List<Map<String, dynamic>> selectedCategoriesNew = [
    {
      "category": Category,
      "active": bool,
    },
  ];

  List<Pack> packsToShow = [];

  @override
  void initState() {
    selectedCategoriesNew = widget.categories
        .map<Map<String, dynamic>>((Category cat) => ({
              "category": cat,
              "active": cat.id == 0 ? true : false,
            }))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Wrap(
                spacing: 5.0,
                runSpacing: 10.0,
                children: List.generate(selectedCategoriesNew.length - 1,
                    (int index) {
                  Map<String, dynamic> currentButtonEntry =
                      selectedCategoriesNew[index];
                  Category currentCategory = currentButtonEntry["category"];
                  return _buildCatButton(
                    isSelected: currentButtonEntry["active"],
                    name: currentCategory.name,
                    onSelect: () => setState(() {
                      selectedCategoriesNew[index]["active"] =
                          !selectedCategoriesNew[index]["active"];
                    }),
                  );
                })),
          ),
          Consumer(builder: (context, ref, child) {
            String query = ref.watch(queryProvider).query;
            packsToShow = [];
            if (selectedCategoriesNew[0]["active"]) {
              packsToShow = widget.categoriesWithPacks[0].packs;
            } else {
              for (Map<String, dynamic> buttonEntry in selectedCategoriesNew) {
                if (buttonEntry["active"]) {
                  Category currentCat = buttonEntry["category"];
                  packsToShow.addAll(currentCat.packs);
                }
              }
            }
            packsToShow = packsToShow
                .where((Pack pack) =>
                    pack.title.toLowerCase().contains(query.toLowerCase()) ||
                    pack.description
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();

            // Sort through categorized packs
            return Column(
              children: packsToShow
                  .map((Pack pack) => SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: PackCard(
                            pack: pack,
                            heroParent: "queried",
                          ),
                        ),
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  @override
  String? get restorationId => "search_screen";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}

  Widget _buildCatButton({
    required bool isSelected,
    required String name,
    required Function onSelect,
  }) =>
      GestureDetector(
        onTap: () => onSelect(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? CustomColors.blue : Colors.white,
            border: Border.all(width: 2, color: CustomColors.blue),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            name,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );
}
