import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/pack_short_service.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/helper_data_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/other.dart';
import 'package:lebenswiki_app/presentation/providers/new_providers.dart';
import 'package:lebenswiki_app/presentation/screens/community.dart';
import 'package:lebenswiki_app/presentation/screens/explore.dart';
import 'package:lebenswiki_app/presentation/screens/home.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/appbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/bottom_menu.dart';
import 'package:lebenswiki_app/presentation/widgets/buttons/add_button.dart';
import 'package:lebenswiki_app/application/loading_helper.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/bottom_nav_bar.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';

class NavBarWrapper extends ConsumerStatefulWidget {
  final int initialTab;
  final bool drawerOpen;

  const NavBarWrapper({
    Key? key,
    this.initialTab = 0,
    this.drawerOpen = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavBarWrapperState();
}

class _NavBarWrapperState extends ConsumerState<NavBarWrapper>
    with TickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();
  bool _showSearch = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() => _updateIndex(tabController.index));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ContentCategory> categories = ref.read(categoryProvider).categories;
    HelperData helperData = HelperData(
      categories: categories,
      blockedIdList: ref.read(blockedListProvider).blockedIdList,
      currentUserId: ref.read(userProvider).user.id,
    );
    return Scaffold(
      floatingActionButton: dialAddButton(context),
      backgroundColor: Colors.white,
      extendBody: true,
      bottomNavigationBar: CustomBottomBar(
        onPressed: (index) => tabController.animateTo(index),
        selectedIndex: _currentIndex,
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              appBar(context,
                  onPress: () => showBottomMenuForNavigation(context, ref)),
              if (_showSearch) SearchBar(searchController: searchController)
            ];
          },
          body: FutureBuilder(
              future:
                  PackShortService.getPacksAndShorts(helperData: helperData),
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
                    return TabBarView(
                      controller: tabController,
                      children: [
                        HomeView(packHelper: right["packHelper"]),
                        Consumer(builder: (context, ref, child) {
                          bool isSearching =
                              ref.watch(searchStateProvider).isSearching;
                          return ExploreView(
                            isSearching: isSearching,
                            categories: categories,
                            packHelper: right["packHelper"],
                            shortHelper: right["shortHelper"],
                          );
                        }),
                        CommunityView(shortHelper: right["shortHelper"]),
                      ],
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  void _updateIndex(int newIndex) => setState(() {
        _currentIndex = newIndex;
        if (_currentIndex == 1) {
          _showSearch = true;
        } else {
          _showSearch = false;
        }
      });
}
