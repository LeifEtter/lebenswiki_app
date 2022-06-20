import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/misc_api.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/components/actions/modal_sheet.dart';
import 'package:lebenswiki_app/helper/actions/reaction_functions.dart';
import 'package:lebenswiki_app/components/actions/report_dialog.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/filtering/tab_bar.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/helper/is_loading.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/report_model.dart';

class ShortView extends StatefulWidget {
  const ShortView({
    Key? key,
  }) : super(key: key);

  @override
  _ShortViewState createState() => _ShortViewState();
}

class _ShortViewState extends State<ShortView> {
  ShortApi shortApi = ShortApi();
  MiscApi miscApi = MiscApi();
  UserApi userApi = UserApi();
  int _currentCategory = 0;
  String? chosenReason = "Illegal unter der NetzDG";
  late List<ContentCategory> categories;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: miscApi.getCategories(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (isLoading(snapshot)) {
          return const Loading();
        }
        categories = List<ContentCategory>.from(snapshot.data!.responseList);
        return DefaultTabController(
          length: categories.length,
          child: Column(
            children: [
              buildTabBar(
                categories: categories,
                callback: _onTabbarChoose,
              ),
              GetContent(
                category: categories[_currentCategory],
                reload: reload,
                cardType: CardType.shortsByCategory,
                menuCallback: _menuCallback,
              )
            ],
          ),
        );
      },
    );
  }

  void reload() {
    setState(() {});
  }

  void _onTabbarChoose(newCategory) {
    setState(() {
      _currentCategory = newCategory;
    });
  }

  void _menuCallback({
    required var contentData,
    required MenuType menuType,
  }) {
    switch (menuType) {
      case MenuType.moreShort:
        showMoreMenu(contentData: contentData);
        break;
      case MenuType.reactShort:
        showReactionMenu(contentData: contentData, isComment: false);
        break;
      case MenuType.reactShortComment:
        showReactionMenu(contentData: contentData, isComment: true);
        break;
      default:
        print("Unknown menuType");
    }
  }

  void showMoreMenu({required var contentData}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 20.0, left: 30.0),
          child: Column(
            children: [
              buildMenuItem(
                Icons.flag,
                "Melden",
                "Diesen Short melden",
                () {
                  _reportDialog(contentData: contentData);
                },
              ),
              buildMenuItem(
                Icons.comment_outlined,
                "Kommentieren",
                "Schreibe einen Kommentar",
                () {},
              ),
              buildMenuItem(
                Icons.bookmark_outline,
                "Speichern",
                "Zu gespeicherten Shorts hinzufügen",
                () {},
              ),
            ],
          ),
        );
      },
      isDismissible: true,
    );
  }

  void showReactionMenu({
    required var contentData,
    required bool isComment,
  }) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              const Text(
                "Wähle deine Reaktion",
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(height: 20.0),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: allReactions.length,
                itemBuilder: (BuildContext context, index) {
                  var currentReaction = allReactions[index].toUpperCase();
                  var currentReactionLower = allReactions[index].toLowerCase();
                  return GestureDetector(
                    onTap: () async {
                      /*isComment ? {
                        
                      } : {

                      };
                      isComment
                          ? await addCommentReaction(
                              contentData.id, currentReaction)
                          : await addReaction(contentData.id, currentReaction);
                      Navigator.pop(context);
                      reload();*/
                    },
                    child: Image.asset(
                      "assets/emojis/$currentReactionLower.png",
                      width: 20,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      isDismissible: true,
    );
  }

  Future<void> _reportDialog({required var contentData}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.35,
            top: MediaQuery.of(context).size.height * 0.21,
          ),
          child: ReportDialog(
            contentData: contentData,
            reportCallback: _reportCallback,
            chosenReason: chosenReason,
          ),
        );
      },
    );
  }

  void _reportCallback({
    required String reason,
    required bool blockUser,
    required var contentData,
  }) {
    blockUser
        ? userApi.blockUser(id: contentData.creator.id, reason: reason)
        : null;
    shortApi
        .reportShort(
            report: Report(
                reason: reason,
                reportedContentId: contentData.id,
                creationDate: DateTime.now()))
        .whenComplete(() {
      reload();
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
