import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/common/components/styling_edit.dart';
import 'package:lebenswiki_app/features/packs/components/pack_creator_page.dart';
import 'package:lebenswiki_app/features/packs/components/pack_editor_components.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_information.dart';
import 'package:lebenswiki_app/features/packs/views/pack_viewer.dart';
import 'package:lebenswiki_app/features/menu/views/your_creator_packs.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

//TODO seperate routing logic
class PackCreatorOverview extends StatefulWidget {
  final Pack pack;

  const PackCreatorOverview({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  _PackCreatorOverviewState createState() => _PackCreatorOverviewState();
}

class _PackCreatorOverviewState extends State<PackCreatorOverview> {
  final PackApi packApi = PackApi();
  final PageController _pageController = PageController();
  late Pack pack;
  int _selectedPage = 0;
  List<Widget> pageViewPages = [];

  @override
  void initState() {
    pack = widget.pack;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TopNavCustom(
            pageName: "Seiten Übersicht",
            backName: "Informationen",
            nextName: "Speichern",
            previousCallback: _backToSettings,
            nextCallback: _goToYourPacks,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PackEditorComponents.iconButton(
                        callback: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackViewer(pack: pack),
                            )),
                        label: "Vorschau",
                        icon: Icons.preview,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: _buildPageBar(),
                      height: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ExpandablePageView(
                  onPageChanged: (value) {
                    _selectedPage = value;
                    setState(() {});
                  },
                  controller: _pageController,
                  children: List.generate(widget.pack.pages.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: EditDecoration.page(
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 400),
                          child: PageOverview(
                            page: widget.pack.pages[index],
                            reload: reload,
                            saveCallback: _saveCallback,
                            selfIndex: index,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveCallback({page, index}) {
    //TODO Implement Saving
  }

  Widget _buildPageBar() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: pack.pages.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPage = index;
                index == pack.pages.length
                    ? {
                        pack.pages
                            .add(PackPage(pageNumber: index + 1, items: [])),
                        setState(() {
                          _selectedPage = index;
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                        })
                      }
                    : _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      );
              });
            },
            child: _selectablePageImage(index),
          ),
        );
      },
    );
  }

  void reload() => setState(() {});

  Widget _selectablePageImage(index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50,
      decoration: BoxDecoration(
        color: index == _selectedPage ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          LebenswikiShadows().fancyShadow,
        ],
      ),
      child: Center(
        child: index != pack.pages.length
            ? Text(
                (index + 1).toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            : const Icon(Icons.add, size: 20.0),
      ),
    );
  }

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(Icons.save, size: 30),
      onPressed: () {
        packApi.updatePack(pack: pack, id: pack.id!);
        setState(() {});
      },
    );
  }

  void _goToYourPacks() {
    packApi.updatePack(pack: pack, id: pack.id!);
    Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => const YourCreatorPacks())));
  }

  void _backToSettings() {
    Navigator.of(context).push(_backRoute());
  }

  Route _backRoute() {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            PackCreatorInformation(pack: pack)),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}
