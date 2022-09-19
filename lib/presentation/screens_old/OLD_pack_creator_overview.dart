/*import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/presentation/widgets/styling_edit.dart';
import 'package:lebenswiki_app/presentation/widgets/pack_creator_page.dart';
import 'package:lebenswiki_app/presentation/widgets/pack_editor_components.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/presentation/screens/pack_viewer.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:lebenswiki_app/features/routing/routes.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

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
            previousCallback: () async {
              _saveCallback();
              await packApi.updatePack(id: pack.id!, pack: pack);
              Navigator.of(context).pop();
            },
            nextCallback: () async {
              _saveCallback();
              await packApi.updatePack(id: pack.id!, pack: pack);
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
                        callback: () {
                          _saveCallback();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PackViewer(
                                  pack: pack,
                                  isPreview: true,
                                ),
                              ));
                        },
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
                saveSelf: _saveSelectedPageCallback,
                selfIndex: index,
                deleteSelf: _deletePage,
              ),
            ),
          )),
    );
  }

  void _saveCallback() {
    for (PackPage page in pack.pages) {
      for (PackPageItem item in page.items) {
        item.headContent.value = item.headContent.controller!.text;
        for (PackPageItemInput item in item.bodyContent) {
          item.value = item.controller!.text;
        }
      }
    }
  }

  void _saveSelectedPageCallback(toSaveIndex) {
    PackPage pageToSave = pack.pages[toSaveIndex];
    for (PackPageItem item in pageToSave.items) {
      item.headContent.value = item.headContent.controller!.text;
      for (PackPageItemInput item in item.bodyContent) {
        item.value = item.controller!.text;
      }
    }
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
              _saveCallback();
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
        boxShadow: [LebenswikiShadows.fancyShadow],
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
}*/
