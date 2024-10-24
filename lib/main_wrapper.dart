import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/reload_provider.dart';
import 'package:lebenswiki_app/presentation/providers/search_providers.dart';
import 'package:lebenswiki_app/presentation/providers/user_provider.dart';
import 'package:lebenswiki_app/presentation/screens/main/community.dart';
import 'package:lebenswiki_app/presentation/screens/main/explore.dart';
import 'package:lebenswiki_app/presentation/screens/main/home.dart';
import 'package:lebenswiki_app/presentation/widgets/buttons/debug_buttons.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/appbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/bottom_menu.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/bottom_nav_bar.dart';
import 'package:lebenswiki_app/data/category_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';

class NavBarWrapper extends ConsumerStatefulWidget {
  final int initialTab;
  final bool drawerOpen;

  const NavBarWrapper({
    super.key,
    this.initialTab = 0,
    this.drawerOpen = false,
  });

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
    _currentIndex = widget.initialTab;
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() => _updateIndex(tabController.index));
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(reloadProvider);
    return PopScope(
      onPopInvoked: (bool bool) => false,
      child: Scaffold(
        floatingActionButton:
            _buildAddButton(ref, user: ref.read(userProvider).user),
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
                                ref.read(userProvider).user,
                              )),
                      if (_showSearch)
                        searchBar(context, controller: searchController),
                    ];
                  },
                  body: FutureBuilder(
                      future: CategoryApi().getCategorizedPacksAndShorts(),
                      builder: (context,
                          AsyncSnapshot<Either<CustomError, List<Category>>>
                              snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return LoadingHelper.loadingIndicator();
                        } else if (snapshot.data == null) {
                          return const Text("Something went wrong");
                        } else if (snapshot.data!.isLeft &&
                            snapshot.data!.left.error ==
                                "Authentication Failed") {
                          context.go("/login");
                        }
                        List<Category> categories = snapshot.data!.right;
                        return TabBarView(
                          controller: tabController,
                          children: [
                            const HomeView(),
                            Consumer(builder: (context, ref, child) {
                              bool isSearching =
                                  ref.watch(searchStateProvider).isSearching;
                              return ExploreView(
                                isSearching: isSearching,
                                categoriesWithPacks: categories,
                              );
                            }),
                            const CommunityView(),
                          ],
                        );
                      })),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(WidgetRef ref, {required User? user}) => SpeedDial(
        iconTheme: const IconThemeData(size: 40),
        backgroundColor: CustomColors.blue,
        direction: SpeedDialDirection.up,
        icon: Icons.add_rounded,
        children: [
          SpeedDialChild(
            label: "Lernpack Erstellen",
            child: const Icon(Icons.comment),
            onTap: () {
              if (user == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        RegisterRequestPopup(ref));
              } else if (user.role!.level < 3) {
                CustomFlushbar.error(
                        message:
                            "Du musst Creator sein um Lernpacks zu erstellen")
                    .show(context);
              } else {
                context.go("/create/pack");
              }
            },
          ),
          SpeedDialChild(
              label: "Short Erstellen",
              child: const Icon(Icons.add),
              onTap: () async {
                if (user == null) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          RegisterRequestPopup(ref));
                } else {
                  await context.push("/create/short");
                  setState(() {});
                }
              })
        ],
      );

  void _updateIndex(int newIndex) {
    if (_currentIndex != newIndex) {
      setState(() {
        _currentIndex = newIndex;
        if (_currentIndex == 1) {
          _showSearch = true;
        } else {
          _showSearch = false;
        }
      });
    }
  }
}
