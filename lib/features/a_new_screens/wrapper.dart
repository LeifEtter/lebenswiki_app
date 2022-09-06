import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_screens/explore.dart';
import 'package:lebenswiki_app/features/a_new_screens/home.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/appbar.dart';
import 'package:lebenswiki_app/features/common/components/buttons/add_button.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/common/components/nav/bottom_nav_bar.dart';
import 'package:lebenswiki_app/features/menu/components/menu_bar.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/helper/pack_list_helper.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/shorts/views/short_feed.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class NavBarWrapper extends StatefulWidget {
  final int initialTab;
  final bool drawerOpen;

  const NavBarWrapper({
    Key? key,
    this.initialTab = 0,
    this.drawerOpen = false,
  }) : super(key: key);

  @override
  _NavBarWrapperState createState() => _NavBarWrapperState();
}

class _NavBarWrapperState extends State<NavBarWrapper>
    with TickerProviderStateMixin {
  final List<Widget> _pages = <Widget>[
    const PackWrapper(),
    const ExploreView(),
    const ShortFeed(),
  ];
  late TabController tabController;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  bool _showSearch = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    tabController = TabController(length: _pages.length, vsync: this);
    tabController.addListener(() => _updateIndex(tabController.index));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 1) {
      _showSearch = true;
    }
    return Scaffold(
      drawer: const MenuBar(),
      floatingActionButton: dialAddButton(context),
      backgroundColor: Colors.white,
      extendBody: true,
      bottomNavigationBar: CustomBottomBar(
        onPressed: (index) {
          tabController.animateTo(index);
          _updateIndex(index);
        },
        selectedIndex: _currentIndex,
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            List<Widget> appBars = [appBar()];
            if (_showSearch) {
              appBars.add(SearchBar(
                onChange: () {},
                searchController: searchController,
              ));
            }
            return appBars;
          },
          /*body: NotificationListener<ScrollNotification>(
            child: ListView(
              controller: scrollController,
              children: [
                Container(height: 500, color: Colors.red),
                Container(height: 500, color: Colors.green),
              ],
            ),
            onNotification: (ScrollNotification scrollInfo) {
              return false;
            },
          ),*/
          body: TabBarView(
            controller: tabController,
            children: _pages,
          ),
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

class PackWrapper extends ConsumerStatefulWidget {
  const PackWrapper({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackWrapperState();
}

class _PackWrapperState extends ConsumerState<PackWrapper> {
  @override
  Widget build(BuildContext context) {
    //INIT PROVIDERS
    final List<ContentCategory> _categories =
        ref.read(categoryProvider).categories;
    final int _userId = ref.read(userProvider).user.id;
    final List<int> _blockedList = ref.watch(blockedListProvider).blockedIdList;

    return FutureBuilder(
      future: PackApi().getAllPacks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (LoadingHelper.isLoading(snapshot)) {
          return LoadingHelper.loadingIndicator();
        }

        ResultModel result = snapshot.data;
        if (result.type == ResultType.failure) return Text(result.message!);

        List<Pack> _unprocessedPacks = List<Pack>.from(result.responseList);

        PackListHelper _packListHelper = PackListHelper(
          packs: _unprocessedPacks,
          currentUserId: _userId,
          blockedList: _blockedList,
          categories: _categories,
        );

        return HomeView(packHelper: _packListHelper);
      },
    );
  }
}
