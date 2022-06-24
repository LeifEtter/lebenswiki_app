import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/features/pack_creation/views/editor_settings.dart';
import 'package:lebenswiki_app/features/styling/colors.dart';
import 'package:lebenswiki_app/features/styling/shadows.dart';
import 'package:lebenswiki_app/features/short_creation/views/create_short.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      onPressed: () => Navigator.of(context).push(_createShortRoute()),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          boxShadow: [
            LebenswikiShadows().fancyShadow,
          ],
          borderRadius: BorderRadius.circular(10.0),
          gradient: LebenswikiColors.blueGradient,
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 52.0,
        ),
      ),
    );
  }

  Route _createShortRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CreateShort(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

Widget dialAddButton(context) {
  return SpeedDial(
    backgroundColor: LebenswikiColors.blue,
    direction: SpeedDialDirection.up,
    icon: Icons.add,
    children: [
      SpeedDialChild(
        label: "Lernpack Erstellen",
        child: const Icon(Icons.comment),
        onTap: () async {
          Pack pack = Pack.initial();
          PackApi().createPack(pack: pack).then((ResultModel result) {
            if (result.type == ResultType.success) {
              pack.id = result.responseItem;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorSettings(pack: pack),
                ),
              );
            }
          });
        },
      ),
      SpeedDialChild(
        label: "Short Erstellen",
        child: const Icon(Icons.add),
        onTap: () => Navigator.of(context).push(createShortRoute()),
      ),
    ],
  );
}

Route createShortRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const CreateShort(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
