import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/features/routing/routes.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_information.dart';
import 'package:lebenswiki_app/repository/colors.dart';
import 'package:lebenswiki_app/features/shorts/views/short_creation.dart';

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
          //TODO implement pack cration route again
          /*PackApi().createPack(pack: pack).then((ResultModel result) {
            if (result.type == ResultType.success) {
              pack.id = result.responseItem;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorSettings(pack: pack),
                ),
              );
            }
          });*/
          pack.pages.add(PackPage(pageNumber: 0, items: []));
          Navigator.of(context).push(LebenswikiRoutes.createPackRoute(pack));
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
