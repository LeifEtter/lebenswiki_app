import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_screens/contact.dart';
import 'package:lebenswiki_app/features/a_new_screens/profile.dart';
import 'package:lebenswiki_app/features/a_new_screens/saved.dart';
import 'package:lebenswiki_app/features/menu/views/developer_info.dart';
import 'package:lebenswiki_app/providers/providers.dart';

void showBottomMenu(BuildContext context, WidgetRef ref) =>
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
                _buildMenuTile(
                  context,
                  endpoint: ProfileView(user: ref.watch(userProvider).user),
                  text: "Profil",
                  icon: Icons.person_outline_rounded,
                ),
                _buildMenuTile(
                  context,
                  endpoint: const SavedView(),
                  text: "Gespeichert",
                  icon: Icons.bookmark_outline,
                ),
                _buildMenuTile(
                  context,
                  endpoint: const ContactView(),
                  text: "Hilfe",
                  icon: Icons.help_outline_rounded,
                ),
                _buildMenuTile(
                  context,
                  endpoint: const DeveloperInfoView(),
                  text: "Kontakt",
                  icon: Icons.phone_outlined,
                ),
                _buildMenuTile(
                  context,
                  endpoint: ProfileView(user: ref.watch(userProvider).user),
                  text: "Ausloggen",
                  icon: Icons.logout,
                ),
              ],
            ),
          );
        });

//Refactor to new routing
Widget _buildMenuTile(
  BuildContext context, {
  required String text,
  required IconData icon,
  required Widget endpoint,
}) =>
    InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => endpoint,
        ),
      ),
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
