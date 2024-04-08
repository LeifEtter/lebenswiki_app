import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';
import 'package:lebenswiki_app/application/routing/router.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/register_request_popup.dart';

void showBottomMenuForNavigation(
        BuildContext context, WidgetRef ref, Function reload, User? user) =>
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: user != null ? 400 : 300,
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                user != null
                    ? buildMenuTile(
                        context,
                        ref,
                        onPress: () async {
                          await Navigator.pushNamed(context, profileViewRoute);
                          reload();
                        },
                        text: "Profil",
                        icon: Icons.person_outline_rounded,
                        denyAnonymous: true,
                        user: user,
                      )
                    : Container(),
                user != null
                    ? buildMenuTile(
                        context,
                        ref,
                        onPress: () async {
                          await Navigator.pushNamed(context, savedViewRoute);
                          reload();
                        },
                        text: "Gespeichert",
                        icon: Icons.bookmark_outline,
                        denyAnonymous: true,
                        user: user,
                      )
                    : Container(),
                user != null
                    ? buildMenuTile(
                        context,
                        ref,
                        onPress: () async {
                          await Navigator.pushNamed(context, createdViewRoute);
                          reload();
                        },
                        text: "Erstellt",
                        icon: Icons.design_services_outlined,
                        denyAnonymous: true,
                        user: user,
                      )
                    : buildMenuTile(context, ref,
                        text: "Als Creator Bewerben",
                        icon: Icons.edit, onPress: () async {
                        //TODO Set default contact option to "Bewerbung" on Routing
                        await Navigator.pushNamed(context, contactViewRoute);
                      }),
                buildMenuTile(
                  context,
                  ref,
                  onPress: () async {
                    await Navigator.pushNamed(context, contactViewRoute);
                  },
                  text: "Hilfe/Feedback",
                  icon: Icons.help_outline_rounded,
                ),
                buildMenuTile(
                  context,
                  ref,
                  onPress: () async {
                    await Navigator.pushNamed(context, developerViewRoute);
                  },
                  text: "Über uns",
                  icon: Icons.phone_outlined,
                ),
                buildMenuTile(
                  context,
                  ref,
                  onPress: () async {
                    await TokenHandler().delete();
                    ref.read(userProvider).removeUser();
                    if (context.mounted) {
                      await Navigator.pushNamed(context, authRoute);
                    }
                  },
                  text: user != null ? "Ausloggen" : "Einloggen",
                  icon: Icons.logout,
                ),
              ],
            ),
          );
        });

Widget buildMenuTile(
  BuildContext context,
  WidgetRef ref, {
  required String text,
  required IconData icon,
  required Function onPress,
  bool denyAnonymous = false,
  User? user,
}) =>
    InkWell(
      onTap: () {
        if (denyAnonymous && user == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) => RegisterRequestPopup(ref),
          );
          return;
        }
        onPress();
      },
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
