import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/misc_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/features/styling/colors.dart';
import 'package:lebenswiki_app/features/common/components/loading.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/features/menu/views/your_shorts_view.dart';

class CreateShort extends StatefulWidget {
  const CreateShort({
    Key? key,
  }) : super(key: key);

  @override
  _CreateShortState createState() => _CreateShortState();
}

class _CreateShortState extends State<CreateShort> {
  final UserApi userApi = UserApi();
  final MiscApi miscApi = MiscApi();
  final ShortApi shortApi = ShortApi();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  int _currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    miscApi.getCategories();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: miscApi.getCategories(),
          builder: (context, AsyncSnapshot<ResultModel> snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            } else {
              List<ContentCategory> categories =
                  List.from(snapshot.data!.responseList);
              return DefaultTabController(
                length: categories.length,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              CloseButton(),
                            ],
                          ),
                          _buildTabBar(categories),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "Titel",
                                border: InputBorder.none,
                              ),
                              controller: _titleController,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: FutureBuilder(
                                    future: userApi.getUserData(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Loading();
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
                          child: SizedBox(
                            width: 150,
                            child: Row(children: [
                              lebenswikiBlueButtonInverted(
                                  text: "Entwürfe", callback: navigateToDrafts),
                              lebenswikiBlueButtonNormal(
                                text: "Post",
                                callback: createCallback,
                                categories: categories,
                              ),
                            ]),
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

  //TODO Fix Short creation
  void createCallback(categories) {
    /*
    shortApi
        .createShort(
          categories: [categories][_currentCategory]["id"],
          content: _contentController.text.toString(),
          title: _titleController.text.toString(),
        )
        .then(
          (_) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const YourShorts(
                chosenTab: 1,
              ),
            ),
          ),
        );*/
  }

  Widget _buildTabBar(List categories) {
    return SizedBox(
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
