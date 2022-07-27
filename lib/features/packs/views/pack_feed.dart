import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/common/components/tab_bar.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card.dart';
import 'package:lebenswiki_app/features/packs/helper/pack_list_helper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class PackFeed extends ConsumerStatefulWidget {
  const PackFeed({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackFeedState();
}

class _PackFeedState extends ConsumerState<PackFeed> {
  PackApi packApi = PackApi();
  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    final List<ContentCategory> categories =
        ref.read(categoryProvider).categories;
    final int userId = ref.read(userIdProvider).userId;
    final List<int> blockedList = ref.watch(blockedListProvider).blockedIdList;
    return FutureBuilder(
      future: packApi.getAllPacks(),
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (LoadingHelper.isLoading(snapshot)) {
          return LoadingHelper.loadingIndicator();
        }

        ResultModel result = snapshot.data;
        //If request fails show error text
        if (result.type == ResultType.failure) return Text(result.message!);

        List<Pack> _packList = List<Pack>.from(result.responseList);

        PackListHelper packListHelper = PackListHelper(
          packs: _packList,
          currentUserId: userId,
          categories: categories,
          blockedList: blockedList,
        );

        return DefaultTabController(
          length: categories.length,
          child: StatefulBuilder(
            builder: (context, newSetState) {
              int currentCategoryId = categories[currentCategory].id;
              List<Pack> currentPacks = List<Pack>.from(
                  packListHelper.categorizedPacks[currentCategoryId]!);
              return Column(
                children: [
                  buildTabBar(
                    categories: categories,
                    callback: (newCategory) {
                      currentCategory = newCategory;
                      newSetState(() {});
                    },
                  ),
                  currentPacks.isEmpty
                      ? const Center(
                          child: Text("Es wurden keine packs gefunden"))
                      : Expanded(
                          child: ListView.builder(
                            addAutomaticKeepAlives: true,
                            shrinkWrap: true,
                            itemCount: currentPacks.length,
                            itemBuilder: ((context, index) {
                              Pack pack = currentPacks[index];

                              return PackCard(
                                pack: pack,
                              );
                            }),
                          ),
                        ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
