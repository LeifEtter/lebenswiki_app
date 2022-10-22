import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/application/data/pack_short_service.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/helper_data_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/main_views/community.dart';
import 'package:lebenswiki_app/presentation/screens/main_views/explore.dart';
import 'package:lebenswiki_app/presentation/screens/main_views/home.dart';
import 'package:lebenswiki_app/presentation/screens/packs/creator_information.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/appbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/bottom_menu.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/bottom_nav_bar.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

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
  //bool _showShortCreation = false;

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
    ref.watch(reloadProvider);
    UserRole userRole = ref.watch(userRoleProvider).role;
    return Scaffold(
      floatingActionButton: _buildAddButton(ref, userRole: userRole),
      backgroundColor: Colors.white,
      extendBody: true,
      bottomNavigationBar: CustomBottomBar(
        onPressed: (index) => tabController.animateTo(index),
        selectedIndex: _currentIndex,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: true,
            bottom: false,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  appBar(context,
                      onPress: () => showBottomMenuForNavigation(
                            context,
                            ref,
                            () => setState(() {}),
                            userRole,
                          )),
                  if (_showSearch) SearchBar(searchController: searchController)
                ];
              },
              body: FutureBuilder(
                  future: PackShortService.getPacksAndShorts(
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
        ],
      ),
    );
  }

  Widget _buildAddButton(WidgetRef ref, {required UserRole userRole}) =>
      SpeedDial(
        iconTheme: const IconThemeData(size: 40),
        backgroundColor: CustomColors.blue,
        direction: SpeedDialDirection.up,
        icon: Icons.add_rounded,
        children: [
          SpeedDialChild(
            label: "Lernpack Erstellen",
            child: const Icon(Icons.comment),
            onTap: () {
              if (userRole == UserRole.anonymous) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        RegisterRequestPopup(ref));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatorPackInfo(),
                  ),
                );
              }
            },
          ),
          SpeedDialChild(
              label: "Short Erstellen",
              child: const Icon(Icons.add),
              onTap: () async {
                if (userRole == UserRole.anonymous) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          RegisterRequestPopup(ref));
                } else {
                  await Navigator.pushNamed(context, '/createShort');
                  setState(() {});
                }
              })
        ],
      );

  void _updateIndex(int newIndex) => setState(() {
        _currentIndex = newIndex;
        if (_currentIndex == 1) {
          _showSearch = true;
        } else {
          _showSearch = false;
        }
      });
}
