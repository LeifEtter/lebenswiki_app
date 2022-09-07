import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_wrappers/main_wrapper.dart';
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
    List<ContentCategory> categories = ref.read(categoryProvider).categories;
    HelperData helperData = HelperData(
      categories: categories,
      blockedIdList: ref.read(blockedListProvider).blockedIdList,
      currentUserId: ref.read(userProvider).user.id,
    );
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
          helperData: helperData,
        );

        return PackFeedView(
          categories: categories,
          packListHelper: packListHelper,
          refresh: _refresh,
        );
      }),
    );
  }

  void _refresh() {
    setState(() {});
  }
}

class PackFeedView extends ConsumerStatefulWidget {
  final List<ContentCategory> categories;
  final PackListHelper packListHelper;
  final Function refresh;

  const PackFeedView({
    Key? key,
    required this.categories,
    required this.packListHelper,
    required this.refresh,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackFeedViewState();
}

class _PackFeedViewState extends ConsumerState<PackFeedView> {
  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    bool searchActive = ref.watch(searchProvider).active;
    int currentCategoryId = widget.categories[currentCategory].id;
    List<Pack> currentPacks = searchActive
        ? List<Pack>.from(widget.packListHelper.queriedPacks)
        : List<Pack>.from(
            widget.packListHelper.categorizedPacks[currentCategoryId]!);
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
                            widget.packListHelper.queryShorts(value);
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
          currentPacks.isEmpty
              ? const Center(child: Text("Es wurden keine packs gefunden"))
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      widget.refresh();
                    },
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
                ),
        ],
      ),
    );
  }
}
