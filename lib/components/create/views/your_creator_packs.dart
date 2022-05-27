import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/components/create/api/api_creator_pack.dart';
import 'package:lebenswiki_app/components/create/data/initial_data.dart';
import 'package:lebenswiki_app/components/create/data/models.dart';
import 'package:lebenswiki_app/components/create/views/editor.dart';
import 'package:lebenswiki_app/components/create/views/editor_settings.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/main.dart';

class YourCreatorPacks extends StatefulWidget {
  final int chosenTab;
  const YourCreatorPacks({
    Key? key,
    this.chosenTab = 0,
  }) : super(key: key);

  @override
  _YourCreatorPacksState createState() => _YourCreatorPacksState();
}

class _YourCreatorPacksState extends State<YourCreatorPacks>
    with TickerProviderStateMixin {
  int chosenTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.chosenTab;
    chosenTab = widget.chosenTab;
  }

  void _home() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => NavBarWrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNavYour(pageName: "Deine Lernpacks", backName: "Menu"),
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
                      GetContent(
                        reload: reload,
                        contentType: ContentType.yourCreatorPacksPublished,
                        menuCallback: (MenuType menuType, Map packData) {},
                      ),
                      const SizedBox(height: 30),
                      _erstelleLernpack(),
                    ],
                  ),
                  Column(
                    children: [
                      GetContent(
                        reload: reload,
                        contentType: ContentType.yourCreatorPacks,
                        menuCallback: (MenuType menuType, Map packData) {},
                      ),
                      const SizedBox(height: 30),
                      _erstelleLernpack(),
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

  Widget _erstelleLernpack() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: LebenswikiColors.blue,
              boxShadow: [LebenswikiShadows().fancyShadow]),
          child: TextButton(
            onPressed: () {
              _routeCreator();
            },
            child: const Text(
              "Erstelle dein eigenes Lernpack",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void toggleTab() {
    chosenTab == 0 ? chosenTab = 1 : chosenTab = 0;
    setState(() {});
  }

  void reload() {
    setState(() {});
  }

  void _routeCreator() {
    //Create Initial Pack
    createCreatorPack(pack: initialPack()).then((id) {
      CreatorPack packGive = initialPack();
      packGive.id = id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => EditorSettings(
                pack: packGive,
              )),
        ),
      );
    });
  }
}
