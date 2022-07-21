import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/features/routing/routes.dart';
import 'package:lebenswiki_app/features/snackbar/components/custom_flushbar.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
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
          pack.pages.add(PackPage(pageNumber: 0, items: []));
          PackApi().createPack(pack: pack).then((ResultModel result) {
            if (result.type == ResultType.success) {
              pack.id = result.responseItem;
              Navigator.of(context)
                  .push(LebenswikiRoutes.createPackRoute(pack));
            } else {
              CustomFlushbar.error(message: "You aren't a Creator")
                  .show(context);
            }
          });
        },
      ),
      SpeedDialChild(
        label: "Short Erstellen",
        child: const Icon(Icons.add),
        onTap: () =>
            Navigator.of(context).push(LebenswikiRoutes.createShortRoute()),
      ),
    ],
  );
}
