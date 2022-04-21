import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/testing/border.dart';

class CreatePack extends StatefulWidget {
  const CreatePack({Key? key}) : super(key: key);

  @override
  _CreatePackState createState() => _CreatePackState();
}

class _CreatePackState extends State<CreatePack> {
  final PageController _pageController = PageController();
  final List _pages = [];
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    _pages.add(_pageScaffold(_settingUpPage()));
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
            child: TopNav(pageName: "Dein Pack", backName: "Pack Liste"),
          ),
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
                child: _buildPageOverview(),
                height: 80,
              ),
            ],
          ),
          SizedBox(
            height: 500,
            child: PageView(
              controller: _pageController,
              children: List.generate(_pages.length, (index) {
                return _pages[index];
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageOverview() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _pages.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPage = index;
                index == _pages.length
                    ? {_pages.add(""), _selectedPage = index}
                    : _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      );
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 50,
              decoration: BoxDecoration(
                color:
                    index == _selectedPage ? Colors.blueAccent : Colors.white,
                /*gradient: index == _selectedPage
                    ? LebenswikiColors.blueGradient
                    : null,*/
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  LebenswikiShadows().fancyShadow,
                ],
              ),
              child: Center(
                child: index != _pages.length
                    ? Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const Icon(Icons.add, size: 20.0),
              ),
            ),
          ),
        );
      },
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

  Widget _generatePage() {
    return ListView(
      children: [],
    );
  }

  Widget createInputField(keyName) {
    return TextFormField(
      key: keyName,
      onSaved: (value) => print(value),
    );
  }
}
