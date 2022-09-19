import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/presentation/widgets/colors.dart';

Widget dialAddButton(context) {
  return SpeedDial(
    iconTheme: const IconThemeData(
      size: 40,
    ),
    backgroundColor: CustomColors.blue,
    direction: SpeedDialDirection.up,
    icon: Icons.add_rounded,
    children: [
      SpeedDialChild(
        label: "Lernpack Erstellen",
        child: const Icon(Icons.comment),
        onTap: () async {
          //TODO complete pack creation
        },
      ),
      SpeedDialChild(
        label: "Short Erstellen",
        child: const Icon(Icons.add),
        onTap: () {
          //TODO Implement create short route
        },
      ),
    ],
  );
}
