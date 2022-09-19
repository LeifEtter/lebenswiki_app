import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/pack_short_service.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/other.dart';
import 'package:lebenswiki_app/presentation/widgets/top_nav.dart';
import 'package:lebenswiki_app/presentation/widgets/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/short_card.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/application/loading_helper.dart';
import 'package:lebenswiki_app/application/pack_list_helper.dart';
import 'package:lebenswiki_app/application/short_list_helper.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';

class SavedView extends ConsumerStatefulWidget {
  const SavedView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedViewState();
}

class _SavedViewState extends ConsumerState<SavedView> {
  @override
  Widget build(BuildContext context) {
    List<ContentCategory> categories = ref.read(categoryProvider).categories;
    HelperData helperData = HelperData(
      categories: categories,
      blockedIdList: ref.read(blockedListProvider).blockedIdList,
      currentUserId: ref.read(userProvider).user.id,
    );
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TopNavIOS(title: "Gespeichert"),
              SizedBox(
                height: 50,
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text("Packs",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    Tab(
                      child: Text("Shorts",
                          style: Theme.of(context).textTheme.labelLarge),
                    )
                  ],
                  isScrollable: true,
                  indicatorWeight: 4.0,
                  indicatorColor: CustomColors.blue,
                  labelColor: CustomColors.offBlack,
                  unselectedLabelColor: CustomColors.darkGrey,
                ),
              ),
              FutureBuilder(
                future: PackShortService.getPacksAndShortsForBookmarks(
                    helperData: helperData),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (LoadingHelper.isLoading(snapshot)) {
                    return LoadingHelper.loadingIndicator();
                  }
                  final Either<CustomError, Map> result = snapshot.data;
                  return result.fold(
                    (left) {
                      return Text(left.error);
                    },
                    (right) {
                      PackListHelper packHelper = right["packHelper"];
                      ShortListHelper shortHelper = right["shortHelper"];
                      return Expanded(
                        child: TabBarView(
                          children: [
                            packHelper.packs.isEmpty
                                ? _buildEmptyText(
                                    "Du hast noch keine Packs gespeichert")
                                : ListView.builder(
                                    padding: const EdgeInsets.all(20.0),
                                    shrinkWrap: true,
                                    itemCount: packHelper.packs.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: SizedBox(
                                        height: 280,
                                        child: NewPackCard(
                                          progressValue: 0,
                                          isStarted: false,
                                          pack: packHelper.packs[index],
                                          heroParent: "saved-packs",
                                        ),
                                      ),
                                    ),
                                  ),
                            shortHelper.shorts.isEmpty
                                ? _buildEmptyText(
                                    "Du hast noch keine Shorts gespeichert")
                                : ListView.builder(
                                    padding: const EdgeInsets.all(20.0),
                                    shrinkWrap: true,
                                    itemCount: shortHelper.shorts.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: NewShortCard(
                                        short: shortHelper.shorts[index],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyText(text) => Column(
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.info_outline_rounded,
            color: CustomColors.darkGrey,
            size: 40,
          ),
          Text(
            text,
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
}
