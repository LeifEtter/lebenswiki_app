import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/pack_card.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/packs/helper/pack_list_helper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/features/a_new_common/extensions.dart';

class ExploreView extends ConsumerStatefulWidget {
  final PackListHelper packHelper;
  final ShortListHelper shortHelper;
  final List<ContentCategory> categories;

  const ExploreView({
    required this.categories,
    required this.packHelper,
    required this.shortHelper,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
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
                  widget.packHelper.categorizedPacks[_selectedCategory]!.map(
                      (Pack pack) => NewPackCard(
                          progressValue: 0, isStarted: false, pack: pack)),
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
          items: const [
            /*NewShortCard(
              short: ,
            ),*/
          ],
          options: CarouselOptions(),
        ),
      ],
    );
  }
}
