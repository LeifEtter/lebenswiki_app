import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/data/pack_short_service.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/helper_data_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/pack_specific_views/creator_overview.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/application/data/pack_list_helper.dart';
import 'package:lebenswiki_app/application/data/short_list_helper.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';

class CreatedView extends ConsumerStatefulWidget {
  const CreatedView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatedViewState();
}

class _CreatedViewState extends ConsumerState<CreatedView> {
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
                future: PackShortService.getPacksAndShortsForCreated(
                    helperData: helperData),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (LoadingHelper.isLoading(snapshot)) {
                    return LoadingHelper.loadingIndicator();
                  }
                  final Either<CustomError, Map> result = snapshot.data;
                  return result.fold(
                    (left) => Text(left.error),
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
                                    padding: const EdgeInsets.all(30.0),
                                    shrinkWrap: true,
                                    itemCount: packHelper.packs.length,
                                    itemBuilder: (context, index) {
                                      Pack currentPack =
                                          packHelper.packs[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40),
                                        child: SizedBox(
                                          width: 300,
                                          height: 250,
                                          child: PackCard(
                                            navigateTo: () async {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CreatorOverview(
                                                              pack:
                                                                  currentPack)));
                                              setState(() {});
                                            },
                                            isDraftView: true,
                                            progressValue: 0,
                                            isStarted: false,
                                            pack: currentPack,
                                            heroParent: "created-packs",
                                          ),
                                        ),
                                      );
                                    },
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
                                      child: ShortCard(
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
