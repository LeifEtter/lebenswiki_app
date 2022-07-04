import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/report_api.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/action_menu/components/bottom_menu/actions_menu.dart';
import 'package:lebenswiki_app/features/action_menu/components/bottom_menu/basic_menu_item.dart';
import 'package:lebenswiki_app/features/action_menu/components/bottom_menu/reaction_menu.dart';
import 'package:lebenswiki_app/features/action_menu/components/report_popup.dart';
import 'package:lebenswiki_app/features/categories/components/tab_bar.dart';
import 'package:lebenswiki_app/features/shorts/helper/get_shorts.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

//TODO Add functionality to reaction to comment
class ShortFeed extends ConsumerStatefulWidget {
  const ShortFeed({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortFeedState();
}

class _ShortFeedState extends ConsumerState<ShortFeed> {
  ShortApi packApi = ShortApi();
  UserApi userApi = UserApi();
  ReportApi reportApi = ReportApi();
  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    final List<ContentCategory> categories =
        ref.read(categoryProvider).categories;
    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          buildTabBar(
            categories: categories,
            callback: _onTabbarChoose,
          ),
          GetShorts(
            reload: _reload,
            cardType: CardType.packsByCategory,
            menuCallback: _menuCallback,
            category: categories[currentCategory],
          ),
        ],
      ),
    );
  }

  void _reload() => setState(() {});

  void _onTabbarChoose(newCategory) => setState(() {
        currentCategory = newCategory;
      });

  void _menuCallback(MenuType menuType, int contentId, int creatorId) {
    switch (menuType) {
      case MenuType.moreShort:
        showActionsMenu(
          context,
          menuItems: [
            basicMenuItem(
              Icons.flag,
              "Melden",
              "Diesen Short melden",
              () => _reportDialog(contentId: contentId, creatorId: creatorId),
            ),
            basicMenuItem(
              Icons.comment_outlined,
              "Kommentieren",
              "Schreibe einen Kommentar",
              () {},
            ),
            basicMenuItem(
              Icons.bookmark_outline,
              "Speichern",
              "Zu gespeicherten Shorts hinzufügen",
              () {},
            ),
          ],
        );
        break;
      case MenuType.reactShort:
        showReactionMenu(
          context,
          callback: (String reaction) =>
              _reactCallback(contentId: contentId, reaction: reaction),
        );
        break;
      case MenuType.commentShort:
        break;
      case MenuType.reactShortComment:
        break;
    }
  }

  Future<void> _reportDialog({
    required int contentId,
    required int creatorId,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ReportDialog(
          reportCallback: (String reason, bool blockUser) => _reportCallback(
              contentId: contentId,
              creatorId: creatorId,
              reason: reason,
              blockUser: blockUser),
        );
      },
    );
  }

  //TODO implement popup
  void _reportCallback({
    required String reason,
    required bool blockUser,
    required int contentId,
    required int creatorId,
  }) {
    blockUser ? userApi.blockUser(id: creatorId, reason: reason) : null;
    reportApi
        .reportShort(
            report: Report(
      reason: reason,
      reportedContentId: contentId,
      creationDate: DateTime.now(),
    ))
        .whenComplete(() {
      _reload();
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  //TODO implement successfull popup
  void _reactCallback({required int contentId, required String reaction}) {
    packApi.reactShort(contentId, reaction).then((value) {
      Navigator.pop(context);
      _reload();
    });
  }
}
