import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/result_model_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/views/menu/your_creator_packs.dart';
import 'package:lebenswiki_app/data/image_repo.dart';
import 'package:lebenswiki_app/helper/auth/authentication_functions.dart';
import 'package:lebenswiki_app/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/views/menu/bookmark_view.dart';
import 'package:lebenswiki_app/views/menu/developer_info.dart';
import 'package:lebenswiki_app/views/menu/profile_view.dart';
import 'package:lebenswiki_app/views/menu/your_shorts_view.dart';
import 'package:share_plus/share_plus.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  UserApi userApi = UserApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: userApi.getUserData(),
        builder: (context, AsyncSnapshot<ResultModel> snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          } else if (snapshot.data == null) {
            return const Text("No Profile Data found");
          } else {
            User user = snapshot.data!.responseItem;
            return ListView(
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
                  destination: const ProfileView(),
                ),
                _buildNavigationDrawerItem(
                    icon: Icons.bookmark_outline,
                    text: "Gespeichert",
                    destination: const BookmarkFeed(
                      isShort: true,
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
                  callback: () => AuthenticationFunctions().logout(context),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 15.0, bottom: 15.0),
                  child: lebenswikiBlueButtonNormal(
                    callback: () {
                      Share.share('Hey, check die Lebenswiki App aus!');
                    },
                    text: "Lebenswiki mit Freunden teilen",
                  ),
                ),
                const Divider(),
                Image.network(ImageRepo.bmsLogo),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Image.network(ImageRepo.jugendStrategieLogo),
                ),
              ],
            );
          }
        },
      ),
    );
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
