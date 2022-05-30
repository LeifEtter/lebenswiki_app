import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/api/api_universal.dart';
import 'package:lebenswiki_app/components/actions/modal_sheet.dart';
import 'package:lebenswiki_app/helper/actions/reaction_functions.dart';
import 'package:lebenswiki_app/components/actions/report_dialog.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/filtering/tab_bar.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/helper/future_handling.dart';

class PackViewNew extends StatefulWidget {
  const PackViewNew({
    Key? key,
  }) : super(key: key);

  @override
  _PackViewNewState createState() => _PackViewNewState();
}

class _PackViewNewState extends State<PackViewNew> {
  int _currentCategory = 0;
  String? chosenReason = "Illegal unter der NetzDG";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return isLoading(snapshot)
            ? const Loading()
            : DefaultTabController(
                length: snapshot.data.length + 1,
                child: Column(
                  children: [
                    buildTabBar(
                      snapshot.data,
                      _onTabbarChoose,
                    ),
                    GetContent(
                      reload: reload,
                      contentType: CardType.creatorPacks,
                      menuCallback: _menuCallback,
                    ),
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

  void _menuCallback(MenuType menuType, Map packData) {
    switch (menuType) {
      case MenuType.moreShort:
        showMoreMenu(packData);
        break;
      case MenuType.reactShort:
        showReactionMenu(packData);
        break;
      default:
      //print("Unknown menuType");
    }
  }

  void showMoreMenu(Map packData) {
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
                "Dieses Pack melden",
                () {
                  _reportDialog(packData);
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
                "Zu gespeicherten Packs hinzufügen",
                () {},
              ),
            ],
          ),
        );
      },
      isDismissible: true,
    );
  }

  void showReactionMenu(Map packData) {
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
                      await addReaction(packData["id"], currentReaction);
                      Navigator.pop(context);
                      reload();
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

  Future<void> _reportDialog(packData) async {
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
            packData: packData,
            reportCallback: _reportCallback,
            chosenReason: chosenReason,
          ),
        );
      },
    );
  }

  void _reportCallback(String reason, bool blockUser, Map packData) {
    blockUser ? blockUserAPI(packData["creator"]["id"], reason) : null;
    reportShort(packData["id"], reason).whenComplete(() {
      reload();
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
