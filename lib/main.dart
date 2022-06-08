import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/components/create/views/feed.dart';
import 'package:lebenswiki_app/components/create/views/your_creator_packs.dart';
import 'package:lebenswiki_app/components/navigation/bottom_nav_bar.dart';
import 'package:lebenswiki_app/components/navigation/main_appbar.dart';
import 'package:lebenswiki_app/components/navigation/menu_bar.dart';
import 'package:lebenswiki_app/components/buttons/add_button.dart';
import 'package:lebenswiki_app/components/navigation/router.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/routing_constants.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/views/authentication/authentication_view.dart';
import 'package:lebenswiki_app/views/shorts/search_view.dart';
import 'package:lebenswiki_app/components/create/views/feed.dart';
import 'package:lebenswiki_app/views/shorts/short_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:lebenswiki_api_helper/lebenswiki_api_helper.dart' as api_helper;

final tokenProvider = Provider((_) => 'Some token');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  Future<List> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return [];
    } else {
      String? token = prefs.getString("token");
      return [token];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getToken(),
      builder: (context, AsyncSnapshot token) {
        if (!token.hasData) {
          return const Loading();
        }
        if (token.data.length == 0) {
          return const Scaffold(body: AuthenticationView());
        } else {
          return const NavBarWrapper();
          //return YourCreatorPacks();
          //return const PackPageView([]);
          //return const TestParent();
        }
      },
    );
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
      const PackViewNew(),
      const ShortView(),
    ];
    return Scaffold(
      drawer: const MenuBar(
        profileData: {"profileName": "Ella Peters", "userName": "@ella"},
      ),
      floatingActionButton: dialAddButton(context),
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        searchRoute: _searchRoute,
      ),
      bottomNavigationBar: BottomNavBar(
        onItemTapped: onItemTapped,
        currentIndex: _currentIndex,
      ),
      body: PageView(
        controller: pageController,
        children: _pages,
        onPageChanged: (index) {
          _currentIndex = index;
          setState(() {});
        },
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      _currentIndex = index;
    });
  }

  Route _searchRoute() {
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
  }
}
