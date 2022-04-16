import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_authentication.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/api/api_universal.dart';
import 'package:lebenswiki_app/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/testing/border.dart';
import 'package:lebenswiki_app/views/your_shorts_view.dart';

class CreateShort extends StatefulWidget {
  const CreateShort({
    Key? key,
  }) : super(key: key);

  @override
  _CreateShortState createState() => _CreateShortState();
}

class _CreateShortState extends State<CreateShort> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  int _currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    getCategories();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getCategories(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              return DefaultTabController(
                length: snapshot.data.length,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 20.0),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Titel",
                                    border: InputBorder.none,
                                  ),
                                  controller: _titleController,
                                ),
                              ),
                              const CloseButton(),
                            ],
                          ),
                          _buildTabBar(snapshot.data),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: FutureBuilder(
                                    future: getUserData(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return Loading();
                                      } else {
                                        return _buildIndicator(snapshot.data);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: TextField(
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      hintText: "Was geht dir durch den Kopf?",
                                      border: InputBorder.none,
                                    ),
                                    controller: _contentController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned.fill(
                        right: 15.0,
                        bottom: 20.0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 150,
                            child: Row(
                              children: [
                                LebenswikiBlueButtonInverted(
                                    text: "Entwürfe",
                                    callback: navigateToDrafts),
                                LebenswikiBlueButton(
                                  text: "Post",
                                  callback: createCallback,
                                  categories: snapshot.data,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void navigateToDrafts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YourShorts(
          chosenTab: 1,
        ),
      ),
    );
  }

  Widget _buildIndicator(profileData) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(profileData["profileImage"]),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  void createCallback(categories) {
    createShort(
      _titleController.text.toString(),
      [categories[_currentCategory]["id"]],
      _contentController.text.toString(),
    ).then((value) => print(value));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YourShorts(
          chosenTab: 1,
        ),
      ),
    );
  }

  Widget _buildTabBar(List categories) {
    return Container(
      height: 55,
      child: TabBar(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: LebenswikiColors.labelColor),
        labelColor: LebenswikiColors.categoryLabelColorSelected,
        unselectedLabelColor: LebenswikiColors.categoryLabelColorUnselected,
        isScrollable: true,
        onTap: (value) {
          setState(() {
            _currentCategory = value;
          });
        },
        tabs: generateTabs(categories),
      ),
    );
  }

  List<Widget> generateTabs(categories) {
    List<Widget> categoryTabs = [];
    for (var category in categories) {
      Widget tab = Tab(
        child: Text(category["categoryName"],
            style: LebenswikiTextStyles.categoryBar.categoryButtonInactive),
      );
      categoryTabs.add(tab);
    }
    return categoryTabs;
  }
}
