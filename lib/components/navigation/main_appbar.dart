import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/authentication/authentication_functions.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/testing/border.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function callback;
  final Function searchRoute;

  const MainAppBar({
    Key? key,
    required this.callback,
    required this.searchRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 10,
      title: const Padding(
        padding: EdgeInsets.only(top: 0),
        child: Text(
          "Lebenswiki",
          style: LebenswikiTextStyles.logoText,
        ),
      ),
      leadingWidth: 55,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Image.asset(
          "assets/icons/lebenswiki_icon.png",
        ),
      ),
      actions: [
        /*TextButton(
          child: Text("Logout"),
          onPressed: () {
            AuthenticationFunctions().logout(context);
          },
        ),*/
        IconButton(
          icon: Image.asset("assets/icons/profile_icon.png", width: 20.0),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(searchRoute());
          },
          icon: Image.asset("assets/icons/search.png", width: 28),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
