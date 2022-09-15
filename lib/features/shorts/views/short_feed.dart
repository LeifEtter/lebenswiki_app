import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_common/other.dart';
import 'package:lebenswiki_app/features/a_new_wrappers/main_wrapper.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/common/components/tab_bar.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';

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
    ref.watch(reloadProvider);
    List<ContentCategory> categories = ref.read(categoryProvider).categories;
    HelperData helperData = HelperData(
      categories: categories,
      blockedIdList: ref.read(blockedListProvider).blockedIdList,
      currentUserId: ref.read(userProvider).user.id,
    );
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

        ShortListHelper shortListHelper =
            ShortListHelper(shorts: _shortList, helperData: helperData);

        return ShortFeedView(
          categories: categories,
          shortListHelper: shortListHelper,
        );
      }),
    );
  }
}

class ShortFeedView extends ConsumerStatefulWidget {
  final List<ContentCategory> categories;
  final ShortListHelper shortListHelper;

  const ShortFeedView({
    Key? key,
    required this.categories,
    required this.shortListHelper,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortFeedViewState();
}

class _ShortFeedViewState extends ConsumerState<ShortFeedView> {
  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    bool searchActive = ref.watch(searchProvider).active;
    int currentCategoryId = widget.categories[currentCategory].id;
    List<Short> currentShorts = searchActive
        ? List<Short>.from(widget.shortListHelper.queriedShorts)
        : List<Short>.from(
            widget.shortListHelper.categorizedShorts[currentCategoryId]!);
    return DefaultTabController(
      length: widget.categories.length,
      child: Column(
        children: [
          searchActive
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          onChanged: (value) {
                            widget.shortListHelper.queryPacks(value);
                            setState(() {});
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.read(searchProvider).switchActiveOff(),
                        child: const Text("Abbrechen"),
                      )
                    ],
                  ),
                )
              : buildTabBar(
                  categories: widget.categories,
                  callback: (newCategory) {
                    currentCategory = newCategory;
                    setState(() {});
                  },
                ),
          currentShorts.isEmpty
              ? const Center(child: Text("Es wurden keine shorts gefunden"))
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.read(reloadProvider).reload();
                    },
                    child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      itemCount: currentShorts.length,
                      itemBuilder: ((context, index) {
                        Short short = currentShorts[index];

                        return ShortCard(
                          short: short,
                        );
                      }),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
