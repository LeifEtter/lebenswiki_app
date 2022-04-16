import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/api_authentication.dart';
import 'package:lebenswiki_app/components/navigation/bottom_nav_bar.dart';
import 'package:lebenswiki_app/components/navigation/main_appbar.dart';
import 'package:lebenswiki_app/components/navigation/menu_bar.dart';
import 'package:lebenswiki_app/components/buttons/add_button.dart';
import 'package:lebenswiki_app/components/navigation/router.dart';
import 'package:lebenswiki_app/components/navigation/routing_constants.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/views/authentication/authentication_signup.dart';
import 'package:lebenswiki_app/views/authentication/authentication_view.dart';
import 'package:lebenswiki_app/views/content_feed.dart';
import 'package:lebenswiki_app/views/community/search_view.dart';
import 'package:lebenswiki_app/views/packs/pack_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lebenswiki_app/data/enums.dart';

final tokenProvider = Provider((_) => 'Some token');
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
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
      initialRoute: AuthenticationWrapperRoute,
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
          return Loading();
        }
        if (token.data.length == 0) {
          return const Scaffold(body: AuthenticationView());
        } else {
          return const NavBarWrapper();
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
  bool _isSearching = false;

  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      ContentFeed(
        contentType: ContentType.packsByCategory,
        isSearching: _isSearching,
      ),
      PackView(),
    ];
    return Scaffold(
      drawer: const MenuBar(
        profileData: {"profileName": "Ella Peters", "userName": "@ella"},
      ),
      floatingActionButton: const AddButton(),
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        callback: toggleSearch,
        searchRoute: _searchRoute,
      ),
      bottomNavigationBar: BottomNavBar(
        onItemTapped: onItemTapped,
        currentIndex: _currentIndex,
      ),
      body: _pages.elementAt(_currentIndex),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void toggleSearch() {
    setState(() {
      !_isSearching ? _isSearching = true : _isSearching = false;
    });
  }

  Route _searchRoute() {
    bool isShort;
    _currentIndex == 0 ? isShort = false : isShort = true;
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SearchView(
        contentType: ContentType.shortsByCategory,
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
