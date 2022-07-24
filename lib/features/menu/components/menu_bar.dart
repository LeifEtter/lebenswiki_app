import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/buttons.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/features/menu/views/your_creator_packs.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/features/authentication/helpers/authentication_functions.dart';
import 'package:lebenswiki_app/features/menu/views/bookmark_view.dart';
import 'package:lebenswiki_app/features/menu/views/developer_info.dart';
import 'package:lebenswiki_app/features/menu/views/profile_view.dart';
import 'package:lebenswiki_app/features/menu/views/your_shorts_view.dart';
import 'package:lebenswiki_app/repository/image_repo.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';
import 'package:share_plus/share_plus.dart';

class MenuBar extends ConsumerStatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuBarState();
}

class _MenuBarState extends ConsumerState<MenuBar> {
  UserApi userApi = UserApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = ref.watch(userProvider).user;
    return Drawer(
        child: ListView(
      padding: const EdgeInsets.only(top: 35.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.profileImage,
                ),
                radius: 35,
              ),
              const CloseButton(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15.0),
          child: Text(user.name,
              style: LebenswikiTextStyles.menuBar.menuProfileName),
        ),
        _buildNavigationDrawerItem(
          icon: Icons.person_outline,
          text: "Profil",
          destination: ProfileView(user: user),
        ),
        _buildNavigationDrawerItem(
            icon: Icons.bookmark_outline,
            text: "Gespeichert",
            destination: const BookmarkFeed(
              isSearching: false,
            )),
        _buildNavigationDrawerItem(
          icon: Icons.bookmark_outline,
          text: "Deine Lernpacks",
          destination: const YourCreatorPacks(),
        ),
        _buildNavigationDrawerItem(
          icon: Icons.mode_edit_outline_outlined,
          text: "Deine Shorts",
          destination: const YourShorts(),
        ),
        _buildNavigationDrawerItem(
          icon: Icons.phone_outlined,
          text: "Kontakt/Feedback",
          destination: const DeveloperInfoView(),
        ),
        _buildDrawerItem(
          icon: Icons.logout,
          text: "Ausloggen",
          callback: () => Authentication.logout(context, ref),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
              left: 25.0, right: 25.0, top: 15.0, bottom: 15.0),
          child: LebenswikiButtons.textButton.blueButtonNormal(
            callback: () {
              Share.share('Hey, check die Lebenswiki App aus!');
            },
            text: "Lebenswiki mit Freunden teilen",
          ),
        ),
        const Divider(),
        Image.asset("assets/images/BMFSFJ_logo.png"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Image.asset("assets/images/jugendstrategie-logo.png"),
        ),
      ],
    ));
  }

  Widget _buildNavigationDrawerItem({
    required IconData icon,
    required String text,
    required Widget destination,
  }) =>
      _buildDrawerItem(
          icon: icon,
          text: text,
          callback: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => destination)));

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required Function callback,
  }) {
    return GestureDetector(
      onTap: () => callback(),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Icon(icon, size: 30.0),
            ),
            Text(
              text,
              style: LebenswikiTextStyles.menuBar.menuText,
            )
          ],
        ),
      ),
    );
  }
}
