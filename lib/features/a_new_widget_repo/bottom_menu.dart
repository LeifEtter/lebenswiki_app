import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/authentication/helpers/authentication_functions.dart';

void showBottomMenuForNavigation(BuildContext context, WidgetRef ref) =>
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
                  onPress: () => Navigator.pushNamed(context, '/profile'),
                  text: "Profil",
                  icon: Icons.person_outline_rounded,
                ),
                buildMenuTile(
                  onPress: () => Navigator.pushNamed(context, '/saved'),
                  text: "Gespeichert",
                  icon: Icons.bookmark_outline,
                ),
                buildMenuTile(
                  onPress: () => Navigator.pushNamed(context, '/contact'),
                  text: "Hilfe",
                  icon: Icons.help_outline_rounded,
                ),
                buildMenuTile(
                  onPress: () => Navigator.pushNamed(context, '/developer'),
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

//Refactor to new routing
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
