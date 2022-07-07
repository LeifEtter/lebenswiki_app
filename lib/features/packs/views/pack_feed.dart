import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/common/components/tab_bar.dart';
import 'package:lebenswiki_app/features/packs/helper/get_packs.dart';
import 'package:lebenswiki_app/features/snackbar/components/custom_snackbar.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';

//TODO Add functionality to reaction to comment
class PackFeed extends ConsumerStatefulWidget {
  const PackFeed({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackFeedState();
}

class _PackFeedState extends ConsumerState<PackFeed> {
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
          GetPacks(
            reload: _reload,
            cardType: CardType.packsByCategory,
            category: categories[currentCategory],
          ),
          TextButton(
            child: Text("call snackbar"),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar.errorSnackbar(context, errorMessage: "Something"),
            ),
          )
        ],
      ),
    );
  }

  void _reload() => setState(() {});

  void _onTabbarChoose(newCategory) => setState(() {
        currentCategory = newCategory;
      });
}
