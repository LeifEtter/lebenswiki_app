import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

Widget buildTabBar(List categories, Function chooseCallback) {
  return SizedBox(
    height: 55,
    child: TabBar(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: LebenswikiColors.labelColor),
      labelColor: LebenswikiColors.categoryLabelColorSelected,
      unselectedLabelColor: LebenswikiColors.categoryLabelColorUnselected,
      isScrollable: true,
      onTap: (value) {
        chooseCallback(value);
      },
      tabs: generateTabs(categories),
    ),
  );
}

List<Widget> generateTabs(categories) {
  List<Widget> categoryTabs = [];
  Tab newCategory = Tab(
    child: Text(
      "Neu",
      style: LebenswikiTextStyles.categoryBar.categoryButtonInactive,
    ),
  );
  categoryTabs.add(newCategory);
  for (var category in categories) {
    Widget tab = Tab(
      child: Text(category["categoryName"],
          style: LebenswikiTextStyles.categoryBar.categoryButtonInactive),
    );
    categoryTabs.add(tab);
  }
  return categoryTabs;
}
