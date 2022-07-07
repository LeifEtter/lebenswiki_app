import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/token/token_handler.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/packs/views/pack_feed.dart';
import 'package:lebenswiki_app/features/common/components/nav/bottom_nav_bar.dart';
import 'package:lebenswiki_app/features/common/components/nav/main_appbar.dart';
import 'package:lebenswiki_app/features/menu/components/menu_bar.dart';
import 'package:lebenswiki_app/features/common/components/buttons/add_button.dart';
import 'package:lebenswiki_app/features/routing/router.dart';
import 'package:lebenswiki_app/features/routing/routing_constants.dart';
import 'package:lebenswiki_app/features/authentication/views/authentication_view.dart';
import 'package:lebenswiki_app/features/shorts/views/short_feed.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lebenswiki',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Outfit",
      ),
      onGenerateRoute: generateRoute,
      initialRoute: authenticationWrapperRoute,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TokenHandler().get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (LoadingHelper.isLoading(snapshot)) {
            return LoadingHelper.loadingIndicator();
          }
          return snapshot.data!.isEmpty
              ? const NavBarWrapper()
              : const AuthenticationView();
        });
  }
}

class NavBarWrapper extends StatefulWidget {
  final int initialTab;

  const NavBarWrapper({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  _NavBarWrapperState createState() => _NavBarWrapperState();
}

class _NavBarWrapperState extends State<NavBarWrapper> {
  int _currentIndex = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      const PackFeed(),
      const ShortFeed(),
    ];
    return Scaffold(
      drawer: const MenuBar(),
      floatingActionButton: dialAddButton(context),
      backgroundColor: Colors.white,
      appBar: const MainAppBar(
          //searchRoute: _searchRoute,
          ),
      bottomNavigationBar: BottomNavBar(
        onItemTapped: onItemTapped,
        currentIndex: _currentIndex,
      ),
      body: PageView(
        controller: pageController,
        children: _pages,
        onPageChanged: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }

  void onItemTapped(int index) => setState(() {
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        _currentIndex = index;
      });

  //TODO implement search route
  /*Route _searchRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SearchView(
        cardType: CardType.shortsByCategory,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }*/
}
