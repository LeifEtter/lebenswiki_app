import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/providers/new_providers.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/application/pack_list_helper.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/application/short_list_helper.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/presentation/widgets/common/extensions.dart';

class ExploreView extends StatefulWidget {
  final PackListHelper packHelper;
  final ShortListHelper shortHelper;
  final List<ContentCategory> categories;
  final bool isSearching;

  const ExploreView({
    required this.categories,
    required this.packHelper,
    required this.shortHelper,
    required this.isSearching,
    Key? key,
  }) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  int _selectedCategory = 0;
  late List<bool> selectedCategories;

  @override
  void initState() {
    selectedCategories =
        widget.categories.map((ContentCategory cat) => false).toList();
    selectedCategories[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSearching) {
      return ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Wrap(
                spacing: 5.0,
                runSpacing: 10.0,
                children: List.generate(widget.categories.length, (int index) {
                  return _buildCatButton(
                    isSelected: selectedCategories[index],
                    name: widget.categories[index].categoryName,
                    onSelect: () => setState(() {
                      selectedCategories[index] = !selectedCategories[index];
                    }),
                  );
                })),
          ),
          Consumer(builder: (context, ref, child) {
            String query = ref.watch(queryProvider).query;
            List<Pack> catPacks = [];
            if (selectedCategories[0]) {
              catPacks.addAll(widget.packHelper.categorizedPacks[0]!);
            } else {
              for (int i = 0; i < selectedCategories.length; i++) {
                if (selectedCategories[i] == true) {
                  catPacks.addAll(widget.packHelper.categorizedPacks[i]!);
                }
              }
            }

            List<Pack> queriedPacks = catPacks
                .where((Pack pack) =>
                    pack.title.toLowerCase().contains(query.toLowerCase()) ||
                    pack.description
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();
            // Sort throguh categorized packs
            return Column(
              children: queriedPacks
                  .map((Pack pack) => SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: PackCard(
                            progressValue: 0,
                            isStarted: false,
                            pack: pack,
                            heroParent: "queried",
                          ),
                        ),
                      ))
                  .toList(),
            );
          }),
        ],
      );
    } else {
      return ListView(
        children: [
          Text(
            "Explore",
            style: Theme.of(context).textTheme.headlineLarge,
          ).addPadding(),
          DefaultTabController(
            length: widget.categories.length,
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
                  tabs: widget.categories
                      .map((ContentCategory cat) => Tab(
                          child: Text(cat.categoryName,
                              style: Theme.of(context).textTheme.labelLarge)))
                      .toList(),
                  onTap: (int newCategory) =>
                      setState(() => _selectedCategory = newCategory),
                ),
                const SizedBox(height: 20),
                CarouselSlider(
                  items: List<Widget>.from(
                    widget.packHelper.categorizedPacks[_selectedCategory]!
                        .map((Pack pack) => Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: PackCard(
                                heroParent: "explore-categories",
                                progressValue: 0,
                                isStarted: false,
                                pack: pack,
                              ),
                            )),
                  ),
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Shorts",
            style: Theme.of(context).textTheme.headlineLarge,
          ).addPadding(),
          CarouselSlider(
            items: List<Widget>.from(widget.shortHelper.shorts.map(
              (Short short) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ShortCard(
                  short: short,
                  inSlider: true,
                ),
              ),
            )),
            options: CarouselOptions(
              height: 230,
              enableInfiniteScroll: false,
            ),
          ),
        ],
      );
    }
  }

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
