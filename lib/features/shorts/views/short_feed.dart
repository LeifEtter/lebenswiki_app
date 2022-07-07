import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/report_api.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/show_bottom_sheet.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/bottom_sheet_item.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/show_reactions_sheet.dart';
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
}
