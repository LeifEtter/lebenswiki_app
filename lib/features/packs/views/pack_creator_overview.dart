import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/features/styling/styling_edit.dart';
import 'package:lebenswiki_app/features/packs/components/pack_creator_page.dart';
import 'package:lebenswiki_app/models/pack_content_models.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_settings.dart';
import 'package:lebenswiki_app/features/packs/views/pack_viewer.dart';
import 'package:lebenswiki_app/features/menu/views/your_creator_packs.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/styling/shadows.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

class Editor extends StatefulWidget {
  final Pack pack;

  const Editor({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final PackApi packApi = PackApi();
  final PageController _pageController = PageController();
  final EditDecoration decoration = EditDecoration();
  final List saveControllers = [];
  late Pack pack;
  int _selectedPage = 0;

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
                      /*Row(
                        children: [
                          _saveButton(),
                          Text(
                            "Speichern",
                            style: _style2(),
                          )
                        ],
                      ),*/
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PackViewer(pack: pack),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [LebenswikiShadows().fancyShadow],
                          ),
                          child: Row(
                            children: [
                              Text("Vorschau", style: _style2()),
                              const Icon(Icons.preview, size: 30),
                            ],
                          ),
                        ),
                      )
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
                  controller: _pageController,
                  children: List.generate(widget.pack.pages.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: decoration.page(
                        child: PageOverview(
                          page: widget.pack.pages[index],
                          reload: reload,
                          saveCallback: _saveCallback,
                          selfIndex: index,
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
                            .add(CreatorPage(pageNumber: index + 1, items: [])),
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

  void reload() {
    setState(() {});
  }

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

  TextStyle _style2() {
    return const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(Icons.save, size: 30),
      onPressed: () {
        packApi.updatePack(pack: pack, id: pack.id);
        setState(() {});
      },
    );
  }

  void _goToYourPacks() {
    packApi.updatePack(pack: pack, id: pack.id);
    Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => const YourCreatorPacks())));
  }

  void _backToSettings() {
    Navigator.of(context).push(_backRoute());
  }

  Route _backRoute() {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            EditorSettings(pack: pack)),
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
