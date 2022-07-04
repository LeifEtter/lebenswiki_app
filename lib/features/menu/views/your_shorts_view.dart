import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/shorts/helper/get_shorts.dart';
import 'package:lebenswiki_app/models/enums.dart';

class YourShorts extends StatefulWidget {
  final int chosenTab;
  const YourShorts({
    Key? key,
    this.chosenTab = 0,
  }) : super(key: key);

  @override
  _YourShortsState createState() => _YourShortsState();
}

class _YourShortsState extends State<YourShorts> with TickerProviderStateMixin {
  int chosenTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.chosenTab;
    chosenTab = widget.chosenTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNav(pageName: "Deine Shorts", backName: "Menu"),
            const SizedBox(height: 0),
            SizedBox(
              height: 50,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Text(
                      "Veröffentlichte",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Entwürfe",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      GetShorts(
                        reload: reload,
                        cardType: CardType.yourShorts,
                        menuCallback: () {},
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GetShorts(
                        reload: reload,
                        cardType: CardType.shortDrafts,
                        menuCallback: () {},
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleTab() {
    chosenTab == 0 ? chosenTab = 1 : chosenTab = 0;
    setState(() {});
  }

  void reload(newChosenTab) {
    _tabController.index = newChosenTab;
    setState(() {});
  }
}
