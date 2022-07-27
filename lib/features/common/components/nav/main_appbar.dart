import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/authentication/helpers/authentication_functions.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  //final Function searchRoute;

  const MainAppBar({
    Key? key,
    //required this.searchRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: const Text("Logout"),
          onPressed: () {
            Authentication.logout(context, ref);
          },
        ),*/
        IconButton(
          icon: Image.asset("assets/icons/profile_icon.png", width: 20.0),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        //TODO Fix search
        /*IconButton(
          onPressed: () {
            // Navigator.of(context).push(searchRoute());
          },
          icon: Image.asset("assets/icons/search.png", width: 28),
        )*/
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
