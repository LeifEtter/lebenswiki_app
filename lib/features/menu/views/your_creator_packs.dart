import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/packs/helper/get_packs.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_information.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/repository/colors.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

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
  final PackApi packApi = PackApi();
  int chosenTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.chosenTab;
    chosenTab = widget.chosenTab;
  }

  void _home() => Navigator.of(context)
      .push(MaterialPageRoute(builder: ((context) => const NavBarWrapper())));

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
                      GetPacks(
                        reload: reload,
                        cardType: CardType.yourPacks,
                      ),
                      const SizedBox(height: 30),
                      _erstelleLernpack(),
                    ],
                  ),
                  Column(
                    children: [
                      GetPacks(
                        reload: reload,
                        cardType: CardType.packDrafts,
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
              _routeCreatePack();
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

  void _routeCreatePack() {
    Pack pack = Pack.initial();
    packApi.createPack(pack: pack).then((ResultModel result) {
      if (result.type == ResultType.success) {
        pack.id = result.responseItem;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackCreatorInformation(pack: pack),
          ),
        );
      }
    });
  }
}
