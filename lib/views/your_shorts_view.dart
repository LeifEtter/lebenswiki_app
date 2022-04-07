import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

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
  void dispose() {
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var deviceWidth = queryData.size.width;
    var deviceHeight = queryData.size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNav(pageName: "Deine Shorts", backName: "Menu"),
            const SizedBox(height: 0),
            Container(
              height: 50,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Text("Veröffentlichte",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                        )),
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
            SizedBox(height: 20.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      GetContent(
                        reload: reload,
                        contentType: ContentType.yourShorts,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GetContent(
                        reload: reload,
                        contentType: ContentType.drafts,
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
