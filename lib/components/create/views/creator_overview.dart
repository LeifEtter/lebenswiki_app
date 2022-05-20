import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/create/data/models.dart';
import 'package:lebenswiki_app/components/create/views/page_overview.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/testing/border.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

class CreatorOverview extends StatefulWidget {
  final CreatorPack pack;

  const CreatorOverview({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  _CreatorOverviewState createState() => _CreatorOverviewState();
}

class _CreatorOverviewState extends State<CreatorOverview> {
  final PageController _pageController = PageController();
  late CreatorPack pack;
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
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                LebenswikiShadows().fancyShadow,
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: TopNav(pageName: "Dein Pack", backName: "Pack Liste"),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Text(
                  "Seiten",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: _buildPageBar(),
                      height: 80,
                    ),
                  ],
                ),
                ExpandablePageView(
                  controller: _pageController,
                  children: List.generate(widget.pack.pages.length, (index) {
                    return PageOverview(
                      page: CreatorPage.fromJson(widget.pack.pages[index]),
                      reload: reload,
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
                        pack.pages.add(
                            CreatorPage(pageNumber: index + 1, items: [])
                                .toJson()),
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

  Widget _pageScaffold(child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 2.0,
        child: child,
      ),
    );
  }

  Widget _settingUpPage() {
    return Column(
      children: [
        const Text("Beschreibe Dein Pack"),
        const Text("Gib deinem Pack ein interessanten Titel"),
        TextFormField(),
      ],
    );
  }
}
