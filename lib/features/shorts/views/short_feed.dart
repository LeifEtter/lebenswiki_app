import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/common/components/tab_bar.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card_scaffold.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';

//TODO Add functionality to reaction to comment
class ShortFeed extends ConsumerStatefulWidget {
  const ShortFeed({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortFeedState();
}

class _ShortFeedState extends ConsumerState<ShortFeed> {
  ShortApi shortApi = ShortApi();
  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    final List<ContentCategory> categories =
        ref.read(categoryProvider).categories;
    final int userId = ref.read(userIdProvider).userId;
    final List<int> blockedList = ref.watch(blockedListProvider).blockedIdList;
    return FutureBuilder(
      future: shortApi.getAllShorts(),
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (LoadingHelper.isLoading(snapshot)) {
          return LoadingHelper.loadingIndicator();
        }

        ResultModel result = snapshot.data;
        //If request fails show error text
        if (result.type == ResultType.failure) return Text(result.message!);
        if (result.responseList.isEmpty) return Text(result.message!);

        List<Short> _shortList = List<Short>.from(result.responseList);

        ShortListHelper shortListHelper = ShortListHelper(
          shorts: _shortList,
          currentUserId: userId,
          categories: categories,
          blockedList: blockedList,
        );

        return DefaultTabController(
          length: categories.length,
          child: StatefulBuilder(
            builder: (context, newSetState) {
              int currentCategoryId = categories[currentCategory].id;
              List<Short> currentShorts = List<Short>.from(
                  shortListHelper.categorizedShorts[currentCategoryId]!);
              return Column(
                children: [
                  buildTabBar(
                    categories: categories,
                    callback: (newCategory) {
                      currentCategory = newCategory;
                      newSetState(() {});
                    },
                  ),
                  currentShorts.isEmpty
                      ? const Center(
                          child: Text("Es wurden keine shorts gefunden"))
                      : Expanded(
                          child: ListView.builder(
                            addAutomaticKeepAlives: true,
                            shrinkWrap: true,
                            itemCount: currentShorts.length,
                            itemBuilder: ((context, index) {
                              Short short = currentShorts[index];

                              return ShortCardScaffold(
                                cardType: CardType.yourShorts,
                                short: short,
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
