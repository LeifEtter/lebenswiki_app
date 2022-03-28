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

class _YourShortsState extends State<YourShorts> {
  int chosenTab = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var deviceWidth = queryData.size.width;
    var deviceHeight = queryData.size.height;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: chosenTab,
          length: 2,
          child: Column(
            children: [
              const TopNav(pageName: "Deine Shorts", backName: "Menu"),
              const SizedBox(height: 0),
              Container(
                height: 50,
                child: const TabBar(
                  tabs: [
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
      ),
    );
  }

  void reload(newChosenTab) {
    chosenTab = newChosenTab;
    setState(() {});
  }
}
