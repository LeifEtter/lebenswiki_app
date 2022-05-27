import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_authentication.dart';
import 'package:lebenswiki_app/components/create/views/your_creator_packs.dart';
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
  final Map profileData;

  const MenuBar({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  String profileName = "Not logged in";
  String userName = "@";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profileData.isNotEmpty) {
      profileName = widget.profileData["profileName"];
      userName = widget.profileData["userName"];
    }
    return Drawer(
      child: FutureBuilder(
        future: getUserData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          } else if (snapshot.data == null) {
            return const Text("No Profile Data found");
          } else {
            if (snapshot.data["profileImage"] == "something") {
              snapshot.data["profileImage"] =
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Pic160118_J%C3%B8rgen_Randers_%28face_only_-_for_free_use%29.jpg/1114px-Pic160118_J%C3%B8rgen_Randers_%28face_only_-_for_free_use%29.jpg";
            }
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
                          snapshot.data["profileImage"],
                        ),
                        radius: 35,
                      ),
                      const CloseButton(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                  child: Text(snapshot.data["name"],
                      style: LebenswikiTextStyles.menuBar.menuProfileName),
                ),
                _buildDrawerItem(Icons.person_outline, "Profil", () {
                  _routeProfilePage();
                }),
                _buildDrawerItem(
                    Icons.bookmark_outline, "Gespeichert", _routeBookmarks),
                _buildDrawerItem(
                  Icons.my_library_books_outlined,
                  "Deine Lernpacks",
                  _routeYourCreatorPacks,
                ),
                _buildDrawerItem(Icons.mode_edit_outline_outlined,
                    "Deine Shorts", _routeYourShorts),
                _buildDrawerItem(Icons.phone_outlined, "Kontakt/Feedback",
                    _routeDeveloperContact),
                _buildDrawerItem(Icons.logout, "Ausloggen", () {
                  AuthenticationFunctions().logout(context);
                }),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 15.0, bottom: 15.0),
                  child: LebenswikiBlueButton(
                    callback: () {
                      Share.share('Hey, check die Lebenswiki App aus!');
                    },
                    text: "Lebenswiki mit Freunden teilen",
                  ),
                ),
                const Divider(),
                Image.network(
                    "https://i.ibb.co/74PBzW8/6207c565b83821547c42e94a-BMFSFJ-gefo-rdert-vom.jpg%22%20alt=%226207c565b83821547c42e94a-BMFSFJ-gefo-rdert-vom"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Image.network(
                    "https://i.ibb.co/Bf24khm/jugendstrategie-logo-aktionsplan-1.png",
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDrawerItem(icon, text, action) {
    return GestureDetector(
      onTap: () => action(),
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

  void _routeProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileView(),
      ),
    );
  }

  void _routeBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookmarkFeed(
          isShort: true,
          isSearching: false,
        ),
      ),
    );
  }

  void _routeYourShorts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YourShorts(),
      ),
    );
  }

  void _routeDeveloperContact() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeveloperInfoView(),
      ),
    );
  }

  void _routeYourCreatorPacks() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const YourCreatorPacks(),
          //builder: (context) => Container(),
        ));
  }
}
