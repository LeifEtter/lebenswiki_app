import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/api/api_universal.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/input/input_styling.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/data/enums.dart';

class ContentFeed extends StatefulWidget {
  final bool isSearching;
  final ContentType contentType;

  const ContentFeed({
    Key? key,
    required this.isSearching,
    required this.contentType,
  }) : super(key: key);

  @override
  _ContentFeedState createState() => _ContentFeedState();
}

class _ContentFeedState extends State<ContentFeed> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _key = GlobalKey();
  int _currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: snapshot.data.length + 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    child: widget.isSearching
                        ? _buildSearchBar()
                        : _buildTabBar(snapshot.data),
                    duration: const Duration(milliseconds: 200),
                  ),
                  GetContent(
                    category: _currentCategory == 0
                        ? 99
                        : snapshot.data[_currentCategory - 1]["id"],
                    contentType: widget.contentType,
                    reload: reload,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  void reload() {
    setState(() {});
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
      child: AuthInputStyling(
        fillColor: const Color.fromRGBO(245, 245, 247, 1),
        child: TextFormField(
            controller: _searchController,
            key: _key,
            decoration: const InputDecoration(
              hintText: "Suche nach Artikeln oder Keywörtern...",
              icon: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 5.0),
                child: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Color.fromRGBO(115, 115, 115, 1),
                ),
              ),
              border: InputBorder.none,
            )),
      ),
    );
  }

  Widget _buildTabBar(List categories) {
    return Container(
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
          setState(() {
            _currentCategory = value;
          });
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
}
