import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_screens/community.dart';
import 'package:lebenswiki_app/features/a_new_screens/contact.dart';
import 'package:lebenswiki_app/features/a_new_screens/explore.dart';
import 'package:lebenswiki_app/features/a_new_screens/home.dart';
import 'package:lebenswiki_app/features/a_new_screens/profile.dart';
import 'package:lebenswiki_app/features/a_new_screens/saved.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/appbar.dart';
import 'package:lebenswiki_app/features/common/components/buttons/add_button.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/common/components/nav/bottom_nav_bar.dart';
import 'package:lebenswiki_app/features/menu/components/menu_bar.dart';
import 'package:lebenswiki_app/features/menu/views/developer_info.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/helper/pack_list_helper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class SearchQueryNotifier extends ChangeNotifier {
  SearchQueryNotifier({this.query = ""});
  String query;

  void setQuery(String newQuery) {
    query = newQuery;
    notifyListeners();
  }
}

final queryProvider = ChangeNotifierProvider((ref) => SearchQueryNotifier());

class SearchStateNotifier extends ChangeNotifier {
  SearchStateNotifier({this.isSearching = false});

  bool isSearching;

  void checkChange({required String text}) {
    bool newSearchState = false;
    if (text != "") newSearchState = true;
    if (newSearchState != isSearching) {
      isSearching = newSearchState;
      notifyListeners();
    }
  }
}

final searchStateProvider =
    ChangeNotifierProvider((ref) => SearchStateNotifier());

class HelperData {
  final int currentUserId;
  final List<ContentCategory> categories;
  final List<int> blockedIdList;

  HelperData({
    required this.blockedIdList,
    required this.categories,
    required this.currentUserId,
  });
}

class CustomError {
  final String error;

  const CustomError({required this.error});
}

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
  bool _isSearching = false;
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
    if (_currentIndex == 1) {
      _showSearch = true;
    }
    return Scaffold(
      drawer: const MenuBar(),
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
            List<Widget> appBars = [appBar(showMenu: _showMenu)];
            if (_showSearch) {
              appBars.add(SearchBar(
                onChange: (String text) {
                  //TODO implement setState only for explore widget
                  setState(() {
                    text == "" ? _isSearching = false : _isSearching = true;
                  });
                },
                searchController: searchController,
              ));
            }
            return appBars;
          },
          body: FutureBuilder(
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
                    return _isSearching
                        ? ListView(
                            shrinkWrap: true,
                            children: [],
                          )
                        : TabBarView(
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

  Future<Either<CustomError, Map>> _getPacksAndShorts({
    required HelperData helperData,
  }) async {
    ResultModel shortsResult = await ShortApi().getAllShorts();
    ResultModel packsResult = await PackApi().getAllPacks();
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

  void _updateIndex(int newIndex) => setState(() {
        _currentIndex = newIndex;
        if (_currentIndex == 1) {
          _showSearch = true;
        } else {
          _showSearch = false;
        }
      });

  void _showMenu() => showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              _buildMenuTile(
                endpoint: const ProfileView(),
                text: "Profil",
                icon: Icons.person_outline_rounded,
              ),
              _buildMenuTile(
                endpoint: const SavedView(),
                text: "Gespeichert",
                icon: Icons.bookmark_outline,
              ),
              _buildMenuTile(
                endpoint: const ContactView(),
                text: "Hilfe",
                icon: Icons.help_outline_rounded,
              ),
              _buildMenuTile(
                endpoint: const DeveloperInfoView(),
                text: "Kontakt",
                icon: Icons.phone_outlined,
              ),
              _buildMenuTile(
                endpoint: const ProfileView(),
                text: "Ausloggen",
                icon: Icons.logout,
              ),
            ],
          ),
        );
      });

  //Refactor to new routing
  Widget _buildMenuTile({
    required String text,
    required IconData icon,
    required Widget endpoint,
  }) =>
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => endpoint,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 40,
              ),
              child: Divider(
                thickness: 1,
              ),
            ),
          ],
        ),
      );
}
