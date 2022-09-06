import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/features/a_new_common/extensions.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  Widget build(BuildContext context) {
    List<ContentCategory> categories = ref.read(categoryProvider).categories;
    return ListView(
      children: [
        Text(
          "Explore",
          style: Theme.of(context).textTheme.headlineLarge,
        ).addPadding(),
        DefaultTabController(
          length: categories.length,
          child: TabBar(
            padding: const EdgeInsets.only(left: 50),
            isScrollable: true,
            indicatorWeight: 4.0,
            indicatorColor: CustomColors.blue,
            labelColor: CustomColors.offBlack,
            unselectedLabelColor: CustomColors.darkGrey,
            tabs: generateTabs(categories),
          ),
        ),
      ],
    );
  }

  List<Widget> generateTabs(List<ContentCategory> categories) {
    List<Widget> categoryTabs = [];
    for (var category in categories) {
      Widget tab = Tab(
        child: Text(
          category.categoryName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      categoryTabs.add(tab);
    }
    return categoryTabs;
  }
  //Widget _tab("Name") =>
}
