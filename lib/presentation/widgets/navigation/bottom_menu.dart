import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/auth/authentication_functions.dart';

void showBottomMenuForNavigation(
        BuildContext context, WidgetRef ref, Function reload) =>
    showModalBottomSheet(
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
                buildMenuTile(
                  onPress: () async {
                    await Navigator.pushNamed(context, '/profile');
                    reload();
                  },
                  text: "Profil",
                  icon: Icons.person_outline_rounded,
                ),
                buildMenuTile(
                  onPress: () async {
                    await Navigator.pushNamed(context, '/saved');
                    reload();
                  },
                  text: "Gespeichert",
                  icon: Icons.bookmark_outline,
                ),
                buildMenuTile(
                  onPress: () async {
                    await Navigator.pushNamed(context, '/created');
                    reload();
                  },
                  text: "Erstellt",
                  icon: Icons.design_services_outlined,
                ),
                buildMenuTile(
                  onPress: () async {
                    await Navigator.pushNamed(context, '/contact');
                    reload();
                  },
                  text: "Hilfe",
                  icon: Icons.help_outline_rounded,
                ),
                buildMenuTile(
                  onPress: () async {
                    await Navigator.pushNamed(context, '/developer');
                    reload();
                  },
                  text: "Über uns",
                  icon: Icons.phone_outlined,
                ),
                buildMenuTile(
                  onPress: () => Authentication.logout(context, ref),
                  text: "Ausloggen",
                  icon: Icons.logout,
                ),
              ],
            ),
          );
        });

Widget buildMenuTile({
  required String text,
  required IconData icon,
  required Function onPress,
}) =>
    InkWell(
      onTap: () => onPress(),
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
