import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/misc_api.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/report_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/components/actions/modal_sheet.dart';
import 'package:lebenswiki_app/helper/actions/reaction_functions.dart';
import 'package:lebenswiki_app/components/actions/report_dialog.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/filtering/tab_bar.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/report_model.dart';

class PackView extends StatefulWidget {
  const PackView({
    Key? key,
  }) : super(key: key);

  @override
  _PackViewState createState() => _PackViewState();
}

class _PackViewState extends State<PackView> {
  final MiscApi miscApi = MiscApi();
  final PackApi packApi = PackApi();
  final UserApi userApi = UserApi();
  final ReportApi reportApi = ReportApi();
  int currentCategory = 0;
  String? chosenReason = "Illegal unter der NetzDG";

  late List<ContentCategory> categories;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: miscApi.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<ResultModel> snapshot) {
        if (!snapshot.hasData) {
          return const Loading();
        } else {
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
                  reload: reload,
                  cardType: CardType.packsByCategory,
                  menuCallback: _menuCallback,
                  category: categories[currentCategory],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void reload() {
    setState(() {});
  }

  void _onTabbarChoose(newCategory) {
    setState(() {
      currentCategory = newCategory;
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
      case MenuType.commentShort:
        break;
      case MenuType.reactShortComment:
        break;
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
                      await packApi.reactPack(packData["id"], currentReaction);
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

  Future<void> _reportDialog(contentData) async {
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
    reportApi
        .reportPack(
            report: Report(
      reason: reason,
      reportedContentId: contentData.id,
      creationDate: DateTime.now(),
    ))
        .whenComplete(() {
      reload();
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
