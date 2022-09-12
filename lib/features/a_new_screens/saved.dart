import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_common/top_nav.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/pack_card.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/short_card.dart';
import 'package:lebenswiki_app/features/a_new_wrappers/main_wrapper.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/helper/pack_list_helper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';

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
                future: _getPacksAndShorts(helperData: helperData),
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
                            ListView.builder(
                              padding: const EdgeInsets.all(20.0),
                              shrinkWrap: true,
                              itemCount: packHelper.packs.length,
                              itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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
                            ListView.builder(
                              padding: const EdgeInsets.all(20.0),
                              shrinkWrap: true,
                              itemCount: shortHelper.shorts.length,
                              itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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

  Future<Either<CustomError, Map>> _getPacksAndShorts({
    required HelperData helperData,
  }) async {
    ResultModel shortsResult = await ShortApi().getBookmarkedShorts();
    ResultModel packsResult = await PackApi().getBookmarkedPacks();
    if (shortsResult.type != ResultType.failure &&
        packsResult.type != ResultType.failure) {
      return Right({
        "shortHelper": ShortListHelper(
            shorts: List<Short>.from(shortsResult.responseList),
            helperData: helperData),
        "packHelper": PackListHelper(
            packs: List<Pack>.from(packsResult.responseList),
            helperData: helperData),
      });
    } else {
      return const Left(CustomError(error: "Etwas ist schiefgelaufen"));
    }
  }
}
