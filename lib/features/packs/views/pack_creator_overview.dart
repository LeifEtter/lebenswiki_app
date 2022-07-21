import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/common/components/styling_edit.dart';
import 'package:lebenswiki_app/features/packs/components/pack_creator_page.dart';
import 'package:lebenswiki_app/features/packs/components/pack_editor_components.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_viewer.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:lebenswiki_app/features/routing/routes.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

//TODO save when any navigation button is pressed
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
    _initalizePageViewPages();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TopNavCustom(
            pageName: "Seiten Übersicht",
            backName: "Informationen",
            nextName: "Speichern",
            previousCallback: () => Navigator.of(context).pop(),
            nextCallback: () {
              //TODO Save Pack with API
              Navigator.of(context).push(LebenswikiRoutes.goToYourPacks());
            },
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
                const SizedBox(height: 30),
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
                  children: pageViewPages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initalizePageViewPages() {
    pageViewPages = List.generate(
      pack.pages.length,
      ((index) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: EditDecoration.page(
              child: PageOverview(
                page: pack.pages[index],
                saveCallback: _saveCallback,
                selfIndex: index,
                deleteSelf: _deletePage,
              ),
            ),
          )),
    );
  }

  void _saveCallback({page, index}) {
    //TODO Implement Saving
  }

  void _deletePage(int index) {
    pack.pages.removeAt(index);
    pageViewPages.removeAt(index);
    _pageController.animateToPage(
      index - 1,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    setState(() {});
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

  Widget _selectablePageImage(index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50,
      decoration: BoxDecoration(
        color: index == _selectedPage ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [LebenswikiShadows().fancyShadow],
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
}
