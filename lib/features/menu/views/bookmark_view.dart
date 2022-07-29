import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/common/components/tab_styles.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card.dart';
import 'package:lebenswiki_app/features/packs/helper/pack_list_helper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class BookmarkFeed extends ConsumerStatefulWidget {
  final bool isSearching;

  const BookmarkFeed({
    Key? key,
    required this.isSearching,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarkFeedState();
}

class _BookmarkFeedState extends ConsumerState<BookmarkFeed>
    with TickerProviderStateMixin {
  final PackApi packApi = PackApi();
  int chosenTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final User user = ref.read(userProvider).user;
    final List<ContentCategory> categories =
        ref.read(categoryProvider).categories;
    final List<int> blockedList = ref.read(blockedListProvider).blockedIdList;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNav(pageName: "Gespeichert", backName: "Menu"),
            const SizedBox(height: 30),
            FutureBuilder(
              future: _getBookmarkedContent(),
              builder: ((BuildContext context, AsyncSnapshot snapshot) {
                if (LoadingHelper.isLoading(snapshot)) {
                  return LoadingHelper.loadingIndicator();
                }

                ShortListHelper shortListHelper = ShortListHelper(
                  shorts: snapshot.data["shorts"],
                  currentUserId: user.id,
                  categories: categories,
                  blockedList: blockedList,
                );

                PackListHelper packListHelper = PackListHelper(
                  packs: snapshot.data["packs"],
                  currentUserId: user.id,
                  categories: categories,
                  blockedList: blockedList,
                );

                log("after packs init");

                return Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: TabBar(
                          controller: _tabController,
                          tabs: [
                            customTab("Lernpacks"),
                            customTab("Shorts"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            packListHelper.packs.isEmpty
                                ? const Center(
                                    child:
                                        Text("Es wurden keine Packs gefunden"))
                                : ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    shrinkWrap: true,
                                    itemCount: packListHelper.packs.length,
                                    itemBuilder: ((context, index) {
                                      Pack pack = packListHelper.packs[index];

                                      return PackCard(pack: pack);
                                    }),
                                  ),
                            shortListHelper.shorts.isEmpty
                                ? const Center(
                                    child:
                                        Text("Es wurden keine Shorts gefunden"))
                                : ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    shrinkWrap: true,
                                    itemCount: shortListHelper.shorts.length,
                                    itemBuilder: ((context, index) {
                                      Short short =
                                          shortListHelper.shorts[index];

                                      return ShortCard(
                                        short: short,
                                      );
                                    }),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, List>> _getBookmarkedContent() async {
    List<Pack> packs = [];
    List<Short> shorts = [];
    ResultModel packsResult = await PackApi().getBookmarkedPacks();
    ResultModel shortsResult = await ShortApi().getBookmarkedShorts();

    if (packsResult.type != ResultType.failure &&
        shortsResult.type != ResultType.failure) {
      packs = List<Pack>.from(packsResult.responseList);
      shorts = List<Short>.from(shortsResult.responseList);
    }

    return {"packs": packs, "shorts": shorts};
  }
}
